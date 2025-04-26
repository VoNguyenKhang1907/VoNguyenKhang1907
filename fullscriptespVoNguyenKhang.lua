local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local espEnabled = false -- Trạng thái bật/tắt ESP
local npcGroup = Workspace:WaitForChild("NPCs") -- Thay bằng nhóm chứa các sinh vật (vd: Figure)

-- Hàm tạo Highlight
local function createHighlight(target, color)
    if not target:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.Adornee = target
        highlight.Parent = target
        highlight.FillColor = color or Color3.fromRGB(255, 0, 0) -- Màu đỏ mặc định
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Viền trắng
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Luôn hiển thị
    end
end

-- Hàm bật ESP
local function enableESP()
    -- Bật ESP cho người chơi
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            createHighlight(player.Character, Color3.fromRGB(0, 255, 0)) -- Màu xanh lá cho người chơi
        end
    end

    -- Bật ESP cho các sinh vật (NPCs)
    for _, npc in pairs(npcGroup:GetChildren()) do
        if npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Torso") then
            createHighlight(npc, Color3.fromRGB(255, 0, 0)) -- Màu đỏ cho NPC
        end
    end
end

-- Hàm tắt ESP
local function disableESP()
    -- Tắt ESP cho người chơi
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("ESPHighlight") then
            player.Character.ESPHighlight:Destroy()
        end
    end

    -- Tắt ESP cho các sinh vật (NPCs)
    for _, npc in pairs(npcGroup:GetChildren()) do
        if npc:FindFirstChild("ESPHighlight") then
            npc.ESPHighlight:Destroy()
        end
    end
end

-- Lắng nghe phím tắt để bật/tắt ESP
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end

    if input.KeyCode == Enum.KeyCode.E then -- Nhấn phím 'E' để bật ESP
        if not espEnabled then
            espEnabled = true
            enableESP()
            print("ESP Enabled")
        end
    elseif input.KeyCode == Enum.KeyCode.R then -- Nhấn phím 'R' để tắt ESP
        if espEnabled then
            espEnabled = false
            disableESP()
            print("ESP Disabled")
        end
    end
end)
