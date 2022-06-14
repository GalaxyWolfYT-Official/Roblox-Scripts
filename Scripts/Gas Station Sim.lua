local guiName = "Gas Station Simulator | GalaxyWolfYT"
local lp = game.Players.LocalPlayer
local mouse = lp:GetMouse()
local rp = game:WaitForChild("ReplicatedStorage")

local promptNameList = {"Clean", "Scan", "FinishFuel", "Refuel", "BuyBloxBull"}

getrenv().promptSpeed = 0
getrenv().promptReach = 15

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

function fastPrompts()
    for i, obj in ipairs(workspace:GetDescendants()) do
        if table.find(promptNameList, obj.Name) then
            obj.HoldDuration = getrenv().promptSpeed
        end
    end
end

function longPrompts()
    for i, obj in ipairs(workspace:GetDescendants()) do
        if table.find(promptNameList, obj.Name) then
            obj.MaxActivationDistance = getrenv().promptReach
        end
    end
end

function energy()
    local energyAmount = lp.PlayerGui.GameUI.Stamina.Bar.Amount.Text
    energyAmount = string.gsub(energyAmount, "%%", "")

    if tonumber(energyAmount) <= 50 then
        for i, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name == "BuyBloxBull" then
                fireproximityprompt(obj, 1000)
            end
        end
    end
end

function autoFarm(speed)
    for i, obj in ipairs(workspace:GetDescendants()) do
        energy()
        if obj.name == "Refuel" then
            local bank = lp.PlayerGui.GameUI.Stats.Bank.Bank.Text
            local bills = lp.PlayerGui.GameUI.Stats.Bills.Bills.Text
            local price = 9

            bank = tonumber(string.sub(bank, 2))
            bills = tonumber(string.sub(bills, 2))
            local total = bank - bills

            if (total) > price + 5 then
                rp.Remote:FireServer("BuyItem", "Syntin Petrol Co", "Gasoline 87", 1, "Station")
            end

            fireproximityprompt(obj, 1000)
        elseif obj.Name == "FinishFuel" then
            fireproximityprompt(obj, 1000)
        end
    end
end

local autoPage = venyx:addPage("Auto Farm", 5012544944)
local gasSection = autoPage:addSection("Gas Farm")

gasSection:addToggle("Auto Farm (Private Server Recommened)", nil, function(value)
    getrenv().gasAutoFarmBool = value
    spawn(function()
        while task.wait() and getrenv().gasAutoFarmBool do
            if getrenv().gasAutoFarmBool == false then
                break
            end
            autoFarm()
            task.wait(.5)
        end
    end)
end)

local promptPage = venyx:addPage("Prompts", 5012544944)
local fastPromptsSection = promptPage:addSection("Fast Prompts")
local longPromptsSection = promptPage:addSection("Prompt Reach")

fastPromptsSection:addToggle("Toggle", nil, function(value)
    getrenv().fastPromptsBool = value
    spawn(function()
        while task.wait() and getrenv().fastPromptsBool do
            if getrenv().fastPromptsBool == false then
                break
            end
            fastPrompts()
            task.wait(0.1)
        end
    end)
end)

fastPromptsSection:addSlider("Speed", 0, 0, 10, function(value)
    getrenv().promptSpeed = value
end)

getrenv().promptSpeed = 0
getrenv().promptReach = 15

longPromptsSection:addToggle("Toggle", nil, function(value)
    getrenv().longPromptsBool = value
    spawn(function()
        while task.wait() and getrenv().longPromptsBool do
            if getrenv().longPromptsBool == false then
                break
            end
            longPrompts()
            task.wait(0.1)
        end
    end)
end)

longPromptsSection:addSlider("Reach", 10, 0, 100, function(value)
    getrenv().promptReach = value
end)

local settings = venyx:addPage("Settings", 5012544372)
local gui = settings:addSection("GUI")
local colors = settings:addSection("Colors")

gui:addKeybind("Toggle GUI", Enum.KeyCode.Semicolon, function()
    venyx:toggle()
end, function()
    venyx:Notify("Settings", "GUI toggle key changed!")
end)

gui:addButton("Kill GUI", function()
    if game:GetService("CoreGui"):FindFirstChild(guiName) then game:GetService("CoreGui"):FindFirstChild(guiName):Destroy() end
end)

for theme, color in pairs(themes) do -- all in one theme changer, i know, im cool
    colors:addColorPicker(theme, color, function(color3)
        venyx:setTheme(theme, color3)
    end)
end

venyx:SelectPage(venyx.pages[1], true)
