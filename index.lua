
return function()

	local app = require('.load.app')
 
	local kernel = app:make('http.kernel')

	local response = kernel:handle()

end

