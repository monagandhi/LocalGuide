class PlaceRecommendation < ActiveRecord::Base
  establish_connection configatron.core_db
  self.table_name = 'place_recommendations'
  
  belongs_to :place
end