class VictimsController < ApplicationController

  def index
    @victims_schema = VictimSchema.new
    @victims_schema.from_params(params)
    respond_to do |format|
      if params['_type'] == 'query'
        format.json{ render json: {
          results: [{id: '', text: ''}].concat( @victims_schema.entities.collect do |v|
              {id: v.id, text: v.to_s, residence: v.residence.to_s}
            end )
        }}
      else
        format.json{ render json: @victims_schema }
      end
    end
  end

end
