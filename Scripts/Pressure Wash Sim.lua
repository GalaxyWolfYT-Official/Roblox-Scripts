local rp = game.ReplicatedStorage
local mercury = loadstring(game:HttpGet("https://raw.githubusercontent.com/GalaxyWolfYT-Official/MercuryUI/main/mercuryLib.lua"))()

local version = "1.0"
local changeLog = [[
	2022-06-14:
		- Initial Release
		- Features Added:
			- UI
			- Auto Clean (The Dirt Disappears After Rejoining!)
			- Infinite Water
]]

local GUI = mercury:Create{
    Name = "Pressure Wash Sim Script",
    Size = UDim2.fromOffset(600, 400),
    Theme = mercury.Themes.Dark,
    Link = "https://github.com/GalaxyWolfYT-Official/MercuryUI"
}

local utilitiesTab = GUI:Tab{
	Name = "Utilities",
	Icon = "rbxassetid://8569322835"
}

function infiniteWater(bool)
    rp.Remotes.RefillRemote:FireServer(bool)
end

function clean(obj)
    for _, toClean in ipairs(obj:GetDescendants()) do
        spawn(function()
            if toClean:IsA("Texture") and toClean:FindFirstChild("ID") then
                game:GetService("ReplicatedStorage").Remotes.SurfaceCompleted:FireServer(toClean.ID.Value, .1)
            end
        end)
    end
end

utilitiesTab:Toggle{
	Name = "Infinite Water",
	StartingState = false,
	Description = "Automatically refills the water",
	Callback = function(state) 
		infiniteWater(state) 
	end
}

utilitiesTab:Button{
	Name = "Clean Once",
	Description = "Cleans The Dirt Once",
	Callback = function()
        spawn(function()
			clean(workspace.Worlds)
        end)
    end
}

utilitiesTab:Toggle{
	Name = "Auto Clean",
	StartingState = false,
	Description = "Auto Cleans (Lag!)",
	Callback = function(state)
		getfenv().autoClean = state
		spawn(function()
			while task.wait(5) and getfenv().autoClean do
				clean(workspace.Worlds)
			end
		end)
	end
}

GUI:Notification{
	Title = "Version",
	Text = version,
	Duration = 3,
	Callback = function() end
}

GUI:Notification{
	Title = "Change Log",
	Text = changeLog,
	Duration = 5,
	Callback = function() end
}

GUI:Credit{
	Name = "GalaxyWolfYT",
	Description = "Created the script.",
	V3rm = "Don't have one yet...",
	Discord = "GalaxyWolfYT#0788"
}