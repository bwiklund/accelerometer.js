app = angular.module 'accelerometer', []


app.factory 'Accelerometer', ($rootScope,Vec) ->
  class Accelerometer
    constructor: ->
      [ @pos, @vel, @acc ] = ( new Vec 0,0,0 for i in [0...3] )

      vecFromEvent = (e) ->
        acc = e.accelerationIncludingGravity
        new Vec acc.x, acc.y, acc.z

      window.addEventListener 'devicemotion', (e) =>
        @lastEvent = @event
        @event = e
        # NOTE: this event triggering a digest would not scale well.
        # in a real app, you should handle this as inexpensively as
        # possible, because it gets fired a ton.
        dT = if @lastEvent
          (@event.timeStamp - @lastEvent.timeStamp)/1000
        else
          0

        @acc = vecFromEvent e
        @vel.add @acc.get().mult dT
        @pos.add @vel.get().mult dT
        $rootScope.$apply()
        return

  
app.controller 'MainCtrl', ($scope,Accelerometer) ->
  $scope.accelerometer = new Accelerometer()
  $scope.formatAxisValue = (val) ->
    if val?
      pretty = val.toFixed 3
      if val >= 0 then pretty = '+' + pretty
      pretty
    else
      "..."


app.factory 'Vec', ->
  class Vec
    constructor: (@x,@y,@z) ->

    get: ->
      new Vec @x, @y, @z

    mult: (n) ->
      @x *= n
      @y *= n
      @z *= n
      @

    add: (v) ->
      @x += v.x
      @y += v.y
      @z += v.z
      @

    sub: (v) ->
      @x -= v.x
      @y -= v.y
      @z -= v.z
      @

    normalize: ->
      mag = @mag()
      @x/=mag
      @y/=mag
      @z/=mag
      @

    mag: ->
      Math.sqrt @x*@x + @y*@y + @z*@z

    dot: (v) ->
      @x*v.x + @y*v.y + @z*v.z

    cross: (v) ->
      x = @y*v.z - @z*v.y
      y = @z*v.x - @x*v.z
      z = @x*v.y - @y*v.x
      @x = x
      @y = y
      @z = z
      @