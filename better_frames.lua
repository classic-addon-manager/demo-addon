local player_frame = ADDON:GetContent(UIC.PLAYER_UNITFRAME)
local target_frame = ADDON:GetContent(UIC.TARGET_UNITFRAME)
local tt_frame = ADDON:GetContent(UIC.TARGET_OF_TARGET_FRAME)
local watch_frame = ADDON:GetContent(UIC.WATCH_TARGET_FRAME)

local function FixBigFrame(frame)
	frame.hpBar.hpLabel.style:SetFontSize(16)
	frame.hpBar.hpLabel:RemoveAllAnchors()
	frame.hpBar.hpLabel:AddAnchor("CENTER", frame.hpBar, 0, 0)

	frame.mpBar.mpLabel.style:SetFontSize(11)
	frame.mpBar.mpLabel:RemoveAllAnchors()
	frame.mpBar.mpLabel:AddAnchor("CENTER", frame.mpBar, 0, 0)
end


FixBigFrame(player_frame)
FixBigFrame(target_frame)
FixBigFrame(tt_frame)
FixBigFrame(watch_frame)
