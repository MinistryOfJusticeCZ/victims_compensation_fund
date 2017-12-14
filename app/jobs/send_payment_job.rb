require 'ires/ires'

class SendPaymentJob < ApplicationJob
  queue_as :default

  def perform(organization_code)
    sender = Ires::Sender.new(organization_code)
    sender.send!
  end
end
