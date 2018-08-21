class DebtsController < ApplicationController

  load_and_authorize_resource :claim
  load_and_authorize_resource :debt, :through => :claim, :shallow => true

  def index
    azahara_schema_index
  end

  def show
    @redemption_schema = RedemptionSchema.new(columns: ['payment-value', 'payment-payment_uid', 'payment-status', 'created_at'], outputs: ['grid'])
    @redemption_schema.add_filter('debt_id', '=', @debt.id)
    @budget_schema = StateBudgetItemSchema.new(columns: ['payment-payment_uid', 'payment-value'], outputs: ['grid'])
    @budget_schema.add_filter('debt_id', '=', @debt.id)
  end

  def new
  end

  def create
    respond_to do |format|
      if @debt.save
        format.html { redirect_to @debt.claim, notice: t('common_labels.notice_saved', model: @debt.model_name.human) }
        format.json { render json: @debt, status: :created }
      else
        format.html { render 'new',  layout: !request.xhr? }
        format.json { render json: { errors: @debt.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @debt.update(update_params)
        format.html { redirect_to @debt, notice: t('common_labels.notice_saved', model: @debt.model_name.human) }
        format.json { render json: @debt }
      else
        format.html { render 'edit', layout: !request.xhr? }
        format.json { render json: { errors: @debt.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @debt.destroy
    respond_to do |format|
      format.html { redirect_to @debt.claim, notice: t('common_labels.notice_destroyed', model: @debt.model_name.human) }
      format.json { render json: @debt }
    end
  end

  private

    def new_params
      create_params
    end

    def update_params
      params.require(:debt).permit(editable_attributes(Debt, :update))
    end

end
