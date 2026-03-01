local TestReaction = {}

function TestReaction:Start() -- This is the start function that plays for the local player on start
	print("Client Started!")
end

function TestReaction.React(Table)
	print(Table)
end

return TestReaction
