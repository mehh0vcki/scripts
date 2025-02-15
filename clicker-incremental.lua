-- variables 
local ClickDetectorMain =false
local ClickDetectorGold =false

local CollectDefaultBobux = false
local CollectRareBobux =    false
local CollectRainyBobux =   false
local CollectGhostBobux =   false
local CollectGoldenBobux =  false
local CollectBobuxSupply =  false

local CollectGrass = false
local SellGrass = false

local AutoBobuxExchange =false
local ChoosenUpgradeMain =  ""
local ChoosenUpgradeGrass = ""
local ChoosenUpgradeGolden =""

local AutoclickColor = false
local ChoosenColor = ""
local ChoosenPoint = ""

-- required
local player = game.Players.LocalPlayer
local function teleportStuff(part)
    -- making this function so i don't write anchor + collision every time. makes script more readable, but make me get called gpt user 😨😨
    part.CFrame = player.Character.Head.CFrame
    part.Anchored = true
    part.CanCollide = false
end

-- checks
local clickDetector = Instance.new("ClickDetector", workspace)
local CDSuccess, error = pcall(function()
    fireclickdetector(clickDetector, math.random(1, 3))
end)
clickDetector:Destroy()

local DiscordUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/mehh0vcki/scripts/refs/heads/main/static/library.lua"))("script by mehhovcki :3")
local UIWindow = DiscordUI:Window("mehhovcki' script™ | Discord UI Library")
local MainTab = UIWindow:Server("[7.5] Clicker Incremental", "rbxassetid://16742508014")
local MainChannel = MainTab:Channel("Main")

if not CDSuccess then
    DiscordUI:Notification(
        "Error",
        "Tests showed us, that fireclickdetector() may not work for your exploit.",
        "Ok!"
    )
end
MainChannel:Label("= Autoclickers = ")
MainChannel:Toggle(
    "Default Bobux Autoclick",
    false,
    function(bool)
        local Bobux = workspace:FindFirstChild("Clicker")
        ClickDetectorMain = bool
       
        while ClickDetectorMain and wait(0.1) do
            fireclickdetector(Bobux.ClickDetector, math.random(1, 3))
        end
    end
)

MainChannel:Toggle(
    "Golden Bobux Autoclick",
    false,
    function(bool)
        local GoldenBobux = workspace:FindFirstChild("GBobuxClicker")
        ClickDetectorGold = bool
        
        while ClickDetectorGold and wait(0.1) do
            fireclickdetector(GoldenBobux.ClickDetector, math.random(1, 3))
        end
    end
)

MainChannel:Label("= Exchange =")
MainChannel:Button(
    "Buy 1 Golden Bobux (2,000B/1GB)",
    function()
        local buyGoldenBobux = workspace:FindFirstChild("BuyGoldenBobux")
        local buyOne = buyGoldenBobux.Button1
        fireclickdetector(buyOne.ClickDetector, math.random(1, 3))
    end
)

MainChannel:Button(
    "Buy 5 Golden Bobux (10,000B/5GB)",
    function()
        local buyGoldenBobux = workspace:FindFirstChild("BuyGoldenBobux")
        local buyFive = buyGoldenBobux.Button2
        fireclickdetector(buyFive.ClickDetector, math.random(1, 3))
    end
)

MainChannel:Label("= Grass Level =")
MainChannel:Toggle(
    "Collect Grass",
    false,
    function(bool)
        CollectGrass = bool
        while CollectGrass and wait(0.1) do
            local grass = workspace:FindFirstChild("GrassBux")
            if grass then
                teleportStuff(grass.Handle)
            end
        end
    end
)

MainChannel:Toggle(
    "Auto Sell Grass",
    false,
    function(bool)
        SellGrass = bool
        while SellGrass and wait(2) do
            local Character = player.Character
            if Character then
                local grass = Character:FindFirstChild("GrassBux")
                if grass then
                    Character.Humanoid:EquipTool(grass)
                    task.wait(.2)
                    firetouchinterest(
                        grass.BuxTouchPart,
                        workspace.GrassAccepter,
                        0
                    )
                end
            end
        end
    end
)
--[[
_G.abc = true

while _G.abc and task.wait(.1) do
    firetouchinterest(
        game.Players.LocalPlayer.Character.GrassBux.BuxTouchPart,
        workspace.GrassAccepter,
        0
    )
    -- game.Players.LocalPlayer.Character.GrassBux.Handle.CFrame = workspace.GrassAccepter.CFrame
    -- print(game.Players.LocalPlayer.Character.GrassBux.Handle.CFrame)
end
]]

local ToggleChannels = MainTab:Channel("Toggles")
ToggleChannels:Label("= Collectables/Clickable = ")
ToggleChannels:Toggle(
    "Collect Bobux",
    false,
    function(bool)
        CollectDefaultBobux = bool
        local bobuxFolder = workspace:FindFirstChild("BobuxFolder")
        if bobuxFolder then
            while CollectDefaultBobux and wait(0.1) do
                for _, bobux in ipairs(bobuxFolder:GetChildren()) do
                    teleportStuff(bobux)
                end
            end
        end
    end
)

ToggleChannels:Toggle(
    "Collect Rare Bobux",
    false,
    function(bool)
        CollectRareBobux = bool
        while CollectRareBobux and wait(0.1) do
            local rareBobux = workspace:FindFirstChild("RareBobux")
            if rareBobux then
                teleportStuff(rareBobux)
            end

            local RareBobuxColor = workspace:FindFirstChild("RareBobuxColor")
            if RareBobuxColor then
                teleportStuff(RareBobuxColor)
            end
        end
    end
)

ToggleChannels:Toggle(
    "Collect Gold Bobux",
    false,
    function(bool)
        CollectGoldenBobux = bool
        while CollectGoldenBobux and wait(.1) do
           local goldenBobux = workspace:FindFirstChild("GoldenBobux")
            if goldenBobux then
                teleportStuff(goldenBobux)
            end
        end
    end
)

ToggleChannels:Label("= Collectables/Spawnable =")
ToggleChannels:Toggle(
    "Collect Rainy Bobux",
    false,
    function(bool)
        CollectRainyBobux = bool
        while CollectRainyBobux and wait(.1) do
            local rainyBobux = workspace:FindFirstChild("RainyBobux")
            if rainyBobux then
               teleportStuff(rainyBobux) 
            end
        end
    end
)

ToggleChannels:Toggle(
    "Collect Ghost Bobux",
    false,
    function(bool)
        CollectGhostBobux = bool
        while CollectGhostBobux and wait(.1) do
            local ghostBobux = workspace:FindFirstChild("GhostBobux")
            if ghostBobux then
                teleportStuff(ghostBobux)
            end
        end
    end
)

ToggleChannels:Toggle(
    "Collect Bobux Supply",
    false,
    function(bool)
        CollectBobuxSupply = bool
        while true and wait() do
            if workspace:FindFirstChild("LotOfRareBobux") then
                local items = workspace:FindFirstChild("LotOfRareBobux"):GetChildren()
                if #items == 0 then
                    workspace:FindFirstChild("LotOfRareBobux"):Destroy()
                end
            else
                break
            end
        end

        while CollectBobuxSupply and wait(1) do
            local bobuxSupply = workspace:FindFirstChild("BobuxSupply")
            if bobuxSupply then
                fireclickdetector(bobuxSupply.ClickDetector, math.random(1, 3))
                task.wait(2)
                local LotOfRareBobux = workspace.LotOfRareBobux

                if LotOfRareBobux then
                    for _, item in ipairs(LotOfRareBobux:GetChildren()) do
                        teleportStuff(item)
                    end
                end
            end
        end
    end
)

local PurchaseChannel = MainTab:Channel("Purchases")
PurchaseChannel:Label("= Upgrade/Main =")
PurchaseChannel:Dropdown(
    "Choose Upgrade",
    {
        "BobuxUpgrade1",
        "ColdownUpgrade",
        "RareBobuxUpgrade",
        "MultiplierBobux1",
        "PartsLimitUpgrade",
        "ConveyorSpeedUpgrade",
        "AutoBobux",
        "AutoBobuxUpgrade"
    },
    function(option)
        ChoosenUpgradeMain = option
    end
)

PurchaseChannel:Button(
    "Purchase Upgrade",
    function()
        local upgrades = workspace:FindFirstChild("Upgrades")
        if upgrades then
            local upgrade = upgrades:FindFirstChild(ChoosenUpgradeMain)
            if upgrade then
                fireclickdetector(upgrade.Button.ClickDetector, math.random(1, 3))
            end
        end
    end
)

PurchaseChannel:Label("= Upgrade/Grass =")
PurchaseChannel:Dropdown(
    "Choose Upgrade",
    {
        "GrassSpawnUpgrade",
        "GrassUpgrade",
        "GrassGrowUpgrade",
        "BobuxUpgrade3",
        "GrassLimitUpgrade",
        "GoldenMultiplier2",
        "MultiplierBobux3",
    },
    function(option)
        ChoosenUpgradeGrass = option
    end
)

PurchaseChannel:Button(
    "Purchase Upgrade",
    function()
        local upgrades = workspace:FindFirstChild("Upgrades")
        if upgrades then
            local upgrade = upgrades:FindFirstChild(ChoosenUpgradeGrass)
            if upgrade then
                fireclickdetector(upgrade.Button.ClickDetector, math.random(1, 3))
            end
        end
    end
)

PurchaseChannel:Label("= Upgrade/Golden =")
PurchaseChannel:Dropdown(
    "Choose Upgrade",
    {
        "GoldenColdownUpgrade",
        "GoldenBobuxUpgrade",
        "ClicksNeededUpgrade",
        "BobuxUpgrade2",
        "MultiplierBobux2",
        "GoldenMultiplier1",
        "BobuxUpgrade5",
        "AutoBobuxUpgrade2",
    },
    function(option)
        ChoosenUpgradeGolden = option
    end
)

PurchaseChannel:Button(
    "Purchase Upgrade",
    function()
        local upgrades = workspace:FindFirstChild("Upgrades")
        if upgrades then
            local upgrade = upgrades:FindFirstChild(ChoosenUpgradeGolden)
            print("upgrade: ", upgrade, " option: golden")
            if upgrade then
                fireclickdetector(upgrade.Button.ClickDetector, math.random(1, 3))
            end
        end
    end
)

local ColorChannel = MainTab:Channel("Colors Room")
ColorChannel:Label("you must unlock [Room3] first!")
ColorChannel:Toggle(
    "Auto-click colors",
    false,
    function(bool)
        AutoClickColors = bool
        local meaninigs = {
            [1] = "Red",
            [2] = "Blue",
            [3] = "Green",
            [4] = "White",
            [5] = "Yellow"
        }

        while AutoClickColors and task.wait(1) do
            local clickButton = workspace:FindFirstChild("ClickButton")
            if clickButton then
                local ButtonNumber = clickButton.WhichButton.Value
                if meaninigs[ButtonNumber] ~= nil then
                    local button = clickButton[meaninigs[ButtonNumber]]
                    fireclickdetector(button.ClickDetector, math.random(1, 3))
                end
            end
        end
    end
)

ColorChannel:Dropdown(
    "Choose Upgrade",
    {
        "ColorGameRefreshUpgrade",
        "WalkSpeedUpgrade1",
        "LeftForRewardUpgrade",
        "RewardTierUpgrade",
        "MultiplierBobux4",
    },
    function(option)
        ChoosenUpgradeColors = option
    end
)

ColorChannel:Button(
    "Purchase Upgrade",
    function()
        local upgrades = workspace:FindFirstChild("Upgrades")
        if upgrades then
            local upgrade = upgrades:FindFirstChild(ChoosenUpgradeColors)
            print(upgrade)
            if upgrade then
                fireclickdetector(upgrade.Button.ClickDetector, math.random(1, 3))
            end
        end
    end
)

local PointMachineChannel = MainTab:Channel("Point Machine")
PointMachineChannel:Label("you must unlock [Room4] first!")
PointMachineChannel:Dropdown(
    "Choose Upgrade",
    {
        "PointGainUpgrade1",
        "PointsMultiplierUpgrade1",
        "PointsCDUpgrade1",
        "WalkSpeedUpgrade2",
        "BobuxUpgrade4",
        "PointsLimitUpgrade",
    },
    function(option)
        ChoosenUpgradePointMachine = option
    end
)

PointMachineChannel:Button(
    "Purchase Upgrade",
    function()
        local upgrades = workspace:FindFirstChild("Upgrades")
        if upgrades then
            local upgrade = upgrades:FindFirstChild(ChoosenUpgradePointMachine)
            if upgrade then
                fireclickdetector(upgrade.Button.ClickDetector, math.random(1, 3))
            end
        end
    end
)

local CreditTab = UIWindow:Server("[v0.2] Credits", "rbxassetid://110969324988843")
local CreditChannel = CreditTab:Channel("@mehhovcki")
CreditChannel:Label("# created by @mehhovcki")
CreditChannel:Label("you can find scripts here:")
CreditChannel:Label("> https://scriptblox.com/ (Update-7.5-Clicker-Incremental...)")
CreditChannel:Label("> https://github.com/ (mehh0vcki/scripts)")
CreditChannel:Label("if you got this script from anywhere else,")
CreditChannel:Label("someone made a dollar out of you.")

CreditChannel:Button(
    "Copy Script Page",
    function()
        setclipboard("https://scriptblox.com/script/Update-7.5-Clicker-Incremental-SIMPLE-SCRIPT-29338")
        DiscordUI:Notification(
            "Copied Script Page",
            "Succesfully copied Script Page.",
            "Ok!"
        )
    end
)

CreditChannel:Button(
    "Copy GitHub Page",
    function()
        setclipboard("https://github.com/mehh0vcki/scripts")
        DiscordUI:Notification(
            "Copied GitHub Page",
            "Succesfully copied GitHub Page.",
            "Ok!"
        )
    end
)

CreditChannel:Label("best support you can give is:")
CreditChannel:Label("* like on scriptblox.com")
CreditChannel:Label("* star on github")

CreditChannel:Button(
    "View update log",
    function()
        DiscordUI:Notification(
            "Update Log",
            "https://scriptblox.com/script/Update-7.5-Clicker-Incremental-SIMPLE-SCRIPT-For-29299",
            "Ok!"
        )
    end
)
-- mehhovcki was here ;3
