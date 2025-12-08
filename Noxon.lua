local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Library = {}

local CONFIG = {
	DROPDOWN_PADDING = 5,
	OPTION_HEIGHT = 40,
	ANIMATION_TIME = 0.3,

	COLORS = {
		MainBg = Color3.fromRGB(50, 50, 50),
		TopBar = Color3.fromRGB(62, 62, 62),
		Button = Color3.fromRGB(62, 62, 62),
		Dropdown = Color3.fromRGB(35, 35, 35),
		ToggleOn = Color3.fromRGB(0, 200, 0),
		ToggleOff = Color3.fromRGB(100, 100, 100),
		SliderBg = Color3.fromRGB(60, 60, 60),
		SliderFill = Color3.fromRGB(0, 150, 255),
		TextBoxBg = Color3.fromRGB(40, 40, 40),
		White = Color3.fromRGB(255, 255, 255)
	}
}

local Window = {}
Window.__index = Window

function Window:CreateTab(name)
	local tab = setmetatable({
		_name = name,
		_window = self,
		_toggleHolder = nil,
		_tabButton = nil,
		_buttons = {},
		_layoutOrder = #self._tabs * 2
	}, {__index = Tab})

	tab._tabButton = Instance.new("TextButton")
	tab._tabButton.Name = name .. "Tab"
	tab._tabButton.Parent = self._tabHolder
	tab._tabButton.BackgroundColor3 = CONFIG.COLORS.Button
	tab._tabButton.BorderSizePixel = 0
	tab._tabButton.Size = UDim2.new(0, 89, 0, 35)
	tab._tabButton.Font = Enum.Font.SourceSans
	tab._tabButton.Text = name
	tab._tabButton.TextColor3 = CONFIG.COLORS.White
	tab._tabButton.TextSize = 20
	tab._tabButton.TextWrapped = true
	tab._tabButton.LayoutOrder = tab._layoutOrder

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = tab._tabButton

	tab._toggleHolder = Instance.new("ScrollingFrame")
	tab._toggleHolder.Name = name .. "_TogglesHolder"
	tab._toggleHolder.Parent = self._mainFrame
	tab._toggleHolder.Active = true
	tab._toggleHolder.BackgroundTransparency = 1
	tab._toggleHolder.BorderSizePixel = 0
	tab._toggleHolder.Position = UDim2.new(0.219819844, 0, 0.0906432718, 0)
	tab._toggleHolder.Size = UDim2.new(0, 421, 0, 300)
	tab._toggleHolder.Visible = #self._tabs == 0
	tab._toggleHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
	tab._toggleHolder.ScrollBarThickness = 8

	local listLayout = Instance.new("UIListLayout")
	listLayout.Parent = tab._toggleHolder
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 5)

	tab._tabButton.MouseButton1Click:Connect(function()
		for _, t in ipairs(self._tabs) do
			t._toggleHolder.Visible = false
		end
		tab._toggleHolder.Visible = true
	end)

	table.insert(self._tabs, tab)
	return tab
end

Tab = {}
Tab.__index = Tab

function Tab:CreateToggle(title, callback)
	local toggle = setmetatable({
		_tab = self,
		_title = title,
		_callback = callback,
		_state = false,
		_button = nil,
		_imageLabel = nil,
		_dropdown = nil,
		_dropdownOpen = false,
		_options = {},
		_layoutOrder = #self._buttons * 2
	}, {__index = Toggle})

	toggle._button = Instance.new("TextButton")
	toggle._button.Name = title:gsub("%s+", "")
	toggle._button.Parent = self._toggleHolder
	toggle._button.BackgroundColor3 = CONFIG.COLORS.Button
	toggle._button.BorderSizePixel = 0
	toggle._button.Size = UDim2.new(0, 412, 0, 50)
	toggle._button.Font = Enum.Font.SourceSans
	toggle._button.Text = "      " .. title
	toggle._button.TextColor3 = CONFIG.COLORS.White
	toggle._button.TextSize = 20
	toggle._button.TextWrapped = true
	toggle._button.TextXAlignment = Enum.TextXAlignment.Left
	toggle._button.LayoutOrder = toggle._layoutOrder

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 16)
	corner.Parent = toggle._button

	toggle._imageLabel = Instance.new("ImageButton")
	toggle._imageLabel.Parent = toggle._button
	toggle._imageLabel.BackgroundTransparency = 1
	toggle._imageLabel.Position = UDim2.new(0.898058236, 0, 0.0399999991, 0)
	toggle._imageLabel.Rotation = 90
	toggle._imageLabel.Size = UDim2.new(0, 42, 0, 46)
	toggle._imageLabel.Image = "rbxassetid://127075876244307"
	toggle._imageLabel.Visible = false

	toggle._button.Activated:Connect(function()
		toggle._state = not toggle._state
		if callback then
			callback(toggle._state)
		end
	end)

	table.insert(self._buttons, toggle)
	return toggle
end

Toggle = {}
Toggle.__index = Toggle

function Toggle:NewKnob(name, callback)
	if #self._options == 0 then
		self._imageLabel.Visible = true
		self:_setupDropdown()
	end

	local knob = {
		type = "knob",
		name = name,
		callback = callback,
		state = false
	}

	table.insert(self._options, knob)
	self:_addKnobToDropdown(knob)
	self:_updateCanvasSize()

	return self
end

function Toggle:NewSlider(name, min, max, default, callback)
	if #self._options == 0 then
		self._imageLabel.Visible = true
		self:_setupDropdown()
	end

	local slider = {
		type = "slider",
		name = name,
		min = min,
		max = max,
		default = default,
		callback = callback
	}

	table.insert(self._options, slider)
	self:_addSliderToDropdown(slider)
	self:_updateCanvasSize()

	return self
end

function Toggle:_setupDropdown()
	if self._dropdown then return end

	self._dropdown = Instance.new("Frame")
	self._dropdown.Name = "DropdownFrame_" .. self._button.Name
	self._dropdown.Size = UDim2.new(1, 0, 0, 0)
	self._dropdown.BackgroundColor3 = CONFIG.COLORS.Dropdown
	self._dropdown.BorderSizePixel = 0
	self._dropdown.ClipsDescendants = true
	self._dropdown.Visible = false
	self._dropdown.LayoutOrder = self._layoutOrder + 1
	self._dropdown.Parent = self._tab._toggleHolder

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = self._dropdown

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 5)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = self._dropdown

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 5)
	padding.PaddingBottom = UDim.new(0, 5)
	padding.PaddingLeft = UDim.new(0, 8)
	padding.PaddingRight = UDim.new(0, 8)
	padding.Parent = self._dropdown

    self._imageLabel.Activated:Connect(function()
	    self:_toggleDropdown()
    end)
end

function Toggle:_toggleDropdown()
	if self._dropdownOpen then
		local tween = TweenService:Create(self._dropdown, TweenInfo.new(CONFIG.ANIMATION_TIME, Enum.EasingStyle.Quad), {
			Size = UDim2.new(1, 0, 0, 0)
		})
		tween:Play()

		local arrowTween = TweenService:Create(self._imageLabel, TweenInfo.new(CONFIG.ANIMATION_TIME), {
			Rotation = 90
		})
		arrowTween:Play()

		tween.Completed:Connect(function()
			self._dropdown.Visible = false
			self:_updateCanvasSize()
		end)
		self._dropdownOpen = false
	else
		self._dropdown.Visible = true
		local targetHeight = #self._options * (CONFIG.OPTION_HEIGHT + 5) + 10
		local tween = TweenService:Create(self._dropdown, TweenInfo.new(CONFIG.ANIMATION_TIME, Enum.EasingStyle.Quad), {
			Size = UDim2.new(1, 0, 0, targetHeight)
		})
		tween:Play()

		local arrowTween = TweenService:Create(self._imageLabel, TweenInfo.new(CONFIG.ANIMATION_TIME), {
			Rotation = 180
		})
		arrowTween:Play()

		tween.Completed:Connect(function()
			self:_updateCanvasSize()
		end)
		self._dropdownOpen = true
	end
end

function Toggle:_addKnobToDropdown(knobData)
	local container = Instance.new("Frame")
	container.Name = knobData.name .. "_Container"
	container.Size = UDim2.new(1, 0, 0, CONFIG.OPTION_HEIGHT)
	container.BackgroundTransparency = 1
	container.Parent = self._dropdown

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(0.6, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = knobData.name
	label.TextColor3 = CONFIG.COLORS.White
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.Size = UDim2.new(0, 50, 0, 25)
	toggleButton.Position = UDim2.new(1, -50, 0.5, -12.5)
	toggleButton.BackgroundColor3 = CONFIG.COLORS.ToggleOff
	toggleButton.Text = ""
	toggleButton.Parent = container

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(1, 0)
	toggleCorner.Parent = toggleButton

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Size = UDim2.new(0, 20, 0, 20)
	knob.Position = UDim2.new(0, 2, 0.5, -10)
	knob.BackgroundColor3 = CONFIG.COLORS.White
	knob.Parent = toggleButton

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	toggleButton.Activated:Connect(function()
		knobData.state = not knobData.state

		local bgTween = TweenService:Create(toggleButton, TweenInfo.new(0.2), {
			BackgroundColor3 = knobData.state and CONFIG.COLORS.ToggleOn or CONFIG.COLORS.ToggleOff
		})

		local knobTween = TweenService:Create(knob, TweenInfo.new(0.2), {
			Position = knobData.state and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
		})

		bgTween:Play()
		knobTween:Play()

		if knobData.callback then
			knobData.callback(knobData.state)
		end
	end)
end

function Toggle:_addSliderToDropdown(sliderData)
	local container = Instance.new("Frame")
	container.Name = sliderData.name .. "_Container"
	container.Size = UDim2.new(1, 0, 0, CONFIG.OPTION_HEIGHT)
	container.BackgroundTransparency = 1
	container.Parent = self._dropdown

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(0.3, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = sliderData.name
	label.TextColor3 = CONFIG.COLORS.White
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local sliderBg = Instance.new("Frame")
	sliderBg.Name = "SliderBackground"
	sliderBg.Size = UDim2.new(0.45, 0, 0, 8)
	sliderBg.Position = UDim2.new(0.32, 0, 0.5, -4)
	sliderBg.BackgroundColor3 = CONFIG.COLORS.SliderBg
	sliderBg.BorderSizePixel = 0
	sliderBg.Parent = container

	local sliderCorner = Instance.new("UICorner")
	sliderCorner.CornerRadius = UDim.new(1, 0)
	sliderCorner.Parent = sliderBg

	local sliderFill = Instance.new("Frame")
	sliderFill.Name = "Fill"
	sliderFill.Size = UDim2.new((sliderData.default - sliderData.min) / (sliderData.max - sliderData.min), 0, 1, 0)
	sliderFill.BackgroundColor3 = CONFIG.COLORS.SliderFill
	sliderFill.BorderSizePixel = 0
	sliderFill.Parent = sliderBg

	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = sliderFill

	local textBox = Instance.new("TextBox")
	textBox.Name = "ValueBox"
	textBox.Size = UDim2.new(0.18, 0, 0, 25)
	textBox.Position = UDim2.new(0.8, 0, 0.5, -12.5)
	textBox.BackgroundColor3 = CONFIG.COLORS.TextBoxBg
	textBox.BorderSizePixel = 0
	textBox.Text = tostring(sliderData.default)
	textBox.TextColor3 = CONFIG.COLORS.White
	textBox.Font = Enum.Font.Gotham
	textBox.TextSize = 14
	textBox.Parent = container

	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 4)
	boxCorner.Parent = textBox

	local currentValue = sliderData.default
	local dragging = false

	local function updateSlider(value)
		value = math.clamp(value, sliderData.min, sliderData.max)
		currentValue = math.round(value)
		textBox.Text = tostring(currentValue)
		sliderFill.Size = UDim2.new((currentValue - sliderData.min) / (sliderData.max - sliderData.min), 0, 1, 0)

		if sliderData.callback then
			sliderData.callback(currentValue)
		end
	end

	local function updateFromInput(input)
		local relativeX = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
		local value = sliderData.min + (sliderData.max - sliderData.min) * relativeX
		updateSlider(value)
	end

	sliderBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			updateFromInput(input)
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement 
			or input.UserInputType == Enum.UserInputType.Touch) then
			updateFromInput(input)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	textBox.FocusLost:Connect(function()
		local value = tonumber(textBox.Text)
		if value then
			updateSlider(value)
		else
			textBox.Text = tostring(currentValue)
		end
	end)
end

function Toggle:_updateCanvasSize()
	task.wait(0.05)
	if self._tab._toggleHolder:FindFirstChildOfClass("UIListLayout") then
		self._tab._toggleHolder.CanvasSize = UDim2.new(0, 0, 0, self._tab._toggleHolder.UIListLayout.AbsoluteContentSize.Y)
	end
end

function Library.CreateWindow(title)
	local player = game.Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local window = setmetatable({
		_title = title,
		_screenGui = nil,
		_mainFrame = nil,
		_topBar = nil,
		_tabHolder = nil,
		_tabs = {}
	}, {__index = Window})

	window._screenGui = Instance.new("ScreenGui")
	window._screenGui.Name = "HouseCloner"
	window._screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	window._screenGui.Parent = playerGui

	window._mainFrame = Instance.new("Frame")
	window._mainFrame.Name = "MainFrame"
	window._mainFrame.Parent = window._screenGui
	window._mainFrame.BackgroundColor3 = CONFIG.COLORS.MainBg
	window._mainFrame.BorderSizePixel = 0
	window._mainFrame.Position = UDim2.new(0.0835517645, 0, 0.240012914, -10)
	window._mainFrame.Size = UDim2.new(0, 555, 0, 342)

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 16)
	mainCorner.Parent = window._mainFrame

	window._topBar = Instance.new("Frame")
	window._topBar.Name = "TopBar"
	window._topBar.Parent = window._mainFrame
	window._topBar.BackgroundColor3 = CONFIG.COLORS.TopBar
	window._topBar.BorderSizePixel = 0
	window._topBar.Size = UDim2.new(0, 555, 0, 23)

	local topCorner = Instance.new("UICorner")
	topCorner.CornerRadius = UDim.new(0, 16)
	topCorner.Parent = window._topBar

	local topLabel = Instance.new("TextLabel")
	topLabel.Name = "TopBarLabel"
	topLabel.Parent = window._topBar
	topLabel.BackgroundTransparency = 1
	topLabel.Size = UDim2.new(1, 0, 1, 0)
	topLabel.Font = Enum.Font.SourceSans
	topLabel.Text = title
	topLabel.TextColor3 = CONFIG.COLORS.White
	topLabel.TextScaled = true
	topLabel.TextSize = 14
	topLabel.TextWrapped = true

	window._tabHolder = Instance.new("ScrollingFrame")
	window._tabHolder.Name = "TabHolder"
	window._tabHolder.Parent = window._mainFrame
	window._tabHolder.Active = true
	window._tabHolder.BackgroundTransparency = 1
	window._tabHolder.BorderSizePixel = 0
	window._tabHolder.Position = UDim2.new(0.0162162166, 0, 0.0906432718, 0)
	window._tabHolder.Size = UDim2.new(0, 91, 0, 301)
	window._tabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
	window._tabHolder.ScrollBarThickness = 8

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.Parent = window._tabHolder
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Padding = UDim.new(0, 5)

	local dragging = false
	local dragInput
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		window._mainFrame.Position = UDim2.new(
			startPos.X.Scale, 
			startPos.X.Offset + delta.X, 
			startPos.Y.Scale, 
			startPos.Y.Offset + delta.Y
		)
	end

	window._topBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true
			dragStart = input.Position
			startPos = window._mainFrame.Position

			local connection
			connection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					connection:Disconnect()
				end
			end)
		end
	end)

	window._topBar.InputChanged:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseMovement 
			or input.UserInputType == Enum.UserInputType.Touch) 
			and dragging then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and (input == dragInput 
			or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)

	return window
end

return Library
