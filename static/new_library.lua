local DiscordLib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local userinfo = {}
local DEFAULT_PFP = "https://www.roblox.com/headshot-thumbnail/image?userId=".. (LocalPlayer and LocalPlayer.UserId or 0) .."&width=420&height=420&format=png"
local DEFAULT_USER = (LocalPlayer and LocalPlayer.Name or "User")
local DEFAULT_THEME = "Dark"
local DEFAULT_STATUS = "status_online"
local DEFAULT_LANGUAGE = "en"

pcall(function()
	if readfile then
		local success, data = pcall(readfile, "discordlibinfo.txt")
		if success and data and typeof(data) == "string" and #data > 0 then
			local decodeSuccess, decodedData = pcall(HttpService.JSONDecode, HttpService, data)
			if decodeSuccess then
				userinfo = decodedData
			else
				warn("DiscordLib: Failed to decode discordlibinfo.txt:", decodedData)
			end
		end
	else
		warn("DiscordLib: 'readfile' function not available. User settings will not persist.")
	end
end)

local pfp = userinfo["pfp"] or DEFAULT_PFP
local user = userinfo["user"] or DEFAULT_USER
local currentThemeName = userinfo["theme"] or DEFAULT_THEME
local currentUserStatus = userinfo["status"] or DEFAULT_STATUS
local currentLanguage = userinfo["language"] or DEFAULT_LANGUAGE

local Languages = {
	["en"] = {
		settings_userSettings = "USER SETTINGS",
		settings_myAccount = "My Account",
		settings_appearance = "Appearance",
		settings_language = "Language",
		settings_discordInfo = "Stable 1.0.1 (00002)\nHost 1.0.0\nRoblox Luau Engine",
		settings_escHint = "ESC",

		header_myAccount = "MY ACCOUNT",
		header_appearance = "APPEARANCE",
		header_language = "LANGUAGE",

		account_changeAvatarHover = "CHANGE\nAVATAR",
		account_usernameLabel = "USERNAME",
		account_editButton = "Edit",

		appearance_desc = "Adjust the color of the interface for better visibility.",

		language_desc = "Select your preferred language for the interface.",

		popup_changeButton = "Change",
		popup_resetButton = "Reset",
		popup_cancelButton = "Cancel",
		popup_okayButton = "Okay",

		popup_changeAvatarTitle = "Change your avatar",
		popup_changeAvatarDesc = "Enter a Roblox decal URL (e.g., rbxassetid://...)",
		popup_changeAvatarPlaceholder = "rbxassetid://...",
		popup_changeAvatarErrorInvalid = "Invalid Image ID or URL.",
		popup_changeAvatarErrorTitle = "Avatar Error",

		popup_changeUsernameTitle = "Change your username",
		popup_changeUsernameDesc = "Enter your new username.",
		popup_changeUsernamePlaceholder = "New Username",
		popup_changeUsernameErrorEmpty = "Username cannot be empty.",
		popup_changeUsernameErrorLong = "Username must be between 1 and 32 characters.",
		popup_changeUsernameErrorTitle = "Username Error",

		status_online = "Online",
		status_idle = "Idle",
		status_dnd = "Do Not Disturb",
		status_invisible = "Invisible",
	},
	["es"] = {
		settings_userSettings = "AJUSTES DE USUARIO",
		settings_myAccount = "Mi Cuenta",
		settings_appearance = "Apariencia",
		settings_language = "Idioma",
		settings_escHint = "ESC",

		header_myAccount = "MI CUENTA",
		header_appearance = "APARIENCIA",
		header_language = "IDIOMA",

		account_changeAvatarHover = "CAMBIAR\nAVATAR",
		account_usernameLabel = "NOMBRE DE USUARIO",
		account_editButton = "Editar",

		appearance_desc = "Ajusta el color de la interfaz para una mejor visibilidad.",

		language_desc = "Selecciona tu idioma preferido para la interfaz.",

		popup_changeButton = "Cambiar",
		popup_resetButton = "Restablecer",
		popup_cancelButton = "Cancelar",
		popup_okayButton = "Aceptar",

		popup_changeAvatarTitle = "Cambiar tu avatar",
		popup_changeAvatarDesc = "Introduce una URL de calcomanía de Roblox (ej., rbxassetid://...)",
		popup_changeAvatarPlaceholder = "rbxassetid://...",
		popup_changeAvatarErrorInvalid = "ID o URL de imagen inválida.",
		popup_changeAvatarErrorTitle = "Error de Avatar",

		popup_changeUsernameTitle = "Cambiar tu nombre de usuario",
		popup_changeUsernameDesc = "Introduce tu nuevo nombre de usuario.",
		popup_changeUsernamePlaceholder = "Nuevo Nombre",
		popup_changeUsernameErrorEmpty = "El nombre de usuario no puede estar vacío.",
		popup_changeUsernameErrorLong = "El nombre de usuario debe tener entre 1 y 32 caracteres.",
		popup_changeUsernameErrorTitle = "Error de Nombre de Usuario",

		status_online = "Conectado",
		status_idle = "Ausente",
		status_dnd = "No Molestar",
		status_invisible = "Invisible",
	},
	["ru"] = {
		settings_userSettings = "НАСТРОЙКИ ПОЛЬЗОВАТЕЛЯ",
		settings_myAccount = "Моя Учетная Запись",
		settings_appearance = "Внешний Вид",
		settings_language = "Язык",
		settings_escHint = "ESC",

		header_myAccount = "МОЯ УЧЕТНАЯ ЗАПИСЬ",
		header_appearance = "ВНЕШНИЙ ВИД",
		header_language = "ЯЗЫК",

		account_changeAvatarHover = "СМЕНИТЬ\nАВАТАР",
		account_usernameLabel = "ИМЯ ПОЛЬЗОВАТЕЛЯ",
		account_editButton = "Изменить",

		appearance_desc = "Настройте цвет интерфейса для лучшей видимости.",

		language_desc = "Выберите предпочитаемый язык интерфейса.",

		popup_changeButton = "Изменить",
		popup_resetButton = "Сбросить",
		popup_cancelButton = "Отмена",
		popup_okayButton = "ОК",

		popup_changeAvatarTitle = "Сменить ваш аватар",
		popup_changeAvatarDesc = "Введите URL декали Roblox (например, rbxassetid://...)",
		popup_changeAvatarPlaceholder = "rbxassetid://...",
		popup_changeAvatarErrorInvalid = "Неверный ID изображения или URL.",
		popup_changeAvatarErrorTitle = "Ошибка Аватара",

		popup_changeUsernameTitle = "Сменить ваше имя пользователя",
		popup_changeUsernameDesc = "Введите ваше новое имя пользователя.",
		popup_changeUsernamePlaceholder = "Новое Имя",
		popup_changeUsernameErrorEmpty = "Имя пользователя не может быть пустым.",
		popup_changeUsernameErrorLong = "Имя пользователя должно быть от 1 до 32 символов.",
		popup_changeUsernameErrorTitle = "Ошибка Имени Пользователя",

		status_online = "В сети",
		status_idle = "Отошел",
		status_dnd = "Не беспокоить",
		status_invisible = "Невидимый",
	}
}

local function GetTranslation(key)
	local langTable = Languages[currentLanguage] or Languages[DEFAULT_LANGUAGE]
	local fallbackTable = Languages[DEFAULT_LANGUAGE]
	return (langTable and langTable[key]) or (fallbackTable and fallbackTable[key]) or key
end

local function SaveInfo()
	userinfo["pfp"] = pfp
	userinfo["user"] = user
	userinfo["theme"] = currentThemeName
	userinfo["status"] = currentUserStatus
	userinfo["language"] = currentLanguage
	if writefile then
		pcall(writefile, "discordlibinfo.txt", HttpService:JSONEncode(userinfo))
	end
end

local Themes = {
	["White"] = {
		MainBackground = Color3.fromRGB(255, 255, 255),
		TopBarBackground = Color3.fromRGB(242, 243, 245),
		UserPadBackground = Color3.fromRGB(235, 236, 238),
		ServerListBackground = Color3.fromRGB(229, 231, 235),
		ChannelListBackground = Color3.fromRGB(242, 243, 245),
		ContentBackground = Color3.fromRGB(255, 255, 255),
		SettingsLeftBackground = Color3.fromRGB(229, 231, 235),
		SettingsRightBackground = Color3.fromRGB(255, 255, 255),
		SettingsUserPanelBackground = Color3.fromRGB(242, 243, 245),
		SettingsUserInputBackground = Color3.fromRGB(229, 231, 235),
		InputBackground = Color3.fromRGB(229, 231, 235),
		InputOutline = Color3.fromRGB(218, 219, 222),
		InputOutlineFocus = Color3.fromRGB(0, 117, 210),
		ButtonBackground = Color3.fromRGB(88, 101, 242),
		ButtonHover = Color3.fromRGB(71, 82, 196),
		ButtonSecondaryBackground = Color3.fromRGB(110, 118, 129),
		ButtonSecondaryHover = Color3.fromRGB(90, 96, 105),
		ToggleButtonBackground = Color3.fromRGB(185, 187, 190),
		ToggleButtonCircle = Color3.fromRGB(255, 255, 255),
		ToggleActiveBackground = Color3.fromRGB(67,181,129),
		ServerButton = Color3.fromRGB(242, 243, 245),
		ServerButtonHover = Color3.fromRGB(220, 221, 222),
		ServerButtonActive = Color3.fromRGB(88, 101, 242),
		ChannelButton = Color3.fromRGB(242, 243, 245),
		ChannelButtonHover = Color3.fromRGB(230, 231, 234),
		ChannelButtonActive = Color3.fromRGB(220, 221, 222),
		Scrollbar = Color3.fromRGB(200, 202, 205),
		Separator = Color3.fromRGB(218, 219, 222),
		PopupBackground = Color3.fromRGB(255, 255, 255),
		PopupSecondaryBackground = Color3.fromRGB(242, 243, 245),
		TooltipBackground = Color3.fromRGB(18, 19, 20),
		GlowColor = Color3.fromRGB(200, 200, 200),

		PrimaryText = Color3.fromRGB(6, 6, 7),
		SecondaryText = Color3.fromRGB(78, 80, 88),
		InteractiveNormal = Color3.fromRGB(78, 80, 88),
		InteractiveHover = Color3.fromRGB(30, 31, 34),
		InteractiveActive = Color3.fromRGB(6, 6, 7),
		HeaderText = Color3.fromRGB(6, 6, 7),
		MutedText = Color3.fromRGB(110, 118, 129),
		AccentText = Color3.fromRGB(88, 101, 242),
		ButtonText = Color3.fromRGB(255, 255, 255),
		IconColor = Color3.fromRGB(90, 96, 105),
		IconHoverColor = Color3.fromRGB(30, 31, 34),
		IconMuted = Color3.fromRGB(110, 118, 129),
		IconActive = Color3.fromRGB(67,181,129),
		TooltipText = Color3.fromRGB(240, 240, 240),

		StatusOnline = Color3.fromRGB(59, 165, 93),
		StatusIdle = Color3.fromRGB(250, 166, 26),
		StatusDoNotDisturb = Color3.fromRGB(237, 66, 69),
		StatusInvisible = Color3.fromRGB(128, 132, 142),
	},
	["Dark"] = {
		MainBackground = Color3.fromRGB(54, 57, 63),
		TopBarBackground = Color3.fromRGB(32, 34, 37),
		UserPadBackground = Color3.fromRGB(41, 43, 47),
		ServerListBackground = Color3.fromRGB(32, 34, 37),
		ChannelListBackground = Color3.fromRGB(47, 49, 54),
		ContentBackground = Color3.fromRGB(54, 57, 63),
		SettingsLeftBackground = Color3.fromRGB(47, 49, 54),
		SettingsRightBackground = Color3.fromRGB(54, 57, 63),
		SettingsUserPanelBackground = Color3.fromRGB(47, 49, 54),
		SettingsUserInputBackground = Color3.fromRGB(54, 57, 63),
		InputBackground = Color3.fromRGB(48, 51, 57),
		InputOutline = Color3.fromRGB(37, 40, 43),
		InputOutlineFocus = Color3.fromRGB(114, 137, 228),
		ButtonBackground = Color3.fromRGB(114, 137, 228),
		ButtonHover = Color3.fromRGB(103, 123, 196),
		ButtonSecondaryBackground = Color3.fromRGB(116, 127, 141),
		ButtonSecondaryHover = Color3.fromRGB(104, 114, 127),
		ToggleButtonBackground = Color3.fromRGB(114, 118, 125),
		ToggleButtonCircle = Color3.fromRGB(255, 255, 255),
		ToggleActiveBackground = Color3.fromRGB(67,181,129),
		ServerButton = Color3.fromRGB(47, 49, 54),
		ServerButtonHover = Color3.fromRGB(114, 137, 228),
		ServerButtonActive = Color3.fromRGB(114, 137, 228),
		ChannelButton = Color3.fromRGB(47, 49, 54),
		ChannelButtonHover = Color3.fromRGB(52, 55, 60),
		ChannelButtonActive = Color3.fromRGB(57, 60, 67),
		Scrollbar = Color3.fromRGB(18, 19, 21),
		Separator = Color3.fromRGB(66, 69, 74),
		PopupBackground = Color3.fromRGB(54, 57, 63),
		PopupSecondaryBackground = Color3.fromRGB(47, 49, 54),
		TooltipBackground = Color3.fromRGB(18, 19, 20),
		GlowColor = Color3.fromRGB(15, 15, 15),

		PrimaryText = Color3.fromRGB(255, 255, 255),
		SecondaryText = Color3.fromRGB(184, 186, 189),
		InteractiveNormal = Color3.fromRGB(114, 118, 125),
		InteractiveHover = Color3.fromRGB(220, 221, 222),
		InteractiveActive = Color3.fromRGB(255, 255, 255),
		HeaderText = Color3.fromRGB(255, 255, 255),
		MutedText = Color3.fromRGB(126, 130, 136),
		AccentText = Color3.fromRGB(114, 137, 228),
		ButtonText = Color3.fromRGB(255, 255, 255),
		IconColor = Color3.fromRGB(220, 221, 222),
		IconHoverColor = Color3.fromRGB(255, 255, 255),
		IconMuted = Color3.fromRGB(114, 118, 125),
		IconActive = Color3.fromRGB(67,181,129),
		TooltipText = Color3.fromRGB(240, 240, 240),

		StatusOnline = Color3.fromRGB(59, 165, 93),
		StatusIdle = Color3.fromRGB(250, 166, 26),
		StatusDoNotDisturb = Color3.fromRGB(237, 66, 69),
		StatusInvisible = Color3.fromRGB(128, 132, 142),
	},
	["Darker"] = {
		MainBackground = Color3.fromRGB(47, 49, 54),
		TopBarBackground = Color3.fromRGB(32, 34, 37),
		UserPadBackground = Color3.fromRGB(36, 39, 43),
		ServerListBackground = Color3.fromRGB(32, 34, 37),
		ChannelListBackground = Color3.fromRGB(41, 44, 49),
		ContentBackground = Color3.fromRGB(47, 49, 54),
		SettingsLeftBackground = Color3.fromRGB(41, 44, 49),
		SettingsRightBackground = Color3.fromRGB(47, 49, 54),
		SettingsUserPanelBackground = Color3.fromRGB(41, 44, 49),
		SettingsUserInputBackground = Color3.fromRGB(47, 49, 54),
		InputBackground = Color3.fromRGB(41, 44, 49),
		InputOutline = Color3.fromRGB(30, 31, 34),
		InputOutlineFocus = Color3.fromRGB(114, 137, 228),
		ButtonBackground = Color3.fromRGB(114, 137, 228),
		ButtonHover = Color3.fromRGB(103, 123, 196),
		ButtonSecondaryBackground = Color3.fromRGB(101, 109, 118),
		ButtonSecondaryHover = Color3.fromRGB(85, 91, 98),
		ToggleButtonBackground = Color3.fromRGB(114, 118, 125),
		ToggleButtonCircle = Color3.fromRGB(240, 240, 240),
		ToggleActiveBackground = Color3.fromRGB(67,181,129),
		ServerButton = Color3.fromRGB(41, 44, 49),
		ServerButtonHover = Color3.fromRGB(114, 137, 228),
		ServerButtonActive = Color3.fromRGB(114, 137, 228),
		ChannelButton = Color3.fromRGB(41, 44, 49),
		ChannelButtonHover = Color3.fromRGB(47, 49, 54),
		ChannelButtonActive = Color3.fromRGB(54, 57, 63),
		Scrollbar = Color3.fromRGB(15, 16, 17),
		Separator = Color3.fromRGB(54, 57, 63),
		PopupBackground = Color3.fromRGB(47, 49, 54),
		PopupSecondaryBackground = Color3.fromRGB(41, 44, 49),
		TooltipBackground = Color3.fromRGB(12, 13, 14),
		GlowColor = Color3.fromRGB(10, 10, 10),

		PrimaryText = Color3.fromRGB(240, 241, 242),
		SecondaryText = Color3.fromRGB(170, 173, 178),
		InteractiveNormal = Color3.fromRGB(142, 146, 151),
		InteractiveHover = Color3.fromRGB(210, 211, 212),
		InteractiveActive = Color3.fromRGB(240, 241, 242),
		HeaderText = Color3.fromRGB(240, 241, 242),
		MutedText = Color3.fromRGB(110, 115, 120),
		AccentText = Color3.fromRGB(114, 137, 228),
		ButtonText = Color3.fromRGB(255, 255, 255),
		IconColor = Color3.fromRGB(185, 187, 190),
		IconHoverColor = Color3.fromRGB(240, 241, 242),
		IconMuted = Color3.fromRGB(114, 118, 125),
		IconActive = Color3.fromRGB(67,181,129),
		TooltipText = Color3.fromRGB(230, 230, 230),

		StatusOnline = Color3.fromRGB(59, 165, 93),
		StatusIdle = Color3.fromRGB(250, 166, 26),
		StatusDoNotDisturb = Color3.fromRGB(237, 66, 69),
		StatusInvisible = Color3.fromRGB(128, 132, 142),
	},
	["Black"] = {
		MainBackground = Color3.fromRGB(0, 0, 0),
		TopBarBackground = Color3.fromRGB(0, 0, 0),
		UserPadBackground = Color3.fromRGB(0, 0, 0),
		ServerListBackground = Color3.fromRGB(0, 0, 0),
		ChannelListBackground = Color3.fromRGB(0, 0, 0),
		ContentBackground = Color3.fromRGB(0, 0, 0),
		SettingsLeftBackground = Color3.fromRGB(0, 0, 0),
		SettingsRightBackground = Color3.fromRGB(0, 0, 0),
		SettingsUserPanelBackground = Color3.fromRGB(15, 15, 15),
		SettingsUserInputBackground = Color3.fromRGB(15, 15, 15),
		InputBackground = Color3.fromRGB(15, 15, 15),
		InputOutline = Color3.fromRGB(30, 30, 30),
		InputOutlineFocus = Color3.fromRGB(114, 137, 228),
		ButtonBackground = Color3.fromRGB(114, 137, 228),
		ButtonHover = Color3.fromRGB(103, 123, 196),
		ButtonSecondaryBackground = Color3.fromRGB(101, 109, 118),
		ButtonSecondaryHover = Color3.fromRGB(85, 91, 98),
		ToggleButtonBackground = Color3.fromRGB(114, 118, 125),
		ToggleButtonCircle = Color3.fromRGB(220, 220, 220),
		ToggleActiveBackground = Color3.fromRGB(67,181,129),
		ServerButton = Color3.fromRGB(15, 15, 15),
		ServerButtonHover = Color3.fromRGB(114, 137, 228),
		ServerButtonActive = Color3.fromRGB(114, 137, 228),
		ChannelButton = Color3.fromRGB(0, 0, 0),
		ChannelButtonHover = Color3.fromRGB(20, 20, 20),
		ChannelButtonActive = Color3.fromRGB(35, 35, 35),
		Scrollbar = Color3.fromRGB(25, 25, 25),
		Separator = Color3.fromRGB(30, 30, 30),
		PopupBackground = Color3.fromRGB(15, 15, 15),
		PopupSecondaryBackground = Color3.fromRGB(10, 10, 10),
		TooltipBackground = Color3.fromRGB(5, 5, 5),
		GlowColor = Color3.fromRGB(5, 5, 5),

		PrimaryText = Color3.fromRGB(245, 245, 245),
		SecondaryText = Color3.fromRGB(180, 180, 180),
		InteractiveNormal = Color3.fromRGB(142, 146, 151),
		InteractiveHover = Color3.fromRGB(220, 221, 222),
		InteractiveActive = Color3.fromRGB(245, 245, 245),
		HeaderText = Color3.fromRGB(245, 245, 245),
		MutedText = Color3.fromRGB(100, 100, 100),
		AccentText = Color3.fromRGB(114, 137, 228),
		ButtonText = Color3.fromRGB(255, 255, 255),
		IconColor = Color3.fromRGB(200, 200, 200),
		IconHoverColor = Color3.fromRGB(245, 245, 245),
		IconMuted = Color3.fromRGB(114, 118, 125),
		IconActive = Color3.fromRGB(67,181,129),
		TooltipText = Color3.fromRGB(230, 230, 230),

		StatusOnline = Color3.fromRGB(59, 165, 93),
		StatusIdle = Color3.fromRGB(250, 166, 26),
		StatusDoNotDisturb = Color3.fromRGB(237, 66, 69),
		StatusInvisible = Color3.fromRGB(128, 132, 142),
	},
}
local CurrentTheme = Themes[currentThemeName] or Themes.Dark
local StatusColors = {
	["Online"] = Themes.Dark.StatusOnline,
	["Idle"] = Themes.Dark.StatusIdle,
	["Do Not Disturb"] = Themes.Dark.StatusDoNotDisturb,
	["Invisible"] = Themes.Dark.StatusInvisible,
}
local Statuses = {"status_online", "status_idle", "status_dnd", "status_invisible"}

local function MakeDraggable(topbarobject, object)
	local Dragging = false
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil
	local Connection = {}

	local function Update(input)
		if not StartPosition then return end
		local Delta = input.Position - DragStart
		local pos = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)
		local Succeeded, Failed = pcall(function() object.Position = pos end)
		if not Succeeded then
			Dragging = false
			if Connection["InputChanged"] then Connection["InputChanged"]:Disconnect() end
			if Connection["InputEnded"] then Connection["InputEnded"]:Disconnect() end
			if Connection["TopBarInputBegan"] then Connection["TopBarInputBegan"]:Disconnect() end
			if Connection["TopBarInputChanged"] then Connection["TopBarInputChanged"]:Disconnect() end
			table.clear(Connection)
		end
	end

	Connection["TopBarInputBegan"] = topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position

			if Connection["InputEnded"] then Connection["InputEnded"]:Disconnect() end
			Connection["InputEnded"] = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
					StartPosition = nil
					if Connection["InputEnded"] then Connection["InputEnded"]:Disconnect() end
				end
			end)
		end
	end)

	Connection["TopBarInputChanged"] = topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	Connection["InputChanged"] = UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)

	return function()
		for _, conn in pairs(Connection) do
			pcall(function() if conn then conn:Disconnect() end end)
		end
		table.clear(Connection)
	end
end

function DiscordLib:Window(text)

	local Elements = {}
	local currentservertoggled = ""
	local minimized = false
	local fs = false
	local settingsopened = false
	local CurrentTheme = Themes[currentThemeName]
	local statusPopupOpen = false
	local dragCleanup = nil
	Elements.CornerNotifications = {}

	local function ApplyLanguage(initialLoad)
		if Elements.SettingsTitle then Elements.SettingsTitle.Text = GetTranslation("settings_userSettings") end
		if Elements.MyAccountBtnTitle then Elements.MyAccountBtnTitle.Text = GetTranslation("settings_myAccount") end
		if Elements.AppearanceBtnTitle then Elements.AppearanceBtnTitle.Text = GetTranslation("settings_appearance") end
		if Elements.LanguageBtnTitle then Elements.LanguageBtnTitle.Text = GetTranslation("settings_language") end
		if Elements.CloseSettingsKeybindHint then Elements.CloseSettingsKeybindHint.Text = GetTranslation("settings_escHint") end

		local currentSettingHeader = Elements.CurrentSettingOpen
		local userPanel = Elements.UserPanel
		local appearancePanel = Elements.AppearancePanel
		local languagePanel = Elements.LanguagePanel
		if currentSettingHeader then
			if userPanel and userPanel.Visible then
				currentSettingHeader.Text = GetTranslation("header_myAccount")
			elseif appearancePanel and appearancePanel.Visible then
				currentSettingHeader.Text = GetTranslation("header_appearance")
			elseif languagePanel and languagePanel.Visible then
				currentSettingHeader.Text = GetTranslation("header_language")
			end
		end

		if Elements.ChangeAvatarText then Elements.ChangeAvatarText.Text = GetTranslation("account_changeAvatarHover") end
		if Elements.UsernameTextLabel then Elements.UsernameTextLabel.Text = GetTranslation("account_usernameLabel") end
		if Elements.EditBtn then Elements.EditBtn.Text = GetTranslation("account_editButton") end

		if Elements.AppearanceDesc then Elements.AppearanceDesc.Text = GetTranslation("appearance_desc") end

		if Elements.LanguageDesc then Elements.LanguageDesc.Text = GetTranslation("language_desc") end

		local function updatePopupTexts(popupName, holderName)
			local holder = Elements.MainFrame:FindFirstChild(holderName)
			if not (holder and holder.Visible) then return end
			local popup = holder:FindFirstChild(popupName)
			if not popup then return end

			local text1 = popup:FindFirstChild("Text1")
			local text2 = popup:FindFirstChild("Text2")
			local underBar = popup:FindFirstChild("UnderBarFrame")
			local textbox = popup:FindFirstChild("TextBoxFrameOutline") and popup.TextBoxFrameOutline:FindFirstChild("TextBoxFrame"):FindFirstChildWhichIsA("TextBox")

			if popupName == "AvatarChangePopup" then
				if text1 then text1.Text = GetTranslation("popup_changeAvatarTitle") end
				if text2 then text2.Text = GetTranslation("popup_changeAvatarDesc") end
				if textbox then textbox.PlaceholderText = GetTranslation("popup_changeAvatarPlaceholder") end
				if underBar then
					local changeBtn = underBar:FindFirstChild("ChangeBtn")
					local resetBtn = underBar:FindFirstChild("ResetBtn")
					local closeBtn1 = underBar:FindFirstChild("CloseBtn1")
					if changeBtn then changeBtn.Text = GetTranslation("popup_changeButton") end
					if resetBtn then resetBtn.Text = GetTranslation("popup_resetButton") end
					if closeBtn1 then closeBtn1.Text = GetTranslation("popup_cancelButton") end
				end
			elseif popupName == "UserChangePopup" then
				if text1 then text1.Text = GetTranslation("popup_changeUsernameTitle") end
				if text2 then text2.Text = GetTranslation("popup_changeUsernameDesc") end
				if textbox then textbox.PlaceholderText = GetTranslation("popup_changeUsernamePlaceholder") end
				if underBar then
					local changeBtn = underBar:FindFirstChild("ChangeBtn")
					local closeBtn1 = underBar:FindFirstChild("CloseBtn1")
					if changeBtn then changeBtn.Text = GetTranslation("popup_changeButton") end
					if closeBtn1 then closeBtn1.Text = GetTranslation("popup_cancelButton") end
				end
			elseif popupName == "Notification" then
				if underBar then
					local alrightBtn = underBar:FindFirstChild("AlrightBtn")
					if alrightBtn then alrightBtn.Text = GetTranslation("popup_okayButton") end
				end
			end
		end

		updatePopupTexts("AvatarChangePopup", "AvatarChangeHolder")
		updatePopupTexts("UserChangePopup", "UserChangeHolder")
		updatePopupTexts("Notification", "NotificationHolderMain")

		local statusPopup = Elements.Userpad and Elements.Userpad:FindFirstChild("StatusPopup")
		if statusPopup then
			for _, key in ipairs(Statuses) do
				local translatedStatus = GetTranslation(key)
				local btn = statusPopup:FindFirstChild(key)
				if btn then
					local label = btn:FindFirstChildWhichIsA("TextLabel")
					if label then label.Text = translatedStatus end
				end
			end
		end


		if not initialLoad then
			SaveInfo()
		end
	end

	local function ApplyTheme(themeName, initialLoad)
		currentThemeName = themeName
		CurrentTheme = Themes[themeName] or Themes.Dark

		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		function tweenColor(obj, prop, targetColor)
			if obj and obj:IsA("GuiObject") then
				if initialLoad then
					obj[prop] = targetColor
				else
					TweenService:Create(obj, tweenInfo, {[prop] = targetColor}):Play()
				end
			elseif obj and obj:IsA("UIGradient") then
			end
		end

		local function tweenTransparency(obj, prop, targetTransparency)
			if obj and obj:IsA("GuiObject") then
				if initialLoad then
					obj[prop] = targetTransparency
				else
					TweenService:Create(obj, tweenInfo, {[prop] = targetTransparency}):Play()
				end
			end
		end

		local mainFrame = Elements.MainFrame
		if not mainFrame then warn("ApplyTheme: MainFrame not found in Elements table!") return end

		tweenColor(mainFrame, "BackgroundColor3", CurrentTheme.MainBackground)

		local topFrame = Elements.TopFrame
		if topFrame then
			tweenColor(topFrame, "BackgroundColor3", CurrentTheme.TopBarBackground)

			local title = Elements.Title
			if title then tweenColor(title, "TextColor3", CurrentTheme.SecondaryText) end

			local closeBtn = Elements.CloseBtn
			if closeBtn then
				tweenColor(closeBtn, "BackgroundColor3", CurrentTheme.TopBarBackground)
				local closeIcon = Elements.CloseIcon
				if closeIcon then tweenColor(closeIcon, "ImageColor3", CurrentTheme.IconColor) end
			end

			local minimizeBtn = Elements.MinimizeBtn
			if minimizeBtn then
				tweenColor(minimizeBtn, "BackgroundColor3", CurrentTheme.TopBarBackground)
				local minimizeIcon = Elements.MinimizeIcon
				if minimizeIcon then tweenColor(minimizeIcon, "ImageColor3", CurrentTheme.IconColor) end
			end
		end

		local contentContainer = Elements.ContentContainer
		if contentContainer then
			contentContainer.BackgroundTransparency = 1
		end

		local userpad = Elements.Userpad
		if userpad then
			tweenColor(userpad, "BackgroundColor3", CurrentTheme.UserPadBackground)
			local userName = Elements.UserName
			if userName then tweenColor(userName, "TextColor3", CurrentTheme.PrimaryText) end

			local userIconButton = Elements.UserIconButton
			if userIconButton then
				local userCircleImage = Elements.UserCircleImage
				if userCircleImage then tweenColor(userCircleImage, "ImageColor3", CurrentTheme.UserPadBackground) end

				local statusIndicator = Elements.StatusIndicator
				if statusIndicator then
					local statusDisplayName = GetTranslation(currentUserStatus)
					local statusKey = "Status" .. statusDisplayName:gsub(" ", "")
					tweenColor(statusIndicator, "BackgroundColor3", CurrentTheme[statusKey] or CurrentTheme.StatusInvisible)
					tweenColor(statusIndicator, "BorderColor3", CurrentTheme.UserPadBackground)
				end
			end

			local settingsOpenBtn = userpad:FindFirstChild("SettingsOpenBtn")
			if settingsOpenBtn then
				local settingsOpenBtnIco = settingsOpenBtn:FindFirstChild("SettingsOpenBtnIco")
				if settingsOpenBtnIco then tweenColor(settingsOpenBtnIco, "ImageColor3", CurrentTheme.IconColor) end
			end
		end


		local serversHoldFrame = Elements.ServersHoldFrame
		if serversHoldFrame then
			tweenColor(serversHoldFrame, "BackgroundColor3", CurrentTheme.ServerListBackground)
			local serversHold = Elements.ServersHold
			if serversHold then
				tweenColor(serversHold, "BackgroundColor3", CurrentTheme.ServerListBackground)
				tweenColor(serversHold, "ScrollBarImageColor3", CurrentTheme.Scrollbar)
				for _, serverBtn in ipairs(serversHold:GetChildren()) do
					if serverBtn:IsA("TextButton") and serverBtn:FindFirstChild("ServerCorner") then
						local serverId = serverBtn.Name
						tweenColor(serverBtn, "BackgroundColor3", serverId == currentservertoggled and CurrentTheme.ServerButtonActive or CurrentTheme.ServerButton)
						local serverIco = serverBtn:FindFirstChild("ServerIco")
						if serverIco and serverIco.Image == "" then
							tweenColor(serverBtn, "TextColor3", CurrentTheme.PrimaryText)
						end
						local indicator = serverBtn:FindFirstChild("ServerWhiteFrame")
						if indicator then indicator.BackgroundColor3 = Color3.new(1,1,1) end
					end
				end
			end
		end

		local settingsFrame = Elements.SettingsFrame
		if settingsFrame then
			if settingsopened then
				tweenTransparency(settingsFrame, "BackgroundTransparency", 0.7)
				tweenColor(settingsFrame, "BackgroundColor3", CurrentTheme.PopupSecondaryBackground)
			else
				settingsFrame.BackgroundTransparency = 1
			end

			local settings = Elements.Settings
			if settings then
				tweenColor(settings, "BackgroundColor3", CurrentTheme.SettingsRightBackground)

				local settingsHolder = Elements.SettingsHolder
				if settingsHolder then
					local closeBtn = Elements.CloseSettingsBtn
					if closeBtn then
						local closeBtnCircle = Elements.CloseSettingsBtnCircle
						if closeBtnCircle then tweenColor(closeBtnCircle, "BackgroundColor3", CurrentTheme.SettingsRightBackground) end
						local closeBtnIcon = Elements.CloseSettingsBtnIcon
						if closeBtnIcon then tweenColor(closeBtnIcon, "ImageColor3", CurrentTheme.IconColor) end
						local closeHint = Elements.CloseSettingsKeybindHint
						if closeHint then tweenColor(closeHint, "TextColor3", CurrentTheme.InteractiveNormal) end
					end

					local leftFrame = Elements.LeftFrame
					if leftFrame then
						tweenColor(leftFrame, "BackgroundColor3", CurrentTheme.SettingsLeftBackground)
						local settingsTitle = Elements.SettingsTitle
						if settingsTitle then tweenColor(settingsTitle, "TextColor3", CurrentTheme.MutedText) end
						local discordInfo = Elements.DiscordInfo
						if discordInfo then tweenColor(discordInfo, "TextColor3", CurrentTheme.MutedText) end

						local currentSettingOpen = nil
						local userPanelCheck = Elements.UserPanel
						local appearancePanelCheck = Elements.AppearancePanel
						local languagePanelCheck = Elements.LanguagePanel
						if userPanelCheck and userPanelCheck.Visible then currentSettingOpen = "MyAccountBtn" end
						if appearancePanelCheck and appearancePanelCheck.Visible then currentSettingOpen = "AppearanceBtn" end
						if languagePanelCheck and languagePanelCheck.Visible then currentSettingOpen = "LanguageBtn" end


						local myAccBtn = Elements.MyAccountBtn
						if myAccBtn then
							tweenColor(myAccBtn, "BackgroundColor3", currentSettingOpen == "MyAccountBtn" and CurrentTheme.ChannelButtonActive or CurrentTheme.ChannelButton)
							local myAccBtnTitle = Elements.MyAccountBtnTitle
							if myAccBtnTitle then tweenColor(myAccBtnTitle, "TextColor3", currentSettingOpen == "MyAccountBtn" and CurrentTheme.InteractiveActive or CurrentTheme.InteractiveNormal) end
						end
						local appearanceBtn = Elements.AppearanceBtn
						if appearanceBtn then
							tweenColor(appearanceBtn, "BackgroundColor3", currentSettingOpen == "AppearanceBtn" and CurrentTheme.ChannelButtonActive or CurrentTheme.ChannelButton)
							local appearanceBtnTitle = Elements.AppearanceBtnTitle
							if appearanceBtnTitle then tweenColor(appearanceBtnTitle, "TextColor3", currentSettingOpen == "AppearanceBtn" and CurrentTheme.InteractiveActive or CurrentTheme.InteractiveNormal) end
						end
						local languageBtn = Elements.LanguageBtn
						if languageBtn then
							tweenColor(languageBtn, "BackgroundColor3", currentSettingOpen == "LanguageBtn" and CurrentTheme.ChannelButtonActive or CurrentTheme.ChannelButton)
							local languageBtnTitle = Elements.LanguageBtnTitle
							if languageBtnTitle then tweenColor(languageBtnTitle, "TextColor3", currentSettingOpen == "LanguageBtn" and CurrentTheme.InteractiveActive or CurrentTheme.InteractiveNormal) end
						end

						local settingsSeparator = leftFrame:FindFirstChild("SettingsSeparator")
						if settingsSeparator then tweenColor(settingsSeparator, "BackgroundColor3", CurrentTheme.Separator) end
					end

					local userPanel = Elements.UserPanel
					if userPanel then
						tweenColor(userPanel, "BackgroundColor3", CurrentTheme.SettingsRightBackground)
						local currentSettingHeader = Elements.CurrentSettingOpen
						if currentSettingHeader and userPanel.Visible then
							tweenColor(currentSettingHeader, "TextColor3", CurrentTheme.HeaderText)
							currentSettingHeader.Text = GetTranslation("header_myAccount")
						end

						local userSettingsCard = Elements.UserSettingsCard
						if userSettingsCard then
							tweenColor(userSettingsCard, "BackgroundColor3", CurrentTheme.SettingsUserPanelBackground)
							local userPanelUserIcon = Elements.UserPanelUserIcon
							if userPanelUserIcon then
								local userPanelUserCircle = Elements.UserPanelUserCircle
								if userPanelUserCircle then tweenColor(userPanelUserCircle, "ImageColor3", CurrentTheme.SettingsUserPanelBackground) end
								local blackFrame = Elements.BlackFrame
								if blackFrame then
									local changeAvatarText = blackFrame:FindFirstChild("ChangeAvatarText")
									if changeAvatarText then tweenColor(changeAvatarText, "TextColor3", Color3.new(1,1,1)) end
								end

								local settingsStatusIndicator = Elements.SettingsStatusIndicator
								if settingsStatusIndicator then
									local statusDisplayName = GetTranslation(currentUserStatus)
									local statusKey = "Status" .. statusDisplayName:gsub(" ", "")
									tweenColor(settingsStatusIndicator, "BackgroundColor3", CurrentTheme[statusKey] or CurrentTheme.StatusInvisible)
									tweenColor(settingsStatusIndicator, "BorderColor3", CurrentTheme.SettingsUserPanelBackground)
								end
							end
							local userPanelUserText = Elements.UserPanelUser
							if userPanelUserText then tweenColor(userPanelUserText, "TextColor3", CurrentTheme.HeaderText) end
						end

						local userSettingsPad = Elements.UserSettingsPad
						if userSettingsPad then
							tweenColor(userSettingsPad, "BackgroundColor3", CurrentTheme.SettingsUserInputBackground)
							local usernameLabel = Elements.UsernameTextLabel
							if usernameLabel then tweenColor(usernameLabel, "TextColor3", CurrentTheme.MutedText) end
							local usernameDisplay = Elements.UserSettingsPadUser
							if usernameDisplay then tweenColor(usernameDisplay, "TextColor3", CurrentTheme.PrimaryText) end

							local editBtn = Elements.EditBtn
							if editBtn then
								tweenColor(editBtn, "BackgroundColor3", CurrentTheme.ButtonSecondaryBackground)
								tweenColor(editBtn, "TextColor3", CurrentTheme.ButtonText)
							end
						end
					end

					local appearancePanel = Elements.AppearancePanel
					if appearancePanel then
						tweenColor(appearancePanel, "BackgroundColor3", CurrentTheme.SettingsRightBackground)
						local currentSettingHeader = Elements.CurrentSettingOpen
						if currentSettingHeader and appearancePanel.Visible then
							tweenColor(currentSettingHeader, "TextColor3", CurrentTheme.HeaderText)
							currentSettingHeader.Text = GetTranslation("header_appearance")
						end
						local appearanceDesc = Elements.AppearanceDesc
						if appearanceDesc then tweenColor(appearanceDesc, "TextColor3", CurrentTheme.SecondaryText) end

						local themeButtonsFrame = Elements.ThemeButtonsFrame
						if themeButtonsFrame then
							for _, container in ipairs(themeButtonsFrame:GetChildren()) do
								if container:IsA("Frame") and container:FindFirstChild("ThemePreview") then
									local preview = container:FindFirstChild("ThemePreview")
									local nameLabel = container:FindFirstChild("ThemeNameLabel")
									local btnThemeKey = container.Name:gsub("PreviewContainer", "")
									local isActive = btnThemeKey == themeName
									local stroke = preview:FindFirstChild("ActiveStroke")

									tweenColor(preview, "BackgroundColor3", Themes[btnThemeKey].ContentBackground)
									if nameLabel then tweenColor(nameLabel, "TextColor3", CurrentTheme.PrimaryText) end

									if stroke then
										stroke.Color = CurrentTheme.AccentText
										stroke.Enabled = isActive
									end
								end
							end
						end
					end

					local languagePanel = Elements.LanguagePanel
					if languagePanel then
						tweenColor(languagePanel, "BackgroundColor3", CurrentTheme.SettingsRightBackground)
						local currentSettingHeader = Elements.CurrentSettingOpen
						if currentSettingHeader and languagePanel.Visible then
							tweenColor(currentSettingHeader, "TextColor3", CurrentTheme.HeaderText)
							currentSettingHeader.Text = GetTranslation("header_language")
						end
						local languageDesc = Elements.LanguageDesc
						if languageDesc then tweenColor(languageDesc, "TextColor3", CurrentTheme.SecondaryText) end

						local langButtonsFrame = Elements.LanguageButtonsFrame
						if langButtonsFrame then
							for langCode, langData in pairs(Languages) do
								local langBtn = langButtonsFrame:FindFirstChild(langCode .. "Btn")
								if langBtn then
									local isActive = langCode == currentLanguage
									tweenColor(langBtn, "BackgroundColor3", isActive and CurrentTheme.ChannelButtonActive or CurrentTheme.ChannelButton)
									tweenColor(langBtn, "TextColor3", isActive and CurrentTheme.InteractiveActive or CurrentTheme.PrimaryText)
								end
							end
						end
					end

				end
			end
		end

		if currentservertoggled ~= "" then
			local serverFrame = Elements[currentservertoggled .. "Frame"]
			if not serverFrame and Elements.ServersHolderFolder then
				serverFrame = Elements.ServersHolderFolder:FindFirstChild(currentservertoggled .. "Frame")
			end

			if serverFrame and serverFrame.Visible then
				local channelListFrame = serverFrame:FindFirstChild("ChannelListFrame")
				if channelListFrame then
					tweenColor(channelListFrame, "BackgroundColor3", CurrentTheme.ChannelListBackground)
					local serverTitleFrame = channelListFrame:FindFirstChild("ServerTitleFrame")
					if serverTitleFrame then
						tweenColor(serverTitleFrame, "BackgroundColor3", CurrentTheme.ChannelListBackground)
						local serverTitle = serverTitleFrame:FindFirstChild("ServerTitle")
						if serverTitle then tweenColor(serverTitle, "TextColor3", CurrentTheme.HeaderText) end
						local titleShadow = serverTitleFrame:FindFirstChild("TitleShadow")
						if titleShadow then tweenColor(titleShadow, "BackgroundColor3", CurrentTheme.Separator) end
					end

					local channelHolderScroll = Elements[currentservertoggled.."_ChannelListHolder"] or channelListFrame:FindFirstChild("ServerChannelHolder")
					if channelHolderScroll then
						tweenColor(channelHolderScroll, "BackgroundColor3", CurrentTheme.ChannelListBackground)
						tweenColor(channelHolderScroll, "ScrollBarImageColor3", CurrentTheme.Scrollbar)
						local activeChannelId = Elements[currentservertoggled .. "_ActiveChannelId"] or ""

						for _, chanBtn in ipairs(channelHolderScroll:GetChildren()) do
							if chanBtn:IsA("TextButton") and chanBtn:FindFirstChild("ChannelBtnCorner") then
								local isActive = chanBtn.Name == activeChannelId
								tweenColor(chanBtn, "BackgroundColor3", isActive and CurrentTheme.ChannelButtonActive or CurrentTheme.ChannelButton)
								local chanHash = chanBtn:FindFirstChild("ChannelBtnHashtag")
								if chanHash then tweenColor(chanHash, "TextColor3", isActive and CurrentTheme.InteractiveActive or CurrentTheme.InteractiveNormal) end
								local chanTitle = chanBtn:FindFirstChild("ChannelBtnTitle")
								if chanTitle then tweenColor(chanTitle, "TextColor3", isActive and CurrentTheme.InteractiveActive or CurrentTheme.InteractiveNormal) end
							end
						end
					end
				end

				local contentAreaFrame = serverFrame:FindFirstChild("ContentAreaFrame")
				if contentAreaFrame then
					tweenColor(contentAreaFrame, "BackgroundColor3", CurrentTheme.ContentBackground)
					local channelTitleFrame = contentAreaFrame:FindFirstChild("ChannelTitleFrame")
					if channelTitleFrame then
						tweenColor(channelTitleFrame, "BackgroundColor3", CurrentTheme.ContentBackground)
						local hashtag = channelTitleFrame:FindFirstChild("Hashtag")
						if hashtag then tweenColor(hashtag, "TextColor3", CurrentTheme.InteractiveNormal) end
						local channelTitle = Elements[currentservertoggled.."_ChannelTitle"] or channelTitleFrame:FindFirstChild("ChannelTitle")
						if channelTitle then tweenColor(channelTitle, "TextColor3", CurrentTheme.HeaderText) end
						local contentTitleShadow = channelTitleFrame:FindFirstChild("ContentTitleShadow")
						if contentTitleShadow then tweenColor(contentTitleShadow, "BackgroundColor3", CurrentTheme.Separator) end
					end

					local channelContentFrame = Elements[currentservertoggled.."_ChannelContentFrame"] or contentAreaFrame:FindFirstChild("ChannelContentFrame")
					if channelContentFrame then
						tweenColor(channelContentFrame, "BackgroundColor3", CurrentTheme.ContentBackground)
						local activeChannelContentHolder = nil
						for _, child in ipairs(channelContentFrame:GetChildren()) do
							if child:IsA("ScrollingFrame") and child.Visible then
								activeChannelContentHolder = child
								break
							end
						end

						if activeChannelContentHolder then
							tweenColor(activeChannelContentHolder, "BackgroundColor3", CurrentTheme.ContentBackground)
							tweenColor(activeChannelContentHolder, "ScrollBarImageColor3", CurrentTheme.Scrollbar)
							for _, item in ipairs(activeChannelContentHolder:GetChildren()) do
								if item:FindFirstChild("ButtonCorner") then
									tweenColor(item, "BackgroundColor3", CurrentTheme.ButtonBackground)
									tweenColor(item, "TextColor3", CurrentTheme.ButtonText)
								elseif item:FindFirstChild("ToggleFrame") then
									tweenColor(item, "BackgroundColor3", CurrentTheme.ContentBackground)
									local toggleTitle = item:FindFirstChild("ToggleTitle")
									if toggleTitle then tweenColor(toggleTitle, "TextColor3", CurrentTheme.SecondaryText) end
									local toggleFrame = item:FindFirstChild("ToggleFrame")
									if toggleFrame then
										local isToggleOn = false
										if item:GetAttribute("ToggledState") == true then isToggleOn = true end
										tweenColor(toggleFrame, "BackgroundColor3", isToggleOn and CurrentTheme.ToggleActiveBackground or CurrentTheme.ToggleButtonBackground)
										local toggleCircle = toggleFrame:FindFirstChild("ToggleFrameCircle")
										if toggleCircle then
											tweenColor(toggleCircle, "BackgroundColor3", CurrentTheme.ToggleButtonCircle)
											local toggleIcon = toggleCircle:FindFirstChild("Icon")
											if toggleIcon then tweenColor(toggleIcon, "ImageColor3", isToggleOn and CurrentTheme.IconActive or CurrentTheme.IconMuted) end
										end
									end
								elseif item:FindFirstChild("SliderFrame") then
									tweenColor(item, "BackgroundColor3", CurrentTheme.ContentBackground)
									local sliderTitle = item:FindFirstChild("SliderTitle")
									if sliderTitle then tweenColor(sliderTitle, "TextColor3", CurrentTheme.SecondaryText) end
									local valueDisplay = item:FindFirstChild("ValueDisplay")
									if valueDisplay then tweenColor(valueDisplay, "TextColor3", CurrentTheme.PrimaryText) end
									local sliderFrame = item:FindFirstChild("SliderFrame")
									if sliderFrame then
										tweenColor(sliderFrame, "BackgroundColor3", CurrentTheme.InputBackground)
										local currentValueFrame = sliderFrame:FindFirstChild("CurrentValueFrame")
										if currentValueFrame then tweenColor(currentValueFrame, "BackgroundColor3", CurrentTheme.AccentText) end
										local zipHandle = sliderFrame:FindFirstChild("Zip")
										if zipHandle then
											tweenColor(zipHandle, "BackgroundColor3", CurrentTheme.PrimaryText)
											tweenColor(zipHandle, "BorderColor3", CurrentTheme.ContentBackground)
											local valueBubble = zipHandle:FindFirstChild("ValueBubble")
											if valueBubble then
												tweenColor(valueBubble, "BackgroundColor3", CurrentTheme.TooltipBackground)
												tweenColor(valueBubble, "BorderColor3", CurrentTheme.InputOutline)
												local valueLabel = valueBubble:FindFirstChild("ValueLabel")
												if valueLabel then tweenColor(valueLabel, "TextColor3", CurrentTheme.TooltipText) end
											end
										end
									end
								elseif item.Name == "Separator" and item:IsA("Frame") then
									tweenColor(item, "BackgroundColor3", CurrentTheme.Separator)
								elseif item:FindFirstChild("TextboxTitle") and item:FindFirstChild("Outline") then
									local title = item:FindFirstChild("TextboxTitle")
									if title then tweenColor(title, "TextColor3", CurrentTheme.SecondaryText) end
									local outline = item:FindFirstChild("Outline")
									if outline then
										local isFocused = item:GetAttribute("IsFocused") or false
										tweenColor(outline, "BackgroundColor3", isFocused and CurrentTheme.InputOutlineFocus or CurrentTheme.InputOutline)
										local bg = outline:FindFirstChild("BG")
										if bg then
											tweenColor(bg, "BackgroundColor3", CurrentTheme.InputBackground)
											local inputBox = bg:FindFirstChildWhichIsA("TextBox")
											if inputBox then
												tweenColor(inputBox, "TextColor3", CurrentTheme.PrimaryText)
												inputBox.PlaceholderColor3 = CurrentTheme.MutedText
											end
										end
									end
								elseif item:FindFirstChildWhichIsA("TextLabel") and item.Name:match("_Label$") then
									tweenColor(item, "TextColor3", CurrentTheme.PrimaryText)
								elseif item:FindFirstChild("KeyButton") then
									local title = item:FindFirstChild("BindTitle")
									if title then tweenColor(title, "TextColor3", CurrentTheme.SecondaryText) end
									local keyButton = item:FindFirstChild("KeyButton")
									if keyButton then
										tweenColor(keyButton, "BackgroundColor3", CurrentTheme.InputBackground)
										if keyButton.Text ~= "..." then
											tweenColor(keyButton, "TextColor3", CurrentTheme.PrimaryText)
										else
											tweenColor(keyButton, "TextColor3", CurrentTheme.AccentText)
										end
									end
								end
							end
						end
					end
				end
			end
		end

		local function themePopup(popupName, holderName)
			local holder = mainFrame:FindFirstChild(holderName)
			if holder and holder.Parent and holder.Visible then
				tweenTransparency(holder, "BackgroundTransparency", 0.5)
				tweenColor(holder, "BackgroundColor3", CurrentTheme.PopupSecondaryBackground)
				local popup = holder:FindFirstChild(popupName)
				if popup then
					tweenColor(popup, "BackgroundColor3", CurrentTheme.PopupBackground)
					local text1 = popup:FindFirstChild("Text1")
					if text1 then tweenColor(text1, "TextColor3", CurrentTheme.HeaderText) end
					local text2 = popup:FindFirstChild("Text2")
					if text2 then tweenColor(text2, "TextColor3", CurrentTheme.SecondaryText) end
					local outline = popup:FindFirstChild("TextBoxFrameOutline")
					if outline then
						local isFocused = false
						local tb = outline:FindFirstChild("TextBoxFrame"):FindFirstChildWhichIsA("TextBox")
						if tb and UserInputService:GetFocusedTextBox() == tb then isFocused = true end
						tweenColor(outline, "BackgroundColor3", isFocused and CurrentTheme.InputOutlineFocus or CurrentTheme.InputOutline)
						local innerBg = outline:FindFirstChild("TextBoxFrame")
						if innerBg then
							tweenColor(innerBg, "BackgroundColor3", CurrentTheme.InputBackground)
							local input = innerBg:FindFirstChildWhichIsA("TextBox")
							if input then
								tweenColor(input, "TextColor3", CurrentTheme.PrimaryText)
								input.PlaceholderColor3 = CurrentTheme.MutedText
							end
						end
					end
					local underBar = popup:FindFirstChild("UnderBarFrame")
					if underBar then
						tweenColor(underBar, "BackgroundColor3", CurrentTheme.PopupSecondaryBackground)
						local changeBtn = underBar:FindFirstChild("ChangeBtn")
						if changeBtn then tweenColor(changeBtn, "BackgroundColor3", CurrentTheme.ButtonBackground); tweenColor(changeBtn, "TextColor3", CurrentTheme.ButtonText) end
						local resetBtn = underBar:FindFirstChild("ResetBtn")
						if resetBtn then tweenColor(resetBtn, "BackgroundColor3", CurrentTheme.ButtonSecondaryBackground); tweenColor(resetBtn, "TextColor3", CurrentTheme.ButtonText) end
						local closeBtn1 = underBar:FindFirstChild("CloseBtn1")
						if closeBtn1 then tweenColor(closeBtn1, "TextColor3", CurrentTheme.SecondaryText) end
						local alrightBtn = underBar:FindFirstChild("AlrightBtn")
						if alrightBtn then tweenColor(alrightBtn, "BackgroundColor3", CurrentTheme.ButtonBackground); tweenColor(alrightBtn, "TextColor3", CurrentTheme.ButtonText) end
					end
					local closeBtn2 = popup:FindFirstChild("CloseBtn2")
					if closeBtn2 then
						local closeIcon2 = closeBtn2:FindFirstChild("Close2Icon")
						if closeIcon2 then tweenColor(closeIcon2, "ImageColor3", CurrentTheme.IconColor) end
					end
				end
			end
		end

		themePopup("Notification", "NotificationHolderMain")
		themePopup("AvatarChangePopup", "AvatarChangeHolder")
		themePopup("UserChangePopup", "UserChangeHolder")

		if Elements.StatusIndicator then
			local statusDisplayName = GetTranslation(currentUserStatus)
			local statusKey = "Status" .. statusDisplayName:gsub(" ", "")
			tweenColor(Elements.StatusIndicator, "BackgroundColor3", CurrentTheme[statusKey] or CurrentTheme.StatusInvisible)
			tweenColor(Elements.StatusIndicator, "BorderColor3", CurrentTheme.UserPadBackground)
		end

		if not initialLoad then
			SaveInfo()
		end
	end

	local function ApplyStatus(statusKeyToUse, initialLoad)
		if not table.find(Statuses, statusKeyToUse) then
			warn("DiscordLib: Invalid status key provided to ApplyStatus:", statusKeyToUse)
			return
		end
		local statusDisplayName = GetTranslation(statusKeyToUse)

		currentUserStatus = statusKeyToUse
		CurrentTheme = Themes[currentThemeName]

		local themeStatusKey = "Status" .. statusDisplayName:gsub(" ", "")
		local targetColor = CurrentTheme[themeStatusKey] or CurrentTheme.StatusInvisible
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local indicator = Elements.StatusIndicator
		if indicator then
			if initialLoad then
				indicator.BackgroundColor3 = targetColor
			else
				TweenService:Create(indicator, tweenInfo, {BackgroundColor3 = targetColor}):Play()
			end
			tweenColor(indicator, "BorderColor3", CurrentTheme.UserPadBackground)
		end

		local settingsIndicator = Elements.SettingsStatusIndicator
		if settingsIndicator then
			if initialLoad then
				settingsIndicator.BackgroundColor3 = targetColor
			else
				TweenService:Create(settingsIndicator, tweenInfo, {BackgroundColor3 = targetColor}):Play()
			end
			tweenColor(settingsIndicator, "BorderColor3", CurrentTheme.SettingsUserPanelBackground)
		end

		if not initialLoad then
			SaveInfo()
		end
	end

	local function CreateCornerNotification(titletext, desctext)
		if Elements.CornerNotification and Elements.CornerNotification.Parent then
			Elements.CornerNotification:Destroy()
			Elements.CornerNotification = nil
		end

		local notifWidth = 280
		local notifHeight = 80
		local padding = 15
		local autoDismissDelay = 5

		local CornerNotifFrame = Instance.new("Frame")
		Elements.CornerNotification = CornerNotifFrame
		CornerNotifFrame.Name = "CornerNotification"
		CornerNotifFrame.Parent = Discord
		CornerNotifFrame.AnchorPoint = Vector2.new(1, 1)
		CornerNotifFrame.Position = UDim2.new(1, padding + notifWidth, 1, -padding)
		CornerNotifFrame.Size = UDim2.new(0, notifWidth, 0, notifHeight)
		CornerNotifFrame.BackgroundColor3 = CurrentTheme.TooltipBackground
		CornerNotifFrame.BackgroundTransparency = 0.1
		CornerNotifFrame.BorderSizePixel = 0
		CornerNotifFrame.ClipsDescendants = true
		CornerNotifFrame.ZIndex = 100

		local Corner = Instance.new("UICorner", CornerNotifFrame)
		Corner.CornerRadius = UDim.new(0, 6)

		local NotifPadding = Instance.new("UIPadding", CornerNotifFrame)
		NotifPadding.PaddingTop = UDim.new(0, 8)
		NotifPadding.PaddingBottom = UDim.new(0, 8)
		NotifPadding.PaddingLeft = UDim.new(0, 12)
		NotifPadding.PaddingRight = UDim.new(0, 12)

		local NotifLayout = Instance.new("UIListLayout", CornerNotifFrame)
		NotifLayout.Padding = UDim.new(0, 4)
		NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder

		local NotifTitle = Instance.new("TextLabel", CornerNotifFrame)
		NotifTitle.Name = "Title"
		NotifTitle.LayoutOrder = 1
		NotifTitle.BackgroundTransparency = 1
		NotifTitle.Size = UDim2.new(1, 0, 0, 18)
		NotifTitle.Font = Enum.Font.GothamMedium
		NotifTitle.Text = titletext
		NotifTitle.TextColor3 = CurrentTheme.TooltipText
		NotifTitle.TextSize = 14
		NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
		NotifTitle.TextTruncate = Enum.TextTruncate.AtEnd

		local NotifDesc = Instance.new("TextLabel", CornerNotifFrame)
		NotifDesc.Name = "Description"
		NotifDesc.LayoutOrder = 2
		NotifDesc.BackgroundTransparency = 1
		NotifDesc.Size = UDim2.new(1, 0, 1, -26)
		NotifDesc.Font = Enum.Font.Gotham
		NotifDesc.Text = desctext
		NotifDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
		NotifDesc.TextSize = 12
		NotifDesc.TextWrapped = true
		NotifDesc.TextXAlignment = Enum.TextXAlignment.Left
		NotifDesc.TextYAlignment = Enum.TextYAlignment.Top

		local CloseNotifBtn = Instance.new("ImageButton", CornerNotifFrame)
		CloseNotifBtn.Name = "CloseCornerNotifBtn"
		CloseNotifBtn.BackgroundTransparency = 1
		CloseNotifBtn.AnchorPoint = Vector2.new(1, 0)
		CloseNotifBtn.Position = UDim2.new(1, -5, 0, 5)
		CloseNotifBtn.Size = UDim2.new(0, 16, 0, 16)
		CloseNotifBtn.ZIndex = CornerNotifFrame.ZIndex + 1
		CloseNotifBtn.Image = "http://www.roblox.com/asset/?id=6035047409"
		CloseNotifBtn.ImageColor3 = CurrentTheme.IconMuted

		local function dismissNotification(animate)
			if CornerNotifFrame and CornerNotifFrame.Parent then
				if Elements.CornerNotification == CornerNotifFrame then
					Elements.CornerNotification = nil
				end
				if animate then
					TweenService:Create(CornerNotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
						Position = UDim2.new(1, padding + notifWidth, 1, -padding)
					}):Play()
					task.wait(0.3)
					if CornerNotifFrame and CornerNotifFrame.Parent then CornerNotifFrame:Destroy() end
				else
					CornerNotifFrame:Destroy()
				end
			end
		end

		CloseNotifBtn.MouseButton1Click:Connect(function() dismissNotification(true) end)
		CloseNotifBtn.MouseEnter:Connect(function() CloseNotifBtn.ImageColor3 = CurrentTheme.IconHoverColor end)
		CloseNotifBtn.MouseLeave:Connect(function() CloseNotifBtn.ImageColor3 = CurrentTheme.IconMuted end)

		TweenService:Create(CornerNotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(1, -padding, 1, -padding)
		}):Play()

		task.delay(autoDismissDelay, function()
			if CornerNotifFrame and CornerNotifFrame.Parent and Elements.CornerNotification == CornerNotifFrame then
				dismissNotification(true)
			end
		end)
	end

	Discord = Instance.new("ScreenGui")
	Discord.Name = "DiscordLib_" .. HttpService:GenerateGUID(false)
	if RunService:IsStudio() then
		Discord.Parent = LocalPlayer and LocalPlayer.PlayerGui or CoreGui
	else
		Discord.Parent = CoreGui
	end
	Discord.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	Discord.ResetOnSpawn = false

	local MainFrame = Instance.new("Frame")
	Elements.MainFrame = MainFrame
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = Discord
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Size = UDim2.new(0, 681, 0, 396)

	local TopFrame = Instance.new("Frame")
	Elements.TopFrame = TopFrame
	TopFrame.Name = "TopFrame"
	TopFrame.Parent = MainFrame
	TopFrame.BorderSizePixel = 0
	TopFrame.Position = UDim2.new(0, 0, 0, 0)
	TopFrame.Size = UDim2.new(1, 0, 0, 22)
	TopFrame.ZIndex = 5

	local Title = Instance.new("TextLabel")
	Elements.Title = Title
	Title.Name = "Title"
	Title.Parent = TopFrame
	Title.BackgroundTransparency = 1.000
	Title.Position = UDim2.new(0.01, 0, 0, 0)
	Title.Size = UDim2.new(0, 192, 1, 0)
	Title.Font = Enum.Font.Gotham
	Title.Text = text
	Title.TextSize = 13.000
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local CloseBtn = Instance.new("TextButton")
	Elements.CloseBtn = CloseBtn
	CloseBtn.Name = "CloseBtn"
	CloseBtn.Parent = TopFrame
	CloseBtn.Position = UDim2.new(1, -28, 0, 0)
	CloseBtn.Size = UDim2.new(0, 28, 0, 22)
	CloseBtn.Font = Enum.Font.SourceSans
	CloseBtn.Text = ""
	CloseBtn.BorderSizePixel = 0
	CloseBtn.AutoButtonColor = false

	local CloseIcon = Instance.new("ImageLabel")
	Elements.CloseIcon = CloseIcon
	CloseIcon.Name = "CloseIcon"
	CloseIcon.Parent = CloseBtn
	CloseIcon.BackgroundTransparency = 1.000
	CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	CloseIcon.Size = UDim2.new(0, 17, 0, 17)
	CloseIcon.Image = "http://www.roblox.com/asset/?id=6035047409"

	local MinimizeBtn = Instance.new("TextButton")
	Elements.MinimizeBtn = MinimizeBtn
	MinimizeBtn.Name = "MinimizeBtn"
	MinimizeBtn.Parent = TopFrame
	MinimizeBtn.Position = UDim2.new(1, -56, 0, 0)
	MinimizeBtn.Size = UDim2.new(0, 28, 0, 22)
	MinimizeBtn.Font = Enum.Font.SourceSans
	MinimizeBtn.Text = ""
	MinimizeBtn.BorderSizePixel = 0
	MinimizeBtn.AutoButtonColor = false

	local MinimizeIcon = Instance.new("ImageLabel")
	Elements.MinimizeIcon = MinimizeIcon
	MinimizeIcon.Name = "MinimizeIcon"
	MinimizeIcon.Parent = MinimizeBtn
	MinimizeIcon.BackgroundTransparency = 1.000
	MinimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	MinimizeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	MinimizeIcon.Size = UDim2.new(0, 17, 0, 17)
	MinimizeIcon.Image = "http://www.roblox.com/asset/?id=6035067836"

	local ServersHolderFolder = Instance.new("Folder")
	ServersHolderFolder.Name = "ServersHolderFolder"
	Elements.ServersHolderFolder = ServersHolderFolder
	ServersHolderFolder.Parent = MainFrame

	local ContentContainer = Instance.new("Frame")
	ContentContainer.Name = "ContentContainer"
	Elements.ContentContainer = ContentContainer
	ContentContainer.Parent = MainFrame
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.BorderSizePixel = 0
	ContentContainer.Position = UDim2.new(0, 71, 0, 22)
	ContentContainer.Size = UDim2.new(1, -71, 1, -22)
	ContentContainer.ClipsDescendants = true
	ContentContainer.ZIndex = 3

	local Userpad = Instance.new("Frame")
	Elements.Userpad = Userpad
	Userpad.Name = "Userpad"
	Userpad.Parent = MainFrame
	Userpad.BorderSizePixel = 0
	Userpad.Position = UDim2.new(0, 71, 1, -43)
	Userpad.Size = UDim2.new(0, 240, 0, 43)
	Userpad.ZIndex = 3

	local UserIconButton = Instance.new("TextButton")
	Elements.UserIconButton = UserIconButton
	UserIconButton.Name = "UserIcon"
	UserIconButton.Parent = Userpad
	UserIconButton.BackgroundTransparency = 1
	UserIconButton.BorderSizePixel = 0
	UserIconButton.Position = UDim2.new(0, 8, 0.5, 0)
	UserIconButton.AnchorPoint = Vector2.new(0, 0.5)
	UserIconButton.Size = UDim2.new(0, 32, 0, 32)
	UserIconButton.AutoButtonColor = false
	UserIconButton.Text = ""
	UserIconButton.ZIndex = 2

	local UserIconCorner = Instance.new("UICorner")
	UserIconCorner.CornerRadius = UDim.new(1, 0)
	UserIconCorner.Parent = UserIconButton

	local UserImage = Instance.new("ImageLabel")
	Elements.UserImage = UserImage
	UserImage.Name = "UserImage"
	UserImage.Parent = UserIconButton
	UserImage.BackgroundTransparency = 1.000
	UserImage.Size = UDim2.new(1, 0, 1, 0)
	UserImage.Image = pfp
	UserImage.ZIndex = 1

	local UserCircleImage = Instance.new("ImageLabel")
	Elements.UserCircleImage = UserCircleImage
	UserCircleImage.Name = "UserCircleImage"
	UserCircleImage.Parent = UserImage
	UserCircleImage.BackgroundTransparency = 1.000
	UserCircleImage.Size = UDim2.new(1, 0, 1, 0)
	UserCircleImage.Image = "rbxassetid://4031889928"
	UserCircleImage.ScaleType = Enum.ScaleType.Slice
	UserCircleImage.SliceCenter = Rect.new(100, 100, 100, 100)
	UserCircleImage.ZIndex = UserImage.ZIndex + 1

	local StatusIndicator = Instance.new("Frame")
	Elements.StatusIndicator = StatusIndicator
	StatusIndicator.Name = "StatusIndicator"
	StatusIndicator.Parent = UserIconButton
	StatusIndicator.BorderSizePixel = 2
	StatusIndicator.AnchorPoint = Vector2.new(1, 1)
	StatusIndicator.Position = UDim2.new(1, 0, 1, 0)
	StatusIndicator.Size = UDim2.new(0, 10, 0, 10)
	StatusIndicator.ZIndex = UserCircleImage.ZIndex + 1

	local StatusIndicatorCorner = Instance.new("UICorner")
	StatusIndicatorCorner.CornerRadius = UDim.new(1, 0)
	StatusIndicatorCorner.Parent = StatusIndicator

	local UserName = Instance.new("TextLabel")
	Elements.UserName = UserName
	UserName.Name = "UserName"
	UserName.Parent = Userpad
	UserName.BackgroundTransparency = 1.000
	UserName.BorderSizePixel = 0
	UserName.Position = UDim2.new(0, 48, 0.5, 0)
	UserName.AnchorPoint = Vector2.new(0, 0.5)
	UserName.Size = UDim2.new(1, -80, 0, 17)
	UserName.Font = Enum.Font.GothamMedium
	UserName.Text = user
	UserName.TextSize = 13.000
	UserName.TextXAlignment = Enum.TextXAlignment.Left
	UserName.ClipsDescendants = true

	local SettingsOpenBtn = Instance.new("TextButton")
	SettingsOpenBtn.Name = "SettingsOpenBtn"
	SettingsOpenBtn.Parent = Userpad
	SettingsOpenBtn.BackgroundTransparency = 1.000
	SettingsOpenBtn.AnchorPoint = Vector2.new(1, 0.5)
	SettingsOpenBtn.Position = UDim2.new(1, -8, 0.5, 0)
	SettingsOpenBtn.Size = UDim2.new(0, 24, 0, 24)
	SettingsOpenBtn.Text = ""
	SettingsOpenBtn.AutoButtonColor = false
	SettingsOpenBtn.ZIndex = 2

	local SettingsOpenBtnIco = Instance.new("ImageLabel")
	SettingsOpenBtnIco.Name = "SettingsOpenBtnIco"
	SettingsOpenBtnIco.Parent = SettingsOpenBtn
	SettingsOpenBtnIco.BackgroundTransparency = 1.000
	SettingsOpenBtnIco.AnchorPoint = Vector2.new(0.5, 0.5)
	SettingsOpenBtnIco.Position = UDim2.new(0.5, 0, 0.5, 0)
	SettingsOpenBtnIco.Size = UDim2.new(0, 18, 0, 18)
	SettingsOpenBtnIco.Image = "http://www.roblox.com/asset/?id=6031280882"

	local ServersHoldFrame = Instance.new("Frame")
	Elements.ServersHoldFrame = ServersHoldFrame
	ServersHoldFrame.Name = "ServersHoldFrame"
	ServersHoldFrame.Parent = MainFrame
	ServersHoldFrame.BorderSizePixel = 0
	ServersHoldFrame.Position = UDim2.new(0, 0, 0, 22)
	ServersHoldFrame.Size = UDim2.new(0, 71, 1, -22)
	ServersHoldFrame.ZIndex = 1

	local ServersHold = Instance.new("ScrollingFrame")
	Elements.ServersHold = ServersHold
	ServersHold.Name = "ServersHold"
	ServersHold.Parent = ServersHoldFrame
	ServersHold.Active = true
	ServersHold.BackgroundTransparency = 0.000
	ServersHold.BorderSizePixel = 0
	ServersHold.Position = UDim2.new(0, 0, 0, 0)
	ServersHold.Size = UDim2.new(1, 0, 1, 0)
	ServersHold.ScrollBarThickness = 4
	ServersHold.ScrollBarImageTransparency = 1
	ServersHold.CanvasSize = UDim2.new(0, 0, 0, 0)
	ServersHold.ScrollingDirection = Enum.ScrollingDirection.Y
	ServersHold.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

	local ServersHoldLayout = Instance.new("UIListLayout")
	ServersHoldLayout.Name = "ServersHoldLayout"
	ServersHoldLayout.Parent = ServersHold
	ServersHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ServersHoldLayout.Padding = UDim.new(0, 7)
	ServersHoldLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local ServersHoldPadding = Instance.new("UIPadding")
	ServersHoldPadding.Name = "ServersHoldPadding"
	ServersHoldPadding.Parent = ServersHold
	ServersHoldPadding.PaddingTop = UDim.new(0, 10)

	local SettingsFrame = Instance.new("Frame")
	Elements.SettingsFrame = SettingsFrame
	SettingsFrame.Name = "SettingsFrame"
	SettingsFrame.Parent = MainFrame
	SettingsFrame.Size = UDim2.new(1, -71, 1, -22)
	SettingsFrame.Position = UDim2.new(0, 71, 0, 22)
	SettingsFrame.Visible = false
	SettingsFrame.ClipsDescendants = true
	SettingsFrame.ZIndex = 10

	local Settings = Instance.new("Frame")
	Elements.Settings = Settings
	Settings.Name = "Settings"
	Settings.Parent = SettingsFrame
	Settings.BorderSizePixel = 0
	Settings.Position = UDim2.new(0, 0, 0, 0)
	Settings.Size = UDim2.new(1, 0, 1, 0)
	Settings.ClipsDescendants = true

	local SettingsHolder = Instance.new("Frame")
	Elements.SettingsHolder = SettingsHolder
	SettingsHolder.Name = "SettingsHolder"
	SettingsHolder.Parent = Settings
	SettingsHolder.BackgroundTransparency = 1.000
	SettingsHolder.ClipsDescendants = true
	SettingsHolder.Position = UDim2.new(0, 0, 0, 0)
	SettingsHolder.Size = UDim2.new(1, 0, 1, 0)

	local CloseSettingsBtn = Instance.new("TextButton")
	Elements.CloseSettingsBtn = CloseSettingsBtn
	CloseSettingsBtn.Name = "CloseSettingsBtn"
	CloseSettingsBtn.Parent = SettingsHolder
	CloseSettingsBtn.AnchorPoint = Vector2.new(1, 0)
	CloseSettingsBtn.BackgroundTransparency = 1
	CloseSettingsBtn.Position = UDim2.new(1, -15, 0, 15)
	CloseSettingsBtn.Selectable = false
	CloseSettingsBtn.Size = UDim2.new(0, 30, 0, 30)
	CloseSettingsBtn.AutoButtonColor = false
	CloseSettingsBtn.Font = Enum.Font.SourceSans
	CloseSettingsBtn.Text = ""
	CloseSettingsBtn.ZIndex = 5

	local CloseSettingsBtnCorner = Instance.new("UICorner")
	CloseSettingsBtnCorner.CornerRadius = UDim.new(1, 0)
	CloseSettingsBtnCorner.Parent = CloseSettingsBtn

	local CloseSettingsBtnCircle = Instance.new("Frame")
	Elements.CloseSettingsBtnCircle = CloseSettingsBtnCircle
	CloseSettingsBtnCircle.Name = "CloseSettingsBtnCircle"
	CloseSettingsBtnCircle.Parent = CloseSettingsBtn
	CloseSettingsBtnCircle.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseSettingsBtnCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
	CloseSettingsBtnCircle.Size = UDim2.new(0, 24, 0, 24)

	local CloseSettingsBtnCircleCorner = Instance.new("UICorner")
	CloseSettingsBtnCircleCorner.CornerRadius = UDim.new(1, 0)
	CloseSettingsBtnCircleCorner.Parent = CloseSettingsBtnCircle

	local CloseSettingsBtnIcon = Instance.new("ImageLabel")
	Elements.CloseSettingsBtnIcon = CloseSettingsBtnIcon
	CloseSettingsBtnIcon.Name = "CloseSettingsBtnIcon"
	CloseSettingsBtnIcon.Parent = CloseSettingsBtnCircle
	CloseSettingsBtnIcon.BackgroundTransparency = 1.000
	CloseSettingsBtnIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseSettingsBtnIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	CloseSettingsBtnIcon.Size = UDim2.new(0, 19, 0, 19)
	CloseSettingsBtnIcon.Image = "http://www.roblox.com/asset/?id=6035047409"

	local CloseSettingsKeybindHint = Instance.new("TextLabel")
	Elements.CloseSettingsKeybindHint = CloseSettingsKeybindHint
	CloseSettingsKeybindHint.Name = "TextLabel"
	CloseSettingsKeybindHint.Parent = CloseSettingsBtn
	CloseSettingsKeybindHint.BackgroundTransparency = 1.000
	CloseSettingsKeybindHint.Position = UDim2.new(0.5, 0, 1, 5)
	CloseSettingsKeybindHint.AnchorPoint = Vector2.new(0.5, 0)
	CloseSettingsKeybindHint.Size = UDim2.new(0, 34, 0, 15)
	CloseSettingsKeybindHint.Font = Enum.Font.GothamMedium
	CloseSettingsKeybindHint.Text = GetTranslation("settings_escHint")
	CloseSettingsKeybindHint.TextSize = 11.000
	CloseSettingsKeybindHint.ZIndex = CloseSettingsBtn.ZIndex

	local LeftFrame = Instance.new("Frame")
	Elements.LeftFrame = LeftFrame
	LeftFrame.Name = "LeftFrame"
	LeftFrame.Parent = SettingsHolder
	LeftFrame.BorderSizePixel = 0
	LeftFrame.Position = UDim2.new(0, 0, 0, 0)
	LeftFrame.Size = UDim2.new(0, 218, 1, 0)

	local LeftFramePadding = Instance.new("UIPadding")
	LeftFramePadding.Parent = LeftFrame
	LeftFramePadding.PaddingTop = UDim.new(0, 60)
	LeftFramePadding.PaddingLeft = UDim.new(0, 20)
	LeftFramePadding.PaddingRight = UDim.new(0, 20)
	LeftFramePadding.PaddingBottom = UDim.new(0, 60)

	local LeftListLayout = Instance.new("UIListLayout")
	LeftListLayout.Parent = LeftFrame
	LeftListLayout.Padding = UDim.new(0, 2)
	LeftListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	LeftListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

	local SettingsTitle = Instance.new("TextLabel")
	Elements.SettingsTitle = SettingsTitle
	SettingsTitle.Name = "SettingsTitle"
	SettingsTitle.Parent = LeftFrame
	SettingsTitle.LayoutOrder = 1
	SettingsTitle.BackgroundTransparency = 1.000
	SettingsTitle.Size = UDim2.new(1, -10, 0, 19)
	SettingsTitle.Font = Enum.Font.GothamBold
	SettingsTitle.Text = GetTranslation("settings_userSettings")
	SettingsTitle.TextSize = 11.000
	SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left

	local MyAccountBtn = Instance.new("TextButton")
	Elements.MyAccountBtn = MyAccountBtn
	MyAccountBtn.Name = "MyAccountBtn"
	MyAccountBtn.Parent = LeftFrame
	MyAccountBtn.LayoutOrder = 2
	MyAccountBtn.BorderSizePixel = 0
	MyAccountBtn.Size = UDim2.new(1, 0, 0, 32)
	MyAccountBtn.AutoButtonColor = false
	MyAccountBtn.Font = Enum.Font.SourceSans
	MyAccountBtn.Text = ""

	local MyAccountBtnCorner = Instance.new("UICorner")
	MyAccountBtnCorner.CornerRadius = UDim.new(0, 4)
	MyAccountBtnCorner.Parent = MyAccountBtn

	local MyAccountBtnTitle = Instance.new("TextLabel")
	Elements.MyAccountBtnTitle = MyAccountBtnTitle
	MyAccountBtnTitle.Name = "MyAccountBtnTitle"
	MyAccountBtnTitle.Parent = MyAccountBtn
	MyAccountBtnTitle.BackgroundTransparency = 1.000
	MyAccountBtnTitle.Position = UDim2.new(0, 12, 0, 0)
	MyAccountBtnTitle.Size = UDim2.new(1, -24, 1, 0)
	MyAccountBtnTitle.Font = Enum.Font.GothamMedium
	MyAccountBtnTitle.Text = GetTranslation("settings_myAccount")
	MyAccountBtnTitle.TextSize = 15.000
	MyAccountBtnTitle.TextXAlignment = Enum.TextXAlignment.Left

	local AppearanceBtn = Instance.new("TextButton")
	Elements.AppearanceBtn = AppearanceBtn
	AppearanceBtn.Name = "AppearanceBtn"
	AppearanceBtn.Parent = LeftFrame
	AppearanceBtn.LayoutOrder = 3
	AppearanceBtn.BorderSizePixel = 0
	AppearanceBtn.Size = UDim2.new(1, 0, 0, 32)
	AppearanceBtn.AutoButtonColor = false
	AppearanceBtn.Font = Enum.Font.SourceSans
	AppearanceBtn.Text = ""

	local AppearanceBtnCorner = Instance.new("UICorner")
	AppearanceBtnCorner.CornerRadius = UDim.new(0, 4)
	AppearanceBtnCorner.Parent = AppearanceBtn

	local AppearanceBtnTitle = Instance.new("TextLabel")
	Elements.AppearanceBtnTitle = AppearanceBtnTitle
	AppearanceBtnTitle.Name = "AppearanceBtnTitle"
	AppearanceBtnTitle.Parent = AppearanceBtn
	AppearanceBtnTitle.BackgroundTransparency = 1.000
	AppearanceBtnTitle.Position = UDim2.new(0, 12, 0, 0)
	AppearanceBtnTitle.Size = UDim2.new(1, -24, 1, 0)
	AppearanceBtnTitle.Font = Enum.Font.GothamMedium
	AppearanceBtnTitle.Text = GetTranslation("settings_appearance")
	AppearanceBtnTitle.TextSize = 15.000
	AppearanceBtnTitle.TextXAlignment = Enum.TextXAlignment.Left

	local LanguageBtn = Instance.new("TextButton")
	Elements.LanguageBtn = LanguageBtn
	LanguageBtn.Name = "LanguageBtn"
	LanguageBtn.Parent = LeftFrame
	LanguageBtn.LayoutOrder = 4
	LanguageBtn.BorderSizePixel = 0
	LanguageBtn.Size = UDim2.new(1, 0, 0, 32)
	LanguageBtn.AutoButtonColor = false
	LanguageBtn.Font = Enum.Font.SourceSans
	LanguageBtn.Text = ""

	local LanguageBtnCorner = Instance.new("UICorner")
	LanguageBtnCorner.CornerRadius = UDim.new(0, 4)
	LanguageBtnCorner.Parent = LanguageBtn

	local LanguageBtnTitle = Instance.new("TextLabel")
	Elements.LanguageBtnTitle = LanguageBtnTitle
	LanguageBtnTitle.Name = "LanguageBtnTitle"
	LanguageBtnTitle.Parent = LanguageBtn
	LanguageBtnTitle.BackgroundTransparency = 1.000
	LanguageBtnTitle.Position = UDim2.new(0, 12, 0, 0)
	LanguageBtnTitle.Size = UDim2.new(1, -24, 1, 0)
	LanguageBtnTitle.Font = Enum.Font.GothamMedium
	LanguageBtnTitle.Text = GetTranslation("settings_language")
	LanguageBtnTitle.TextSize = 15.000
	LanguageBtnTitle.TextXAlignment = Enum.TextXAlignment.Left

	local SettingsSeparator = Instance.new("Frame")
	SettingsSeparator.Name = "SettingsSeparator"
	SettingsSeparator.Parent = LeftFrame
	SettingsSeparator.LayoutOrder = 5
	SettingsSeparator.BorderSizePixel = 0
	SettingsSeparator.Size = UDim2.new(1, -10, 0, 1)
	SettingsSeparator.Position = UDim2.new(0, 5, 0, 0)

	local Spacer = Instance.new("Frame")
	Spacer.Name = "Spacer"
	Spacer.Parent = LeftFrame
	Spacer.LayoutOrder = 100
	Spacer.BackgroundTransparency = 1
	Spacer.Size = UDim2.new(1, 0, 1, -134)

	local DiscordInfo = Instance.new("TextLabel")
	Elements.DiscordInfo = DiscordInfo
	DiscordInfo.Name = "DiscordInfo"
	DiscordInfo.Parent = LeftFrame
	DiscordInfo.LayoutOrder = 101
	DiscordInfo.BackgroundTransparency = 1.000
	DiscordInfo.Size = UDim2.new(1, 0, 0, 44)
	DiscordInfo.Font = Enum.Font.Gotham
	DiscordInfo.Text = Languages["en"].settings_discordInfo
	DiscordInfo.TextSize = 11.000
	DiscordInfo.TextWrapped = true
	DiscordInfo.TextXAlignment = Enum.TextXAlignment.Left
	DiscordInfo.TextYAlignment = Enum.TextYAlignment.Top

	local UserPanel = Instance.new("Frame")
	Elements.UserPanel = UserPanel
	UserPanel.Name = "UserPanel"
	UserPanel.Parent = SettingsHolder
	UserPanel.BorderSizePixel = 0
	UserPanel.Position = UDim2.new(0, 218, 0, 0)
	UserPanel.Size = UDim2.new(1, -218, 1, 0)
	UserPanel.Visible = true
	UserPanel.ClipsDescendants = true

	local UserPanelPadding = Instance.new("UIPadding")
	UserPanelPadding.Parent = UserPanel
	UserPanelPadding.PaddingTop = UDim.new(0, 60)
	UserPanelPadding.PaddingLeft = UDim.new(0, 40)
	UserPanelPadding.PaddingRight = UDim.new(0, 40)
	UserPanelPadding.PaddingBottom = UDim.new(0, 20)

	local CurrentSettingOpen = Instance.new("TextLabel")
	Elements.CurrentSettingOpen = CurrentSettingOpen
	CurrentSettingOpen.Name = "CurrentSettingOpen"
	CurrentSettingOpen.Parent = UserPanel
	CurrentSettingOpen.BackgroundTransparency = 1.000
	CurrentSettingOpen.Position = UDim2.new(0, 0, 0, 0)
	CurrentSettingOpen.Size = UDim2.new(1, 0, 0, 19)
	CurrentSettingOpen.Font = Enum.Font.GothamBold
	CurrentSettingOpen.Text = GetTranslation("header_myAccount")
	CurrentSettingOpen.TextSize = 16.000
	CurrentSettingOpen.TextXAlignment = Enum.TextXAlignment.Left

	local UserSettingsCard = Instance.new("Frame")
	Elements.UserSettingsCard = UserSettingsCard
	UserSettingsCard.Name = "UserSettingsCard"
	UserSettingsCard.Parent = UserPanel
	UserSettingsCard.BorderSizePixel = 0
	UserSettingsCard.Position = UDim2.new(0, 0, 0, 40)
	UserSettingsCard.Size = UDim2.new(1, 0, 0, 100)

	local UserSettingsCardCorner = Instance.new("UICorner")
	UserSettingsCardCorner.CornerRadius = UDim.new(0, 8)
	UserSettingsCardCorner.Parent = UserSettingsCard

	local UserPanelUserIcon = Instance.new("TextButton")
	Elements.UserPanelUserIcon = UserPanelUserIcon
	UserPanelUserIcon.Name = "UserPanelUserIcon"
	UserPanelUserIcon.Parent = UserSettingsCard
	UserPanelUserIcon.BackgroundTransparency = 1
	UserPanelUserIcon.BorderSizePixel = 0
	UserPanelUserIcon.Position = UDim2.new(0, 20, 0, 15)
	UserPanelUserIcon.Size = UDim2.new(0, 70, 0, 70)
	UserPanelUserIcon.AutoButtonColor = false
	UserPanelUserIcon.Text = ""
	UserPanelUserIcon.ZIndex = 2

	local UserPanelUserImage = Instance.new("ImageLabel")
	Elements.UserPanelUserImage = UserPanelUserImage
	UserPanelUserImage.Name = "UserPanelUserImage"
	UserPanelUserImage.Parent = UserPanelUserIcon
	UserPanelUserImage.BackgroundTransparency = 1.000
	UserPanelUserImage.Size = UDim2.new(1, 0, 1, 0)
	UserPanelUserImage.Image = pfp
	UserPanelUserImage.ZIndex = 1

	local UserPanelUserCircle = Instance.new("ImageLabel")
	Elements.UserPanelUserCircle = UserPanelUserCircle
	UserPanelUserCircle.Name = "UserPanelUserCircle"
	UserPanelUserCircle.Parent = UserPanelUserImage
	UserPanelUserCircle.BackgroundTransparency = 1.000
	UserPanelUserCircle.Size = UDim2.new(1, 0, 1, 0)
	UserPanelUserCircle.Image = "rbxassetid://4031889928"
	UserPanelUserCircle.ScaleType = Enum.ScaleType.Slice
	UserPanelUserCircle.SliceCenter = Rect.new(100, 100, 100, 100)
	UserPanelUserCircle.ZIndex = UserPanelUserImage.ZIndex + 1

	local BlackFrame = Instance.new("Frame")
	Elements.BlackFrame = BlackFrame
	BlackFrame.Name = "BlackFrame"
	BlackFrame.Parent = UserPanelUserIcon
	BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	BlackFrame.BackgroundTransparency = 0.400
	BlackFrame.BorderSizePixel = 0
	BlackFrame.Size = UDim2.new(1, 0, 1, 0)
	BlackFrame.Visible = false
	BlackFrame.ZIndex = UserPanelUserCircle.ZIndex + 1

	local BlackFrameCorner = Instance.new("UICorner")
	BlackFrameCorner.CornerRadius = UDim.new(1, 0)
	BlackFrameCorner.Parent = BlackFrame

	local ChangeAvatarText = Instance.new("TextLabel")
	Elements.ChangeAvatarText = ChangeAvatarText
	ChangeAvatarText.Name = "ChangeAvatarText"
	ChangeAvatarText.Parent = BlackFrame
	ChangeAvatarText.BackgroundTransparency = 1.000
	ChangeAvatarText.Size = UDim2.new(1, 0, 1, 0)
	ChangeAvatarText.Font = Enum.Font.GothamBold
	ChangeAvatarText.Text = GetTranslation("account_changeAvatarHover")
	ChangeAvatarText.TextColor3 = Color3.fromRGB(255, 255, 255)
	ChangeAvatarText.TextSize = 11.000
	ChangeAvatarText.TextWrapped = true
	ChangeAvatarText.TextYAlignment = Enum.TextYAlignment.Center

	local SettingsStatusIndicator = Instance.new("Frame")
	Elements.SettingsStatusIndicator = SettingsStatusIndicator
	SettingsStatusIndicator.Name = "SettingsStatusIndicator"
	SettingsStatusIndicator.Parent = UserPanelUserIcon
	SettingsStatusIndicator.BorderSizePixel = 3
	SettingsStatusIndicator.AnchorPoint = Vector2.new(1, 1)
	SettingsStatusIndicator.Position = UDim2.new(1, 4, 1, 4)
	SettingsStatusIndicator.Size = UDim2.new(0, 14, 0, 14)
	SettingsStatusIndicator.ZIndex = BlackFrame.ZIndex + 1

	local SettingsStatusIndicatorCorner = Instance.new("UICorner")
	SettingsStatusIndicatorCorner.CornerRadius = UDim.new(1, 0)
	SettingsStatusIndicatorCorner.Parent = SettingsStatusIndicator

	local UserPanelUser = Instance.new("TextLabel")
	Elements.UserPanelUser = UserPanelUser
	UserPanelUser.Name = "UserPanelUser"
	UserPanelUser.Parent = UserSettingsCard
	UserPanelUser.BackgroundTransparency = 1.000
	UserPanelUser.Position = UDim2.new(0, 110, 0, 40)
	UserPanelUser.AnchorPoint = Vector2.new(0, 0.5)
	UserPanelUser.Size = UDim2.new(0, 200, 0, 19)
	UserPanelUser.Font = Enum.Font.GothamMedium
	UserPanelUser.TextSize = 17.000
	UserPanelUser.TextXAlignment = Enum.TextXAlignment.Left
	UserPanelUser.Text = user

	local UserSettingsPad = Instance.new("Frame")
	Elements.UserSettingsPad = UserSettingsPad
	UserSettingsPad.Name = "UserSettingsPad"
	UserSettingsPad.Parent = UserPanel
	UserSettingsPad.BorderSizePixel = 0
	UserSettingsPad.Position = UDim2.new(0, 0, 0, 155)
	UserSettingsPad.Size = UDim2.new(1, 0, 0, 56)

	local UserSettingsPadCorner = Instance.new("UICorner")
	UserSettingsPadCorner.CornerRadius = UDim.new(0, 5)
	UserSettingsPadCorner.Parent = UserSettingsPad

	local UsernameTextLabel = Instance.new("TextLabel")
	Elements.UsernameTextLabel = UsernameTextLabel
	UsernameTextLabel.Name = "UsernameText"
	UsernameTextLabel.Parent = UserSettingsPad
	UsernameTextLabel.BackgroundTransparency = 1.000
	UsernameTextLabel.Position = UDim2.new(0, 15, 0, 8)
	UsernameTextLabel.Size = UDim2.new(0, 100, 0, 15)
	UsernameTextLabel.Font = Enum.Font.GothamBold
	UsernameTextLabel.Text = GetTranslation("account_usernameLabel")
	UsernameTextLabel.TextSize = 10.000
	UsernameTextLabel.TextXAlignment = Enum.TextXAlignment.Left

	local UserSettingsPadUser = Instance.new("TextLabel")
	Elements.UserSettingsPadUser = UserSettingsPadUser
	UserSettingsPadUser.Name = "UserSettingsPadUser"
	UserSettingsPadUser.Parent = UserSettingsPad
	UserSettingsPadUser.BackgroundTransparency = 1.000
	UserSettingsPadUser.Position = UDim2.new(0, 15, 0, 25)
	UserSettingsPadUser.Size = UDim2.new(0.6, 0, 0, 19)
	UserSettingsPadUser.Font = Enum.Font.Gotham
	UserSettingsPadUser.TextSize = 14.000
	UserSettingsPadUser.TextXAlignment = Enum.TextXAlignment.Left
	UserSettingsPadUser.Text = user

	local EditBtn = Instance.new("TextButton")
	Elements.EditBtn = EditBtn
	EditBtn.Name = "EditBtn"
	EditBtn.Parent = UserSettingsPad
	EditBtn.AnchorPoint = Vector2.new(1, 0.5)
	EditBtn.Position = UDim2.new(1, -15, 0.5, 0)
	EditBtn.Size = UDim2.new(0, 65, 0, 32)
	EditBtn.Font = Enum.Font.GothamMedium
	EditBtn.Text = GetTranslation("account_editButton")
	EditBtn.TextSize = 14.000
	EditBtn.AutoButtonColor = false

	local EditBtnCorner = Instance.new("UICorner")
	EditBtnCorner.CornerRadius = UDim.new(0, 3)
	EditBtnCorner.Parent = EditBtn

	local AppearancePanel = Instance.new("Frame")
	Elements.AppearancePanel = AppearancePanel
	AppearancePanel.Name = "AppearancePanel"
	AppearancePanel.Parent = SettingsHolder
	AppearancePanel.BorderSizePixel = 0
	AppearancePanel.Position = UDim2.new(0, 218, 0, 0)
	AppearancePanel.Size = UDim2.new(1, -218, 1, 0)
	AppearancePanel.Visible = false
	AppearancePanel.ClipsDescendants = true

	local AppearancePanelPadding = Instance.new("UIPadding")
	AppearancePanelPadding.Parent = AppearancePanel
	AppearancePanelPadding.PaddingTop = UDim.new(0, 60)
	AppearancePanelPadding.PaddingLeft = UDim.new(0, 40)
	AppearancePanelPadding.PaddingRight = UDim.new(0, 40)
	AppearancePanelPadding.PaddingBottom = UDim.new(0, 20)

	local AppearanceDesc = Instance.new("TextLabel")
	Elements.AppearanceDesc = AppearanceDesc
	AppearanceDesc.Name = "AppearanceDesc"
	AppearanceDesc.Parent = AppearancePanel
	AppearanceDesc.BackgroundTransparency = 1.000
	AppearanceDesc.Position = UDim2.new(0, 0, 0, 20)
	AppearanceDesc.Size = UDim2.new(1, 0, 0, 35)
	AppearanceDesc.Font = Enum.Font.Gotham
	AppearanceDesc.Text = GetTranslation("appearance_desc")
	AppearanceDesc.TextSize = 13.000
	AppearanceDesc.TextWrapped = true
	AppearanceDesc.TextXAlignment = Enum.TextXAlignment.Left
	AppearanceDesc.TextYAlignment = Enum.TextYAlignment.Top

	local ThemeButtonsFrame = Instance.new("Frame")
	Elements.ThemeButtonsFrame = ThemeButtonsFrame
	ThemeButtonsFrame.Name = "ThemeButtonsFrame"
	ThemeButtonsFrame.Parent = AppearancePanel
	ThemeButtonsFrame.BackgroundTransparency = 1
	ThemeButtonsFrame.Position = UDim2.new(0, 0, 0, 40)
	ThemeButtonsFrame.Size = UDim2.new(1, 0, 0, 60)

	local ThemeButtonsLayout = Instance.new("UIListLayout")
	ThemeButtonsLayout.Parent = ThemeButtonsFrame
	ThemeButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
	ThemeButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	ThemeButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Top
	ThemeButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ThemeButtonsLayout.Padding = UDim.new(0, 25)

	local themeOrder = {"White", "Dark", "Darker", "Black"}
	for i, themeKey in ipairs(themeOrder) do
		local themeButtonContainer = Instance.new("Frame")
		themeButtonContainer.Name = themeKey.."PreviewContainer"
		themeButtonContainer.Parent = ThemeButtonsFrame
		themeButtonContainer.LayoutOrder = i
		themeButtonContainer.Size = UDim2.new(0, 40, 0, 60)
		themeButtonContainer.BackgroundTransparency = 1

		local containerLayout = Instance.new("UIListLayout")
		containerLayout.Parent = themeButtonContainer
		containerLayout.FillDirection = Enum.FillDirection.Vertical
		containerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
		containerLayout.Padding = UDim.new(0, 5)

		local themePreview = Instance.new("Frame")
		themePreview.Name = "ThemePreview"
		themePreview.Parent = themeButtonContainer
		themePreview.Size = UDim2.new(0, 35, 0, 35)
		themePreview.BackgroundColor3 = Themes[themeKey].ContentBackground

		local themePreviewCorner = Instance.new("UICorner")
		themePreviewCorner.CornerRadius = UDim.new(1, 0)
		themePreviewCorner.Parent = themePreview

		local activeStroke = Instance.new("UIStroke")
		activeStroke.Name = "ActiveStroke"
		activeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		activeStroke.Color = CurrentTheme.AccentText
		activeStroke.Thickness = 2
		activeStroke.Transparency = 0
		activeStroke.Enabled = (themeKey == currentThemeName)
		activeStroke.Parent = themePreview

		local themeNameLabel = Instance.new("TextLabel")
		themeNameLabel.Name = "ThemeNameLabel"
		themeNameLabel.Parent = themeButtonContainer
		themeNameLabel.BackgroundTransparency = 1
		themeNameLabel.Size = UDim2.new(1, 0, 0, 15)
		themeNameLabel.Font = Enum.Font.Gotham
		themeNameLabel.Text = themeKey
		themeNameLabel.TextSize = 11
		themeNameLabel.TextColor3 = CurrentTheme.PrimaryText

		local clickDetector = Instance.new("TextButton")
		clickDetector.Name = "ClickDetector"
		clickDetector.Parent = themePreview
		clickDetector.Size = UDim2.new(1,0,1,0)
		clickDetector.BackgroundTransparency = 1
		clickDetector.Text = ""
		clickDetector.ZIndex = 2

		clickDetector.MouseButton1Click:Connect(function()
			if currentThemeName == themeKey then return end
			ApplyTheme(themeKey)
		end)

		clickDetector.MouseEnter:Connect(function()
			if activeStroke and not activeStroke.Enabled then
				activeStroke.Enabled = true
				activeStroke.Transparency = 0.7
			end
		end)
		clickDetector.MouseLeave:Connect(function()
			if activeStroke and activeStroke.Transparency > 0 then
				if themeKey ~= currentThemeName then
					activeStroke.Enabled = false
				end
				activeStroke.Transparency = 0
			end
		end)
	end

	local LanguagePanel = Instance.new("Frame")
	Elements.LanguagePanel = LanguagePanel
	LanguagePanel.Name = "LanguagePanel"
	LanguagePanel.Parent = SettingsHolder
	LanguagePanel.BorderSizePixel = 0
	LanguagePanel.Position = UDim2.new(0, 218, 0, 0)
	LanguagePanel.Size = UDim2.new(1, -218, 1, 0)
	LanguagePanel.Visible = false
	LanguagePanel.ClipsDescendants = true

	local LanguagePanelPadding = Instance.new("UIPadding")
	LanguagePanelPadding.Parent = LanguagePanel
	LanguagePanelPadding.PaddingTop = UDim.new(0, 60)
	LanguagePanelPadding.PaddingLeft = UDim.new(0, 40)
	LanguagePanelPadding.PaddingRight = UDim.new(0, 40)
	LanguagePanelPadding.PaddingBottom = UDim.new(0, 20)

	local LanguageDesc = Instance.new("TextLabel")
	Elements.LanguageDesc = LanguageDesc
	LanguageDesc.Name = "LanguageDesc"
	LanguageDesc.Parent = LanguagePanel
	LanguageDesc.BackgroundTransparency = 1.000
	LanguageDesc.Position = UDim2.new(0, 0, 0, 20)
	LanguageDesc.Size = UDim2.new(1, 0, 0, 35)
	LanguageDesc.Font = Enum.Font.Gotham
	LanguageDesc.Text = GetTranslation("language_desc")
	LanguageDesc.TextSize = 13.000
	LanguageDesc.TextWrapped = true
	LanguageDesc.TextXAlignment = Enum.TextXAlignment.Left
	LanguageDesc.TextYAlignment = Enum.TextYAlignment.Top

	local LanguageButtonsFrame = Instance.new("Frame")
	Elements.LanguageButtonsFrame = LanguageButtonsFrame
	LanguageButtonsFrame.Name = "LanguageButtonsFrame"
	LanguageButtonsFrame.Parent = LanguagePanel
	LanguageButtonsFrame.BackgroundTransparency = 1
	LanguageButtonsFrame.Position = UDim2.new(0, 0, 0, 40)
	LanguageButtonsFrame.Size = UDim2.new(1, 0, 0.5, 0)

	local LanguageButtonsLayout = Instance.new("UIListLayout")
	LanguageButtonsLayout.Parent = LanguageButtonsFrame
	LanguageButtonsLayout.FillDirection = Enum.FillDirection.Vertical
	LanguageButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	LanguageButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
	LanguageButtonsLayout.Padding = UDim.new(0, 10)

	local langOrder = {"en", "es", "ru"}
	for _, langCode in ipairs(langOrder) do
		local langData = Languages[langCode]
		if langData then
			local langName = langData["settings_language"] or langCode

			local langButton = Instance.new("TextButton")
			langButton.Name = langCode .. "Btn"
			langButton.Parent = LanguageButtonsFrame
			langButton.Size = UDim2.new(0, 150, 0, 32)
			langButton.Text = langName
			langButton.Font = Enum.Font.GothamMedium
			langButton.TextSize = 14
			langButton.AutoButtonColor = false

			local langBtnCorner = Instance.new("UICorner")
			langBtnCorner.CornerRadius = UDim.new(0, 3)
			langBtnCorner.Parent = langButton

			langButton.MouseButton1Click:Connect(function()
				if currentLanguage == langCode then return end
				currentLanguage = langCode
				ApplyLanguage(false)
				ApplyTheme(currentThemeName, false)
			end)
		end
	end

	dragCleanup = MakeDraggable(TopFrame, MainFrame)

	CloseBtn.MouseButton1Click:Connect(function()
		MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true, function()
			pcall(function() if dragCleanup then dragCleanup() end end)
			Discord:Destroy()
		end)
	end)

	CloseBtn.MouseEnter:Connect(function()
		TweenService:Create(CloseBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(240, 71, 71)}):Play()
		if Elements.CloseIcon then TweenService:Create(Elements.CloseIcon, TweenInfo.new(0.1), {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play() end
	end)

	CloseBtn.MouseLeave:Connect(function()
		TweenService:Create(CloseBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.TopBarBackground}):Play()
		if Elements.CloseIcon then TweenService:Create(Elements.CloseIcon, TweenInfo.new(0.1), {ImageColor3 = CurrentTheme.IconColor}):Play() end
	end)

	MinimizeBtn.MouseEnter:Connect(function()
		TweenService:Create(MinimizeBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ButtonSecondaryHover}):Play()
		if Elements.MinimizeIcon then TweenService:Create(Elements.MinimizeIcon, TweenInfo.new(0.1), {ImageColor3 = CurrentTheme.IconHoverColor}):Play() end
	end)

	MinimizeBtn.MouseLeave:Connect(function()
		TweenService:Create(MinimizeBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.TopBarBackground}):Play()
		if Elements.MinimizeIcon then TweenService:Create(Elements.MinimizeIcon, TweenInfo.new(0.1), {ImageColor3 = CurrentTheme.IconColor}):Play() end
	end)

	MinimizeBtn.MouseButton1Click:Connect(function()
		minimized = not minimized
		local targetSize = minimized and UDim2.new(0, 681, 0, 22) or UDim2.new(0, 681, 0, 396)
		MainFrame:TweenSize(targetSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
	end)

	if Elements.ServersHold then
		Elements.ServersHold.MouseEnter:Connect(function() TweenService:Create(Elements.ServersHold, TweenInfo.new(0.2), {ScrollBarImageTransparency = 0}):Play() end)
		Elements.ServersHold.MouseLeave:Connect(function() TweenService:Create(Elements.ServersHold, TweenInfo.new(0.2), {ScrollBarImageTransparency = 1}):Play() end)
	end

	if Elements.UserIconButton then
		Elements.UserIconButton.MouseButton1Click:Connect(function()
			statusPopupOpen = not statusPopupOpen
			local existingPopup = Elements.Userpad and Elements.Userpad:FindFirstChild("StatusPopup")

			if statusPopupOpen then
				if existingPopup then existingPopup:Destroy() end

				local StatusPopup = Instance.new("Frame")
				StatusPopup.Name = "StatusPopup"
				StatusPopup.Parent = Elements.Userpad
				StatusPopup.BackgroundColor3 = CurrentTheme.TooltipBackground
				StatusPopup.BorderSizePixel = 1
				StatusPopup.BorderColor3 = CurrentTheme.InputOutline
				StatusPopup.Size = UDim2.new(0, 140, 0, 0)
				StatusPopup.Position = UDim2.new(0, 8, 0, -10)
				StatusPopup.AnchorPoint = Vector2.new(0, 1)
				StatusPopup.ClipsDescendants = true
				StatusPopup.ZIndex = 100

				local PopupCorner = Instance.new("UICorner")
				PopupCorner.CornerRadius = UDim.new(0, 5)
				PopupCorner.Parent = StatusPopup

				local PopupLayout = Instance.new("UIListLayout")
				PopupLayout.Padding = UDim.new(0, 0)
				PopupLayout.SortOrder = Enum.SortOrder.LayoutOrder
				PopupLayout.Parent = StatusPopup

				local PopupPadding = Instance.new("UIPadding")
				PopupPadding.PaddingTop = UDim.new(0, 5)
				PopupPadding.PaddingBottom = UDim.new(0, 5)
				PopupPadding.PaddingLeft = UDim.new(0, 5)
				PopupPadding.PaddingRight = UDim.new(0, 5)
				PopupPadding.Parent = StatusPopup

				local totalHeight = 0
				for i, statusKey in ipairs(Statuses) do
					local translatedStatusName = GetTranslation(statusKey)

					local statusOption = Instance.new("TextButton")
					statusOption.Name = statusKey
					statusOption.Parent = StatusPopup
					statusOption.BackgroundTransparency = 1
					statusOption.Size = UDim2.new(1, -10, 0, 25)
					statusOption.AutoButtonColor = false
					statusOption.Text = ""
					statusOption.LayoutOrder = i

					local optionCorner = Instance.new("UICorner")
					optionCorner.CornerRadius = UDim.new(0, 3)
					optionCorner.Parent = statusOption

					local optionLayout = Instance.new("UIListLayout")
					optionLayout.FillDirection = Enum.FillDirection.Horizontal
					optionLayout.VerticalAlignment = Enum.VerticalAlignment.Center
					optionLayout.Padding = UDim.new(0, 8)
					optionLayout.Parent = statusOption

					local statusCircle = Instance.new("Frame")
					statusCircle.Size = UDim2.new(0, 10, 0, 10)
					local themeStatusKey = "Status" .. translatedStatusName:gsub(" ", "")
					statusCircle.BackgroundColor3 = CurrentTheme[themeStatusKey] or CurrentTheme.StatusInvisible
					statusCircle.BorderSizePixel = 0
					statusCircle.Parent = statusOption

					local circleCorner = Instance.new("UICorner")
					circleCorner.CornerRadius = UDim.new(1, 0)
					circleCorner.Parent = statusCircle

					local statusLabel = Instance.new("TextLabel")
					statusLabel.BackgroundTransparency = 1
					statusLabel.Size = UDim2.new(0.8, 0, 1, 0)
					statusLabel.Font = Enum.Font.Gotham
					statusLabel.Text = translatedStatusName
					statusLabel.TextColor3 = CurrentTheme.TooltipText
					statusLabel.TextSize = 13
					statusLabel.TextXAlignment = Enum.TextXAlignment.Left
					statusLabel.Parent = statusOption
					totalHeight = totalHeight + 25 + PopupLayout.Padding.Offset

					statusOption.MouseEnter:Connect(function() statusOption.BackgroundColor3 = Color3.new(1,1,1); statusOption.BackgroundTransparency = 0.8; statusLabel.TextColor3 = CurrentTheme.PrimaryText end)
					statusOption.MouseLeave:Connect(function() statusOption.BackgroundTransparency = 1; statusLabel.TextColor3 = CurrentTheme.TooltipText end)
					statusOption.MouseButton1Click:Connect(function()
						ApplyStatus(statusKey)
						statusPopupOpen = false
						if StatusPopup and StatusPopup.Parent then
							StatusPopup:TweenSize(UDim2.new(0, 140, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true, function() if StatusPopup and StatusPopup.Parent then StatusPopup:Destroy() end end)
						end
					end)
				end

				totalHeight = totalHeight + PopupPadding.PaddingTop.Offset + PopupPadding.PaddingBottom.Offset - PopupLayout.Padding.Offset
				local finalSize = UDim2.new(0, 140, 0, totalHeight)
				task.wait(.1)
				if StatusPopup and StatusPopup.Parent then
					StatusPopup:TweenSize(
						finalSize,
						Enum.EasingDirection.Out,
						Enum.EasingStyle.Quad,
						0.2,
						true
					)
				end

			elseif existingPopup then
				statusPopupOpen = false
				if existingPopup and existingPopup.Parent then
					existingPopup:TweenSize(UDim2.new(0, 140, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true, function() if existingPopup and existingPopup.Parent then existingPopup:Destroy() end end)
				end
			end
		end)
	end

	MainFrame.InputBegan:Connect(function(input)
		if statusPopupOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
			local popup = Elements.Userpad and Elements.Userpad:FindFirstChild("StatusPopup")
			local iconButton = Elements.UserIconButton
			if popup and iconButton then
				local mousePos = UserInputService:GetMouseLocation()
				local popupRect = Rect.new(popup.AbsolutePosition, popup.AbsolutePosition + popup.AbsoluteSize)
				local iconRect = Rect.new(iconButton.AbsolutePosition, iconButton.AbsolutePosition + iconButton.AbsoluteSize)
				if not (mousePos.X >= popupRect.Min.X and mousePos.X <= popupRect.Max.X and mousePos.Y >= popupRect.Min.Y and mousePos.Y <= popupRect.Max.Y) and
					not (mousePos.X >= iconRect.Min.X and mousePos.X <= iconRect.Max.X and mousePos.Y >= iconRect.Min.Y and mousePos.Y <= iconRect.Max.Y) then
					statusPopupOpen = false
					if popup and popup.Parent then
						popup:TweenSize(UDim2.new(0, 140, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true, function() if popup and popup.Parent then popup:Destroy() end end)
					end
				end
			end
		end
	end)

	local settingsOpenBtnRef = Elements.Userpad and Elements.Userpad:FindFirstChild("SettingsOpenBtn")
	if settingsOpenBtnRef then
		settingsOpenBtnRef.MouseEnter:Connect(function()
			local ico = settingsOpenBtnRef:FindFirstChild("SettingsOpenBtnIco")
			if ico then TweenService:Create(ico, TweenInfo.new(0.1), {ImageColor3 = CurrentTheme.IconHoverColor}):Play() end
		end)
		settingsOpenBtnRef.MouseLeave:Connect(function()
			local ico = settingsOpenBtnRef:FindFirstChild("SettingsOpenBtnIco")
			if ico then TweenService:Create(ico, TweenInfo.new(0.1), {ImageColor3 = CurrentTheme.IconColor}):Play() end
		end)
		settingsOpenBtnRef.MouseButton1Click:Connect(function ()
			if settingsopened then return end
			settingsopened = true
			local settingsFrame = Elements.SettingsFrame
			local userPanel = Elements.UserPanel
			local appearancePanel = Elements.AppearancePanel
			local languagePanel = Elements.LanguagePanel
			local currentSettingOpenText = Elements.CurrentSettingOpen

			if not (settingsFrame and userPanel and appearancePanel and languagePanel and currentSettingOpenText) then
				warn("DiscordLib: Settings UI elements are missing!")
				settingsopened = false
				return
			end

			settingsFrame.Visible = true
			settingsFrame.BackgroundTransparency = 1
			TweenService:Create(settingsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0.7}):Play()

			userPanel.Visible = true
			appearancePanel.Visible = false
			languagePanel.Visible = false
			currentSettingOpenText.Parent = userPanel
			ApplyTheme(currentThemeName, false)
			ApplyLanguage(false)
		end)
	end

	local function CloseSettings()
		if not settingsopened then return end
		settingsopened = false
		local settingsFrame = Elements.SettingsFrame
		if settingsFrame then
			TweenService:Create(settingsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
			task.wait(0.3)
			if settingsFrame then settingsFrame.Visible = false end
		end
	end

	if Elements.CloseSettingsBtn then Elements.CloseSettingsBtn.MouseButton1Click:Connect(CloseSettings) end

	local function SwitchSettingsPanel(targetPanel)
		if not settingsopened then return end
		local userPanel = Elements.UserPanel
		local appearancePanel = Elements.AppearancePanel
		local languagePanel = Elements.LanguagePanel
		local currentSettingOpenText = Elements.CurrentSettingOpen

		if not (userPanel and appearancePanel and languagePanel and currentSettingOpenText) then return end

		userPanel.Visible = false
		appearancePanel.Visible = false
		languagePanel.Visible = false

		if targetPanel == userPanel then
			userPanel.Visible = true
			currentSettingOpenText.Parent = userPanel
			currentSettingOpenText.Text = GetTranslation("header_myAccount")
		elseif targetPanel == appearancePanel then
			appearancePanel.Visible = true
			currentSettingOpenText.Parent = appearancePanel
			currentSettingOpenText.Text = GetTranslation("header_appearance")
		elseif targetPanel == languagePanel then
			DiscordLib:Notification("Hey!", "This section is still in development, and can be very unstable! If you encounter any issue with this tab, or effects of it, please, report it to developer. Thanks!", "Ok.")
			languagePanel.Visible = true
			currentSettingOpenText.Parent = languagePanel
			currentSettingOpenText.Text = GetTranslation("header_language")
		end

		ApplyTheme(currentThemeName, false)
	end

	if Elements.MyAccountBtn then
		Elements.MyAccountBtn.MouseButton1Click:Connect(function() SwitchSettingsPanel(Elements.UserPanel) end)
	end
	if Elements.AppearanceBtn then
		Elements.AppearanceBtn.MouseButton1Click:Connect(function() SwitchSettingsPanel(Elements.AppearancePanel) end)
	end
	if Elements.LanguageBtn then
		Elements.LanguageBtn.MouseButton1Click:Connect(function() SwitchSettingsPanel(Elements.LanguagePanel) end)
	end

	local function SetupSettingsButtonHover(button, title, panel)
		if not (button and title and panel) then return end
		button.MouseEnter:Connect(function()
			if not panel.Visible then
				TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ChannelButtonHover}):Play()
				TweenService:Create(title, TweenInfo.new(0.1), {TextColor3 = CurrentTheme.InteractiveHover}):Play()
			end
		end)
		button.MouseLeave:Connect(function()
			if not panel.Visible then
				TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ChannelButton}):Play()
				TweenService:Create(title, TweenInfo.new(0.1), {TextColor3 = CurrentTheme.InteractiveNormal}):Play()
			end
		end)
	end

	SetupSettingsButtonHover(Elements.MyAccountBtn, Elements.MyAccountBtnTitle, Elements.UserPanel)
	SetupSettingsButtonHover(Elements.AppearanceBtn, Elements.AppearanceBtnTitle, Elements.AppearancePanel)
	SetupSettingsButtonHover(Elements.LanguageBtn, Elements.LanguageBtnTitle, Elements.LanguagePanel)

	UserInputService.InputBegan:Connect(function(io, p)
		if p then return end
		if io.KeyCode == Enum.KeyCode.Escape then
			local statusPopup = Elements.Userpad and Elements.Userpad:FindFirstChild("StatusPopup")
			local avatarHolder = MainFrame:FindFirstChild("AvatarChangeHolder")
			local userHolder = MainFrame:FindFirstChild("UserChangeHolder")
			local notifHolder = MainFrame:FindFirstChild("NotificationHolderMain")

			if statusPopupOpen and statusPopup then
				statusPopupOpen = false
				if statusPopup and statusPopup.Parent then
					statusPopup:TweenSize(UDim2.new(0, 140, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true, function() if statusPopup and statusPopup.Parent then statusPopup:Destroy() end end)
				end
			elseif avatarHolder then
				local popup = avatarHolder:FindFirstChild("AvatarChangePopup")
				if popup then popup:TweenSize(UDim2.new(0, 346, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true) end
				TweenService:Create(avatarHolder, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
				task.wait(0.2)
				if avatarHolder then avatarHolder:Destroy() end
			elseif userHolder then
				local popup = userHolder:FindFirstChild("UserChangePopup")
				if popup then popup:TweenSize(UDim2.new(0, 346, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true) end
				TweenService:Create(userHolder, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
				task.wait(0.2)
				if userHolder then userHolder:Destroy() end
			elseif notifHolder then
				local popup = notifHolder:FindFirstChild("Notification")
				if popup then popup:TweenSize(UDim2.new(0, 346, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true) end
				TweenService:Create(notifHolder, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
				task.wait(0.2)
				if notifHolder then notifHolder:Destroy() end
			elseif settingsopened then
				CloseSettings()
			end
		end
	end)

	if Elements.EditBtn then
		Elements.EditBtn.MouseEnter:Connect(function() TweenService:Create(Elements.EditBtn, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.ButtonSecondaryHover}):Play() end)
		Elements.EditBtn.MouseLeave:Connect(function() TweenService:Create(Elements.EditBtn, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.ButtonSecondaryBackground}):Play() end)
	end

	if Elements.UserPanelUserIcon and Elements.BlackFrame then
		Elements.UserPanelUserIcon.MouseEnter:Connect(function() if Elements.BlackFrame then Elements.BlackFrame.Visible = true end end)
		Elements.UserPanelUserIcon.MouseLeave:Connect(function() if Elements.BlackFrame then Elements.BlackFrame.Visible = false end end)
	end

	if Elements.UserPanelUserIcon then
		Elements.UserPanelUserIcon.MouseButton1Click:Connect(function()
			local NotificationHolder = Instance.new("Frame")
			NotificationHolder.Parent = MainFrame
			NotificationHolder.Name = "AvatarChangeHolder"
			NotificationHolder.BackgroundColor3 = CurrentTheme.PopupSecondaryBackground
			NotificationHolder.BackgroundTransparency = 1
			NotificationHolder.Position = UDim2.new(0, 0, 0, 0)
			NotificationHolder.Size = UDim2.new(1, 0, 1, 0)
			NotificationHolder.ZIndex = 20
			NotificationHolder.Visible = true
			TweenService:Create(NotificationHolder, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()

			local AvatarChange = Instance.new("Frame")
			AvatarChange.Name = "AvatarChangePopup"
			AvatarChange.Parent = NotificationHolder
			AvatarChange.AnchorPoint = Vector2.new(0.5, 0.5)
			AvatarChange.BackgroundColor3 = CurrentTheme.PopupBackground
			AvatarChange.ClipsDescendants = true
			AvatarChange.Position = UDim2.new(0.5, 0, 0.5, 0)
			AvatarChange.Size = UDim2.new(0, 0, 0, 0)
			AvatarChange.ZIndex = 21

			AvatarChange:TweenSize(UDim2.new(0, 346, 0, 198), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.3, true)

			local UserChangeCorner = Instance.new("UICorner")
			UserChangeCorner.CornerRadius = UDim.new(0, 5)
			UserChangeCorner.Parent = AvatarChange

			local UnderBarFrame = Instance.new("Frame")
			UnderBarFrame.Name = "UnderBarFrame"
			UnderBarFrame.BackgroundColor3 = CurrentTheme.PopupSecondaryBackground
			UnderBarFrame.BorderSizePixel = 0
			UnderBarFrame.AnchorPoint = Vector2.new(0, 1)
			UnderBarFrame.Position = UDim2.new(0, 0, 1, 0)
			UnderBarFrame.Size = UDim2.new(1, 0, 0, 50)
			UnderBarFrame.Parent = AvatarChange


			local Text1 = Instance.new("TextLabel")
			Text1.Name = "Text1"
			Text1.BackgroundTransparency = 1.000
			Text1.Position = UDim2.new(0, 20, 0, 15)
			Text1.Size = UDim2.new(1, -40, 0, 30)
			Text1.Font = Enum.Font.GothamMedium
			Text1.Text = GetTranslation("popup_changeAvatarTitle")
			Text1.TextColor3 = CurrentTheme.HeaderText
			Text1.TextSize = 18.000
			Text1.TextXAlignment = Enum.TextXAlignment.Left
			Text1.Parent = AvatarChange

			local Text2 = Instance.new("TextLabel")
			Text2.Name = "Text2"
			Text2.BackgroundTransparency = 1.000
			Text2.Position = UDim2.new(0, 20, 0, 45)
			Text2.Size = UDim2.new(1, -40, 0, 30)
			Text2.Font = Enum.Font.Gotham
			Text2.Text = GetTranslation("popup_changeAvatarDesc")
			Text2.TextColor3 = CurrentTheme.SecondaryText
			Text2.TextSize = 13.000
			Text2.TextXAlignment = Enum.TextXAlignment.Left
			Text2.Parent = AvatarChange

			local TextBoxFrameOutline = Instance.new("Frame")
			TextBoxFrameOutline.Name = "TextBoxFrameOutline"
			TextBoxFrameOutline.AnchorPoint = Vector2.new(0.5, 0)
			TextBoxFrameOutline.BackgroundColor3 = CurrentTheme.InputOutline
			TextBoxFrameOutline.Position = UDim2.new(0.5, 0, 0, 85)
			TextBoxFrameOutline.Size = UDim2.new(0, 306, 0, 38)
			TextBoxFrameOutline.Parent = AvatarChange

			local TextBoxFrameOutlineCorner = Instance.new("UICorner")
			TextBoxFrameOutlineCorner.CornerRadius = UDim.new(0, 3)
			TextBoxFrameOutlineCorner.Parent = TextBoxFrameOutline

			local TextBoxFrame = Instance.new("Frame")
			TextBoxFrame.Name = "TextBoxFrame"
			TextBoxFrame.AnchorPoint = Vector2.new(0.5, 0.5)
			TextBoxFrame.BackgroundColor3 = CurrentTheme.InputBackground
			TextBoxFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
			TextBoxFrame.Size = UDim2.new(1, -2, 1, -2)
			TextBoxFrame.Parent = TextBoxFrameOutline

			local TextBoxFrameCorner = Instance.new("UICorner")
			TextBoxFrameCorner.CornerRadius = UDim.new(0, 3)
			TextBoxFrameCorner.Parent = TextBoxFrame

			local AvatarTextbox = Instance.new("TextBox")
			AvatarTextbox.Name = "AvatarTextbox"
			AvatarTextbox.BackgroundTransparency = 1.000
			AvatarTextbox.Position = UDim2.new(0, 10, 0, 0)
			AvatarTextbox.Size = UDim2.new(1, -20, 1, 0)
			AvatarTextbox.Font = Enum.Font.Gotham
			AvatarTextbox.Text = ""
			AvatarTextbox.PlaceholderText = GetTranslation("popup_changeAvatarPlaceholder")
			AvatarTextbox.PlaceholderColor3 = CurrentTheme.MutedText
			AvatarTextbox.TextColor3 = CurrentTheme.PrimaryText
			AvatarTextbox.TextSize = 14.000
			AvatarTextbox.TextXAlignment = Enum.TextXAlignment.Left
			AvatarTextbox.ClearTextOnFocus = false
			AvatarTextbox.Parent = TextBoxFrame

			local ChangeBtn = Instance.new("TextButton")
			ChangeBtn.Name = "ChangeBtn"
			ChangeBtn.AnchorPoint = Vector2.new(1, 0.5)
			ChangeBtn.BackgroundColor3 = CurrentTheme.ButtonBackground
			ChangeBtn.Position = UDim2.new(1, -15, 0.5, 0)
			ChangeBtn.Size = UDim2.new(0, 80, 0, 32)
			ChangeBtn.Font = Enum.Font.GothamMedium
			ChangeBtn.Text = GetTranslation("popup_changeButton")
			ChangeBtn.TextColor3 = CurrentTheme.ButtonText
			ChangeBtn.TextSize = 14.000
			ChangeBtn.AutoButtonColor = false
			ChangeBtn.Parent = UnderBarFrame

			local ChangeCorner = Instance.new("UICorner")
			ChangeCorner.CornerRadius = UDim.new(0, 4)
			ChangeCorner.Parent = ChangeBtn

			local ResetBtn = Instance.new("TextButton")
			ResetBtn.Name = "ResetBtn"
			ResetBtn.AnchorPoint = Vector2.new(1, 0.5)
			ResetBtn.BackgroundColor3 = CurrentTheme.ButtonSecondaryBackground
			ResetBtn.BackgroundTransparency = 0
			ResetBtn.Position = UDim2.new(1, -105, 0.5, 0)
			ResetBtn.Size = UDim2.new(0, 76, 0, 32)
			ResetBtn.Font = Enum.Font.GothamMedium
			ResetBtn.Text = GetTranslation("popup_resetButton")
			ResetBtn.TextColor3 = CurrentTheme.ButtonText
			ResetBtn.TextSize = 14.000
			ResetBtn.AutoButtonColor = false
			ResetBtn.Parent = UnderBarFrame

			local ResetCorner = Instance.new("UICorner")
			ResetCorner.CornerRadius = UDim.new(0, 4)
			ResetCorner.Parent = ResetBtn

			local CloseBtn1 = Instance.new("TextButton")
			CloseBtn1.Name = "CloseBtn1"
			CloseBtn1.AnchorPoint = Vector2.new(0, 0.5)
			CloseBtn1.BackgroundTransparency = 1.000
			CloseBtn1.Position = UDim2.new(0, 15, 0.5, 0)
			CloseBtn1.Size = UDim2.new(0, 76, 0, 32)
			CloseBtn1.Font = Enum.Font.GothamMedium
			CloseBtn1.Text = GetTranslation("popup_cancelButton")
			CloseBtn1.TextColor3 = CurrentTheme.SecondaryText
			CloseBtn1.TextSize = 14.000
			CloseBtn1.AutoButtonColor = false
			CloseBtn1.Parent = UnderBarFrame

			local CloseBtn2 = Instance.new("TextButton")
			CloseBtn2.Name = "CloseBtn2"
			CloseBtn2.BackgroundTransparency = 1.000
			CloseBtn2.Position = UDim2.new(1, -30, 0, 5)
			CloseBtn2.AnchorPoint = Vector2.new(1, 0)
			CloseBtn2.Size = UDim2.new(0, 26, 0, 26)
			CloseBtn2.Font = Enum.Font.Gotham
			CloseBtn2.Text = ""
			CloseBtn2.AutoButtonColor = false
			CloseBtn2.ZIndex = 12
			CloseBtn2.Parent = AvatarChange

			local Close2Icon = Instance.new("ImageLabel")
			Close2Icon.Name = "Close2Icon"
			Close2Icon.BackgroundTransparency = 1.000
			Close2Icon.AnchorPoint = Vector2.new(0.5, 0.5)
			Close2Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
			Close2Icon.Size = UDim2.new(0, 20, 0, 20)
			Close2Icon.Image = "http://www.roblox.com/asset/?id=6035047409"
			Close2Icon.ImageColor3 = CurrentTheme.IconColor
			Close2Icon.Parent = CloseBtn2

			local function CloseAvatarPopup()
				AvatarChange:TweenSize(UDim2.new(0, 346, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
				TweenService:Create(NotificationHolder, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
				task.wait(0.2)
				if NotificationHolder then NotificationHolder:Destroy() end
			end

			CloseBtn1.MouseButton1Click:Connect(CloseAvatarPopup)
			CloseBtn2.MouseButton1Click:Connect(CloseAvatarPopup)
			NotificationHolder.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local mousePos = UserInputService:GetMouseLocation()
					local popupRect = Rect.new(AvatarChange.AbsolutePosition, AvatarChange.AbsolutePosition + AvatarChange.AbsoluteSize)
					if not (mousePos.X >= popupRect.Min.X and mousePos.X <= popupRect.Max.X and mousePos.Y >= popupRect.Min.Y and mousePos.Y <= popupRect.Max.Y) then CloseAvatarPopup() end
				end
			end)
			ChangeBtn.MouseButton1Click:Connect(function()
				local newPfp = AvatarTextbox.Text
				if newPfp:match("^rbxassetid://%d+") or newPfp:match("^https?://") then
					local oldPfp = pfp
					pfp = newPfp
					local successPfp, _ = pcall(function() if Elements.UserImage then Elements.UserImage.Image = pfp end end)
					local successPanelPfp, _ = pcall(function() if Elements.UserPanelUserImage then Elements.UserPanelUserImage.Image = pfp end end)
					if not successPfp or not successPanelPfp then
						pfp = oldPfp
						if Elements.UserImage then Elements.UserImage.Image = pfp end
						if Elements.UserPanelUserImage then Elements.UserPanelUserImage.Image = pfp end
						DiscordLib:Notification(GetTranslation("popup_changeAvatarErrorTitle"), GetTranslation("popup_changeAvatarErrorInvalid"), GetTranslation("popup_okayButton"))
						return
					end
					SaveInfo()
					CloseAvatarPopup()
				else
					DiscordLib:Notification(GetTranslation("popup_changeAvatarErrorTitle"), GetTranslation("popup_changeAvatarDesc"), GetTranslation("popup_okayButton"))
				end
			end)
			ResetBtn.MouseButton1Click:Connect(function()
				pfp = DEFAULT_PFP
				if Elements.UserImage then Elements.UserImage.Image = pfp end
				if Elements.UserPanelUserImage then Elements.UserPanelUserImage.Image = pfp end
				SaveInfo()
				CloseAvatarPopup()
			end)
			ChangeBtn.MouseEnter:Connect(function() TweenService:Create(ChangeBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ButtonHover}):Play() end)
			ChangeBtn.MouseLeave:Connect(function() TweenService:Create(ChangeBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ButtonBackground}):Play() end)
			ResetBtn.MouseEnter:Connect(function() TweenService:Create(ResetBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ButtonSecondaryHover}):Play() end)
			ResetBtn.MouseLeave:Connect(function() TweenService:Create(ResetBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ButtonSecondaryBackground}):Play() end)
			CloseBtn1.MouseEnter:Connect(function() TweenService:Create(CloseBtn1, TweenInfo.new(0.1), {TextColor3 = CurrentTheme.PrimaryText}):Play() end)
			CloseBtn1.MouseLeave:Connect(function() TweenService:Create(CloseBtn1, TweenInfo.new(0.1), {TextColor3 = CurrentTheme.SecondaryText}):Play() end)
			CloseBtn2.MouseEnter:Connect(function() TweenService:Create(Close2Icon, TweenInfo.new(0.1), {ImageColor3 = CurrentTheme.IconHoverColor}):Play() end)
			CloseBtn2.MouseLeave:Connect(function() TweenService:Create(Close2Icon, TweenInfo.new(0.1), {ImageColor3 = CurrentTheme.IconColor}):Play() end)
			AvatarTextbox.Focused:Connect(function() TweenService:Create(TextBoxFrameOutline, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.InputOutlineFocus}):Play() end)
			AvatarTextbox.FocusLost:Connect(function() TweenService:Create(TextBoxFrameOutline, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.InputOutline}):Play() end)
		end)
	end

	if Elements.EditBtn then
		Elements.EditBtn.MouseButton1Click:Connect(function()
			local NotificationHolder = Instance.new("Frame")
			NotificationHolder.Name = "UserChangeHolder"
			NotificationHolder.Parent = MainFrame
			NotificationHolder.BackgroundColor3 = CurrentTheme.PopupSecondaryBackground
			NotificationHolder.BackgroundTransparency = 1
			NotificationHolder.Position = UDim2.new(0, 0, 0, 0)
			NotificationHolder.Size = UDim2.new(1, 0, 1, 0)
			NotificationHolder.ZIndex = 20
			NotificationHolder.Visible = true
			TweenService:Create(NotificationHolder, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()

			local UserChange = Instance.new("Frame")
			UserChange.Name = "UserChangePopup"
			UserChange.Parent = NotificationHolder
			UserChange.AnchorPoint = Vector2.new(0.5, 0.5)
			UserChange.BackgroundColor3 = CurrentTheme.PopupBackground
			UserChange.ClipsDescendants = true
			UserChange.Position = UDim2.new(0.5, 0, 0.5, 0)
			UserChange.Size = UDim2.new(0, 0, 0, 0)
			UserChange.ZIndex = 21

			UserChange:TweenSize(UDim2.new(0, 346, 0, 198), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)

			local UserChangeCorner = Instance.new("UICorner")
			UserChangeCorner.CornerRadius = UDim.new(0, 5)
			UserChangeCorner.Parent = UserChange

			local UnderBarFrame = Instance.new("Frame")
			UnderBarFrame.Name = "UnderBarFrame"
			UnderBarFrame.BackgroundColor3 = CurrentTheme.PopupSecondaryBackground
			UnderBarFrame.BorderSizePixel = 0
			UnderBarFrame.AnchorPoint = Vector2.new(0, 1)
			UnderBarFrame.Position = UDim2.new(0, 0, 1, 0)
			UnderBarFrame.Size = UDim2.new(1, 0, 0, 50)
			UnderBarFrame.Parent = UserChange


			local Text1 = Instance.new("TextLabel")
			Text1.Name = "Text1"
			Text1.BackgroundTransparency = 1.000
			Text1.Position = UDim2.new(0, 20, 0, 15)
			Text1.Size = UDim2.new(1, -40, 0, 30)
			Text1.Font = Enum.Font.GothamMedium
			Text1.Text = GetTranslation("popup_changeUsernameTitle")
			Text1.TextColor3 = CurrentTheme.HeaderText
			Text1.TextSize = 18.000
			Text1.TextXAlignment = Enum.TextXAlignment.Left
			Text1.Parent = UserChange

			local Text2 = Instance.new("TextLabel")
			Text2.Name = "Text2"
			Text2.BackgroundTransparency = 1.000
			Text2.Position = UDim2.new(0, 20, 0, 45)
			Text2.Size = UDim2.new(1, -40, 0, 30)
			Text2.Font = Enum.Font.Gotham
			Text2.Text = GetTranslation("popup_changeUsernameDesc")
			Text2.TextColor3 = CurrentTheme.SecondaryText
			Text2.TextSize = 13.000
			Text2.TextXAlignment = Enum.TextXAlignment.Left
			Text2.Parent = UserChange

			local TextBoxFrameOutline = Instance.new("Frame")
			TextBoxFrameOutline.Name = "TextBoxFrameOutline"
			TextBoxFrameOutline.AnchorPoint = Vector2.new(0.5, 0)
			TextBoxFrameOutline.BackgroundColor3 = CurrentTheme.InputOutline
			TextBoxFrameOutline.Position = UDim2.new(0.5, 0, 0, 85)
			TextBoxFrameOutline.Size = UDim2.new(0, 306, 0, 38)
			TextBoxFrameOutline.Parent = UserChange

			local TextBoxFrameOutlineCorner = Instance.new("UICorner")
			TextBoxFrameOutlineCorner.CornerRadius = UDim.new(0, 3)
			TextBoxFrameOutlineCorner.Parent = TextBoxFrameOutline

			local TextBoxFrame = Instance.new("Frame")
			TextBoxFrame.Name = "TextBoxFrame"
			TextBoxFrame.AnchorPoint = Vector2.new(0.5, 0.5)
			TextBoxFrame.BackgroundColor3 = CurrentTheme.InputBackground
			TextBoxFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
			TextBoxFrame.Size = UDim2.new(1, -2, 1, -2)
			TextBoxFrame.Parent = TextBoxFrameOutline

			local TextBoxFrameCorner = Instance.new("UICorner")
			TextBoxFrameCorner.CornerRadius = UDim.new(0, 3)
			TextBoxFrameCorner.Parent = TextBoxFrame

			local UsernameTextbox = Instance.new("TextBox")
			UsernameTextbox.Name = "UsernameTextbox"
			UsernameTextbox.BackgroundTransparency = 1.000
			UsernameTextbox.Position = UDim2.new(0, 10, 0, 0)
			UsernameTextbox.Size = UDim2.new(1, -20, 1, 0)
			UsernameTextbox.Font = Enum.Font.Gotham
			UsernameTextbox.Text = user
			UsernameTextbox.PlaceholderText = GetTranslation("popup_changeUsernamePlaceholder")
			UsernameTextbox.PlaceholderColor3 = CurrentTheme.MutedText
			UsernameTextbox.TextColor3 = CurrentTheme.PrimaryText
			UsernameTextbox.TextSize = 14.000
			UsernameTextbox.TextXAlignment = Enum.TextXAlignment.Left
			UsernameTextbox.ClearTextOnFocus = false
			UsernameTextbox.Parent = TextBoxFrame

			local ChangeBtn = Instance.new("TextButton")
			ChangeBtn.Name = "ChangeBtn"
			ChangeBtn.AnchorPoint = Vector2.new(1, 0.5)
			ChangeBtn.BackgroundColor3 = CurrentTheme.ButtonBackground
			ChangeBtn.Position = UDim2.new(1, -15, 0.5, 0)
			ChangeBtn.Size = UDim2.new(0, 80, 0, 32)
			ChangeBtn.Font = Enum.Font.GothamMedium
			ChangeBtn.Text = GetTranslation("popup_changeButton")
			ChangeBtn.TextColor3 = CurrentTheme.ButtonText
			ChangeBtn.TextSize = 14.000
			ChangeBtn.AutoButtonColor = false
			ChangeBtn.Parent = UnderBarFrame

			local ChangeCorner = Instance.new("UICorner")
			ChangeCorner.CornerRadius = UDim.new(0, 4)
			ChangeCorner.Parent = ChangeBtn

			local CloseBtn1 = Instance.new("TextButton")
			CloseBtn1.Name = "CloseBtn1"
			CloseBtn1.AnchorPoint = Vector2.new(0, 0.5)
			CloseBtn1.BackgroundTransparency = 1.000
			CloseBtn1.Position = UDim2.new(0, 15, 0.5, 0)
			CloseBtn1.Size = UDim2.new(0, 76, 0, 32)
			CloseBtn1.Font = Enum.Font.GothamMedium
			CloseBtn1.Text = GetTranslation("popup_cancelButton")
			CloseBtn1.TextColor3 = CurrentTheme.SecondaryText
			CloseBtn1.TextSize = 14.000
			CloseBtn1.AutoButtonColor = false
			CloseBtn1.Parent = UnderBarFrame

			local CloseBtn2 = Instance.new("TextButton")
			CloseBtn2.Name = "CloseBtn2"
			CloseBtn2.BackgroundTransparency = 1.000
			CloseBtn2.Position = UDim2.new(1, -30, 0, 5)
			CloseBtn2.AnchorPoint = Vector2.new(1, 0)
			CloseBtn2.Size = UDim2.new(0, 26, 0, 26)
			CloseBtn2.Font = Enum.Font.Gotham
			CloseBtn2.Text = ""
			CloseBtn2.AutoButtonColor = false
			CloseBtn2.ZIndex = 12
			CloseBtn2.Parent = UserChange

			local Close2Icon = Instance.new("ImageLabel")
			Close2Icon.Name = "Close2Icon"
			Close2Icon.BackgroundTransparency = 1.000
			Close2Icon.AnchorPoint = Vector2.new(0.5, 0.5)
			Close2Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
			Close2Icon.Size = UDim2.new(0, 20, 0, 20)
			Close2Icon.Image = "http://www.roblox.com/asset/?id=6035047409"
			Close2Icon.ImageColor3 = CurrentTheme.IconColor
			Close2Icon.Parent = CloseBtn2

			local function CloseUserPopup()
				UserChange:TweenSize(UDim2.new(0, 346, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true)
				TweenService:Create(NotificationHolder, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
				task.wait(0.2)
				if NotificationHolder then NotificationHolder:Destroy() end
			end

			CloseBtn1.MouseButton1Click:Connect(CloseUserPopup)
			CloseBtn2.MouseButton1Click:Connect(CloseUserPopup)
			NotificationHolder.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					local mousePos = UserInputService:GetMouseLocation()
					local popupRect = Rect.new(UserChange.AbsolutePosition, UserChange.AbsolutePosition + UserChange.AbsoluteSize)
					if not (mousePos.X >= popupRect.Min.X and mousePos.X <= popupRect.Max.X and mousePos.Y >= popupRect.Min.Y and mousePos.Y <= popupRect.Max.Y) then CloseUserPopup() end
				end
			end)
			ChangeBtn.MouseButton1Click:Connect(function()
				local newUsername = UsernameTextbox.Text:gsub("^%s*(.-)%s*$", "%1")
				local errorTitle = GetTranslation("popup_changeUsernameErrorTitle")
				local okayBtn = GetTranslation("popup_okayButton")
				if #newUsername > 0 and #newUsername <= 32 then
					user = newUsername
					if Elements.UserName then Elements.UserName.Text = user end
					if Elements.UserSettingsPadUser then Elements.UserSettingsPadUser.Text = user end
					if Elements.UserPanelUser then Elements.UserPanelUser.Text = user end
					SaveInfo()
					CloseUserPopup()
				elseif #newUsername == 0 then DiscordLib:Notification(errorTitle, GetTranslation("popup_changeUsernameErrorEmpty"), okayBtn)
				else DiscordLib:Notification(errorTitle, GetTranslation("popup_changeUsernameErrorLong"), okayBtn) end
			end)
			ChangeBtn.MouseEnter:Connect(function() TweenService:Create(ChangeBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ButtonHover}):Play() end)
			ChangeBtn.MouseLeave:Connect(function() TweenService:Create(ChangeBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ButtonBackground}):Play() end)
			CloseBtn1.MouseEnter:Connect(function() TweenService:Create(CloseBtn1, TweenInfo.new(0.1), {TextColor3 = CurrentTheme.PrimaryText}):Play() end)
			CloseBtn1.MouseLeave:Connect(function() TweenService:Create(CloseBtn1, TweenInfo.new(0.1), {TextColor3 = CurrentTheme.SecondaryText}):Play() end)
			CloseBtn2.MouseEnter:Connect(function() TweenService:Create(Close2Icon, TweenInfo.new(0.1), {ImageColor3 = CurrentTheme.IconHoverColor}):Play() end)
			CloseBtn2.MouseLeave:Connect(function() TweenService:Create(Close2Icon, TweenInfo.new(0.1), {ImageColor3 = CurrentTheme.IconColor}):Play() end)
			UsernameTextbox.Focused:Connect(function() TweenService:Create(TextBoxFrameOutline, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.InputOutlineFocus}):Play() end)
			UsernameTextbox.FocusLost:Connect(function() TweenService:Create(TextBoxFrameOutline, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.InputOutline}):Play() end)
			UsernameTextbox:GetPropertyChangedSignal("Text"):Connect(function() if #UsernameTextbox.Text > 32 then UsernameTextbox.Text = UsernameTextbox.Text:sub(1, 32) end end)
		end)
	end

	ApplyTheme(currentThemeName, true)
	ApplyStatus(currentUserStatus, true)
	ApplyLanguage(true)

	function DiscordLib:Notification(titletext, desctext, btntext)
		if minimized then
			CreateCornerNotification(titletext, desctext)
		else
			local NotificationHolderMain = Instance.new("TextButton")
			NotificationHolderMain.AutoButtonColor = false
			NotificationHolderMain.Text = ""
			NotificationHolderMain.Name = "NotificationHolderMain"
			NotificationHolderMain.Parent = MainFrame
			NotificationHolderMain.BackgroundColor3 = CurrentTheme.PopupSecondaryBackground
			NotificationHolderMain.BackgroundTransparency = 1
			NotificationHolderMain.BorderSizePixel = 0
			NotificationHolderMain.Position = UDim2.new(0, 0, 0, 0)
			NotificationHolderMain.Size = UDim2.new(1, 0, 1, 0)
			NotificationHolderMain.ZIndex = 30

			TweenService:Create(NotificationHolderMain, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()

			local Notification = Instance.new("Frame")
			Notification.Name = "Notification"
			Notification.Parent = NotificationHolderMain
			Notification.AnchorPoint = Vector2.new(0.5, 0.5)
			Notification.BackgroundColor3 = CurrentTheme.PopupBackground
			Notification.ClipsDescendants = true
			Notification.Position = UDim2.new(0.5, 0, 0.5, 0)
			Notification.Size = UDim2.new(0, 0, 0, 0)
			Notification.ZIndex = 31

			Notification:TweenSize(UDim2.new(0, 346, 0, 176), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)

			local NotificationCorner = Instance.new("UICorner", Notification)
			NotificationCorner.CornerRadius = UDim.new(0, 5)

			local UnderBarFrame = Instance.new("Frame", Notification)
			UnderBarFrame.Name = "UnderBarFrame"
			UnderBarFrame.BackgroundColor3 = CurrentTheme.PopupSecondaryBackground
			UnderBarFrame.BorderSizePixel = 0
			UnderBarFrame.AnchorPoint = Vector2.new(0, 1)
			UnderBarFrame.Position = UDim2.new(0, 0, 1, 0)
			UnderBarFrame.Size = UDim2.new(1, 0, 0, 45)

			local Text1 = Instance.new("TextLabel", Notification)
			Text1.Name = "Text1"
			Text1.BackgroundTransparency = 1.000
			Text1.Position = UDim2.new(0, 20, 0, 15)
			Text1.Size = UDim2.new(1, -40, 0, 30)
			Text1.Font = Enum.Font.GothamMedium
			Text1.Text = titletext
			Text1.TextColor3 = CurrentTheme.HeaderText
			Text1.TextSize = 18.000
			Text1.TextXAlignment = Enum.TextXAlignment.Left

			local Text2 = Instance.new("TextLabel", Notification)
			Text2.Name = "Text2"
			Text2.BackgroundTransparency = 1.000
			Text2.Position = UDim2.new(0, 20, 0, 45)
			Text2.Size = UDim2.new(1, -40, 0, 63)
			Text2.Font = Enum.Font.Gotham
			Text2.Text = desctext
			Text2.TextColor3 = CurrentTheme.SecondaryText
			Text2.TextSize = 14.000
			Text2.TextWrapped = true
			Text2.TextXAlignment = Enum.TextXAlignment.Left
			Text2.TextYAlignment = Enum.TextYAlignment.Top

			local AlrightBtn = Instance.new("TextButton")
			AlrightBtn.Name = "AlrightBtn"
			AlrightBtn.AnchorPoint = Vector2.new(0.5, 0.5)
			AlrightBtn.BackgroundColor3 = CurrentTheme.ButtonBackground
			AlrightBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
			AlrightBtn.Size = UDim2.new(1, -30, 1, -16)
			AlrightBtn.Font = Enum.Font.GothamMedium
			AlrightBtn.Text = btntext or GetTranslation("popup_okayButton")
			AlrightBtn.TextColor3 = CurrentTheme.ButtonText
			AlrightBtn.TextSize = 14.000
			AlrightBtn.AutoButtonColor = false
			AlrightBtn.Parent = UnderBarFrame

			local AlrightCorner = Instance.new("UICorner")
			AlrightCorner.CornerRadius = UDim.new(0, 4)
			AlrightCorner.Parent = AlrightBtn

			local function CloseNotification()
				local notifFrame = NotificationHolderMain and NotificationHolderMain:FindFirstChild("Notification")
				if notifFrame and notifFrame.Parent then notifFrame:TweenSize(UDim2.new(0, 346, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.2, true) end
				if NotificationHolderMain and NotificationHolderMain.Parent then TweenService:Create(NotificationHolderMain, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play() end
				task.wait(0.2)
				if NotificationHolderMain and NotificationHolderMain.Parent then NotificationHolderMain:Destroy() end
			end

			AlrightBtn.MouseButton1Click:Connect(CloseNotification)
			NotificationHolderMain.MouseButton1Click:Connect(CloseNotification)

			AlrightBtn.MouseEnter:Connect(function() TweenService:Create(AlrightBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ButtonHover}):Play() end)
			AlrightBtn.MouseLeave:Connect(function() TweenService:Create(AlrightBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ButtonBackground}):Play() end)
		end
	end

	local ServerHold = {}
	function ServerHold:Server(text, img)
		local fc = false
		local serverId = text .. "Server_" .. HttpService:GenerateGUID(false):sub(1,4)

		local ServerFrame = Instance.new("Frame")
		Elements[serverId.."Frame"] = ServerFrame
		ServerFrame.Name = serverId.."Frame"
		ServerFrame.Parent = Elements.ContentContainer
		ServerFrame.BorderSizePixel = 0
		ServerFrame.ClipsDescendants = true
		ServerFrame.Position = UDim2.new(0, 0, 0, 0)
		ServerFrame.Size = UDim2.new(1, 0, 1, 0)
		ServerFrame.Visible = false
		ServerFrame.ZIndex = 4
		ServerFrame.BackgroundTransparency = 1

		local ServerButton = Instance.new("TextButton")
		ServerButton.Name = serverId
		ServerButton.Parent = Elements.ServersHold
		ServerButton.Size = UDim2.new(0, 47, 0, 47)
		ServerButton.AutoButtonColor = false
		ServerButton.Font = Enum.Font.Gotham
		ServerButton.Text = ""
		ServerButton.TextSize = 18.000
		ServerButton.ZIndex = 2

		local ServerBtnCorner = Instance.new("UICorner")
		ServerBtnCorner.Name = "ServerCorner"
		ServerBtnCorner.CornerRadius = UDim.new(1, 0)
		ServerBtnCorner.Parent = ServerButton

		local ServerIco = Instance.new("ImageLabel")
		ServerIco.Name = "ServerIco"
		ServerIco.AnchorPoint = Vector2.new(0.5, 0.5)
		ServerIco.BackgroundTransparency = 1.000
		ServerIco.Position = UDim2.new(0.5, 0, 0.5, 0)
		ServerIco.Size = UDim2.new(1, -10, 1, -10)
		ServerIco.Image = ""
		ServerIco.ZIndex = 1
		ServerIco.ScaleType = Enum.ScaleType.Fit
		ServerIco.Parent = ServerButton

		local ServerIcoCorner = Instance.new("UICorner")
		ServerIcoCorner.CornerRadius = UDim.new(1, 0)
		ServerIcoCorner.Parent = ServerIco

		local ServerWhiteFrame = Instance.new("Frame")
		ServerWhiteFrame.Name = "ServerWhiteFrame"
		ServerWhiteFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		ServerWhiteFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ServerWhiteFrame.Position = UDim2.new(0, -30, 0.5, 0)
		ServerWhiteFrame.Size = UDim2.new(0, 6, 0, 10)
		ServerWhiteFrame.Visible = false
		ServerWhiteFrame.Parent = ServerButton

		local ServerWhiteFrameCorner = Instance.new("UICorner")
		ServerWhiteFrameCorner.CornerRadius = UDim.new(0, 3)
		ServerWhiteFrameCorner.Parent = ServerWhiteFrame

		local ChannelListFrame = Instance.new("Frame")
		ChannelListFrame.Name = "ChannelListFrame"
		ChannelListFrame.BorderSizePixel = 0
		ChannelListFrame.Position = UDim2.new(0, 0, 0, 0)
		ChannelListFrame.Size = UDim2.new(0, 240, 1, 0)
		ChannelListFrame.Parent = ServerFrame

		local ServerTitleFrame = Instance.new("Frame")
		ServerTitleFrame.Name = "ServerTitleFrame"
		ServerTitleFrame.BorderSizePixel = 0
		ServerTitleFrame.Size = UDim2.new(1, 0, 0, 48)
		ServerTitleFrame.Parent = ChannelListFrame

		local TitleShadow = Instance.new("Frame")
		TitleShadow.Name = "TitleShadow"
		TitleShadow.BorderSizePixel = 0
		TitleShadow.Size = UDim2.new(1, 0, 0, 1)
		TitleShadow.AnchorPoint = Vector2.new(0, 1)
		TitleShadow.Position = UDim2.new(0, 0, 1, 0)
		TitleShadow.Parent = ServerTitleFrame

		local ServerTitle = Instance.new("TextLabel")
		ServerTitle.Name = "ServerTitle"
		ServerTitle.BackgroundTransparency = 1.000
		ServerTitle.Position = UDim2.new(0, 16, 0, 0)
		ServerTitle.Size = UDim2.new(1, -32, 1, 0)
		ServerTitle.Font = Enum.Font.GothamMedium
		ServerTitle.Text = text
		ServerTitle.TextSize = 15.000
		ServerTitle.TextXAlignment = Enum.TextXAlignment.Left
		ServerTitle.Parent = ServerTitleFrame

		local ServerChannelHolder = Instance.new("ScrollingFrame")
		ServerChannelHolder.Name = "ServerChannelHolder"
		ServerChannelHolder.Active = true
		ServerChannelHolder.BackgroundTransparency = 0
		ServerChannelHolder.BorderSizePixel = 0
		ServerChannelHolder.Position = UDim2.new(0, 0, 0, 48)
		ServerChannelHolder.Size = UDim2.new(1, 0, 1, -48)
		ServerChannelHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
		ServerChannelHolder.ScrollBarThickness = 4
		ServerChannelHolder.ScrollBarImageTransparency = 1
		ServerChannelHolder.ScrollingDirection = Enum.ScrollingDirection.Y
		ServerChannelHolder.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
		ServerChannelHolder.Parent = ChannelListFrame

		Elements[serverId.."_ChannelListHolder"] = ServerChannelHolder

		local ServerChannelHolderLayout = Instance.new("UIListLayout")
		ServerChannelHolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ServerChannelHolderLayout.Padding = UDim.new(0, 2)
		ServerChannelHolderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		ServerChannelHolderLayout.Parent = ServerChannelHolder

		local ServerChannelHolderPadding = Instance.new("UIPadding")
		ServerChannelHolderPadding.PaddingTop = UDim.new(0, 8)
		ServerChannelHolderPadding.PaddingBottom = UDim.new(0, 8)
		ServerChannelHolderPadding.PaddingLeft = UDim.new(0, 8)
		ServerChannelHolderPadding.PaddingRight = UDim.new(0, 8)
		ServerChannelHolderPadding.Parent = ServerChannelHolder

		local ContentAreaFrame = Instance.new("Frame")
		ContentAreaFrame.Name = "ContentAreaFrame"
		ContentAreaFrame.BorderSizePixel = 0
		ContentAreaFrame.Position = UDim2.new(0, 240, 0, 0)
		ContentAreaFrame.Size = UDim2.new(1, -240, 1, 0)
		ContentAreaFrame.ClipsDescendants = true
		ContentAreaFrame.Parent = ServerFrame

		local ChannelTitleFrame = Instance.new("Frame")
		ChannelTitleFrame.Name = "ChannelTitleFrame"
		ChannelTitleFrame.BorderSizePixel = 0
		ChannelTitleFrame.Size = UDim2.new(1, 0, 0, 48)
		ChannelTitleFrame.Parent = ContentAreaFrame

		local ContentTitleShadow = Instance.new("Frame")
		ContentTitleShadow.Name = "ContentTitleShadow"
		ContentTitleShadow.BorderSizePixel = 0
		ContentTitleShadow.Size = UDim2.new(1, 0, 0, 1)
		ContentTitleShadow.AnchorPoint = Vector2.new(0, 1)
		ContentTitleShadow.Position = UDim2.new(0, 0, 1, 0)
		ContentTitleShadow.Parent = ChannelTitleFrame

		local Hashtag = Instance.new("TextLabel")
		Hashtag.Name = "Hashtag"
		Hashtag.BackgroundTransparency = 1.000
		Hashtag.Position = UDim2.new(0, 16, 0, 0)
		Hashtag.Size = UDim2.new(0, 19, 1, 0)
		Hashtag.Font = Enum.Font.Gotham
		Hashtag.Text = "#"
		Hashtag.TextSize = 20.000
		Hashtag.Parent = ChannelTitleFrame

		local ChannelTitle = Instance.new("TextLabel")
		ChannelTitle.Name = "ChannelTitle"
		ChannelTitle.BackgroundTransparency = 1.000
		ChannelTitle.Position = UDim2.new(0, 40, 0, 0)
		ChannelTitle.Size = UDim2.new(1, -55, 1, 0)
		ChannelTitle.Font = Enum.Font.GothamMedium
		ChannelTitle.Text = ""
		ChannelTitle.TextSize = 15.000
		ChannelTitle.TextXAlignment = Enum.TextXAlignment.Left
		ChannelTitle.Parent = ChannelTitleFrame

		Elements[serverId.."_ChannelTitle"] = ChannelTitle

		local ChannelContentFrame = Instance.new("Frame")
		ChannelContentFrame.Name = "ChannelContentFrame"
		ChannelContentFrame.BorderSizePixel = 0
		ChannelContentFrame.ClipsDescendants = true
		ChannelContentFrame.Position = UDim2.new(0, 0, 0, 48)
		ChannelContentFrame.Size = UDim2.new(1, 0, 1, -48)
		ChannelContentFrame.Parent = ContentAreaFrame

		Elements[serverId.."_ChannelContentFrame"] = ChannelContentFrame

		if Elements.ServersHold and ServersHoldLayout and ServersHoldPadding then
			task.wait()
			Elements.ServersHold.CanvasSize = UDim2.new(0, 0, 0, ServersHoldLayout.AbsoluteContentSize.Y + ServersHoldPadding.PaddingTop.Offset)
		end

		ServerButton.MouseEnter:Connect(function()
			if currentservertoggled ~= serverId then
				TweenService:Create(ServerButton, TweenInfo.new(0.15), {BackgroundColor3 = CurrentTheme.ServerButtonHover}):Play()
				local corner = ServerButton:FindFirstChild("ServerCorner")
				if corner then TweenService:Create(corner, TweenInfo.new(0.15), {CornerRadius = UDim.new(0, 15)}):Play() end
			end
			ServerWhiteFrame:TweenSize(UDim2.new(0, 6, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
			ServerWhiteFrame.Visible = true
		end)
		ServerButton.MouseLeave:Connect(function()
			if currentservertoggled ~= serverId then
				TweenService:Create(ServerButton, TweenInfo.new(0.15), {BackgroundColor3 = CurrentTheme.ServerButton}):Play()
				local corner = ServerButton:FindFirstChild("ServerCorner")
				if corner then TweenService:Create(corner, TweenInfo.new(0.15), {CornerRadius = UDim.new(1, 0)}):Play() end
				ServerWhiteFrame:TweenSize(UDim2.new(0, 6, 0, 10), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
				ServerWhiteFrame.Visible = false
			else
				ServerWhiteFrame:TweenSize(UDim2.new(0, 6, 0, 35), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
			end
		end)
		ServerButton.MouseButton1Click:Connect(function()
			if currentservertoggled == serverId then return end
			if currentservertoggled ~= "" then
				local oldServerFrame = Elements[currentservertoggled.."Frame"] or Elements.ServersHolderFolder:FindFirstChild(currentservertoggled.."Frame")
				if oldServerFrame then oldServerFrame.Visible = false end
				local oldServerButton = Elements.ServersHold and Elements.ServersHold:FindFirstChild(currentservertoggled)
				if oldServerButton then
					TweenService:Create(oldServerButton, TweenInfo.new(0.15), {BackgroundColor3 = CurrentTheme.ServerButton}):Play()
					local oldCorner = oldServerButton:FindFirstChild("ServerCorner")
					if oldCorner then TweenService:Create(oldCorner, TweenInfo.new(0.15), {CornerRadius = UDim.new(1, 0)}):Play() end
					local oldIndicator = oldServerButton:FindFirstChild("ServerWhiteFrame")
					if oldIndicator then oldIndicator:TweenSize(UDim2.new(0, 6, 0, 10), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true); oldIndicator.Visible = false end
				end
			end
			currentservertoggled = serverId
			if ServerFrame then ServerFrame.Visible = true end
			TweenService:Create(ServerButton, TweenInfo.new(0.15), {BackgroundColor3 = CurrentTheme.ServerButtonActive}):Play()
			local corner = ServerButton:FindFirstChild("ServerCorner")
			if corner then TweenService:Create(corner, TweenInfo.new(0.15), {CornerRadius = UDim.new(0, 15)}):Play() end
			ServerWhiteFrame:TweenSize(UDim2.new(0, 6, 0, 35), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.15, true)
			ServerWhiteFrame.Visible = true
			ApplyTheme(currentThemeName, false)
			ApplyLanguage(false)
		end)
		if img and img ~= "" then
			local success, _ = pcall(function() ServerIco.Image = img end)
			if not success then ServerButton.Text = string.sub(text, 1, 1):upper() end
		else
			ServerButton.Text = string.sub(text, 1, 1):upper()
		end
		if fs == false then
			fs = true
			ServerButton.BackgroundColor3 = CurrentTheme.ServerButtonActive
			local corner = ServerButton:FindFirstChild("ServerCorner")
			if corner then corner.CornerRadius = UDim.new(0, 15) end
			ServerWhiteFrame.Size = UDim2.new(0, 6, 0, 35)
			ServerWhiteFrame.Visible = true
			ServerFrame.Visible = true
			currentservertoggled = serverId
			ApplyTheme(currentThemeName, true)
			ApplyLanguage(true)
		end

		local ChannelHold = {}
		function ChannelHold:Channel(channelName)
			local channelId = channelName.."ChannelBtn_"..HttpService:GenerateGUID(false):sub(1,4)
			local channelHolderName = channelName.."_Holder"
			Elements[serverId.."_ActiveChannelId"] = Elements[serverId.."_ActiveChannelId"] or ""

			local ChannelBtn = Instance.new("TextButton")
			ChannelBtn.Name = channelId
			ChannelBtn.Parent = ServerChannelHolder
			ChannelBtn.BorderSizePixel = 0
			ChannelBtn.Size = UDim2.new(1, -10, 0, 32)
			ChannelBtn.AutoButtonColor = false
			ChannelBtn.Font = Enum.Font.SourceSans
			ChannelBtn.Text = ""
			ChannelBtn.BackgroundTransparency = 1.000

			local ChannelBtnCorner = Instance.new("UICorner")
			ChannelBtnCorner.Name = "ChannelBtnCorner"
			ChannelBtnCorner.CornerRadius = UDim.new(0, 4)
			ChannelBtnCorner.Parent = ChannelBtn

			local ChannelBtnLayout = Instance.new("UIListLayout")
			ChannelBtnLayout.FillDirection = Enum.FillDirection.Horizontal
			ChannelBtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			ChannelBtnLayout.Padding = UDim.new(0, 6)
			ChannelBtnLayout.Parent = ChannelBtn

			local ChannelBtnPadding = Instance.new("UIPadding")
			ChannelBtnPadding.PaddingLeft = UDim.new(0, 8)
			ChannelBtnPadding.Parent = ChannelBtn

			local ChannelBtnHashtag = Instance.new("TextLabel")
			ChannelBtnHashtag.Name = "ChannelBtnHashtag"
			ChannelBtnHashtag.BackgroundTransparency = 1.000
			ChannelBtnHashtag.Size = UDim2.new(0, 12, 0, 21)
			ChannelBtnHashtag.Font = Enum.Font.Gotham
			ChannelBtnHashtag.Text = "#"
			ChannelBtnHashtag.TextSize = 20.000
			ChannelBtnHashtag.Parent = ChannelBtn

			local ChannelBtnTitle = Instance.new("TextLabel")
			ChannelBtnTitle.Name = "ChannelBtnTitle"
			ChannelBtnTitle.BackgroundTransparency = 1.000
			ChannelBtnTitle.Size = UDim2.new(1, -30, 1, 0)
			ChannelBtnTitle.Font = Enum.Font.GothamMedium
			ChannelBtnTitle.Text = channelName
			ChannelBtnTitle.TextSize = 14.000
			ChannelBtnTitle.TextXAlignment = Enum.TextXAlignment.Left
			ChannelBtnTitle.Parent = ChannelBtn

			local ChannelHolder = Instance.new("ScrollingFrame")
			ChannelHolder.Name = channelHolderName
			ChannelHolder.Parent = ChannelContentFrame
			ChannelHolder.Active = true
			ChannelHolder.BackgroundTransparency = 0
			ChannelHolder.BorderSizePixel = 0
			ChannelHolder.Position = UDim2.new(0,0,0,0)
			ChannelHolder.Size = UDim2.new(1,0,1,0)
			ChannelHolder.ScrollBarThickness = 6
			ChannelHolder.CanvasSize = UDim2.new(0,0,0,0)
			ChannelHolder.ScrollBarImageTransparency = 1
			ChannelHolder.Visible = false
			ChannelHolder.ClipsDescendants = false
			ChannelHolder.ScrollingDirection = Enum.ScrollingDirection.Y
			ChannelHolder.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

			local ChannelHolderLayout = Instance.new("UIListLayout")
			ChannelHolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ChannelHolderLayout.Padding = UDim.new(0, 2)
			ChannelHolderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			ChannelHolderLayout.Parent = ChannelHolder

			local ChannelHolderPadding = Instance.new("UIPadding")
			ChannelHolderPadding.PaddingTop = UDim.new(0, 8)
			ChannelHolderPadding.PaddingBottom = UDim.new(0, 8)
			ChannelHolderPadding.PaddingLeft = UDim.new(0, 8)
			ChannelHolderPadding.PaddingRight = UDim.new(0, 8)
			ChannelHolderPadding.Parent = ChannelHolder
			ChannelBtn.MouseEnter:Connect(function()
				if Elements[serverId.."_ActiveChannelId"] ~= channelId then
					TweenService:Create(ChannelBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ChannelButtonHover}):Play()
					TweenService:Create(ChannelBtnTitle, TweenInfo.new(0.1), {TextColor3 = CurrentTheme.InteractiveHover}):Play()
					TweenService:Create(ChannelBtnHashtag, TweenInfo.new(0.1), {TextColor3 = CurrentTheme.InteractiveHover}):Play()
				end
			end)
			ChannelBtn.MouseLeave:Connect(function()
				if Elements[serverId.."_ActiveChannelId"] ~= channelId then
					TweenService:Create(ChannelBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ChannelButton}):Play()
					TweenService:Create(ChannelBtnTitle, TweenInfo.new(0.1), {TextColor3 = CurrentTheme.InteractiveNormal}):Play()
					TweenService:Create(ChannelBtnHashtag, TweenInfo.new(0.1), {TextColor3 = CurrentTheme.InteractiveNormal}):Play()
				end
			end)
			ChannelBtn.MouseButton1Click:Connect(function()
				if Elements[serverId.."_ActiveChannelId"] == channelId then return end
				local oldChannelId = Elements[serverId.."_ActiveChannelId"]
				if oldChannelId ~= "" then
					local oldBtn = ServerChannelHolder:FindFirstChild(oldChannelId)
					if oldBtn then
						TweenService:Create(oldBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ChannelButton}):Play()
						local oldTitle = oldBtn:FindFirstChild("ChannelBtnTitle")
						if oldTitle then TweenService:Create(oldTitle, TweenInfo.new(0.1), {TextColor3 = CurrentTheme.InteractiveNormal}):Play() end
						local oldHash = oldBtn:FindFirstChild("ChannelBtnHashtag")
						if oldHash then TweenService:Create(oldHash, TweenInfo.new(0.1), {TextColor3 = CurrentTheme.InteractiveNormal}):Play() end
					end
					local oldChannelName = ""
					if oldBtn then oldChannelName = oldBtn:FindFirstChild("ChannelBtnTitle").Text end
					local oldHolder = ChannelContentFrame:FindFirstChild(oldChannelName.."_Holder")
					if oldHolder then oldHolder.Visible = false end
				end
				Elements[serverId.."_ActiveChannelId"] = channelId
				ChannelHolder.Visible = true
				if ChannelTitle then ChannelTitle.Text = channelName end
				TweenService:Create(ChannelBtn, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ChannelButtonActive}):Play()
				TweenService:Create(ChannelBtnTitle, TweenInfo.new(0.1), {TextColor3 = CurrentTheme.InteractiveActive}):Play()
				TweenService:Create(ChannelBtnHashtag, TweenInfo.new(0.1), {TextColor3 = CurrentTheme.InteractiveActive}):Play()
				ApplyTheme(currentThemeName, false)
				ApplyLanguage(false)
			end)
			ChannelHolder.MouseEnter:Connect(function() TweenService:Create(ChannelHolder, TweenInfo.new(0.2), {ScrollBarImageTransparency = 0}):Play() end)
			ChannelHolder.MouseLeave:Connect(function() TweenService:Create(ChannelHolder, TweenInfo.new(0.2), {ScrollBarImageTransparency = 1}):Play() end)

			task.wait()
			if ServerChannelHolder and ServerChannelHolderLayout and ServerChannelHolderPadding then
				ServerChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ServerChannelHolderLayout.AbsoluteContentSize.Y + ServerChannelHolderPadding.PaddingTop.Offset + ServerChannelHolderPadding.PaddingBottom.Offset)
			end

			if fc == false then
				fc = true
				Elements[serverId.."_ActiveChannelId"] = channelId
				if ChannelTitle then ChannelTitle.Text = channelName end
				ChannelBtn.BackgroundColor3 = CurrentTheme.ChannelButtonActive
				ChannelBtnTitle.TextColor3 = CurrentTheme.InteractiveActive
				ChannelBtnHashtag.TextColor3 = CurrentTheme.InteractiveActive
				ChannelHolder.Visible = true
				ApplyTheme(currentThemeName, true)
				ApplyLanguage(true)
			end

			local ChannelContent = {}
			local function UpdateCanvasSize()
				task.wait()
				if ChannelHolder and ChannelHolderLayout and ChannelHolderPadding then
					ChannelHolder.CanvasSize = UDim2.new(0,0,0, ChannelHolderLayout.AbsoluteContentSize.Y + ChannelHolderPadding.PaddingTop.Offset + ChannelHolderPadding.PaddingBottom.Offset)
				end
			end

			function ChannelContent:Button(buttonText, callback)
				local Button = Instance.new("TextButton")
				Button.Name = buttonText.."_Button"
				Button.Parent = ChannelHolder
				Button.Size = UDim2.new(1, 0, 0, 32)
				Button.AutoButtonColor = false
				Button.Font = Enum.Font.GothamMedium
				Button.TextSize = 14.000
				Button.Text = buttonText

				local ButtonCorner = Instance.new("UICorner")
				ButtonCorner.CornerRadius = UDim.new(0, 4)
				ButtonCorner.Name = "ButtonCorner"
				ButtonCorner.Parent = Button

				tweenColor(Button, "BackgroundColor3", CurrentTheme.ButtonBackground)
				tweenColor(Button, "TextColor3", CurrentTheme.ButtonText)


				Button.MouseEnter:Connect(function() TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ButtonHover}):Play() end)
				Button.MouseLeave:Connect(function() TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = CurrentTheme.ButtonBackground}):Play() end)
				Button.MouseButton1Click:Connect(function()
					local originalSize = Button.Size
					local targetSize = UDim2.new(originalSize.X.Scale * 0.95, originalSize.X.Offset * 0.95, originalSize.Y.Scale * 0.95, originalSize.Y.Offset * 0.95)
					Button:TweenSize(targetSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true, function()
						Button:TweenSize(originalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.1, true)
					end)
					pcall(callback)
				end)
				UpdateCanvasSize()
			end

			function ChannelContent:Toggle(toggleText, defaultState, callback)
				local toggled = defaultState or false
				local Toggle = Instance.new("Frame")
				Toggle.Name = toggleText.."_Toggle"
				Toggle:SetAttribute("ToggledState", toggled)
				Toggle.Parent = ChannelHolder
				Toggle.BackgroundTransparency = 1
				Toggle.BorderSizePixel = 0
				Toggle.Size = UDim2.new(1, 0, 0, 40)

				local ToggleButton = Instance.new("TextButton")
				ToggleButton.BackgroundTransparency = 1
				ToggleButton.Size = UDim2.new(1,0,1,0)
				ToggleButton.Text = ""
				ToggleButton.AutoButtonColor = false
				ToggleButton.ZIndex = 2
				ToggleButton.Parent = Toggle

				local ToggleTitle = Instance.new("TextLabel")
				ToggleTitle.Name = "ToggleTitle"
				ToggleTitle.BackgroundTransparency = 1.000
				ToggleTitle.AnchorPoint = Vector2.new(0, 0.5)
				ToggleTitle.Position = UDim2.new(0, 0, 0.5, 0)
				ToggleTitle.Size = UDim2.new(0.8, -50, 1, 0)
				ToggleTitle.Font = Enum.Font.Gotham
				ToggleTitle.Text = toggleText
				ToggleTitle.TextSize = 14.000
				ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left
				ToggleTitle.Parent = Toggle

				local ToggleFrame = Instance.new("Frame")
				ToggleFrame.Name = "ToggleFrame"
				ToggleFrame.AnchorPoint = Vector2.new(1, 0.5)
				ToggleFrame.Position = UDim2.new(1, 0, 0.5, 0)
				ToggleFrame.Size = UDim2.new(0, 40, 0, 21)
				ToggleFrame.Parent = Toggle

				local ToggleFrameCorner = Instance.new("UICorner")
				ToggleFrameCorner.CornerRadius = UDim.new(1, 0)
				ToggleFrameCorner.Name = "ToggleFrameCorner"
				ToggleFrameCorner.Parent = ToggleFrame

				local ToggleFrameCircle = Instance.new("Frame")
				ToggleFrameCircle.Name = "ToggleFrameCircle"
				ToggleFrameCircle.AnchorPoint = Vector2.new(0.5, 0.5)
				ToggleFrameCircle.Position = toggled and UDim2.new(1, -10.5, 0.5, 0) or UDim2.new(0, 10.5, 0.5, 0)
				ToggleFrameCircle.Size = UDim2.new(0, 15, 0, 15)
				ToggleFrameCircle.Parent = ToggleFrame

				local ToggleFrameCircleCorner = Instance.new("UICorner")
				ToggleFrameCircleCorner.CornerRadius = UDim.new(1, 0)
				ToggleFrameCircleCorner.Parent = ToggleFrameCircle

				local Icon = Instance.new("ImageLabel")
				Icon.Name = "Icon"
				Icon.AnchorPoint = Vector2.new(0.5, 0.5)
				Icon.BackgroundTransparency = 1.000
				Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
				Icon.Size = UDim2.new(0, 10, 0, 10)
				Icon.Image = toggled and "http://www.roblox.com/asset/?id=6023426926" or "http://www.roblox.com/asset/?id=6035047409"
				Icon.ImageTransparency = 0
				Icon.Parent = ToggleFrameCircle
				Icon.ZIndex = ToggleFrameCircle.ZIndex + 1

				tweenColor(ToggleTitle, "TextColor3", CurrentTheme.SecondaryText)
				tweenColor(ToggleFrame, "BackgroundColor3", toggled and CurrentTheme.ToggleActiveBackground or CurrentTheme.ToggleButtonBackground)
				tweenColor(ToggleFrameCircle, "BackgroundColor3", CurrentTheme.ToggleButtonCircle)
				tweenColor(Icon, "ImageColor3", toggled and CurrentTheme.IconActive or CurrentTheme.IconMuted)

				ToggleButton.MouseButton1Click:Connect(function()
					toggled = not toggled
					Toggle:SetAttribute("ToggledState", toggled)
					local targetBgColor = toggled and CurrentTheme.ToggleActiveBackground or CurrentTheme.ToggleButtonBackground
					local targetCirclePos = toggled and UDim2.new(1, -10.5, 0.5, 0) or UDim2.new(0, 10.5, 0.5, 0)
					local targetIconColor = toggled and CurrentTheme.IconActive or CurrentTheme.IconMuted
					local targetIconImage = toggled and "http://www.roblox.com/asset/?id=6023426926" or "http://www.roblox.com/asset/?id=6035047409"
					local tweenInfoShort = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					TweenService:Create(ToggleFrame, tweenInfoShort, {BackgroundColor3 = targetBgColor}):Play()
					TweenService:Create(ToggleFrameCircle, tweenInfoShort, {Position = targetCirclePos}):Play()
					if Icon and Icon.Parent then
						TweenService:Create(Icon, tweenInfoShort, {ImageColor3 = targetIconColor}):Play()
						Icon.Image = targetIconImage
					end
					pcall(callback, toggled)
				end)
				UpdateCanvasSize()
				return Toggle
			end

			function ChannelContent:Slider(sliderText, min, max, start, callback)
				local SliderFunc = {}
				local dragging = false
				local currentValue = start or min
				local SliderBase = Instance.new("Frame")
				SliderBase.Name = sliderText.."_Slider"
				SliderBase.Parent = ChannelHolder
				SliderBase.BackgroundTransparency = 1
				SliderBase.Size = UDim2.new(1, 0, 0, 45)

				local SliderTitle = Instance.new("TextLabel")
				SliderTitle.Name = "SliderTitle"
				SliderTitle.BackgroundTransparency = 1.000
				SliderTitle.Position = UDim2.new(0, 0, 0, 0)
				SliderTitle.Size = UDim2.new(1, -50, 0, 20)
				SliderTitle.Font = Enum.Font.Gotham
				SliderTitle.Text = sliderText
				SliderTitle.TextSize = 14.000
				SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
				SliderTitle.Parent = SliderBase

				local ValueDisplay = Instance.new("TextLabel")
				ValueDisplay.Name = "ValueDisplay"
				ValueDisplay.BackgroundTransparency = 1
				ValueDisplay.AnchorPoint = Vector2.new(1, 0)
				ValueDisplay.Position = UDim2.new(1, 0, 0, 0)
				ValueDisplay.Size = UDim2.new(0, 40, 0, 20)
				ValueDisplay.Font = Enum.Font.GothamMedium
				ValueDisplay.TextSize = 13.000
				ValueDisplay.TextXAlignment = Enum.TextXAlignment.Right
				ValueDisplay.Text = tostring(math.floor(currentValue))
				ValueDisplay.Parent = SliderBase

				local SliderFrame = Instance.new("Frame")
				SliderFrame.Name = "SliderFrame"
				SliderFrame.Position = UDim2.new(0, 0, 0, 25)
				SliderFrame.Size = UDim2.new(1, 0, 0, 8)
				SliderFrame.Parent = SliderBase

				local SliderFrameCorner = Instance.new("UICorner")
				SliderFrameCorner.CornerRadius = UDim.new(1, 0)
				SliderFrameCorner.Parent = SliderFrame

				local CurrentValueFrame = Instance.new("Frame")
				CurrentValueFrame.Name = "CurrentValueFrame"
				CurrentValueFrame.BorderSizePixel = 0
				CurrentValueFrame.Size = UDim2.new(math.clamp((currentValue - min) / (max - min), 0, 1), 0, 1, 0)
				CurrentValueFrame.Parent = SliderFrame

				local CurrentValueFrameCorner = Instance.new("UICorner")
				CurrentValueFrameCorner.CornerRadius = UDim.new(1, 0)
				CurrentValueFrameCorner.Parent = CurrentValueFrame

				local Zip = Instance.new("TextButton")
				Zip.Name = "Zip"
				Zip.BorderSizePixel = 2
				Zip.AnchorPoint = Vector2.new(0.5, 0.5)
				Zip.Position = UDim2.new(math.clamp((currentValue - min) / (max - min), 0, 1), 0, 0.5, 0)
				Zip.Size = UDim2.new(0, 16, 0, 16)
				Zip.AutoButtonColor = false
				Zip.Text = ""
				Zip.ZIndex = 3
				Zip.Parent = SliderFrame

				local ZipCorner = Instance.new("UICorner")
				ZipCorner.CornerRadius = UDim.new(1, 0)
				ZipCorner.Parent = Zip

				local ValueBubble = Instance.new("Frame")
				ValueBubble.Name = "ValueBubble"
				ValueBubble.AnchorPoint = Vector2.new(0.5, 1)
				ValueBubble.Position = UDim2.new(0.5, 0, 0, -8)
				ValueBubble.Size = UDim2.new(0, 36, 0, 21)
				ValueBubble.BorderSizePixel = 1
				ValueBubble.Visible = false
				ValueBubble.ZIndex = 5
				ValueBubble.Parent = Zip

				local ValueBubbleCorner = Instance.new("UICorner")
				ValueBubbleCorner.CornerRadius = UDim.new(0, 3)
				ValueBubbleCorner.Parent = ValueBubble

				local ValueLabel = Instance.new("TextLabel")
				ValueLabel.Name = "ValueLabel"
				ValueLabel.BackgroundTransparency = 1.000
				ValueLabel.Size = UDim2.new(1, 0, 1, 0)
				ValueLabel.Font = Enum.Font.GothamMedium
				ValueLabel.Text = tostring(math.floor(currentValue))
				ValueLabel.TextSize = 11.000
				ValueLabel.Parent = ValueBubble

				tweenColor(SliderTitle, "TextColor3", CurrentTheme.SecondaryText)
				tweenColor(ValueDisplay, "TextColor3", CurrentTheme.PrimaryText)
				tweenColor(SliderFrame, "BackgroundColor3", CurrentTheme.InputBackground)
				tweenColor(CurrentValueFrame, "BackgroundColor3", CurrentTheme.AccentText)
				tweenColor(Zip, "BackgroundColor3", CurrentTheme.PrimaryText)
				tweenColor(Zip, "BorderColor3", CurrentTheme.ContentBackground)
				tweenColor(ValueBubble, "BackgroundColor3", CurrentTheme.TooltipBackground)
				tweenColor(ValueBubble, "BorderColor3", CurrentTheme.InputOutline)
				tweenColor(ValueLabel, "TextColor3", CurrentTheme.TooltipText)


				local dragConnection = nil
				local function UpdateSlider(inputPosition)
					local relativeX = inputPosition.X - SliderFrame.AbsolutePosition.X
					local percentage = math.clamp(relativeX / SliderFrame.AbsoluteSize.X, 0, 1)
					currentValue = min + percentage * (max - min)
					local displayValue = math.floor(currentValue)
					Zip.Position = UDim2.new(percentage, 0, 0.5, 0)
					CurrentValueFrame.Size = UDim2.new(percentage, 0, 1, 0)
					ValueLabel.Text = tostring(displayValue)
					ValueDisplay.Text = tostring(displayValue)
					pcall(callback, displayValue)
				end
				Zip.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
						ValueBubble.Visible = true
						if dragConnection then dragConnection:Disconnect() end
						dragConnection = UserInputService.InputChanged:Connect(function(inputChanged) if inputChanged.UserInputType == Enum.UserInputType.MouseMovement then UpdateSlider(inputChanged.Position) end end)
						UpdateSlider(input.Position)
					end
				end)
				Zip.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
						ValueBubble.Visible = false
						if dragConnection then dragConnection:Disconnect(); dragConnection = nil end
					end
				end)
				Zip.MouseEnter:Connect(function() if not dragging then ValueBubble.Visible = true end end)
				Zip.MouseLeave:Connect(function() if not dragging then ValueBubble.Visible = false end end)
				function SliderFunc:Change(newValue)
					newValue = math.clamp(newValue, min, max)
					currentValue = newValue
					local percentage = (newValue - min) / (max - min)
					local displayValue = math.floor(currentValue)
					Zip.Position = UDim2.new(percentage, 0, 0.5, 0)
					CurrentValueFrame.Size = UDim2.new(percentage, 0, 1, 0)
					ValueLabel.Text = tostring(displayValue)
					ValueDisplay.Text = tostring(displayValue)
					pcall(callback, displayValue)
				end
				UpdateCanvasSize()
				return SliderFunc
			end

			function ChannelContent:Separator()
				local SepFrame = Instance.new("Frame")
				SepFrame.Name = "Separator"
				SepFrame.BorderSizePixel = 0
				SepFrame.Size = UDim2.new(1, 0, 0, 1)
				SepFrame.LayoutOrder = 999
				SepFrame.Parent = ChannelHolder
				tweenColor(SepFrame, "BackgroundColor3", CurrentTheme.Separator)
				UpdateCanvasSize()
			end

			function ChannelContent:Textbox(tbText, placeholder, clearOnSubmit, callback)
				local TextboxBase = Instance.new("Frame")
				TextboxBase.Name = tbText.."_Textbox"
				TextboxBase.BackgroundTransparency = 1
				TextboxBase.Size = UDim2.new(1, 0, 0, 60)
				TextboxBase.Parent = ChannelHolder
				TextboxBase:SetAttribute("IsFocused", false)

				local Title = Instance.new("TextLabel")
				Title.Name = "TextboxTitle"
				Title.BackgroundTransparency = 1
				Title.Size = UDim2.new(1, 0, 0, 20)
				Title.Font = Enum.Font.Gotham
				Title.Text = tbText
				Title.TextSize = 14
				Title.TextXAlignment = Enum.TextXAlignment.Left
				Title.Parent = TextboxBase

				local Outline = Instance.new("Frame")
				Outline.Name = "Outline"
				Outline.Position = UDim2.new(0, 0, 0, 22)
				Outline.Size = UDim2.new(1, 0, 0, 36)
				Outline.Parent = TextboxBase

				local OutlineCorner = Instance.new("UICorner")
				OutlineCorner.CornerRadius = UDim.new(0,3)
				OutlineCorner.Parent = Outline

				local BG = Instance.new("Frame")
				BG.Name = "BG"
				BG.Position = UDim2.new(0,1,0,1)
				BG.Size = UDim2.new(1,-2,1,-2)
				BG.Parent = Outline

				local BGCorner = Instance.new("UICorner")
				BGCorner.CornerRadius = UDim.new(0,3)
				BGCorner.Parent = BG

				local InputBox = Instance.new("TextBox")
				InputBox.BackgroundTransparency = 1
				InputBox.Position = UDim2.new(0, 10, 0, 0)
				InputBox.Size = UDim2.new(1, -20, 1, 0)
				InputBox.Font = Enum.Font.Gotham
				InputBox.PlaceholderText = placeholder or ""
				InputBox.Text = ""
				InputBox.TextSize = 14.000
				InputBox.TextXAlignment = Enum.TextXAlignment.Left
				InputBox.ClearTextOnFocus = false
				InputBox.Parent = BG

				tweenColor(Title, "TextColor3", CurrentTheme.SecondaryText)
				tweenColor(Outline, "BackgroundColor3", CurrentTheme.InputOutline)
				tweenColor(BG, "BackgroundColor3", CurrentTheme.InputBackground)
				tweenColor(InputBox, "TextColor3", CurrentTheme.PrimaryText)
				InputBox.PlaceholderColor3 = CurrentTheme.MutedText

				InputBox.Focused:Connect(function()
					TextboxBase:SetAttribute("IsFocused", true)
					TweenService:Create(Outline, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.InputOutlineFocus}):Play()
				end)
				InputBox.FocusLost:Connect(function(enterPressed)
					TextboxBase:SetAttribute("IsFocused", false)
					TweenService:Create(Outline, TweenInfo.new(0.2), {BackgroundColor3 = CurrentTheme.InputOutline}):Play()
					if enterPressed and #InputBox.Text > 0 then
						pcall(callback, InputBox.Text)
						if clearOnSubmit then InputBox.Text = "" end
					end
				end)
				UpdateCanvasSize()
			end

			function ChannelContent:Label(labelText)
				local Label = Instance.new("TextLabel")
				Label.Name = labelText.."_Label"
				Label.BackgroundTransparency = 1
				Label.Size = UDim2.new(1, 0, 0, 30)
				Label.Font = Enum.Font.GothamMedium
				Label.Text = labelText
				Label.TextSize = 14.000
				Label.TextXAlignment = Enum.TextXAlignment.Left
				Label.TextYAlignment = Enum.TextYAlignment.Center
				Label.Parent = ChannelHolder
				Label.TextColor3 = CurrentTheme.PrimaryText
				Label.TextWrapped = true

				local LabelPadding = Instance.new("UIPadding")
				LabelPadding.PaddingLeft = UDim.new(0, 5)
				LabelPadding.Parent = Label
				tweenColor(Label, "TextColor3", CurrentTheme.PrimaryText)
				UpdateCanvasSize()
			end

			function ChannelContent:Bind(bindText, defaultKey, callback)
				local currentKey = defaultKey or Enum.KeyCode.F
				local listening = false
				local BindFrame = Instance.new("Frame")
				BindFrame.Name = bindText.."_Bind"
				BindFrame.BackgroundTransparency = 1
				BindFrame.Size = UDim2.new(1, 0, 0, 35)
				BindFrame.Parent = ChannelHolder

				local Title = Instance.new("TextLabel")
				Title.Name = "BindTitle"
				Title.BackgroundTransparency = 1
				Title.Size = UDim2.new(0.6, 0, 1, 0)
				Title.Font = Enum.Font.Gotham
				Title.Text = bindText
				Title.TextSize = 14
				Title.TextXAlignment = Enum.TextXAlignment.Left
				Title.TextYAlignment = Enum.TextYAlignment.Center
				Title.Parent = BindFrame

				local KeyButton = Instance.new("TextButton")
				KeyButton.Name = "KeyButton"
				KeyButton.Position = UDim2.new(0.65, 0, 0, 0)
				KeyButton.Size = UDim2.new(0.35, 0, 1, 0)
				KeyButton.Font = Enum.Font.GothamMedium
				KeyButton.Text = currentKey.Name ~= "Unknown" and currentKey.Name or "None"
				KeyButton.TextSize = 13
				KeyButton.AutoButtonColor = false
				KeyButton.Parent = BindFrame

				local KeyButtonCorner = Instance.new("UICorner")
				KeyButtonCorner.CornerRadius = UDim.new(0, 3)
				KeyButtonCorner.Parent = KeyButton

				tweenColor(Title, "TextColor3", CurrentTheme.SecondaryText)
				tweenColor(KeyButton, "BackgroundColor3", CurrentTheme.InputBackground)
				tweenColor(KeyButton, "TextColor3", CurrentTheme.PrimaryText)


				local inputConnection = nil
				KeyButton.MouseButton1Click:Connect(function()
					if listening then return end
					listening = true
					KeyButton.Text = "..."
					KeyButton.TextColor3 = CurrentTheme.AccentText
					if inputConnection then inputConnection:Disconnect() end
					inputConnection = UserInputService.InputBegan:Connect(function(input, processed)
						if processed then return end
						local newKeyName = "None"
						if input.UserInputType == Enum.UserInputType.Keyboard then
							currentKey = input.KeyCode
							newKeyName = currentKey.Name ~= "Unknown" and currentKey.Name or "None"
						elseif input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
							currentKey = input.UserInputType
							newKeyName = input.UserInputType.Name
						elseif input.UserInputType == Enum.UserInputType.None then
							currentKey = Enum.KeyCode.F
							newKeyName = "None"
						end

						KeyButton.Text = newKeyName
						KeyButton.TextColor3 = CurrentTheme.PrimaryText
						listening = false
						if inputConnection then inputConnection:Disconnect(); inputConnection = nil end
						pcall(callback, currentKey)
					end)
				end)
				UserInputService.InputBegan:Connect(function(input, processed)
					if processed or listening then return end
					if (input.KeyCode == currentKey and currentKey ~= Enum.KeyCode.Unknown) or (input.UserInputType == currentKey and currentKey ~= Enum.UserInputType.None) then
						pcall(callback)
					end
				end)
				UpdateCanvasSize()
			end
			
			function ChannelContent:Dropdown(text, list, callback)
				local DropFunc = {}
				local itemcount = 0
				local framesize = 0
				local DropTog = false
				local DropdownBase = Instance.new("Frame")
				local DropdownTitle = Instance.new("TextLabel")
				local DropdownFrameOutline = Instance.new("Frame")
				local DropdownFrameOutlineCorner = Instance.new("UICorner")
				local DropdownFrame = Instance.new("Frame")
				local DropdownFrameCorner = Instance.new("UICorner")
				local CurrentSelectedText = Instance.new("TextLabel")
				local ArrowImg = Instance.new("ImageLabel")
				local DropdownFrameBtn = Instance.new("TextButton")
				local DropdownFrameMainOutline = Instance.new("Frame")
				local DropdownFrameMainOutlineCorner = Instance.new("UICorner")
				local DropdownFrameMain = Instance.new("Frame")
				local DropdownFrameMainCorner = Instance.new("UICorner")
				local DropItemHolder = Instance.new("ScrollingFrame")
				local DropItemHolderLayout = Instance.new("UIListLayout")

				DropdownBase.Name = text.."_Dropdown"
				DropdownBase.Parent = ChannelHolder
				DropdownBase.BackgroundTransparency = 1.000
				DropdownBase.Size = UDim2.new(1, 0, 0, 73)
				DropdownBase.ClipsDescendants = false
				DropdownBase.ZIndex = 2

				local DropdownBaseLayout = Instance.new("UIListLayout")
				DropdownBaseLayout.Parent = DropdownBase
				DropdownBaseLayout.FillDirection = Enum.FillDirection.Vertical
				DropdownBaseLayout.SortOrder = Enum.SortOrder.LayoutOrder
				DropdownBaseLayout.Padding = UDim.new(0, 5)

				DropdownTitle.Name = "DropdownTitle"
				DropdownTitle.Parent = DropdownBase
				DropdownTitle.LayoutOrder = 1
				DropdownTitle.BackgroundTransparency = 1.000
				DropdownTitle.Size = UDim2.new(1, 0, 0, 20)
				DropdownTitle.Font = Enum.Font.Gotham
				DropdownTitle.Text = text
				DropdownTitle.TextColor3 = CurrentTheme.SecondaryText
				DropdownTitle.TextSize = 14.000
				DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left

				local ClickableBox = Instance.new("Frame")
				ClickableBox.Name = "ClickableBox"
				ClickableBox.Parent = DropdownBase
				ClickableBox.LayoutOrder = 2
				ClickableBox.BackgroundTransparency = 1
				ClickableBox.Size = UDim2.new(1, 0, 0, 36)

				DropdownFrameOutline.Name = "DropdownFrameOutline"
				DropdownFrameOutline.Parent = ClickableBox
				DropdownFrameOutline.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownFrameOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
				DropdownFrameOutline.Size = UDim2.new(1, 0, 1, 0)
				DropdownFrameOutline.BackgroundColor3 = CurrentTheme.InputOutline

				DropdownFrameOutlineCorner.CornerRadius = UDim.new(0, 3)
				DropdownFrameOutlineCorner.Name = "DropdownFrameOutlineCorner"
				DropdownFrameOutlineCorner.Parent = DropdownFrameOutline

				DropdownFrame.Name = "DropdownFrame"
				DropdownFrame.Parent = DropdownFrameOutline
				DropdownFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
				DropdownFrame.Size = UDim2.new(1, -2, 1, -2)
				DropdownFrame.BackgroundColor3 = CurrentTheme.InputBackground
				DropdownFrame.ClipsDescendants = true

				DropdownFrameCorner.CornerRadius = UDim.new(0, 3)
				DropdownFrameCorner.Name = "DropdownFrameCorner"
				DropdownFrameCorner.Parent = DropdownFrame

				CurrentSelectedText.Name = "CurrentSelectedText"
				CurrentSelectedText.Parent = DropdownFrame
				CurrentSelectedText.BackgroundTransparency = 1.000
				CurrentSelectedText.Position = UDim2.new(0, 10, 0, 0)
				CurrentSelectedText.Size = UDim2.new(1, -40, 1, 0)
				CurrentSelectedText.Font = Enum.Font.Gotham
				CurrentSelectedText.Text = "..."
				CurrentSelectedText.TextColor3 = CurrentTheme.PrimaryText
				CurrentSelectedText.TextSize = 14.000
				CurrentSelectedText.TextXAlignment = Enum.TextXAlignment.Left

				ArrowImg.Name = "ArrowImg"
				ArrowImg.Parent = DropdownFrame
				ArrowImg.BackgroundTransparency = 1.000
				ArrowImg.AnchorPoint = Vector2.new(1, 0.5)
				ArrowImg.Position = UDim2.new(1, -10, 0.5, 0)
				ArrowImg.Size = UDim2.new(0, 18, 0, 18)
				ArrowImg.Image = "http://www.roblox.com/asset/?id=6034818372"
				ArrowImg.ImageColor3 = CurrentTheme.IconColor
				ArrowImg.Rotation = 0

				DropdownFrameBtn.Name = "DropdownFrameBtn"
				DropdownFrameBtn.Parent = ClickableBox
				DropdownFrameBtn.BackgroundTransparency = 1.000
				DropdownFrameBtn.Size = UDim2.new(1, 0, 1, 0)
				DropdownFrameBtn.ZIndex = 3
				DropdownFrameBtn.Font = Enum.Font.SourceSans
				DropdownFrameBtn.Text = ""

				local DropdownListContainer = Instance.new("Frame")
				DropdownListContainer.Name = "DropdownListContainer"
				DropdownListContainer.Parent = DropdownBase
				DropdownListContainer.LayoutOrder = 3
				DropdownListContainer.BackgroundTransparency = 1
				DropdownListContainer.Size = UDim2.new(1, 0, 0, 0)
				DropdownListContainer.ClipsDescendants = true
				DropdownListContainer.Visible = false
				DropdownListContainer.ZIndex = 10

				DropdownFrameMainOutline.Name = "DropdownFrameMainOutline"
				DropdownFrameMainOutline.Parent = DropdownListContainer
				DropdownFrameMainOutline.AnchorPoint = Vector2.new(0.5, 0)
				DropdownFrameMainOutline.Position = UDim2.new(0.5, 0, 0, 0)
				DropdownFrameMainOutline.Size = UDim2.new(1, 0, 1, 0)
				DropdownFrameMainOutline.BackgroundColor3 = CurrentTheme.InputOutline

				DropdownFrameMainOutlineCorner.CornerRadius = UDim.new(0, 3)
				DropdownFrameMainOutlineCorner.Name = "DropdownFrameMainOutlineCorner"
				DropdownFrameMainOutlineCorner.Parent = DropdownFrameMainOutline

				DropdownFrameMain.Name = "DropdownFrameMain"
				DropdownFrameMain.Parent = DropdownFrameMainOutline
				DropdownFrameMain.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownFrameMain.Position = UDim2.new(0.5, 0, 0.5, 0)
				DropdownFrameMain.Size = UDim2.new(1, -2, 1, -2)
				DropdownFrameMain.BackgroundColor3 = CurrentTheme.PopupSecondaryBackground
				DropdownFrameMain.ClipsDescendants = true

				DropdownFrameMainCorner.CornerRadius = UDim.new(0, 3)
				DropdownFrameMainCorner.Name = "DropdownFrameMainCorner"
				DropdownFrameMainCorner.Parent = DropdownFrameMain

				DropItemHolder.Name = "ItemHolder"
				DropItemHolder.Parent = DropdownFrameMain
				DropItemHolder.Active = true
				DropItemHolder.BackgroundTransparency = 1.000
				DropItemHolder.Position = UDim2.new(0, 0, 0, 0)
				DropItemHolder.Size = UDim2.new(1, 0, 1, 0)
				DropItemHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
				DropItemHolder.ScrollBarThickness = 4
				DropItemHolder.BorderSizePixel = 0
				DropItemHolder.ScrollBarImageColor3 = CurrentTheme.Scrollbar
				DropItemHolder.ScrollingDirection = Enum.ScrollingDirection.Y
				DropItemHolder.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar

				DropItemHolderLayout.Name = "ItemHolderLayout"
				DropItemHolderLayout.Parent = DropItemHolder
				DropItemHolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
				DropItemHolderLayout.Padding = UDim.new(0, 1)

				local DropItemHolderPadding = Instance.new("UIPadding")
				DropItemHolderPadding.PaddingTop = UDim.new(0,3)
				DropItemHolderPadding.PaddingBottom = UDim.new(0,3)
				DropItemHolderPadding.PaddingLeft = UDim.new(0,3)
				DropItemHolderPadding.PaddingRight = UDim.new(0,3)
				DropItemHolderPadding.Parent = DropItemHolder

				local function UpdateOuterCanvasSize()
					task.wait()
					if ChannelHolder and ChannelHolderLayout and ChannelHolderPadding then
						ChannelHolder.CanvasSize = UDim2.new(0,0,0, ChannelHolderLayout.AbsoluteContentSize.Y + ChannelHolderPadding.PaddingTop.Offset + ChannelHolderPadding.PaddingBottom.Offset)
					end
				end

				DropdownFrameBtn.MouseButton1Click:Connect(function()
					DropTog = not DropTog
					local targetListHeight = 0
					if DropTog then
						local itemCountForHeight = math.min(itemcount, 3)
						targetListHeight = (itemCountForHeight * 29) + ((itemCountForHeight - 1) * DropItemHolderLayout.Padding.Offset) + DropItemHolderPadding.PaddingTop.Offset + DropItemHolderPadding.PaddingBottom.Offset + 2
						if itemcount == 0 then targetListHeight = 30 end

						DropdownListContainer.Visible = true
						DropdownListContainer.ClipsDescendants = false
						DropdownBase.ClipsDescendants = false
						DropdownBase.Size = UDim2.new(1, 0, 0, 73 + targetListHeight + DropdownBaseLayout.Padding.Offset)
						DropdownListContainer.Size = UDim2.new(1, 0, 0, targetListHeight)
						TweenService:Create(ArrowImg, TweenInfo.new(0.2), {Rotation = 180}):Play()

					else
						targetListHeight = 0
						DropdownBase.Size = UDim2.new(1, 0, 0, 73)
						DropdownListContainer.Size = UDim2.new(1, 0, 0, targetListHeight)
						DropdownListContainer.Visible = false
						DropdownListContainer.ClipsDescendants = true
						DropdownBase.ClipsDescendants = true
						TweenService:Create(ArrowImg, TweenInfo.new(0.2), {Rotation = 0}):Play()
					end
					UpdateOuterCanvasSize()
				end)


				local function CreateItemButton(itemValue)
					itemcount = itemcount + 1

					local Item = Instance.new("TextButton")
					local ItemCorner = Instance.new("UICorner")
					local ItemText = Instance.new("TextLabel")

					Item.Name = "Item_"..itemValue:gsub("%s+", "")
					Item.Parent = DropItemHolder
					Item.BackgroundColor3 = CurrentTheme.ChannelButtonHover
					Item.Size = UDim2.new(1, -6, 0, 29)
					Item.AutoButtonColor = false
					Item.Font = Enum.Font.SourceSans
					Item.Text = ""
					Item.BackgroundTransparency = 1

					ItemCorner.CornerRadius = UDim.new(0, 4)
					ItemCorner.Name = "ItemCorner"
					ItemCorner.Parent = Item

					ItemText.Name = "ItemText"
					ItemText.Parent = Item
					ItemText.BackgroundTransparency = 1.000
					ItemText.Position = UDim2.new(0, 8, 0, 0)
					ItemText.Size = UDim2.new(1, -16, 1, 0)
					ItemText.Font = Enum.Font.Gotham
					ItemText.TextColor3 = CurrentTheme.InteractiveNormal
					ItemText.TextSize = 14.000
					ItemText.TextXAlignment = Enum.TextXAlignment.Left
					ItemText.Text = itemValue

					Item.MouseEnter:Connect(function()
						ItemText.TextColor3 = CurrentTheme.InteractiveHover
						Item.BackgroundTransparency = 0.8
					end)

					Item.MouseLeave:Connect(function()
						ItemText.TextColor3 = CurrentTheme.InteractiveNormal
						Item.BackgroundTransparency = 1
					end)

					Item.MouseButton1Click:Connect(function()
						CurrentSelectedText.Text = itemValue
						pcall(callback, itemValue)
						DropTog = false
						DropdownBase.Size = UDim2.new(1, 0, 0, 73)
						DropdownListContainer.Size = UDim2.new(1, 0, 0, 0)
						DropdownListContainer.Visible = false
						DropdownListContainer.ClipsDescendants = true
						DropdownBase.ClipsDescendants = true
						TweenService:Create(ArrowImg, TweenInfo.new(0.2), {Rotation = 0}):Play()
						UpdateOuterCanvasSize()
					end)
					task.wait()
					DropItemHolder.CanvasSize = UDim2.new(0,0,0,DropItemHolderLayout.AbsoluteContentSize.Y + DropItemHolderPadding.PaddingTop.Offset + DropItemHolderPadding.PaddingBottom.Offset)
				end

				if list and #list > 0 then
					for _, v in ipairs(list) do
						CreateItemButton(v)
					end
					CurrentSelectedText.Text = list[1]
				else
					CurrentSelectedText.Text = "No Options"
				end


				UpdateOuterCanvasSize()

				function DropFunc:Clear()
					for _, v in ipairs(DropItemHolder:GetChildren()) do
						if v:IsA("TextButton") and v.Name:match("^Item_") then
							v:Destroy()
						end
					end
					itemcount = 0
					CurrentSelectedText.Text = "..."
					DropItemHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
					if DropTog then
						DropTog = false
						DropdownBase.Size = UDim2.new(1, 0, 0, 73)
						DropdownListContainer.Size = UDim2.new(1, 0, 0, 0)
						DropdownListContainer.Visible = false
						DropdownListContainer.ClipsDescendants = true
						DropdownBase.ClipsDescendants = true
						TweenService:Create(ArrowImg, TweenInfo.new(0.2), {Rotation = 0}):Play()
					end
					UpdateOuterCanvasSize()
				end

				function DropFunc:Add(textadd)
					if not textadd or textadd == "" then return end
					CreateItemButton(textadd)
					if itemcount == 1 then
						CurrentSelectedText.Text = textadd
					end
					UpdateOuterCanvasSize()
				end

				function DropFunc:Set(textValue)
					local found = false
					for _, itemBtn in ipairs(DropItemHolder:GetChildren()) do
						if itemBtn:IsA("TextButton") and itemBtn.Name:match("^Item_") then
							local itemLabel = itemBtn:FindFirstChild("ItemText")
							if itemLabel and itemLabel.Text == textValue then
								CurrentSelectedText.Text = textValue
								found = true
								break
							end
						end
					end
					if not found then
						warn("DiscordLib Dropdown: Could not find item '".. tostring(textValue) .."' to set.")
					end
				end


				return DropFunc
			end

			function ChannelContent:Colorpicker(text, presetColor, callback)
				presetColor = presetColor or Color3.new(1,1,1)
				local ColorPickerFunc = {}
				local ColorH, ColorS, ColorV = Color3.toHSV(presetColor)
				local DraggingHue = false
				local DraggingSV = false
				local UpdateConnection = nil

				local ColorpickerBase = Instance.new("Frame")
				ColorpickerBase.Name = text.."_Colorpicker"
				ColorpickerBase.Parent = ChannelHolder
				ColorpickerBase.BackgroundTransparency = 1.000
				ColorpickerBase.Size = UDim2.new(1, 0, 0, 175)

				local ColorpickerLayout = Instance.new("UIListLayout")
				ColorpickerLayout.Parent = ColorpickerBase
				ColorpickerLayout.FillDirection = Enum.FillDirection.Vertical
				ColorpickerLayout.SortOrder = Enum.SortOrder.LayoutOrder
				ColorpickerLayout.Padding = UDim.new(0, 5)

				local ColorpickerTitle = Instance.new("TextLabel")
				ColorpickerTitle.Name = "ColorpickerTitle"
				ColorpickerTitle.Parent = ColorpickerBase
				ColorpickerTitle.LayoutOrder = 1
				ColorpickerTitle.BackgroundTransparency = 1.000
				ColorpickerTitle.Size = UDim2.new(1, 0, 0, 20)
				ColorpickerTitle.Font = Enum.Font.Gotham
				ColorpickerTitle.Text = text
				ColorpickerTitle.TextColor3 = CurrentTheme.SecondaryText
				ColorpickerTitle.TextSize = 14.000
				ColorpickerTitle.TextXAlignment = Enum.TextXAlignment.Left

				local PickerContainer = Instance.new("Frame")
				PickerContainer.Name = "PickerContainer"
				PickerContainer.Parent = ColorpickerBase
				PickerContainer.LayoutOrder = 2
				PickerContainer.BackgroundTransparency = 1
				PickerContainer.Size = UDim2.new(1, 0, 0, 139)

				local ColorpickerFrameOutline = Instance.new("Frame")
				ColorpickerFrameOutline.Name = "ColorpickerFrameOutline"
				ColorpickerFrameOutline.Parent = PickerContainer
				ColorpickerFrameOutline.BackgroundColor3 = CurrentTheme.InputOutline
				ColorpickerFrameOutline.Size = UDim2.new(0, 238, 0, 139)

				local ColorpickerFrameOutlineCorner = Instance.new("UICorner")
				ColorpickerFrameOutlineCorner.CornerRadius = UDim.new(0, 3)
				ColorpickerFrameOutlineCorner.Name = "ColorpickerFrameOutlineCorner"
				ColorpickerFrameOutlineCorner.Parent = ColorpickerFrameOutline

				local ColorpickerFrame = Instance.new("Frame")
				ColorpickerFrame.Name = "ColorpickerFrame"
				ColorpickerFrame.Parent = ColorpickerFrameOutline
				ColorpickerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				ColorpickerFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
				ColorpickerFrame.Size = UDim2.new(1, -2, 1, -2)
				ColorpickerFrame.BackgroundColor3 = CurrentTheme.PopupSecondaryBackground
				ColorpickerFrame.ClipsDescendants = true

				local ColorpickerFrameCorner = Instance.new("UICorner")
				ColorpickerFrameCorner.CornerRadius = UDim.new(0, 3)
				ColorpickerFrameCorner.Name = "ColorpickerFrameCorner"
				ColorpickerFrameCorner.Parent = ColorpickerFrame

				local ColorSVBox = Instance.new("ImageLabel")
				ColorSVBox.Name = "ColorSVBox"
				ColorSVBox.Parent = ColorpickerFrame
				ColorSVBox.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
				ColorSVBox.Position = UDim2.new(0, 10, 0, 10)
				ColorSVBox.Size = UDim2.new(0, 154, 0, 118)
				ColorSVBox.ZIndex = 2
				ColorSVBox.Image = "rbxassetid://4155801252"

				local ColorCorner = Instance.new("UICorner")
				ColorCorner.CornerRadius = UDim.new(0, 3)
				ColorCorner.Name = "ColorCorner"
				ColorCorner.Parent = ColorSVBox

				local ColorSelection = Instance.new("ImageLabel")
				ColorSelection.Name = "ColorSelection"
				ColorSelection.Parent = ColorSVBox
				ColorSelection.AnchorPoint = Vector2.new(0.5, 0.5)
				ColorSelection.BackgroundTransparency = 1.000
				ColorSelection.Position = UDim2.new(ColorS, 0, 1 - ColorV, 0)
				ColorSelection.Size = UDim2.new(0, 18, 0, 18)
				ColorSelection.Image = "http://www.roblox.com/asset/?id=4805639000"
				ColorSelection.ScaleType = Enum.ScaleType.Fit
				ColorSelection.ZIndex = 3

				local HueBar = Instance.new("ImageLabel")
				HueBar.Name = "HueBar"
				HueBar.Parent = ColorpickerFrame
				HueBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				HueBar.Position = UDim2.new(0, 171, 0, 10)
				HueBar.Size = UDim2.new(0, 18, 0, 118)
				HueBar.ZIndex = 2
				HueBar.Image = ""

				local HueCorner = Instance.new("UICorner")
				HueCorner.CornerRadius = UDim.new(0, 3)
				HueCorner.Name = "HueCorner"
				HueCorner.Parent = HueBar

				local HueGradient = Instance.new("UIGradient")
				HueGradient.Color = ColorSequence.new {
					ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
					ColorSequenceKeypoint.new(1/6, Color3.fromRGB(255, 255, 0)),
					ColorSequenceKeypoint.new(2/6, Color3.fromRGB(0, 255, 0)),
					ColorSequenceKeypoint.new(3/6, Color3.fromRGB(0, 255, 255)),
					ColorSequenceKeypoint.new(4/6, Color3.fromRGB(0, 0, 255)),
					ColorSequenceKeypoint.new(5/6, Color3.fromRGB(255, 0, 255)),
					ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
				}
				HueGradient.Rotation = 90
				HueGradient.Name = "HueGradient"
				HueGradient.Parent = HueBar

				local HueSelection = Instance.new("ImageLabel")
				HueSelection.Name = "HueSelection"
				HueSelection.Parent = HueBar
				HueSelection.AnchorPoint = Vector2.new(0.5, 0.5)
				HueSelection.BackgroundTransparency = 1.000
				HueSelection.Position = UDim2.new(0.5, 0, ColorH, 0)
				HueSelection.Size = UDim2.new(0, 18, 0, 18)
				HueSelection.Image = "http://www.roblox.com/asset/?id=4805639000"
				HueSelection.ScaleType = Enum.ScaleType.Fit
				HueSelection.ZIndex = 3

				local PresetClr = Instance.new("Frame")
				PresetClr.Name = "PresetClr"
				PresetClr.Parent = ColorpickerFrame
				PresetClr.BackgroundColor3 = presetColor
				PresetClr.Position = UDim2.new(0, 199, 0, 10)
				PresetClr.Size = UDim2.new(0, 25, 0, 25)
				PresetClr.ZIndex = 2

				local PresetClrCorner = Instance.new("UICorner")
				PresetClrCorner.CornerRadius = UDim.new(0, 3)
				PresetClrCorner.Name = "PresetClrCorner"
				PresetClrCorner.Parent = PresetClr

				local function UpdateColorPicker()
					local newColor = Color3.fromHSV(ColorH, ColorS, ColorV)
					PresetClr.BackgroundColor3 = newColor
					ColorSVBox.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
					pcall(callback, newColor)
				end

				ColorSVBox.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						DraggingSV = true
						local mouseLocation = UserInputService:GetMouseLocation()
						local relativePos = mouseLocation - ColorSVBox.AbsolutePosition
						local S = math.clamp(relativePos.X / ColorSVBox.AbsoluteSize.X, 0, 1)
						local V = 1 - math.clamp(relativePos.Y / ColorSVBox.AbsoluteSize.Y, 0, 1)
						ColorS = S
						ColorV = V
						ColorSelection.Position = UDim2.new(S, 0, 1 - V, 0)
						UpdateColorPicker()
						if UpdateConnection then UpdateConnection:Disconnect() end
						UpdateConnection = RunService.RenderStepped:Connect(function()
							if not DraggingSV then if UpdateConnection then UpdateConnection:Disconnect() end return end
							local currentMouseLocation = UserInputService:GetMouseLocation()
							local currentRelativePos = currentMouseLocation - ColorSVBox.AbsolutePosition
							S = math.clamp(currentRelativePos.X / ColorSVBox.AbsoluteSize.X, 0, 1)
							V = 1 - math.clamp(currentRelativePos.Y / ColorSVBox.AbsoluteSize.Y, 0, 1)
							ColorS = S
							ColorV = V
							ColorSelection.Position = UDim2.new(S, 0, 1 - V, 0)
							UpdateColorPicker()
						end)
					end
				end)
				ColorSVBox.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						DraggingSV = false
						if UpdateConnection then UpdateConnection:Disconnect() end
					end
				end)


				HueBar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						DraggingHue = true
						local mouseLocation = UserInputService:GetMouseLocation()
						local relativeY = mouseLocation.Y - HueBar.AbsolutePosition.Y
						local H = math.clamp(relativeY / HueBar.AbsoluteSize.Y, 0, 1)
						ColorH = H
						HueSelection.Position = UDim2.new(0.5, 0, H, 0)
						UpdateColorPicker()
						if UpdateConnection then UpdateConnection:Disconnect() end
						UpdateConnection = RunService.RenderStepped:Connect(function()
							if not DraggingHue then if UpdateConnection then UpdateConnection:Disconnect() end return end
							local currentMouseLocation = UserInputService:GetMouseLocation()
							local currentRelativeY = currentMouseLocation.Y - HueBar.AbsolutePosition.Y
							H = math.clamp(currentRelativeY / HueBar.AbsoluteSize.Y, 0, 1)
							ColorH = H
							HueSelection.Position = UDim2.new(0.5, 0, H, 0)
							UpdateColorPicker()
						end)
					end
				end)
				HueBar.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						DraggingHue = false
						if UpdateConnection then UpdateConnection:Disconnect() end
					end
				end)


				function ColorPickerFunc:SetColor(newColor : Color3)
					if typeof(newColor) ~= "Color3" then return end
					ColorH, ColorS, ColorV = Color3.toHSV(newColor)
					HueSelection.Position = UDim2.new(0.5, 0, ColorH, 0)
					ColorSelection.Position = UDim2.new(ColorS, 0, 1 - ColorV, 0)
					UpdateColorPicker()
				end

				UpdateColorPicker()
				task.wait()
				ChannelHolder.CanvasSize = UDim2.new(0,0,0,ChannelHolderLayout.AbsoluteContentSize.Y + ChannelHolderPadding.PaddingTop.Offset + ChannelHolderPadding.PaddingBottom.Offset)

				return ColorPickerFunc
			end


			return ChannelContent
		end

		return ChannelHold
	end

	return ServerHold
end

return DiscordLib
