local rangeFinder
local speedoMeter
local buffTracker 

BA_SETTINGS = nil

local function OnLoad()
	BA_SETTINGS = require("better_archeage/settings")

	if BA_SETTINGS.useRangeFinder then
		rangeFinder = require("better_archeage/range_meter")
	end

  speedoMeter = require("better_archeage/speedometer")	

	require("better_archeage/better_frames")

	require("better_archeage/abyss_bar")

	buffTracker = require("better_archeage/buff_tracker")
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
	OnSettingToggle = OnSetting
}
