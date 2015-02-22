

(function() {
this.headcount.controller('LoginModalInstanceCtrl',['$scope','$modalInstance', 'warn',
function ($scope, $modalInstance, warn) {
  console.log("login modal",warn);

  // TODO link locations to alerts
  // _.forEach(alertsList, function(alert){
  //   alert.location=_.findOne
  // });
  $scope.warn = warn;



  $scope.ok = function () {
    $modalInstance.close();
  };

  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };
}]);
}).call(this);
