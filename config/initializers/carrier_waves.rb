pkg_storage_type = Settings.pkg_storage.type

if pkg_storage_type == :ftp
  ftp = Settings.pkg_storage.ftp
  CarrierWave.configure do |config|
    config.cache_storage = :file
    config.ftp_host = ftp.host
    config.ftp_port = ftp.port
    config.ftp_user = ftp.user
    config.ftp_passwd = ftp.passwd
    config.ftp_url = ftp.url
    config.ftp_folder = ftp.folder
    config.ftp_passive = ftp.passive
    config.ftp_tls = ftp.tls
  end
elsif pkg_storage_type == :sftp
  sftp = Settings.pkg_storage.sftp
  CarrierWave.configure do |config|
    config.cache_storage = :file
    config.sftp_host = sftp.host
    config.sftp_user = sftp.user
    config.sftp_folder = sftp.folder
    config.sftp_url = sftp.url
    config.sftp_options = {
      :password => sftp.passwd,
      :port     => sftp.port
    }
  end
end