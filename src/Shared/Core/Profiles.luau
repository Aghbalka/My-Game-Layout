local Profiles = {}

local PlayerProfiles = {}

local RunService = game:GetService("RunService")

function Profiles:CreateProfile(PlayerId, Structure)
	if RunService:IsClient() then
		return
	end
	PlayerProfiles[PlayerId] = Structure
	return PlayerProfiles[PlayerId]
end

function Profiles:ChangeProfile(PlayerId, NewStructure)
	local CurrentProfile = PlayerProfiles[PlayerId]
	if not CurrentProfile then
		return false, "Profile not found"
	end

	local function CompareStructure(tbl1, tbl2)
		if type(tbl1) ~= "table" or type(tbl2) ~= "table" then
			return false
		end
		for k, v in pairs(tbl1) do
			if type(v) == "table" then
				if type(tbl2[k]) ~= "table" or not CompareStructure(v, tbl2[k]) then
					return false
				end
			else
				if tbl2[k] == nil then
					return false
				end
			end
		end
		for k, _v in pairs(tbl2) do
			if tbl1[k] == nil then
				return false
			end
		end
		return true
	end

	if not CompareStructure(CurrentProfile, NewStructure) then
		return false, "Structure mismatch"
	end

	local function DeepCopy(tbl)
		local copy = {}
		for k, v in pairs(tbl) do
			if type(v) == "table" then
				copy[k] = DeepCopy(v)
			else
				copy[k] = v
			end
		end
		return copy
	end

	if RunService:IsClient() then
		return false, "Client cannot modify profiles"
	end

	PlayerProfiles[PlayerId] = DeepCopy(NewStructure)
	return true
end

function Profiles:ChangeProfileProperty(PlayerId, Path, Value)
	if RunService:IsClient() then
		return
	end

	local ProfileTarget = PlayerProfiles[PlayerId]
	if not ProfileTarget then
		return false, "Profile not found"
	end

	local segments = {}
	for segment in Path:gmatch("[^/]+") do
		table.insert(segments, segment)
	end

	local current = ProfileTarget
	for i = 1, #segments - 1 do
		local key = segments[i]
		if type(current[key]) ~= "table" then
			return false, "Searched value is a table"
		end
		current = current[key]
	end

	local lastKey = segments[#segments]
	current[lastKey] = Value
	return true
end

function Profiles:GetProfile(PlayerId)
	local ProfileTarget = PlayerProfiles[PlayerId]
	if not ProfileTarget then
		return
	end
	return ProfileTarget
end

function Profiles:GetProfileProperty(PlayerId, Path)
	local Profile = PlayerProfiles[PlayerId]
	if not Profile then
		return nil
	end

	local current = Profile
	for segment in Path:gmatch("[^/]+") do
		current = current[segment]
		if current == nil then
			return nil
		end
	end

	return current
end

function Profiles:EraseProfile(PlayerId)
	if RunService:IsClient() then
		return
	end

	PlayerProfiles[PlayerId] = nil
end

return Profiles
