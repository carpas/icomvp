module.exports = (app, passport) =>
	parseServiceLayer = App.require 'config/storage/parseServiceLayer'

	isLoggedIn = (req, res, next) =>
		if req.isAuthenticated()
			return next()

		res.redirect '/login'


	app.get "/", isLoggedIn, (req, res) =>
		parseServiceLayer.getAll (results) =>
			files = []
			for result in results

				files.push {
					id: result.id
					name: result.get "name"
					content: result.get "content"
				}

			res.render 'index/index', {
				files: files
			}


	app.get "/login", (req, res) =>
		res.render 'login/login', {}


	app.post("/login", passport.authenticate('local',
			{
				successRedirect: '/'
			}
		)
	)

	app.get "/logout", isLoggedIn, (req, res) =>
		req.logout()
		res.redirect '/'


	app.post "/parse/save", (req, res) =>
		id = req.body.id
		fileName = req.body.fileName
		fileContent = req.body.fileContent

		parseServiceLayer.save id, {fileName, fileContent}
		.then (id) =>
			res.send "#{id}"


	app.post "/parse/destroy", (req, res) =>
		id = req.body.fileID
		parseServiceLayer.destroy id
		.then =>
			res.send "File Deleted"