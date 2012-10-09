require 'csv'

class LocalGuideController < ApplicationController
  
  def index
    @places = []
    @markers = []
    @hostings = []
    @cities = ["San Francisco", "New York", "Seattle"]
  end
  
  def get_data
    @markers = []
    @places = []
    @hostings = []
    @cities = ["San Francisco", "New York"]
    filename = "listings_latlng.csv"
    rows = CSV.read(filename, options = Hash.new)
    rows.each do |row|
      place_hosting_id = row[0].to_i
      category = row[1]
      country = row[2]
      city = row[3]
      lat = row[4]
      lng = row[5]
      color = row[6]
      marker = []
      if city == params[:city]
        @markers << [lat, lng, color, place_hosting_id]
        # hosting /place info
        if category == 'listing'
          hosting = Hosting.find_by_id(place_hosting_id)
          if hosting
            @hostings << hosting
          end
        else
          place = PlaceRecommendation.find(:first, :conditions => ["place_id = ?", place_hosting_id], :include => :place)
          if place
            @places << place
          end
        end
      end
    end 
    puts 'hostings: ' + @hostings.length.to_s
    puts 'places: ' + @places.length.to_s
    render "index.html.erb"
  end
end
