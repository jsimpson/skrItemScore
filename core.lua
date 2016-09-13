local GameTooltip = GameTooltip
local ItemRefTooltip = ItemRefTooltip
local ShoppingTooltip1 = ShoppingTooltip1
local ShoppingTooltip2 = ShoppingTooltip2
local UnitClass = UnitClass
local GetSpecialization = GetSpecialization
local GetItemInfo = GetItemInfo
local GetItemStats = GetItemStats

local itemIdentifiers = {
  ['agi'] = 'ITEM_MOD_AGILITY_SHORT',
  ['crit'] = 'ITEM_MOD_CRIT_RATING_SHORT',
  ['haste'] = 'ITEM_MOD_HASTE_RATING_SHORT',
  ['int'] = 'ITEM_MOD_INTELLECT_SHORT',
  ['mastery'] = 'ITEM_MOD_MASTERY_RATING_SHORT',
  ['vers'] = 'ITEM_MOD_VERSATILITY_RATING_SHORT',
}

local statWeights = {
  -- Warrior
  [1] = {
    -- Arms
    [1] = {},
    -- Fury
    [2] = {},
    -- Protection
    [3] = {},
  },
  -- Paladin
  [2] = {
    -- Holy
    [1] = {},
    -- Protection
    [2] = {},
    -- Retribution
    [3] = {},
  },
  -- Hunter
  [3] = {
    -- Beastmaster
    [1] = {},
    -- Marksmanship
    [2] = {},
    -- Survival
    [3] = {},
  },
  -- Rogue
  [4] = {
    -- Assassination
    [1] = {
      ['agi'] = 1.0,
      ['crit'] = 0.61,
      ['vers'] = 0.69,
      ['haste'] = 0.27,
      ['mastery'] = 0.29,
    },
    -- Outlaw
    [2] = {
      ['agi'] = 1.0,
      ['crit'] = 0.58,
      ['vers'] = 0.69,
      ['haste'] = 0.49,
      ['mastery'] = 0.54,
    },
    -- Subtlety
    [3] = {
      ['agi'] = 1.0,
      ['crit'] = 0.61,
      ['vers'] = 0.70,
      ['haste'] = 0.38,
      ['mastery'] = 0.65,
    },
  },
  -- Priest
  [5] = {
    -- Discipline
    [1] = {},
    -- Holy
    [2] = {},
    -- Shadow
    [3] = {},
  },
  -- Deathknight
  [6] = {
    -- Blood
    [1] = {},
    -- Frost
    [2] = {},
    -- Unholy
    [3] = {},
  },
  -- Shaman
  [7] = {
    -- Elemental
    [1] = {},
    -- Enhancement
    [2] = {},
    -- Restoration
    [3] = {},
  },
  -- Mage
  [8] = {
    -- Arcane
    [1] = {
      ['crit'] = 0.76,
      ['int'] = 1.0,
      ['vers'] = 0.78,
      ['haste'] = 0.75,
      ['mastery'] = 0.71,
    },
    -- Fire
    [2] = {
      ['crit'] = 1.3,
      ['int'] = 1.0,
      ['vers'] = 0.84,
      ['haste'] = 0.81,
      ['mastery'] = 0.76,
    },
    -- Frost
    [3] = {
      ['crit'] = 0.91,
      ['int'] = 1.0,
      ['vers'] = 0.79,
      ['haste'] = 0.95,
      ['mastery'] = 0.57,
    },
  },
  -- Warlock
  [9] = {
    -- Affliction
    [1] = {},
    -- Chaos
    [2] = {},
    -- Destruction
    [3] = {},
  },
  -- Monk
  [10] = {
    -- Bremaster
    [1] = {},
    -- Mistweaver
    [2] = {},
    -- Windwalker
    [3] = {
      ['agi'] = 1.0,
      ['crit'] = 0.54,
      ['haste'] = 0.46,
      ['mastery'] = 0.62,
      ['vers'] = 0.53,
    },
  },
  -- Druid
  [11] = {
    -- Balance
    [1] = {},
    -- Feral
    [2] = {},
    -- Guardian
    [3] = {},
    -- Restoration
    [4] = {},
  },
  -- Demon Hunter
  [12] = {
    -- Havoc
    [1] = {},
    -- Vengeance
    [2] = {},
  },
}

local classId, specId

local CalculateScore = function(itemStats)
  if not classId or specId then
    classId = select(3, UnitClass('player'))
    specId = GetSpecialization()
  end
  local score = 0
  for stat, mod in pairs(statWeights[classId][specId]) do
    local val = itemStats[itemIdentifiers[stat]]
    if val ~= nil and val ~= 0 then score = score + (val * mod) end
  end
  return score
end

local ItemTooltipHook = function(self, ...)
  local _, link = self:GetItem()
  if not link then return end

  -- Skip artifact weapons
  local _, _, quality = GetItemInfo(link)
  if quality == 6 then return end

  local stats = GetItemStats(link)
  if not stats then return end

  local score = CalculateScore(stats)
  if score == 0 or score == nil then return end

  self:AddLine(" ")
  self:AddLine("|cffffd100Score:|r "..score, 1, 1, 1, 1, 1, 1)
  self:Show()
end

GameTooltip:HookScript("OnTooltipSetItem", ItemTooltipHook)
ItemRefTooltip:HookScript("OnTooltipSetItem", ItemTooltipHook)
ShoppingTooltip1:HookScript("OnTooltipSetItem", ItemTooltipHook)
ShoppingTooltip2:HookScript("OnTooltipSetItem", ItemTooltipHook)
