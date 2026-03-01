local TestRemotes = {
	Remote = {
		Type = "Event", -- Event or Function
		Track = "ToServer", -- ToClient Or ToServer, Controlls what functions should be ran, Service functions or Reaction functions
	},
	UpdateTest = {
		Type = "Event", -- Event or Function
		Track = "ToClient", -- ToClient Or ToServer, Controlls what functions should be ran, Service functions or Reaction functions
	},
}

return TestRemotes
