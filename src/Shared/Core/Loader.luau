local Loader = {}

function Loader:Bootstrap()
	local RunService = game:GetService("RunService")

	local Remotes = require(game.ReplicatedStorage.Controlers.Remotes)
	local Input = require(game.ReplicatedStorage.Controlers.Input)
	local Interface = require(game.ReplicatedStorage.Controlers.Interface)
	local Services = require(game.ReplicatedStorage.Controlers.Services)
	local Reactions = require(game.ReplicatedStorage.Controlers.Reactions)
	local Handlers = require(game.ReplicatedStorage.Controlers.Handlers)

	if RunService:IsServer() then
		Remotes:CreateRemotes()
		Services:InitializeAllServices()
		Handlers:HandleAllRemotes()
	end

	if RunService:IsClient() then
		Remotes:CreateRemotes()
		Input:ActivateInput()
		Interface:ActivateInterface()
		Reactions:InitializeAllReactions()
		Handlers:HandleAllRemotes()
	end
end

return Loader
