local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GalaxyWolfYT-Official/VenyxUI/main/source.lua"))()
local venyx = library.new("This Game Is A Based On Other Games XD", 5012544693)
getfenv().autoMineSpeed = 0.5
getfenv().autoMineRadius = 1000

local lp = game.Players.LocalPlayer

local themes = {
	Background = Color3.fromRGB(24, 24, 24),
	Glow = Color3.fromRGB(0, 0, 0),
	Accent = Color3.fromRGB(10, 10, 10),
	LightContrast = Color3.fromRGB(20, 20, 20),
	DarkContrast = Color3.fromRGB(14, 14, 14),  
	TextColor = Color3.fromRGB(255, 255, 255)
}

function getMine()
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
    game:GetService("ReplicatedStorage").Aero.AeroRemoteServices.MiningService.SellInventory:InvokeServer(getMine().Seller.Seller)
end

function damage()
    local mines = getMine()
    for i, mine in pairs(mines) do
        for _, block in ipairs(mine.MineableBlocks:GetChildren()) do
            if (lp.Character.HumanoidRootPart.Position - block.Position).magnitude < getfenv().autoMineRadius then
                coroutine.wrap(function()
                    game:GetService("ReplicatedStorage").Aero.AeroRemoteServices.BlockService.DamageBlock:InvokeServer(block.UniqueId.Value, block.Parent.Parent)
                    sell()
                end)()
                wait(getfenv().autoMineSpeed)
            end
        end
    end
end

local mining = venyx:addPage("Mining", 5012544693)
local autoMining = mining:addSection("Auto")

autoMining:addToggle("Auto Mining + Selling", nil, function(value)
    getfenv().damageBool = value
    coroutine.wrap(function()
        while getfenv().damageBool == true and wait() do
            if getfenv().damageBool == false then break end
            damage()
        end
    end)()
end)

autoMining:addSlider("Auto Mining Speed (Milliseconds)", 500, 0, 1000, function(value)
	local speed = value / 1000
    getfenv().autoMineSpeed = speed
end)

autoMining:addSlider("Auto Mining Radius", 100000, 0, 100000, function(value)
    getfenv().autoMineRadius = value
end)

local theme = venyx:addPage("Theme", 5012544693)
local colors = theme:addSection("Colors")

for theme, color in pairs(themes) do
	colors:addColorPicker(theme, color, function(color3)
		venyx:setTheme(theme, color3)
	end)
end

-- load
venyx:SelectPage(venyx.pages[1], true)