require 'uri'
class Organization < Love

  def self.district_courts
    all(params: {f: {category_abbrev: '=|OS\\KS'}, sort: {'0' => {path: 'category_abbrev'} }})
  end

end
