-- =================================================================
-- INTERFACE GRAPHIQUE COMPLÈTE DE TEST (AUTONOME & DÉPLAÇABLE)
-- =================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- 1. CRÉATION DU CONTENEUR ET DE LA FENÊTRE
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Pluplume"
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Ajout d'arrondis sur les coins
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- 2. BARRE DE TITRE (Zone pour drag/déplacer)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -40, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Pluplume hub"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- 3. BOUTON DE FERMETURE (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy() -- Ferme et supprime le menu de l'écran
end)

-- 4. ZONE DE CONTENU (Pour aligner les boutons)
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ContentFrame

-- 5. FONCTION POUR CRÉER FACILEMENT DES BOUTONS INTERACTIFS
local function CreerBouton(texte, callback)
	local Bouton = Instance.new("TextButton")
	Bouton.Size = UDim2.new(1, 0, 0, 40)
	Bouton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	Bouton.Text = texte
	Bouton.TextColor3 = Color3.fromRGB(230, 230, 230)
	Bouton.Font = Enum.Font.SourceSans
	Bouton.TextSize = 16
	Bouton.Parent = ContentFrame

	local BtnCorner = Instance.new("UICorner")
	BtnCorner.CornerRadius = UDim.new(0, 6)
	BtnCorner.Parent = Bouton

	-- Effets visuels au survol
	Bouton.MouseEnter:Connect(function()
		TweenService:Create(Bouton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
	end)
	Bouton.MouseLeave:Connect(function()
		TweenService:Create(Bouton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
	end)

	-- Liaison de la fonction au clic
	Bouton.MouseButton1Click:Connect(function()
		pcall(callback)
	end)
end

-- =================================================================
-- 6. SYSTÈME DE DRAG (Rend la fenêtre déplaçable avec la barre)
-- =================================================================
local dragging, dragInput, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

TitleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- =================================================================
-- 7. CONFIGURATION DE VOS BOUTONS ET DE LEURS FONCTIONS
-- =================================================================

-- Bouton 1 : Test de modification de vitesse
CreerBouton("Modifier Vitesse (WalkSpeed)", function()
	local character = LocalPlayer.Character
	if character and character:FindFirstChild("Humanoid") then
		character.Humanoid.WalkSpeed = 60
		print("[TEST] Vitesse définie à 60.")
	end
end)

-- Bouton 2 : Réinitialiser le personnage
CreerBouton("Réinitialiser Vitesse", function()
	local character = LocalPlayer.Character
	if character and character:FindFirstChild("Humanoid") then
		character.Humanoid.WalkSpeed = 16
		print("[TEST] Vitesse remise par défaut.")
	end
end)
