class DebtsController < ApplicationController

  load_and_authorize_resource :claim
  load_and_authorize_resource :debt, :through => :claim, :shallow => true

  def index
    azahara_schema_index
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

end
