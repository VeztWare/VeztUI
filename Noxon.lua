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
		DropdownOption = Color3.fromRGB(45, 45, 45),
		DropdownOptionHover = Color3.fromRGB(55, 55, 55),
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
	toggle._button.Text = "                  " .. title
	toggle._button.TextColor3 = CONFIG.COLORS.White
	toggle._button.TextSize = 20
	toggle._button.TextWrapped = true
	toggle._button.TextXAlignment = Enum.TextXAlignment.Left
	toggle._button.LayoutOrder = toggle._layoutOrder

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 16)
	corner.Parent = toggle._button

	local typeIcon = Instance.new("ImageLabel")
	typeIcon.Name = "Type"
	typeIcon.Parent = toggle._button
	typeIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	typeIcon.BackgroundTransparency = 1.000
	typeIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	typeIcon.BorderSizePixel = 0
	typeIcon.Position = UDim2.new(0.024271844, 0, 0.159999996, 0)
	typeIcon.Size = UDim2.new(0, 34, 0, 33)
	typeIcon.Image = "rbxassetid://9728118892"

	local separator = Instance.new("Frame")
	separator.Name = "Separator"
	separator.Parent = toggle._button
	separator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	separator.BorderColor3 = Color3.fromRGB(0, 0, 0)
	separator.BorderSizePixel = 0
	separator.Position = UDim2.new(0.122000001, 0, 0, 0)
	separator.Size = UDim2.new(0, 1, 0, 50)

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

function Tab:CreateLabel(text)
	local label = setmetatable({
		_tab = self,
		_text = text,
		_button = nil,
		_layoutOrder = #self._buttons * 2
	}, {__index = Label})

	label._button = Instance.new("TextButton")
	label._button.Name = "Label"
	label._button.Parent = self._toggleHolder
	label._button.Active = false
	label._button.BackgroundColor3 = CONFIG.COLORS.Button
	label._button.BorderColor3 = Color3.fromRGB(0, 0, 0)
	label._button.BorderSizePixel = 0
	label._button.Size = UDim2.new(0, 412, 0, 50)
	label._button.AutoButtonColor = false
	label._button.Font = Enum.Font.SourceSans
	label._button.Text = "                  " .. text
	label._button.TextColor3 = CONFIG.COLORS.White
	label._button.TextSize = 20
	label._button.TextWrapped = true
	label._button.TextXAlignment = Enum.TextXAlignment.Left
	label._button.LayoutOrder = label._layoutOrder

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 16)
	corner.Parent = label._button

	local typeIcon = Instance.new("ImageLabel")
	typeIcon.Name = "Type"
	typeIcon.Parent = label._button
	typeIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	typeIcon.BackgroundTransparency = 1.000
	typeIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	typeIcon.BorderSizePixel = 0
	typeIcon.Position = UDim2.new(0.024271844, 0, 0.159999996, 0)
	typeIcon.Size = UDim2.new(0, 34, 0, 33)
	typeIcon.Image = "rbxassetid://77863683668201"

	local separator = Instance.new("Frame")
	separator.Name = "Separator"
	separator.Parent = label._button
	separator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	separator.BorderColor3 = Color3.fromRGB(0, 0, 0)
	separator.BorderSizePixel = 0
	separator.Position = UDim2.new(0.122000001, 0, 0, 0)
	separator.Size = UDim2.new(0, 1, 0, 50)

	table.insert(self._buttons, label)
	return label
end

Label = {}
Label.__index = Label

function Label:UpdateLabel(newText)
	self._text = newText
	self._button.Text = "                  " .. newText
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

function Toggle:NewTextBox(name, callback)
	if #self._options == 0 then
		self._imageLabel.Visible = true
		self:_setupDropdown()
	end

	local textbox = {
		type = "textbox",
		name = name,
		callback = callback
	}

	table.insert(self._options, textbox)
	self:_addTextBoxToDropdown(textbox)
	self:_updateCanvasSize()

	return self
end

function Toggle:NewDropdown(name, options, callback)
	if #self._options == 0 then
		self._imageLabel.Visible = true
		self:_setupDropdown()
	end

	local dropdown = {
		type = "dropdown",
		name = name,
		options = options or {},
		callback = callback,
		currentOption = nil,
		_container = nil,
		_optionsFrame = nil,
		_isOpen = false
	}

	table.insert(self._options, dropdown)
	self:_addDropdownToDropdown(dropdown)
	self:_updateCanvasSize()

	return dropdown
end

function Toggle:_setupDropdown()
	if self._dropdown then return end

	self._dropdown = Instance.new("Frame")
	self._dropdown.Name = "DropdownFrame_" .. self._button.Name
	self._dropdown.Size = UDim2.new(1, 0, 0, 0)
	self._dropdown.BackgroundColor3 = CONFIG.COLORS.Dropdown
	self._dropdown.BorderSizePixel = 0
	self._dropdown.ClipsDescendants = false
	self._dropdown.Visible = false
	self._dropdown.LayoutOrder = self._button.LayoutOrder + 1
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

function Toggle:_addTextBoxToDropdown(textboxData)
	local container = Instance.new("Frame")
	container.Name = textboxData.name .. "_Container"
	container.Size = UDim2.new(1, 0, 0, CONFIG.OPTION_HEIGHT)
	container.BackgroundTransparency = 1
	container.Parent = self._dropdown

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(0.3, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = textboxData.name
	label.TextColor3 = CONFIG.COLORS.White
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local textBox = Instance.new("TextBox")
	textBox.Name = "InputBox"
	textBox.Size = UDim2.new(0.65, 0, 0, 28)
	textBox.Position = UDim2.new(0.33, 0, 0.5, -14)
	textBox.BackgroundColor3 = CONFIG.COLORS.TextBoxBg
	textBox.BorderSizePixel = 0
	textBox.Text = ""
	textBox.PlaceholderText = "Enter text..."
	textBox.TextColor3 = CONFIG.COLORS.White
	textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
	textBox.Font = Enum.Font.Gotham
	textBox.TextSize = 14
	textBox.ClearTextOnFocus = false
	textBox.Parent = container

	local boxCorner = Instance.new("UICorner")
	boxCorner.CornerRadius = UDim.new(0, 6)
	boxCorner.Parent = textBox

	textBox.FocusLost:Connect(function(enterPressed)
		if textboxData.callback then
			textboxData.callback(textBox.Text)
		end
	end)
end

function Toggle:_addDropdownToDropdown(dropdownData)
	local container = Instance.new("Frame")
	container.Name = dropdownData.name .. "_Container"
	container.Size = UDim2.new(1, 0, 0, CONFIG.OPTION_HEIGHT)
	container.BackgroundTransparency = 1
	container.ClipsDescendants = false
	container.Parent = self._dropdown
	dropdownData._container = container

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(0.3, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = dropdownData.name
	label.TextColor3 = CONFIG.COLORS.White
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = container

	local dropdownButton = Instance.new("TextButton")
	dropdownButton.Name = "DropdownButton"
	dropdownButton.Size = UDim2.new(0.65, 0, 0, 28)
	dropdownButton.Position = UDim2.new(0.33, 0, 0.5, -14)
	dropdownButton.BackgroundColor3 = CONFIG.COLORS.TextBoxBg
	dropdownButton.BorderSizePixel = 0
	dropdownButton.Text = dropdownData.currentOption or "Select..."
	dropdownButton.TextColor3 = CONFIG.COLORS.White
	dropdownButton.Font = Enum.Font.Gotham
	dropdownButton.TextSize = 14
	dropdownButton.Parent = container

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = dropdownButton

	local arrow = Instance.new("TextLabel")
	arrow.Name = "Arrow"
	arrow.Size = UDim2.new(0, 20, 1, 0)
	arrow.Position = UDim2.new(1, -22, 0, 0)
	arrow.BackgroundTransparency = 1
	arrow.Text = "▼"
	arrow.TextColor3 = CONFIG.COLORS.White
	arrow.Font = Enum.Font.Gotham
	arrow.TextSize = 12
	arrow.Parent = dropdownButton

	local optionsFrame = Instance.new("ScrollingFrame")
	optionsFrame.Name = "OptionsFrame"
	optionsFrame.Size = UDim2.new(0.65, 0, 0, 0)
	optionsFrame.Position = UDim2.new(0.33, 0, 0, 30)
	optionsFrame.BackgroundColor3 = CONFIG.COLORS.Dropdown
	optionsFrame.BorderSizePixel = 0
	optionsFrame.Visible = false
	optionsFrame.ClipsDescendants = true
	optionsFrame.ScrollBarThickness = 4
	optionsFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	optionsFrame.ZIndex = 100
	optionsFrame.Parent = container

	local optCorner = Instance.new("UICorner")
	optCorner.CornerRadius = UDim.new(0, 6)
	optCorner.Parent = optionsFrame

	local optLayout = Instance.new("UIListLayout")
	optLayout.SortOrder = Enum.SortOrder.LayoutOrder
	optLayout.Padding = UDim.new(0, 2)
	optLayout.Parent = optionsFrame

	optLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		local contentHeight = optLayout.AbsoluteContentSize.Y
		optionsFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
	end)

	local function refreshOptions()
		for _, child in ipairs(optionsFrame:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end

		for i, option in ipairs(dropdownData.options) do
			local optionButton = Instance.new("TextButton")
			optionButton.Name = "Option_" .. i
			optionButton.Size = UDim2.new(1, 0, 0, 25)
			optionButton.BackgroundColor3 = CONFIG.COLORS.DropdownOption
			optionButton.BorderSizePixel = 0
			optionButton.Text = tostring(option)
			optionButton.TextColor3 = CONFIG.COLORS.White
			optionButton.Font = Enum.Font.Gotham
			optionButton.TextSize = 13
			optionButton.LayoutOrder = i
			optionButton.ZIndex = 101
			optionButton.Parent = optionsFrame

			local optCorner = Instance.new("UICorner")
			optCorner.CornerRadius = UDim.new(0, 6)
			optCorner.Parent = optionButton

			optionButton.MouseEnter:Connect(function()
				optionButton.BackgroundColor3 = CONFIG.COLORS.DropdownOptionHover
			end)

			optionButton.MouseLeave:Connect(function()
				optionButton.BackgroundColor3 = CONFIG.COLORS.DropdownOption
			end)

			optionButton.Activated:Connect(function()
				dropdownData.currentOption = option
				dropdownButton.Text = tostring(option)

				if dropdownData.callback then
					dropdownData.callback(option)
				end

				dropdownData._isOpen = false
				local tween = TweenService:Create(optionsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
					Size = UDim2.new(0.65, 0, 0, 0)
				})
				tween:Play()
				tween.Completed:Connect(function()
					optionsFrame.Visible = false
				end)

				local arrowTween = TweenService:Create(arrow, TweenInfo.new(0.2), {
					Rotation = 0
				})
				arrowTween:Play()
			end)
		end
	end

	refreshOptions()

	dropdownButton.Activated:Connect(function()
		if dropdownData._isOpen then
			dropdownData._isOpen = false
			local tween = TweenService:Create(optionsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
				Size = UDim2.new(0.65, 0, 0, 0)
			})
			tween:Play()
			tween.Completed:Connect(function()
				optionsFrame.Visible = false
			end)

			local arrowTween = TweenService:Create(arrow, TweenInfo.new(0.2), {
				Rotation = 0
			})
			arrowTween:Play()
		else
			dropdownData._isOpen = true
			optionsFrame.Visible = true

			local window = self._tab._window._mainFrame
			local containerAbsPos = container.AbsolutePosition
			local containerAbsSize = container.AbsoluteSize
			local windowAbsPos = window.AbsolutePosition
			local windowAbsSize = window.AbsoluteSize

			local containerBottom = containerAbsPos.Y + containerAbsSize.Y
			local windowBottom = windowAbsPos.Y + windowAbsSize.Y

			local containerTop = containerAbsPos.Y
			local windowTop = windowAbsPos.Y

			local availableSpaceBelow = windowBottom - containerBottom - 10
			local availableSpaceAbove = containerTop - windowTop - 10

			local maxPreferredHeight = math.min(#dropdownData.options * 27, 150)
			local openDownwards = true
			local actualMaxHeight = maxPreferredHeight

			if availableSpaceBelow < maxPreferredHeight and availableSpaceAbove > maxPreferredHeight then
				openDownwards = false
				optionsFrame.Position = UDim2.new(0.33, 0, 0, -actualMaxHeight - 2)
			elseif availableSpaceBelow < maxPreferredHeight then
				openDownwards = true
				actualMaxHeight = math.min(availableSpaceBelow, maxPreferredHeight)
				optionsFrame.Position = UDim2.new(0.33, 0, 0, 30)
			else
				openDownwards = true
				optionsFrame.Position = UDim2.new(0.33, 0, 0, 30)
			end

			if actualMaxHeight < 25 then
				actualMaxHeight = 25
			end

			local tween = TweenService:Create(optionsFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
				Size = UDim2.new(0.65, 0, 0, actualMaxHeight)
			})
			tween:Play()

			local arrowTween = TweenService:Create(arrow, TweenInfo.new(0.2), {
				Rotation = openDownwards and 180 or 0
			})
			arrowTween:Play()
		end
	end)

	dropdownData.Refresh = function(self, newOptions)
		self.options = newOptions or {}
		self.currentOption = nil
		dropdownButton.Text = "Select..."
		refreshOptions()
	end
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
	window._mainFrame.ClipsDescendants = false
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

	window._closeButton = Instance.new("ImageButton")
	window._closeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	window._closeButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	window._closeButton.BorderSizePixel = 0
	window._closeButton.Position = UDim2.new(0.933333337, 0, 0, 0)
	window._closeButton.Size = UDim2.new(0, 24, 0, 23)
	window._closeButton.Image = "rbxassetid://132261474823036"
	window._closeButton.Parent = window._topBar

	window._closeCorner = Instance.new("UICorner")
	window._closeCorner.CornerRadius = UDim.new(0, 16)
	window._closeCorner.Parent = window._closeButton

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

	window._closeButton.Activated:Connect(function()
		window._screenGui:Destroy()
	end)

	local dragging = false
	local dragInput
	local dragStart
	local startPos
	local dragInputObject = nil

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
		if (input.UserInputType == Enum.UserInputType.MouseButton1 
			or input.UserInputType == Enum.UserInputType.Touch) 
			and not dragging then 

			dragging = true
			dragStart = input.Position
			startPos = window._mainFrame.Position
			dragInputObject = input

			if input.UserInputType == Enum.UserInputType.Touch then
				input:GetPropertyChangedSignal("UserInputState"):Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						dragInputObject = nil
					end
				end)
			else
				local connection
				connection = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
						dragInputObject = nil
						connection:Disconnect()
					end
				end)
			end
		end
	end)

	window._topBar.InputChanged:Connect(function(input)
		if dragging and input == dragInputObject then
			dragInput = input
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging then
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				update(input)
			elseif input == dragInputObject then
				update(input)
			end
		end
	end)

	window._topBar.Active = true

	return window
end

return Library
