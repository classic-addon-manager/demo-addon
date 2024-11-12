local canvas = api.Interface:CreateEmptyWindow("speedometer")

canvas:Show(true)
canvas:SetExtent(255, 20)

local maxSpeedValue = 50

local speedBar = api.Interface:CreateStatusBar("speedo", canvas, "item_evolving_material")
speedBar:SetBarColor({
  ConvertColor(222),
  ConvertColor(177),
  ConvertColor(102),
  1
})
speedBar.bg:SetColor(ConvertColor(76), ConvertColor(45), ConvertColor(8), 0.4)
speedBar:SetMinMaxValues(0, maxSpeedValue)
speedBar:AddAnchor("TOPLEFT", canvas, 25, 1)
speedBar:AddAnchor("BOTTOMRIGHT", canvas, -1, 1)

local speedLabel = canvas:CreateChildWidget("label", "speedLabel", 0, true)
speedLabel:AddAnchor("TOPLEFT", speedBar, 110, 10)
speedLabel:SetText("SPEED")

canvas:AddAnchor("TOP", "UIParent", "TOP", 10, 44)


local function OnUpdate()
	local speed = api.SiegeWeapon:GetSiegeWeaponSpeed()

	if speed == 0 then
		canvas:Show(false)
		return
	end

	if speed * 10 > maxSpeedValue then
		maxSpeedValue = speed * 10
		speedBar:SetMinMaxValues(0, maxSpeedValue)
	end

	canvas:Show(true)
	speedBar:SetValue(math.abs(speed * 10))
	speedLabel:SetText(string.format("%.1fm/s", speed))
end


api.On("UPDATE", OnUpdate)


return canvas
