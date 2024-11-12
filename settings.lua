local settings = api.GetSettings("better_archeage")

local use_range_finder = settings.useRangeFinder or true
local range_finder_size = settings.rangeFinderFont or 14



settings.useRangeFinder = use_range_finder
settings.rangeFinderFont = range_finder_size

settings.s_options = {
	rangeFinderFont = {
		titleStr = "Range Finder Font Size",
		controlStr = { "12", "20"}
	},
	useRangeFinder = {
		titleStr = "Use Range Finder"
	}
}


api.SaveSettings()
return settings
