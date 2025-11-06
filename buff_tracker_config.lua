local configFrame = nil

function CreateBuffTrackerConfigWindow()
	local frame = api.Interface:CreateWindow("buffTrackerConfig", "Buff Tracker Config")
	frame:Show(false)
	frame:AddAnchor("TOPLEFT", "UIParent", 100, 100)

	local list = W_CTRL.CreatePageScrollListCtrl("adList", frame)
	list:Show(true)
	list:AddAnchor("TOPLEFT", frame, 4, 44 + 10 / 2)
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
                subItem.textbox:SetText("" .. data["maxStack"])
            elseif data["type"] == "stack_time" then
                subItem.textbox:SetText("" .. data["maxStack"])
            elseif data["type"] == "alert" then
                subItem.textbox:SetText(data["alert"])
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
        sortCombobox:AddAnchor("BOTTOMRIGHT", subItem, "TOPRIGHT", 0, 35)
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
        targetCombobox:AddAnchor("BOTTOMRIGHT", subItem, "TOPRIGHT", -10, 36)
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
            api.File:Write("better-archeage/settings.txt", finalConfig)
            
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

    function frame:UpdateTrackerList()
        local config = api.File:Read("better-archeage/settings.txt")

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
        api.File:Write("better-archeage/settings.txt", configData)
        
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
        
        -- Save to file
        api.File:Write("better-archeage/settings.txt", configData)
        api.Log:Info("Buff tracker settings saved!")
    end
    saveButton:SetHandler("OnClick", saveButton.OnClick)

    return frame
end

configFrame = CreateBuffTrackerConfigWindow()
return configFrame