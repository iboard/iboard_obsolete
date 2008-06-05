class LogsController < ApplicationController

  before_filter :authenticate

  def index
    @logs = Log.search(params[:search_txt],params[:page],12)
    if params[:observer] == "1"
       params[:observer] = "0"
       render :layout => false
       return
     end
  end

  def print
    render :index, :layout => 'printview'
  end
  
  def delete_old
    date_to = Date::today()-1.month
    @logs = Log.find(:all,:conditions => [ "created_at < ?", date_to ] ).each { |l|
      l.destroy
    }
  end
  
end
