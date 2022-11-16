local _G = _G;
local Item = Item;
local C_TradeSkillUI = C_TradeSkillUI;
local PROFESSIONS_MODIFIED_CRAFTING_REAGENT_BASIC = PROFESSIONS_MODIFIED_CRAFTING_REAGENT_BASIC;
local PROFESSIONS_MODIFIED_CRAFTING_REAGENT_OPTIONAL = PROFESSIONS_MODIFIED_CRAFTING_REAGENT_OPTIONAL;

local function handler(tooltip, item)
	if (item:IsItemEmpty()) then
		return;
	end

	item:ContinueOnItemLoad(function()
		local expacID, _, isCraftingReagent = select(15, GetItemInfo(item:GetItemID()));
		if (not isCraftingReagent) then
			return;
		end
	
		local expansionName = _G["EXPANSION_NAME" .. expacID];
		if (not expansionName) then
			return;
		end
	
		local baseKey = tooltip:GetName().."TextLeft";
		for i=1, tooltip:NumLines() do
			local line = _G[baseKey .. i];
			if (line and line:GetObjectType() == "FontString") then
				local text = line:GetText();
				if (text == PROFESSIONS_MODIFIED_CRAFTING_REAGENT_BASIC or text == PROFESSIONS_MODIFIED_CRAFTING_REAGENT_OPTIONAL) then
					line:SetText(("%s (%s)"):format(text, expansionName));
					if (tooltip:IsShown()) then
						tooltip:Show(); -- trigger size update
					end
					return;
				end
			end
		end
	end);
end

local function OnItem(tooltip)
	if (not (tooltip == GameTooltip or tooltip == ItemRefTooltip)) then
		return;
	end

	local _, itemLink = tooltip:GetItem();
	if (itemLink) then
		handler(tooltip, Item:CreateFromItemLink(itemLink));
	end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnItem);

hooksecurefunc(GameTooltip, "SetRecipeReagentItem", function(self, recipeID, reagentIndex)
	local itemLink = C_TradeSkillUI.GetRecipeFixedReagentItemLink(recipeID, reagentIndex);
	handler(self, Item:CreateFromItemLink(itemLink));
end);
