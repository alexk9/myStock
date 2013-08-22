require 'open-uri'

class PriceController < ApplicationController
  def sync
    @stock_code = params[:stock_code]

    url ="http://finance.naver.com/item/sise_day.nhn?code=%s" % @stock_code
    @doc = Nokogiri::HTML(open(url))
    @doc_string = @doc.to_s.encode('utf-8')

    e = @doc.xpath("//a[contains(text(),'맨뒤')]")[0]
    reg = Regexp.new(/page=(?<page>[0-9].*)/)
    m = reg.match(e['href'])

    @page= m['page'].to_i

    #@page=1

    @prices = []
    (1..@page).reverse_each { |idx|
      url = "http://finance.naver.com/item/sise_day.nhn?code=%s&page=%s" % [ @stock_code, idx]
      doc = Nokogiri::HTML(open(url))
      tr  = doc.xpath('/html/body/table/tr[@onmouseover="mouseOver(this)"]')

      tr.each { |line_node|
        if line_node.children[0].text.rstrip == "\u00a0"
          next
        end
        price = Price.new
        price.std_ymd = line_node.children[0].text
        price.end_price = line_node.children[2].text.gsub(",","")
        reg = Regexp.new(/(?<price>[0-9,].*)/)
        if line_node.children == nil
          i=1234
        elsif line_node.children[4].children[1].nil?
          i=2345
        elsif line_node.children[4].children[1]['src'] == nil
          i=4567
        end
        img_url = line_node.children[4].children[1]['src'].to_s if not line_node.children[4].children[1]['src'].nil?
        if not img_url.nil?
          if img_url.index('ico_down.gif') != nil
            price.comp_dir='하락'
          elsif img_url.index('ico_down02.gif') != nil
            price.comp_dir='하한'
          elsif img_url.index('ico_up.gif') != nil
            price.comp_dir='상승'
          elsif img_url.index('ico_up02.gif') != nil
            price.comp_dir='상한'
          end
        end
        m=reg.match(line_node.children[4].text)
        price.comp_last = m['price'].gsub(",","")
        price.start_price =line_node.children[6].text.gsub(",","")
        price.high_price =line_node.children[8].text.gsub(",","")
        price.low_price =line_node.children[10].text.gsub(",","")
        price.amount =line_node.children[12].text.gsub(",","")

        @prices << price

        sleep 0.5
      }

    }
  end
end
