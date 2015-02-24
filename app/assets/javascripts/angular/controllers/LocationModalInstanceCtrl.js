

(function() {
this.headcount.controller('LocationModalInstanceCtrl',['scope','$mdDialog','chroma', 'loc', function (scope, $mdDialog,chroma, loc) {
  console.log("location modal");
  console.log(loc);

  scope.loc = loc;
  scope.getcolor=chroma.getHeatColor;

  // UserFav = $resource('/api/user_location_favs/:id',{id:'@id'}, {})


  //$scope.heatcolor = $scope.$parent.$parent.getcolor($scope.heat);


  scope.ok = function () {
    $modalInstance.close();
  };

  scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };
}]);
}).call(this);
