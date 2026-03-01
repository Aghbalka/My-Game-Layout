local Schemas = {}

function Schemas:SchemaCheck(SchemaPrefix, RemoteName, Args)
	local SchemasModule = require(game.ReplicatedStorage.Networking.Schemas:FindFirstChild(SchemaPrefix .. "Schemas"))

	local Schema = SchemasModule[RemoteName]

	if not Schema then
		warn("No schema found for:", RemoteName)
		return false
	end

	if #Args ~= #Schema then
		return false
	end

	for i, expectedType in ipairs(Schema) do
		if typeof(Args[i]) ~= expectedType then
			return false
		end
	end

	return true
end

return Schemas
