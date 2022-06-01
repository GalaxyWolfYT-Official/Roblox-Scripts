local lp = game.Players.LocalPlayer
local paintGrid = lp.PlayerGui.MainGui.PaintFrame.GridHolder.Grid
local canvasSize = 32
local imageDataName = "zerotwo.json"

function paintPixel(pos, color)
    pos.BackgroundColor3 = color
end

function getImageInfo(fileName)
    local file = readfile(string.format("Starving Artists/%s", fileName))
    local image = game.HttpService:JSONDecode(file)
    return image
end

function getRGB()
    local colors = {}
    for _, layer in pairs(getImageInfo(imageDataName)) do
        for _, rgb in pairs(layer) do
            local colorR, colorG, colorB = rgb[1], rgb[2], rgb[3]
            table.insert(colors, {colorR, colorG, colorB})
        end
    end
    return colors
end

for pos, rgb in pairs(getRGB()) do
    if paintGrid:FindFirstChild(pos) then
        paintPixel(paintGrid:FindFirstChild(pos), Color3.fromRGB(unpack(rgb)))
    end
end
