class Love < ActiveResource::Base
  self.site = "#{Rails.configuration.love_url}/api/v1/"
end
