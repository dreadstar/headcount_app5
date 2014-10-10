# app/assets/javascripts/angular/controllers/RestaurantItemCtrl.js.coffee
#= require chroma

@headcount.controller 'LocationItemCtrl', ['$scope', '$location', '$http', 'UserFavorite', ($scope, $location, $http, UserFavorite) ->

	$scope.heat = $scope.loc.current_state/$scope.loc.max_cap
	# UserFav = $resource('/api/user_location_favs/:id',{id:'@id'}, {})


	$scope.loc.heatcolor=$scope.heatcolor = $scope.$parent.getcolor $scope.heat
	#eventually add check to make sure heat < 1 or make 1 
	#serverside serializer has catch for zero max_cap

	window.realtime.socketIo.on('realtime_msg', (data)->
		console.log 'enter item'
		console.log data 
		console.log $scope.loc
		switch data.msg.resource 
			when "locations"
				if data.msg.obj.id is $scope.loc.id 
					$scope.loc.current_state= data.msg.obj.current_state
					$scope.loc.fanscnt= data.msg.obj.fanscnt
					$scope.loc.max_cap= data.msg.obj.max_cap
					$scope.heat = $scope.loc.current_state/$scope.loc.max_cap 
					$scope.heatcolor = $scope.$parent.getcolor $scope.heat
					console.log 'index array value'+$scope.locsIndex[data.msg.obj.id] 
					console.log 'upaded item'
					console.log $scope.loc
					$scope.$apply()
			when "alerts"
				console.log "sockio - alerts"
				if $scope.loc.id is data.msg.obj.location_id
					$scope.loc.alerts.push(data.msg.obj)
					$scope.$apply()

  )
    
 # $scope.viewLocation = (id) ->
 #   $location.url "/locations/#{id}"

#this could be the place for other mfav link etc
]

