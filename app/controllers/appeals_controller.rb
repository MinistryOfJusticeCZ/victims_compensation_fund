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
    @satisfaction_schema.add_filter('appeal_id', '=', @appeal.id)
  end

  def new
  end

  def create
    if @appeal.save
      respond_to do |format|
        format.html { redirect_to @appeal.claim, notice: t('common_labels.notice_saved', model: @claim.model_name.human) }
        format.json { render json: @appeal, status: :created }
      end
    else
      respond_to do |format|
        format.html { render 'new',  layout: !request.xhr? }
        format.json { render json: { errors: @appeal.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

    def create_params
      params.require(:appeal).permit(:claim_id, :payment_type, :bank_account, :file_uid, :amount, claim_attributes: [:court_uid, :file_uid], victim_attributes: [:firstname, :lastname, :birth_date])
    end

end
