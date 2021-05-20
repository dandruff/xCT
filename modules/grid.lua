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
 [  ©2020. All Rights Reserved.        ]
 [====================================]]

local ADDON_NAME, addon = ...

local mfloor = math.floor

-- Shorten my handle
local x = addon.engine
local AlignGrid

function x:LoadAlignmentGrid()
  AlignGrid = CreateFrame('Frame', nil, UIParent)
  AlignGrid:SetAllPoints(UIParent)
  local boxSize = 32

  -- Get the current screen resolution, Mid-points, and the total number of lines
  local ResX, ResY = mfloor(UIParent:GetWidth() + 0.5), mfloor(UIParent:GetHeight() + 0.5)

  local midX, midY = ResX / 2, ResY / 2
  local iLinesLeftRight, iLinesTopBottom = midX / boxSize , midY / boxSize

  -- Vertical Bars
  for i = 1, iLinesLeftRight do
    -- Vertical Bars to the Left of the Center
    local tt1 = AlignGrid:CreateTexture(nil, 'BACKGROUND')
    tt1:SetTexture("Interface\\BUTTONS\\WHITE8X8.blp")

    if i % 4 == 0 then
        --tt1:SetTexture(.9, .9, .1, .6)
        tt1:SetVertexColor(.9, .9, .1)
        tt1:SetAlpha(.6)
    elseif i % 2 == 0 then
        --tt1:SetTexture(.4, .4, .4, .6)
        tt1:SetVertexColor(.4, .4, .4)
        tt1:SetAlpha(.6)
    else
        --tt1:SetTexture(.4, .4, .4, .4)
        tt1:SetVertexColor(.4, .4, .4)
        tt1:SetAlpha(.4)
    end

    tt1:SetPoint('TOP', AlignGrid, 'TOP', -i * boxSize + 1, 0)
    tt1:SetPoint('BOTTOM', AlignGrid, 'BOTTOM', -i * boxSize + 1, 0)
    tt1:SetWidth(1)

    -- Vertical Bars to the Right of the Center
    local tt2 = AlignGrid:CreateTexture(nil, 'BACKGROUND')
    tt2:SetTexture("Interface\\BUTTONS\\WHITE8X8.blp")

    if i % 4 == 0 then
        --tt2:SetTexture(.9, .9, .1, .6)
        tt2:SetVertexColor(.9, .9, .1)
        tt2:SetAlpha(.6)
    elseif i % 2 == 0 then
        --tt2:SetTexture(.4, .4, .4, .6)
        tt2:SetVertexColor(.4, .4, .4)
        tt2:SetAlpha(.6)
    else
        --tt2:SetTexture(.4, .4, .4, .4)
        tt2:SetVertexColor(.4, .4, .4)
        tt2:SetAlpha(.4)
    end

    tt2:SetPoint('TOP', AlignGrid, 'TOP', i * boxSize + 1, 0)
    tt2:SetPoint('BOTTOM', AlignGrid, 'BOTTOM', i * boxSize + 1, 0)
    tt2:SetWidth(1)
  end

  -- Horizontal Bars
  for i = 1, iLinesTopBottom do
    -- Horizontal Bars to the Below of the Center
    local tt3 = AlignGrid:CreateTexture(nil, 'BACKGROUND')
    tt3:SetTexture("Interface\\BUTTONS\\WHITE8X8.blp")
    if i % 4 == 0 then
        --tt3:SetTexture(.9, .9, .1, .6)
        tt3:SetVertexColor(.9, .9, .1)
        tt3:SetAlpha(.6)
    elseif i % 2 == 0 then
        --tt3:SetTexture(.4, .4, .4, .6)
        tt3:SetVertexColor(.4, .4, .4)
        tt3:SetAlpha(.6)
    else
        --tt3:SetTexture(.4, .4, .4, .4)
        tt3:SetVertexColor(.4, .4, .4)
        tt3:SetAlpha(.4)
    end
    tt3:SetPoint('LEFT', AlignGrid, 'LEFT', 0, -i * boxSize - 1)
    tt3:SetPoint('RIGHT', AlignGrid, 'RIGHT', 0, -i * boxSize - 1)
    tt3:SetHeight(1)

    -- Horizontal Bars to the Above of the Center
    local tt4 = AlignGrid:CreateTexture(nil, 'BACKGROUND')
    tt4:SetTexture("Interface\\BUTTONS\\WHITE8X8.blp")
    if i % 4 == 0 then
        --tt4:SetTexture(.9, .9, .1, .6)
        tt4:SetVertexColor(.9, .9, .1)
        tt4:SetAlpha(.6)
    elseif i % 2 == 0 then
        --tt4:SetTexture(.4, .4, .4, .6)
        tt4:SetVertexColor(.4, .4, .4)
        tt4:SetAlpha(.6)
    else
        --tt4:SetTexture(.4, .4, .4, .4)
        tt4:SetVertexColor(.4, .4, .4)
        tt4:SetAlpha(.4)
    end
    tt4:SetPoint('LEFT', AlignGrid, 'LEFT', 0, i * boxSize - 1)
    tt4:SetPoint('RIGHT', AlignGrid, 'RIGHT', 0, i * boxSize - 1)
    tt4:SetHeight(1)
  end

  --Create the Vertical Middle Bar
  local tta = AlignGrid:CreateTexture(nil, 'BACKGROUND')
  tta:SetTexture("Interface\\BUTTONS\\WHITE8X8.blp")
  --tta:SetTexture(1, 0, 0, .6)
  tta:SetVertexColor(1, 0, 0)
  tta:SetAlpha(.6)
  tta:SetPoint('TOP', AlignGrid, 'TOP', 0, 0)
  tta:SetPoint('BOTTOM', AlignGrid, 'BOTTOM', 0, 0)
  tta:SetWidth(2)

  --Create the Horizontal Middle Bar
  local ttb = AlignGrid:CreateTexture(nil, 'BACKGROUND')
  ttb:SetTexture("Interface\\BUTTONS\\WHITE8X8.blp")
  --ttb:SetTexture(1, 0, 0, .6)
  ttb:SetVertexColor(1, 0, 0)
  ttb:SetAlpha(.6)
  ttb:SetPoint('LEFT', AlignGrid, 'LEFT', 0, 0)
  ttb:SetPoint('RIGHT', AlignGrid, 'RIGHT', 0, 0)
  ttb:SetHeight(2)

  AlignGrid:Hide()

  x.AlignGrid = AlignGrid
end
