local TestValidators = {
	Remote = function(Msg) -- group of conditions in order to validate the data and keep the gameplay safe
		return Msg ~= "F### you" and Msg ~= "F###"
	end,
}

return TestValidators
