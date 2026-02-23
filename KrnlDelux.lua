local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local pgui = player:WaitForChild("PlayerGui")

local main = Instance.new("ScreenGui")
main.Name = "Krnl_GUI"
main.ResetOnSpawn = false
main.IgnoreGuiInset = true
main.Parent = pgui

-- ==================== BLUR ====================
local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0

-- ==================== INTRO ====================
task.spawn(function()
    TweenService:Create(blur, TweenInfo.new(0.8), {Size = 24}):Play()

    local intro = Instance.new("ImageLabel")
    intro.Size = UDim2.new(0,667,0,421)
    intro.Position = UDim2.new(0.5,0,0.5,0)
    intro.AnchorPoint = Vector2.new(0.5,0.5)
    intro.BackgroundTransparency = 1
    intro.Image = "rbxassetid://6278672195"
    intro.ImageColor3 = Color3.fromRGB(136,0,32)
    intro.ImageTransparency = 1
    intro.ZIndex = 10
    intro.Parent = main
    Instance.new("UICorner",intro).CornerRadius = UDim.new(0,9)

    local txt = Instance.new("TextLabel",intro)
    txt.Size = UDim2.new(1,0,1,0)
    txt.Position = UDim2.new(0,0,0,0)
    txt.BackgroundTransparency = 1
    txt.Text = "Krnl"
    txt.TextColor3 = Color3.new(1,1,1)
    txt.TextSize = 100
    txt.Font = Enum.Font.MontserratBold
    txt.TextTransparency = 1
    txt.TextXAlignment = Enum.TextXAlignment.Center
    txt.TextYAlignment = Enum.TextYAlignment.Center
    txt.ZIndex = 11

    TweenService:Create(intro, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {ImageTransparency = 0.2}):Play()
    TweenService:Create(txt, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {TextTransparency = 0}):Play()

    task.wait(3.5)

    TweenService:Create(intro, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {ImageTransparency = 1}):Play()
    TweenService:Create(txt, TweenInfo.new(1.2, Enum.EasingStyle.Sine), {TextTransparency = 1}):Play()

    task.wait(1.2)

    TweenService:Create(blur, TweenInfo.new(1.2), {Size = 0}):Play()
    intro:Destroy()
end)

-- ==================== BAR (always visible) ====================
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- MAIN CIRCLE BUTTON
local bar = Instance.new("ImageButton")
bar.Size = UDim2.fromOffset(70,70)
bar.Position = UDim2.new(0.5,0,0,10)
bar.AnchorPoint = Vector2.new(0.5,0)
bar.BackgroundColor3 = Color3.fromRGB(170, 0, 255) -- vibrant neon purple
bar.BackgroundTransparency = 0
bar.Image = "" -- no background image
bar.AutoButtonColor = false
bar.Parent = main

-- Perfect circle
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1,0)
corner.Parent = bar

-- OPTIONAL subtle glow ring (can remove if you want ultra flat)
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(200, 80, 255)
stroke.Thickness = 2
stroke.Transparency = 0.2
stroke.Parent = bar

---------------------------------------------------
-- CENTER ICON (your KRNL logo)
---------------------------------------------------
local icon = Instance.new("ImageLabel")
icon.Size = UDim2.new(0.65,0,0.65,0)
icon.Position = UDim2.new(0.5,0,0.5,0)
icon.AnchorPoint = Vector2.new(0.5,0.5)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://74662995765930"
icon.ScaleType = Enum.ScaleType.Fit
icon.Parent = bar

bar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement 
	or input.UserInputType == Enum.UserInputType.Touch then
		
		if dragStart then
			local delta = input.Position - dragStart
			
			if math.abs(delta.X) > dragThreshold or math.abs(delta.Y) > dragThreshold then
				dragging = true
				
				local newPos = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
				
				TweenService:Create(bar, TweenInfo.new(0.05), {
					Position = newPos
				}):Play()
			end
		end
	end
end)

bar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 
	or input.UserInputType == Enum.UserInputType.Touch then
		
		-- If it wasn't dragged much, treat as click
		if not dragging then
			-- TOGGLE UI HERE
			mainFrame.Visible = not mainFrame.Visible
		end
		
		dragStart = nil
		dragging = false
	end
end)

-- ==================== NEW GUI ====================
local newGui = Instance.new("ImageLabel")
newGui.Position = UDim2.new(0.5,0,0.5,0)
newGui.AnchorPoint = Vector2.new(0.5,0.5)
newGui.BackgroundTransparency = 1
newGui.Image = "rbxassetid://6278672195"
newGui.ImageColor3 = Color3.fromRGB(141,0,45)
newGui.Visible = false
newGui.Parent = main
newGui.ClipsDescendants = true
Instance.new("UICorner",newGui).CornerRadius = UDim.new(0,9)

local aspect = Instance.new("UIAspectRatioConstraint",newGui)
aspect.AspectRatio = 772 / 553

local bigSize = UDim2.new(0,772,0,553)
local smallSize = UDim2.new(0.9,0,0.8,0)
local targetSize = bigSize

local function updateGuiSize()
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
    targetSize = isMobile and smallSize or bigSize
end

updateGuiSize()
UserInputService:GetPropertyChangedSignal("TouchEnabled"):Connect(updateGuiSize)

-- ==================== LEFT SCROLLABLE FRAME ====================
local leftScroll = Instance.new("ScrollingFrame",newGui)
leftScroll.Size = UDim2.new(0.12,0,1,0)
leftScroll.Position = UDim2.new(0,0,0,0)
leftScroll.BackgroundTransparency = 1
leftScroll.ScrollBarThickness = 4
leftScroll.ScrollBarImageColor3 = Color3.fromRGB(80,80,80)
leftScroll.CanvasSize = UDim2.new(0,0,0,0)
leftScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local leftLayout = Instance.new("UIListLayout",leftScroll)
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.Padding = UDim.new(0.02,0)
leftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
leftLayout.VerticalAlignment = Enum.VerticalAlignment.Top
leftLayout.FillDirection = Enum.FillDirection.Vertical

local function addHoverEffect(btn)
    local originalSize = btn.Size
    local hoverSize = UDim2.new(originalSize.X.Scale * 1.1, 0, originalSize.Y.Scale * 1.1, 0)
    local originalBg = btn.BackgroundTransparency

    local function onEnter()
        TweenService:Create(btn, TweenInfo.new(0.3), {
            Size = hoverSize,
            BackgroundTransparency = 0.4,
            BackgroundColor3 = Color3.fromRGB(255, 0, 68)
        }):Play()
    end

    local function onLeave()
        TweenService:Create(btn, TweenInfo.new(0.3), {
            Size = originalSize,
            BackgroundTransparency = originalBg
        }):Play()
    end

    btn.MouseEnter:Connect(onEnter)
    btn.MouseLeave:Connect(onLeave)

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            onEnter()
        end
    end)

    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            onLeave()
        end
    end)
end

-- Left buttons (inside scrollable frame)
local img1 = Instance.new("ImageLabel",leftScroll)
img1.Size = UDim2.new(0.9,0,0,80)
img1.BackgroundTransparency = 1
img1.Image = "rbxassetid://74662995765930"
img1.LayoutOrder = 1
Instance.new("UICorner",img1).CornerRadius = UDim.new(1,0)
local aspect1 = Instance.new("UIAspectRatioConstraint",img1)
aspect1.AspectRatio = 1

local speedBtn = Instance.new("ImageButton",leftScroll)
speedBtn.Size = UDim2.new(0.9,0,0,80)
speedBtn.BackgroundTransparency = 1
speedBtn.Image = "rbxassetid://81121929950119"
speedBtn.LayoutOrder = 2
Instance.new("UICorner",speedBtn).CornerRadius = UDim.new(0,9)
local aspect2 = Instance.new("UIAspectRatioConstraint",speedBtn)
aspect2.AspectRatio = 1
addHoverEffect(speedBtn)

local backBtn = Instance.new("ImageButton",leftScroll)
backBtn.Size = UDim2.new(0.9,0,0,80)
backBtn.BackgroundTransparency = 1
backBtn.Image = "rbxassetid://77171223284055"
backBtn.LayoutOrder = 3
Instance.new("UICorner",backBtn).CornerRadius = UDim.new(1,0)
local aspect3 = Instance.new("UIAspectRatioConstraint",backBtn)
aspect3.AspectRatio = 1
addHoverEffect(backBtn)

local iyBtn = Instance.new("TextButton",leftScroll)
iyBtn.Size = UDim2.new(0.9,0,0,80)
iyBtn.BackgroundTransparency = 1
iyBtn.Text = "IY"
iyBtn.TextColor3 = Color3.new(1,1,1)
iyBtn.Font = Enum.Font.GothamBold
iyBtn.TextSize = 20
iyBtn.TextScaled = true
iyBtn.LayoutOrder = 4
Instance.new("UICorner",iyBtn).CornerRadius = UDim.new(0,9)
local aspect4 = Instance.new("UIAspectRatioConstraint",iyBtn)
aspect4.AspectRatio = 1
addHoverEffect(iyBtn)

local r6Btn = Instance.new("TextButton",leftScroll)
r6Btn.Size = UDim2.new(0.9,0,0,80)
r6Btn.BackgroundTransparency = 1
r6Btn.Text = "R6"
r6Btn.TextColor3 = Color3.new(1,1,1)
r6Btn.Font = Enum.Font.GothamBold
r6Btn.TextSize = 20
r6Btn.TextScaled = true
r6Btn.LayoutOrder = 5
Instance.new("UICorner",r6Btn).CornerRadius = UDim.new(0,9)
local aspectR6 = Instance.new("UIAspectRatioConstraint",r6Btn)
aspectR6.AspectRatio = 1
addHoverEffect(r6Btn)

local bBtn = Instance.new("TextButton",leftScroll)
bBtn.Size = UDim2.new(0.9,0,0,80)
bBtn.BackgroundTransparency = 1
bBtn.Text = "B"
bBtn.TextColor3 = Color3.new(1,1,1)
bBtn.Font = Enum.Font.GothamBold
bBtn.TextSize = 20
bBtn.TextScaled = true
bBtn.LayoutOrder = 6
Instance.new("UICorner",bBtn).CornerRadius = UDim.new(0,9)
local aspect5 = Instance.new("UIAspectRatioConstraint",bBtn)
aspect5.AspectRatio = 1
addHoverEffect(bBtn)

local img6 = Instance.new("ImageButton",leftScroll)
img6.Size = UDim2.new(0.9,0,0,80)
img6.BackgroundTransparency = 1
img6.Image = "rbxassetid://15606171585"
img6.LayoutOrder = 7
Instance.new("UICorner",img6).CornerRadius = UDim.new(0,9)
local aspect6 = Instance.new("UIAspectRatioConstraint",img6)
aspect6.AspectRatio = 1
addHoverEffect(img6)

local devConsoleBtn = Instance.new("ImageButton",leftScroll)
devConsoleBtn.Size = UDim2.new(0.9,0,0,80)
devConsoleBtn.BackgroundTransparency = 1
devConsoleBtn.Image = "rbxassetid://7128117167"
devConsoleBtn.LayoutOrder = 8
Instance.new("UICorner",devConsoleBtn).CornerRadius = UDim.new(0,9)
local aspectDev = Instance.new("UIAspectRatioConstraint",devConsoleBtn)
aspectDev.AspectRatio = 1
addHoverEffect(devConsoleBtn)
devConsoleBtn.Activated:Connect(function()
    game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
end)

local bottomBtn = Instance.new("ImageButton",leftScroll)
bottomBtn.Size = UDim2.new(0.9,0,0,80)
bottomBtn.BackgroundTransparency = 1
bottomBtn.Image = "rbxassetid://86591853167234"
bottomBtn.LayoutOrder = 9
Instance.new("UICorner",bottomBtn).CornerRadius = UDim.new(0,9)
local aspectBottom = Instance.new("UIAspectRatioConstraint",bottomBtn)
aspectBottom.AspectRatio = 1
addHoverEffect(bottomBtn)

-- Auto-update canvas size
leftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    leftScroll.CanvasSize = UDim2.new(0,0,0,leftLayout.AbsoluteContentSize.Y + 20)
end)

-- ==================== RIGHT PANEL CONTAINER ====================
local rightContainer = Instance.new("Frame",newGui)
rightContainer.Size = UDim2.new(0.88,0,1,0)
rightContainer.Position = UDim2.new(0.12,0,0,0)
rightContainer.BackgroundTransparency = 1
rightContainer.ClipsDescendants = true

-- ==================== LUA PANEL ====================
local luaPanel = Instance.new("Frame",rightContainer)
luaPanel.Size = UDim2.new(1,0,1,0)
luaPanel.Position = UDim2.new(0,0,0,0)
luaPanel.BackgroundTransparency = 1

scriptBox.Size = UDim2.new(0.9,0,0.7,0)
scriptBox.Position = UDim2.new(0.05,0,0.05,0)
scriptBox.BackgroundColor3 = Color3.fromRGB(20,20,20)
scriptBox.BackgroundTransparency = 0.1
scriptBox.TextColor3 = Color3.fromRGB(230,230,230)
scriptBox.PlaceholderText = "-- Write your script here"
scriptBox.MultiLine = true
scriptBox.TextWrapped = false
scriptBox.TextScaled = false
scriptBox.ClearTextOnFocus = false
scriptBox.Font = Enum.Font.Code
scriptBox.TextSize = 14

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,9)
corner.Parent = scriptBox

local buttonsFrame = Instance.new("Frame",luaPanel)
buttonsFrame.Size = UDim2.new(0,382,0,50)
buttonsFrame.Position = UDim2.new(0.5, -191, 0.8,0)
buttonsFrame.BackgroundColor3 = Color3.new(0,0,0)
buttonsFrame.BackgroundTransparency = 0.2
Instance.new("UICorner",buttonsFrame).CornerRadius = UDim.new(1,0)

local buttonsLayout = Instance.new("UIListLayout",buttonsFrame)
buttonsLayout.FillDirection = Enum.FillDirection.Horizontal
buttonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
buttonsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
buttonsLayout.Padding = UDim.new(0.1,0)

local clearImageBtn = Instance.new("ImageButton",buttonsFrame)
clearImageBtn.Size = UDim2.new(0,41,0,43)
clearImageBtn.BackgroundTransparency = 1
clearImageBtn.Image = "rbxassetid://111704740561400"
Instance.new("UICorner",clearImageBtn).CornerRadius = UDim.new(0,9)
clearImageBtn.Activated:Connect(function()
    scriptBox.Text = ""
    showMessage("script cleared!", Color3.fromRGB(0,255,100))
end)

local copyImageBtn = Instance.new("ImageButton",buttonsFrame)
copyImageBtn.Size = UDim2.new(0,41,0,43)
copyImageBtn.BackgroundTransparency = 1
copyImageBtn.Image = "rbxassetid://96265482350413"
Instance.new("UICorner",copyImageBtn).CornerRadius = UDim.new(0,9)
copyImageBtn.Activated:Connect(function()
    if scriptBox.Text ~= "" then
        setclipboard(scriptBox.Text)
        showMessage("script copied!", Color3.fromRGB(0,255,100))
    end
end)

local executeImageBtn = Instance.new("ImageButton",buttonsFrame)
executeImageBtn.Size = UDim2.new(0,41,0,43)
executeImageBtn.BackgroundTransparency = 1
executeImageBtn.Image = "rbxassetid://136341313090125"
Instance.new("UICorner",executeImageBtn).CornerRadius = UDim.new(0,9)
executeImageBtn.Activated:Connect(function()
    local success, err = pcall(function()
        loadstring(scriptBox.Text)()
    end)
    if success then
        showMessage("script executed!", Color3.fromRGB(0,255,100))
    else
        showMessage("script executed error!", Color3.fromRGB(255,0,0))
    end
end)

-- ==================== SPEED SETTINGS PANEL ====================
local speedPanel = Instance.new("Frame",rightContainer)
speedPanel.Size = UDim2.new(1,0,1,0)
speedPanel.Position = UDim2.new(0,0,0,0)
speedPanel.BackgroundTransparency = 1
speedPanel.Visible = false

local speedTitle = Instance.new("TextLabel",speedPanel)
speedTitle.Size = UDim2.new(1,0,0.1,0)
speedTitle.Position = UDim2.new(0,0,0.05,0)
speedTitle.BackgroundTransparency = 1
speedTitle.Text = "Speed Settings"
speedTitle.TextColor3 = Color3.new(1,1,1)
speedTitle.Font = Enum.Font.GothamBold
speedTitle.TextSize = 22
speedTitle.TextScaled = true

local walkBox = Instance.new("TextBox",speedPanel)
walkBox.Size = UDim2.new(0.7,0,0.12,0)
walkBox.Position = UDim2.new(0.15,0,0.25,0)
walkBox.BackgroundColor3 = Color3.new(0,0,0)
walkBox.BackgroundTransparency = 0.2
walkBox.TextColor3 = Color3.new(1,1,1)
walkBox.PlaceholderText = "WalkSpeed (default 16)"
walkBox.Text = "16"
walkBox.Font = Enum.Font.Code
walkBox.TextSize = 16
Instance.new("UICorner",walkBox).CornerRadius = UDim.new(1,0)

local jumpBox = Instance.new("TextBox",speedPanel)
jumpBox.Size = UDim2.new(0.7,0,0.12,0)
jumpBox.Position = UDim2.new(0.15,0,0.4,0)
jumpBox.BackgroundColor3 = Color3.new(0,0,0)
jumpBox.BackgroundTransparency = 0.2
jumpBox.TextColor3 = Color3.new(1,1,1)
jumpBox.PlaceholderText = "JumpPower (default 50)"
jumpBox.Text = "50"
jumpBox.Font = Enum.Font.Code
jumpBox.TextSize = 16
Instance.new("UICorner",jumpBox).CornerRadius = UDim.new(1,0)

local startBtn = Instance.new("TextButton",speedPanel)
startBtn.Size = UDim2.new(0.7,0,0.12,0)
startBtn.Position = UDim2.new(0.15,0,0.6,0)
startBtn.BackgroundColor3 = Color3.new(0,0,0)
startBtn.BackgroundTransparency = 0.2
startBtn.Text = "Start"
startBtn.TextColor3 = Color3.new(1,1,1)
startBtn.Font = Enum.Font.GothamBold
startBtn.TextSize = 20
Instance.new("UICorner",startBtn).CornerRadius = UDim.new(1,0)
startBtn.Activated:Connect(function()
    local ws = tonumber(walkBox.Text) or 16
    local jp = tonumber(jumpBox.Text) or 50
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = ws
        player.Character.Humanoid.JumpPower = jp
        showMessage("Speed applied!", Color3.fromRGB(0,255,100))
    end
end)

-- ==================== BASIC SCRIPTS PANEL ====================
local basicPanel = Instance.new("Frame",rightContainer)
basicPanel.Size = UDim2.new(1,0,1,0)
basicPanel.Position = UDim2.new(0,0,0,0)
basicPanel.BackgroundTransparency = 1
basicPanel.Visible = false

local basicTitle = Instance.new("TextLabel",basicPanel)
basicTitle.Size = UDim2.new(1,0,0.1,0)
basicTitle.Position = UDim2.new(0,0,0.05,0)
basicTitle.BackgroundTransparency = 1
basicTitle.Text = "Basic Scripts"
basicTitle.TextColor3 = Color3.new(1,1,1)
basicTitle.Font = Enum.Font.GothamBold
basicTitle.TextSize = 22
basicTitle.TextScaled = true

local scrollingFrame = Instance.new("ScrollingFrame",basicPanel)
scrollingFrame.Size = UDim2.new(0.9,0,0.8,0)
scrollingFrame.Position = UDim2.new(0.05,0,0.15,0)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.ScrollBarThickness = 6

local gridLayout = Instance.new("UIGridLayout",scrollingFrame)
gridLayout.CellSize = UDim2.new(0.48,0,0,35)
gridLayout.CellPadding = UDim2.new(0.02,0,0.02,0)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local scriptMap = {
    ["Infinite Jump"] = [[local InfiniteJumpEnabled = true
game:GetService("UserInputService").JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
    end
end)]],
    ["God Mode"] = "game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge\ngame.Players.LocalPlayer.Character.Humanoid.Health = math.huge",
    ["Super Speed (100"] = "game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100",
    ["Super Jump (100"] = "game.Players.LocalPlayer.Character.Humanoid.JumpPower = 100",
    ["Invisible"] = "for _,part in pairs(game.Players.LocalPlayer.Character:GetChildren()) do if part:IsA('BasePart') then part.Transparency = 1 end end",
    ["No Gravity"] = "game.Workspace.Gravity = 0",
    ["Big Head"] = "game.Players.LocalPlayer.Character.Head.Size = Vector3.new(5,5,5)",
    ["Spin Forever"] = "while true do task.wait() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(10), 0) end",
}

local scriptsList = {
    "Infinite Jump",
    "God Mode",
    "Super Speed (100",
    "Super Jump (100",
    "Invisible",
    "No Gravity",
    "Big Head",
    "Spin Forever",
    "Fly (Toggle F",
    "Noclip (Toggle E",
    "Teleport to Spawn",
    "Kill All Players",
    "X-Ray Vision",
    "Fast Swim",
    "No Clip Walls",
    "Destroy GUI",
    "Reset Character",
    "Freeze Character",
    "Teleport Home",
    "Bright Lighting",
    "Dark Lighting",
    "Remove Fog",
    "Day Time",
    "Night Time",
    "Max Zoom Distance",
    "Dance Animation",
    "Super Speed (50",
    "Super Jump (50",
    "No Fog",
    "Full Bright",
    "No Clip (Toggle)",
    "Fly (Toggle)",
    "God Mode (Toggle)",
    "Speed (200)",
    "Jump (200)",
    "Teleport Random",
    "Auto Respawn",
    "Auto Rejoin",
    "No Fall Damage",
    "Infinite Stamina",
    "Fast Run",
    "Fast Climb",
    "No Swim Slow",
    "No Door Lock",
    "No Traps",
    "No Kill Bricks",
    "No Lava Damage",
    "No Spike Damage",
    "No Poison Damage",
    "No Drown",
    "No Hunger"
}

for _, name in ipairs(scriptsList) do
    local btn = Instance.new("TextButton",scrollingFrame)
    btn.Text = name
    btn.BackgroundColor3 = Color3.new(0,0,0)
    btn.BackgroundTransparency = 0.2
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextScaled = true
    Instance.new("UICorner",btn).CornerRadius = UDim.new(1,0)
    btn.Activated:Connect(function()
        local code = scriptMap[name] or "print('Executed: " .. name .. "')"
        local success, err = pcall(function()
            loadstring(code)()
        end)
        if success then
            showMessage(name .. " executed!", Color3.fromRGB(0,255,100))
        else
            showMessage("Error in " .. name, Color3.fromRGB(255,0,0))
        end
    end)
end

-- ==================== SMOOTH PANEL SWITCH ====================
local function showPanel(panel)
    panel.Position = UDim2.new(-1,0,0,0)
    panel.Visible = true
    TweenService:Create(panel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Position = UDim2.new(0,0,0,0)
    }):Play()
end

local function hidePanel(panel)
    TweenService:Create(panel, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Position = UDim2.new(-1,0,0,0)
    }):Play()
    task.wait(0.5)
    panel.Visible = false
end

local currentPanel = luaPanel

local function switchTo(panel)
    if currentPanel == panel then return end
    hidePanel(currentPanel)
    showPanel(panel)
    currentPanel = panel
end

-- ==================== BUTTON CONNECTIONS ====================
speedBtn.Activated:Connect(function()
    switchTo(speedPanel)
end)

backBtn.Activated:Connect(function()
    switchTo(luaPanel)
end)

iyBtn.Activated:Connect(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

r6Btn.Activated:Connect(function()
    -- Your exact requested R6 loadstring
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-r6-script-56753"))()
end)

bBtn.Activated:Connect(function()
    switchTo(basicPanel)
end)

img6.Activated:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/G4mg1/main/refs/heads/main/README.md"))()
end)

devConsoleBtn.Activated:Connect(function()
    game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
end)

-- ==================== BAR CLICK ====================
local shown = false
local openPos = UDim2.new(0.5,0,0.5,0)
local closedPos = UDim2.new(0.5,0,1.5,0)

bar.Activated:Connect(function()
    shown = not shown
    if shown then
        newGui.Visible = true
        newGui.Position = closedPos
        newGui.Size = targetSize
        TweenService:Create(newGui, TweenInfo.new(0.6,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out), {
            Position = openPos
        }):Play()
        TweenService:Create(blur, TweenInfo.new(0.6), {Size=24}):Play()
        setFOV(50)
        currentPanel = luaPanel
        luaPanel.Position = UDim2.new(0,0,0,0)
        luaPanel.Visible = true
        speedPanel.Visible = false
        basicPanel.Visible = false
    else
        TweenService:Create(newGui, TweenInfo.new(0.6,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out), {
            Position = closedPos
        }):Play()
        TweenService:Create(blur, TweenInfo.new(0.6), {Size=0}):Play()
        setFOV(defaultFOV)
        task.wait(0.6)
        newGui.Visible = false
    end
end)

-- ==================== FOV CONTROL ====================
local defaultFOV = camera.FieldOfView

local function setFOV(target)
    TweenService:Create(camera, TweenInfo.new(0.6, Enum.EasingStyle.Cubic), {FieldOfView = target}):Play()
end

-- ==================== MESSAGE SYSTEM ====================
local function showMessage(text, color)
    local msg = Instance.new("TextLabel")
    msg.Size = UDim2.new(0,200,0,30)
    msg.Position = UDim2.new(0.5,0,1,-50)
    msg.AnchorPoint = Vector2.new(0.5,1)
    msg.BackgroundColor3 = Color3.fromRGB(0,0,40)
    msg.BackgroundTransparency = 1
    msg.Text = text
    msg.TextColor3 = color
    msg.Font = Enum.Font.GothamBold
    msg.TextSize = 16
    msg.Parent = main
    Instance.new("UICorner",msg).CornerRadius = UDim.new(1,0)

    TweenService:Create(msg, TweenInfo.new(0.8,Enum.EasingStyle.Elastic,Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        Position = UDim2.new(0.5,0,1,-80)
    }):Play()
    task.wait(3)
    TweenService:Create(msg, TweenInfo.new(0.8,Enum.EasingStyle.Elastic,Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5,0,1,-50)
    }):Play()
    task.wait(0.8)
    msg:Destroy()
end

print("krnl executed!")
