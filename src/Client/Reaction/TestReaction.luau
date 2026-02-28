local TestReaction = {}

TestReaction.Started = false -- so we avoid running the initialize function twice or more

function TestReaction:Start() -- Start function that plays when started
	print("Client Started!")
end

function TestReaction:Update(Msg) -- Update Function that exists in every Reaction Module, gets run by Handlers, Basically Services but client sided
	print(Msg)
end

return TestReaction
