local Remotes = {}

Remotes.ToClient = {}
Remotes.ToServer = {}

function Remotes:CreateRemotes()
	local RunService = game:GetService("RunService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local RemoteDefinitions = ReplicatedStorage.Networking.Remotes

	local RemoteFolder = ReplicatedStorage:FindFirstChild("Remotes")
	if not RemoteFolder then
		RemoteFolder = Instance.new("Folder")
		RemoteFolder.Name = "Remotes"
		RemoteFolder.Parent = ReplicatedStorage
	end

	if RunService:IsServer() then
		for _, Child in pairs(RemoteDefinitions:GetChildren()) do
			if Child:IsA("ModuleScript") then
				local Module = require(Child)
				local Prefix = Child.Name:gsub("Remotes$", "")

				for Name, Data in Module do
					local Remote
					if Data.Type == "Event" then
						Remote = Instance.new("RemoteEvent")
					elseif Data.Type == "Function" then
						Remote = Instance.new("RemoteFunction")
					end

					Remote.Name = Name
					Remote:SetAttribute("Domain", Prefix)
					Remote.Parent = RemoteFolder

					if Data.Track == "ToClient" then
						Remotes.ToClient[Name] = Remote
					elseif Data.Track == "ToServer" then
						Remotes.ToServer[Name] = Remote
					end
				end
			end
		end
	end

	if RunService:IsClient() then
		for _, Child in pairs(RemoteDefinitions:GetChildren()) do
			if Child:IsA("ModuleScript") then
				local Module = require(Child)

				for Name, Data in Module do
					if Data.Track == "ToClient" then
						Remotes.ToClient[Name] = ReplicatedStorage.Remotes:WaitForChild(Name)
					elseif Data.Track == "ToServer" then
						Remotes.ToServer[Name] = ReplicatedStorage.Remotes:WaitForChild(Name)
					end
				end
			end
		end
	end
end

function Remotes:GetRemote(RemoteName, Track)
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	if Track == "ToClient" then
		local WantedRemote = Remotes.ToClient[RemoteName]
		if WantedRemote then
			return WantedRemote
		else
			return ReplicatedStorage.Remotes:WaitForChild(RemoteName)
		end
	elseif Track == "ToServer" then
		local WantedRemote = Remotes.ToServer[RemoteName]
		if WantedRemote then
			return WantedRemote
		else
			return ReplicatedStorage.Remotes:WaitForChild(RemoteName)
		end
	else
		print("Enter A Valid Track!")
		return false
	end
end

return Remotes
