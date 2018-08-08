require 'activeresource'



module DocumentGenerator
  class Document

    def  self.url(template_id)
      "#{EgovUtils::Settings['ctd_url'] || Rails.configuration.try(:ctd_url)}/api/v1/templates/#{template_id}/documents.json"
    end

    attr_reader :state_budget_item

    def initialize(state_budget_item)
      @state_budget_item = state_budget_item
    end

    def context_data
      {
        "date"=>state_budget_item.created_at.iso8601,
        "file_uid"=> state_budget_item.claim.msp_file_uid,
        "court_file_uid"=> state_budget_item.claim.file_uid,
        "dokladova_rada"=> state_budget_item.payment.budget_category_prefix,
        "payment"=>{
          "payment_uid"=> state_budget_item.payment.payment_uid,
          "due_at"=> [state_budget_item.claim.binding_effect.try(:+, Redemption.boundary_days), Date.today + 5.days].compact.max,
          "amount"=> state_budget_item.payment.value,
          "receiving_subject" => {
            "name"=> "Ministerstvo spravedlnosti ČR",
            "account"=> "19-5120001/0710",
            "ic"=> "00025429"
          },
          "sending_subject"=> {"account"=> "35-5120001/0710"}
        }
      }
    end

    def approvement_paper(input)
      response = HTTParty.post(self.class.url(1), body: {context: context_data, input: input})
      response.body
    end

  end
end
