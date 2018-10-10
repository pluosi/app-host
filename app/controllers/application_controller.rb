class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  skip_before_action :verify_authenticity_token, :only => [:udid_callback]

  include UserSign


  def udid_callback

    profile_service_response = request.raw_post.to_s

    plistBegin = profile_service_response.index('<?xml version="1.0"')
    plistEnd = profile_service_response.index('</plist>') + 8

    plist = profile_service_response[plistBegin...plistEnd]


    Rails.logger.info "------profile_service_response start----"
    Rails.logger.info profile_service_response
    Rails.logger.info "------profile_service_response end----"
    Rails.logger.info "#{plistBegin} - #{plistEnd}"
    Rails.logger.info "------"
    Rails.logger.info "#{plist}"
    Rails.logger.info "------profile_service_response.data end----"


    profile_service_attributes = CFPropertyList::List.new(:data => plist).value


    udid = profile_service_attributes.value['UDID'].value
    redirect_to "#{Settings.PROTOCOL}#{Settings.HOST}/udid/#{udid}"
  end

  def udid
    @udid = params[:udid]
  end

end