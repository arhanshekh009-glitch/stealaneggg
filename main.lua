-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Prevent Duplicate UI
local existingUI = PlayerGui:FindFirstChild("CryzixBlueUI_Ultimate")
if existingUI then
	existingUI:Destroy()
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CryzixBlueUI_Ultimate"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local connections = {}

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 14, 23)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -180)
MainFrame.Size = UDim2.new(0, 550, 0, 360)
MainFrame.Active = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Color = Color3.fromRGB(59, 130, 246)
UIStroke.Thickness = 2

----------------------------------------------------
-- FLOATING RE-OPEN ICON (🥚)
----------------------------------------------------
local OpenIcon = Instance.new("TextButton")
OpenIcon.Name = "OpenIcon"
OpenIcon.Parent = ScreenGui
OpenIcon.Size = UDim2.new(0, 48, 0, 48)
OpenIcon.Position = UDim2.new(0.02, 0, 0.25, 0)
OpenIcon.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
OpenIcon.Text = "🥚"
OpenIcon.TextSize = 24
OpenIcon.Visible = false
OpenIcon.Active = true

local IconCorner = Instance.new("UICorner", OpenIcon)
IconCorner.CornerRadius = UDim.new(0, 12)

local IconStroke = Instance.new("UIStroke", OpenIcon)
IconStroke.Color = Color3.fromRGB(59, 130, 246)
IconStroke.Thickness = 2

-- Icon Draggable Engine
local iconDragging, iconDragStart, iconStartPos
table.insert(connections, OpenIcon.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		iconDragging = true
		iconDragStart = input.Position
		iconStartPos = OpenIcon.Position
	end
end))

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
	if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - iconDragStart
		OpenIcon.Position = UDim2.new(iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X, iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y)
	end
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		iconDragging = false
	end
end))

table.insert(connections, OpenIcon.MouseButton1Click:Connect(function()
	MainFrame.Visible = true
	OpenIcon.Visible = false
end))

----------------------------------------------------
-- MAIN FRAME DRAGGING MECHANISM
----------------------------------------------------
local dragging, dragStart, startPos
table.insert(connections, MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end))

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end))

----------------------------------------------------
-- TOP BAR & SIDEBAR
----------------------------------------------------
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Name = "TopBar"
TopBar.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
TopBar.Size = UDim2.new(1, 0, 0, 40)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Size = UDim2.new(1, -90, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "⚡ Cryzix Hub - Steal An Egg"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local MinimizeBtn = Instance.new("TextButton", TopBar)
MinimizeBtn.Size = UDim2.new(0, 32, 0, 26)
MinimizeBtn.Position = UDim2.new(1, -40, 0, 7)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

table.insert(connections, MinimizeBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	OpenIcon.Visible = true
end))

local LeftSidebar = Instance.new("Frame", MainFrame)
LeftSidebar.Name = "LeftSidebar"
LeftSidebar.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
LeftSidebar.Position = UDim2.new(0, 0, 0, 40)
LeftSidebar.Size = UDim2.new(0, 130, 1, -40)
Instance.new("UICorner", LeftSidebar).CornerRadius = UDim.new(0, 10)

----------------------------------------------------
-- CONTENT & TABS
----------------------------------------------------
local ContentArea = Instance.new("Frame", MainFrame)
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
	
	local layout = Instance.new("UIListLayout", frame)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 8)
end

setupScrollFrame(PlayerTab)
setupScrollFrame(GameTab)
setupScrollFrame(SettingsTab)

PlayerTab.Visible = true

local tabs = {
	{Name = "Player 👤", Tab = PlayerTab},
	{Name = "Game 🎮", Tab = GameTab},
	{Name = "Settings ⚙️", Tab = SettingsTab}
}

for i, tabInfo in ipairs(tabs) do
	local btn = Instance.new("TextButton", LeftSidebar)
	btn.Position = UDim2.new(0, 8, 0, 10 + ((i - 1) * 40))
	btn.Size = UDim2.new(1, -16, 0, 32)
	btn.BackgroundColor3 = (i == 1) and Color3.fromRGB(37, 99, 235) or Color3.fromRGB(30, 41, 59)
	btn.Font = Enum.Font.GothamMedium
	btn.Text = tabInfo.Name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 11
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	
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

local SpeedFrame = Instance.new("Frame", PlayerTab)
SpeedFrame.Size = UDim2.new(1, -5, 0, 45)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
Instance.new("UICorner", SpeedFrame).CornerRadius = UDim.new(0, 6)

local SpeedLabel = Instance.new("TextLabel", SpeedFrame)
SpeedLabel.Text = "WalkSpeed (1 - 10,000,000):"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.Position = UDim2.new(0, 10, 0, 0)
SpeedLabel.Size = UDim2.new(0.6, 0, 1, 0)
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.TextSize = 11
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left

local SpeedInput = Instance.new("TextBox", SpeedFrame)
SpeedInput.Position = UDim2.new(0.65, 0, 0.15, 0)
SpeedInput.Size = UDim2.new(0.3, 0, 0.7, 0)
SpeedInput.BackgroundColor3 = Color3.fromRGB(37, 99, 235)
SpeedInput.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedInput.Text = "16"
SpeedInput.Font = Enum.Font.GothamBold
SpeedInput.TextSize = 11
Instance.new("UICorner", SpeedInput).CornerRadius = UDim.new(0, 4)

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

-- Working Toggle Loops
local function createToggle(parent, text, loopFunc)
	local frame = Instance.new("Frame", parent)
	frame.Size = UDim2.new(1, -5, 0, 38)
	frame.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

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
	Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 4)

	local state = false
	local thread = nil

	table.insert(connections, toggle.MouseButton1Click:Connect(function()
		state = not state
		toggle.Text = state and "ON" or "OFF"
		toggle.BackgroundColor3 = state and Color3.fromRGB(37, 99, 235) or Color3.fromRGB(15, 23, 42)

		if state then
			thread = task.spawn(function()
				while state do
					pcall(loopFunc)
					task.wait(0.3)
				end
			end)
		else
			if thread then
				task.cancel(thread)
				thread = nil
			end
		end
	end))
end

createToggle(PlayerTab, "Auto Treadmill (AFK)", function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		for _, folderName in ipairs({"Treadmills", "Treadmill", "Bases"}) do
			local targetFolder = workspace:FindFirstChild(folderName)
			if targetFolder then
				local part = targetFolder:FindFirstChildWhichIsA("BasePart", true)
				if part then
					firetouchinterest(char.HumanoidRootPart, part, 0)
					task.wait(0.05)
					firetouchinterest(char.HumanoidRootPart, part, 1)
				end
			end
		end
	end
end)

createToggle(PlayerTab, "Auto Upgrade Treadmill", function()
	for _, remoteName in ipairs({"UpgradeTreadmill", "TreadmillUpgrade", "BuyTreadmill"}) do
		local remote = ReplicatedStorage:FindFirstChild(remoteName, true)
		if remote and remote:IsA("RemoteEvent") then
			remote:FireServer()
		end
	end
end)

createToggle(PlayerTab, "Auto Upgrade Base", function()
	for _, remoteName in ipairs({"UpgradeBase", "BaseUpgrade", "BuyBase"}) do
		local remote = ReplicatedStorage:FindFirstChild(remoteName, true)
		if remote and remote:IsA("RemoteEvent") then
			remote:FireServer()
		end
	end
end)

createToggle(PlayerTab, "Auto Steal Egg", function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		local eggFolder = workspace:FindFirstChild("Eggs") or workspace:FindFirstChild("SpawnedEggs") or workspace:FindFirstChild("EggSpawns")
		if eggFolder then
			for _, egg in ipairs(eggFolder:GetChildren()) do
				local part = egg:IsA("BasePart") and egg or egg:FindFirstChildWhichIsA("BasePart", true)
				if part then
					char.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
					firetouchinterest(char.HumanoidRootPart, part, 0)
					task.wait(0.05)
					firetouchinterest(char.HumanoidRootPart, part, 1)
					break
				end
			end
		end
	end
end)

----------------------------------------------------
-- 2. GAME TAB (LIVE EGG & ANIMAL RENDER)
----------------------------------------------------
local Header = Instance.new("Frame", GameTab)
Header.Size = UDim2.new(1, -5, 0, 42)
Header.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 6)

local HeaderTitle = Instance.new("TextLabel", Header)
HeaderTitle.Size = UDim2.new(1, -10, 1, 0)
HeaderTitle.Position = UDim2.new(0, 8, 0, 0)
HeaderTitle.BackgroundTransparency = 1
HeaderTitle.Font = Enum.Font.GothamBold
HeaderTitle.Text = "🌙 Night Reset Tracker & Live Egg Stats"
HeaderTitle.TextColor3 = Color3.fromRGB(59, 130, 246)
HeaderTitle.TextSize = 11
HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left

local EggContainer = Instance.new("Frame", GameTab)
EggContainer.Size = UDim2.new(1, -5, 0, 0)
EggContainer.BackgroundTransparency = 1
EggContainer.AutomaticSize = Enum.AutomaticSize.Y

local EggLayout = Instance.new("UIListLayout", EggContainer)
EggLayout.SortOrder = Enum.SortOrder.LayoutOrder
EggLayout.Padding = UDim.new(0, 6)

-- Custom Catalog Data
local catalog = {
	{Name = "Golden Egg 🥚", Price = "$100,000", Animal = "Dragon 🐉", Rarity = "Legendary"},
	{Name = "Ice Egg 🧊", Price = "$50,000", Animal = "Ice Wolf 🐺", Rarity = "Rare"},
	{Name = "Volcano Egg 🌋", Price = "$25,000", Animal = "Phoenix 🦅", Rarity = "Epic"},
	{Name = "Forest Egg 🌲", Price = "$10,000", Animal = "Bear 🐻", Rarity = "Common"}
}

for _, item in ipairs(catalog) do
	local card = Instance.new("Frame", EggContainer)
	card.Size = UDim2.new(1, 0, 0, 48)
	card.BackgroundColor3 = Color3.fromRGB(20, 30, 50)
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

	local title = Instance.new("TextLabel", card)
	title.Position = UDim2.new(0, 10, 0, 6)
	title.Size = UDim2.new(0.9, 0, 0, 18)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.Text = item.Name .. " [" .. item.Rarity .. "]"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.TextSize = 11
	title.TextXAlignment = Enum.TextXAlignment.Left

	local details = Instance.new("TextLabel", card)
	details.Position = UDim2.new(0, 10, 0, 24)
	details.Size = UDim2.new(0.9, 0, 0, 18)
	details.BackgroundTransparency = 1
	details.Font = Enum.Font.Gotham
	details.Text = "Reward: " .. item.Price .. "  |  Pet: " .. item.Animal
	details.TextColor3 = Color3.fromRGB(147, 197, 253)
	details.TextSize = 10
	details.TextXAlignment = Enum.TextXAlignment.Left
end

----------------------------------------------------
-- 3. SETTINGS TAB
----------------------------------------------------
local UnloadBtn = Instance.new("TextButton", SettingsTab)
UnloadBtn.Size = UDim2.new(1, -5, 0, 36)
UnloadBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
UnloadBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UnloadBtn.Text = "Destroy / Unload UI"
UnloadBtn.Font = Enum.Font.GothamBold
UnloadBtn.TextSize = 11
Instance.new("UICorner", UnloadBtn).CornerRadius = UDim.new(0, 6)

table.insert(connections, UnloadBtn.MouseButton1Click:Connect(function()
	for _, conn in ipairs(connections) do
		if conn and conn.Connected then
			conn:Disconnect()
		end
	end
	table.clear(connections)
	ScreenGui:Destroy()
end))
