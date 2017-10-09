class ClaimsController < ApplicationController

  load_and_authorize_resource

  def index
    @schema = ClaimSchema.new(columns: ['file_uid'], outputs: ['grid'])
    @schema.from_params(params)
    respond_to do |format|
      format.html
      format.json {
        render json: @schema
      }
    end
  end

  def show
    @payments_schema = PaymentSchema.new(columns: ['offender-fullname', 'payment_uid', 'value'], outputs: ['grid'])
    @payments_schema.add_filter('claim_id', '=', @claim.id)
    @appeals_schema = AppealSchema.new(columns: ['file_uid', 'victim-fullname', 'payment_type'], outputs: ['grid'])
    @appeals_schema.add_filter('claim_id', '=', @claim.id)
  end

  def new
  end

  def create
    if @claim.save
      redirect_to @claim, notice: t(:notice_saved, entity: @claim.model_name.human)
    else
      render 'new'
    end
  end

  private

    def create_params
      params.require(:claim).permit(:court_uid, :file_uid)
    end

end
