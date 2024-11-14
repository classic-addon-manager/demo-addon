local rangeFinder
local speedoMeter
local buffTracker 

BA_SETTINGS = nil

local function OnLoad()
	BA_SETTINGS = require("better-archeage/settings")

	if BA_SETTINGS.useRangeFinder then
		rangeFinder = require("better-archeage/range_meter")
	end

  if BA_SETTINGS.useSpeedometer then
  	speedoMeter = require("better-archeage/speedometer")	
  end
	require("better-archeage/better_frames")

	-- require("better_archeage/abyss_bar")
  if BA_SETTINGS.useRangeFinder then
		buffTracker = require("better-archeage/buff_tracker")
	end
end

local function OnUnload()
	if rangeFinder ~= nil then
		rangeFinder:Show(false)
		rangeFinder = nil
	end

	if speedoMeter ~= nil then
  	speedoMeter:Show(false)
		speedoMeter = nil
  end

	if buffTracker ~= nil then
		buffTracker:Show(false)
		buffTracker = nil
	end
end

local function OnSetting()
	api.Log:Info("OnSetting!!")
end

return {
	name = "Better ArcheAge",
	desc = "A suite of improvements to the game",
	author = "Aguru",
	version = "1.0",
	OnLoad = OnLoad,
	OnUnload = OnUnload,
	-- OnSettingToggle = OnSetting
}
