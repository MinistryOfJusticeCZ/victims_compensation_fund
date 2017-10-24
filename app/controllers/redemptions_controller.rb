class RedemptionsController < ApplicationController

  load_and_authorize_resource :claim
  load_and_authorize_resource

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
    authorize!(:create, Debt) if @redemption.debt && @redemption.debt.new_record?
    @redemption.author = current_user
    if @redemption.save
      respond_to do |format|
        format.html { redirect_to @redemption.debt.claim, notice: t('common_labels.notice_saved', model: @redemption.model_name.human) }
        format.json { render json: @redemption, status: :created }
      end
    else
      respond_to do |format|
        format.html { render 'new' }
        format.json { render json: { errors: @redemption.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

    def create_params
      params.require(:redemption).permit(:debt_id, payment_attributes: [:value, :currency_code], debt_attributes: [:claim_id, :offender_id, {claim_attributes: [:court_uid, :file_uid], offender_attributes: [:firstname, :lastname, :birth_date]}])
    end

end