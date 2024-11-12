local canvas = api.Interface:CreateEmptyWindow("rangefinder")

canvas:Show(true)

local rangeLabel = canvas:CreateChildWidget("label", "rLabel", 0, true)
rangeLabel:Show(true)
rangeLabel:AddAnchor("TOPLEFT", canvas, 0, 0)
rangeLabel:SetText("Hello")
rangeLabel.style:SetFontSize(BA_SETTINGS.rangeFinderFont)

local function OnUpdate()
	local sX, sY, sZ = api.Unit:GetUnitScreenPosition("target")
	if sX == nil or sZ < 0 or sZ > 120  then
		canvas:Show(false)
		return
	else
		canvas:Show(true)
	end

	if sX == nil then
		return
	end
	
	local dist = api.Unit:UnitDistance("target")

	if dist == nil then
		dist = 0
		-- canvas:Show(false)
	end

	if dist < 0 then
		dist = 0
	end

	rangeLabel:SetText(string.format("%.1fm", dist))

	-- canvas:RemoveAllAnchors()
	if sX ~= nil and sY ~= nil then
		canvas:AddAnchor("BOTTOM", "UIParent", "TOPLEFT", sX, sY - 44)
	end
end

-- canvas:SetHandler("OnUpdate", OnUpdate)
api.On("UPDATE", OnUpdate)

return canvas
