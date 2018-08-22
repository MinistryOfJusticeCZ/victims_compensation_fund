require 'ires/ires'

class SendPaymentJob < ApplicationJob
  queue_as :default

  def perform(payment_id, organization_code=nil)
    sender = Ires::Sender.new
    payment = Payment.with_deleted.find(payment_id)
    # organization_code ||= payment.claim.court_uid
    sender.send_payment_prescription!(payment, job_id)
  end
end
