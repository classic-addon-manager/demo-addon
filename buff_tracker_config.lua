local configFrame = nil

function CreateBuffTrackerConfigWindow()
	local frame = api.Interface:CreateWindow("buffTrackerConfig", "Better ArcheAge Settings")
	frame:Show(false)
	frame:AddAnchor("TOPLEFT", "UIParent", 100, 100)

	-- Load settings from settings.txt
	local settingsData = api.File:Read("better-archeage/settings.txt")
	local enableLargeHPMP = true
	local enableGuildName = true
	local enableGearScore = true
	local enableRangeFinder = true
	local enableSpeedometer = true
	local enableBuffTracker = true
	
	-- Handle both old format (array) and new format (table with settings)
	if settingsData then
		if settingsData.buffTrackers then
			-- New format with settings
			-- Use explicit nil checks to preserve false values
			if settingsData.enableLargeHPMP ~= nil then
				enableLargeHPMP = settingsData.enableLargeHPMP
			end
			if settingsData.enableGuildName ~= nil then
				enableGuildName = settingsData.enableGuildName
			end
			if settingsData.enableGearScore ~= nil then
				enableGearScore = settingsData.enableGearScore
			end
			if settingsData.useRangeFinder ~= nil then
				enableRangeFinder = settingsData.useRangeFinder
			end
			if settingsData.useSpeedometer ~= nil then
				enableSpeedometer = settingsData.useSpeedometer
			end
			if settingsData.useBufftracker ~= nil then
				enableBuffTracker = settingsData.useBufftracker
			end
		elseif type(settingsData) == "table" and #settingsData > 0 and settingsData[1].nameFilter then
			-- Old format (just array), keep defaults
		end
	end

	-- Create checkboxes for general settings
	local checkboxY = 50
	local checkboxSpacing = 25

	-- Helper function to create checkbutton with background
	local function CreateCheckButtonWithLabel(parent, id, text, yPos)
		local checkbox = api.Interface:CreateWidget("checkbutton", id, parent)
		checkbox:SetExtent(18, 17)
		checkbox:AddAnchor("TOPLEFT", parent, 10, yPos)
		
		-- Create background drawables for checkbutton states
		local bg1 = checkbox:CreateImageDrawable("ui/button/check_button.dds", "background")
		bg1:SetExtent(18, 17)
		bg1:AddAnchor("CENTER", checkbox, 0, 0)
		bg1:SetCoords(0, 0, 18, 17)
		checkbox:SetNormalBackground(bg1)
		
		local bg2 = checkbox:CreateImageDrawable("ui/button/check_button.dds", "background")
		bg2:SetExtent(18, 17)
		bg2:AddAnchor("CENTER", checkbox, 0, 0)
		bg2:SetCoords(0, 0, 18, 17)
		checkbox:SetHighlightBackground(bg2)
		
		local bg3 = checkbox:CreateImageDrawable("ui/button/check_button.dds", "background")
		bg3:SetExtent(18, 17)
		bg3:AddAnchor("CENTER", checkbox, 0, 0)
		bg3:SetCoords(0, 0, 18, 17)
		checkbox:SetPushedBackground(bg3)
		
		local bg4 = checkbox:CreateImageDrawable("ui/button/check_button.dds", "background")
		bg4:SetExtent(18, 17)
		bg4:AddAnchor("CENTER", checkbox, 0, 0)
		bg4:SetCoords(0, 17, 18, 17)
		checkbox:SetDisabledBackground(bg4)
		
		local bg5 = checkbox:CreateImageDrawable("ui/button/check_button.dds", "background")
		bg5:SetExtent(18, 17)
		bg5:AddAnchor("CENTER", checkbox, 0, 0)
		bg5:SetCoords(18, 0, 18, 17)
		checkbox:SetCheckedBackground(bg5)
		
		local bg6 = checkbox:CreateImageDrawable("ui/button/check_button.dds", "background")
		bg6:SetExtent(18, 17)
		bg6:AddAnchor("CENTER", checkbox, 0, 0)
		bg6:SetCoords(18, 17, 18, 17)
		checkbox:SetDisabledCheckedBackground(bg6)
		
		local label = parent:CreateChildWidget("label", id .. "Label", 0, true)
		label:SetText(text)
		label:AddAnchor("LEFT", checkbox, "RIGHT", 0, 0)
		label.style:SetFontSize(12)
        label.style:SetColor(0, 0, 0, 1)
        label.style:SetAlign(ALIGN.LEFT)
		
		return checkbox, label
	end

	local largeHPMPCheckbox, largeHPMPLabel = CreateCheckButtonWithLabel(frame, "largeHPMPCheckbox", "Enable large HP /MP on health bars", checkboxY)
	largeHPMPCheckbox:SetChecked(enableLargeHPMP)

	local guildNameCheckbox, guildNameLabel = CreateCheckButtonWithLabel(frame, "guildNameCheckbox", "Enable Guild Name on health bars", checkboxY + checkboxSpacing)
	guildNameCheckbox:SetChecked(enableGuildName)

	local gearScoreCheckbox, gearScoreLabel = CreateCheckButtonWithLabel(frame, "gearScoreCheckbox", "Enable GearScore on Health Bars", checkboxY + checkboxSpacing * 2)
	gearScoreCheckbox:SetChecked(enableGearScore)

	local rangeFinderCheckbox, rangeFinderLabel = CreateCheckButtonWithLabel(frame, "rangeFinderCheckbox", "Enable Range Finder", checkboxY + checkboxSpacing * 3)
	rangeFinderCheckbox:SetChecked(enableRangeFinder)

	local speedometerCheckbox, speedometerLabel = CreateCheckButtonWithLabel(frame, "speedometerCheckbox", "Enable speedoMeter", checkboxY + checkboxSpacing * 4)
	speedometerCheckbox:SetChecked(enableSpeedometer)

	local buffTrackerCheckbox, buffTrackerLabel = CreateCheckButtonWithLabel(frame, "buffTrackerCheckbox", "Use Buff Tracker", checkboxY + checkboxSpacing * 5)
	buffTrackerCheckbox:SetChecked(enableBuffTracker)

	local list = W_CTRL.CreatePageScrollListCtrl("adList", frame)
	list:Show(true)
	list:AddAnchor("TOPLEFT", frame, 4, checkboxY + checkboxSpacing * 6 + 10)
	list:AddAnchor("BOTTOMRIGHT", frame, 0, -45)

    local NameSetFunc = function(subItem, data, setValue)
		if setValue then
			subItem.textbox:SetText(data["nameFilter"])
		else
			subItem.textbox:SetText("")
		end
	end

    local TypeSetFunc = function(subItem, data, setValue)
        if setValue then
            local typeMap = {
                default = 1,
                stack = 2, 
                stack_time = 3,
                alert = 4
            }
            subItem.combobox:Select(typeMap[data["type"]] or 1)
        else
            subItem.combobox:Select(1)
        end
    end

    local TargetSetFunc = function(subItem, data, setValue)
        if setValue then
            local targetMap = {
                player = 1,
                target = 2
            }
            subItem.combobox:Select(targetMap[data["trg"]] or 1)
        else
            subItem.combobox:Select(1)
        end
    end

    local ExtraDataSetFunc = function(subItem, data, setValue)
        if setValue then
            if data["type"] == "stack" then
                subItem.textbox:SetText(tostring(data["maxStack"] or ""))
            elseif data["type"] == "stack_time" then
                subItem.textbox:SetText(tostring(data["maxStack"] or ""))
            elseif data["type"] == "alert" then
                subItem.textbox:SetText(tostring(data["alert"] or ""))
            end
        else
            subItem.textbox:SetText("")
        end
    end

    local NameColumnLayoutSetFunc = function(frame, rowIndex, colIndex, subItem)
        local nameLabel = W_CTRL.CreateEdit("inputName", subItem)
        --nameLabel:Show(true)
        nameLabel:SetExtent(120, 25)
        nameLabel:AddAnchor("LEFT", subItem, 25, 0)
        --nameLabel.style:SetAlign(ALIGN_CENTER)
        --ApplyTextColor(nameLabel, FONT_COLOR.DEFAULT)

        subItem.textbox = nameLabel
        
        
    end

    local TypeColumnLayoutSetFunc = function(frame, rowIndex, colIndex, subItem)
        local sortCombobox = W_CTRL.CreateComboBox(subItem)
        sortCombobox:SetWidth(105)
        sortCombobox:AddAnchor("BOTTOMRIGHT", subItem, "TOPRIGHT", 0, 29)
        sortCombobox.dropdownItem = {
          "default",
          "stack",
          "stack_time",
          "alert"
        }
        sortCombobox:Select(1)

        subItem.combobox = sortCombobox
    end

    local TargetColumnLayoutSetFunc = function(frame, rowIndex, colIndex, subItem)
        local targetCombobox = W_CTRL.CreateComboBox(subItem)
        targetCombobox:SetWidth(105)
        targetCombobox:AddAnchor("BOTTOMRIGHT", subItem, "TOPRIGHT", -10, 29)
        targetCombobox.dropdownItem = {
            "player",
            "target"
        }
        targetCombobox:Select(1)

        subItem.combobox = targetCombobox
    end

    local ExtraDataColumnLayoutSetFunc = function(frame, rowIndex, colIndex, subItem)
        local extraDataTextbox = W_CTRL.CreateEdit("inputExtraData", subItem)
        extraDataTextbox:SetExtent(140, 25)
        extraDataTextbox:AddAnchor("CENTER", subItem, 3, -1)

        subItem.textbox = extraDataTextbox

        -- Add delete button
        local deleteButton = subItem:CreateChildWidget("button", "deleteButton", 0, true)
        api.Interface:ApplyButtonSkin(deleteButton, BUTTON_BASIC.MINUS)
        deleteButton:SetExtent(20, 20)
        deleteButton:AddAnchor("RIGHT", subItem, 40, 0)
        deleteButton.style:SetAlign(ALIGN.CENTER)
        
        function deleteButton:OnClick()
            -- First, save current UI state to get the latest data
            local configData = {}
            
            for checkRowIndex = 1, 10 do
                if list.listCtrl.items[checkRowIndex] then
                    local targetSubItem = list.listCtrl.items[checkRowIndex].subItems[1]
                    local nameSubItem = list.listCtrl.items[checkRowIndex].subItems[2]
                    local typeSubItem = list.listCtrl.items[checkRowIndex].subItems[3]
                    local extraDataSubItem = list.listCtrl.items[checkRowIndex].subItems[4]
                    
                    local nameValue = ""
                    if nameSubItem and nameSubItem.textbox then
                        nameValue = nameSubItem.textbox:GetText() or ""
                        nameValue = nameValue:gsub("^%s*(.-)%s*$", "%1")
                    end
                    
                    if nameValue ~= "" then
                        local rowData = list:GetDataByViewIndex(checkRowIndex, 1)
                        local entry = {}
                        
                        if rowData then
                            for k, v in pairs(rowData) do
                                entry[k] = v
                            end
                        end
                        
                        local targetValue = "player"
                        if targetSubItem and targetSubItem.combobox then
                            local selectedIndex = targetSubItem.combobox:GetSelectedIndex()
                            local targetOptions = {"player", "target"}
                            targetValue = targetOptions[selectedIndex] or "player"
                        end
                        
                        local typeValue = "default"
                        if typeSubItem and typeSubItem.combobox then
                            local selectedIndex = typeSubItem.combobox:GetSelectedIndex()
                            local typeOptions = {"default", "stack", "stack_time", "alert"}
                            typeValue = typeOptions[selectedIndex] or "default"
                        end
                        
                        local extraDataValue = ""
                        if extraDataSubItem and extraDataSubItem.textbox then
                            extraDataValue = extraDataSubItem.textbox:GetText() or ""
                            extraDataValue = extraDataValue:gsub("^%s*(.-)%s*$", "%1")
                        end
                        
                        entry.nameFilter = nameValue
                        entry.trg = targetValue
                        entry.type = typeValue
                        
                        if typeValue == "stack" or typeValue == "stack_time" then
                            local maxStack = tonumber(extraDataValue)
                            if maxStack then
                                entry.maxStack = maxStack
                            else
                                entry.maxStack = nil
                            end
                            entry.alert = nil
                        elseif typeValue == "alert" then
                            entry.alert = extraDataValue
                            entry.maxStack = nil
                        else
                            entry.maxStack = nil
                            entry.alert = nil
                        end
                        
                        table.insert(configData, entry)
                    end
                end
            end
            
            -- Remove the entry at rowIndex (skip it when building the list)
            local finalConfig = {}
            for i = 1, #configData do
                if i ~= rowIndex then
                    table.insert(finalConfig, configData[i])
                end
            end
            
            -- Save to file
            SaveSettingsToFile(finalConfig)
            
            -- Clear and reload the list
            list:DeleteAllDatas()
            frame:UpdateTrackerList()
            
            api.Log:Info("Entry removed!")
        end
        deleteButton:SetHandler("OnClick", deleteButton.OnClick)
    end

    list:InsertColumn("Target", 140, 0, TargetSetFunc, nil, nil, TargetColumnLayoutSetFunc)
    list:InsertColumn("Name", 140, 1, NameSetFunc, nil, nil, NameColumnLayoutSetFunc)
    list:InsertColumn("Type", 140, 2, TypeSetFunc, nil, nil, TypeColumnLayoutSetFunc)
    list:InsertColumn("ExtraData", 140, 3, ExtraDataSetFunc, nil, nil, ExtraDataColumnLayoutSetFunc)

    list:InsertRows(10, false)

    list.listCtrl:DisuseSorting()

    frame.list = list

    local function SaveSettingsToFile(configData)
        -- Load existing settings to preserve values not in the UI
        local existingSettings = api.File:Read("better-archeage/settings.txt")
        
        local settingsToSave = {
            buffTrackers = configData,
            enableLargeHPMP = largeHPMPCheckbox:GetChecked(),
            enableGuildName = guildNameCheckbox:GetChecked(),
            enableGearScore = gearScoreCheckbox:GetChecked(),
            useRangeFinder = rangeFinderCheckbox:GetChecked(),
            useSpeedometer = speedometerCheckbox:GetChecked(),
            useBufftracker = buffTrackerCheckbox:GetChecked()
        }
        

        if existingSettings then
            if existingSettings.rangeFinderFont then
                settingsToSave.rangeFinderFont = existingSettings.rangeFinderFont
            end
            if existingSettings.useBufftracker ~= nil then
                settingsToSave.useBufftracker = existingSettings.useBufftracker
            end
        end
        
        api.File:Write("better-archeage/settings.txt", settingsToSave)
    end

    function frame:UpdateTrackerList()
        local settingsData = api.File:Read("better-archeage/settings.txt")
        local config = {}
        
        if settingsData then
            if settingsData.buffTrackers then
                config = settingsData.buffTrackers
            elseif type(settingsData) == "table" and #settingsData > 0 and settingsData[1].nameFilter then
                -- Old format (just array)
                config = settingsData
            end
        end

        for k, v in ipairs(config) do
            list:InsertData(k, 1, v)
            list:InsertData(k, 2, v)
            list:InsertData(k, 3, v)
            list:InsertData(k, 4, v)
        end
    end

    frame:UpdateTrackerList()

    -- Create Add Button
    local addButton = frame:CreateChildWidget("button", "addButton", 1, true)
    api.Interface:ApplyButtonSkin(addButton, BUTTON_BASIC.DEFAULT)
    addButton:SetExtent(100, 30)
    addButton:SetText("Add")
    addButton:AddAnchor("BOTTOMRIGHT", frame, -120, -30)
    addButton.style:SetAlign(ALIGN.CENTER)

    function addButton:OnClick()
        -- Save current changes first
        local configData = {}
        
        -- Iterate through all rows (10 rows)
        for rowIndex = 1, 10 do
            -- Get subItems from the list control (Lua uses 1-based indexing)
            if list.listCtrl.items[rowIndex] then
                local targetSubItem = list.listCtrl.items[rowIndex].subItems[1]
                local nameSubItem = list.listCtrl.items[rowIndex].subItems[2]
                local typeSubItem = list.listCtrl.items[rowIndex].subItems[3]
                local extraDataSubItem = list.listCtrl.items[rowIndex].subItems[4]
                
                -- Get Name value
                local nameValue = ""
                if nameSubItem and nameSubItem.textbox then
                    nameValue = nameSubItem.textbox:GetText() or ""
                    nameValue = nameValue:gsub("^%s*(.-)%s*$", "%1")
                end
                
                -- Only process if name is not empty
                if nameValue ~= "" then
                    local rowData = list:GetDataByViewIndex(rowIndex, 1)
                    local entry = {}
                    
                    if rowData then
                        for k, v in pairs(rowData) do
                            entry[k] = v
                        end
                    end
                    
                    local targetValue = "player"
                    if targetSubItem and targetSubItem.combobox then
                        local selectedIndex = targetSubItem.combobox:GetSelectedIndex()
                        local targetOptions = {"player", "target"}
                        targetValue = targetOptions[selectedIndex] or "player"
                    end
                    
                    local typeValue = "default"
                    if typeSubItem and typeSubItem.combobox then
                        local selectedIndex = typeSubItem.combobox:GetSelectedIndex()
                        local typeOptions = {"default", "stack", "stack_time", "alert"}
                        typeValue = typeOptions[selectedIndex] or "default"
                    end
                    
                    local extraDataValue = ""
                    if extraDataSubItem and extraDataSubItem.textbox then
                        extraDataValue = extraDataSubItem.textbox:GetText() or ""
                        extraDataValue = extraDataValue:gsub("^%s*(.-)%s*$", "%1")
                    end
                    
                    entry.nameFilter = nameValue
                    entry.trg = targetValue
                    local oldType = entry.type
                    entry.type = typeValue
                    
                    if typeValue == "stack" or typeValue == "stack_time" then
                        local maxStack = tonumber(extraDataValue)
                        if maxStack then
                            entry.maxStack = maxStack
                        else
                            entry.maxStack = nil
                        end

                        if oldType ~= typeValue then
                            entry.alert = nil
                        end
                    elseif typeValue == "alert" then
                        entry.alert = extraDataValue
                        if oldType ~= typeValue then
                            entry.maxStack = nil
                        end
                    else
                        if oldType ~= typeValue then
                            entry.maxStack = nil
                            entry.alert = nil
                        end
                    end
                    
                    table.insert(configData, entry)
                end
            end
        end
        
        -- Add new empty entry
        local newEntry = {
            nameFilter = "",
            trg = "player",
            type = "default"
        }
        table.insert(configData, newEntry)
        
        -- Save to file
        SaveSettingsToFile(configData)
        
        -- Clear and reload the list
        list:DeleteAllDatas()
        frame:UpdateTrackerList()
        
        api.Log:Info("New entry added!")
    end
    addButton:SetHandler("OnClick", addButton.OnClick)

    -- Create Save Button
    local saveButton = frame:CreateChildWidget("button", "saveButton", 1, true)
    api.Interface:ApplyButtonSkin(saveButton, BUTTON_BASIC.DEFAULT)
    saveButton:SetExtent(100, 30)
    saveButton:SetText("Save")
    saveButton:AddAnchor("BOTTOMRIGHT", frame, -10, -30)
    saveButton.style:SetAlign(ALIGN.CENTER)

    function saveButton:OnClick()
        local configData = {}
        
        for rowIndex = 1, 10 do
            if list.listCtrl.items[rowIndex] then
                local targetSubItem = list.listCtrl.items[rowIndex].subItems[1] 
                local nameSubItem = list.listCtrl.items[rowIndex].subItems[2]   
                local typeSubItem = list.listCtrl.items[rowIndex].subItems[3]    
                local extraDataSubItem = list.listCtrl.items[rowIndex].subItems[4] 
                
                local nameValue = ""
                if nameSubItem and nameSubItem.textbox then
                    nameValue = nameSubItem.textbox:GetText() or ""
                    nameValue = nameValue:gsub("^%s*(.-)%s*$", "%1") -- trim whitespace
                end
                
                if nameValue ~= "" then
                    local rowData = list:GetDataByViewIndex(rowIndex, 1)
                    local entry = {}
                    
                    if rowData then
                        for k, v in pairs(rowData) do
                            entry[k] = v
                        end
                    end
                    
                    local targetValue = "player"
                    if targetSubItem and targetSubItem.combobox then
                        local selectedIndex = targetSubItem.combobox:GetSelectedIndex()
                        local targetOptions = {"player", "target"}
                        targetValue = targetOptions[selectedIndex] or "player"
                    end
                    
                    local typeValue = "default"
                    if typeSubItem and typeSubItem.combobox then
                        local selectedIndex = typeSubItem.combobox:GetSelectedIndex()
                        local typeOptions = {"default", "stack", "stack_time", "alert"}
                        typeValue = typeOptions[selectedIndex] or "default"
                    end
                    
                    local extraDataValue = ""
                    if extraDataSubItem and extraDataSubItem.textbox then
                        extraDataValue = extraDataSubItem.textbox:GetText() or ""
                        extraDataValue = extraDataValue:gsub("^%s*(.-)%s*$", "%1") -- trim whitespace
                    end
                    
                    entry.nameFilter = nameValue
                    entry.trg = targetValue
                    local oldType = entry.type
                    entry.type = typeValue
                    
                    if typeValue == "stack" or typeValue == "stack_time" then
                        local maxStack = tonumber(extraDataValue)
                        if maxStack then
                            entry.maxStack = maxStack
                        else
                            entry.maxStack = nil
                        end
                        if oldType ~= typeValue then
                            entry.alert = nil
                        end
                    elseif typeValue == "alert" then
                        entry.alert = extraDataValue
                        
                        if oldType ~= typeValue then
                            entry.maxStack = nil
                        end
                    else
                        if oldType ~= typeValue then
                            entry.maxStack = nil
                            entry.alert = nil
                        end
                    end
                    
                    table.insert(configData, entry)
                end
            end
        end
        
        -- Save buff tracker config and checkbox settings to file
        SaveSettingsToFile(configData)
        
        api.Log:Info("Buff tracker settings saved!")
    end
    saveButton:SetHandler("OnClick", saveButton.OnClick)

    return frame
end

configFrame = CreateBuffTrackerConfigWindow()
return configFrame