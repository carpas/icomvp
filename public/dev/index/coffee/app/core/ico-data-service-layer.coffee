class ICODataServiceLayer

	uploadButtonSelector: "#upload-button"
	downloadButtonSelector: "#download-button"


	@init: =>
		$(document).on 'click', '#upload-button', @_exportContent
		$(document).on 'click', '#download-button', @_importContent


	@saveFile: (fileInfo) =>
		new Promise (resolve, reject) =>
			App.turnOnSaving()
			url = "/parse/save"
			Ajax.doPost url, fileInfo
			.then (response) =>
				App.turnOffSaving()
				resolve response

			.catch (error) =>
				reject error


	@deleteFile: (fileID) =>
		new Promise (resolve, reject) =>
			url = "parse/destroy"
			Ajax.doPost url, {fileID}
			.then =>
				resolve fileID

			.catch (error) =>
				reject error


	@_getLocalFilesContent: =>
		localFilesContent = []

		$fileManagerContent = $("file-manager .content")

		for file in $fileManagerContent.children()

			{name, content} = file.firstChild.dataset

			localFile = {
				fileName: name
				content
			}

			localFilesContent.push localFile

		localFilesContent


	@_getNewContent: =>
#### FIXME: add real data from backend
#### 'content' is stored as a base64 string.
#### to convert it just run atob('#{content}')
		[
			{
				fileName: "Programação"
				content: 'W3siUHJvZ3JhbWHn428iOltdfV0='
			}
			{
				fileName: "Outros"
				content: 'W3siT3V0cm9zIjpbXX1d'
			}
		]


	@_exportContent: =>
		Loader.turnOn()
		localContent = @_getLocalFilesContent()

		#### FIXME: export localContent to server or file to download
		console.log localContent
		setTimeout =>
			Loader.turnOff()
		, 1000


	@_importContent: =>
		Loader.turnOn()
		newContent = @_getNewContent()

		importContentEvent = window.pubsubEvents.importContent
		PubSub.publish importContentEvent, newContent

