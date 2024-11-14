local settings = api.GetSettings("better-archeage")

local use_range_finder = settings.useRangeFinder or true
local use_speedometer = settings.useSpeedometer or true
local use_buffTracker = settings.useBufftracker or true

local range_finder_size = settings.rangeFinderFont or 14



settings.useRangeFinder = use_range_finder
settings.rangeFinderFont = range_finder_size
settings.useSpeedometer = use_speedometer
settings.useBufftracker = use_buffTracker

settings.s_options = {
	rangeFinderFont = {
		titleStr = "Range Finder Font Size",
		controlStr = { "12", "20"}
	},
	useRangeFinder = {
		titleStr = "Use Range Finder"
	},
	useSpeedometer = {
		titleStr = "Use Speedometer"
	},
	useBufftracker = {
		titleStr = "Use Buff Tracker"
	}
}


api.SaveSettings()
return settings
