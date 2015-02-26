(function() {
  this.headcount.controller('LoginModalInstanceCtrl', ['scope', '$mdDialog', 'warn', 'Auth',
    function(scope, $mdDialog, warn,Auth) {
      console.log("login modal", warn);

      // TODO link locations to alerts
      // _.forEach(alertsList, function(alert){
      //   alert.location=_.findOne
      // });
      scope.warn = warn;
      scope.loginForm = {};
      scope.loginForm.email = "";
      scope.loginForm.password = "";



      scope.ok = function() {
        Auth.login(scope.loginForm).then(function(user) {
          console.log('login good',user); // => {id: 1, ect: '...'}
        }, function(error) {
          // Authentication failed...
          console.log('login bad',error);
        });
        $mdDialog.hide();
      };

      scope.cancel = function() {
        $mdDialog.hide('cancel');
      };
    }
  ]);
}).call(this);
