--[[   ____    ______
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/

 [=====================================]
 [  Author: Dandraffbal-Stormreaver US ]
 [  xCT+ Version 4.x.x                 ]
 [  ©2010-2025 All Rights Reserved.    ]
 [====================================]]

-- this file handles updating the frame settings and anything that changes the UI frames themselves
local ADDON_NAME, addon = ...

local LSM = LibStub("LibSharedMedia-3.0")

-- Start the Random Machine!
math.random(time())
math.random()
math.random(time())

-- Shorten my handle
local x = addon.engine

local now = 0

-- Function to allow users to scroll a frame with mouseover
local function Frame_OnMouseWheel(self, delta)
    if delta > 0 then
        self:ScrollUp()
    elseif delta < 0 then
        self:ScrollDown()
    end
end

-- =====================================================
-- AddOn:UpdateFrames(
--        specificFrame,    [string] - (Optional) the framename
--    )
--        If you specify a specificFrame then only that
--    frame will be updated, otherwise all the frames will
--    be updated.
-- =====================================================
function x:UpdateFrames(specificFrame)
    -- Update the frames
    for frameName, frameSettings in pairs(x.db.profile.frames) do
        if specificFrame and specificFrame == frameName or not specificFrame then
            local f

            -- Create the frame (or retrieve it)
            if x.framesByName[frameName] then
                f = x.framesByName[frameName]
            else
                f = CreateFrame(
                    "ScrollingMessageFrame",
                    "xCT_Plus" .. frameName .. "Frame",
                    UIParent,
                    "BackdropTemplate"
                )
                f:SetSpacing(2)
                f:ClearAllPoints()
                f:SetMovable(true)
                f:SetResizable(true)
                --f:SetMinResize(64, 32)
                --f:SetMaxResize(768, 768)
                f:SetClampedToScreen(true)
                f:SetShadowColor(0, 0, 0, 0)

                f.sizing = CreateFrame("Frame", "xCT_Plus" .. frameName .. "SizingFrame", f)
                f.sizing.parent = f
                f.sizing:SetHeight(16)
                f.sizing:SetWidth(16)
                f.sizing:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 1)
                f.sizing:Hide()

                f.moving = CreateFrame("Frame", "xCT_Plus" .. frameName .. "MovingFrame", f)
                f.moving.parent = f
                f.moving:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1)
                f.moving:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -21)
                f.moving:SetHeight(20)
                f.moving:Hide()

                x.framesByName[frameName] = f
            end

            f.frameName = frameName
            f.settings = frameSettings

            -- Frame Strata
            if x.configuring then
                f:SetFrameStrata("FULLSCREEN_DIALOG")
            else
                f:SetFrameStrata(string.sub(x.db.profile.frameSettings.frameStrata, 2))
            end

            -- Set the position
            if frameSettings.enabledFrame then
                f:SetWidth(frameSettings.Width)
                f:SetHeight(frameSettings.Height)

                -- WoW's default movement from changing the anchor
                local point, relativeTo, relativePoint, xOfs, yOfs =
                    unpack(f:GetNumPoints() > 0 and { f:GetPoint(0) } or {})

                -- If the point is not center, then something dirty happened... clean it up
                if point and point ~= "CENTER" then
                    -- Calculate the center of the screen
                    local ResX, ResY = GetScreenWidth(), GetScreenHeight()
                    local midX, midY = ResX / 2, ResY / 2

                    -- Calculate the Top/Left of a frame relative to the center
                    local left, top = math.floor(f:GetLeft() - midX + 0.5), math.floor(f:GetTop() - midY + 0.5)

                    -- Calculate get the center of the screen from the left/top
                    local pointX = math.floor(left + (f:GetWidth() / 2) + 0.5)
                    local pointY = math.floor(top - (f:GetHeight() / 2) + 0.5)

                    f:ClearAllPoints()
                    f:SetPoint("CENTER", pointX, pointY)
                else
                    f:ClearAllPoints()
                    f:SetPoint("CENTER", frameSettings.X, frameSettings.Y)
                end
            end

            -- For keeping the frame on the screen
            --f:SetClampRectInsets(0, 0, settings.fontSize, 0)

            -- Frame Alpha
            --f:SetAlpha(settings.alpha / 100)

            -- NOTE: Setting the frame alpha this way still works... but it
            -- doesn't apply to string texture children. FontString:SetAlpha
            -- still works normally. Added bonus of not fading the frame
            -- when we are configuring.

            -- Insert Direction
            if frameSettings.insertText then
                f:SetInsertMode(
                    frameSettings.insertText == "top" and SCROLLING_MESSAGE_FRAME_INSERT_MODE_TOP
                        or SCROLLING_MESSAGE_FRAME_INSERT_MODE_BOTTOM
                )
            end

            -- Font Template
            local outline = string.sub(frameSettings.fontOutline, 2)

            if outline == "NONE" then
                f:SetFont(LSM:Fetch("font", frameSettings.font), frameSettings.fontSize, "")
            else
                f:SetFont(LSM:Fetch("font", frameSettings.font), frameSettings.fontSize, outline)
            end

            if frameSettings.fontJustify then
                f:SetJustifyH(frameSettings.fontJustify)
            end

            -- Special Cases
            if frameName == "class" then
                f:SetMaxLines(1)
                f:SetFading(false)
            else
                -- scrolling
                if frameSettings.enableScrollable then
                    f:SetMaxLines(frameSettings.scrollableLines)
                    if not frameSettings.scrollableInCombat then
                        if InCombatLockdown() then
                            x:DisableFrameScrolling(frameName)
                        else
                            x:EnableFrameScrolling(frameName)
                        end
                    else
                        x:EnableFrameScrolling(frameName)
                    end
                else
                    f:SetMaxLines(math.max(1, math.floor(frameSettings.Height / frameSettings.fontSize) - 1)) --- shhhhhhhhhhhhhhhhhhhh
                    x:DisableFrameScrolling(frameName)
                end
            end

            -- fading
            if frameSettings.enableCustomFade then
                f:SetFading(frameSettings.enableFade)
                f:SetFadeDuration(frameSettings.fadeTime)
                f:SetTimeVisible(frameSettings.visibilityTime)
            else
                f:SetFading(true)
                f:SetTimeVisible(3)
            end

            if frameSettings.enableFontShadow then
                f:SetShadowColor(unpack(frameSettings.fontShadowColor))
                f:SetShadowOffset(frameSettings.fontShadowOffsetX, frameSettings.fontShadowOffsetY)
            else
                f:SetShadowColor(0, 0, 0, 0)
            end

            if frameSettings.enabledFrame then
                f:Show()
            else
                f:Hide()
            end
        end
    end
end

function x:EnableFrameScrolling(framename)
    local f = x.framesByName[framename]
    f:EnableMouseWheel(true)
    f:SetScript("OnMouseWheel", Frame_OnMouseWheel)
end

function x:DisableFrameScrolling(framename)
    local f = x.framesByName[framename]
    f:EnableMouseWheel(false)
    f:SetScript("OnMouseWheel", nil)
end

-- =====================================================
-- AddOn:Clear(
--        specificFrame,    [string] - (Optional) the framename
--    )
--        If you specify a specificFrame then only that
--    frame will be cleared of its text, otherwise all
--    the frames will be cleared.
-- =====================================================
function x:Clear(specificFrame)
    if not specificFrame then
        for framename in pairs(x.db.profile.frames) do
            local frame = x:GetFrame(framename)
            if frame then -- attempt to fix login 'attempt to index nil value frame' error
                frame:Clear()
            end
        end
    else
        x:GetFrame(specificFrame):Clear()
    end
end

-- =====================================================
-- AddOn:Abbreviate(
--      amount,     [int]    - the amount to abbreviate
--      frameName*, [string] - (optional) the name of the frame whose settings we need to check.
-- )
--
-- Abbreviates the specified amount. Will also check the current settings profile if a name frame is specified.
-- =====================================================
function x:Abbreviate(amount, frameName)
    local roundNumber = function(value)
        return math.floor(value + 0.5)
    end

    local isNegative = amount < 0
    if isNegative then
        amount = math.abs(amount)
    end

    local message = tostring(amount)

    if frameName and self.db.profile.frames[frameName] and self.db.profile.frames[frameName].megaDamage then
        local suffix = ""
        if self.db.profile.spells.formatAbbreviate then
            if x.locale == "koKR" then
                if amount >= 100000000 then
                    suffix = self.db.profile.megaDamage.billionSymbol
                    amount = amount / 100000000
                elseif amount >= 10000 then
                    suffix = self.db.profile.megaDamage.millionSymbol
                    amount = amount / 10000
                elseif amount >= 1000 then
                    suffix = self.db.profile.megaDamage.thousandSymbol
                    amount = amount / 1000
                end
            else
                if amount >= 1000000000 then
                    suffix = self.db.profile.megaDamage.billionSymbol
                    amount = amount / 1000000000
                elseif amount >= 1000000 then
                    suffix = self.db.profile.megaDamage.millionSymbol
                    amount = amount / 1000000
                elseif amount >= 1000 then
                    suffix = self.db.profile.megaDamage.thousandSymbol
                    amount = amount / 1000
                end
            end

            if self.db.profile.megaDamage.decimalPoint then
                message = tostring(roundNumber(amount * 10) / 10) .. suffix
            else
                message = tostring(roundNumber(amount)) .. suffix
            end
        else
            local k
            while true do
                message, k = string.gsub(message, "^(-?%d+)(%d%d%d)", "%1,%2")
                if k == 0 then
                    break
                end
            end
        end
    end

    if isNegative then
        message = "-" .. message
    end

    return message
end

-- =====================================================
-- AddOn:AddMessage(
--        frameName,  [string] - the framename
--        message,    [string] - the pre-formatted message to be sent
--        colorName,  [string or table] - the name of the color OR a
--                                        table containing the color
--                                        e.g. colorname={1,2,3} --r=1,g=2,b=3
--    )
--        Sends a message to the framename specified.
-- =====================================================
function x:AddMessage(frameName, message, colorName)
    local frame = x:GetFrame(frameName, true)
    local frameSettings = x.db.profile.frames[frameName]

    -- Make sure we have a valid frame
    if not frameSettings or not frame then
        x:Print("Frame not found", frameName)
        return
    end

    -- Load the color
    local r, g, b = 1, 1, 1
    if type(colorName) == "table" then
        -- unpack({0, 0, 1}) leads to OOM... idk why?!
        r, g, b = colorName[1], colorName[2], colorName[3]
    else
        local color = x:LookupColorByName(colorName)
        if color then
            r, g, b = color[1], color[2], color[3]
        else
            x:Print("There is no color named", colorName)
            error("missing color")
        end
    end

    if not frameSettings.enabledFrame then
        if not frameSettings.secondaryFrame or frameSettings.secondaryFrame == 0 then
            -- Neither the frame nor the secondary frame is enabled
            return nil
        end

        -- Overwrite the output frame
        frameName = x.framesById[frameSettings.secondaryFrame]
        frameSettings = x.db.profile.frames[frameName]

        if not frameSettings.enabledFrame then
            return nil
        end

        frame = x:GetFrame(frameName, true)
    end

    -- check for forced color
    if frameSettings.customColor and frameSettings.fontColor then
        r, g, b = frameSettings.fontColor[1], frameSettings.fontColor[2], frameSettings.fontColor[3]
    end

    frame:AddMessage(message, r, g, b)
end

--[=====================================================[
 AddOn:GetSpellTextureFormatted(
    spellID,          [number] - The spell ID you want the icon for
    message,          [string] - The message that will be used (usually the amount)
    frameSettings,     [table] - The settings of the frame
    strColor,         [string] - the color to be used or defaults white
    mergeCount        [number] - The number of events merged into this message
  )
  Returns:
    message,     [string] - the message contains the formatted icon

    Formats an icon quickly for use when outputting to a combat text frame.
--]=====================================================]
function x:GetSpellTextureFormatted(spellId, message, frameSettings, iconSize, strColor, mergeCount)
    iconSize = iconSize or frameSettings.iconsEnabled and frameSettings.iconsSize or -1
    local showInvisibleIcon = frameSettings.spacerIconsEnabled
    local justify = frameSettings.fontJustify

    strColor = strColor or "ffffff"

    local icon = x.BLANK_ICON
    if iconSize >= 1 then
        -- always show unless we specify enableIcons to be off (overriding iconSize to be -1)
        showInvisibleIcon = true

        if spellId == 0 then
            icon = PET_ATTACK_TEXTURE
        elseif type(spellId) == "string" then
            icon = spellId
        else
            icon = spellId and C_Spell.GetSpellTexture(addon.replaceSpellId[spellId] or spellId) or x.BLANK_ICON
        end
    end

    message = message or ""

    if mergeCount and mergeCount > 1 then
        message = string.format("%s |cff%sx%d|r", message, strColor, mergeCount)
    end

    if showInvisibleIcon then
        local iconStr = string.format("|T%s:%d:%d:0:0:64:64:5:59:5:59|t", icon, iconSize, iconSize)
        if justify == "LEFT" then
            message = iconStr .. " " .. message
        else
            message = message .. " " .. iconStr
        end
    end

    if x.enableMergerDebug then
        message = message .. " |cffFFFFFF[|cffFF0000ID:|r|cffFFFF00" .. (spellId or "No ID") .. "|r]|r"
    end

    return message
end

-- WoW - Battle for Azeroth doesn't support fading textures with SetAlpha?
-- We have to do it on a font string level
local ScrollingMessageFrame_OverrideAlpha_Worker = CreateFrame("FRAME")
ScrollingMessageFrame_OverrideAlpha_Worker:SetScript("OnUpdate", function()
    local now2, alpha, scale = GetTime()
    for _, frame in pairs(x.framesByName) do
        alpha = frame.settings.alpha / 100

        -- Only run on frames that have a custom alpha
        if alpha ~= 1 then
            -- Loop through each fontstring
            for _, visibleLine in ipairs(frame.visibleLines) do
                if visibleLine.messageInfo then -- Check for valid font strings (not released)
                    -- Keep the default fading, we will use their value to scale the custom alpha
                    scale = frame:CalculateLineAlphaValueFromTimestamp(
                        now2,
                        math.max(visibleLine.messageInfo.timestamp, frame.overrideFadeTimestamp)
                    )

                    -- If we are fading the message away and fading is enabled
                    if scale ~= 1 and frame:CanEffectivelyFade() then
                        visibleLine:SetAlpha(alpha * scale) -- Fade the font string, scaled for the custom amount

                    -- Only change the font string's alpha if it didn't already change
                    elseif visibleLine:GetAlpha() ~= alpha then
                        visibleLine:SetAlpha(alpha)
                    end
                end
            end
        end
    end
end)

-- =====================================================
-- AddOn:AddSpamMessage(
--     framename,      [string]              - the frame's name
--     mergeId,        [number or string]    - identity items to merge, if number then it HAS TO BE the valid spell ID
--     message,        [number or string]    - the pre-formatted message to be sent, if its not a number, then only the
--                                             first 'message' value that is sent this mergeId will be used.
--     colorName,      [string or table]     - the name of the color OR a table containing the color
--                                             (e.g. {1,2,3} -- r=1, b=2, g=3)
--     interval,       [number]              - the merge interval
--     additionalInfo, [nil or table]        - additional infos for this message
-- )
-- Sends a message to the framename specified.
-- =====================================================
function x:AddSpamMessage(frameName, mergeId, message, colorName, interval, additionalInfo)
    -- Check for a Secondary Spell ID
    mergeId = addon.replaceSpellId[mergeId] or mergeId

    local db = addon.merges[mergeId]

    -- How many seconds are we delaying the output / merging the events?
    interval = interval or (db and db.interval) or x.db.profile.spells.mergeEverythingInterval

    local heap, stack = x.spamMergerHeap[frameName], x.spamMergerStack[frameName]
    if heap[mergeId] then
        heap[mergeId].color = colorName
        heap[mergeId].update = interval

        if tonumber(message) then
            heap[mergeId].mergedAmount = heap[mergeId].mergedAmount + tonumber(message)
        else
            heap[mergeId].message = message
        end

        heap[mergeId].mergedCount = heap[mergeId].mergedCount + 1

        if heap[mergeId].displayTime <= now then
            heap[mergeId].displayTime = now + interval
        end

        if additionalInfo then
            heap[mergeId].args = additionalInfo
        end
    else
        heap[mergeId] = {
            -- after this time we display it on the frame
            displayTime = now + interval,

            -- how often to update
            update = interval,

            -- merged entries
            mergedAmount = 0,
            mergedCount = 1,

            -- color
            color = colorName,
        }

        if tonumber(message) then
            heap[mergeId].mergedAmount = heap[mergeId].mergedAmount + tonumber(message)
        else
            heap[mergeId].message = message
        end

        if additionalInfo then
            heap[mergeId].args = additionalInfo
        end

        -- Insert into the stack - thats our queue for the display!
        table.insert(stack, mergeId)
    end
end

--[================================================================[
             _____ _______                           ____
            / ____|__   __|                         |___ \
      __  _| |       | |_| |_      __   _____ _ __    __) |
      \ \/ / |       | |_   _|     \ \ / / _ \ '__|  |__ <
       >  <| |____   | | |_|        \ V /  __/ |_    ___) |
      /_/\_\\_____|  |_|             \_/ \___|_(_)  |____/

   ___ _ __   __ _ _ __ ___    _ __ ___   ___ _ __ __ _  ___ _ __
  / __| '_ \ / _` | '_ ` _ \  | '_ ` _ \ / _ \ '__/ _` |/ _ \ '__|
  \__ \ |_) | (_| | | | | | | | | | | | |  __/ | | (_| |  __/ |
  |___/ .__/ \__,_|_| |_| |_| |_| |_| |_|\___|_|  \__, |\___|_|
      | |                                          __/ |
      |_|                                         |___/

    This is the new spam merger.  Here is how it works:
    On each OnUpdate (at 60 FPS this happens 60 times per second):
        + Go to the current xCT-frame (one frame at a time)
            - Go through the whole stack of this xCT-frame
                + if a spell entry says its time to display, then display it
                + if not, then skip it
        + Advance our frame index so that we use the next frame next time.
        + Wait for next Update

        As you can see, I only update one xCT-Frame per OnUpdate.

        As of 4.9.0 we're displaying all waiting messages per OnUpdate instead of just one message.
        I am hoping that the spell merger will (still) be mostly invisible.

  ]================================================================]

do
    -- We want to display messages for one frame on each update
    local currentFrameId = 1

    function x.OnSpamUpdate(_, elapsed)
        if not x.db then
            return
        end

        -- Update 'now'
        now = now + elapsed

        -- Check to see if we are out of bounds
        if currentFrameId > #x.framesById then
            currentFrameId = 1
        end

        local frameName = x.framesById[currentFrameId]

        local heap, stack, frameSettings =
            x.spamMergerHeap[frameName], -- the heap contains merge entries
            x.spamMergerStack[frameName], -- the stack contains lookup values
            x:GetFrameSettings(frameName) -- this frame's settings

        -- If the frame is not enabled, then dont even worry about it
        if not frameSettings then
            currentFrameId = currentFrameId + 1
            return
        end

        for _, mergeId in pairs(stack) do
            -- This has all the information for the message we want to display
            local item = heap[mergeId]

            if item and item.displayTime <= now and item.mergedCount > 0 then
                item.displayTime = now

                if not item.mergedAmount and not item.message then
                    -- How did this happen?!
                    x:Print("Empty item in the spam merger", mergeId)
                    DevTools_Dump(item)

                    item.mergedCount = 0
                    item.mergedAmount = 0
                    item.message = ""
                    item.args = nil
                elseif frameName == "outgoing" or frameName == "outgoing_healing" then
                    -- Outgoing damage
                    if not item.message and x:Options_Filter_OutgoingDamage_HideEvent(item.mergedAmount) then
                        -- not enough to display
                        item.mergedCount = 0
                        item.mergedAmount = 0
                        item.message = ""
                        item.args = nil
                    end
                elseif frameName == "critical" then
                    -- Outgoing damage and healing crits
                    if not item.message and x:Options_Filter_OutgoingDamage_HideEvent(item.mergedAmount, true) then
                        -- not enough to display
                        item.mergedCount = 0
                        item.mergedAmount = 0
                        item.message = ""
                        item.args = nil
                    end
                elseif frameName == "healing" then
                    -- Incoming healing
                    if not item.message and x:Options_Filter_IncomingHealing_HideEvent(item.mergedAmount) then
                        -- not enough to display
                        item.mergedCount = 0
                        item.mergedAmount = 0
                        item.message = ""
                        item.args = nil
                    end
                elseif frameName == "damage" then
                    -- Incoming damage
                    if not item.message and x:Options_Filter_IncomingDamage_HideEvent(item.mergedAmount) then
                        -- not enough to display
                        item.mergedCount = 0
                        item.mergedAmount = 0
                        item.message = ""
                        item.args = nil
                    end
                end

                if item.mergedCount > 0 then
                    -- total as a string
                    local message
                    if tonumber(item.mergedAmount) and item.mergedAmount ~= 0 then
                        message = x:Abbreviate(tonumber(item.mergedAmount), frameName)
                    else
                        message = item.message
                    end

                    local strColor = "ffffff"
                    if frameName == "healing" or frameName == "outgoing_healing" then
                        strColor = "ffff00"
                    end

                    -- Add critical Prefix and Postfix
                    if frameName == "critical" then
                        message = string.format("%s%s%s", frameSettings.critPrefix, message, frameSettings.critPostfix)
                    end

                    if item.args and item.args.controller and frameSettings.names[item.args.controller].nameType > 0 then
                        if frameSettings.fontJustify == "RIGHT" then
                            message = x:formatName(item.args, frameSettings.names, item.args.useSource) .. " " .. message
                        else
                            message = message .. x:formatName(item.args, frameSettings.names, item.args.useSource)
                        end
                    end

                    -- Add Icons
                    local iconSize
                    if mergeId == 6603 and not x:ShowAutoAttackIcons(frameName) then
                        -- Disable the auto attack icon for the incoming damage frame
                        iconSize = -1
                    end

                    message = x:GetSpellTextureFormatted(
                        mergeId,
                        message,
                        frameSettings,
                        iconSize,
                        strColor,
                        item.mergedCount
                    )

                    x:AddMessage(frameName, message, item.color)

                    -- Clear all the old amounts, we dont need them anymore
                    item.mergedCount = 0
                    item.mergedAmount = 0
                    item.message = ""
                    item.args = nil
                end
            end
        end

        -- Advance to the next frame
        currentFrameId = currentFrameId + 1
    end

    x.spamMergerFrame = CreateFrame("FRAME")
    x.spamMergerFrame:SetScript("OnUpdate", x.OnSpamUpdate)
end

local function Frame_Sizing_OnUpdate(self)
    local settings = self.parent.settings
    local width, height = math.floor(self.parent:GetWidth() + 0.5), math.floor(self.parent:GetHeight() + 0.5)
    self.parent.width:SetText(width)
    self.parent.height:SetText(height)

    self.parent:SetMaxLines(math.floor(height / settings.fontSize) - 1)
end

local function Frame_Moving_OnUpdate(self)
    -- Calculate get the center of the screen from the left/top
    local posX = math.floor(math.floor(self.parent:GetLeft() - GetScreenWidth() / 2 + 0.5))
    local posY = math.floor(math.floor(self.parent:GetTop() - GetScreenHeight() / 2 + 0.5))

    -- Set the position of the frame
    self.parent.position:SetText(string.format("%d, %d", posX, posY))
end

local function Frame_Sizing_OnMouseDown(self, button)
    if button == "LeftButton" then
        self.parent:StartSizing()
        self:SetScript("OnUpdate", Frame_Sizing_OnUpdate)
        self.isMoving = true
    end
end

local function Frame_Sizing_OnMouseUp(self, button)
    if button == "LeftButton" and self.isMoving then
        self.parent:StopMovingOrSizing()
        self:SetScript("OnUpdate", nil)
        self.isMoving = false
    end
end

local function Frame_Moving_OnMouseDown(self, button)
    if button == "LeftButton" then
        self.parent:StartMoving()
        self:SetScript("OnUpdate", Frame_Moving_OnUpdate)
        self.isMoving = true
    end
end

local function Frame_Moving_OnMouseUp(self, button)
    if button == "LeftButton" and self.isMoving then
        self.parent:StopMovingOrSizing()
        self:SetScript("OnUpdate", nil)
        self.isMoving = false
    end
end

local function Frame_MouseEnter(self)
    if x.db.profile.frameSettings.showPositions then
        if self.width then
            self.width:Show()
            self.height:Show()
            self.position:Show()
        else
            self.parent.width:Show()
            self.parent.height:Show()
            self.parent.position:Show()
        end
    end
end

local function Frame_MouseLeave(self)
    if self.width then
        self.width:Hide()
        self.height:Hide()
        self.position:Hide()
    else
        self.parent.width:Hide()
        self.parent.height:Hide()
        self.parent.position:Hide()
    end
end

-- Starts the "config mode" so that you can move the frames
function x.StartConfigMode()
    x.configuring = true

    for framename, settings in pairs(x.db.profile.frames) do
        if settings.enabledFrame then
            local f = x:GetFrame(framename)

            f:SetBackdrop({
                bgFile = "Interface/Tooltips/UI-Tooltip-Background",
                edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
                tile = false,
                tileSize = 0,
                edgeSize = 2,
                insets = { left = 0, right = 0, top = 0, bottom = 0 },
            })

            f:SetBackdropColor(0.1, 0.1, 0.1, 0.8)
            f:SetBackdropBorderColor(0.1, 0.1, 0.1, 0.5)

            -- Show the sizing and moving frames
            f.sizing:Show()
            f.moving:Show()

            -- Frame Title
            f.title = f:CreateFontString(nil, "OVERLAY")
            f.title:SetPoint("BOTTOM", f, "TOP", 0, -18)
            f.title:SetFont(LSM:Fetch("font", "Condensed Bold (xCT+)"), 15, "OUTLINE")
            f.title:SetText(x.frameTitles[framename])

            -- Size Text
            f.width = f:CreateFontString(nil, "OVERLAY")
            f.width:SetTextColor(0.47, 0.55, 0.87, 1)
            f.width:SetPoint("TOP", f, "BOTTOM", 0, -2)
            f.width:SetFont(LSM:Fetch("font", "Condensed Bold (xCT+)"), 18, "OUTLINE")
            f.width:SetText(math.floor(f:GetWidth() + 0.5))
            f.width:Hide()

            f.height = f:CreateFontString(nil, "OVERLAY")
            f.height:SetTextColor(0.47, 0.55, 0.87, 1)
            f.height:SetPoint("LEFT", f, "RIGHT", 4, 0)
            f.height:SetFont(LSM:Fetch("font", "Condensed Bold (xCT+)"), 18, "OUTLINE")
            f.height:SetText(math.floor(f:GetHeight() + 0.5))
            f.height:Hide()

            -- Calculate get the center of the screen from the left/top
            local posX = math.floor(math.floor(f:GetLeft() - GetScreenWidth() / 2 + 0.5))
            local posY = math.floor(math.floor(f:GetTop() - GetScreenHeight() / 2 + 0.5))

            -- Position Text
            f.position = f:CreateFontString(nil, "OVERLAY")
            f.position:SetTextColor(1, 1, 0, 1)
            f.position:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 4)
            f.position:SetFont(LSM:Fetch("font", "Condensed Bold (xCT+)"), 18, "OUTLINE")
            f.position:SetText(string.format("%d, %d", posX, posY))
            f.position:Hide()

            f.moving.d = f:CreateTexture(nil, "OVERLAY")
            f.moving.d:SetPoint("TOPLEFT", f, "TOPLEFT", 1, -1)
            f.moving.d:SetPoint("TOPRIGHT", f, "TOPRIGHT", -1, -19)
            f.moving.d:SetHeight(20)
            f.moving.d:SetVertexColor(0.3, 0.3, 0.3)
            f.moving.d:SetTexture("Interface\\BUTTONS\\WHITE8X8.blp")
            f.moving.d:SetAlpha(0.6)

            f.sizing.d = f.sizing:CreateTexture("ARTWORK")
            f.sizing.d:SetHeight(16)
            f.sizing.d:SetWidth(16)
            f.sizing.d:SetPoint("BOTTOMRIGHT", f, "BOTTOMRIGHT", -1, 1)
            f.sizing.d:SetVertexColor(0.3, 0.3, 0.3)
            f.sizing.d:SetTexture("Interface\\BUTTONS\\WHITE8X8.blp")
            f.sizing.d:SetAlpha(0.6)

            -- Frame Settings
            f:SetScript("OnEnter", Frame_MouseEnter)
            f:SetScript("OnLeave", Frame_MouseLeave)

            -- Moving Settings
            f.moving:EnableMouse(true)
            f.moving:RegisterForDrag("LeftButton")
            f.moving:SetScript("OnMouseDown", Frame_Moving_OnMouseDown)
            f.moving:SetScript("OnMouseUp", Frame_Moving_OnMouseUp)
            f.moving:SetScript("OnEnter", Frame_MouseEnter)
            f.moving:SetScript("OnLeave", Frame_MouseLeave)

            -- Resizing Settings
            f.sizing:EnableMouse(true)
            f.sizing:RegisterForDrag("LeftButton")
            f.sizing:SetScript("OnMouseDown", Frame_Sizing_OnMouseDown)
            f.sizing:SetScript("OnMouseUp", Frame_Sizing_OnMouseUp)
            f.sizing:SetScript("OnEnter", Frame_MouseEnter)
            f.sizing:SetScript("OnLeave", Frame_MouseLeave)

            -- TODO: Add option to adjust the number of lines for memory purposes
            -- TODO: Show Alignment Grid

            if framename == "class" then
                f.sizing.d:Hide()
                f.sizing:Hide()
            end

            f:SetFrameStrata("FULLSCREEN_DIALOG")
        end
    end
end

function x:EndConfigMode()
    x.configuring = false
    if x.AlignGrid then
        x.AlignGrid:Hide()
    end

    for framename, settings in pairs(x.db.profile.frames) do
        if settings.enabledFrame then
            local f = x:GetFrame(framename)

            f:SetBackdrop(nil)

            -- Remove Scripts
            f:SetScript("OnEnter", nil)
            f:SetScript("OnLeave", nil)

            f.moving:SetScript("OnMouseDown", nil)
            f.moving:SetScript("OnMouseUp", nil)
            f.moving:SetScript("OnEnter", nil)
            f.moving:SetScript("OnLeave", nil)

            f.sizing:SetScript("OnMouseDown", nil)
            f.sizing:SetScript("OnMouseUp", nil)
            f.sizing:SetScript("OnEnter", nil)
            f.sizing:SetScript("OnLeave", nil)

            -- Clean up visual items
            if f.title then
                f.title:Hide()
                f.title = nil
            end

            if f.moving.d then
                f.moving.d:Hide()
                f.moving.d = nil
            end

            if f.sizing.d then
                f.sizing.d:Hide()
                f.sizing.d = nil
            end

            if f.position then
                f.position:Hide()
                f.position = nil
            end

            if f.width then
                f.width:Hide()
                f.width = nil
            end

            if f.height then
                f.height:Hide()
                f.height = nil
            end

            f:EnableMouse(false)

            -- Hide the sizing frame
            f.sizing:EnableMouse(false)
            f.sizing:Hide()

            -- Hide the moving frame
            f.moving:EnableMouse(false)
            f.moving:Hide()

            -- Set the Frame Strata
            f:SetFrameStrata(string.sub(x.db.profile.frameSettings.frameStrata, 2))
        end
    end

    collectgarbage()
end

function x.ToggleConfigMode()
    if x.configuring then
        return
    else
        -- Close the Options Dialog if it is Open
        -- Because this could be called fromt the UI, we need to wait
        x:HideConfigTool(true)

        -- Thanks Elv :)
        GameTooltip:Hide() -- Just in case you're mouseover'ed something and it closes.

        StaticPopup_Show("XCT_PLUS_CONFIGURING")

        if x.db.profile.frameSettings.showGrid then
            if not x.AlignGrid then
                x:LoadAlignmentGrid()
            end
            x.AlignGrid:Show()
        end

        x.StartConfigMode()
    end
end

function x:SaveAllFrames()
    for framename, settings in pairs(x.db.profile.frames) do
        local frame = x.framesByName[framename]
        -- If frame is disabled, trying to calculate position will fail
        if settings.enabledFrame then
            local width = frame:GetWidth()
            local height = frame:GetHeight()

            settings.Width = math.floor(width + 0.5)
            settings.Height = math.floor(height + 0.5)

            -- Calculate the center of the screen
            local ResX, ResY = GetScreenWidth(), GetScreenHeight()
            local midX, midY = ResX / 2, ResY / 2

            -- Calculate the Top/Left of a frame relative to the center
            local left, top = math.floor(frame:GetLeft() - midX + 0.5), math.floor(frame:GetTop() - midY + 0.5)

            -- Calculate get the center of the screen from the left/top
            settings.X = math.floor(left + (width / 2) + 0.5)
            settings.Y = math.floor(top - (height / 2) + 0.5)
        end
    end
end

local colors = { "1", "2", "4", "8", "16", "32", "64" }
local function GetRandomSpellColor()
    local color = colors[math.random(7)]
    return x.db.profile.SpellColors[color].color or x.db.profile.SpellColors[color].default
end

-- Gets a random spell icon that is NOT an engineering cog wheel
local function GetRandomSpellID()
    local icon, spellID
    repeat
        spellID = math.random(100, 80000)
        icon = C_Spell.GetSpellTexture(spellID)
    until icon and icon ~= 136243
    return spellID
end

function x.TestMoreUpdate(self, elapsed)
    if InCombatLockdown() then
        self:SetScript("OnUpdate", nil)
    else
        self.lastUpdate = self.lastUpdate + elapsed

        if not self.nextUpdate then
            self.nextUpdate = math.random(80, 600) / 1000
        end

        if self.nextUpdate < self.lastUpdate then
            self.nextUpdate = nil
            self.lastUpdate = 0

            if self == x.framesByName.general and math.random(3) % 3 == 0 then
                local outputFrame, color = "general", { math.random(255) / 255, math.random(255) / 255, math.random(255) / 255 }
                if not x.db.profile.frames[outputFrame].enabledFrame then
                    x:Clear(outputFrame)
                    if x.db.profile.frames[outputFrame].secondaryFrame ~= 0 then
                        outputFrame = x.framesById[x.db.profile.frames[outputFrame].secondaryFrame]
                    else
                        return
                    end
                end
                if x.db.profile.frames[outputFrame].customColor then
                    color = x.db.profile.frames[outputFrame].fontColor
                end
                x:AddMessage(outputFrame, COMBAT_TEXT_LABEL, color)
            elseif self == x.framesByName.outgoing then
                local outputFrame, color = "outgoing", GetRandomSpellColor()
                if not x.db.profile.frames[outputFrame].enabledFrame then
                    x:Clear(outputFrame)
                    if x.db.profile.frames[outputFrame].secondaryFrame ~= 0 then
                        outputFrame = x.framesById[x.db.profile.frames[outputFrame].secondaryFrame]
                    else
                        return
                    end
                end
                local message = x:Abbreviate(math.random(60000), outputFrame)

                local mergeCount = 0
                if x.db.profile.spells.enableMerger and math.random(3) % 3 == 0 then
                    mergeCount = math.random(17) + 1
                end
                if x.db.profile.frames[outputFrame].customColor then
                    color = x.db.profile.frames[outputFrame].fontColor
                end

                message = x:GetSpellTextureFormatted(
                    x.db.profile.frames.outgoing.iconsEnabled and GetRandomSpellID() or -1,
                    message,
                    x.db.profile.frames.outgoing, -- frame settings
                    nil, -- iconSize
                    nil, -- strColor
                    mergeCount -- entries
                )
                x:AddMessage(outputFrame, message, color)
            elseif self == x.framesByName.outgoing_healing then
                local outputFrame, color = "outgoing_healing", GetRandomSpellColor()
                if not x.db.profile.frames[outputFrame].enabledFrame then
                    x:Clear(outputFrame)
                    if x.db.profile.frames[outputFrame].secondaryFrame ~= 0 then
                        outputFrame = x.framesById[x.db.profile.frames[outputFrame].secondaryFrame]
                    else
                        return
                    end
                end
                local message = x:Abbreviate(math.random(60000), outputFrame)

                local mergeCount = 0
                if x.db.profile.spells.enableMerger and math.random(3) % 3 == 0 then
                    mergeCount = math.random(17) + 1
                end
                if x.db.profile.frames[outputFrame].customColor then
                    color = x.db.profile.frames[outputFrame].fontColor
                end

                message = x:GetSpellTextureFormatted(
                    x.db.profile.frames.outgoing.iconsEnabled and GetRandomSpellID() or -1,
                    message,
                    x.db.profile.frames.outgoing, -- frame settings
                    nil, -- iconSize
                    nil, -- strColor
                    mergeCount -- entries
                )
                x:AddMessage(outputFrame, message, color)
            elseif self == x.framesByName.critical and math.random(2) % 2 == 0 then
                local outputFrame, color = "critical", GetRandomSpellColor()
                if not x.db.profile.frames[outputFrame].enabledFrame then
                    x:Clear(outputFrame)
                    if x.db.profile.frames[outputFrame].secondaryFrame ~= 0 then
                        outputFrame = x.framesById[x.db.profile.frames[outputFrame].secondaryFrame]
                    else
                        return
                    end
                end
                local message = x.db.profile.frames.critical.critPrefix
                    .. x:Abbreviate(math.random(60000), outputFrame)
                    .. x.db.profile.frames.critical.critPostfix

                local mergeCount = 0
                if
                    x:Options_SpamMerger_EnableSpamMerger()
                    and (math.random(3) % 3 == 0)
                    and (
                        x:Options_SpamMerger_MergeCriticalsWithOutgoing()
                        or x:Options_SpamMerger_MergeCriticalsByThemselves()
                    )
                then
                    mergeCount = math.random(17) + 1
                end
                if x.db.profile.frames[outputFrame].customColor then
                    color = x.db.profile.frames[outputFrame].fontColor
                end
                message = x:GetSpellTextureFormatted(
                    x.db.profile.frames.critical.iconsEnabled and GetRandomSpellID() or -1, -- spellID
                    message, -- message
                    x.db.profile.frames.critical, -- frame settings
                    nil, -- iconSize
                    nil, -- strColor
                    mergeCount -- entries
                )
                x:AddMessage(outputFrame, message, color)
            elseif self == x.framesByName.damage and math.random(2) % 2 == 0 then
                local outputFrame, color = "damage", { 1, math.random(100) / 255, math.random(100) / 255 }
                if not x.db.profile.frames[outputFrame].enabledFrame then
                    x:Clear(outputFrame)
                    if x.db.profile.frames[outputFrame].secondaryFrame ~= 0 then
                        outputFrame = x.framesById[x.db.profile.frames[outputFrame].secondaryFrame]
                    else
                        return
                    end
                end
                if x.db.profile.frames[outputFrame].customColor then
                    color = x.db.profile.frames[outputFrame].fontColor
                end
                x:AddMessage(outputFrame, "-" .. x:Abbreviate(math.random(100000), "damage"), color)
            elseif self == x.framesByName.healing and math.random(2) % 2 == 0 then
                local outputFrame, color = "healing", { 0.1, ((math.random(3) + 1) * 63) / 255, 0.1 }
                if not x.db.profile.frames[outputFrame].enabledFrame then
                    x:Clear(outputFrame)
                    if x.db.profile.frames[outputFrame].secondaryFrame ~= 0 then
                        outputFrame = x.framesById[x.db.profile.frames[outputFrame].secondaryFrame]
                    else
                        return
                    end
                end
                if x.db.profile.frames[outputFrame].customColor then
                    color = x.db.profile.frames[outputFrame].fontColor
                end
                if COMBAT_TEXT_SHOW_FRIENDLY_NAMES == "1" then
                    local message = UnitName("player")
                    local realm = ""
                    if x.db.profile.frames.healing.enableRealmNames then
                        realm = "-" .. GetRealmName()
                    end
                    if x.db.profile.frames.healing.enableClassNames then
                        message = string.format(
                            "|c%s%s%s|r",
                            RAID_CLASS_COLORS[select(2, UnitClass("player"))].colorStr,
                            message,
                            realm
                        )
                    end
                    if x.db.profile.spells.mergeHealing and math.random(2) % 2 == 0 then
                        message = string.format("%s |cffFFFF00x%s|r", message, math.random(17) + 1)
                    end
                    x:AddMessage(outputFrame, "+" .. x:Abbreviate(math.random(90000), "healing") .. " " .. message, color)
                else
                    x:AddMessage(outputFrame, "+" .. x:Abbreviate(math.random(90000), "healing"), color)
                end
            elseif self == x.framesByName.power and math.random(4) % 4 == 0 then
                local outputFrame = "power"
                if not x.db.profile.frames[outputFrame].enabledFrame then
                    x:Clear(outputFrame)
                    if x.db.profile.frames[outputFrame].secondaryFrame ~= 0 then
                        outputFrame = x.framesById[x.db.profile.frames[outputFrame].secondaryFrame]
                    else
                        return
                    end
                end
                local _, powerToken = UnitPowerType("player")
                local color = { PowerBarColor[powerToken].r, PowerBarColor[powerToken].g, PowerBarColor[powerToken].b }
                if x.db.profile.frames[outputFrame].customColor then
                    color = x.db.profile.frames[outputFrame].fontColor
                end
                x:AddMessage(outputFrame, "+" .. x:Abbreviate(math.random(5000), "power") .. " " .. _G[powerToken], color)
            elseif self == x.framesByName.class and math.random(4) % 4 == 0 then
                local outputFrame = "class"
                if not x.db.profile.frames.class.enabledFrame then
                    x:Clear(outputFrame)
                    return
                end
                if not self.testCombo then
                    self.testCombo = 0
                end
                self.testCombo = self.testCombo + 1
                if self.testCombo > 8 then
                    self.testCombo = 1
                end
                local color = { 1, 0.82, 0 }
                if x.db.profile.frames.class.customColor then
                    color = x.db.profile.frames.class.fontColor
                end
                x:AddMessage(outputFrame, tostring(self.testCombo), color)
            elseif self == x.framesByName.procs and math.random(8) % 8 == 0 then
                local outputFrame = "procs"
                if not x.db.profile.frames[outputFrame].enabledFrame then
                    x:Clear(outputFrame)
                    if x.db.profile.frames[outputFrame].secondaryFrame ~= 0 then
                        outputFrame = x.framesById[x.db.profile.frames[outputFrame].secondaryFrame]
                    else
                        return
                    end
                end
                local color = { 1, 1, 0 }
                if x.db.profile.frames[outputFrame].customColor then
                    color = x.db.profile.frames[outputFrame].fontColor
                end
                x:AddMessage(outputFrame, ERR_SPELL_COOLDOWN, color)
            elseif self == x.framesByName.loot and math.random(8) % 8 == 0 then
                local outputFrame = "loot"
                if not x.db.profile.frames[outputFrame].enabledFrame then
                    x:Clear(outputFrame)
                    if x.db.profile.frames[outputFrame].secondaryFrame ~= 0 then
                        outputFrame = x.framesById[x.db.profile.frames[outputFrame].secondaryFrame]
                    else
                        return
                    end
                end
                local color = { 1, 1, 0 }
                if x.db.profile.frames[outputFrame].customColor then
                    color = x.db.profile.frames[outputFrame].fontColor
                end
                if x.db.profile.frames[outputFrame].colorBlindMoney then
                    local g, s, c, message =
                        math.random(100) % 10 ~= 0 and math.random(100) or nil,
                        math.random(100) % 10 ~= 0 and math.random(100) or nil,
                        math.random(100) % 10 ~= 0 and math.random(100) or nil,
                        ""
                    if g then
                        message = tostring(g) .. "|cffFFD700g|r"
                    end
                    if s then
                        if g then
                            message = message .. " " .. tostring(s) .. "|cffC0C0C0s|r"
                        else
                            message = message .. tostring(s) .. "|cffC0C0C0s|r"
                        end
                    end
                    if c then
                        if s or g then
                            message = message .. " " .. tostring(c) .. "|cffB87333c|r"
                        else
                            message = message .. tostring(c) .. "|cffB87333c|r"
                        end
                    end
                    if not g and not s and not c then
                        return
                    end
                    x:AddMessage(outputFrame, MONEY .. ": " .. message, color)
                else
                    x:AddMessage(
                        outputFrame,
                        MONEY .. ": " .. C_CurrencyInfo.GetCoinTextureString(math.random(1000000)),
                        color
                    )
                end
            end
        end
    end
end

function x.ToggleTestMode(hidePopup)
    if x.configuring then
        return
    else
        if x.testing then
            x:EndTestMode()
        else
            x.testing = true

            -- Start the Test more
            for framename in pairs(x.db.profile.frames) do
                local frame = x:GetFrame(framename)
                frame.nextUpdate = nil
                frame.lastUpdate = 0
                frame:SetScript("OnUpdate", x.TestMoreUpdate)
            end

            -- Test more Popup
            -- Because this could be called fromt the UI, we need to wait
            x:HideConfigTool(true)

            if type(hidePopup) == "boolean" and hidePopup then
                return
            else
                StaticPopup_Show("XCT_PLUS_TESTMODE")
            end
        end
    end
end

function x:EndTestMode()
    x.testing = false

    -- Stop the Test more
    for framename in pairs(x.db.profile.frames) do
        local frame = x:GetFrame(framename)
        frame:SetScript("OnUpdate", nil)
        frame:Clear()
    end

    StaticPopup_Hide("XCT_PLUS_TESTMODE")
end

function x.RestoreAllDefaults()
    LibStub("AceConfigDialog-3.0"):Close(ADDON_NAME)
    GameTooltip:Hide()
    StaticPopup_Show("XCT_PLUS_RESET_SETTINGS")
end

-- Popups
StaticPopupDialogs["XCT_PLUS_CONFIGURING"] = {
    text = "Configuring xCT+\nType: |cffFF0000/xct lock|r to save changes",
    timeout = 0,
    whileDead = 1,

    button1 = SAVE_CHANGES,
    button2 = CANCEL,
    OnAccept = function()
        x:SaveAllFrames()
        x:EndConfigMode()
        x:ShowConfigTool()
        x:Print("Frames have been saved. Please fasten your seat belts.")
    end,
    OnCancel = function()
        x:UpdateFrames()
        x:EndConfigMode()
        x:ShowConfigTool()
    end,
    hideOnEscape = false,

    -- Taint work around
    preferredIndex = 3,
}

StaticPopupDialogs["XCT_PLUS_TESTMODE"] = {
    text = "xCT+ Test Mode",
    timeout = 0,
    whileDead = 1,

    button1 = "Stop",
    OnAccept = function()
        x:EndTestMode()
        x:ShowConfigTool()
    end,
    hideOnEscape = true,

    -- Taint work around
    preferredIndex = 3,
}

StaticPopupDialogs["XCT_PLUS_RESET_SETTINGS"] = {
    text = "Are your certain you want to erase |cffFF0000ALL|r your xCT+ settings?",
    timeout = 0,
    whileDead = 1,

    button1 = "|cffFF0000ERASE ALL!!|r",
    button2 = CANCEL,
    OnAccept = function()
        xCTSavedDB = nil
        ReloadUI()
    end,
    OnCancel = function()
        x:ShowConfigTool()
    end,
    hideOnEscape = true,

    -- Taint work around
    preferredIndex = 3,
}

StaticPopupDialogs["XCT_PLUS_HIDE_IN_COMBAT"] = {
    text = "|cffFFFF00Disable the|r |cff798BDDHide Config in Combat|r|cffFFFF00 feature?|r\n\n\n|cffFF0000WARNING:|r By disabling this protection you risk |cffFF8000tainting|r your UI. In some cases, you will need to type: '|cff798BDD/reload|r' in order to change |cff10FF40glyphs|r or |cff10FF40talents|r and to place |cff10FF40world markers|r.\n",
    timeout = 0,
    whileDead = 1,

    button1 = CONTINUE,
    button2 = REVERT,
    OnCancel = function()
        x.db.profile.hideConfig = true
        -- TODO what are we doing with this?
        x:RefreshConfig()
    end,

    -- Taint work around
    preferredIndex = 3,
}

StaticPopupDialogs["XCT_PLUS_DB_CLEANUP_1"] = {
    text = "|cff798BDDxCT+ Spring Cleaning|r\n\nHello, |cffFFFF00xCT|r|cffFF0000+|r needed to cleanup some |cffFF0000old or removed spell entries|r from the spam merger. |cffFFFF00Those settings needed to be reset|r. The rest of your profile settings |cff22FF44remains the same|r.\n\nSorry for this inconvenience.\n\n",
    timeout = 0,
    whileDead = 1,

    button1 = OKAY .. "!",
    button2 = "Don't Show Again",
    hideOnEscape = true,

    OnCancel = function()
        x.db.global.dontShowDBCleaning = true
    end,

    -- Taint work around
    preferredIndex = 3,
}

StaticPopupDialogs["XCT_PLUS_FORCE_CVAR_UPDATE"] = {
    text = "|cff798BDDxCT+|r performed an action that requires it to update some |cffFFFF00Combat Text|r related |cffFF8000CVars|r. It is |cff20DD40highly recommened|r you reload your UI before changing any more settings.",
    timeout = 0,
    whileDead = 1,

    button1 = "Later",
    button2 = "Reload UI Now",
    OnCancel = ReloadUI,

    -- Taint work around
    preferredIndex = 3,
}

StaticPopupDialogs["XCT_PLUS_SUGGEST_MULTISTRIKE_OFF"] = {
    text = "",
}

StaticPopupDialogs["XCT_PLUS_DB_CLEANUP_2"] = {
    text = "|cffD7DF23xCT+ Legion Clean Up|r\n\nHello Again,\n\n I am sorry to inform you that |cffFFFF00xCT|r|cffFF0000+|r needs to\n\n|cffFF0000COMPLETELY RESET YOUR PROFILE|r\n\n back to the original defaults. \n\nI know this may significantly inconvenience many of you, but after much deliberation, the profile reset is the only way to properly prepare your profile for Legion.\n\n|cffFFFF00We will need to |r|cff798BDDReload Your UI|r|cffFFFF00 after we |cff798BDDReset Your Profile|r|cffFFFF00. Press the button below to continue...\n\n|cffaaaaaa(Your saved vars have NOT been reset yet and you may revert to an older version of xCT+ at this time by simply exiting the game, but that is not recommended)|r",
    timeout = 0,
    whileDead = 1,

    button1 = "Exit WoW",
    button2 = "Reset Profile and Reload UI",

    OnAccept = Quit,
    OnCancel = function()
        x:Print("Resetting UI")
        x:CleanUpForLegion()
    end,

    -- Taint work around
    preferredIndex = 3,
}
