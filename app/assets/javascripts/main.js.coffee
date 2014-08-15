# app/assets/javascripts/main.js.coffee

# This line is related to our Angular app, not to our
# HomeCtrl specifically. This is basically how we tell
# Angular about the existence of our application.
@headcount = angular.module('headcount', ['ngRoute','btford.socket-io'])


### 
.
	factory('mySocket', (socketFactory) -> {
	  mySocket = socketFactory()
	  mySocket.forward 'location'
	  mySocket
  })

 
.
  controller('rtCtrl',  (mySocket) -> {
	  mySocket
  })
###
# ,'headcount.rtCtrl'
# This routing directive tells Angular about the default
# route for our application. The term "otherwise" here
# might seem somewhat awkward, but it will make more
# sense as we add more routes to our application.
@headcount.config(['$routeProvider', ($routeProvider) ->
  $routeProvider.
    when('/locations', {
      templateUrl: '../templates/locations/index.html',
      controller: 'LocationIndexCtrl'
    }).
    when('/locations/:id', {
      templateUrl: '../templates/locations/show.html',
      controller: 'LocationShowCtrl'
    }).
    otherwise({
      templateUrl: '../templates/home.html',
      controller: 'HomeCtrl'
    }) 
])
