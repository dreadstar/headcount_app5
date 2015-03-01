(function() {

  this.headcount.controller('LocationIndexCtrl', [
    '$scope', '$location',  'socket', 'UserFavorite','LocationAlert', '$mdDialog', 'lodash','Auth','$q','chroma','Locations','$mdSidenav','$mdToast',
    function($scope, $location, socket, UserFavorite,LocationAlert, $mdDialog,_ ,Auth,$q,chroma,Locations, $mdSidenav,$mdToast) {

      var favorites=[];
      var locationAlerts=[];
      $scope.isAuthenticated = Auth.isAuthenticated;

      $scope.locs = [];
      $scope.locsIndex = [];
      $scope.favorites = [];
      $scope.alerts = [];
      $scope.view='all';
      $scope.showMap= false;
      // color setup
      chroma.setColors(['black', 'blue', 'red','yellow']);
      $scope.getcolor=chroma.getHeatColor;
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
      var invisibleAlertLocations=[];
      var myLocation = {};
      myLocation.address = '';
      myLocation.zip = '';
      myLocation.long = '';
      myLocation.lat = '';
      myLocation.ip = '';
    //   $scope.toggleMap = function() {
    //       $mdSidenav('right').toggle();
    //   };

      // loading data all|fav|pop|hot|cool
      var _LoadView = function(view){
        var deferred = $q.defer();
        var locqry;
        // handle when we have logout or login chaining
        view = typeof view == 'string'   ? view : $scope.view;
        $scope.locs=[];
        $scope.locsIndex=[];
        $scope.view=view;
        console.log('start LoadView '+ view);
        Locations.viewList(view)
          .then(function(locs){
            $scope.locs=locs;
            _.map($scope.locs, function(loc,i){
                $scope.locsIndex[$scope.locs[i].id] = i;

                $scope.locs[i].alerts=[];
                return loc;
              });

            console.log($scope.locs);
            console.log($scope.locsIndex);
            deferred.resolve($scope.locs);
          });
        return deferred.promise;
      };

      var _loadAlerts= function(){
        var deferred = $q.defer();
        locationAlerts = LocationAlert.query(function() {
          console.log('_loadAlerts start',locationAlerts);
          _.map(_.filter(locationAlerts,function(alert){ return _.isObject($scope.locs[$scope.locsIndex[alert.location_id]]); }), function(alert){ $scope.locs[$scope.locsIndex[alert.location_id]].alerts.push(alert);
           return alert.location_id; });
          _.map(_.filter(locationAlerts,function(alert){ return _.findWhere($scope.favorites,{location_id: alert.location_id}) && !_.findWhere($scope.alerts,{alert_id: alert.id}); }), function(alert){ $scope.alerts.unshift({msg: alert.msg, type:"success", alert_id: alert.id, location_id: alert.location_id, date_end:alert.date_end, date_start: alert.date_start});
           return alert.id; });

          console.log('_loadAlerts end',$scope.alerts);
          deferred.resolve($scope.alerts);
        });
        return deferred.promise;
      };


      var _updateAlerts = function(){
        var deferred = $q.defer();
        console.log('_updateAlerts start',locationAlerts);
        var filterLocs=_.filter($scope.locs,function(loc){ return _.isObject(_.findWhere(locationAlerts,{location_id: loc.id})); });

        _.map(filterLocs, function(loc){
            var afilter=_.filter(locationAlerts,function(alert){

              return (loc.id===alert.location_id);
            });

            $scope.locs[$scope.locsIndex[loc.id]].alerts=afilter;

           return loc.id;
        });
        deferred.resolve($scope.locs);
        console.log('_updateAlerts end',$scope.locs);
        return deferred.promise;
      };

      var _loadFavorites = function(){
        var deferred = $q.defer();
        if($scope.isAuthenticated()){
          favorites = UserFavorite.query(function() {

            console.log('_loadFavorites start',favorites);
            $scope.favorites=favorites;
            _.map($scope.favorites, function(fav){
              $scope.locs[$scope.locsIndex[fav.location_id]].isFavorite = true;
              $scope.locs[$scope.locsIndex[fav.location_id]].favId = fav.id;
              return fav;
            });


            console.log('_loadFavorites end loggin',$scope.locs);
            deferred.resolve($scope.locs);

          });
          // end favorites query
        }else {
          console.log('_loadFavorites not logged in',$scope.locs);
          deferred.resolve($scope.locs);
        }
        return deferred.promise;
      };

      var _checkAuth= function(){
          console.log('_checkAuth start');
          var deferred = $q.defer();

          Auth.currentUser().then(function(user) {

            $scope.isAuthenticated = Auth.isAuthenticated;
            // User was logged in, or Devise returned
            // previously authenticated session.
            console.log('authenticated',user); // => {id: 1, ect: '...'}
            deferred.resolve($scope.isAuthenticated());

          }, function(error) {

            console.log('not authenticated',error);
            $scope.isAuthenticated = Auth.isAuthenticated;
            deferred.resolve($scope.isAuthenticated());
            // unauthenticated error

          });
          return deferred.promise;
      };

      //initial load all default
      _LoadView().then(_checkAuth).then(_loadFavorites).then(_loadAlerts);

      $scope.LoadView = function(view){
        _LoadView(view).then(_checkAuth).then(_loadFavorites).then(_updateAlerts);
      };



      //show the modal for a location
      $scope.showInfo = function (id,$event) {
        console.log("opening location modal" ,id,$scope.locs[$scope.locsIndex[id]]);
        var parentEl = angular.element(document.body);
        console.log("login modal -parentEl",parentEl,$event );
        var modalInfo = $mdDialog.show({
          title:'<div flex="25"><button type="button"  class="location-heat-lg" style="background-color: {{ getcolor(loc.current_state/loc.max_cap) }}">&nbsp;</button></div><div flex="75">{{loc.name}}</div>',
          parent: parentEl,
          targetEvent: $event,
          templateUrl: '../templates/modals/locationModalContent.html',
          controller: 'LocationModalInstanceCtrl',
          // size: 'md',
          locals: {
            loc:  $scope.locs[$scope.locsIndex[id]]

          }
        })
        ;

        // modalInfo.result.then(function () {
        //   // console.log('Modal info success at: ' + new Date());
        // }, function () {
        //   // console.log('Modal info dismissed at: ' + new Date());
        // })['finally'](function(){
        //   modalInfo = undefined;  // <--- This fixes
        // });
      };

      //show the modal for starred alerts
      $scope.showAlerts = function ($event) {
        console.log("opening alerts modal",$scope.alerts ,$event);
        var parentEl = angular.element(document.body);
        var modalAlerts = $mdDialog.show({
          parent: parentEl,
          targetEvent: $event,
          templateUrl: '../templates/modals/alertsList.html',
          controller: 'AlertsListModalInstanceCtrl',
          // size: 'md',
          locals: {
            alertsList:  $scope.alerts,
            locationsList: $scope.locs
              // TODO should return join of locs and invisibleAlertLocations


          }
        });

        // modalAlerts.result.then(function () {
        //   // console.log('Modal alerts success at: ' + new Date());
        // }, function () {
        //   // console.log('Modal alerts dismissed at: ' + new Date());
        // })['finally'](function(){
        //   modalAlerts = undefined;  // <--- This fixes
        // });
      };
      // end alert modal

      //show the modal for login
      $scope.showLogin =function (warn,$event) {
        console.log("opening login modal",warn );
        var parentEl = angular.element(document.body);

        var modalLogin = $mdDialog.show({
          parent: parentEl,
          targetEvent: $event,
          templateUrl: '../templates/modals/loginModal.html',
          controller: 'LoginModalInstanceCtrl',
          // size: 'md',
          locals: {
            warn:  warn
          }
        });

      };
      // end login modal

      //show the modal for logout
      $scope.showLogout =function ($event) {
        console.log("opening logout modal" );
        var parentEl = angular.element(document.body);
        if ($scope.view =='fav') $scope.view='all';
        $scope.alerts=[];
        Auth.logout()
            .then(_LoadView)
            .then(_loadFavorites)
            .then(_loadAlerts);

        // var modalLogin = $mdDialog.show({
        //   parent: parentEl,
        //   targetEvent: $event,
        //   templateUrl: '../templates/modals/loginModal.html',
        //   controller: 'LoginModalInstanceCtrl',
        //   locals: {
        //     warn:  warn
        //   }
        // });

      };
      // end logout modal

      //show the modal for mylocation
      $scope.setLocation =function ($event) {
        console.log("opening myLocation modal",myLocation );
        var parentEl = angular.element(document.body);

        var modalLogin = $mdDialog.show({
          parent: parentEl,
          targetEvent: $event,
          templateUrl: '../templates/modals/myLocationModal.html',
          controller: 'myLocationModalInstanceCtrl',
          // size: 'md',
          locals: {
            myLocation:  myLocation
          }
        });


      };
      // end mylocation modal

      $scope.toggleFavorite = function(id,$event) {
        if(!$scope.isAuthenticated()){
          $scope.showLogin(true,$event);
          return;
        }
        var fav;
        if ($scope.locs[$scope.locsIndex[id]].isFavorite) {
          console.log('removing fav '+id+ ' obj.favId'+ $scope.locs[$scope.locsIndex[id]].favId);

          console.log($scope.locs[$scope.locsIndex[id]]);
          fav = UserFavorite.get({
            id: $scope.favorites.filter(function(x) { return x.location_id == id; })[0].id
          }, function() {
            console.log('tracking down fav delete error');
            fav.$delete();
          });
          console.log('tracking down fav delete error2');
          $scope.favorites.splice($scope.favorites.filter(function(x) { return x.location_id == id; })[0], 1);
          delete $scope.locs[$scope.locsIndex[id]].isFavorite;
          delete $scope.locs[$scope.locsIndex[id]].favId;
        } else {
          console.log('adding fav');

          fav = new UserFavorite();
          fav.location_id = id;
          $scope.locs[$scope.locsIndex[id]].isFavorite = true;
          console.log(fav);
          fav.$save(function(){
            favorites = UserFavorite.query(function() {

              console.log(favorites);
              $scope.favorites=favorites;
              _.map($scope.favorites, function(fav){
                  console.log('in loop f.loc_id '+fav.location_id+ ' f.id '+fav.id + ' loc.indx '+ $scope.locsIndex[fav.location_id] );
                  $scope.locs[$scope.locsIndex[fav.location_id]].isFavorite = true;
                  $scope.locs[$scope.locsIndex[fav.location_id]].favId = fav.id;
                  console.log($scope.locs[$scope.locsIndex[fav.location_id]]);
                  return fav;
                });


              console.log($scope.locs);
            });

          });

        }
      };

      // authentication stuff
      $scope.$on('devise:login', function(event, currentUser) {
          // TODO toast not appearing
          $mdToast.show($mdToast.simple().content('Logged In!')); _LoadView().then(_checkAuth).then(_loadFavorites).then(_loadAlerts);
      });

      $scope.$on('devise:new-session', function(event, currentUser) {
          _LoadView().then(_checkAuth).then(_loadFavorites).then(_loadAlerts);
      });
      // realtime stuff
      if(socket.ready()){
        socket.on('realtime_msg', function(data) {

          switch(data.msg.resource) {
            case "locations":
              console.log("sockio - location");
              $scope.locs[$scope.locsIndex[data.msg.obj.id]].current_state = data.msg.obj.current_state;
              $scope.locs[$scope.locsIndex[data.msg.obj.id]].fanscnt = data.msg.obj.fanscnt;
              break;
            case "alerts":
              console.log("sockio - alerts alert:loc "+data.msg.obj.location_id);
              locationAlerts.unshift(data.msg.obj);
              console.log($scope.favorites);
              if (_.findWhere($scope.favorites,{location_id: data.msg.obj.location_id}) ){
                console.log('loc is a fav add to scope alerts');
                $scope.alerts.unshift({msg: data.msg.obj.msg, type:"success"});
                // TODO check alert location not in locs then pull to invisibleAlertLocations
                // need a query flow for single location id
              }
              if ($scope.locs[$scope.locsIndex[data.msg.obj.location_id]]){
                $scope.locs[$scope.locsIndex[data.msg.obj.location_id]].alerts.push(data.msg.obj);
              }
              break;
            default:
              console.log("unmatched subscription message");
          }
          // $scope.$apply();
          console.log(data);
        });
        // end of socket - time
      }else{
        console.log('socketio not ready');
      }


    }
  ]);

/* animation of location entires */
angular.module('headcount')
    .animation('.location-entry', function() {
return {
  enter : function(element, done) {
    /* element.css('opacity',0);
    jQuery(element).animate({
      opacity: 1
    }, done);
    */

    // optional onDone or onCancel callback
    // function to handle any post-animation
    // cleanup operations
    return function(isCancelled) {
      if(isCancelled) {
        jQuery(element).stop();
      }
    };
  },
  leave : function(element, done) {
    element.css('opacity', 1);
    jQuery(element).animate({
      opacity: 0
    }, done);

    // optional onDone or onCancel callback
    // function to handle any post-animation
    // cleanup operations
    return function(isCancelled) {
      if(isCancelled) {
        jQuery(element).stop();
      }
    };
  },


  // you can also capture these animation events
  addClass : function(element, className, done) {},
  removeClass : function(element, className, done) {}
};
})
.directive('stopEvent', function () {
    return {
        restrict: 'A',
        link: function (scope, element, attr) {
            element.bind('click', function (e) {
                e.stopPropagation();
            });
        }
    };
 });



}).call(this);
