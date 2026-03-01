local Handlers = {}

function Handlers:HandleAllRemotes()
	-- Will take every remote:
	-- if its a ToServer event then: it runs a Service function after server event
	-- if its a ToServer function then: it runs a Service function after server invoke
	-- if its a ToClient event then: it runs a Reaction function after server event
	-- if its a ToClient function then: it runs a Reaction function after server invoke
	-- ValidateChecks and SchemaChecks the arguments before playing the functions
	-- will play all functions in its local Handlers list

	local RemotesController = require(script.Parent.Remotes)
	local ValidatorsController = require(script.Parent.Validators)
	local SchemasController = require(script.Parent.Schemas)
	local RunService = game:GetService("RunService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")

	for Remote, Object in pairs(RemotesController.ToClient) do
		if not RunService:IsClient() then
			continue
		else
			local Player = game:GetService("Players").LocalPlayer

			if Object:IsA("RemoteEvent") then
				Object.OnClientEvent:Connect(function(...)
					local Prefix = Object:GetAttribute("Domain")
					local RemoteHandler =
						require(ReplicatedStorage.Networking.Handlers:WaitForChild(Prefix .. "Handlers"))
					local Functions = RemoteHandler[Remote]["Functions"]
					local Reaction = require(Player.PlayerScripts.Reaction:WaitForChild(Prefix .. "Reaction"))

					local ValidatorChecked = ValidatorsController:ValidatorCheck(Prefix, Remote, { ... })
					local SchemaChecked = SchemasController:SchemaCheck(Prefix, Remote, { ... })

					if ValidatorChecked and SchemaChecked then
						for _, Func in pairs(Functions) do
							if Reaction[Func] then
								Reaction[Func](...)
							else
								print(Func .. " Function Not Found!")
							end
						end
					end
				end)
			elseif Object:IsA("RemoteFunction") then
				Object.OnClientInvoke = function(...)
					local Prefix = Object:GetAttribute("Domain")
					local RemoteHandler =
						require(ReplicatedStorage.Networking.Handlers:WaitForChild(Prefix .. "Handlers"))
					local Functions = RemoteHandler[Remote]["Functions"]
					local Reaction = require(Player.PlayerScripts.Reaction:WaitForChild(Prefix .. "Reaction"))

					local ValidatorChecked = ValidatorsController:ValidatorCheck(Prefix, Remote, { ... })
					local SchemaChecked = SchemasController:SchemaCheck(Prefix, Remote, { ... })

					if ValidatorChecked and SchemaChecked then
						local result = {}

						for Name, Func in pairs(Functions) do
							if Reaction[Func] then
								result[Name] = Reaction[Func](...)
							else
								print(Func .. " Function Not Found!")
							end
						end

						return result
					end

					return
				end
			end
		end
	end

	for Remote, Object in pairs(RemotesController.ToServer) do
		if not RunService:IsServer() then
			continue
		else
			local ServerScriptService = game:GetService("ServerScriptService")
			local Profiles = require(game.ReplicatedStorage.Core.Profiles)

			if Object:IsA("RemoteEvent") then
				Object.OnServerEvent:Connect(function(Player, ...)
					local Prefix = Object:GetAttribute("Domain")
					local RemoteHandler =
						require(ReplicatedStorage.Networking.Handlers:WaitForChild(Prefix .. "Handlers"))
					local Functions = RemoteHandler[Remote]["Functions"]
					local Service = require(ServerScriptService.Services:WaitForChild(Prefix .. "Service"))

					local ValidatorChecked = ValidatorsController:ValidatorCheck(Prefix, Remote, { ... })
					local SchemaChecked = SchemasController:SchemaCheck(Prefix, Remote, { ... })

					if ValidatorChecked and SchemaChecked then
						for _, Func in pairs(Functions) do
							if Service[Func] then
								Service[Func](Player, ...)
							else
								print(Func .. " Function Not Found!")
							end
						end

						local ReactionEvent = Service._ReactionEvent
						local Prof = Profiles:GetProfileProperty(Player.UserId, Prefix)
						if ReactionEvent:IsA("RemoteEvent") then
							ReactionEvent:FireClient(Player, Prof)
						elseif ReactionEvent:IsA("RemoteFunction") then
							ReactionEvent:InvokeClient(Player, Prof)
						end
					end
				end)
			elseif Object:IsA("RemoteFunction") then
				Object.OnServerInvoke = function(Player, ...)
					local Prefix = Object:GetAttribute("Domain")
					local RemoteHandler =
						require(ReplicatedStorage.Networking.Handlers:WaitForChild(Prefix .. "Handlers"))
					local Functions = RemoteHandler[Remote]["Functions"]
					local Service = require(ServerScriptService.Services:WaitForChild(Prefix .. "Service"))

					local ValidatorChecked = ValidatorsController:ValidatorCheck(Prefix, Remote, { ... })
					local SchemaChecked = SchemasController:SchemaCheck(Prefix, Remote, { ... })

					if ValidatorChecked and SchemaChecked then
						local result = {}

						for Name, Func in pairs(Functions) do
							if Service[Func] then
								result[Name] = Service[Func](Player, ...)
							else
								print(Func .. " Function Not Found!")
							end
						end

						local ReactionEvent = Service._ReactionEvent
						local Prof = Profiles:GetProfileProperty(Player.UserId, Prefix)
						if ReactionEvent:IsA("RemoteEvent") then
							ReactionEvent:FireClient(Player, Prof)
						elseif ReactionEvent:IsA("RemoteFunction") then
							ReactionEvent:InvokeClient(Player, Prof)
						end

						return result
					end
					return
				end
			end
		end
	end
end

return Handlers
