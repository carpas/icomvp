class App

	constructor: ->
		ICODataServiceLayer.init()
		FileRouter.init()
		FileManager.init()
		DataEvents.init()
		IcoEditor.init()


	@turnOnSaving: =>
		$("#saving-button").addClass window.cssClass.isActive


	@turnOffSaving: =>
		$("#saving-button").removeClass window.cssClass.isActive


window.App = new App()