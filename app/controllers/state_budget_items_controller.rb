class StateBudgetItemsController < ApplicationController

  load_and_authorize_resource :debt
  load_and_authorize_resource through: :debt, except: :index
  load_and_authorize_resource only: :index

  def index
    azahara_schema_index
  end

  def show
  end

  def new
  end

  def create
    @state_budget_item.debt ||= @debt
    @state_budget_item.payment = Payment.new(value: @state_budget_item.value, direction: 'outgoing')
    respond_to do |format|
      if @state_budget_item.save
        format.html { redirect_to @debt, notice: t('common_labels.notice_saved', model: @state_budget_item.model_name.human) }
        format.json { render json: @state_budget_item.reload.as_json(include: :payment), status: :created }
      else
        format.html { render 'new', layout: !request.xhr? }
        format.json { render json: { errors: @state_budget_item.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @state_budget_item.update(update_params)
        format.html { redirect_to @state_budget_item.debt, notice: t('common_labels.notice_saved', model: @state_budget_item.model_name.human) }
        format.json { render json: @state_budget_item }
      else
        format.html { render 'edit', layout: !request.xhr? }
        format.json { render json: { errors: @state_budget_item.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @state_budget_item.destroy
    respond_to do |format|
      format.html { redirect_to @state_budget_item.debt, notice: t('common_labels.notice_destroyed', model: @state_budget_item.model_name.human) }
      format.json { render json: @state_budget_item }
    end
  end

  private

    def new_params
      create_params
    end

    def create_params
      params.require(:state_budget_item).permit(editable_attributes(StateBudgetItem, :create))
    end

    def update_params
      params.require(:state_budget_item).permit(editable_attributes(StateBudgetItem, :update))
    end

end
