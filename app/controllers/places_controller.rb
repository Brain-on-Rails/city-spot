class PlacesController < ApplicationController

  def index

  end

  def new
    @place = Place.new
    @form_id = view_context.dom_id(@place, :form)
  end

  def create
    @place = Place.new(place_params)
    @form_id = view_context.dom_id(@place, :form)

    if @place.save
      redirect_to root_path
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            @form_id,
          partial: "form_body",
            locals: { place: @place, form_id: @form_id }
          )
        end
      end
    end
  end

  private

  def place_params
    params.require(:place).permit(:latitude, :longitude, :name, :description, images: [])
  end
end