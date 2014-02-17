express = require 'express'

app = express()

app.configure ->
  app.use require('connect-assets')()
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.use express.static __dirname + '/public'

app.get "/", (i,o) ->
  o.render 'index'

port = process.argv[2] || 8765
app.listen port, (err) ->
  if err
    throw err
    process.exit()
  else
    console.log "fmjs is listening on #{port}"