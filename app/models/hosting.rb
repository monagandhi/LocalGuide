class Hosting < ActiveRecord::Base
  establish_connection configatron.core_db
  self.table_name = 'hostings'

end