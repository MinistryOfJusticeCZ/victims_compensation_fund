class AppealsController < ApplicationController

  load_and_authorize_resource :claim
  load_and_authorize_resource :appeal, :through => :claim, :shallow => true

  def new
  end

  def create
    if @appeal.save
      redirect_to @appeal.claim
    else
      render 'new'
    end
  end

  private

    def create_params
      params.require(:appeal).permit(:claim_id, :payment_type, :bank_account, :file_uid, claim_attributes: [:court_uid, :file_uid], victim_attributes: [:firstname, :lastname, :birth_date])
    end

end
