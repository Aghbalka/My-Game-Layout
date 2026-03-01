local Validators = {}

function Validators:ValidatorCheck(ValidatorPrefix, RemoteName, Args)
	local ValidatorsModule =
		require(game.ReplicatedStorage.Networking.Validators:FindFirstChild(ValidatorPrefix .. "Validators"))
	local Result = ValidatorsModule[RemoteName](table.unpack(Args))
	return Result
end

return Validators
