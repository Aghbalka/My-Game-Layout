local TestInput = {}

TestInput.Bindings = { -- input gets defined and configured by the InputController
	{
		KeyCode = Enum.KeyCode.E, -- The Key
		State = Enum.UserInputState.Begin, -- The State
		Type = Enum.UserInputType.Keyboard, -- The Type
		RemoteEvent = "Remote", -- The Event
		Args = { "Inputed!" }, -- Its Arguments
	},
}

return TestInput
