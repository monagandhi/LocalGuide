require 'csv'

class LocalGuideController < ApplicationController
  
  def index
    @markers = []
    @cities = ["San Francisco", "New York", "Seattle"]
  end
  
  def get_data
    @markers = []
    @places = []
    @hostings = []
    @cities = ["San Francisco", "New York", "Seattle"]
    filename = "listings_latlng.csv"
    rows = CSV.read(filename, options = Hash.new)
    rows.each do |row|
      marker = []
      place_hosting_id = row[0].to_i
      # hosting /place info
      hosting = Hosting.find_by_id(place_hosting_id)
      if hosting
        name = hosting.name
        city = hosting.city
        link = "https://airbnb.com/rooms/"+ place_hosting_id.to_s
        @hostings << [name, city, link]
      else
        place = PlaceRecommendation.find_by_id(place_hosting_id)
        @places << place
      end
      category = row[1]
      country = row[2]
      city = row[3]
      lat = row[4]
      lng = row[5]
      color = row[6]
      if city == params[:city]
        @markers << [lat, lng, color]
      end
    end
    render "index.html.erb"
  end
end
