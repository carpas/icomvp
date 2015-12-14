expressSession = require 'express-session'
LocalStrategy = require('passport-local').Strategy


module.exports = (app, passport) =>

  app.use expressSession({secret: App.secret, resave: false, saveUninitialized: false})
  app.use passport.initialize()
  app.use passport.session()

  passport.serializeUser (user, done) =>
    done null, user.username

  passport.deserializeUser (username, done) =>
    done null, username

  passport.use new LocalStrategy(
    {
      usernameField: 'username'
      passwordField: 'password'
    },
    (username, password, done) =>

      unless username is App.login.username
        return done "Nome de usuário inválido", false

      unless password is App.login.password
        return done "Senha inválida", false

      return done null, {username, password}
  )