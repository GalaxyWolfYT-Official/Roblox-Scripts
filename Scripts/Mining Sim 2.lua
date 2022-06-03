local lp = game.Players.LocalPlayer
local rp = game.ReplicatedStorage
local tweenService = game:GetService("TweenService")
local events = rp.Events

local inv = lp.PlayerGui.ScreenGui.Inventory
local crates = inv.Frame.Container.Items.Content.Frame.Crate.Items
local codes = {
    "RareCrate",
    "Gems",
    "FreeCrate",
    "Release",
    "FreeEgg"
}

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GalaxyWolfYT-Official/VenyxUI/main/source.lua"))()
local venyx = library.new("Mining Simulator 2 | GalaxyWolfYT", 5012544693)

-- themes
local themes = {
	Background = Color3.fromRGB(24, 24, 24),
	Glow = Color3.fromRGB(0, 0, 0),
	Accent = Color3.fromRGB(10, 10, 10),
	LightContrast = Color3.fromRGB(20, 20, 20),
	DarkContrast = Color3.fromRGB(14, 14, 14),  
	TextColor = Color3.fromRGB(255, 255, 255)
}

function float()
    lp.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
end

function tpTo(pos)
    float()
    lp.Character.HumanoidRootPart.CFrame = pos
    float()
end

function openCrates()
    for _, obj in ipairs(crates:GetChildren()) do
        local objName = obj.Name
        local objParent = obj.Parent
        if obj:IsA("Frame") then
            repeat
                task.wait()
                events.OpenCrate:FireServer(obj.Name)
            until not objParent:FindFirstChild(objName) or objParent == nil
        end
    end
end

function redeemCodes()
    for _, code in pairs(codes) do
        rp.Functions.RedeemCode:InvokeServer(string.lower(code))
    end
end

function getChests()
    local chests = {}
    for _, obj in ipairs(workspace.Checkpoints:GetChildren()) do
        if obj:FindFirstChild("Chest") then
            table.insert(chests, obj.Chest)
        end
    end
    return chests
end

function getTreasures()
    local ogPos = lp.Character.HumanoidRootPart.CFrame 
    for _, obj in ipairs(getChests()) do
        obj = obj.Activation.Root
        if obj:FindFirstChild("TouchInterest") then
            tpTo(obj.CFrame)
            task.wait(.2)
            tpTo(obj.CFrame)
            firetouchinterest(lp.Character.Head, obj, 1)
            tpTo(obj.CFrame)
            task.wait(.2)
            tpTo(obj.CFrame)
            firetouchinterest(lp.Character.Head, obj, 0)
            tpTo(obj.CFrame)
        end
    end
    tpTo(ogPos)
end

-- Miscellaneous
local misc = venyx:addPage("Miscellaneous", 5012544944)
local tools = misc:addSection("Tools")

tools:addButton("Open All Crates", function()
	openCrates()
end)

tools:addButton("Redeem Codes", function()
    redeemCodes()
end)

tools:addButton("Get Chests", function()
    getTreasures()
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