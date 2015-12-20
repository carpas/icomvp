module.exports = {

	_parseKeys: {
		master: "eZ51KYELKdpkbnXBwhU5HLiR23ROwgNslb0fRur3"
		js: "INhHVGn6bzeNtvHleVXRxFgvJQZdVdLkeDGzWxut"
	}


	init: ->
		App.Parse.initialize @_parseKeys.master, @_parseKeys.js


	_getFile: (id) ->
		new Promise (resolve, reject) =>
			File = App.Parse.Object.extend "Files"
			query = new App.Parse.Query File

			query.get id, {
				success: (file) =>
					resolve file

				error: =>
					resolve undefined
			}


	_createNewFile: ->
		File = App.Parse.Object.extend "Files"
		new File()


	getAll: (callback) ->
		File = App.Parse.Object.extend "Files"
		query = new App.Parse.Query(File)
		query.find {
			success: callback
		}


	save: (id, fileInfo) ->
		{fileName, fileContent} = fileInfo

		new Promise (resolve, reject) =>
			@_getFile id
			.then (existingFile) =>
				fileToSave = if existingFile then existingFile else @_createNewFile()
				fileToSave.set "name", fileName
				fileToSave.set "content", fileContent

				fileToSave.save null, {
					success: (file) =>
						console.log "File number #{file.id} saved."
						resolve file.id

					error: (file, error) =>
						console.log "There was an error trying to save file #{file.id}"
						reject error
				}


	destroy: (id) ->
		@_getFile id
		.then (fileToDestroy) =>
			fileToDestroy.destroy {
				success: (file) =>
					console.log "File #{file.id} Deleted."

				error: (file) =>
					console.log "There was an error trying to delete File #{file.id}."
			}
		.catch (error) =>
			console.log error
}

