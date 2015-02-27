
(function() {
this.headcount
.factory('socket',['$rootScope', function ($rootScope) {
  // var socket = io.connect();
	// var socket = io.connect("http://localhost:5001");
	var socket = window.realtime.socketIo;

	return {
		ready: function(){
			return typeof socket === 'undefined'?false:true;
		},
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

}])
.factory('Locations', ['$resource','$q','$http','lodash',function($resource,$q,$http,_){
	  var _viewList= function(view){
			var deferred = $q.defer();
			var locqry;
			view = typeof view !== 'undefined' ? view : 'all';

			console.log('start LoadView service '+ view);
			switch(view) {
				case "all":
					locqry='./locations.json';
					break;
				case "fav":
					locqry='./locations/fav.json';
					break;
				case "pop":
					locqry='./locations/pop.json';
					break;
				case "hot":
					locqry='./locations/hot.json';
					break;
				case "cool":
					locqry='./locations/cool.json';
					break;
				default:
					console.log("unmatched view",view);
			}

			$http.get(locqry).success(function(data) {

				var locs = data.locations;


				switch(view) {
					case "all":
						locs= _.sortBy(locs,  function(o) { return o.name; });
						break;
					case "fav":
						locs = _.sortBy(locs, function(o) { return o.name; });
						break;
					case "pop":
						locs = _.sortBy(locs,  function(o) { return o.fanscnt; } );
						break;
					case "hot":
						locs = _.sortBy(locs,  function(o) { return  -1 * o.current_state/o.max_cap; });
						break;
					case "cool":
						locs = _.sortBy(locs,  function(o) { return o.current_state/o.max_cap; });
						break;
					default:
						console.log("unmatched subscription message");
				}
				deferred.resolve(locs);
			});
			return deferred.promise;

		};
		var _getById = function(id){
			return $resource('/api/locations/:id',{id:'@id'}, {});
		};
    return {
			viewList: _viewList,
			getById: _getById
		};

  }

]);

}).call(this);
