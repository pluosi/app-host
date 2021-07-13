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
elsif pkg_storage_type == :fog
  s3 = Settings.pkg_storage.fog
  CarrierWave.configure do |config|
    config.cache_storage = :file                            # uncomment the line :file instead of the default :storage.  Otherwise, it will use AWS as the temp cache store.
    config.fog_credentials = {
      provider:              'AWS',                         # required
      aws_access_key_id:     s3.aws_access_key_id,          # required unless using use_iam_profile
      aws_secret_access_key: s3.aws_secret_access_key,      # required unless using use_iam_profile
      use_iam_profile:       s3.use_iam_profile,            # optional, defaults to false
      region:                s3.region,                     # optional, defaults to 'us-east-1'
      host:                  s3.host,                       # optional, defaults to nil
      endpoint:              s3.endpoint                    # optional, defaults to nil
    }
    config.fog_directory  = s3.fog_directory                # required
    config.fog_public     = s3.fog_public                                 
    config.fog_use_ssl_for_aws = s3.fog_use_ssl_for_aws
    config.fog_attributes = {}                              # optional, defaults to {}
  end
end

