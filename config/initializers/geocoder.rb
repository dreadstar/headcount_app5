Geocoder.configure(
  # geocoding options
  # :timeout      => 3,           # geocoding service timeout (secs)
  :timeout      => 3,
  # :lookup       => :google,     # name of geocoding service (symbol)
  :lookup       => :google,
  # :language     => :en,         # ISO-639 language code
  # :use_https    => false,       # use HTTPS for lookup requests? (if supported)
  :use_https    => true,
  # :http_proxy   => nil,         # HTTP proxy server (user:pass@host:port)
  # :https_proxy  => nil,         # HTTPS proxy server (user:pass@host:port)
  # :api_key      => nil,         # API key for geocoding service
  #:api_key      => "AIzaSyDQLkWoovT1KL-xfYeMyR-CrQ7QMmWJgXo",
  # :cache        => nil,         # cache object (must respond to #[], #[]=, and #keys)
  # :cache => Redis.new,
  # :cache_prefix => "geocoder:", # prefix (string) to use for all cache keys

  # exceptions that should not be rescued by default
  # (if you want to implement custom error handling);
  # supports SocketError and TimeoutError
  # :always_raise => [],

  # calculation options
  # :units     => :mi,       # :km for kilometers or :mi for miles
  :units     => :mi,
  # :distances => :linear    # :spherical or :linear

)
