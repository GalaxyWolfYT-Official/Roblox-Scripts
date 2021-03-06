local guiName = "Tower Defense | GalaxyWolfYT"
local lp = game.Players.LocalPlayer
local RP = game:WaitForChild("ReplicatedStorage")
local RemoteFunction = RP.RemoteFunction

if game:GetService("CoreGui"):FindFirstChild(guiName) then game:GetService("CoreGui"):FindFirstChild(guiName):Destroy() end
local library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/GalaxyWolfYT-Official/VenyxUI/main/source.lua"))()
local venyx = library.new(guiName, 5012544693)

local themes = {
    Background = Color3.fromRGB(24, 24, 24),
    Glow = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(10, 10, 10),
    LightContrast = Color3.fromRGB(20, 20, 20),
    DarkContrast = Color3.fromRGB(14, 14, 14),
    TextColor = Color3.fromRGB(255, 255, 255)
}

function getPlayerTowers()
    local towers = {}
    for _, tower in next, workspace.Towers:GetChildren() do
        local success, error = pcall(function()
            if tower:FindFirstChild("Owner") and tower.Owner.Value == lp then
                table.insert(towers, tower)
            end
        end)
    end
    return towers
end

function getFarms()
    local towers = getPlayerTowers()
    local farms = {}
    for _, tower in next, towers do
        if tower.HumanoidRootPart:FindFirstChild("Coin") then
            table.insert(farms, tower)
        end
    end
    return farms
end

function getNormalTowers()
    local towers = getPlayerTowers()
    local normalTowers = {}
    for _, tower in next, towers do
        if not tower.HumanoidRootPart:FindFirstChild("Coin") then
            table.insert(normalTowers, tower)
        end
    end
    return normalTowers
end

function sellTroops()
    for _, troop in next, getNormalTowers() do
        RemoteFunction:InvokeServer("Troops", "Sell", {
            ["Troop"] = troop
        })
    end
end

function upgrade(what)
    RemoteFunction:InvokeServer("Troops", "Upgrade", "Set", {
        ["Troop"] = what
    })
end

function sellFarmsOnLastRound()
    if RP.State.Wave.Value == 40 then
        for _, farm in next, getFarms() do
            RemoteFunction:InvokeServer("Troops", "Sell", {
                ["Troop"] = farm
            })
        end
    end
end

function sellFarms()
    for _, farm in next, getFarms() do
        RemoteFunction:InvokeServer("Troops", "Sell", {
            ["Troop"] = farm
        })
    end
end

function upgradeFarms()
    local farms = getFarms()
    for _, farm in next, farms do
        upgrade(farm)
    end
end

function upgradeTroops()
    local troops = getNormalTowers()
    for _, troop in next, troops do
        upgrade(troop)
    end
end

-- Troops page
local troops = venyx:addPage("Troops", 5012544693)
local autoTroops = troops:addSection("Auto")
local utilitiesTroops = troops:addSection("Utilities")

autoTroops:addToggle("Upgrade Troops", nil, function(status)
    getrenv().autoUpTroops = status
    spawn(function()
        while task.wait(.1) do
            if getrenv().autoUpTroops == false then
                break
            end
            upgradeTroops()
        end
    end)()
end)

autoTroops:addToggle("Upgrade farms", nil, function(status)
    getrenv().autoUpFarms = status
    spawn(function()
        while task.wait(.1) do
            if getrenv().autoUpFarms == false then
                break
            end
            upgradeFarms()
        end
    end)()
end)

utilitiesTroops:addToggle("Sell Farms On Last Round", nil, function(status)
    getrenv().autoSellFarms = status
    spawn(function()
        while task.wait(.1) do
            if getrenv().autoSellFarms == false then
                break
            end
            sellFarmsOnLastRound()
        end
    end)()
end)

utilitiesTroops:addButton("Sell All Farms", function()
    sellFarms()
end)

utilitiesTroops:addButton("Sell All Troops", function()
    sellTroops()
end)

local settings = venyx:addPage("Settings", 5012544372)
local gui = settings:addSection("GUI")
local colors = settings:addSection("Colors")

gui:addKeybind("Toggle GUI", Enum.KeyCode.Semicolon, function()
    venyx:toggle()
end, function()
    venyx:Notify("Settings", "GUI toggle key changed!")
end)

for theme, color in next, themes do -- all in one theme changer, i know, im cool
    colors:addColorPicker(theme, color, function(color3)
        venyx:setTheme(theme, color3)
    end)
end

venyx:SelectPage(venyx.pages[1], true)
