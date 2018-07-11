class RedemptionsController < ApplicationController

  load_and_authorize_resource :claim
  load_and_authorize_resource

  def index
    azahara_schema_index do |schema|
      if current_user.has_role?('compensator')
        schema.default_scope ||= 'unprocessed'
      end
    end
  end

  def show
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

  def edit
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

  def destroy
    @redemption.destroy
    respond_to do |format|
      format.html { redirect_to @redemption.debt, notice: t('common_labels.notice_destroyed', model: @redemption.model_name.human) }
      format.json { render json: @redemption }
    end
  end

  private

    def new_params
      create_params
    end

    def create_params
      params.require(:redemption).permit(editable_attributes(Redemption, :create))
    end

    def update_params
      params.require(:redemption).permit(editable_attributes(Redemption, :update))
    end

end
