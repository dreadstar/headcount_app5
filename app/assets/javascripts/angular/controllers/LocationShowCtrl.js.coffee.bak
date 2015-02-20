# app/assets/javascripts/angular/controllers/RestaurantShowCtrl.js.coffee

@headcount.controller 'LocationShowCtrl', ['$scope', '$http', '$routeParams', ($scope, $http, $routeParams) ->
  $http.get("./locations/#{$routeParams.id}.json").success((data) ->
    $scope.loc = data
  )
]