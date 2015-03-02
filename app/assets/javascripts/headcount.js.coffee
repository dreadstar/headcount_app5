# app/assets/javascripts/main.js.coffee
#= require angular
#= require angular-route
#= require angular-aria
#= require angular-resource
# require angular-bootstrap
#= require angular-animate
#= require angular-material/angular-material
#= require angular-devise/devise
#= require gmaps/google

#= require angular-socket-io
#= require angular-socket-io/socket

# already loaded in application.html.erb
# require lodash

#= require chroma
#= require_self
#= require_tree ./angular



# This line is related to our Angular app, not to our
# HomeCtrl specifically. This is basically how we tell
# Angular about the existence of our application.
angular.module('lodash', [])
  .factory('lodash', ['$window', ($window)->
    return $window._
  ])
angular.module('Gmaps', [])
    .factory('Gmaps', ['$window', ($window)->
        return $window.Gmaps
    ])
angular.module('chroma', [])
  .factory('chroma', ['$window', ($window)->
    _chroma=$window.chroma
    _colorset = []
    _colormap = {}

    _setColors = (colorset) ->
      _colorset=colorset
      _colormap = _chroma.scale(_colorset).mode('lab').correctLightness(false)

    _getColor = (heat) ->
      return _colormap(heat).hex()

    return{
      getHeatColor:_getColor,
      setColors: _setColors,
      chroma: _chroma
    }
  ])
@headcount = angular.module('headcount', ['ngRoute',
'ngResource',
'btford.socket-io',
'ngMaterial',
'ngAria',
'ngAnimate',
'lodash',
'Devise',
'chroma',
'Gmaps'])



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
    })
])
.config(['AuthProvider',(AuthProvider) ->

])
###
@headcount.config(['$resourceProvider',  ($resourceProvider) ->
  $resourceProvider.defaults.stripTrailingSlashes = false
])
###
