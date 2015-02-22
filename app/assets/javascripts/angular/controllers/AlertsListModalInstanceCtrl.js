

(function() {
this.headcount.controller('AlertsListModalInstanceCtrl',['$scope','$modalInstance', 'alertslist', 'locationsList',
function ($scope, $modalInstance, alertsList,locationsList) {
  console.log("alerts modal",alertsList,locationsList);

  // TODO link locations to alerts
  // _.forEach(alertsList, function(alert){
  //   alert.location=_.findOne
  // });
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
