module Api::V1
  class IresBatchController < ApiController

    api :POST, '/ires_batch', 'Receive and handles status of operations made by this application to IRES'
    param :xml_data, String, desc: 'base64 encoded data of the batch message'
    def create
      require 'ires/status_batch'
      batch = Ires::StatusBatch.new(params[:xml_data])

      batch.payment_infos.each do |pi|
        payment = Payment.find_by(uuid: pi.payment_uuid)
        if payment
          payment.update_columns(status: pi.prescription_status, paid_at: pi.paid_at)
          if pi.paid? && payment.value < pi.total_paid_amount
            payment.audit_message = "Zaplacena jiná částka, než která byla oznámena."
            payment.update(value: total_paid_amount)
          end
        end
      end

      render json: { return: batch.encoded_signed_response }
    end

  end
end
