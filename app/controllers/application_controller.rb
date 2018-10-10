class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  skip_before_action :verify_authenticity_token, :only => [:udid_callback]

  include UserSign


  def udid_callback

    profile_service_response = OpenSSL::PKCS7.new request.raw_post

    # profile_service_response.verify profile_service_response.certificates, AppleDeviceX509Store, nil, OpenSSL::PKCS7::NOINTERN | OpenSSL::PKCS7::NOCHAIN


    Rails.logger.info "------profile_service_response start----"
    Rails.logger.info profile_service_response
    Rails.logger.info "------profile_service_response end----"
    Rails.logger.info profile_service_response.data
    Rails.logger.info "------profile_service_response.data end----"


    profile_service_attributes = CFPropertyList::List.new(:data => profile_service_response.data).value

    # Rails.logger.info "------udid_callback start----"
    # Rails.logger.info request.raw_post
    # Rails.logger.info "------2----"
    # Rails.logger.info params.inspect
    # Rails.logger.info "------udid_callback end----" 

    File.open("/tmp/ota_helper_#{Time.now.to_i}.mobileconfig", 'wb') do |file|
      file.write(request.raw_post)
    end

    udid = profile_service_attributes.value['UDID'].value
    redirect_to "#{Settings.PROTOCOL}#{Settings.HOST}/udid/#{udid}"
  end

  def udid
    @udid = params[:udid]
  end

end