local TestService = {}

TestService._Config = nil -- easy reference to Config that gets defined by ServicesController
TestService._ReactionEvent = nil -- refers to the reaction event that runs every time a function happens in here

TestService.PlayerFolder = {
	-- folder structure that gets created fore each player if they joined, Gets created inside the Profiles core module, Services Controller will take care of it
	Points = 10,
}

function TestService:Start() -- Start function that plays when started
	print("Server Started!")
end

function TestService:Function(Msg)
	print(Msg)
end

return TestService
