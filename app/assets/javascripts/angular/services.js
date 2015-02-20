
(function() {
this.headcount
.factory('socket',['$rootScope', function ($rootScope) {
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
			});
		}
	};
}])
.factory('UserFavorite', ['$resource',function($resource){          
    return $resource('/api/user_location_favs/:id',{id:'@id'}, {});
                
  }

])
.factory('LocationAlert', ['$resource',function($resource){          
    return $resource('/api/alerts/:id',{id:'@id'}, {});
                
}]);

}).call(this);