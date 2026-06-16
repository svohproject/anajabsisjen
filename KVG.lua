local player = game.Players.LocalPlayer

local PAD_POSITION = Vector3.new(940.012817, 176.0, -1223.30676)
local DUEL_POSITION = Vector3.new(171.524994, 1914.70007, -93.2749634)

local LOBBY_SPAWNS = {
    Vector3.new(919.240845, 171.313599, -1179.3905),
    Vector3.new(934.338501, 171.313599, -1161.89062),
    Vector3.new(917.838501, 171.313599, -1145.39062),
    Vector3.new(907.338501, 171.313599, -1173.39062),
    Vector3.new(930.338501, 171.313599, -1173.89062),
    Vector3.new(906.338501, 171.313599, -1151.89062),
    Vector3.new(902.838501, 171.313599, -1163.89062),
    Vector3.new(928.838501, 171.313599, -1151.89062),
}

local enabled = false
local lastPadTeleport = 0
local COOLDOWN = 180
local currentFOV = 90
local lowGFXEnabled = false

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 320)
mainFrame.Position = UDim2.new(0.5, -210, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = false
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 16)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(0, 170, 255)
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, 0, 0, 50)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local farmTab = Instance.new("TextButton")
farmTab.Size = UDim2.new(0.5, 0, 1, 0)
farmTab.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
farmTab.Text = "Farm"
farmTab.TextColor3 = Color3.new(1,1,1)
farmTab.TextScaled = true
farmTab.Font = Enum.Font.GothamBold
farmTab.Parent = tabFrame

local settingsTab = Instance.new("TextButton")
settingsTab.Size = UDim2.new(0.5, 0, 1, 0)
settingsTab.Position = UDim2.new(0.5, 0, 0, 0)
settingsTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
settingsTab.Text = "Settings"
settingsTab.TextColor3 = Color3.new(1,1,1)
settingsTab.TextScaled = true
settingsTab.Font = Enum.Font.GothamBold
settingsTab.Parent = tabFrame

local farmContent = Instance.new("Frame")
farmContent.Size = UDim2.new(1,0,1,-50)
farmContent.Position = UDim2.new(0,0,0,50)
farmContent.BackgroundTransparency = 1
farmContent.Parent = mainFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8,0,0,55)
toggleBtn.Position = UDim2.new(0.1,0,0,30)
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Text = "DISABLED"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = farmContent

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(0.9,0,0,40)
statusLabel.Position = UDim2.new(0.05,0,0,110)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Status: Disabled"
statusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
statusLabel.TextScaled = true
statusLabel.Parent = farmContent

local settingsContent = Instance.new("Frame")
settingsContent.Size = UDim2.new(1,0,1,-50)
settingsContent.Position = UDim2.new(0,0,0,50)
settingsContent.BackgroundTransparency = 1
settingsContent.Visible = false
settingsContent.Parent = mainFrame

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0.9,0,0,30)
fovLabel.Position = UDim2.new(0.05,0,0,30)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV (70-120):"
fovLabel.TextColor3 = Color3.new(1,1,1)
fovLabel.TextScaled = true
fovLabel.Font = Enum.Font.GothamSemibold
fovLabel.Parent = settingsContent

local fovBox = Instance.new("TextBox")
fovBox.Size = UDim2.new(0.8,0,0,40)
fovBox.Position = UDim2.new(0.1,0,0,65)
fovBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
fovBox.Text = "90"
fovBox.TextColor3 = Color3.new(1,1,1)
fovBox.TextScaled = true
fovBox.Font = Enum.Font.GothamBold
fovBox.ClearTextOnFocus = false
fovBox.Parent = settingsContent

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(0,8)
fovCorner.Parent = fovBox

local lowGFXBtn = Instance.new("TextButton")
lowGFXBtn.Size = UDim2.new(0.8,0,0,50)
lowGFXBtn.Position = UDim2.new(0.1,0,0,130)
lowGFXBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
lowGFXBtn.Text = "Low GFX: OFF"
lowGFXBtn.TextColor3 = Color3.new(1,1,1)
lowGFXBtn.TextScaled = true
lowGFXBtn.Font = Enum.Font.GothamBold
lowGFXBtn.Parent = settingsContent

local smallBtn = Instance.new("TextButton")
smallBtn.Size = UDim2.new(0, 55, 0, 55)
smallBtn.Position = UDim2.new(0, 20, 0, 20)
smallBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
smallBtn.Text = "K"
smallBtn.TextColor3 = Color3.new(1,1,1)
smallBtn.TextScaled = true
smallBtn.Font = Enum.Font.GothamBold
smallBtn.Draggable = true
smallBtn.Parent = screenGui

local function switchTab(tab)
    if tab == "Farm" then
        farmContent.Visible = true
        settingsContent.Visible = false
        farmTab.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        settingsTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    else
        farmContent.Visible = false
        settingsContent.Visible = true
        farmTab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        settingsTab.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    end
end

farmTab.MouseButton1Click:Connect(function() switchTab("Farm") end)
settingsTab.MouseButton1Click:Connect(function() switchTab("Settings") end)

fovBox.FocusLost:Connect(function()
    local num = tonumber(fovBox.Text)
    if num then
        currentFOV = math.clamp(math.floor(num), 70, 120)
        fovBox.Text = tostring(currentFOV)
        pcall(function() workspace.CurrentCamera.FieldOfView = currentFOV end)
    else
        fovBox.Text = tostring(currentFOV)
    end
end)

lowGFXBtn.MouseButton1Click:Connect(function()
    lowGFXEnabled = not lowGFXEnabled
    if lowGFXEnabled then
        lowGFXBtn.Text = "Low GFX: ON"
        lowGFXBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").FogEnd = 999999
            game:GetService("Lighting").Brightness = 0.5
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.Plastic
                    v.Reflectance = 0
                    if v:FindFirstChild("Texture") then v.Texture:Destroy() end
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                    v.Enabled = false
                elseif v:IsA("PointLight") or v:IsA("SpotLight") then
                    v.Enabled = false
                end
            end
        end)
    else
        lowGFXBtn.Text = "Low GFX: OFF"
        lowGFXBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
            game:GetService("Lighting").GlobalShadows = true
        end)
    end
end)

toggleBtn.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        toggleBtn.Text = "ENABLED"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
        statusLabel.Text = "Status: Farming Active"
        lastPadTeleport = 0
    else
        toggleBtn.Text = "DISABLED"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        statusLabel.Text = "Status: Disabled"
    end
end)

smallBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

task.spawn(function()
    while true do
        if enabled then
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local root = character.HumanoidRootPart
                local humanoid = character:FindFirstChild("Humanoid")
                local currentTime = tick()

                if (root.Position - DUEL_POSITION).Magnitude < 60 then
                    statusLabel.Text = "Status: In Duel"
                    task.wait(1.5)
                    continue
                end

                if root.Position.Y < 400 then
                    local nearLobbySpawn = false
                    for _, spawnPos in ipairs(LOBBY_SPAWNS) do
                        if (root.Position - spawnPos).Magnitude < 15 then
                            nearLobbySpawn = true
                            break
                        end
                    end

                    if nearLobbySpawn then
                        root.CFrame = CFrame.new(PAD_POSITION)
                        lastPadTeleport = currentTime
                        statusLabel.Text = "Status: Spawned → Teleported to Pad"
                        task.wait(2.5)
                    elseif (currentTime - lastPadTeleport) > COOLDOWN then
                        root.CFrame = CFrame.new(PAD_POSITION)
                        lastPadTeleport = currentTime
                        statusLabel.Text = "Status: Teleported to Pad (Cooldown)"
                        task.wait(2.5)
                    else
                        local remaining = math.floor(COOLDOWN - (currentTime - lastPadTeleport))
                        statusLabel.Text = "Status: Waiting... (" .. remaining .. "s)"
                    end
                end

                if humanoid then
                    local tool = nil
                    for _, t in ipairs(player.Backpack:GetChildren()) do
                        if t:IsA("Tool") and (t.Name:lower():find("knife") or t.Name:lower():find("blade")) then
                            tool = t
                            break
                        end
                    end
                    if not tool then
                        for _, t in ipairs(player.Backpack:GetChildren()) do
                            if t:IsA("Tool") then tool = t break end
                        end
                    end

                    if tool then
                        pcall(function() humanoid:UnequipTools() end)
                        task.wait(0.025)
                        pcall(function() humanoid:EquipTool(tool) end)
                        task.wait(0.03)
                        local equipped = character:FindFirstChildWhichIsA("Tool")
                        if equipped then equipped:Activate() end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

print("KVG AutoFarm Loaded")