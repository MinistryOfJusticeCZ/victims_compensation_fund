class PaymentsController < ApplicationController

  load_and_authorize_resource :claim
  load_and_authorize_resource :payment, :through => :claim, :shallow => true

  def index
    @schema = PaymentSchema.new(columns: ['value'], outputs: ['grid'])
    @schema.from_params(params)
    respond_to do |format|
      format.html
      format.json {
        render json: @schema.entities
      }
    end
  end

  def new
  end

  def create
    authorize!(:create, Claim) if @payment.claim.new_record?
    @payment.author = current_user
    if @payment.save
      redirect_to @payment.claim, notice: t(:notice_saved, entity: @payment.model_name.human)
    else
      render 'new'
    end
  end

  private

    def create_params
      params.require(:payment).permit(:value, :claim_id, claim_attributes: [:court_uid, :file_uid], offender_attributes: [:firstname, :lastname, :birth_date])
    end

end