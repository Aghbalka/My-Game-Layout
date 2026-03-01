local Services = {}

local LoadedServices = {}

local FullProfileStructure = {}
local RunService = game:GetService("RunService")

function Services:GetService(ServicePrefix)
	if RunService:IsClient() then
		return
	end
	local Service = LoadedServices[ServicePrefix]
	if not Service then
		return false
	end
	return Service
end

function Services:InitializeAllServices()
	if RunService:IsClient() then
		return
	end

	for _, Child in pairs(game.ServerScriptService.Services:GetChildren()) do
		if Child:IsA("ModuleScript") then
			local Service = require(Child)
			local Prefix = Child.Name:gsub("Service$", "")
			LoadedServices[Prefix] = Service
			local Config = require(game.ServerScriptService.Config:FindFirstChild(Prefix .. "Config"))
			Service._Config = Config
			local ReactionEvent = game.ReplicatedStorage.Remotes:FindFirstChild("Update" .. Prefix)
			Service._ReactionEvent = ReactionEvent
			FullProfileStructure[Prefix] = Service.PlayerFolder
		end
	end

	for _, Service in pairs(LoadedServices) do
		if Service.Started then
			return
		else
			Service:Start()
			Service.Started = true
		end
	end

	local Profiles = require(game.ReplicatedStorage.Core.Profiles)
	game:GetService("Players").PlayerAdded:Connect(function(Player)
		Profiles:CreateProfile(Player.UserId, FullProfileStructure)
		for Name, Service in pairs(LoadedServices) do
			local ReactionEvent = Service._ReactionEvent
			if ReactionEvent:IsA("RemoteEvent") then
				ReactionEvent:FireClient(Player, Profiles:GetProfile(Player.UserId)[Name])
			elseif ReactionEvent:IsA("RemoteFunction") then
				ReactionEvent:InvokeClient(Player, Profiles:GetProfile(Player.UserId)[Name])
			end
		end
	end)

	game:GetService("Players").PlayerRemoving:Connect(function(Player)
		Profiles:EraseProfile(Player.UserId)
	end)
end

return Services
