local Input = {}

local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local ConnectedInputs = {}

function Input:ActivateInput()
	if RunService:IsServer() then
		return
	end

	local Player = Players.LocalPlayer
	if not Player then
		return
	end

	local Remotes = require(game.ReplicatedStorage.Controlers.Remotes)

	for _, Child in pairs(Player.PlayerScripts.Input:GetChildren()) do
		if Child:IsA("ModuleScript") then
			local InputModule = require(Child)
			local Bindings = InputModule.Bindings or {}

			for _, Bind in pairs(Bindings) do
				local Key = Bind.KeyCode
				local State = Bind.State
				local Type = Bind.Type
				local RemoteEventName = Bind.RemoteEvent
				local Args = Bind.Args or {}

				local RemoteEvent = Remotes:GetRemote(RemoteEventName, "ToServer")
				if not RemoteEvent then
					warn("RemoteEvent not found:", RemoteEventName)
					continue
				end

				local keyId = tostring(Key) .. tostring(State) .. tostring(Type) .. RemoteEventName
				if ConnectedInputs[keyId] then
					continue
				end

				if State == Enum.UserInputState.Begin then
					UIS.InputBegan:Connect(function(input, processed)
						if processed then
							return
						end
						if input.KeyCode == Key and input.UserInputType == Type then
							RemoteEvent:FireServer(table.unpack(Args))
						end
					end)
				end

				if State == Enum.UserInputState.End then
					UIS.InputEnded:Connect(function(input, processed)
						if processed then
							return
						end
						if input.KeyCode == Key and input.UserInputType == Type then
							RemoteEvent:FireServer(table.unpack(Args))
						end
					end)
				end

				ConnectedInputs[keyId] = true
			end
		end
	end
end

return Input
