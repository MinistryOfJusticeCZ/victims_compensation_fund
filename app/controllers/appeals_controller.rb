class AppealsController < ApplicationController

  load_and_authorize_resource :claim
  load_and_authorize_resource :appeal, :through => :claim, :shallow => true

  def index
    azahara_schema_index
  end

  def show
    @satisfaction_schema = SatisfactionSchema.new(columns: ['payment-value', 'created_at'], outputs: ['grid'])
    @satisfaction_schema.add_filter('appeal_id', '=', @appeal.id)
  end

  def new
  end

  def create
    respond_to do |format|
      if @appeal.save
        format.html { redirect_to @appeal.claim, notice: t('common_labels.notice_saved', model: @appeal.model_name.human) }
        format.json { render json: @appeal, status: :created }
      else
        binding.pry
        format.html { render 'new',  layout: !request.xhr? }
        format.json { render json: { errors: @appeal.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @appeal.update(update_params)
        format.html { redirect_to @appeal.claim, notice: t('common_labels.notice_saved', model: @appeal.model_name.human) }
        format.json { render json: @appeal }
      else
        format.html { render 'edit',  layout: !request.xhr? }
        format.json { render json: { errors: @appeal.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

    def new_params
      create_params
    end

    def create_params
      params.require(:appeal).permit(editable_attributes(Appeal, :create))
    end

    def update_params
      params.require(:appeal).permit(:claim_id, :payment_type, :bank_account, :file_uid, :amount, :victim_id,
        claim_attributes: [:court_uid, :file_uid, :binding_effect],
        victim_attributes: editable_attributes(EgovUtils::Person, :update),
        offender_attributes: [:person_id, person_attributes: editable_attributes(EgovUtils::Person, :update)]
      )
    end

end
