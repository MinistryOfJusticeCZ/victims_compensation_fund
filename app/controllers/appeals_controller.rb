class AppealsController < ApplicationController

  load_and_authorize_resource :claim
  load_and_authorize_resource :appeal, :through => :claim, :shallow => true

  def index
    azahara_schema_index
  end

  def show
    @satisfaction_schema = SatisfactionSchema.new(columns: ['payment-value', 'payment-status', 'created_at'], outputs: ['grid'])
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

  def destroy
    @appeal.destroy
    respond_to do |format|
      format.html { redirect_to @appeal.claim, notice: t('common_labels.notice_destroyed', model: @appeal.model_name.human) }
      format.json { render json: @appeal }
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
      params.require(:appeal).permit(editable_attributes(Appeal, :update))
    end

end
