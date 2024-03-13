local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local plr = game:GetService("Players")
local lplr = plr.LocalPlayer
local repstorage = game:GetService("ReplicatedStorage")
game:GetService("Teams")
local roles
function IsAlive(Player) -- kelve123
	for i, v in pairs(roles) do
		if Player.Name == i then
			if not v.Killed and not v.Dead then
				return true
			else
				return false
			end
		end
	end
end
local function mm2_esp()
	-- Original by kelve123 on GitHub, some fixes are made by kevin3050tit2
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local LP = Players.LocalPlayer

	-- > Functions <--

	function CreateHighlight() -- make any new highlights for new players
		for i, v in pairs(Players:GetChildren()) do
			if v ~= LP and v.Character and not v.Character:FindFirstChild("Highlight") then
				Instance.new("Highlight", v.Character)           
			end
		end
	end

	function UpdateHighlights() -- Get Current Role Colors (messy)
		for _, v in pairs(Players:GetChildren()) do
			if v ~= LP and v.Character and v.Character:FindFirstChild("Highlight") then
				Highlight = v.Character:FindFirstChild("Highlight")
				if v.Name == Sheriff and IsAlive(v) then
					Highlight.FillColor = Color3.fromRGB(0, 0, 225)
				elseif v.Name == Murder and IsAlive(v) then
					Highlight.FillColor = Color3.fromRGB(225, 0, 0)
				elseif v.Name == Hero and IsAlive(v) and not IsAlive(game.Players[Sheriff]) then
					Highlight.FillColor = Color3.fromRGB(255, 250, 0)
				elseif IsAlive(v) then
					Highlight.FillColor = Color3.fromRGB(0, 225, 0)
				else
					Highlight.FillColor = Color3.fromRGB(143, 143, 143)
				end
			end
		end
	end	


	-- > Loops < --

	RunService:BindToRenderStep("MainGUI", Enum.RenderPriority.Camera, function()
		roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
		for i, v in pairs(roles) do
			if v.Role == "Murderer" then
				Murder = i
			elseif v.Role == 'Sheriff'then
				Sheriff = i
			elseif v.Role == 'Hero'then
				Hero = i
			end
		end
		CreateHighlight()
		UpdateHighlights()
	end)


end

-- Powered by Rayfield UI lib
local Window = Rayfield:CreateWindow({
	Name = "Raycast",
	LoadingTitle = "Welcome to Raycast!",
	LoadingSubtitle = "version 1",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil, -- Create a custom folder for your hub/game
		FileName = "mmrc"
	},
	Discord = {
		Enabled = false,
		Invite = "sirius", -- The Discord invite code, do not include discord.gg/
		RememberJoins = true -- Set this to false to make them join the discord every time they load it up
	},
	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
		Title = "Sirius Hub",
		Subtitle = "Key System",
		Note = "Join the discord (discord.gg/sirius)",
		FileName = "SiriusKey",
		SaveKey = true,
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = "Hello"
	}
})
local vim = game:GetService("VirtualInputManager")
local Tab = Window:CreateTab("Main", 4483362458) -- Title, Image
local Section = Tab:CreateSection("Round")
local killallmurd = Tab:CreateButton({
	Name = "Kill all (Murderer)",
	Callback = function(Value)
		if Value then
			if lplr.Backpack:FindFirstChild("Knife") or lplr.Character:FindFirstChild("Knife") then
				pcall(function()
					lplr.Backpack:FindFirstChild("Knife").Parent = lplr.Character
				end)
				roles = repstorage:FindFirstChild("GetPlayerData", true):InvokeServer()
				while task.wait() do
					for i, v in pairs(game:GetService("Players"):GetPlayers()) do
						if IsAlive(v) then
							v.Character.HumanoidRootPart.CFrame = lplr.Character.HumanoidRootPart
							vim:SendMouseButtonEvent(0,0,0,true,game,false,0)
							task.wait()
							vim:SendMouseButtonEvent(0,0,0,false,game,false,0)
							task.wait(.3)
							roles = repstorage:FindFirstChild("GetPlayerData", true):InvokeServer()
							if not lplr.Backpack:FindFirstChild("Knife") or not lplr.Character:FindFirstChild("Knife") then
								break
							end
						end
					end
				end
			end
		end
	end})
local Flingie = false
local SkidFling = function(TargetPlayer)
	local Character = lplr.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local RootPart = Humanoid and Humanoid.RootPart

	local TCharacter = TargetPlayer.Character
	local THumanoid
	local TRootPart
	local THead
	local Accessory
	local Handle

	if TCharacter:FindFirstChildOfClass("Humanoid") then
		THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
	end
	if THumanoid and THumanoid.RootPart then
		TRootPart = THumanoid.RootPart
	end
	if TCharacter:FindFirstChild("Head") then
		THead = TCharacter.Head
	end
	if TCharacter:FindFirstChildOfClass("Accessory") then
		Accessory = TCharacter:FindFirstChildOfClass("Accessory")
	end
	if Accessory and Accessory:FindFirstChild("Handle") then
		Handle = Accessory.Handle
	end

	if Character and Humanoid and RootPart then
		if RootPart.Velocity.Magnitude < 50 then
			getgenv().OldPos = RootPart.CFrame
		end
		if THumanoid and THumanoid.Sit and not Flingie then
			return
		end
		if THead then
			workspace.CurrentCamera.CameraSubject = THead
		elseif not THead and Handle then
			workspace.CurrentCamera.CameraSubject = Handle
		elseif THumanoid and TRootPart then
			workspace.CurrentCamera.CameraSubject = THumanoid
		end
		if not TCharacter:FindFirstChildWhichIsA("BasePart") then
			return
		end

		local FPos = function(BasePart, Pos, Ang)
			RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
			Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
			RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
			RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
		end

		local SFBasePart = function(BasePart)
			local TimeToWait = 2
			local Time = tick()
			local Angle = 0

			repeat
				if RootPart and THumanoid then
					if BasePart.Velocity.Magnitude < 50 then
						Angle = Angle + 100

						FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
						task.wait()
					else
						FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
						task.wait()

						FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
						task.wait()
					end
				else
					break
				end
			until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
		end

		workspace.FallenPartsDestroyHeight = 0/0

		local BV = Instance.new("BodyVelocity")
		BV.Name = "EpixVel"
		BV.Parent = RootPart
		BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
		BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

		if TRootPart and THead then
			if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
				SFBasePart(THead)
			else
				SFBasePart(TRootPart)
			end
		elseif TRootPart and not THead then
			SFBasePart(TRootPart)
		elseif not TRootPart and THead then
			SFBasePart(THead)
		elseif not TRootPart and not THead and Accessory and Handle then
			SFBasePart(Handle)
		else
			return
		end

		BV:Destroy()
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		workspace.CurrentCamera.CameraSubject = Humanoid

		repeat
			RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
			Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
			Humanoid:ChangeState("GettingUp")
			table.foreach(Character:GetChildren(), function(_, x)
				if x:IsA("BasePart") then
					x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
				end
			end)
			task.wait()
		until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
		workspace.FallenPartsDestroyHeight = getgenv().FPDH
	else
	end
end
local FlingDPDOpt = {"All"}
local SelectedFDPD = nil
for i, v in pairs(game:GetService("Players"):GetPlayers()) do
	table.insert(FlingDPDOpt, v)
end
game:GetService("Players").PlayerAdded:Connect(function(v)
	table.insert(FlingDPDOpt, v)
end)
game:GetService("Players").PlayerRemoving:Connect(function(v)
	table.remove(FlingDPDOpt, #v)
end)
local flingxd = Tab:CreateDropdown({ -- esli ne rabotaet napishi
	Name = "Fling",
	Options = FlingDPDOpt,
	Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		if Value then
			SelectedFDPD = Value
			if SelectedFDPD == "All" then
				for i, v in next, game:GetService("Players"):GetPlayers() do
					SkidFling(v)
				end
			else
				pcall(function() SkidFling(SelectedFDPD) end)
			end
		end
	end})
local visual = Tab:CreateSection("Render")
local Kelve_ESP = Tab:CreateButton({
	Name = "ESP",
	Callback = function()
		mm2_esp()
	end,
})
local Dchroma = Tab:CreateButton({
	Name = "Disable chromas",
	Callback = function()
		for i, v in pairs(game:GetDescendants()) do
			if v.Name:find("Chroma") then
				pcall(function()
					v:Destroy()
				end)
			end
		end
	end,
})
local fps_boost = Tab:CreateButton({
	Name = "Fast Mode",
	Callback = function()
		local Terrain = workspace:FindFirstChildOfClass('Terrain')
		local Lighting = game:GetService('Lighting')
		local RunService = game:GetService('RunService')
		Terrain.WaterWaveSize = 0
		Terrain.WaterWaveSpeed = 0
		Terrain.WaterReflectance = 0
		Terrain.WaterTransparency = 0
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		settings().Rendering.QualityLevel = 1
		for i,v in pairs(game:GetDescendants()) do
			if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
				v.Material = "Plastic"
				v.Reflectance = 0
			elseif v:IsA("Decal") then
				v.Transparency = 1
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Lifetime = NumberRange.new(0)
			elseif v:IsA("Explosion") then
				v.BlastPressure = 1
				v.BlastRadius = 1
			end
		end
		for i,v in pairs(Lighting:GetDescendants()) do
			if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BloomEffect") or v:IsA("DepthOfFieldEffect") then
				v.Enabled = false
			end
		end
		workspace.DescendantAdded:Connect(function(child)
			task.spawn(function()
				if child:IsA('ForceField') then
					RunService.Heartbeat:Wait()
					child:Destroy()
				elseif child:IsA('Sparkles') then
					RunService.Heartbeat:Wait()
					child:Destroy()
				elseif child:IsA('Smoke') or child:IsA('Fire') then
					RunService.Heartbeat:Wait()
					child:Destroy()
				end
			end)
		end)
	end,
})
