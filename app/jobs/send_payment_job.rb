require 'ires/ires'

class SendPaymentJob < ApplicationJob
  queue_as :default

  def perform(organization_code)
    sender = Ires::Sender.new
    sender.send_prescription!(organization_code, job_id)
  end
end
