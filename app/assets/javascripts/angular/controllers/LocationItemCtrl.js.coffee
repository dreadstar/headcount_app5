# app/assets/javascripts/angular/controllers/RestaurantIndexCtrl.js.coffee
#= require chroma

@headcount.controller 'LocationItemCtrl', ['$scope', '$location', '$http', ($scope, $location, $http) ->

  $scope.heat = $scope.loc.current_state/$scope.loc.max_cap 

  $scope.heatcolor = $scope.$parent.getcolor $scope.heat
  #eventually add check to make sure heat < 1 or make 1 
  #serverside serializer has catch for zero max_cap

    
 # $scope.viewLocation = (id) ->
 #   $location.url "/locations/#{id}"

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