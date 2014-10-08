
'use strict'

# Services 
# Demonstrate how to register services
# In this case it is a simple value service.
# angular.module('services', []).
# @headcount.module('services', []).
# factory('socket',  (socketFactory) ->
#   socketFactory()
# ).
# value('version', '0.1')
###
@headcount.factory('socket',  ($rootScope) -> 
  socket = io.connect()
  return {
    on: (eventName, callback) -> 
		  socket.on(eventName,  -> {
        args = arguments
        $rootScope.$apply(  -> 
          callback.apply socket, args
        )
      })
    
    emit:  (eventName, data, callback) -> 
      socket.emit(eventName, data,   -> {
        args = arguments
        $rootScope.$apply  -> 
          if callback then callback.apply(socket, args)
      })
  }
)
###
`headcount.factory('socket', function ($rootScope) {
  // var socket = io.connect();
	// var socket = io.connect("http://localhost:5001");
	var socket = window.realtime.socketIo;
	return {
		on: function (eventName, callback) {
			socket.on(eventName, function () {
				var args = arguments;
			  $rootScope.$apply(function () {
			    callback.apply(socket, args);
			  });
			});
		},
		emit: function (eventName, data, callback) {
			socket.emit(eventName, data, function () {
				var args = arguments;
				$rootScope.$apply(function () {
					if (callback) {
						callback.apply(socket, args);
					}
				});
			})
		}
	};
}).factory('UserFavorite', function($resource){          
    return $resource('/api/user_location_favs/:id',{id:'@id'}, {});
                
  }

);`
