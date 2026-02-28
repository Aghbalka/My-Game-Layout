local TestHandlers = {
	Remote = {
		Functions = { "Update" }, -- functions to run after the event is fired or invoked, if ToServer then run it from Service and if ToClient then run it from Reaction
	},
}

return TestHandlers
