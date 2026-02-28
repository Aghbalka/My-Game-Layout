local TestInterface = {}

TestInterface.Controls = { -- interface gets defined and configured by the InterfaceController
	{
		Path = "ScreenGui/Interface", -- Path to the object
		EventType = "MouseButton1Up", -- Event that occurs on the object (OP imo)
		RemoteEvent = "Remote", -- The Remote
		Args = { "Pressed!" }, -- Its Arguments
	},
}

return TestInterface
