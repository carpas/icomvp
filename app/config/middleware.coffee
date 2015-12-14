express = require 'express'
bodyParser = require 'body-parser'


module.exports = (app) =>

	app.use bodyParser.json()
	app.use bodyParser.urlencoded {
		extended: true
	}
	app.use express.static(App.appPath("public/dist"))
	app.use express.Router()
	