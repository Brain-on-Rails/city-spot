class PlacesController < ApplicationController

  def index

  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)

    if @place.save
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end



  private
  def place_params
    params.require(:place).permit(:latitude, :longitude, :name, :description, images: [])
  end
end