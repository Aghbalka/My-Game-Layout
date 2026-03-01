local Interface = {}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local ConnectedControls = {}

local function getObjectByPath(root, path)
	local current = root
	for segment in path:gmatch("[^/]+") do
		current = current:WaitForChild(segment)
		if not current then
			return nil
		end
	end
	return current
end

function Interface:ActivateInterface()
	if RunService:IsServer() then
		return
	end

	local Player = Players.LocalPlayer
	if not Player then
		return
	end

	local Remotes = require(game.ReplicatedStorage.Controlers.Remotes)

	for _, Child in pairs(Player.PlayerScripts.Interface:GetChildren()) do
		if Child:IsA("ModuleScript") then
			local InterfaceModule = require(Child)
			local Controls = InterfaceModule.Controls or {}

			for _, Control in pairs(Controls) do
				local Path = Control.Path
				local EventType = Control.EventType
				local RemoteEventName = Control.RemoteEvent
				local Args = Control.Args or {}

				local GUIObject = getObjectByPath(Player.PlayerGui, Path)
				if not GUIObject then
					warn("GUI object not found:", Path)
					continue
				end

				local RemoteEvent = Remotes:GetRemote(RemoteEventName, "ToServer")
				if not RemoteEvent then
					warn("RemoteEvent not found:", RemoteEventName)
					continue
				end

				local keyId = Path .. EventType .. RemoteEventName
				if ConnectedControls[keyId] then
					continue
				end

				local event = GUIObject[EventType]
				if typeof(event) == "RBXScriptSignal" then
					event:Connect(function()
						RemoteEvent:FireServer(table.unpack(Args))
					end)
				else
					warn("Event not found on GUI object:", EventType)
				end

				ConnectedControls[keyId] = true
			end
		end
	end
end

return Interface
