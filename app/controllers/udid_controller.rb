class UdidController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:create]
  
  def create
    profile_service_attributes = PkgAdapter::ConfigParser.mobileconfig(request.raw_post)
    udid = profile_service_attributes.value['UDID'].value
    redirect_to "#{Settings.PROTOCOL}#{Settings.HOST}/udid?udid=#{udid}", :status => 301
  end

  def index
    @udid = params[:udid]
  end

  def mobileconfig
    path = Rails.root.join("public/ota_helper.mobileconfig")
    mobileconfig = File.read(path)
    mobileconfig.gsub! '__URL__', "#{Settings.PROTOCOL}#{Settings.HOST}/udid"
    send_data mobileconfig, :filename => "ota_helper.mobileconfig"
  end


end