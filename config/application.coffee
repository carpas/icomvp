env = process.env.NODE_ENV || "development"
packageJSON = require '../package.json'
path = require 'path'
express = require 'express'
passport = require 'passport'


console.log "Loading ICO App in #{env} mode."


global.App = {
	app: express()

	Parse: require 'parse/node'

	port: process.env.PORT || 3000

	#### FIXME: Use real user data
	login: {
		username: "123"
		password: "123"
	}

	version: packageJSON.version

	root: path.join __dirname, ".."

	env: env

	secret: "ICO-Webapp-2016-MVP-READFU"

	start: ->
		if !@started
			@started = true
			@.app.listen @port
			console.log "Running ICO version #{@version} on port #{@port} in #{@env} mode."

	appPath: (path) ->
		"#{@root}/#{path}"

	require: (path) ->
		require @appPath(path)

}


#### Set Jade views directory
App.app.set 'views', App.appPath("public/dev")
App.app.set 'view engine', 'jade'
App.app.set 'view options', {pretty: env is 'development'}


#### Init routes
App.require('config/middleware')(App.app)
App.require('config/login')(App.app, passport)
App.require('config/routes')(App.app, passport)


#### Parse initialization code
App.require('config/storage/parseServiceLayer').init(App.Parse)
