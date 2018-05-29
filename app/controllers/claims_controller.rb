class ClaimsController < ApplicationController

  load_and_authorize_resource

  def index
    azahara_schema_index
  end

  def show
    @debts_schema = DebtSchema.new(columns: ['offender-person-fullname', 'debt_type', 'value', 'sum:redemptions-payment-value'], outputs: ['grid'])
    @debts_schema.add_filter('claim_id', '=', @claim.id)
    @appeals_schema = AppealSchema.new(columns: ['file_uid', 'victim-fullname', 'payment_type'], outputs: ['grid'])
    @appeals_schema.add_filter('claim_id', '=', @claim.id)
  end

  def new
  end

  def create
    respond_to do |format|
      if @claim.save
        format.html { redirect_to @claim, notice: t('common_labels.notice_saved', model: @claim.model_name.human) }
        format.json { render json: @claim, status: :created }
      else
        format.html { render 'new', layout: !request.xhr? }
        format.json { render json: { errors: @claim.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @claim.update(update_params)
        format.html { redirect_to @claim, notice: t('common_labels.notice_saved', model: @claim.model_name.human) }
        format.json { render json: @claim }
      else
        format.html { render 'edit', layout: !request.xhr? }
        format.json { render json: { errors: @claim.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @claim.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: t('common_labels.notice_destroyed', model: @claim.model_name.human) }
      format.json { render json: @claim }
    end
  end

  private

    def create_params
      params.require(:claim).permit(:court_uid, :file_uid, :binding_effect)
    end

    def update_params
      params.require(:claim).permit(:court_uid, :file_uid, :binding_effect, :assigned_to_id)
    end

end
