# Better ArcheAge

A comprehensive addon suite for ArcheAge Classic that enhances gameplay with quality-of-life improvements and visual enhancements.

## Overview

Better ArcheAge is a collection of modular improvements designed to enhance your ArcheAge Classic experience. The addon provides customizable buff tracking, range finding, speed monitoring, and enhanced health bar displays.

## Features

### 🎯 Buff Tracker

Track specific buffs and debuffs on yourself or your target with customizable display options.

**Features:**
- Track buffs by name or ID
- Monitor buffs on player or target
- Multiple display types:
  - **Default**: Shows remaining time
  - **Stack**: Displays current stack count vs maximum
  - **Stack + Time**: Shows both stack count and remaining time
  - **Alert**: Displays custom alert message when buff is active
- Color-coded progress bars with customizable colors
- Keyframe system for color changes at specific times
- Draggable interface (hold Shift to drag)
- Position persistence

**Usage:**
1. Open the settings panel (click the addon settings button)
2. Add buff entries with the "Add" button
3. Configure:
   - **Target**: Player or Target
   - **Name**: Buff name (partial matches work)
   - **Type**: Display type (default, stack, stack_time, alert)
   - **Extra Data**: Maximum stack count or alert message (depending on type)
4. Click "Save" to apply changes

### 📏 Range Finder

Display the distance to your current target in real-time.

**Features:**
- Shows distance in meters above the target
- Automatically hides when no target is selected
- Customizable font size (12-20)
- Only displays when target is within valid range (0-120m)

**Configuration:**
- Enable/disable in settings panel
- Font size can be adjusted (requires settings file edit or future UI)

### 🚗 Speedometer

Monitor your movement speed when riding vehicles.

**Features:**
- Visual speed bar display
- Shows current speed in m/s
- Automatically adjusts scale for high speeds
- Only displays when moving (hides when speed is 0)
- Positioned at top center of screen

**Configuration:**
- Enable/disable in settings panel

### 💚 Better Frames

Enhanced health and mana bar displays with additional information.

**Features:**

#### Large HP/MP Display
- Larger, centered font for HP and MP values
- Makes health/mana easier to read at a glance
- Applies to player, target, target-of-target, and watch frames

#### Guild Name Display
- Shows guild name on target frames
- Displays as `<GuildName>` above the target's health bar
- Only shows for character targets with a guild

#### GearScore Display
- Shows target's gear score on target frames
- Displays as `XXXXgs` below the target's health bar
- Only shows for character targets

**Configuration:**
- Each feature can be individually enabled/disabled in settings

## Configuration

### Settings Panel

Open the settings panel by clicking the addon settings button. The panel provides:

- **Checkboxes** for enabling/disabling features:
  - Enable large HP /MP on health bars
  - Enable Guild Name on health bars
  - Enable GearScore on Health Bars
  - Enable Range Finder
  - Enable speedoMeter
  - Use Buff Tracker

- **Buff Tracker Configuration Table**:
  - Add, edit, and remove buff tracking entries
  - Configure each entry's target, name filter, type, and extra data
  - Delete entries using the minus button on each row

### Settings File

Settings are stored in `better-archeage/settings.txt`. The file uses Lua table format:

```lua
{
    buffTrackers = {
        {
            nameFilter = "Zeal",
            type = "default",
            trg = "player",
            baseColor = "#37CC7B"
        }
    },
    enableLargeHPMP = true,
    enableGuildName = true,
    enableGearScore = true,
    useRangeFinder = true,
    useSpeedometer = true,
    useBufftracker = true,
    rangeFinderFont = 14
}
```

## Usage Tips

### Buff Tracker

- **Name Matching**: Use partial names (e.g., "Liberation" matches "Liberation" buff)
- **Color Customization**: Use hex colors like `#FF0000` for red
- **Keyframes**: Set color changes at specific times (e.g., turn red when buff has 6 seconds remaining)
- **Alert Type**: Use for important buffs that need immediate attention
- **Stack Tracking**: Perfect for buffs that stack (e.g., Inspire stacks)


## Troubleshooting

### Buff Tracker Not Showing
- Ensure "Use Buff Tracker" is enabled in settings
- Check that buff names match exactly (case-sensitive)
- Verify the target setting (player vs target) is correct

### Range Finder Not Appearing
- Make sure you have a target selected
- Check that "Enable Range Finder" is enabled
- Target must be within 0-120 meters

### Settings Not Saving
- Ensure you click the "Save" button after making changes
- Check file permissions on the addon directory
- Verify `settings.txt` is writable