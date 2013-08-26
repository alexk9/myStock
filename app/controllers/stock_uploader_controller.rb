class StockUploaderController < ApplicationController
  def index
    a=1
  end
  def upload
    uploaded_file = params[:stocks_file]
    File.open(Rails.root.join('public', 'uploads', uploaded_file.original_filename), 'wb') do |file|
      file.write(uploaded_file.read)
    end
    wb  = RubyXL::Parser.parse(Rails.root.join('public', 'uploads', uploaded_file.original_filename).to_s)


    @items = []
    wb[0].each { |line|
      if line != nil and line[0]!=nil and line[1] != nil and line[0].value!='법인명' then
        item={}
        item[:name]=line[0].value[4,line[0].value.length-4]
        item[:code]=line[1].value
        item[:market] = line[0].value[1]
        @items << item
      end
    }

    @item_file_name = uploaded_file.original_filename

  end

  def update
    item_file_name = params[:item_file_name]
    @item_file_path =Rails.root.join('public', 'uploads', item_file_name).to_s

    Stock.delete_all

    wb  = RubyXL::Parser.parse(@item_file_path)
    stocks = Array.new
    wb[0].each { |line|
      if line != nil and line[0]!=nil and line[1] != nil and line[0].value!='법인명' then
        s = Stock.new
        s.company_name = line[0].value[4,line[0].value.length-4]
        s.stock_code = line[1].value
        s.market = line[0].value[1]

        stocks << s
      end
    }

    Stock.import stocks
  end
end
