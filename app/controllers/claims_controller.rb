class ClaimsController < ApplicationController

  load_and_authorize_resource

  def index
    @schema = ClaimSchema.new(columns: ['file_uid'], outputs: ['grid'])
    @schema.from_params(params)
    respond_to do |format|
      format.html
      format.json {
        render json: @schema.entities
      }
    end
  end

  def show
  end

end
