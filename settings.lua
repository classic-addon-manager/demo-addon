-- Load settings from settings.txt
local settingsData = api.File:Read("better-archeage/settings.txt")

-- Default values
local settings = {
	useRangeFinder = true,
	useSpeedometer = true,
	useBufftracker = true,
	rangeFinderFont = 14,
	enableLargeHPMP = true,
	enableGuildName = true,
	enableGearScore = true
}


-- Load from settings.txt if it exists
if settingsData then
	if settingsData.buffTrackers then
		api.Log:Info("New settings format loaded")
		-- New format with settings
		-- Use explicit nil checks to preserve false values
		if settingsData.useRangeFinder ~= nil then
			settings.useRangeFinder = settingsData.useRangeFinder
		end
		if settingsData.useSpeedometer ~= nil then
			settings.useSpeedometer = settingsData.useSpeedometer
		end
		if settingsData.useBufftracker ~= nil then
			settings.useBufftracker = settingsData.useBufftracker
		end
		if settingsData.rangeFinderFont ~= nil then
			settings.rangeFinderFont = settingsData.rangeFinderFont
		end
		if settingsData.enableLargeHPMP ~= nil then
			settings.enableLargeHPMP = settingsData.enableLargeHPMP
		end
		if settingsData.enableGuildName ~= nil then
			settings.enableGuildName = settingsData.enableGuildName
		end
		if settingsData.enableGearScore ~= nil then
			settings.enableGearScore = settingsData.enableGearScore
		end
	elseif type(settingsData) == "table" and #settingsData > 0 and settingsData[1].nameFilter then
		-- Old format (just array), keep defaults
	end
end

return settings
