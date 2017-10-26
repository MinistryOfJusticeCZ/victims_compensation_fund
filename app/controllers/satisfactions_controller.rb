class SatisfactionsController < ApplicationController

  load_and_authorize_resource :appeal
  load_and_authorize_resource :satisfaction, :through => :appeal, :shallow => true

  def index
    @schema = SatisfactionSchema.new(outputs: ['grid'])
    @schema.from_params(params)
    respond_to do |format|
      format.html
      format.json {
        render json: @schema
      }
    end
  end

  def new

  end

  def create
    if @satisfaction.save
      respond_to do |format|
        format.html { redirect_to @satisfaction.appeal }
        format.json { render json: @satisfaction, status: :created }
      end
    else
      respond_to do |format|
        format.html { render 'new', layout: !request.xhr? }
        format.json { render json: { errors: @satisfaction.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private
    def create_params
      params.require(:satisfaction).permit(:appeal_id, payment_attributes: [:value])
    end

end
