-- c00lhub1!1!1! MOBILE FULL HUB

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-------------------------------------------------
-- GUI
-------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "c00lhubFull"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-------------------------------------------------
-- LOADING
-------------------------------------------------
local loading = Instance.new("Frame", gui)
loading.Size = UDim2.fromScale(0.8,0.18)
loading.Position = UDim2.fromScale(0.1,0.41)
loading.BackgroundColor3 = Color3.fromRGB(20,20,20)
loading.BorderSizePixel = 0
Instance.new("UICorner", loading).CornerRadius = UDim.new(0,18)

local ltitle = Instance.new("TextLabel", loading)
ltitle.Size = UDim2.new(1,0,0.45,0)
ltitle.BackgroundTransparency = 1
ltitle.Text = "Loading c00lhub1!1!1!"
ltitle.TextColor3 = Color3.fromRGB(255,0,0)
ltitle.Font = Enum.Font.GothamBlack
ltitle.TextScaled = true

local barBG = Instance.new("Frame", loading)
barBG.Position = UDim2.fromScale(0.05,0.65)
barBG.Size = UDim2.fromScale(0.9,0.18)
barBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
barBG.BorderSizePixel = 0
Instance.new("UICorner", barBG).CornerRadius = UDim.new(1,0)

local bar = Instance.new("Frame", barBG)
bar.Size = UDim2.fromScale(0,1)
bar.BackgroundColor3 = Color3.fromRGB(255,0,0)
bar.BorderSizePixel = 0
Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

for i = 1,100 do
	bar.Size = UDim2.fromScale(i/100,1)
	task.wait(0.02)
end

loading:Destroy()

-------------------------------------------------
-- MAIN HUB
-------------------------------------------------
local hubFrame = Instance.new("Frame", gui)
hubFrame.Size = UDim2.fromScale(0.9,0.85)
hubFrame.Position = UDim2.fromScale(0.05,0.1)
hubFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
hubFrame.BorderSizePixel = 0
Instance.new("UICorner", hubFrame).CornerRadius = UDim.new(0,22)

-- DRAG (MOBILE)
local dragging, dragStart, startPos
hubFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = hubFrame.Position
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.Touch then
		local delta = input.Position - dragStart
		hubFrame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end
end)

-- TITLE
local title = Instance.new("TextLabel", hubFrame)
title.Size = UDim2.new(1,0,0.08,0)
title.BackgroundTransparency = 1
title.Text = "c00lhub1!1!1!"
title.TextColor3 = Color3.fromRGB(255,0,0)
title.Font = Enum.Font.GothamBlack
title.TextScaled = true

-------------------------------------------------
-- FLOATING BUTTON
-------------------------------------------------
local floatBtn = Instance.new("TextButton", gui)
floatBtn.Size = UDim2.fromScale(0.15,0.07)
floatBtn.Position = UDim2.fromScale(0.8,0.02)
floatBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
floatBtn.Text = "c00lhub"
floatBtn.TextColor3 = Color3.fromRGB(255,255,255)
floatBtn.Font = Enum.Font.GothamBlack
floatBtn.TextScaled = true
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0,12)

local hubVisible = true
floatBtn.MouseButton1Click:Connect(function()
	hubVisible = not hubVisible
	hubFrame.Visible = hubVisible
end)

-------------------------------------------------
-- STATES
-------------------------------------------------
local states = {
	Speed = false,
	InfJump = false,
	AutoFarm = false,
	ESP = false
}

local speedOff = 16
local speedOn = 32

-------------------------------------------------
-- TOGGLES
-------------------------------------------------
local function createToggle(text, y, callback)
	local btn = Instance.new("TextButton", hubFrame)
	btn.Size = UDim2.fromScale(0.9,0.08)
	btn.Position = UDim2.fromScale(0.05,y)
	btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
	btn.BorderSizePixel = 0
	btn.Text = text.." [OFF]"
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextScaled = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,16)

	local on = false
	btn.MouseButton1Click:Connect(function()
		on = not on
		btn.Text = text.." ["..(on and "ON" or "OFF").."]"
		btn.BackgroundColor3 = on and Color3.fromRGB(255,0,0) or Color3.fromRGB(35,35,35)
		callback(on)
	end)
end

-- SPEEDHACK TOGGLE
createToggle("Speed Hack",0.10,function(v)
	states.Speed = v
	humanoid.WalkSpeed = v and speedOn or speedOff
end)

-- INFINITE JUMP
UIS.JumpRequest:Connect(function()
	if states.InfJump then
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end
end)
createToggle("Infinite Jump",0.18,function(v)
	states.InfJump = v
end)

-- AUTO FARM
task.spawn(function()
	while true do
		if states.AutoFarm and character:FindFirstChild("HumanoidRootPart") then
			character.HumanoidRootPart.CFrame *= CFrame.new(0,0,-2)
		end
		task.wait(0.1)
	end
end)
createToggle("Auto Farm",0.26,function(v)
	states.AutoFarm = v
end)

-- ESP
local espPlayers = {}
local function createESP(plr)
	if plr == player then return end
	local char = plr.Character
	if not char then return end

	local highlight = Instance.new("Highlight")
	highlight.FillColor = Color3.fromRGB(255,0,0)
	highlight.OutlineColor = Color3.fromRGB(255,255,255)
	highlight.Parent = char

	local billboard = Instance.new("BillboardGui", char)
	billboard.Size = UDim2.new(0,180,0,50)
	billboard.StudsOffset = Vector3.new(0,3,0)
	billboard.AlwaysOnTop = true

	local label = Instance.new("TextLabel", billboard)
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255,0,0)
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.TextWrapped = true

	return {highlight=highlight, label=label, plr=plr}
end

local function updateESP()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= player then
			if states.ESP then
				if not espPlayers[plr] then
					espPlayers[plr] = createESP(plr)
				end
			else
				if espPlayers[plr] then
					if espPlayers[plr].highlight then espPlayers[plr].highlight:Destroy() end
					if espPlayers[plr].label then espPlayers[plr].label.Parent:Destroy() end
					espPlayers[plr] = nil
				end
			end
		end
	end
end

createToggle("ESP",0.34,function(v)
	states.ESP = v
	updateESP()
end)

RunService.RenderStepped:Connect(function()
	if states.ESP then
		for plr,data in pairs(espPlayers) do
			if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
				local hum = plr.Character:FindFirstChild("Humanoid")
				local hrp = plr.Character.HumanoidRootPart
				if hum and hrp then
					local dist = math.floor((hrp.Position - character.HumanoidRootPart.Position).Magnitude)
					data.label.Text = plr.Name.." | HP: "..math.floor(hum.Health).."/"..math.floor(hum.MaxHealth).." | "..dist.." studs"
				end
			end
		end
	end
end)

-------------------------------------------------
-- SPEED OFF/ON TEXTBOX
-------------------------------------------------
local speedOffBox = Instance.new("TextBox", hubFrame)
speedOffBox.Size = UDim2.fromScale(0.42,0.06)
speedOffBox.Position = UDim2.fromScale(0.05,0.42)
speedOffBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
speedOffBox.Text = "Speed OFF (16)"
speedOffBox.TextColor3 = Color3.fromRGB(255,255,255)
speedOffBox.Font = Enum.Font.GothamBold
speedOffBox.TextScaled = true
Instance.new("UICorner", speedOffBox).CornerRadius = UDim.new(0,12)

speedOffBox.FocusLost:Connect(function()
	local v = tonumber(speedOffBox.Text)
	if v then
		speedOff = v
		if not states.Speed then humanoid.WalkSpeed = speedOff end
	end
end)

local speedOnBox = Instance.new("TextBox", hubFrame)
speedOnBox.Size = UDim2.fromScale(0.42,0.06)
speedOnBox.Position = UDim2.fromScale(0.53,0.42)
speedOnBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
speedOnBox.Text = "Speed ON (32)"
speedOnBox.TextColor3 = Color3.fromRGB(255,255,255)
speedOnBox.Font = Enum.Font.GothamBold
speedOnBox.TextScaled = true
Instance.new("UICorner", speedOnBox).CornerRadius = UDim.new(0,12)

speedOnBox.FocusLost:Connect(function()
	local v = tonumber(speedOnBox.Text)
	if v then
		speedOn = v
		if states.Speed then humanoid.WalkSpeed = speedOn end
	end
end)

-------------------------------------------------
-- Survivor/Killer SELECT
-------------------------------------------------
local selectedType = nil

local survivorBtn = Instance.new("TextButton", hubFrame)
survivorBtn.Size = UDim2.fromScale(0.42,0.06)
survivorBtn.Position = UDim2.fromScale(0.05,0.52)
survivorBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
survivorBtn.Text = "Survivor"
survivorBtn.TextColor3 = Color3.fromRGB(255,255,255)
survivorBtn.Font = Enum.Font.GothamBlack
survivorBtn.TextScaled = true
Instance.new("UICorner", survivorBtn).CornerRadius = UDim.new(0,12)

survivorBtn.MouseButton1Click:Connect(function()
	selectedType = "Survivor"
	print("Modo Survivor selecionado")
end)

local killerBtn = Instance.new("TextButton", hubFrame)
killerBtn.Size = UDim2.fromScale(0.42,0.06)
killerBtn.Position = UDim2.fromScale(0.53,0.52)
killerBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
killerBtn.Text = "Killer"
killerBtn.TextColor3 = Color3.fromRGB(255,255,255)
killerBtn.Font = Enum.Font.GothamBlack
killerBtn.TextScaled = true
Instance.new("UICorner", killerBtn).CornerRadius = UDim.new(0,12)

killerBtn.MouseButton1Click:Connect(function()
	selectedType = "Killer"
	print("Modo Killer selecionado")
end)

-- Character name textbox
local charNameBox = Instance.new("TextBox", hubFrame)
charNameBox.Size = UDim2.fromScale(0.9,0.06)
charNameBox.Position = UDim2.fromScale(0.05,0.60)
charNameBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
charNameBox.PlaceholderText = "Que Survivor/Killer?"
charNameBox.Text = ""
charNameBox.TextColor3 = Color3.fromRGB(255,255,255)
charNameBox.Font = Enum.Font.GothamBold
charNameBox.TextScaled = true
Instance.new("UICorner", charNameBox).CornerRadius = UDim.new(0,12)

-- Confirm button
local confirmBtn = Instance.new("TextButton", hubFrame)
confirmBtn.Size = UDim2.fromScale(0.9,0.06)
confirmBtn.Position = UDim2.fromScale(0.05,0.68)
confirmBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
confirmBtn.Text = "Confirmar"
confirmBtn.TextColor3 = Color3.fromRGB(0,0,0)
confirmBtn.Font = Enum.Font.GothamBlack
confirmBtn.TextScaled = true
Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0,12)

confirmBtn.MouseButton1Click:Connect(function()
	if not selectedType then
		warn("Selecione Survivor ou Killer primeiro!")
		return
	end

	local assets = ReplicatedStorage:FindFirstChild("Assets")
	if not assets then return warn("Assets não encontrado") end

	-- Seleciona automaticamente a pasta correta
	local folder
	if selectedType == "Survivor" then
		folder = assets:FindFirstChild("Survivors") or assets:FindFirstChild("Survvors")
	elseif selectedType == "Killer" then
		folder = assets:FindFirstChild("Killers")
	end

	if not folder then
		warn(selectedType.." pasta não encontrada!")
		return
	end

	local charName = charNameBox.Text
	local charFolder = folder:FindFirstChild(charName)
	if not charFolder then
		warn(charName.." não encontrado na pasta "..selectedType)
		return
	end

	print("Selecionado "..selectedType..": "..charName)

	local config = charFolder:FindFirstChild("Config")
	if not config or not config:IsA("ModuleScript") then
		warn("ModuleScript Config não encontrado")
		return
	end

	local confTable = require(config)

	local speedVal = tonumber(speedOnBox.Text)
	if speedVal then
		if confTable["SprintSpeed"] ~= nil then
			confTable["SprintSpeed"] = speedVal
			print("SprintSpeed atualizado para: "..speedVal)
		else
			warn("SprintSpeed não encontrado no Config")
		end
	else
		warn("Speed ON textbox não contém número válido")
	end
end)
