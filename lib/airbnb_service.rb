

if Rails.env.production? || Rails.env.staging?
  Airbnb::Service.zookeepers = %w[zk0.sys.airbnb.com:2181 zk1.sys.airbnb.com:2181 zk2.sys.airbnb.com:2181]
else
  Airbnb::Service.zookeepers = %w[localhost:2181]
  # Turn off retries in dev and test
  Airbnb::Service.options = {:retries => 0, :exceptions => []}
end
