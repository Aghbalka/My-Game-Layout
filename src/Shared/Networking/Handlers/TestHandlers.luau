local TestHandlers = {
	Remote = {
		Functions = { "Function" }, -- functions to run after the event is fired or invoked, if ToServer then run it from Service and if ToClient then run it from Reaction
	},
	UpdateTest = {
		Functions = { "React" },
	},
}

return TestHandlers
