require 'ires/ires'

class SendPaymentJob < ApplicationJob
  queue_as :default

  def perform(payment_id, organization_code)
    sender = Ires::Sender.new
    sender.send_payment_prescription!(Payment.with_deleted.find(payment_id), organization_code, job_id)
  end
end
