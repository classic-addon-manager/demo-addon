-- Ensure BA_SETTINGS is available (set as global in main.lua)
if BA_SETTINGS == nil then
	BA_SETTINGS = require("better-archeage/settings")
end

local player_frame = ADDON:GetContent(UIC.PLAYER_UNITFRAME)
local target_frame = ADDON:GetContent(UIC.TARGET_UNITFRAME)
local tt_frame = ADDON:GetContent(UIC.TARGET_OF_TARGET_FRAME)
local watch_frame = ADDON:GetContent(UIC.WATCH_TARGET_FRAME)

local function FixBigFrame(frame)
	-- Large HP/MP on health bars
	if BA_SETTINGS.enableLargeHPMP then
		frame.hpBar.hpLabel.style:SetFontSize(16)
		frame.hpBar.hpLabel:RemoveAllAnchors()
		frame.hpBar.hpLabel:AddAnchor("CENTER", frame.hpBar, 0, 0)

		frame.mpBar.mpLabel.style:SetFontSize(11)
		frame.mpBar.mpLabel:RemoveAllAnchors()
		frame.mpBar.mpLabel:AddAnchor("CENTER", frame.mpBar, 0, 0)
	end

	if frame.target == "target" then
		-- Guild Name on health bars
		if BA_SETTINGS.enableGuildName then
			local expeditionNameWidget = frame:CreateChildWidget("label", "expeditionName", 0, true)
			expeditionNameWidget:SetExtent(90, FONT_SIZE.MIDDLE)
			expeditionNameWidget:AddAnchor("BOTTOMRIGHT", frame.hpBar, "TOPRIGHT", 0, -22)
			expeditionNameWidget:SetAutoResize(true)
			expeditionNameWidget.style:SetAlign(ALIGN.LEFT)
			expeditionNameWidget.style:SetShadow(true)
			ApplyTextColor(expeditionNameWidget, FONT_COLOR.WHITE)
			frame.expeditionName = expeditionNameWidget
		end

		-- GearScore on Health Bars
		if BA_SETTINGS.enableGearScore then
			local gearscoreWidget = frame:CreateChildWidget("label", "gearScore", 0, true)
			gearscoreWidget:SetExtent(90, FONT_SIZE.MIDDLE)
			gearscoreWidget:AddAnchor("BOTTOMRIGHT", frame.hpBar, "TOPRIGHT", 0, 16)
			gearscoreWidget:SetAutoResize(true)
			gearscoreWidget.style:SetAlign(ALIGN.LEFT)
			gearscoreWidget.style:SetShadow(true)
			ApplyTextColor(gearscoreWidget, FONT_COLOR.WHITE)
			frame.gearScore = gearscoreWidget
		end
	

		local function UpdateName()
			if frame.target == nil then
    	        return
    	    end

			local unitId = api.Unit:GetUnitId(frame.target)
			local unitInfo = api.Unit:GetUnitInfoById(unitId)

			local name = unitInfo.name
			if unitInfo ~= nil then
				-- Update Guild Name if enabled
				if BA_SETTINGS.enableGuildName and frame.expeditionName then
					if unitInfo.type == "character" and unitInfo.expeditionName ~= nil then
						frame.expeditionName:Show(true)
						frame.expeditionName:SetText("<" .. unitInfo.expeditionName .. ">")
					else
						frame.expeditionName:Show(false)
						frame.expeditionName:SetText("")
					end
				end
				
				-- Update GearScore if enabled
				if BA_SETTINGS.enableGearScore and frame.gearScore then
					if unitInfo.type == "character" then
						local unitGearscore = api.Unit:UnitGearScore(frame.target)
						if unitGearscore ~= nil then
							frame.gearScore:Show(true)
							frame.gearScore:SetText(unitGearscore.."gs")
						else
							frame.gearScore:Show(false)
							frame.gearScore:SetText("")
						end
					else
						frame.gearScore:Show(false)
						frame.gearScore:SetText("")
					end
				end
			end

    	    frame.name:SetText(name)
		end
	    frame.UpdateName = UpdateName
	end

end


FixBigFrame(player_frame)
FixBigFrame(target_frame)
FixBigFrame(tt_frame)
FixBigFrame(watch_frame)

local updateTime = 0

--local function OnUpdate(deltaTime)
--    updateTime = updateTime + deltaTime
--
--    if updateTime < 100 then
--        return
--    end
--    
--    updateTime = 0
--
--end


--api.On("UPDATE", OnUpdate)
