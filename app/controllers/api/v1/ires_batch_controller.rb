module Api::V1
  class IresBatchController < ApiController

    def create
      require 'ires/status_batch'
      batch = Ires::StatusBatch.new(params[:xml_data])
    end

  end
end
