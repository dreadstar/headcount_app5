(function() {
  this.headcount.controller('LocationIndexCtrl', [
    '$scope', '$location', '$http', 'socket', 'UserFavorite','LocationAlert', '$modal', function($scope, $location, $http, socket, UserFavorite,LocationAlert, $modal ) {
      var favorites=[];
      var locationAlerts=[];
      $scope.locs = [];
      $scope.locsIndex = [];
      $scope.favorites = [];
      $scope.alerts = [];
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

      // loading data all|fav|pop|hot|cool
      $scope.LoadView = function(view='all'){
        var locqry;
        $scope.view=view;
        console.log('start LoadView '+ view);
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
            console.log("unmatched subscription message");
        }

        $http.get('./locations.json').success(function(data) {
          var i, loc, _i, _len, _ref;
          $scope.locs = data.locations;
          _ref = $scope.locs;
          for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
            loc = _ref[i];
            $scope.locsIndex[$scope.locs[i].id] = i;
            $scope.locs[i].alerts=[];
          }
          console.log($scope.locs);
          console.log($scope.locsIndex);

          favorites = UserFavorite.query(function() {
            var fav, i, _i, _j, _len, _len1;
            console.log(favorites);
            $scope.favorites=favorites;
            for (i = _i = 0, _len = favorites.length; _i < _len; i = ++_i) {
              fav = favorites[i];
              
              $scope.locs[$scope.locsIndex[fav.location_id]].isFavorite = true;
              $scope.locs[$scope.locsIndex[fav.location_id]].favId = fav.id;
            }
            
            console.log($scope.locs);

            locationAlerts = LocationAlert.query(function() {
              var i, _i, _j, _len, _len1;
              console.log(locationAlerts);
              for (i = _i = 0, _len = locationAlerts.length; _i < _len; i = ++_i) {
                alert = locationAlerts[i];
                if (_.findWhere($scope.favorites,{location_id: alert.location_id}) && !_.findWhere($scope.alerts,{alert_id: alert.id})){
                  
                  $scope.alerts.unshift({msg: alert.msg, type:"success", alert_id: alert.id});
                }
                if ($scope.locs[$scope.locsIndex[alert.location_id]]){
                  $scope.locs[$scope.locsIndex[alert.location_id]].alerts.push(alert);
                }
              }
              
              console.log($scope.alerts);
            });

          });

          

        });
      };
      //initial load all default
      $scope.LoadView();

      $scope.closeAlert = function(index) {
        $scope.alerts.splice(index, 1);
      };

      //show the modal for a location
      $scope.showInfo = function (id,size) {
        console.log("opening  modal" );
        console.log(id );
        console.log($scope );
        console.log($scope.locs[$scope.locsIndex[id]]);
        $scope.modalInstance = $modal.open({
          templateUrl: '../templates/modals/locationModalContent.html',
          controller: 'LocationModalInstanceCtrl',
          size: 'sm',
          resolve: {
            loc: function () {
              return $scope.locs[$scope.locsIndex[id]];
            }
          }
        });

        $scope.modalInstance.result.then(function () {
          console.log('Modal success at: ' + new Date());
        }, function () {
          console.log('Modal dismissed at: ' + new Date());
        })['finally'](function(){
          $scope.modalInstance = undefined  // <--- This fixes
        });
      };

      $scope.toggleFavorite = function(id) {
        var fav;
        if ($scope.locs[$scope.locsIndex[id]].isFavorite) {
          console.log('removing fav');
          fav = UserFavorite.get({
            id: $scope.locs[$scope.locsIndex[id]].favId
          }, function() {
            return fav.$delete();
          });
          $scope.locs[$scope.locsIndex[id]].isFavorite = false;
        } else {
          console.log('adding fav');
        
          fav = new UserFavorite();
          fav.location_id = id;
          $scope.locs[$scope.locsIndex[id]].isFavorite = true;
          console.log(fav);
          fav.$save();
          favorites = UserFavorite.query(function() {
            var i, _i, _j, _len, _len1;
            console.log(favorites);
            for (i = _i = 0, _len = favorites.length; _i < _len; i = ++_i) {
              fav = favorites[i];
              $scope.locs[$scope.locsIndex[fav.location_id]].isFavorite = true;
              $scope.locs[$scope.locsIndex[fav.location_id]].favId = fav.id;
            }
            
            console.log($scope.locs);
          });
        }
      };

      socket.on('realtime_msg', function(data) {
        
        switch(data.msg.resource) {
          case "locations":
            console.log("sockio - location");
            $scope.locs[$scope.locsIndex[data.msg.obj.id]].current_state = data.msg.obj.current_state;
            $scope.locs[$scope.locsIndex[data.msg.obj.id]].fanscnt = data.msg.obj.fanscnt;
            break;
          case "alerts":
            console.log("sockio - alerts");
            if (_.findWhere($scope.favorites,{location_id: data.msg.obj.location_id}) ){
              $scope.alerts.unshift({msg: data.msg.obj.msg, type:"success"});
            }
            if ($scope.locs[$scope.locsIndex[data.msg.obj.location_id]]){
              $scope.locs[$scope.locsIndex[data.msg.obj.location_id]].alerts.push(data.msg.obj);
            }
            break;
          default:
            console.log("unmatched subscription message");
        }
        $scope.$apply()
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
