module Constants
  ## Constants::NUMでアクセスできる
  DEFAULT_URL_OPTIONS = if Rails.env == "production"
                          'https://oyatsu300.com'
                        else
                          'http://127.0.0.1:3000/'
                        end
end
