class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  skip_before_action :verify_authenticity_token, :only => [:udid_callback]

  include UserSign


  def udid_callback
    Rails.logger.info "------udid_callback start----"
    Rails.logger.info request.raw_post
    Rails.logger.info "------2----"
    Rails.logger.info params.inspect
    Rails.logger.info "------udid_callback end----" 

    udid = "#{request.raw_post}"
    redirect_to "#{Settings.PROTOCOL}#{Settings.HOST}/udid/#{udid}"
  end

  def udid
    @udid = params[:udid]
  end

end