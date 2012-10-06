class Place < ActiveRecord::Base
  establish_connection configatron.core_db

  def approximate_address?
    !self[:api_id]
  end
  
  def formatted_address
    if source == 'Google Places'
      "#{street_number} #{address}"
    else
      address
    end
  end
end