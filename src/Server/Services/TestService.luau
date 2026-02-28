local TestService = {}

TestService.Started = false -- so we avoid running the initialize function twice or more
TestService._Config = nil -- easy reference to Config that gets defined by ServicesController
TestService._ReactionEvent = nil -- refers to the reaction event that runs every time a function happens in here

TestService.PlayerFolder = {
	-- folder structure that gets created fore each player if they joined, Gets created inside the Profiles core module, Services Controller will take care of it
}

function TestService:Start() -- Start function that plays when started
	print("Started!")
end

function TestService:Function() -- functions, like literal functions lol, u can add however much amount of functions here, gets ran by Handlers
	print("Function!")
end

return TestService
