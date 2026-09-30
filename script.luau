-- =================================================================
-- HUB INTERFACE PREMIUM V2 - MULTI-ONGLETS & MULTI-FONCTIONS
-- =================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- 1. CRÉATION DU CONTENEUR PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PremiumHub_Gui"
ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Fenêtre Principale
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- 2. BARRE DE TITRE (Zone de Drag)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -50, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "Premium Dev Hub v2.0"
TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextSize = 18
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Bouton Fermer (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -38, 0, 7)
CloseButton.BackgroundColor3 = Color3.fromRGB(230, 75, 75)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 14
CloseButton.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton
CloseButton.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- 3. PANNEAU DE GAUCHE (Pour la navigation des Onglets)
local NavigationBar = Instance.new("Frame")
NavigationBar.Size = UDim2.new(0, 130, 1, -45)
NavigationBar.Position = UDim2.new(0, 0, 0, 45)
NavigationBar.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
NavigationBar.BorderSizePixel = 0
NavigationBar.Parent = MainFrame

local NavListLayout = Instance.new("UIListLayout")
NavListLayout.Padding = UDim.new(0, 5)
NavListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavListLayout.Parent = NavigationBar

-- 4. ZONE DE CONTENU (À droite, pour afficher les pages)
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -140, 1, -55)
Container.Position = UDim2.new(0, 135, 0, 50)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

-- =================================================================
-- MOTEUR DE L'INTERFACE (GESTION DES ONGLETS & DES OBJETS)
-- =================================================================
local Hub = {}
local premierOnglet = true

function Hub:CreerOnglet(nomOnglet)
	-- Création de la page de contenu cachée par défaut
	local Page = Instance.new("ScrollingFrame")
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.BackgroundTransparency = 1
	Page.Visible = premierOnglet
	Page.CanvasSize = UDim2.new(0, 0, 0, 500)
	Page.ScrollBarThickness = 2
	Page.Parent = Container

	local PageLayout = Instance.new("UIListLayout")
	PageLayout.Padding = UDim.new(0, 8)
	PageLayout.Parent = Page

	-- Création du bouton d'onglet dans la barre de navigation
	local TabButton = Instance.new("TextButton")
	TabButton.Size = UDim2.new(0, 115, 0, 35)
	TabButton.BackgroundColor3 = premierOnglet and Color3.fromRGB(45, 45, 48) or Color3.fromRGB(35, 35, 38)
	TabButton.Text = nomOnglet
	TabButton.TextColor3 = premierOnglet and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 180, 180)
	TabButton.Font = Enum.Font.SourceSansBold
	TabButton.TextSize = 14
	TabButton.Parent = NavigationBar

	local TabCorner = Instance.new("UICorner")
	TabCorner.CornerRadius = UDim.new(0, 6)
	TabCorner.Parent = TabButton

	premierOnglet = false

	-- Système de changement d'onglet au clic
	TabButton.MouseButton1Click:Connect(function()
		for _, child in pairs(Container:GetChildren()) do
			if child:IsA("ScrollingFrame") then child.Visible = false end
		end
		for _, btn in pairs(NavigationBar:GetChildren()) do
			if btn:IsA("TextButton") then
				btn.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
				btn.TextColor3 = Color3.fromRGB(180, 180, 180)
			end
		end
		Page.Visible = true
		TabButton.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
		TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)

	-- OBJETS DISPONIBLES DANS CHAQUE ONGLET
	local Elements = {}

	-- Élément 1 : Bouton Simple
	function Elements:AjouterBouton(texte, callback)
		local Bouton = Instance.new("TextButton")
		Bouton.Size = UDim2.new(1, -5, 0, 35)
		Bouton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		Bouton.Text = texte
		Bouton.TextColor3 = Color3.fromRGB(230, 230, 230)
		Bouton.Font = Enum.Font.SourceSans
		Bouton.TextSize = 15
		Bouton.Parent = Page
		Instance.new("UICorner", Bouton).CornerRadius = UDim.new(0, 5)

		Bouton.MouseButton1Click:Connect(function() pcall(callback) end)
	end

	-- Élément 2 : Interrupteur (Toggle On/Off)
	function Elements:AjouterToggle(texte, callback)
		local ToggleFrame = Instance.new("Frame")
		ToggleFrame.Size = UDim2.new(1, -5, 0, 35)
		ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		ToggleFrame.Parent = Page
		Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 5)

		local ToggleLabel = Instance.new("TextLabel")
		ToggleLabel.Size = UDim2.new(1, -50, 1, 0)
		ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
		ToggleLabel.BackgroundTransparency = 1
		ToggleLabel.Text = texte
		ToggleLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
		ToggleLabel.Font = Enum.Font.SourceSans
		ToggleLabel.TextSize = 15
		ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
		ToggleLabel.Parent = ToggleFrame

		local Indicator = Instance.new("TextButton")
		Indicator.Size = UDim2.new(0, 40, 0, 20)
		Indicator.Position = UDim2.new(1, -45, 0, 7.5)
		Indicator.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		Indicator.Text = ""
		Indicator.Parent = ToggleFrame
		Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 10)

		local etat = false
		Indicator.MouseButton1Click:Connect(function()
			etat = not etat
			TweenService:Create(Indicator, TweenInfo.new(0.2), {
				BackgroundColor3 = etat and Color3.fromRGB(0, 180, 100) or Color3.fromRGB(70, 70, 70)
			}):Play()
			pcall(callback, etat)
		end)
	end

	-- Élément 3 : Zone de Saisie (TextBox)
	function Elements:AjouterTextBox(placeholder, callback)
		local BoxFrame = Instance.new("Frame")
		BoxFrame.Size = UDim2.new(1, -5, 0, 40)
		BoxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		BoxFrame.Parent = Page
		Instance.new("UICorner", BoxFrame).CornerRadius = UDim.new(0, 5)

		local TextBox = Instance.new("TextBox")
		TextBox.Size = UDim2.new(1, -20, 1, -10)
		TextBox.Position = UDim2.new(0, 10, 0, 5)
		TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
		TextBox.PlaceholderText = placeholder
		TextBox.Text = ""
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.Font = Enum.Font.SourceSans
		TextBox.TextSize = 14
		TextBox.Parent = BoxFrame
		Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 4)

		TextBox.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				pcall(callback, TextBox.Text)
			end
		end)
	end

	return Elements
end

-- =================================================================
-- 5. SYSTÈME DE DRAG (FENÊTRE DÉPLAÇABLE)
-- =================================================================
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true dragStart = input.Position startPos = MainFrame.Position
		input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
	end
end)
TitleBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)


-- =================================================================
-- CRÉATION ET CONFIGURATION DES ONGLETS (À MODIFIER SELON VOS ENVIES)
-- =================================================================

-- --- ONGLET 1 : MOUVEMENTS ---
local TabMouvements = Hub:CreerOnglet("Mouvements")

TabMouvements:AjouterBouton("Vitesse Flash (x100)", function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = 100 end
end)

TabMouvements:AjouterBouton("Reset Physiques", function()
	local char = LocalPlayer.Character
	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.WalkSpeed = 16
		char.Humanoid.JumpPower = 50
	end
end)

TabMouvements:AjouterTextBox("Taper vitesse personnalisée...", function(valeurTexte)
	local nombreVitesse = tonumber(valeurTexte)
	local char = LocalPlayer.Character
	if nombreVitesse and char and char:FindFirstChild("Humanoid") then
		char.Humanoid.WalkSpeed = nombreVitesse
		print("Vitesse définie via TextBox à : " .. nombreVitesse)
	end
end)

-- --- ONGLET 2 : AUTOMATISMES ---
local TabAuto = Hub:CreerOnglet("Boucles Auto")
local boucleSautActive = false
TabAuto:AjouterToggle("Saut Automatique en boucle", function(etatDuToggle)
boucleSautActive = etatDuToggle
-- On lance une tâche en arrière-plan si activé
task.spawn(function()
while boucleSautActive do
local char = LocalPlayer.Character
if char and char:FindFirstChild("Humanoid") then
char.Humanoid.Jump = true
end
task.wait(0.5) -- Attend une demi-seconde entre chaque saut
end
end)
end)
-- --- ONGLET 3 : INFOS CLIENT ---
local TabInfos = Hub:CreerOnglet("À propos")
TabInfos:AjouterBouton("Afficher mon pseudo dans les logs", function()
print("Utilisateur actuel : " .. LocalPlayer.Name)
