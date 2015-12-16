class App

  constructor: ->

  	ICODataServiceLayer.init()
  	FileRouter.init()
  	FileManager.init()
  	DataEvents.init()
  	IcoEditor.init()


window.App = new App()