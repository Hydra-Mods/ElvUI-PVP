local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")
local String = "%s: %s"
local Panel

local OnEvent = function(self)
	self.text:SetFormattedText(String, HONOR, C_CurrencyInfo.GetCurrencyInfo(1901).quantity)

	if (not Panel) then
		Panel = self
	end
end

local OnClick = function()
	if E.Classic then
		ToggleCharacter("HonorFrame")
	elseif E.Wrath then
		TogglePVPFrame()
	else
		ToggleCharacter("PVPFrame")
	end
end

local OnEnter = function(self)
	DT:SetupTooltip(self)

	local HK, DK = GetPVPSessionStats()
	local Rank = UnitPVPRank("player")

	if (Rank > 0) then
		local Name, Number = GetPVPRankInfo(Rank, "player")

		DT.tooltip:AddDoubleLine(Name, format("%s %s", RANK, Number))
	end

	if (HK > 0) then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(HONOR_TODAY)
		DT.tooltip:AddDoubleLine(HONORABLE_KILLS, BreakUpLargeNumbers(HK), 1, 1, 1, 1, 1, 1)
		DT.tooltip:AddDoubleLine(DISHONORABLE_KILLS, BreakUpLargeNumbers(DK), 1, 1, 1, 1, 1, 1)
	end

	HK, DK = GetPVPLifetimeStats()

	if (HK > 0) then
		DT.tooltip:AddLine(" ")
		DT.tooltip:AddLine(HONOR_LIFETIME)
		DT.tooltip:AddDoubleLine(HONORABLE_KILLS, BreakUpLargeNumbers(HK), 1, 1, 1, 1, 1, 1)
		DT.tooltip:AddDoubleLine(DISHONORABLE_KILLS, BreakUpLargeNumbers(DK), 1, 1, 1, 1, 1, 1)
	end

	DT.tooltip:Show()
end

local ValueColorUpdate = function(hex)
	String = strjoin("", "%s: ", hex, " %s|r")

	if Panel then
		OnEvent(Panel)
	end
end

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("PVP", nil, {"CURRENCY_DISPLAY_UPDATE"}, OnEvent, nil, OnClick, OnEnter, nil, PVP)