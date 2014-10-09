(function() {
  this.headcount.controller('LocationIndexCtrl', [
    '$scope', '$location', '$http', 'socket', 'UserFavorite', function($scope, $location, $http, socket, UserFavorite) {
      var favorites;
      $scope.locs = [];
      $scope.locsindex = [];
      $scope.favorites = [];
      $scope.colors = ['black', 'blue', 'red'];
      $scope.search_ranges = [
        {
          val: 0,
          txt: '1 mile'
        }, {
          val: 1,
          txt: '5 miles'
        }, {
          val: 2,
          txt: '10 miles'
        }, {
          val: 3,
          txt: 'all'
        }
      ];
      $scope.myRange = $scope.search_ranges[3];
      $scope.colormap = chroma.scale($scope.colors).mode('lab').correctLightness(false);
      $scope.getcolor = function(heat) {
        return $scope.colormap(heat).hex();
      };
      $http.get('./locations.json').success(function(data) {
        var i, loc, _i, _len, _ref;
        $scope.locs = data.locations;
        _ref = $scope.locs;
        for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
          loc = _ref[i];
          $scope.locsindex[$scope.locs[i].id] = i;
        }
        console.log($scope.locs);
        return console.log($scope.locsindex);
      });
      favorites = UserFavorite.query(function() {
        var fav, i, _i, _j, _len, _len1;
        console.log(favorites);
        for (i = _i = 0, _len = favorites.length; _i < _len; i = ++_i) {
          fav = favorites[i];
          $scope.locs[$scope.locsindex[fav.location_id]].isFavorite = true;
          $scope.locs[$scope.locsindex[fav.location_id]].favId = fav.id;
        }
        
        console.log($scope.locs);
      });
      $scope.toggleFavorite = function(id) {
        var fav;
        if ($scope.locs[$scope.locsindex[id]].isFavorite) {
          console.log('removing fav');
          fav = UserFavorite.get({
            id: $scope.locs[$scope.locsindex[id]].favId
          }, function() {
            return fav.$delete();
          });
          $scope.locs[$scope.locsindex[id]].isFavorite = false;
        } else {
          console.log('adding fav');
        
          fav = new UserFavorite();
          fav.location_id = id;
          $scope.locs[$scope.locsindex[id]].isFavorite = true;
          console.log(fav);
          fav.$save();
          favorites = UserFavorite.query(function() {
            var i, _i, _j, _len, _len1;
            console.log(favorites);
            for (i = _i = 0, _len = favorites.length; _i < _len; i = ++_i) {
              fav = favorites[i];
              $scope.locs[$scope.locsindex[fav.location_id]].isFavorite = true;
            }
            for (i = _j = 0, _len1 = favorites.length; _j < _len1; i = ++_j) {
              fav = favorites[i];
              $scope.locs[$scope.locsindex[fav.location_id]].favId = fav.id;
            }
            console.log($scope.locs);
          });
        }
      };
      socket.on('rt-locations', function(data) {
        $scope.locs[data.msg.obj.id].current_state = data.msg.obj.current_state;
        $scope.locs[data.msg.obj.id].fanscnt = data.msg.obj.fanscnt;
        console.log(data);
      });
    }
  ]);


  /*    
    $scope.viewFavorites = ->
  	  $http.get('./locations/fav.json').success((data) ->
  	    $scope.locs = data
  	  )
  	$scope.viewPopular = ->
  	  $http.get('./locations/pop.json').success((data) ->
  	    $scope.locs = data
  	  )
  	$scope.viewHottest = ->
  	  $http.get('./locations/hot.json').success((data) ->
  	    $scope.locs = data
  	  )
  	$scope.viewCoolest = ->
  	  $http.get('./locations/cool.json').success((data) ->
  	    $scope.locs = data
  	  )
   */

}).call(this);
