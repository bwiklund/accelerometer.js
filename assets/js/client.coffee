app = angular.module 'accelerometer', []


app.factory 'Accelerometer', ($rootScope) ->
  class Accelerometer
    constructor: ->
      window.addEventListener 'devicemotion', (e) =>
        @lastEvent = @event
        @event = e
        # NOTE: this event triggering a digest would not scale well.
        # in a real app, you should handle this as inexpensively as
        # possible, because it gets fired a ton.
        $rootScope.$apply()
        return

  
app.controller 'MainCtrl', ($scope,Accelerometer) ->
  $scope.accelerometer = new Accelerometer()
  $scope.formatAxisValue = (dim) ->
    if dim?
      val = $scope.accelerometer.event.accelerationIncludingGravity[ dim ]
      pretty = val.toFixed 3
      if val >= 0 then pretty = '+' + pretty
      pretty
    else
      "..."