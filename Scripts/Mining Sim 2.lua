local guiName = "Mining Simulator 2 | GalaxyWolfYT | ; To Hide GUI"
local lp = game.Players.LocalPlayer
local rp = game:WaitForChild("ReplicatedStorage")
local chunkUtil = require(rp.SharedModules.ChunkUtil)
local events = rp.Events

local inv = lp.PlayerGui.ScreenGui.Inventory
local crates = inv.Frame.Container.Items.Content.Frame.Crate.Items
local codes = {"RareCrate", "Gems", "FreeCrate", "Release", "FreeEgg"}
local eggNames = {"Select/None", "Basic Egg", "Exotic Egg", "Forest Egg", "Spotted Egg", "Dragon Egg", "Dark Egg",
                  "Ice Egg", "Arctic Egg", "Volcanic Egg", "Underworld Egg", "Crystal Egg"}
local chestTypes = {"Select/None", "Wood", "Silver", "Gold", "Epic", "Legendary"}

getrenv().selectedEgg = nil
getrenv().floating = false
getrenv().instaTp = nil
getrenv().mining = false
getrenv().grabChests = false
getrenv().autoEgg = false
getrenv().selectedChests = {nil, nil, nil}
getrenv().selectedOres = {nil, nil, nil}

if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(lp.UserId, 43752232) then
    getrenv().instaTp = true
else
    getrenv().instaTp = false
end

local finity =
    loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/UI-Librarys/main/Finity%20UI%20Lib"))()
local fw = finity.new(true, guiName)
fw.ChangeToggleKey(Enum.KeyCode.Semicolon)

function float()
    lp.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
end

spawn(function()
    while task.wait() do
        if getrenv().floating == true then
            float()
        end
    end
end)

function goTo(pos, speed)
    if not ((lp.Character.HumanoidRootPart.Position -
        Vector3.new(pos.X, lp.Character.HumanoidRootPart.Position.Y, pos.Z)).magnitude < .1) then
        speed = (lp.Character.HumanoidRootPart.Position - Vector3.new(pos.X, lp.Character.HumanoidRootPart.Position.Y, pos.Z)).magnitude / speed + 2
        local TweenService = game:GetService("TweenService")
        local tweenInfo = TweenInfo.new(speed, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(lp.Character.HumanoidRootPart, tweenInfo, {
            CFrame = CFrame.new(pos.X, lp.Character.HumanoidRootPart.CFrame.Y, pos.Z)
        })
        tween:Play()
        tween.Completed:Wait()
        task.wait(1)
        return tween
    end
    lp.Character.HumanoidRootPart.CFrame = CFrame.new(lp.Character.HumanoidRootPart.CFrame.X, pos.Y,
        lp.Character.HumanoidRootPart.CFrame.Z)
end

function instaTp(pos)
    lp.Character.HumanoidRootPart.CFrame = pos
    task.wait(.1)
    events.PlaceTeleporter:FireServer()
    events.GotoTeleporter:FireServer()
    events.RemoveTeleporter:FireServer()
end

function tpTo(pos)
    getrenv().floating = true
    if getrenv().instaTp == true then
        instaTp(pos)
    else
        goTo(pos, 10)
    end
    getrenv().floating = false
end

function openCrates()
    for _, obj in next, crates:GetChildren() do
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
    for _, code in next, codes do
        rp.Functions.RedeemCode:InvokeServer(string.lower(code))
    end
end

function getChests()
    local chests = {}
    for _, obj in next, workspace.Checkpoints:GetChildren() do
        if obj:FindFirstChild("Chest") then
            table.insert(chests, obj.Chest)
        end
    end
    return chests
end

function getTreasures()
    local ogPos = lp.Character.HumanoidRootPart.CFrame
    for _, obj in next, getChests() do
        if (obj.Activation.Tag.BillboardGui.Title.Visible == false) then
            obj = obj.Activation.Root
            if obj:FindFirstChild("TouchInterest") then
                tpTo(obj.CFrame)
                task.wait(.2)
                firetouchinterest(lp.Character.Head, obj, 1)
                task.wait(.2)
                firetouchinterest(lp.Character.Head, obj, 0)
            end
        end
    end
    tpTo(ogPos)
end

function openEgg(egg)
    events.OpenEgg:FireServer(egg)
end

function getBlockPos(block)
    return chunkUtil.worldToCell(block.Position)
end

function getOreNames()
    local ores = {}
    table.insert(ores, "Select/None")
    for _, obj in next, rp.Assets.BlockDecorations:GetChildren() do
        table.insert(ores, obj.Name)
    end
    return ores
end

function mine()
    for _, block in next, workspace.Chunks:GetDescendants() do
        if block:IsA("Part") and table.find(getrenv().selectedOres, block.Name) then
            local success, error = pcall(function()
                repeat
                    task.wait()
                    tpTo(block.CFrame)
                    events.MineBlock:FireServer(getBlockPos(block))
                until block == nil
            end)
        end
    end
end

function grabChests()
    for _, chest in next, workspace.Chests:GetChildren() do
        if table.find(getrenv().selectedChests, chest.Name) then
            local success, err = pcall(function()
                repeat
                    task.wait()
                    tpTo(chest.PrimaryPart.CFrame)
                until chest == nil or chest.PrimaryPart == nil
            end)
        end
    end
end

-- Miscellaneous
local misc = fw:Category("Miscellaneous")

local ores = misc:Sector("Ores")

for i = 1, 3, 1 do
    ores:Cheat("Dropdown", string.format("Ore #%s", i), function(ore)
        if ore == "Select/None" then
            getrenv().selectedOres[i] = nil
        else
            getrenv().selectedOres[i] = ore
        end
    end, {
        options = getOreNames()
    })
end

ores:Cheat("Checkbox", "Auto Mine Selected Ores", function(mineBool)
    getrenv().mining = mineBool
    spawn(function()
        while task.wait() and getrenv().mining do
            if getrenv().mining == false then break end
            mine()
        end
    end)
end)

local crates = misc:Sector("Chests")

for i = 1, 3, 1 do
    crates:Cheat("Dropdown", string.format("Chest #%s", i), function(chest)
        if chest == "Select/None" then
            getrenv().selectedChests[i] = nil
        else
            getrenv().selectedChests[i] = chest
        end
    end, {
        options = chestTypes
    })
end

crates:Cheat("Checkbox", "Grab Chests", function(chestBool)
    getrenv().grabChests = chestBool
    spawn(function()
        while task.wait() and getrenv().grabChests do
            if getrenv().grabChests == false then break end
            grabChests()
        end
    end)
end)

crates:Cheat("Button", "Open All Chests", function()
    openCrates()
end)

local tools = misc:Sector("Tools")

tools:Cheat("Button", "Redeem Codes", function()
    redeemCodes()
end)

tools:Cheat("Button", "Get Treasure", function()
    getTreasures()
end)

local eggs = misc:Sector("Eggs")

eggs:Cheat("Dropdown", "Select A Egg", function(egg)
    if egg == "Select/None" then
        getrenv().selectedEgg = nil
    else
        getrenv().selectedEgg = egg
    end
end, {
    options = eggNames
})

eggs:Cheat("Checkbox", "Open Selected Egg", function(autoEgg)
    getrenv().autoEgg = autoEgg
    if getrenv().selectedEgg ~= nil then
        local ogPos = lp.Character.HumanoidRootPart.CFrame
        spawn(function()
            while task.wait() and getrenv().autoEgg == true do
                lp.Character.HumanoidRootPart.CFrame = (workspace.Eggs[getrenv().selectedEgg].Default.Root.CFrame +
                                                           Vector3.new(0, 0, 0))
                task.wait(.2)
                openEgg(getrenv().selectedEgg)
                -- task.wait(.5)
                -- lp.Character.HumanoidRootPart.CFrame = ogPos
            end
        end)
    end
end)