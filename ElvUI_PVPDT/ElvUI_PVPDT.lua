local E = unpack(ElvUI)
local DT = E:GetModule("DataTexts")

local BreakUpLargeNumbers = BreakUpLargeNumbers
local GetPVPLifetimeStats = GetPVPLifetimeStats
local Label = KILLS
local String = "%s: %s"
local Panel

local OnEvent = function(self, event, unit)
	if (unit and unit ~= "player") then
		return
	end
	
	self.text:SetFormattedText(String, Label, BreakUpLargeNumbers(GetPVPLifetimeStats()))
	
	Panel = self
end

local OnClick = function()
	ToggleCharacter("HonorFrame")
end

local OnEnter = function(self)
	DT:SetupTooltip(self)
	
	local HK, DK = GetPVPSessionStats()
	local Rank = UnitPVPRank("player")
	
	if (Rank > 0) then
		local Name, Number = GetPVPRankInfo(Rank, "player")
		
		DT.tooltip:AddDoubleLine(Name, format("%s %s", RANK, Number))
		DT.tooltip:AddLine(" ")
	end
	
	if (HK > 0) then
		DT.tooltip:AddLine(HONOR_TODAY)
		DT.tooltip:AddDoubleLine(HONORABLE_KILLS, BreakUpLargeNumbers(HK), 1, 1, 1, 1, 1, 1)
		DT.tooltip:AddDoubleLine(DISHONORABLE_KILLS, BreakUpLargeNumbers(DK), 1, 1, 1, 1, 1, 1)
		DT.tooltip:AddLine(" ")
	end
	
	HK, DK = GetPVPLifetimeStats()
	
	if (HK > 0) then
		DT.tooltip:AddLine(HONOR_LIFETIME)
		DT.tooltip:AddDoubleLine(HONORABLE_KILLS, BreakUpLargeNumbers(HK), 1, 1, 1, 1, 1, 1)
		DT.tooltip:AddDoubleLine(DISHONORABLE_KILLS, BreakUpLargeNumbers(DK), 1, 1, 1, 1, 1, 1)
	end
	
	DT.tooltip:Show()
end

local ValueColorUpdate = function(hex)
	String = strjoin("", "%s: ", hex, "%s|r")
	
	if (Panel ~= nil) then
		OnEvent(Panel)
	end
end

E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext("PVP", nil, {"PLAYER_PVP_KILLS_CHANGED", "PLAYER_ENTERING_WORLD"}, OnEvent, nil, OnClick, OnEnter, nil, PVP)