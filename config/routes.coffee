module.exports = (app, passport) =>

	isLoggedIn = (req, res, next) =>
		if req.isAuthenticated()
			return next()

		res.redirect '/login'


	app.get "/", isLoggedIn, (req, res) =>
		#### FIXME: Add real data from backend
		res.render 'index/index', {
			files: [
				{
					name: "Programação"
					content: "W3siUHJvZ3JhbWHn428iOltdfV0="
				}
				{
					name: "Outros"
					content: "W3siT3V0cm9zIjpbXX1d"
				}
			]
		}


	app.get "/login", (req, res) =>
		res.render 'login/login', {}


	app.post "/login", passport.authenticate('local',
		{
			successRedirect: '/'
		}
	)