require 'csv'

class LocalGuideController < ApplicationController
  
  def index
    @cities = ["San Francisco", "New York", "Seattle"]
  end
  
  def get_data
    @markers = []
    @cities = ["San Francisco", "New York", "Seattle"]
    filename = "listings_latlng.csv"
    rows = CSV.read(filename, options = Hash.new)
    rows.each do |row|
      marker = []
      place_hosting_id = row[0] 
      # hosting /place info
      # is_hosting = Hosting.find_by_id(place_hosting_id)
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
