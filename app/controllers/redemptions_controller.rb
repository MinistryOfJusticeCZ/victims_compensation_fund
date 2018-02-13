class RedemptionsController < ApplicationController

  load_and_authorize_resource :claim
  load_and_authorize_resource

  def index
    azahara_schema_index
  end

  def new
  end

  def create
    authorize!(:create, Debt) if @redemption.debt && @redemption.debt.new_record?
    @redemption.author = current_user
    respond_to do |format|
      if @redemption.save
        format.html { redirect_to @redemption.debt, notice: t('common_labels.notice_saved', model: @redemption.model_name.human) }
        format.json { render json: @redemption.reload.as_json(include: :payment), status: :created }
      else
        format.html { render 'new', layout: !request.xhr? }
        format.json { render json: { errors: @redemption.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @redemption.update(update_params)
        format.html { redirect_to @redemption.debt, notice: t('common_labels.notice_saved', model: @redemption.model_name.human) }
        format.json { render json: @redemption }
      else
        format.html { render 'edit', layout: !request.xhr? }
        format.json { render json: { errors: @redemption.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

    def new_params
      create_params
    end

    def create_params
      params.require(:redemption).permit(:debt_id, payment_attributes: [:value, :currency_code],
        debt_attributes: [:claim_id, :offender_id, :debt_type, :value, {
          claim_attributes: [:court_uid, :file_uid],
          offender_attributes: [:person_id, { person_attributes: [:firstname, :lastname, :birth_date, {residence_attributes: [:street, :house_number, :orientation_number, :city, :postcode, :district, :region]}] }]
        }])
    end

    def update_params
      params.require(:redemption).permit(:debt_id, # payment_attributes: [:value],
        debt_attributes: [:claim_id, :offender_id, :debt_type, :value, {
          claim_attributes: [:court_uid, :file_uid],
          offender_attributes: [:person_id, { person_attributes: [:firstname, :lastname, :birth_date, {residence_attributes: [:street, :house_number, :orientation_number, :city, :postcode, :district, :region]}] }]
        }])
    end

end
