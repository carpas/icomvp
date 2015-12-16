# @codekit-prepend '../../../bower_components/jquery/dist/jquery.js'
# @codekit-prepend '../../../general/coffee/ajax.coffee'


class Login

  constructor: ->

    errorMessage = decodeURIComponent window.location.search.split("?error=")[1]
    unless errorMessage is "undefined"
      $(".error-msg").html(errorMessage)

    $(document).on "click", "#submitButton", =>

      userValue = $("#userInput")[0].value
      passwordValue = $("#passwordInput")[0].value
      inputs = {username: userValue, password: passwordValue}

      if @_areInputsValid inputs
        @_loginUser inputs, =>
          window.location.replace "/"


  _loginUser: (inputs, callback) =>
    Ajax.doPost "/login", inputs
    .then =>
      callback()
    .catch (err) =>
      newUrl = window.location.origin + window.location.pathname + "?error=#{err.responseText}"
      window.location = newUrl


  _areInputsValid: (inputs) =>
    {username, password} = inputs
    username.length > 0 and password.length > 0



window.login = new Login(0)