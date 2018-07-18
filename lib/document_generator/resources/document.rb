module DocumentGenerator
  class Document < ::ActiveResource::Base

    self.site = "#{EgovUtils::Settings['ctd_url'] || Rails.configuration.try(:ctd_url)}/api/v1/"
    self.format = EgovUtils::AzaharaJsonResourceFormat


    def self.where(clauses = {})
      raise ArgumentError, "expected a clauses Hash, got #{clauses.inspect}" unless clauses.is_a? Hash
      find(:all, params: {f: clauses})
    end
  end
end
