class ApplicationController < ActionController::Base
  protect_from_forgery

protected 

  def not_found
    flash[:warning] = 'Sorry, we were unable to find that page.
      Our database has been updated. Please, try to find what you need from here.'
    redirect_to root_url, status: 301
  end
end
