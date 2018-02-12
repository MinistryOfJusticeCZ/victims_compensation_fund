module Api::V1
  class IresBatchController < ApiController

    api :POST, '/ires_batch', 'Receive and handles status of operations made by this application to IRES'
    param :xml_data, String, desc: 'base64 encoded data of the batch message'
    def create
      require 'ires/status_batch'
      batch = Ires::StatusBatch.new(params[:xml_data])

      batch.payment_infos.each do |pi|
        payment = Payment.find_by(uuid: pi.payment_uuid)
        payment.update_column(:status, pi.prescription_status) if payment
      end

      render json: { return: batch.encoded_signed_response }
    end

  end
end
