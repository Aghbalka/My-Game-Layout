local Reactions = {}

local LoadedReactions = {}

local RunService = game:GetService("RunService")

function Reactions:GetReaction(ReactionPrefix)
	if RunService:IsServer() then
		return
	end
	local Reaction = LoadedReactions[ReactionPrefix]
	if not Reaction then
		return false
	end
	return Reaction
end

function Reactions:InitializeAllReactions()
	if RunService:IsServer() then
		return
	end

	local Player = game:GetService("Players").LocalPlayer

	for _, Child in pairs(Player:WaitForChild("PlayerScripts"):WaitForChild("Reaction"):GetChildren()) do
		if Child:IsA("ModuleScript") then
			local Reaction = require(Child)
			local Prefix = Child.Name:gsub("Reaction$", "")
			LoadedReactions[Prefix] = Reaction
		end
	end

	for _, Reaction in pairs(LoadedReactions) do
		if Reaction.Started then
			return
		else
			Reaction:Start()
			Reaction.Started = true
		end
	end
end

return Reactions
