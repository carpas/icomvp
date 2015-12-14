class Loader

	@loaderSelector: ".loader"


	@turnOn: =>
		$(@loaderSelector).css "display", "block"
		setTimeout =>
			$(@loaderSelector).addClass window.cssClass.isActive
		, 1
		

	@turnOff: =>
		$(@loaderSelector).removeClass window.cssClass.isActive
		setTimeout =>
			$(@loaderSelector).css "display", "none"
		, 200