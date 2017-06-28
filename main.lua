
return function(args)
	
	local app = require('.load.app')

	local kernel = app:make('console.kernel')
	
 	local input = app:make('input', args)
 	local output = app:make('output')

 	kernel:handle(input, output)
end

