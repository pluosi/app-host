class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  skip_before_action :verify_authenticity_token, :only => [:udid_callback]

  include UserSign


  def udid_callback

    profile_service_attributes = PkgAdapter::ConfigParser.mobileconfig(request.raw_post)

    udid = profile_service_attributes.value['UDID'].value
    redirect_to "#{Settings.PROTOCOL}#{Settings.HOST}/udid/#{udid}", :status => 301

  end

  def udid
    @udid = params[:udid]
  end

end