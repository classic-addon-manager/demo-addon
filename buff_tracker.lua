local function CreateBuffTrackerView(frame, settings)
	local i = 1
	if frame.trackers ~= nil then 
	  i = #frame.trackers
	else
		frame.trackers = {}
	end

	local tracker = frame:CreateChildWidget("emptywidget", "tracker." .. i, 0, true)
	tracker:SetExtent(172, 40)
	tracker.settings = settings

	local buffIcon = CreateItemIconButton(i .. ".buffIcon", tracker)
	buffIcon:Show(true)
	F_SLOT.ApplySlotSkin(buffIcon, buffIcon.back, SLOT_STYLE.BUFF)
	buffIcon:AddAnchor("TOPLEFT", tracker, "TOPLEFT", 0, 0)
  -- F_SLOT.SetIconBackGround(zealIcon, trackedBuffInfo.path)
	-- local buffTime = ...
	local buffTimeBar = api.Interface:CreateStatusBar("speedo", tracker, "item_evolving_material")
	buffTimeBar:SetBarColor({
	  ConvertColor(55),
	  ConvertColor(200),
	  ConvertColor(66),
	  1
	})
	buffTimeBar.bg:SetColor(ConvertColor(76), ConvertColor(45), ConvertColor(8), 0.4)
	buffTimeBar:SetMinMaxValues(0, 100)
	buffTimeBar:AddAnchor("TOPLEFT", tracker, 42, 1)
	buffTimeBar:AddAnchor("BOTTOMRIGHT", tracker, -1, 1)
	
	local buffTimeLabel = tracker:CreateChildWidget("label", "buffTimeLabel", 0, true)
	buffTimeLabel:AddAnchor("TOPLEFT", tracker, "CENTER", 0, 0)
	buffTimeLabel.style:SetFontSize(20)

	tracker:AddAnchor("TOPLEFT", frame, 0, 0 + (40 * i))
	tracker:Show(false)

	local maxBuffTime = 0
	tracker.lastTime = 0

	function tracker:UpdateBuff(buff)
		F_SLOT.SetIconBackGround(buffIcon, buff.path)
		if maxBuffTime < buff.timeLeft then
			maxBuffTime = buff.timeLeft
		end
		
		buffTimeBar:SetValue((buff.timeLeft / maxBuffTime) * 100)
		buffTimeLabel:SetText(string.format("%.1fs", buff.timeLeft / 1000))
		if buff.timeLeft > 20 then
			if not tracker:IsVisible() then
				tracker:Reset()
			end
			tracker:Show(true)
		else
			tracker:Show(false)
		end

		-- Compute keyframes
		for ki, kf  in ipairs(settings.keyframes) do
			if tracker.lastTime > kf.time and buff.timeLeft <= kf.time then
				api.Log:Info(string.format("%i %i %i", tracker.lastTime, kf.time, buff.timeLeft))
				if kf.type == "color" then
					self:SetColor(kf.value)
				end
			end
    end

		tracker.lastTime = buff.timeLeft
	end

	function tracker:SetColor(color)
		buffTimeBar:SetBarColor({
	  ConvertColor(color[1]),
	  ConvertColor(color[2]),
	  ConvertColor(color[3]),
	  1
		})
		buffTimeBar.bg:SetColor(ConvertColor(76), ConvertColor(45), ConvertColor(8), 0.4)
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


local frame = api.Interface:CreateEmptyWindow("buffTracker")
frame:Show(true)
frame:AddAnchor("TOPLEFT", "UIParent", 400, 100)

local trackedSettings = {
{ 
		nameFilter = "Inspired", trg = "player", 
		keyframes = {
			{ type = "color", time = 24000, value = {200, 50, 50}}
		} 
	}
}

local function RefreshTracked()
	for i, v  in ipairs(trackedSettings) do
  	CreateBuffTrackerView(frame, v)
  end
end

local function BuffLoop(trg)
	local buffCount = api.Unit:UnitBuffCount(trg)
	for i = 1, buffCount, 1 do
		local buff = api.Unit:UnitBuff(trg, i)
		local buffInfo = api.Ability:GetBuffTooltip(buff.buff_id)
		
		if buffInfo.name == frame.trackers[1].settings.nameFilter then
			frame.trackers[1]:UpdateBuff(buff)
		end
	end
end

local function OnUpdate()
	BuffLoop("player")
end

RefreshTracked()

api.On("UPDATE", OnUpdate)

return frame
