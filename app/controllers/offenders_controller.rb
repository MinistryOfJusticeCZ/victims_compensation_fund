class OffendersController < ApplicationController

  def index
    @offenders_schema = OffenderSchema.new
    @offenders_schema.from_params(params)
    respond_to do |format|
      if params['_type'] == 'query'
        format.json{ render json: {
          results: @offenders_schema.entities.collect do |o|
              {id: o.id, text: o.to_s, residence: o.person.residence.to_s}
            end
        }}
      else
        format.json{ render json: @offenders_schema }
      end
    end
  end

end
