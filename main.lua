local addonName, addon = ...
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local _G = _G
local tContains = tContains
local Item = Item
local C_TradeSkillUI = C_TradeSkillUI

local function handler(tooltip, item)
	if item:IsItemEmpty() then
		return
	end

	local itemId = item:GetItemID()
	if not itemId or itemId == 0 then
		return
	end

	local expansionName = nil
	for expansionLevel, expansionItems in pairs(addon.items) do
		if tContains(expansionItems, itemId) then
			expansionName = _G["EXPANSION_NAME" .. expansionLevel]
			break
		end
	end
	if not expansionName then
		return
	end

	local baseKey = tooltip:GetName().."TextLeft"
	for i=1, tooltip:NumLines() do
		local line = _G[baseKey .. i]
		if line and line:GetObjectType() == "FontString" then
			local text = line:GetText()
			if text == L["Crafting Reagent"] then
				line:SetText(L["TOOLTIP_TEXT_FORMAT"]:format(text, expansionName))
				return
			end
		end
	end
end

GameTooltip:HookScript("OnTooltipSetItem", function(self)
	local itemLink = self:GetItem()
	handler(self, Item:CreateFromItemLink(itemLink))
end)

hooksecurefunc(GameTooltip, "SetRecipeReagentItem", function(self, recipeID, reagentIndex)
	local itemLink = C_TradeSkillUI.GetRecipeReagentItemLink(recipeID, reagentIndex)
	handler(self, Item:CreateFromItemLink(itemLink))
end)
