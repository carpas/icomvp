class FileRouter

	@init: =>
		#### Have to wait at least 1 milisecond to start editing the Dom
		setTimeout =>
			fileToShow = @_getFileToShowInfo()
			@publishChangeFileEvent fileToShow

			document.location.onhashchange = =>
				fileToShow = @_getFileToShowInfo()
				@publishChangeFileEvent fileToShow
		, 1


	@publishChangeFileEvent: (fileToShow) =>
		if fileToShow.newFileName
			changeFileEvent = window.pubsubEvents.changeFileWithoutSaving
			PubSub.publish changeFileEvent, fileToShow


	@_getFileToShowInfo: =>
		newFileName = window.location.hash?.split("#")[1]
		newFileCell = $(".file-cell[data-name=#{newFileName}]")[0]
		newContent = newFileCell?.dataset.content
		newFileID = newFileCell?.dataset.id

		{newFileName, newContent, newFileID}

