(function() {
  this.headcount.controller('myLocationModalInstanceCtrl', ['scope', '$mdDialog',  'myLocation',
    function(scope, $mdDialog, myLocation) {
      console.log("myLocation modal", myLocation);



      scope.locationForm = myLocation;




      scope.ok = function() {
          console.log('pre location check',scope.locationForm);
        // Auth.login(scope.locationForm).then(function(user) {
        //   console.log('location good',user); // => {id: 1, ect: '...'}
        // }, function(error) {
        //   // Authentication failed...
        //   console.log('location bad',error);
        // });
        $mdDialog.hide();
      };

      scope.cancel = function() {
        $mdDialog.hide('cancel');
      };
    }
  ]);
}).call(this);
