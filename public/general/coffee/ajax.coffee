class Ajax

	@doPost: (url, data = {}) =>
		@_ajax "POST", url, data


	@doGet: (url, data = {}) =>
		@_ajax "GET", url, data


	@_ajax: (method, url, data) =>
		new Promise (resolve, reject) =>
			$.ajax {
				method
				url
				data: data
				success: (data) =>
					resolve data
				error: (err) =>
					console.log err
					reject err
			}
