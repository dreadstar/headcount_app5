

(function() {
this.headcount.controller('AlertsListModalInstanceCtrl',['$scope','$modalInstance', 'alertslist', function ($scope, $modalInstance, alertsList) {
  console.log("alerts modal",alertsList);

  console.log(this );
  $scope.alerts = alertsList;

  $scope.closeAlert = function(index) {
    $scope.alerts.splice(index, 1);
  };

  $scope.ok = function () {
    $modalInstance.close();
  };

  $scope.cancel = function () {
    $modalInstance.dismiss('cancel');
  };
}]);
}).call(this);
