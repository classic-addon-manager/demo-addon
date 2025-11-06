local frame = api.Interface:CreateEmptyWindow("buffTracker")
frame:Show(true)

local width = api.Interface:GetScreenWidth() or 2560
local height = api.Interface:GetScreenHeight() or 1080

-- local width = 2560
-- local height = 1080

local alertLabel = frame:CreateChildWidget("label", "label", 0, true)
alertLabel:SetText("")
alertLabel:AddAnchor("TOPLEFT", "UIParent", width / 2, height / 2 - 350)
alertLabel.style:SetFontSize(32)
alertLabel:Show(false)

function frame:OnDragStart()
	if not api.Input:IsShiftKeyDown() then
		return
	end
	frame:StartMoving()
	api.Cursor:ClearCursor()
	api.Cursor:SetCursorImage(CURSOR_PATH.MOVE, 0, 0)
end

function frame:OnDragStop()
	frame:StopMovingOrSizing()
	api.Cursor:ClearCursor()

	local x, y = frame:GetOffset()
	api.File:Write("better-archeage/position.txt", {x, y})
end

frame:EnableDrag(true)
frame:SetHandler("OnDragStart", frame.OnDragStart)
frame:SetHandler("OnDragStop", frame.OnDragStop)

local function RepositionTrackers(frame)
	local activeTrackers = {}
	for _, tracker in ipairs(frame.trackers) do
		if tracker:IsVisible() then
			table.insert(activeTrackers, tracker)
		end
	end
	
	-- Sort trackers by their original index to maintain consistent order
	table.sort(activeTrackers, function(a, b)
		local aNum = tonumber(string.match(a:GetName(), "tracker%.(%d+)")) or 0
		local bNum = tonumber(string.match(b:GetName(), "tracker%.(%d+)")) or 0
		return aNum < bNum
	end)
	
	-- Reposition active trackers
	for i, tracker in ipairs(activeTrackers) do
		tracker:RemoveAllAnchors()
		tracker:AddAnchor("TOPLEFT", frame, 0, 0 + (40 * (i - 1)))
	end
end

local function CreateBuffTrackerView(frame, settings)
	local i = 1
	if frame.trackers ~= nil then 
	  i = #frame.trackers + 1
	else
		frame.trackers = {}
	end

	frame:SetExtent(172, 40 * i)

	local tracker = frame:CreateChildWidget("emptywidget", "tracker." .. i, 0, true)
	tracker:SetExtent(172, 40)
	tracker:Clickable(false)
	tracker.settings = settings

	local buffIcon = CreateItemIconButton(i .. ".buffIcon", tracker)
	buffIcon:Show(true)
	buffIcon:Clickable(false)
	F_SLOT.ApplySlotSkin(buffIcon, buffIcon.back, SLOT_STYLE.BUFF)
	buffIcon:AddAnchor("TOPLEFT", tracker, "TOPLEFT", 0, 0)

  -- F_SLOT.SetIconBackGround(zealIcon, trackedBuffInfo.path)
	-- local buffTime = ...
	local buffTimeBar = api.Interface:CreateStatusBar("speedo", tracker, "item_evolving_material")
	buffTimeBar:Clickable(false)
	function tracker:SetColor(color)
		-- If color is a table, split into 3
		-- If color is a string, split as hex rgb
		if type(color) == "table" then
			buffTimeBar:SetBarColor({
		  		ConvertColor(color[1]),
		  		ConvertColor(color[2]),
		  		ConvertColor(color[3]),
		  	1
			})
		elseif type(color) == "string" then
			-- Parse R G B from hex string into 0-255
			local r, g, b = string.match(color, "#(%x%x)(%x%x)(%x%x)")
			local r = tonumber(r, 16)
			local g = tonumber(g, 16)
			local b = tonumber(b, 16)
			buffTimeBar:SetBarColor({
		  		ConvertColor(r),
	  			ConvertColor(g),
	  			ConvertColor(b),
	  			1
			})
		end
		buffTimeBar.bg:SetColor(ConvertColor(76), ConvertColor(45), ConvertColor(8), 0.4)
	end

	if settings.baseColor then
		tracker:SetColor(settings.baseColor)
	else
		tracker:SetColor({70, 200, 66})
	end
	--buffTimeBar.bg:SetColor(ConvertColor(76), ConvertColor(45), ConvertColor(8), 0.4)
	buffTimeBar:SetMinMaxValues(0, 100)

	if settings.type == "stack" then
		buffTimeBar:SetMinMaxValues(0, settings.maxStack)
	end

	buffTimeBar:AddAnchor("TOPLEFT", tracker, 42, 1)
	buffTimeBar:AddAnchor("BOTTOMRIGHT", tracker, -1, 1)

	local buffTimeLabel = tracker:CreateChildWidget("label", "buffTimeLabel", 0, true)
	buffTimeLabel:AddAnchor("TOPLEFT", tracker, "CENTER", 0, 0)
	buffTimeLabel.style:SetFontSize(20)
	buffTimeLabel:Clickable(false)

	tracker:Show(false)

	local maxBuffTime = 0
	tracker.lastTime = 0

	function tracker:UpdateBuff(buff)
		F_SLOT.SetIconBackGround(buffIcon, buff.path)
		if buff.timeLeft ~= nil and maxBuffTime < buff.timeLeft then
			maxBuffTime = buff.timeLeft
		end

		if tracker.settings.type == "stack" then
			buffTimeBar:SetValue(buff.stack)
			buffTimeLabel:SetText(string.format("%d/%d", buff.stack, tracker.settings.maxStack))
		elseif tracker.settings.type == "stack_time" then
			buffTimeBar:SetValue((buff.timeLeft / maxBuffTime) * 100)
			buffTimeLabel:SetText(string.format("%d/%d", buff.stack, tracker.settings.maxStack))
		elseif buff.timeLeft == nil then
			buffTimeBar:SetValue(100)
			buffTimeLabel:SetText("Active")
		else
			buffTimeBar:SetValue((buff.timeLeft / maxBuffTime) * 100)
			buffTimeLabel:SetText(string.format("%.1fs", buff.timeLeft / 1000))
		end
		
		if (buff.timeLeft ~= nil and buff.timeLeft > 190) or buff.timeLeft == nil then
			tracker:Show(true)
			RepositionTrackers(frame)
		else
			tracker:Show(false)
			RepositionTrackers(frame)
		end

		if tracker.settings.type == "alert" then
			tracker:Show(false)
		end
		-- Compute keyframes
		if settings.keyframes then
			for ki, kf  in ipairs(settings.keyframes) do
				if kf.time ~= nil then
					if tracker.lastTime > kf.time and buff.timeLeft <= kf.time then
						if kf.type == "color" then
							self:SetColor(kf.value)
						end
					end
				end
				
				if kf.remain ~= nil then
					if buff.timeLeft <= kf.remain then
						if kf.type == "color" then
							self:SetColor(kf.value)
						end
					end
				end
			end
		end

		tracker.lastTime = buff.timeLeft
	end

	function tracker:Reset()
		buffTimeBar:SetBarColor({
	  		ConvertColor(55),
	  		ConvertColor(200),
	  		ConvertColor(66),
	  		1
		})
		buffTimeBar.bg:SetColor(ConvertColor(76), ConvertColor(45), ConvertColor(8), 0.4)
	end

	table.insert(frame.trackers, tracker)
end

local defaultTrackedSettings = {
	{ 
		comment = "Tracker for Liberation on TARGET (only works on English clients)",
		nameFilter = "Liberation",
		trg = "target", 
		baseColor = "#FF0000"
	},
	{ 
		comment = "Tracker for Inspired on PLAYER",
		idFilter = 127,
		trg = "player", 
		baseColor = "#37CC7B",
		keyframes = {
			{ type = "color", remain = 6000, value = "#FF0000"}
		} 
	},
}

local position = { 400, 100}

local trackedSettings = api.File:Read("better-archeage/settings.txt")
local savedPosition = api.File:Read("better-archeage/position.txt")

if trackedSettings == nil then
	trackedSettings = defaultTrackedSettings
	api.File:Write("better-archeage/settings.txt", defaultTrackedSettings)
end

if savedPosition == nil then
	savedPosition = position
	api.File:Write("better-archeage/position.txt", savedPosition)
end

frame:AddAnchor("TOPLEFT", "UIParent", savedPosition[1], savedPosition[2])

local function RefreshTracked()
  for i, v  in ipairs(trackedSettings) do
  	CreateBuffTrackerView(frame, v)
  end
end

local function IsBuffMatchingTracker(buff, tracker)
    local settings = tracker.settings
    local buffInfo = api.Ability:GetBuffTooltip(buff.buff_id)
    
    if settings.idFilter and buff.buff_id ~= settings.idFilter then
        return false
    end
    
    if settings.nameFilter and not string.find(string.lower(buffInfo.name), string.lower(settings.nameFilter)) then
        return false
    end
    
    return true
end

local function BuffLoop(trg)
    local buffCount = api.Unit:UnitBuffCount(trg)
    local debuffCount = api.Unit:UnitDeBuffCount(trg)
    
    if buffCount == 0 and debuffCount == 0 then
        for _, tracker in ipairs(frame.trackers) do
            if tracker.settings.trg == trg and tracker:IsVisible() then
                tracker:Show(false)
                tracker:Reset()
            end
        end
        return
    end

    local buffsByID = {}
    for i = 1, buffCount do
        local buff = api.Unit:UnitBuff(trg, i)
        buffsByID[buff.buff_id] = buff
    end

    for i = 1, debuffCount do
        local debuff = api.Unit:UnitDeBuff(trg, i)
        buffsByID[debuff.buff_id] = debuff
    end

    local hasAlert = false
    for _, tracker in ipairs(frame.trackers) do
        local settings = tracker.settings
        
        if settings.trg == trg then
            local foundBuff = false
            
            if settings.idFilter and buffsByID[settings.idFilter] then
                tracker:UpdateBuff(buffsByID[settings.idFilter])
                foundBuff = true
                if settings.alert then
                    hasAlert = true
                end
            else
                for _, buff in pairs(buffsByID) do
                    if IsBuffMatchingTracker(buff, tracker) then
                        tracker:UpdateBuff(buff)
                        foundBuff = true
                        if settings.alert then
							if settings.baseColor then
								local color = settings.baseColor
								if color:sub(1,1) == "#" then
									color = color:sub(2)
								end
								
								local r = tonumber(color:sub(1,2), 16) or 255
								local g = tonumber(color:sub(3,4), 16) or 255
								local b = tonumber(color:sub(5,6), 16) or 255
								alertLabel.style:SetColor(r/255, g/255, b/255, 1)
							end
							alertLabel:SetText(settings.alert)
                            hasAlert = true
                        end
                        break
                    end
                end
            end
            
            if not foundBuff and tracker:IsVisible() then
                tracker:Show(false)
                tracker:Reset()
            end
        end
    end
    
    alertLabel:Show(hasAlert)
end

local updateTime = 0
local cleanupTick = 0

local function OnUpdate(dt)
	updateTime = updateTime + dt

	if updateTime < 100 then
		return
	end

	updateTime = 0

	local trackers = frame.trackers
	local targets = {}
	for _, tracker in ipairs(trackers) do
		if not targets[tracker.settings.trg] then
			targets[tracker.settings.trg] = true
		end
	end

	for target, _ in pairs(targets) do
		BuffLoop(target)
	end
end

RefreshTracked()

api.On("UPDATE", OnUpdate)

return frame
