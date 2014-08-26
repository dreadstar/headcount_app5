# app/assets/javascripts/angular/controllers/RestaurantIndexCtrl.js.coffee
#= require chroma

@headcount.controller 'LocationIndexCtrl', ['$scope', '$location', '$http','socket', ($scope, $location, $http, socket) ->
#@headcount.controller 'LocationIndexCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->
  $scope.locs = []
  $scope.locsindex = []
  # intimate,cool, hot
  $scope.colors = ['black','blue','red']
  # results radius
  $scope.search_ranges = [{val : 0, txt : '1 mile'},{val : 1, txt :'5 miles'},{val : 2, txt :'10 miles'},{val : 3, txt :'all'}]
  $scope.myRange = $scope.search_ranges[3]
  # colormap for heat
  $scope.colormap = chroma.scale($scope.colors).mode('lab').correctLightness false 
  $scope.getcolor = (heat) ->
    $scope.colormap(heat).hex()
  $http.get('./locations.json').success((data) ->
    $scope.locs = data.locations
    $scope.locsindex[$scope.locs[i].id]= i for loc, i in $scope.locs
    console.log $scope.locsindex 
  )
  # the code to process an update notification
  socket.on('rt-locations',  (data) ->
    $scope.locs[data.msg.obj.id].current_state= data.msg.obj.current_state
    $scope.locs[data.msg.obj.id].fanscnt= data.msg.obj.fanscnt
    console.log data 
  )
  window.realtime.socketIo.on('realtime_msg', (data)->
    console.log data 
    console.log $scope.locs 
    $scope.locs[$scope.locsindex[data.msg.obj.id]].current_state= data.msg.obj.current_state
    $scope.locs[$scope.locsindex[data.msg.obj.id]].fanscnt= data.msg.obj.fanscnt
    console.log 'index array value'+$scope.locsindex[data.msg.obj.id] 
    console.log 'upaded array'
    console.log $scope.locs 
    $rootScope.$apply()
	)
#  $scope.$on "getcolor",  (event, args) ->
#  	$scope.colormap(args.heat).hex()
#  $scope.viewLocation = (id) ->
#    $location.url "/locations/#{id}"

#this could be the place for other mfav link etc
]

###    
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
###