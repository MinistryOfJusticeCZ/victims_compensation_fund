class StateBudgetItemsController < ApplicationController

  load_and_authorize_resource :debt
  load_and_authorize_resource through: :debt, except: [:index, :show]
  load_and_authorize_resource only: [:index, :show]

  def index
    azahara_schema_index
  end

  def show
    respond_to do |format|
      format.html
      format.pdf {
        send_data generate_approvement_paper(@state_budget_item, params[:input].permit!.to_h), type: :pdf, disposition: 'attachment', filename: "SD_#{@state_budget_item.claim.msp_file_uid}.pdf"
      }
    end
  end

  def new
  end

  def create
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

    def generate_approvement_paper(state_budget_item, input)
      require_dependency 'document_generator/resources/document'
      doc = DocumentGenerator::Document.new(state_budget_item)
      doc.approvement_paper(input)
    end

end
