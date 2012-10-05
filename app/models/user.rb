class User < ActiveRecord::Base
  establish_connection configatron.core_db
end
