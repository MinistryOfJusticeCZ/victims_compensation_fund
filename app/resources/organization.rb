class Organization < Love

  def self.district_courts
    all(params: {f: {category_abbrev: 'OS'}})
  end

end
