class PlacesController < ApplicationController

  def index

  end

  def new
    @place = Place.new
  end
end