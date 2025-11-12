# xCT+

Created for optimal performance in the toughest fights, a rugged combat text add-on is finally ready to be put to the 
test!

## Overview

xCT+ is immensely based off the add-on xCT by braindump (aka Affli). It strives to be as minimalistic as possible while 
maintaining ease of use. That is why, introduced in version 3, you can now configure all settings while in-game.

Overall, xCT+ is a replacement for Blizzard’s scrolling combat text. It is superior to the default combat text because 
xCT+ organizes incoming healing, incoming damage, and outgoing damage/healing into their own frames, while minimizing 
spam.
 
## Features

For those that have used Affli’s xCT Add-On, xCT+ expands the functionality of its predecessor. New features include:

* An In-Game Configuration Tool
* Frames for tracking Criticals, Loot and Money, Spell Procs and Unit Power (e.g. Mana)
* A grid when positioning the frames
* Tons of new options and features
* A redesigned Spell Merger to cut down on the spam
* Profiles
* And many more exciting new features!

## The future of xCT+ in Midnight

I recently gained access to the Midnight beta and tested some things:
- Listening for event `COMBAT_LOG_EVENT_UNFILTERED` is gone. Thats how this addon got almost all of its information.
- Same for `COMBAT_LOG_EVENT`
- I can register a handler for `UNIT_COMBAT` event and it gives me some data but its really lackluster:
  - No source unit of the damage? (e. g. Did I do that or did another player do that? Who damaged me?)
  - No spell ID (was it a melee attack or a spell?)
  - Is dependent on your Combat Log filter (see your chat box).
- `C_CombatText.GetCurrentEventInfo()` is supposed to provide these informations as `(secret value)`, but it just returns `nil` at the moment.

Currently I'm not optimistic that xCT+ will work in any capacity in the WoW Midnight expansion. 
If something changes I'll look at it again. Even a reduced form of xCT+ would be fine for me but that does not 
seem possible right now.

If anybody knows more and could help me bring some functionality to Midnight, please feel free to contact me via Github or ingame.

## The future of xCT+ in TWW and beyond

As of TWW Season 1, [Dandruff](https://www.curseforge.com/members/tdandruff) (Dandruff-Stormreaver US) resigned from addon development and gave [RedAces](https://www.curseforge.com/members/redaces) (Feylynn-Antonidas EU) the 
permission to develop xCT+ further. He has aided development since mid Dragonflight and will continue to fix and 
enhance xCT+.

### Version 4.9.0
Version 4.9.0 shapes up to be a major rewrite of the whole addon. The following features are currently in it:

* a lot of cleanup (!)
* a lot of bugfixes (!)
* use more headers in the options GUI because the descriptions are sometimes only displayed as "..."
* allow hiding the auto attack icons for outgoing attacks
* only register xCT as LibSink target if any other addon has loaded LibSink. Remove LibSink from embedded libraries
* show fully absorbed outgoing damage events as normal damage events (if enabled)
* add partially absorbed outgoing damage to the amount to show the full damage we did (if enabled)
* fix the handling of DK runes coming off CD
* The spell value filter now works AFTER merging!
  * e. g. if the spell filter is set for >= 100k damage, then 2x 60k damage events will be merged and displayed as 120k (x2) 
  * Before this change, nothing was displayed because each damage event was filtered before merging
* add notification for profession skill ups (if enabled)
* replace "OnUpdate" function for delayed loot display with a AceTimer schedule
* add new frame "outgoing" healing
  * Spam Merger now wont merge heal + damage if the Spell ID is the same (e. g. DK consumption, Death Strike)
* Major overhaul of the spam merger
  * cleanup merges of older expansions and rearrange them
  * let the player set the merge interval for everything we are currently merging
  * fix dispell merging
  * Spam merger now should display more OnUpdate in order to show all waiting messages
* modernize spell filter options: you can now delete an entry completely via an select (unsorted for now)
* Split xCT into a main addon and an options addon to reduce the footprint.
  * The main addon has a RAM footprint of about 800 KB, and the options of 1,8 MB ... wow!

Feel free to try the alpha and beta versions and provide feedback in GitHub!

## Download

* [CurseForge](https://www.curseforge.com/wow/addons/xct-plus)
* [GitHub](https://github.com/dandruff/xCT)
 
## Support

Feel free to use the comments below for quick and dirty questions. If you think that you have a question that is more 
involved, you should create a ticket on the [GitHub issue tracker](https://github.com/dandruff/xCT/issues/new).

All contributions (pull requests, testing, bug reports, ...) are welcome!
