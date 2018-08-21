class SatisfactionsController < ApplicationController

  load_and_authorize_resource :appeal
  load_and_authorize_resource :satisfaction, :through => :appeal, :shallow => true

  def index
    azahara_schema_index
  end

  def new

  end

  def create
    respond_to do |format|
      @satisfaction.build_payment(value: @satisfaction.fund_transfers.sum{|ft| ft.value}, direction: 'outgoing')
      if @satisfaction.save
        format.html { redirect_to @satisfaction.appeal }
        format.json { render json: @satisfaction, status: :created }
      else
        format.html { render 'new', layout: !request.xhr? }
        format.json { render json: { errors: @satisfaction.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private
    def create_params
      params.require(:satisfaction).permit(:appeal_id, fund_transfers_attributes: [:redemption_id])
    end

end
