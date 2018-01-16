module Api::V1
  class IresBatchController < ApiController

    api :POST, '/ires_batch', 'Receive and handles status of operations made by this application to IRES'
    param :xml_data, String, desc: 'base64 encoded data of the batch message'
    def create
      require 'ires/status_batch'
      batch = Ires::StatusBatch.new(params[:xml_data])

      render json: { return: "AHOJ SVETE" }
    end

  end
end
