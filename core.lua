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
  ['vers'] = 'ITEM_MOD_VERSATILITY',
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
      ['vers'] = 0.69,
      ['crit'] = 0.61,
      ['mastery'] = 0.29,
      ['haste'] = 0.27,
    },
    -- Outlaw
    [2] = {
      ['agi'] = 1.0,
      ['vers'] = 0.69,
      ['crit'] = 0.58,
      ['mastery'] = 0.54,
      ['haste'] = 0.49,
    },
    -- Subtlety
    [3] = {
      ['agi'] = 1.0,
      ['vers'] = 0.70,
      ['mastery'] = 0.65,
      ['crit'] = 0.61,
      ['haste'] = 0.38,
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
      ['int'] = 1.0,
      ['vers'] = 0.78,
      ['crit'] = 0.76,
      ['haste'] = 0.75,
      ['mastery'] = 0.71,
    },
    -- Fire
    [2] = {
      ['crit'] = 1.3,
      ['int'] = 1.0,
      ['haste'] = 0.81,
      ['int'] = 9.14,
      ['vers'] = 7.48,
      ['haste'] = 6.93,
      ['mastery'] = 7.17,
    },
    -- Frost
    [3] = {
      ['int'] = 1.0,
      ['haste'] = 0.95,
      ['crit'] = 0.91,
      ['vers'] = 0.79,
      ['mastery'] = 0.57,
    },
  },
  -- Warlock
  [9] = {
    -- Affliction
    [1] = {
      ['mastery'] = 1.04,
      ['int'] = 1.0,
      ['haste'] = 0.86,
      ['crit'] = 0.75,
      ['vers'] = 0.60,
    },
    -- Demonology
    [2] = {
      ['haste'] = 1.17,
      ['int'] = 1.0,
      ['crit'] = 0.75,
      ['vers'] = 0.69,
      ['mastery'] = 0.68,
    },
    -- Destruction
    [3] = {
      ['haste'] = 1.24,
      ['int'] = 1.0,
      ['crit'] = 0.85,
      ['vers'] = 0.58,
      ['mastery'] = 0.55,
    },
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
