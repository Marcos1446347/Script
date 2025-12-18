-- Usa esse swap e faz mudar o modelo do Slasher para o do Jason

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Killers = ReplicatedStorage.Assets.Killers

local function SwapKiller(fromKiller, toKiller)
local fromFolder = Killers:FindFirstChild(fromKiller)
local toFolder = Killers:FindFirstChild(toKiller)

-- remover antigo    
if fromFolder:FindFirstChild("Config") then fromFolder.Config:Destroy() end    
if fromFolder:FindFirstChild("Behavior") then fromFolder.Behavior:Destroy() end    

-- mover novo    
toFolder.Config.Parent = fromFolder    
toFolder.Behavior.Parent = fromFolder

end

local function Equip(player, killerName)
local equipped = player.PlayerData.Equipped.Killer
equipped.Value = killerName
end

-- Exemplo:
SwapKiller("Slasher", "Jason")
Equip(player, "Jason")

local rigsource = game:GetObjects("rbxassetid://134073307157221")[1]
rigsource.Parent = game.ReplicatedStorage

for i, v in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
	if v:IsA("BasePart") and not v:FindFirstAncestor("Rig") then
		if v.Name ~= "Machete" and v.Name ~= "Chainsaw" then
			v.Transparency = 1
			v.Changed:Connect(function(str)
				if str == "Transparency" then
					v.Transparency = 1
				end
			end)
		end
	end
end
