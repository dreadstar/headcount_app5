# location = ENV["REDISCLOUD_URL"] || 'redis://127.0.0.1:6379/0'
location = ENV["REDISCLOUD_URL"] || 'redis://192.168.1.2:6379/0'
# powerful-savannah-9626.herokuapp.com
uri = URI.parse(location)
$redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)