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
			changeFileEvent = window.pubsubEvents.changeFile
			PubSub.publish changeFileEvent, fileToShow


	@_getFileToShowInfo: =>
		newFileName = window.location.hash?.split("#")[1]
		newContent = $(".file-cell[data-name=#{newFileName}]")[0]?.dataset.content

		{newFileName, newContent}