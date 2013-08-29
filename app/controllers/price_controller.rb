require 'open-uri'

class PriceController < ApplicationController

  def calc_highest_match
    stock_code = params[:stock_code]

    @stock,@prices = calc_highest_match_by_stock_code(stock_code)
  end

  def calc_highest_match_all
    stocks = Stock.where("market != '넥'")
    Rails.logger.info( "Total Stock Count: %d" % stocks.size)
    idx = 0
    stocks.each { |a_stock|
      idx=idx+1
      calc_highest_match_by_stock_code( a_stock.stock_code)
      Rails.logger.info( "Stock Code '%s' Complted. ( %d/%d )" % [a_stock.stock_code, idx, stocks.size])
    }
  end

  def sync_all
    stocks = Stock.where("market != '넥' AND stock_code not in ( SELECT distinct stock_code FROM prices)")
    Rails.logger.info( "Total Stock Count: %d" % stocks.size)
    idx = 0
    stocks.each { |a_stock|
      idx=idx+1
      sync_by_stock_code( a_stock.stock_code)
      Rails.logger.info( "Stock Code '%s' Complted. ( %d/%d )" % [a_stock.stock_code, idx, stocks.size])
    }
  end

  def sync
    stock_code = params[:stock_code]
    @prices = sync_by_stock_code(stock_code)

  end

  private
  def sync_by_stock_code(stock_code)
    url ="http://finance.naver.com/item/sise_day.nhn?code=%s" % stock_code
    doc = nil
    success = false
    while success == false
      begin
        doc = Nokogiri::HTML(open(url))
        success = true
      rescue Errno::ETIMEDOUT
        Rails.logger.error("주식 시세 마스터 조회중 에러 발생:%s" % stock_code)
        sleep 1
      end
    end
    doc_string = doc.to_s.encode('utf-8')

    e = doc.xpath("//a[contains(text(),'맨뒤')]")[0]
    reg = Regexp.new(/page=(?<page>[0-9].*)/)
    m = reg.match(e['href'])

    page= m['page'].to_i

    #page=1

    prices = []
    (1..page).each { |idx|
      url = "http://finance.naver.com/item/sise_day.nhn?code=%s&page=%s" % [ stock_code, idx]
      doc = nil
      success = false

      while success == false
        begin
          doc = Nokogiri::HTML(open(url))
          success = true
        rescue Errno::ETIMEDOUT
          Rails.logger.error("연결 에러 발생:%s" % url )
          sleep 1
        end
      end
      tr  = doc.xpath('/html/body/table/tr[@onmouseover="mouseOver(this)"]')

      tr.each { |line_node|
        if line_node.children[0].text.rstrip == "\u00a0"
          next
        end
        a_price = Price.new
        a_price.std_ymd = line_node.children[0].text
        a_price.end_price = line_node.children[2].text.gsub(",","")
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
            a_price.comp_dir='하락'
          elsif img_url.index('ico_down02.gif') != nil
            a_price.comp_dir='하한'
          elsif img_url.index('ico_up.gif') != nil
            a_price.comp_dir='상승'
          elsif img_url.index('ico_up02.gif') != nil
            a_price.comp_dir='상한'
          end
        end
        m=reg.match(line_node.children[4].text)
        a_price.comp_last = m['price'].gsub(",","")
        a_price.stock_code = stock_code
        a_price.start_price =line_node.children[6].text.gsub(",","")
        a_price.high_price =line_node.children[8].text.gsub(",","")
        a_price.low_price =line_node.children[10].text.gsub(",","")
        a_price.amount =line_node.children[12].text.gsub(",","")

        prices << a_price
      }
      Rails.logger.info( "Stock Code: %s, Complete ( %d/%d )" % [stock_code,idx,page])
      sleep 0.1
    }

    Price.where( :stock_code => stock_code).delete_all

    Price.import prices

    return prices
  end

  def calc_highest_match_by_stock_code(stock_code)

    stock = Stock.where({:stock_code=>stock_code})[0]
    prices = Price.joins(:stock).where( stocks:{ stock_code:stock_code}).order("std_ymd asc")

    highest_cnt= 0
    highest_pair_cnt =0
    up_cnt = 0
    up_pair_cnt = 0
    lowest_cnt = 0
    lowest_pair_cnt = 0
    down_cnt =0
    down_pair_cnt =0
    highest_anals = []
    prev_price = nil
    prices.each { |a_price|
      if a_price.comp_dir == '상한'
        highest_cnt = highest_cnt + 1
        up_cnt = up_cnt +1
        if prev_price != nil and prev_price.comp_dir =='상한'
          highest_pair_cnt = highest_pair_cnt +1
          up_pair_cnt = up_pair_cnt +1
          a_ha = HighestAnal.new
          a_ha.stock_code = stock_code
          a_ha.first_date=prev_price.std_ymd
          a_ha.second_date=a_price.std_ymd
          a_ha.stock_code_seq=highest_anals.size+1

          highest_anals << a_ha
        elsif prev_price != nil and prev_price.comp_dir =='상승'
          up_pair_cnt = up_pair_cnt +1
        end
      elsif a_price.comp_dir=='상승'
        up_cnt = up_cnt +1
        if prev_price != nil and  ( prev_price.comp_dir == '상한' or prev_price.comp_dir=='상승')
          up_pair_cnt = up_pair_cnt + 1
        end
      elsif a_price.comp_dir=='하한'
        lowest_cnt = lowest_cnt + 1
        down_cnt = down_cnt +1
        if prev_price != nil and  prev_price.comp_dir =='하한'
          lowest_pair_cnt = lowest_pair_cnt +1
          down_pair_cnt = down_pair_cnt +1
        elsif prev_price != nil and prev_price.comp_dir=='하락'
          down_pair_cnt = down_pair_cnt +1
        end
      elsif a_price.comp_dir=='하락'
        down_cnt = down_cnt +1
        if prev_price != nil and  (prev_price.comp_dir =='하한' or prev_price.comp_dir =='하락')
          down_pair_cnt= down_pair_cnt +1
        end
      else
      end

      prev_price= a_price

    }

    HighestAnalMaster.where( :stock_code => stock_code).delete_all
    a_ham = HighestAnalMaster.new
    a_ham.stock_code=stock_code
    a_ham.highest_cnt=highest_cnt
    a_ham.highest_pair_cnt=highest_anals.size
    a_ham.up_cnt = up_cnt
    a_ham.up_pair_cnt = up_pair_cnt
    a_ham.lowest_cnt = lowest_cnt
    a_ham.lowest_pair_cnt = lowest_pair_cnt
    a_ham.down_cnt = down_cnt
    a_ham.down_pair_cnt = down_pair_cnt

    a_ham.save

    HighestAnal.where( :stock_code => stock_code).delete_all

    HighestAnal.import highest_anals


    return stock, prices
  end
end
