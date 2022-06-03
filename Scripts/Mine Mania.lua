local library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/GalaxyWolfYT-Official/VenyxUI/main/source.lua"))()
local venyx = library.new("Mine Mania | GalaxyWolfYT", 5012544693)


--Variables START
getrenv().autoMineSpeed = 0.5
getrenv().autoMineRadius = 1000

local lp = game.Players.LocalPlayer
local rp = game:GetService("ReplicatedStorage")

local themes = {
    Background = Color3.fromRGB(24, 24, 24),
    Glow = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(10, 10, 10),
    LightContrast = Color3.fromRGB(20, 20, 20),
    DarkContrast = Color3.fromRGB(14, 14, 14),
    TextColor = Color3.fromRGB(255, 255, 255)
}

-- Variables END

function getMines()
    local mines = {}
    for _, obj in ipairs(game.Workspace.Map.Mines:GetDescendants()) do
        if string.find(obj.Name, "Mine") then
            if obj:FindFirstChild("MineableBlocks") and #obj.MineableBlocks:GetChildren() ~= 0 then
                table.insert(mines, obj)
            end
        end
    end
    return mines
end

function sell()
    for i, mine in pairs(getMines()) do
        rp.Aero.AeroRemoteServices.MiningService.SellInventory:InvokeServer(mine.Seller.Seller)
    end
end

function damage()
    local mines = getMines()
    for i, mine in ipairs(mines) do
        for _, block in ipairs(mine.MineableBlocks:GetChildren()) do
            if (lp.Character.HumanoidRootPart.Position - block.Position).magnitude < getrenv().autoMineRadius then
                spawn(function()
                    rp.Aero.AeroRemoteServices.BlockService.DamageBlock:InvokeServer(
                        block.UniqueId.Value, block.Parent.Parent)
                    sell()
                end)()
                task.wait(getrenv().autoMineSpeed)
            end
        end
    end
end

local mining = venyx:addPage("Mining", 5012544944)
local autoMining = mining:addSection("Auto")

autoMining:addToggle("Auto Mining + Selling", nil, function(value)
    getrenv().damageBool = value
    spawn(function()
        while getrenv().damageBool == true and task.wait() do
            if getrenv().damageBool == false then
                break
            end
            damage()
        end
    end)()
end)

autoMining:addSlider("Auto Mining Speed (Milliseconds)", 500, 0, 1000, function(value)
    local speed = value / 1000
    getrenv().autoMineSpeed = speed
end)

autoMining:addSlider("Auto Mining Radius", 100000, 0, 100000, function(value)
    getrenv().autoMineRadius = value
end)

local settings = venyx:addPage("Settings", 5012544372)
local gui = settings:addSection("GUI")
local colors = settings:addSection("Colors")

gui:addKeybind("Toggle GUI", Enum.KeyCode.Semicolon, function()
	venyx:toggle()
end, function()
	venyx:Notify("Settings", "GUI toggle key changed!")
end)

for theme, color in pairs(themes) do -- all in one theme changer, i know, im cool
	colors:addColorPicker(theme, color, function(color3)
		venyx:setTheme(theme, color3)
	end)
end


venyx:SelectPage(venyx.pages[1], true)
