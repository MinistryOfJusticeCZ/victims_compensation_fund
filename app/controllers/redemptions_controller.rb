class RedemptionsController < ApplicationController

  load_and_authorize_resource :claim
  load_and_authorize_resource :redemption, :through => :claim, :shallow => true

  def index
    @schema = RedemptionSchema.new(outputs: ['grid'])
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
    authorize!(:create, Claim) if @redemption.debt.claim.new_record?
    @redemption.author = current_user
    if @redemption.save
      redirect_to @redemption.claim, notice: t('common_labels.notice_saved', model: @redemption.model_name.human)
    else
      render 'new'
    end
  end

  private

    def create_params
      params.require(:redemption).permit(payment_attributes: [:value, :currency_code], debt_attributes: [:claim_id, :offender_id, {claim_attributes: [:court_uid, :file_uid], offender_attributes: [:firstname, :lastname, :birth_date]}])
    end

end
