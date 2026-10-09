-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Prevent Duplicate UI Instances
local existingUI = PlayerGui:FindFirstChild("CryzixBlueUI_Fixed")
if existingUI then
	existingUI:Destroy()
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CryzixBlueUI_Fixed"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Connections Tracker for Clean Unload
local connections = {}

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(11, 15, 25)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -180)
MainFrame.Size = UDim2.new(0, 550, 0, 360)
MainFrame.Active = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(59, 130, 246)
UIStroke.Thickness = 2

----------------------------------------------------
-- DRAGGING MECHANISM (Touch & Mouse Compatible)
----------------------------------------------------
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

table.insert(connections, MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position

		local inputEndedConn
		inputEndedConn = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				inputEndedConn:Disconnect()
			end
		end)
	end
end))

table.insert(connections, MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end))

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateDrag(input)
	end
end))

----------------------------------------------------
-- TOP BAR & SIDEBAR
----------------------------------------------------
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 10)
TopCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Size = UDim2.new(1, -30, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "Cryzix Community - Steal An Egg Hub"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local LeftSidebar = Instance.new("Frame")
LeftSidebar.Name = "LeftSidebar"
LeftSidebar.Parent = MainFrame
LeftSidebar.BackgroundColor3 = Color3.fromRGB(17, 24, 39)
LeftSidebar.Position = UDim2.new(0, 0, 0, 40)
LeftSidebar.Size = UDim2.new(0, 130, 1, -40)

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = LeftSidebar

----------------------------------------------------
-- CONTENT AREA & SCROLLING FRAMES
----------------------------------------------------
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 140, 0, 48)
ContentArea.Size = UDim2.new(1, -150, 1, -55)

local PlayerTab = Instance.new("ScrollingFrame", ContentArea)
local GameTab = Instance.new("ScrollingFrame", ContentArea)
local SettingsTab = Instance.new("ScrollingFrame", ContentArea)

local function setupScrollFrame(frame)
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1
	frame.ScrollBarThickness = 3
	frame.Visible = false
	frame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	frame.CanvasSize = UDim2.new(0, 0, 0, 0)
	
	local layout = Instance.new("UIListLayout")
	layout.Parent = frame
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)
end

setupScrollFrame(PlayerTab)
setupScrollFrame(GameTab)
setupScrollFrame(SettingsTab)

PlayerTab.Visible = true

-- Tab Navigation Setup
local tabs = {
	{Name = "Player", Tab = PlayerTab},
	{Name = "Game", Tab = GameTab},
	{Name = "Settings", Tab = SettingsTab}
}

for i, tabInfo in ipairs(tabs) do
	local btn = Instance.new("TextButton", LeftSidebar)
	btn.Position = UDim2.new(0, 8, 0, 10 + ((i - 1) * 40))
	btn.Size = UDim2.new(1, -16, 0, 32)
	btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(37, 99, 235) or Color3.fromRGB(30, 41, 59)
	btn.Font = Enum.Font.GothamMedium
	btn.Text = tabInfo.Name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 12
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn
	
	table.insert(connections, btn.MouseButton1Click:Connect(function()
		for _, child in ipairs(LeftSidebar:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
			end
		end
		btn.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
		PlayerTab.Visible = false
		GameTab.Visible = false
		SettingsTab.Visible = false
		tabInfo.Tab.Visible = true
	end))
end

----------------------------------------------------
-- 1. PLAYER TAB
----------------------------------------------------
local currentSpeed = 16

local function applySpeed(character, speed)
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = speed
		end
	end
end

-- WalkSpeed Controls
local SpeedFrame = Instance.new("Frame", PlayerTab)
SpeedFrame.Size = UDim2.new(1, -5, 0, 45)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(23, 32, 51)

local SpeedFrameCorner = Instance.new("UICorner")
SpeedFrameCorner.CornerRadius = UDim.new(0, 6)
SpeedFrameCorner.Parent = SpeedFrame

local SpeedLabel = Instance.new("TextLabel", SpeedFrame)
SpeedLabel.Text = "WalkSpeed (1 - 10,000,000):"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Position = UDim2.new(0, 10, 0, 0)
SpeedLabel.Size = UDim2.new(0.65, 0, 1, 0)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 11
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local SpeedInput = Instance.new("TextBox", SpeedFrame)
SpeedInput.Position = UDim2.new(0.68, 0, 0.15, 0)
SpeedInput.Size = UDim2.new(0.28, 0, 0.7, 0)
SpeedInput.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.Text = "16"
SpeedInput.Font = Enum.Font.GothamBold
SpeedInput.TextSize = 12

local SpeedInputCorner = Instance.new("UICorner")
SpeedInputCorner.CornerRadius = UDim.new(0, 4)
SpeedInputCorner.Parent = SpeedInput

table.insert(connections, SpeedInput.FocusLost:Connect(function()
	local val = tonumber(SpeedInput.Text)
	if val then
		currentSpeed = math.clamp(val, 1, 10000000)
		SpeedInput.Text = tostring(currentSpeed)
		applySpeed(LocalPlayer.Character, currentSpeed)
	else
		SpeedInput.Text = tostring(currentSpeed)
	end
end))

table.insert(connections, LocalPlayer.CharacterAdded:Connect(function(newCharacter)
	newCharacter:WaitForChild("Humanoid")
	applySpeed(newCharacter, currentSpeed)
end))

-- Generic Toggle Generator
local function createToggle(parent, text, callback)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1, -5, 0, 38)
	frame.BackgroundColor3 = Color3.fromRGB(23, 32, 51)
	
	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 6)
	frameCorner.Parent = frame

	local label = Instance.new("TextLabel", frame)
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.Size = UDim2.new(0.7, 0, 1, 0)
	label.Font = Enum.Font.Gotham
	label.TextSize = 11
	label.BackgroundTransparency = 1
	label.TextXAlignment = Enum.TextXAlignment.Left

	local toggle = Instance.new("TextButton", frame)
	toggle.Position = UDim2.new(0.72, 0, 0.15, 0)
	toggle.Size = UDim2.new(0.24, 0, 0.7, 0)
	toggle.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggle.Text = "OFF"
	toggle.Font = Enum.Font.GothamBold
	toggle.TextSize = 10
	
	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 4)
	toggleCorner.Parent = toggle

	local state = false
	table.insert(connections, toggle.MouseButton1Click:Connect(function()
		state = not state
		toggle.Text = state and "ON" or "OFF"
		toggle.BackgroundColor3 = state and Color3.fromRGB(37, 99, 235) or Color3.fromRGB(15, 23, 42)
		callback(state)
	end))
end

-- Toggles (Use game's actual remote structures when bound)
createToggle(PlayerTab, "Auto Treadmill (AFK)", function(enabled)
	print("[UI System] Auto Treadmill Toggled:", enabled)
end)

createToggle(PlayerTab, "Auto Upgrade Treadmill", function(enabled)
	print("[UI System] Auto Upgrade Treadmill Toggled:", enabled)
end)

createToggle(PlayerTab, "Auto Upgrade Base", function(enabled)
	print("[UI System] Auto Upgrade Base Toggled:", enabled)
end)

createToggle(PlayerTab, "Auto Steal Egg", function(enabled)
	print("[UI System] Auto Steal Egg Toggled:", enabled)
end)

----------------------------------------------------
-- 2. GAME TAB (LIVE EGG TRACKER)
----------------------------------------------------
-- Header Container
local StatusHeader = Instance.new("Frame", GameTab)
StatusHeader.Size = UDim2.new(1, -5, 0, 50)
StatusHeader.BackgroundColor3 = Color3.fromRGB(23, 32, 51)
local StatusHeaderCorner = Instance.new("UICorner", StatusHeader)
StatusHeaderCorner.CornerRadius = UDim.new(0, 6)

local StatusTitle = Instance.new("TextLabel", StatusHeader)
StatusTitle.Size = UDim2.new(1, -10, 0, 20)
StatusTitle.Position = UDim2.new(0, 8, 0, 4)
StatusTitle.BackgroundTransparency = 1
StatusTitle.Font = Enum.Font.GothamBold
StatusTitle.Text = "Live Status: Available"
StatusTitle.TextColor3 = Color3.fromRGB(59, 130, 246)
StatusTitle.TextSize = 11
StatusTitle.TextXAlignment = Enum.TextXAlignment.Left

local ResetTimerLabel = Instance.new("TextLabel", StatusHeader)
ResetTimerLabel.Size = UDim2.new(1, -10, 0, 20)
ResetTimerLabel.Position = UDim2.new(0, 8, 0, 24)
ResetTimerLabel.BackgroundTransparency = 1
ResetTimerLabel.Font = Enum.Font.Gotham
ResetTimerLabel.Text = "Next Reset Countdown: Synchronizing..."
ResetTimerLabel.TextColor3 = Color3.fromRGB(147, 197, 253)
ResetTimerLabel.TextSize = 10
ResetTimerLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Container for Dynamic Live Eggs List
local EggContainer = Instance.new("Frame", GameTab)
EggContainer.Size = UDim2.new(1, -5, 0, 0)
EggContainer.BackgroundTransparency = 1
EggContainer.AutomaticSize = Enum.AutomaticSize.Y

local EggListLayout = Instance.new("UIListLayout", EggContainer)
EggListLayout.SortOrder = Enum.SortOrder.LayoutOrder
EggListLayout.Padding = UDim.new(0, 6)

-- Baseline Egg Catalog Data
local baseCatalog = {
	["Golden Egg"] = {Price = "$100,000", Pet = "Dragon", Rarity = "Legendary"},
	["Ice Egg"] = {Price = "$50,000", Pet = "Ice Wolf", Rarity = "Rare"},
	["Volcano Egg"] = {Price = "$25,000", Pet = "Phoenix", Rarity = "Epic"},
	["Forest Egg"] = {Price = "$10,000", Pet = "Bear", Rarity = "Common"}
}

local activeEggFrames = {}

local function createEggCard(name, price, pet, rarity)
	local card = Instance.new("Frame", EggContainer)
	card.Size = UDim2.new(1, 0, 0, 40)
	card.BackgroundColor3 = Color3.fromRGB(23, 32, 51)
	
	local cardCorner = Instance.new("UICorner", card)
	cardCorner.CornerRadius = UDim.new(0, 6)

	local title = Instance.new("TextLabel", card)
	title.Position = UDim2.new(0, 8, 0, 4)
	title.Size = UDim2.new(0.6, 0, 0, 16)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.Text = name .. " (" .. rarity .. ")"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 11
	title.TextXAlignment = Enum.TextXAlignment.Left

	local details = Instance.new("TextLabel", card)
	details.Position = UDim2.new(0, 8, 0, 20)
	details.Size = UDim2.new(0.9, 0, 0, 16)
	details.BackgroundTransparency = 1
	details.Font = Enum.Font.Gotham
	details.Text = "Price: " .. price .. " | Pet: " .. pet
	details.TextColor3 = Color3.fromRGB(147, 197, 253)
	details.TextSize = 10
	details.TextXAlignment = Enum.TextXAlignment.Left

	return card
end

-- Refresh Live Egg Tracker
local function refreshEggTracker()
	for _, frame in pairs(activeEggFrames) do
		frame:Destroy()
	end
	table.clear(activeEggFrames)

	-- Search Workspace dynamically for spawned egg instances or fall back to base catalog
	local workspaceEggs = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("SpawnedEggs")
	local foundAny = false

	if workspaceEggs then
		for _, eggObj in ipairs(workspaceEggs:GetChildren()) do
			foundAny = true
			local eggName = eggObj.Name
			local info = baseCatalog[eggName] or {Price = "Dynamic", Pet = "Unknown", Rarity = "Special"}
			activeEggFrames[eggName] = createEggCard(eggName, info.Price, info.Pet, info.Rarity)
		end
	end

	if not foundAny then
		-- Render base catalog if workspace instances are not direct children
		for eggName, info in pairs(baseCatalog) do
			activeEggFrames[eggName] = createEggCard(eggName, info.Price, info.Pet, info.Rarity)
		end
	end
end

refreshEggTracker()

-- Automatically listen for egg additions/deletions in workspace
local workspaceEggs = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("SpawnedEggs")
if workspaceEggs then
	table.insert(connections, workspaceEggs.ChildAdded:Connect(refreshEggTracker))
	table.insert(connections, workspaceEggs.ChildRemoved:Connect(refreshEggTracker))
end

-- Live Time Sync for Night Reset Timer (Detects game ValueObjects if present)
table.insert(connections, RunService.Heartbeat:Connect(function()
	local timerValue = ReplicatedStorage:FindFirstChild("NightResetTime") or workspace:FindFirstChild("NightResetTime")
	if timerValue and timerValue:IsA("IntValue") or (timerValue and timerValue:IsA("NumberValue")) then
		ResetTimerLabel.Text = "Next Reset Countdown: " .. tostring(timerValue.Value) .. "s"
	else
		ResetTimerLabel.Text = "Next Reset Countdown: Active Cycle"
	end
end))

----------------------------------------------------
-- 3. SETTINGS TAB & CLEANUP
----------------------------------------------------
local UnloadBtn = Instance.new("TextButton", SettingsTab)
UnloadBtn.Size = UDim2.new(1, -5, 0, 36)
UnloadBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
UnloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UnloadBtn.Text = "Close / Unload UI"
UnloadBtn.Font = Enum.Font.GothamBold
UnloadBtn.TextSize = 11

local UnloadBtnCorner = Instance.new("UICorner")
UnloadBtnCorner.CornerRadius = UDim.new(0, 6)
UnloadBtnCorner.Parent = UnloadBtn

table.insert(connections, UnloadBtn.MouseButton1Click:Connect(function()
	for _, conn in ipairs(connections) do
		if conn and conn.Connected then
			conn:Disconnect()
		end
	end
	table.clear(connections)
	ScreenGui:Destroy()
end))
