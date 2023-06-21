local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local String = "%s: %s / %s"
local Panel

local OnEvent = function(self, event, unit)
	self.text:SetFormattedText(String, HONOR, UnitHonor("player"), UnitHonorMax("player"))

	if (not Panel) then
		Panel = self
	end
end

local OnClick = function()
	PVEFrame_ToggleFrame("PVPUIFrame", "HonorFrame")
end

local OnEnter = function(self)
	DT:SetupTooltip(self)

	local Honor = UnitHonor("player")
	local MaxHonor = UnitHonorMax("player")
	local HonorLevel = UnitHonorLevel("player")
	local NextRewardLevel = _G.C_PvP.GetNextHonorLevelForReward(HonorLevel)
	local RewardInfo = _G.C_PvP.GetHonorRewardInfo(NextRewardLevel)
	local Percent = floor((Honor / MaxHonor * 100 + 0.05) * 10) / 10
	local Remaining = MaxHonor - Honor
	local RemainingPercent = floor((Remaining / MaxHonor * 100 + 0.05) * 10) / 10
	local Kills = GetPVPLifetimeStats()

	DT.tooltip:AddLine(format(HONOR_LEVEL_TOOLTIP, HonorLevel))
	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine("Current honor") -- HONOR
	DT.tooltip:AddDoubleLine(format("%s / %s", BreakUpLargeNumbers(Honor), BreakUpLargeNumbers(MaxHonor)), format("%s%%", Percent), 1, 1, 1, 1, 1, 1)

	DT.tooltip:AddLine(" ")
	DT.tooltip:AddLine("Remaining honor")
	DT.tooltip:AddDoubleLine(format("%s", BreakUpLargeNumbers(Remaining)), format("%s%%", RemainingPercent), 1, 1, 1, 1, 1, 1)

	if (Kills > 0) then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(HONORABLE_KILLS)
		DT.tooltip:AddLine(BreakUpLargeNumbers(Kills), 1, 1, 1)
	end

	if RewardInfo then
		local RewardText = select(11, GetAchievementInfo(RewardInfo.achievementRewardedID))

		if RewardText:match("%S") then
			DT.tooltip:AddLine(" ")
			DT.tooltip:AddLine(format(PVP_PRESTIGE_RANK_UP_NEXT_MAX_LEVEL_REWARD, NextRewardLevel))
			DT.tooltip:AddLine(RewardText, 1, 1, 1)
		end
	end

	DT.tooltip:Show()
end

local ValueColorUpdate = function(hex)
	String = strjoin("", "%s: ", hex, "%s|r / ", hex, "%s|r")

	if Panel then
		OnEvent(Panel)
	end
end

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("PVP", nil, {"HONOR_XP_UPDATE", "HONOR_LEVEL_UPDATE"}, OnEvent, nil, OnClick, OnEnter, nil, PVP)