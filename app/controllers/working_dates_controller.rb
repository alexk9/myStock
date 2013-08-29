class WorkingDatesController < ApplicationController
  # GET /templates
  # GET /templates.json
  def index
    Rails.logger.info( "Selecting working dates...")
    @working_dates= WorkingDate.all
    Rails.logger.info( "Select completed.")

  end
  def init

    WorkingDate.delete_all

    wdates = []
    Rails.logger.info( "Selecting distinct working dates...")
    Price.select("distinct std_ymd").each do |record|
      a_wdate = WorkingDate.new
      a_wdate.std_ymd= record.std_ymd
      wdates << a_wdate
    end
    Rails.logger.info( "%d dates selected." % wdates.size)

    WorkingDate.import wdates
    Rails.logger.info( "Working dates importing completed.")

    @nWDates = wdates.size
  end
end
