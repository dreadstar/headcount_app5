(function() {
this.headcount.controller('LocationModalInstanceCtrl',['$scope', 'loc','$scope.$modalInstance', function ($scope, $modalInstance, loc) {
  console.log("location modal");
  console.log(loc);
  console.log($scope );
  console.log(this );
  $scope.loc = loc;

  $scope.heat = $scope.loc.current_state/$scope.loc.max_cap;
  // UserFav = $resource('/api/user_location_favs/:id',{id:'@id'}, {})


  //$scope.heatcolor = $scope.$parent.$parent.getcolor($scope.heat);
  

  $scope.ok = function () {
    $scope.$modalInstance.close();
  };

  $scope.cancel = function () {
    $scope.$modalInstance.dismiss('cancel');
  };
}]);
}).call(this);
