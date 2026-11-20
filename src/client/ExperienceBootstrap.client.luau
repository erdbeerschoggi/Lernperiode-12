-- Additive entry point. Both existing Rojo project files already map src/client.
-- All implementation is split into modules under PlayerExperience.
local controller = require(script.Parent:WaitForChild("PlayerExperience"):WaitForChild("Controller"))
local cleanup = controller.start()
if cleanup then script.Destroying:Connect(cleanup) end
