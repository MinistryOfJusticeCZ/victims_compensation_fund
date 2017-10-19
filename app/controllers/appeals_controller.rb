class AppealsController < ApplicationController

  load_and_authorize_resource :claim
  load_and_authorize_resource :appeal, :through => :claim, :shallow => true

  def index
    @schema = AppealSchema.new(columns: ['file_uid', 'victim-fullname', 'payment_type'], outputs: ['grid'])
    @schema.from_params(params)
    respond_to do |format|
      format.html
      format.json {
        render json: @schema
      }
    end
  end

  def show
    @satisfaction_schema = SatisfactionSchema.new(columns: ['payment-value', 'created_at'], outputs: ['grid'])
  end

  def new
  end

  def create
    if @appeal.save
      redirect_to @appeal.claim
    else
      render 'new'
    end
  end

  private

    def create_params
      params.require(:appeal).permit(:claim_id, :payment_type, :bank_account, :file_uid, claim_attributes: [:court_uid, :file_uid], victim_attributes: [:firstname, :lastname, :birth_date])
    end

end
