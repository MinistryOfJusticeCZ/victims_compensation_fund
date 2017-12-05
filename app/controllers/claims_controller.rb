class ClaimsController < ApplicationController

  load_and_authorize_resource

  def index
    azahara_schema_index
  end

  def show
    @redemptions_schema = RedemptionSchema.new(columns: ['debt-offender-person-fullname', 'payment-payment_uid', 'payment-value'], outputs: ['grid'])
    @redemptions_schema.add_filter('debt-claim_id', '=', @claim.id)
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

  private

    def create_params
      params.require(:claim).permit(:court_uid, :file_uid)
    end

    def update_params
      params.require(:claim).permit(:court_uid, :file_uid)
    end

end
