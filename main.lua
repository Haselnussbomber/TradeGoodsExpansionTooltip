local addonName, addon = ...;
local L = LibStub("AceLocale-3.0"):GetLocale(addonName);

local _G = _G;
local tContains = tContains;
local Item = Item;
local C_TradeSkillUI = C_TradeSkillUI;

local function handler(tooltip, item)
	if (item:IsItemEmpty()) then
		return;
	end

	local itemId = item:GetItemID();
	if (not itemId or itemId == 0) then
		return;
	end

	local expansionName = nil;
	for expansionLevel, expansionItems in pairs(addon.items) do
		if (tContains(expansionItems, itemId)) then
			expansionName = _G["EXPANSION_NAME" .. expansionLevel];
			break;
		end
	end
	if (not expansionName) then
		return;
	end

	local baseKey = tooltip:GetName().."TextLeft";
	for i=1, tooltip:NumLines() do
		local line = _G[baseKey .. i];
		if (line and line:GetObjectType() == "FontString") then
			local text = line:GetText();
			if (text == L["Crafting Reagent"] or text == L["Optional Crafting Reagent"]) then
				line:SetText(L["TOOLTIP_TEXT_FORMAT"]:format(text, expansionName));
				if (tooltip:IsShown()) then
					tooltip:Show(); -- trigger size update
				end
				return;
			end
		end
	end
end

local function handleTooltipSetItem(self)
	local itemName, itemLink = self:GetItem();
	handler(self, Item:CreateFromItemLink(itemLink));
end

GameTooltip:HookScript("OnTooltipSetItem", handleTooltipSetItem);
ItemRefTooltip:HookScript("OnTooltipSetItem", handleTooltipSetItem);

hooksecurefunc(GameTooltip, "SetRecipeReagentItem", function(self, recipeID, reagentIndex)
	local itemLink = C_TradeSkillUI.GetRecipeFixedReagentItemLink(recipeID, reagentIndex);
	handler(self, Item:CreateFromItemLink(itemLink));
end);
