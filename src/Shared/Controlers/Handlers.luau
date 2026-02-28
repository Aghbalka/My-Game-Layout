local Handlers = {}

function Handlers:HandleAllRemotes()
	-- Will take every remote:
	-- if its a ToServer event then: it runs a Service function after server event
	-- if its a ToServer function then: it runs a Service function after server invoke
	-- if its a ToClient event then: it runs a Reaction function after server event
	-- if its a ToClient function then: it runs a Reaction function after server invoke
	-- ValidateChecks and SchemaChecks the arguments before checking theyre type from the RemotesController
    -- will applicate all functions in its local Handlers list
end

return Handlers
