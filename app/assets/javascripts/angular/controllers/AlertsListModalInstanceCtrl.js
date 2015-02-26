

(function() {
this.headcount.controller('AlertsListModalInstanceCtrl',['scope','$mdDialog', 'alertsList', 'locationsList',
function (scope, $mdDialog, alertsList,locationsList) {
  console.log("alerts modal",alertsList,locationsList);

  // TODO link locations to alerts
  // _.forEach(alertsList, function(alert){
  //   alert.location=_.findOne
  // });

  scope.alerts = alertsList;

  scope.closeAlert = function(index) {
    scope.alerts.splice(index, 1);
  };

  scope.ok = function () {
    $mdDialog.hide();
  };

  scope.cancel = function () {
    $mdDialog.hide();
  };
}]);
}).call(this);
