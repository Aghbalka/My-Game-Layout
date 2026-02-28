local Loader = {}

-- will contain requiring functions
-- for server: it will run InitializeAllServices, CreateAllRemotes, HandleAllRemotes (ToServer Remotes)
-- for client: it will run InitializeAllReactions, ActivateInput, ActivateInterface, HandleAllRemotes (ToClient Remotes)
-- Validators and schemas will be ran from the Handlers so no wories

function Loader:ClientLoad() end

function Loader:ServerLoad() end

return Loader
