_G.ClickDetector = true
_G.CollectBobux = true
_G.CollectSupply = true
_G.GhostBobux = true
_G.CollectGrass = true

local clickdetector = Instance.new("ClickDetector", workspace)
local success, error = pcall(function()
    fireclickdetector(clickdetector, 0)
end)
clickdetector:Destroy()

if not success then
    warn("fireclickdetector() is not supported by your exploit. Auto-Clicker will not work.")
end

local function fireClickDetector()
    local clickerPart = Workspace.Clicker.ClickDetector
    while _G.ClickDetector and wait(0.1) do
        fireclickdetector(clickerPart, 0.69420)
    end
end

local function teleportBobux()
    local bobuxFolder = Workspace.BobuxFolder
    local character = game.Players.LocalPlayer.Character
    while _G.CollectBobux and wait(0.1) do
        for _, bobux in ipairs(bobuxFolder:GetChildren()) do
            bobux.CFrame = character.Head.CFrame
            -- firetouchinterest(bobux, bobux.TouchInterest, 0)
        end

        local rareBobux = workspace:FindFirstChild("RareBobux")
        if rareBobux ~= nil then
            rareBobux.CFrame = character.Head.CFrame
            -- firetouchinterest(rareBobux, rareBobux.TouchInterest, 0)
        end

        local rainBobux = workspace:FindFirstChild("RainyBobux")
        if rainBobux ~= nil then
            rainBobux.CFrame = character.Head.CFrame
        end
    end
end

local function enableBobuxSupply()
    local character = game.Players.LocalPlayer.Character
    while _G.CollectSupply and wait(1) do
        local bobuxSupply = workspace:FindFirstChild("BobuxSupply")
        if bobuxSupply then
            fireclickdetector(bobuxSupply.ClickDetector, 2)
            wait(2)

            local LotOfRareRobux = workspace.LotOfRareBobux
            for _, item in ipairs(LotOfRareRobux:GetChildren()) do
                item.CFrame = character.Head.CFrame
            end
            LotOfRareRobux:Destroy()
        end
    end
end

local function collectGhostBux()
    local character = game.Players.LocalPlayer.Character
    while _G.GhostBobux and wait(1) do
        local ghostBobux = workspace:FindFirstChild("GhostBobux")
        if ghostBobux then
            ghostBobux.CFrame = character.Head.CFrame
        end
        -- workspace.GhostBobux
    end
end

local function collectGrassBux()
    local backpack = game.Players.LocalPlayer.Backpack
    local character = game.Players.LocalPlayer.Character
    while _G.CollectGrass and wait(.1) do
        local grassBux = workspace:FindFirstChild("GrassBux")
        local grassAccepter = workspace:FindFirstChild("GrassAccepter")

        if grassBux then
            grassBux.Handle.CFrame = character.Head.CFrame
            -- task.wait(2)
            -- if backpack:FindFirstChild("GrassBux") then
            --     character.Humanoid:EquipTool(backpack.GrassBux)
            --     task.wait(0.5)
            --     character.GrassBux.BuxTouchPart.CFrame = grassAccepter.CFrame
            -- end
        end
    end
end

task.spawn(function()
    fireClickDetector()
end)
task.spawn(function()
    teleportBobux()
end)
task.spawn(function()
    enableBobuxSupply()
end)
task.spawn(function()
    collectGrassBux()
end)
task.spawn(function()
    collectGhostBux()
end)
