--[[

	Shadow Vayne Script by Superx321
	Version: 3.13

	For Functions & Changelog, check the Thread on the BoL Forums:
	http://botoflegends.com/forum/topic/18939-shadow-vayne-the-mighty-hunter/

	If anything is not working or u wish a new Function, let me know it

	Thx to Jus & Hellsing for minor helping, Manciuszz for his Gapcloserlist and Klokje for his Interruptlist
	]]
if myHero.charName ~= "Vayne" then return end
if not VIP_USER then
	rawset(_G, "LoadVIPScript", function() return end)
end

local informationTable,CastedLastE  = {}, 0
local spellExpired  =  nil
local ScriptOnLoadDone, LastAttackedEnemy = false, nil

_SC = { init = true, initDraw = true, menuKey = 16, useTS = false, menuIndex = -1, instances = {}, _changeKey = false, _changeKeyInstance = false, _sliceInstance = false, _listInstance = false }
if not GetSave("scriptConfig")["Master"] then GetSave("scriptConfig")["Master"] = {} end
_SC.master = GetSave("scriptConfig")["Master"]
_SC.masterIndex = 0

_G.scriptConfig.CustomaddParam = _G.scriptConfig.addParam
_G.scriptConfig.addParam = function(self, pVar, pText, pType, defaultValue, a, b, c, d)
if pVar == "scriptActive" or pVar == "lastHitting" or pVar == "laneClear" or pVar == "hybridMode" then
pVar = "ShadowHijacked"
--~ pText = "ShadowVayne found. Set the Keysettings there!"
--~ pType = 5

end
if (self.name == "sidasacsetup_sidasacautocarrysub" and (pText == "Hotkey" or pText == "Auto Carry"))
	or (self.name == "sidasacsetup_sidasacmixedmodesub" and (pText == "Hotkey" or pText == "Mixed Mode"))
	or (self.name == "sidasacsetup_sidasaclaneclearsub" and (pText == "Hotkey" or pText == "Lane Clear"))
	or (self.name == "sidasacsetup_sidasaclasthitsub" and (pText == "Hotkey" or pText == "Last Hit")) then
pText = "ShadowVayne found. Set the Keysettings there!"
pType = 5
end
--~ if pType:lower():find("hotkey") then print(pText, " ", pType, " ", defaultValue," ", a," ",b," ",pVar.name) end
 _G.scriptConfig.CustomaddParam(self, pVar, pText, pType, defaultValue, a, b, c, d)
 end

---------------------------------
---------  Auto Updates ---------
---------------------------------
 function _GetLibs()
	if not GetLibsStarted then
		GetLibsStarted = true
		socket = require("socket")
		LibsDone = 0
		SocketsClosed = 0
		GotVersions = 0
		clientversion = {}
		clientscript = {}

		for i=1,#_AutoUpdates do
		clientversion[i] = socket.connect("reddi-ts.de", 80)
		clientversion[i]:send("GET /BoL/Scripts.php?path=".._AutoUpdates[i]["Version"].." HTTP/1.0\r\n\r\n")
		end

		for i=1,#_AutoUpdates do
		clientscript[i] = socket.connect("reddi-ts.de", 80)
		clientscript[i]:send("GET /BoL/Scripts.php?path=".._AutoUpdates[i]["Script"].." HTTP/1.0\r\n\r\n")
		end
	end

	if GotVersions ~= #_AutoUpdates then
		for i=1,#_AutoUpdates do
			if _AutoUpdates[i]["VersionClosed"] ~= true then
				s, status, partial = clientversion[i]:receive(1024)
				if not _AutoUpdates[i]["VersionRaw"] then _AutoUpdates[i]["VersionRaw"] = "" end
				_AutoUpdates[i]["VersionRaw"] = _AutoUpdates[i]["VersionRaw"]..(s or partial)
				if status == "closed" then
					clientversion[i]:close()
					_AutoUpdates[i]["VersionClosed"] = true
					GotVersions = GotVersions + 1
					_AutoUpdates[i]["ServerVersion"] = tonumber(string.sub(_AutoUpdates[i]["VersionRaw"], -8))
				end
			end
		end
	end


	if SocketsClosed ~= #_AutoUpdates then
		for i=1,#_AutoUpdates do
			if _AutoUpdates[i]["ScriptClosed"] ~= true then
				s, status, partial = clientscript[i]:receive(1024)
				if not _AutoUpdates[i]["ScriptRaw"] then _AutoUpdates[i]["ScriptRaw"] = "" end
				_AutoUpdates[i]["ScriptRaw"] = _AutoUpdates[i]["ScriptRaw"]..(s or partial)
				if status == "closed" then
					clientscript[i]:close()
					_AutoUpdates[i]["ScriptClosed"] = true
					SocketsClosed = SocketsClosed + 1
				end
			end
		end
	end

	if SocketsClosed == #_AutoUpdates and not WroteIt then
		WroteIt = true
		for i=1,#_AutoUpdates do
			if tonumber(_AutoUpdates[i]["ServerVersion"]) > tonumber(_GetLocalVersion(_AutoUpdates[i]["Name"])) then
				if _AutoUpdates[i]["Name"] == "ShadowVayne" then
					if SVUpdateMenu.UseAutoCheck then
						if SVUpdateMenu.UseAutoLoad then
							LibNameFile = io.open(SCRIPT_PATH.. GetCurrentEnv().FILE_NAME, "w+")
							LibNameString = _AutoUpdates[i]["ScriptRaw"]
							LibNameFindCache = string.find(LibNameString, "text/html")
							LibNameStringSub = string.sub(LibNameString, LibNameFindCache+13)
							LibNameFile:write(LibNameStringSub)
							LibNameFile:close()
							_PrintUpdateMsg("Updated Version "..tonumber(_GetLocalVersion(_AutoUpdates[i]["Name"])).." => "..tonumber(_AutoUpdates[i]["ServerVersion"]).."", _AutoUpdates[i]["Name"])
							_PrintUpdateMsg("Please Reload with F9!", _AutoUpdates[i]["Name"])
						else
							_PrintUpdateMsg("New Update available: Version "..tonumber(_AutoUpdates[i]["ServerVersion"]), _AutoUpdates[i]["Name"])
							_PrintUpdateMsg("AutoDownload is set to off", _AutoUpdates[i]["Name"])
						end
					end
				else
					_PrintUpdateMsg("Updated Version "..tonumber(_GetLocalVersion(_AutoUpdates[i]["Name"])).." => "..tonumber(_AutoUpdates[i]["ServerVersion"]).."", _AutoUpdates[i]["Name"])
					LibNameFile = io.open(LIB_PATH.._AutoUpdates[i]["Name"]..".lua", "w+")
					LibNameString = _AutoUpdates[i]["ScriptRaw"]
					LibNameFindCache = string.find(LibNameString, "text/html")
					LibNameStringSub = string.sub(LibNameString, LibNameFindCache+13)
					LibNameFile:write(LibNameStringSub)
					LibNameFile:close()
				end
			end
			LibsDone = LibsDone + 1
		end
	end

	if LibsDone == #_AutoUpdates then
		AllLibsLoaded = true
	else
		_GetLibs()
	end
end

function _GetLocalVersion(LibName)
	if LibName == "ShadowVayne" then
		FilePath = SCRIPT_PATH.. GetCurrentEnv().FILE_NAME
	else
		FilePath = LIB_PATH..LibName..".lua"
	end
	if not FileExist(FilePath) then
		LibNameFile = io.open(FilePath, "w+")
		LibNameFile:write("version = 0")
		LibNameFile:close()
	end
	LibNameFile = io.open(FilePath, "r")
	LibNameString = LibNameFile:read("*a")
	LibNameFile:close()
	LibNameVersionPos = LibNameString:lower():find("version")
	if type(LibNameVersionPos) == "number" then
		for i = 1,20 do
			GetCurrentChar = string.sub(LibNameString, LibNameVersionPos+i, LibNameVersionPos+i)
			if type(tonumber(GetCurrentChar)) == "number" then
				VersionNumberStartPos = LibNameVersionPos+i
				break
			end
		end

		for i = 0,20 do
			GetCurrentChar = string.sub(LibNameString, VersionNumberStartPos+i, VersionNumberStartPos+i)
			if type(tonumber(GetCurrentChar)) ~= "number" and GetCurrentChar ~= "." then
				VersionNumberEndPos = VersionNumberStartPos+i-1
				break
			end
		end
		FileVersion = string.sub(LibNameString, VersionNumberStartPos, VersionNumberEndPos)
		if FileVersion == "2.431" then
			return 5
		else
			return FileVersion
		end
	else
		return 0.01
	end
end

function _PrintUpdateMsg(Msg, LibName)
	if LibName == nil or LibName == "ShadowVayne" then
		print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">"..Msg.."</font>")
	else
		print("<font color=\"#F0Ff8d\"><b>ShadowVayne("..LibName.."):</b></font> <font color=\"#FF0F0F\">"..Msg.."</font>")
	end
end

LibNameFile = io.open(SCRIPT_PATH.."/".. GetCurrentEnv().FILE_NAME, "r")
LibNameString = LibNameFile:read("*a")
LibNameFile:close()
SV_Version =  tonumber(_GetLocalVersion("ShadowVayne"))

SVUpdateMenu = scriptConfig("[ShadowVayne] UpdateSettings", "SV_UPDATE")
SVMainMenu = scriptConfig("[ShadowVayne] MainScript", "SV_MAIN")
SVSOWMenu = scriptConfig("[ShadowVayne] SimpleOrbWalker Settings", "SV_SOW")
SVSTSMenu = scriptConfig("[ShadowVayne] SimpleTargetSelector Settings", "SV_STS")

SVMainMenu:addParam("nil","Waiting for the Script to load", SCRIPT_PARAM_INFO, "")
SVSOWMenu:addParam("nil","Waiting for the Script to load", SCRIPT_PARAM_INFO, "")

SVUpdateMenu:addParam("UseAutoCheck","Check for Updates", SCRIPT_PARAM_ONOFF, true)
SVUpdateMenu:addParam("UseAutoLoad","Automatic Download Updates", SCRIPT_PARAM_ONOFF, true)

SVUpdateMenu:addParam("version","ShadowVayne Version:", SCRIPT_PARAM_INFO, "v"..SV_Version)
 _AutoUpdates = {
			{["Name"] = "VPrediction", 		["Version"] = "/Hellsing/BoL/master/version/VPrediction.version", 		["Script"] = "/Hellsing/BoL/master/common/VPrediction.lua"},
			{["Name"] = "SOW", 				["Version"] = "/Hellsing/BoL/master/version/SOW.version", 				["Script"] = "/Hellsing/BoL/master/common/SOW.lua"},
			{["Name"] = "CustomPermaShow", 	["Version"] = "/Superx321/BoL/master/common/CustomPermaShow.Version", 	["Script"] = "/Superx321/BoL/master/common/CustomPermaShow.lua"},
			{["Name"] = "SourceLib", 		["Version"] = "/TheRealSource/public/master/common/SourceLib.version", 	["Script"] = "/TheRealSource/public/master/common/SourceLib.lua"},
		--	{["Name"] = "Selector", 		["Version"] = "/pqmailer/BoL_Scripts/master/Paid/Selector.revision", 	["Script"] = "/pqmailer/BoL_Scripts/master/Paid/Selector.lua"},
			{["Name"] = "ShadowVayne", 		["Version"] = "/Superx321/BoL/master/ShadowVayne.Version", 				["Script"] = "/Superx321/BoL/master/ShadowVayne.lua"},
		}
_GetLibs()

---------------------------------
---------  Cast E Spell ---------
---------------------------------
function _CastESpell(Target, Reason, Delay)
	if VIP_USER and SVMainMenu.vip.EPackets then
		DelayAction(function() Packet('S_CAST', { spellId = _E, targetNetworkId = Target.networkID }):send(true) end, Delay)
	else
		DelayAction(function() CastSpell(_E, Target) end, Delay)
	end
	CastedLastE = GetTickCount() + 500
end

function _CastPacketSpell(SpellToCast, TargetToCast)
	if VIP_USER and SVMainMenu.vip.EPackets then
		Packet('S_CAST', { spellId = SpellToCast, targetNetworkId = TargetToCast.networkID }):send(true)
		CastedLastE = GetTickCount() + 500
	else
		CastSpell(_E, TargetToCast)
		CastedLastE = GetTickCount() + 500
	end

end

----------------------------------
--------- Anti Gapcloser ---------
----------------------------------
function OnProcessSpell(unit, spell)
	if not myHero.dead and ScriptOnLoadDone then
		-- AntiGapCloser Targeted Spells
		if isAGapcloserUnitTarget[unit.charName] and spell.name == isAGapcloserUnitTarget[unit.charName].spell and unit.team ~= myHero.team then
			if spell.target ~= nil and spell.target.hash == myHero.hash then
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / AutoCarry Mode") end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Lasthit Mode") end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Mixed Mode") end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Laneclear Mode") end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."Always"] then _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Always") end
				if SVMainMenu.autostunn.OverwriteAutoCarry and ShadowVayneAutoCarry then  _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / AutoCarry Mode") end
				if SVMainMenu.autostunn.OverwriteMixedMode and ShadowVayneMixedMode then  _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / AutoCarry Mode") end
				if SVMainMenu.autostunn.OverwriteLaneClear and ShadowVayneLaneClear then  _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / AutoCarry Mode") end
				if SVMainMenu.autostunn.OverwriteLastHit and ShadowVayneLastHit then  _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / AutoCarry Mode") end
				if SVMainMenu.autostunn.Overwritealways then  _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / AutoCarry Mode") end
			end
		end

		-- AntiGapCloser Interrupt Spells
		if isAChampToInterrupt[spell.name] and unit.charName == isAChampToInterrupt[spell.name].champ and GetDistance(unit) <= 715 and unit.team ~= myHero.team then
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then _CastESpell(unit, "Interrupt ("..(spell.name)..") / AutoCarry Mode") end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then _CastESpell(unit, "Interrupt ("..(spell.name)..") / Lasthit Mode") end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then _CastESpell(unit, "Interrupt ("..(spell.name)..") / Mixed Mode") end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then _CastESpell(unit, "Interrupt ("..(spell.name)..") / Laneclear Mode") end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."Always"] then _CastESpell(unit, "Interrupt ("..(spell.name)..") / Always") end
		end

		if unit.isMe then
			if spell.name:find("Attack") then
				LastAttackedEnemy = spell.target
				DelayAction(function() IsAttacking = false;_CallBackAfterAA() end, spell.windUpTime - GetLatency() / 2000)
			end

			if spell.name == "Recall" then
				RecallCast = true
				DelayAction(function() RecallCast = false end, 0.75)
			end
		end

 			if spell.name:find("VayneCondemn") then -- E detected, cooldown for next E 500 ticks
				LastSpellTarget = spell.target
				DelayAction(function() myHero:Attack(LastSpellTarget) end, spell.windUpTime - GetLatency() / 2000)
				ShootRengar = false
			end

		if isAGapcloserUnitNoTarget[spell.name] and GetDistance(unit) <= 2000 and (spell.target == nil or spell.target.isMe) and unit.team ~= myHero.team then
			if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then spellExpired = false end
			if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then spellExpired = false end
			if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then spellExpired = false end
			if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then spellExpired = false end
			if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."Always"] then spellExpired = false end
			if SVMainMenu.autostunn.OverwriteAutoCarry and ShadowVayneAutoCarry then spellExpired = false end
			if SVMainMenu.autostunn.OverwriteMixedMode and ShadowVayneMixedMode then spellExpired = false end
			if SVMainMenu.autostunn.OverwriteLaneClear and ShadowVayneLaneClear then spellExpired = false end
			if SVMainMenu.autostunn.OverwriteLastHit and ShadowVayneLastHit then spellExpired = false end
			if SVMainMenu.autostunn.Overwritealways then spellExpired = false end
			informationTable = {
				spellSource = unit,
				spellCastedTick = GetTickCount(),
				spellStartPos = Point(spell.startPos.x, spell.startPos.z),
				spellEndPos = Point(spell.endPos.x, spell.endPos.z),
				spellRange = isAGapcloserUnitNoTarget[spell.name].range,
				spellSpeed = isAGapcloserUnitNoTarget[spell.name].projSpeed,
				spellName = spell.name
			}
		end
	end
end

function _CheckRengarGapcloser()
	if ShootRengar then
		if RengarHero.dead or RengarHero.health < 1 then ShootRengar = false end
		if not StartResetTimer then StartResetTimer=true;DelayAction(function() StartResetTimer, ShootRengar = false,false end, 2) end
		CastSpell(_E, RengarHero)
	end
end

function _NonTargetGapCloserAfterCast()
	if not myHero.dead and myHero:CanUseSpell(_E) == READY then
		if spellExpired == false and (GetTickCount() - informationTable.spellCastedTick) <= (informationTable.spellRange/informationTable.spellSpeed)*1000 then
			local spellDirection     = (informationTable.spellEndPos - informationTable.spellStartPos):normalized()
			local spellStartPosition = informationTable.spellStartPos + spellDirection
			local spellEndPosition   = informationTable.spellStartPos + spellDirection * informationTable.spellRange
			local heroPosition = Point(myHero.x, myHero.z)
			local SkillShot = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))
			if heroPosition:distance(SkillShot) <= 250 then
				if SVMainMenu.vip.EPackets then _CastESpell(informationTable.spellSource, "Gapcloser NonTargeted ("..(informationTable.spellName)..")") end
			end
		else
			spellExpired = true
			informationTable = {}
		end
	end
end

function _RengarLeapObj(Obj)
	if Obj.name == "Rengar_LeapSound.troy" and myHero:CanUseSpell(_E) == READY and GetDistanceSqr(RengarHero) < 1000*1000 then
		if SVMainMenu.anticapcloser[("Rengar")..(isAGapcloserUnitTarget["Rengar"].spellKey)][("Rengar").."AutoCarry"] and ShadowVayneAutoCarry then ShootRengar = true end
		if SVMainMenu.anticapcloser[("Rengar")..(isAGapcloserUnitTarget["Rengar"].spellKey)][("Rengar").."LastHit"] and ShadowVayneMixedMode then ShootRengar = true end
		if SVMainMenu.anticapcloser[("Rengar")..(isAGapcloserUnitTarget["Rengar"].spellKey)][("Rengar").."MixedMode"] and ShadowVayneLaneClear then ShootRengar = true end
		if SVMainMenu.anticapcloser[("Rengar")..(isAGapcloserUnitTarget["Rengar"].spellKey)][("Rengar").."LaneClear"] and ShadowVayneLastHit then ShootRengar = true end
		if SVMainMenu.anticapcloser[("Rengar")..(isAGapcloserUnitTarget["Rengar"].spellKey)][("Rengar").."Always"] then ShootRengar = true end
		if SVMainMenu.autostunn.OverwriteAutoCarry and ShadowVayneAutoCarry then  ShootRengar = true end
		if SVMainMenu.autostunn.OverwriteMixedMode and ShadowVayneMixedMode then  ShootRengar = true end
		if SVMainMenu.autostunn.OverwriteLaneClear and ShadowVayneLaneClear then  ShootRengar = true end
		if SVMainMenu.autostunn.OverwriteLastHit and ShadowVayneLastHit then  ShootRengar = true end
		if SVMainMenu.autostunn.Overwritealways then  ShootRengar = true end
	end
end

----------------------------------
---------- Recall Break ----------
----------------------------------
function OnRecall(hero, channelTimeInMs)
  if hero.isMe then
    Recalling = true
  end
end

function OnAbortRecall(hero)
  if hero.isMe then
    Recalling = false
  end
end

function OnFinishRecall(hero)
  if hero.isMe then
    Recalling = false
  end
end

----------------------------------
---------- Script Start ----------
----------------------------------
function _SwapAutoUpdate(SwapState, LibName)
	LibNameFile = io.open(LIB_PATH.."/"..LibName..".lua", "r")
	LibNameString = LibNameFile:read("*a")
	LibNameCutString = LibNameString
	GroundPos = 0
	LibNameFile:close()
	for i = 1,10 do
		LibNameUpdatePos = LibNameCutString:lower():find("autoupdate")
		if type(LibNameUpdatePos) == "number" then
			if string.find(string.sub(LibNameCutString, LibNameUpdatePos, LibNameUpdatePos+20), "= true") then
				StartString = string.sub(LibNameString, 0, GroundPos+LibNameUpdatePos-1)
				if SwapState == false then
					ReplaceString = string.gsub(string.sub(LibNameString, GroundPos+LibNameUpdatePos, GroundPos+LibNameUpdatePos+20), "= true", "= false")
				else
					ReplaceString = string.sub(LibNameString, GroundPos+LibNameUpdatePos, GroundPos+LibNameUpdatePos+20)
				end
				EndString = string.sub(LibNameString, GroundPos+LibNameUpdatePos+21)
				break
			elseif string.find(string.sub(LibNameCutString, LibNameUpdatePos, LibNameUpdatePos+20), "= false") then
				StartString = string.sub(LibNameString, 0, GroundPos+LibNameUpdatePos-1)
				if SwapState == true then
					ReplaceString = string.gsub(string.sub(LibNameString, GroundPos+LibNameUpdatePos, GroundPos+LibNameUpdatePos+20), "= false", "= true")
				else
					ReplaceString = string.sub(LibNameString, GroundPos+LibNameUpdatePos, GroundPos+LibNameUpdatePos+20)
				end
				EndString = string.sub(LibNameString, GroundPos+LibNameUpdatePos+21)
				break
			else
				LibNameCutString = string.sub(LibNameCutString, 20)
				GroundPos = GroundPos + 20
			end
		else

		StartString = LibNameString
		ReplaceString = ""
		EndString = ""
		end
	end
	LibNameFile = io.open(LIB_PATH..LibName..".lua", "w+")
	LibNameFile:write(StartString..ReplaceString..EndString)
	LibNameFile:close()
end

function _RequireWithoutUpdate(LibName)
_SwapAutoUpdate(false, LibName)
require (LibName)
_SwapAutoUpdate(true, LibName)
end

function OnTick()
	if not ScriptStartOver and AllLibsLoaded then
		_RequireWithoutUpdate("VPrediction")
		_RequireWithoutUpdate("SourceLib")
		_RequireWithoutUpdate("SOW")
		if VIP_USER and FileExist(LIB_PATH.."Selector.lua") then _RequireWithoutUpdate("Selector") end
		_RequireWithoutUpdate("CustomPermaShow")
		_CheckSACMMASOW()
		if SAC_V84 and not SACLoaded then
			if not AuthWaitPrint then _PrintScriptMsg("Waiting for SAC:Reborn Auth");AuthWaitPrint=true end
			SACWait = true
		end

		if SAC_V84 and SACLoaded then
			SACWait = false
		end

		if not SACWait then
			ScriptStartOver = true
			VP = VPrediction(true)
			_LoadTables()
			_LoadMenu()
			_ArrangeEnemies()
			AddTickCallback(_GetRunningModes)
			AddTickCallback(_CheckStunn)
			AddTickCallback(_NonTargetGapCloserAfterCast)
			AddTickCallback(_ClickThreshLantern)
			AddTickCallback(_UsePermaShows)
--~ 			AddTickCallback(_UseSelector)
			AddTickCallback(_UseTumble)
			AddTickCallback(_UseBotRK)
			AddTickCallback(_UseBilgeWater)
			AddTickCallback(_SetToggleMode)
			AddTickCallback(_WallTumble)
			AddDrawCallback(_WallTumbleDraw)
			AddCreateObjCallback(_GenerateThreshLanter)
			AddCreateObjCallback(_RengarLeapObj)
			autoLevelSetFunction(_AutoLevelSpell)
			autoLevelSetSequence({0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
			ScriptOnLoadDone = true
			_G.HidePermaShow = {["LaneClear OnHold:"] = true,["Orbwalk OnHold:"] = true, ["LastHit OnHold:"] = true, ["HybridMode OnHold:"] = true,}
			_G.HidePermaShow["Condemn on next BasicAttack:"] = true
			_G.HidePermaShow["              Sida's Auto Carry: Reborn"] = true
			_G.HidePermaShow["Auto Carry"] = true
			_G.HidePermaShow["Last Hit"] = true
			_G.HidePermaShow["Mixed Mode"] = true
			_G.HidePermaShow["Lane Clear"] = true
			_G.HidePermaShow["Auto-Condemn"] = true
			_G.HidePermaShow["No mode active"] = true
			_G.HidePermaShow["ShadowVayne found. Set the Keysettings there!"] = true
			for i, enemy in ipairs(GetEnemyHeroes()) do
				if enemy.charName == "Rengar" then
					RengarHero = enemy
					AddTickCallback(_CheckRengarGapcloser)
				end
			end

		end
	end
end

function _LoadMenu()
	SVMainMenu:addSubMenu("[Condemn]: AntiGapCloser Settings", "anticapcloser")
	SVMainMenu:addSubMenu("[Condemn]: AutoStunn Settings", "autostunn")
	SVMainMenu:addSubMenu("[Condemn]: AutoStunn Targets", "targets")
	SVMainMenu:addSubMenu("[Condemn]: Interrupt Settings", "interrupt")
	SVMainMenu:addSubMenu("[Condemn]: Draw Settings", "condemndraw")
	SVMainMenu:addSubMenu("[Tumble]: Settings", "tumble")
	SVMainMenu:addSubMenu("[Misc]: Key Settings", "keysetting")
	SVMainMenu:addSubMenu("[Misc]: AutoLevelSpells Settings", "autolevel")
	SVMainMenu:addSubMenu("[Misc]: VIP Settings", "vip")
	SVMainMenu:addSubMenu("[Misc]: PermaShow Settings", "permashowsettings")
	SVMainMenu:addSubMenu("[Misc]: Draw Settings", "draw")
	SVMainMenu:addSubMenu("[Misc]: WallTumble Settings", "walltumble")
	SVMainMenu:addSubMenu("[BotRK]: Settings", "botrksettings")
	SVMainMenu:addSubMenu("[Bilgewater]: Settings", "bilgesettings")
	SVMainMenu:addSubMenu("[QSS]: Settings", "qqs")
	SVMainMenu:addSubMenu("[Debug]: Settings", "debug")
	SVMainMenu.qqs:addParam("nil","QSS/Cleanse is not Supported yet", SCRIPT_PARAM_INFO, "")

	SVMainMenu.keysetting:addParam("nil","Basic Key Settings", SCRIPT_PARAM_INFO, "")
	SVMainMenu.keysetting:addParam("basiccondemn","Condemn on next BasicAttack:", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte( "E" ))
	SVMainMenu.keysetting:addParam("threshlantern","Grab the Thresh lantern: ", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "T" ))
	SVMainMenu.keysetting.basiccondemn = false
	SVMainMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")
	SVMainMenu.keysetting:addParam("nil","General Key Settings", SCRIPT_PARAM_INFO, "")
	SVMainMenu.keysetting:addParam("togglemode","ToggleMode:", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam("autocarry","Auto Carry Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "V" ))
	SVMainMenu.keysetting:addParam("mixedmode","Mixed Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "C" ))
	SVMainMenu.keysetting:addParam("laneclear","Lane Clear Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "M" ))
	SVMainMenu.keysetting:addParam("lasthit","Last Hit Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "N" ))
	SVMainMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")

	if SOWLoaded then SVMainMenu.keysetting:addParam("nil","SimpleOrbWalker found", SCRIPT_PARAM_INFO, "") end
	if SACLoaded then SVMainMenu.keysetting:addParam("nil","Sida's Auto Carry: Reborn found", SCRIPT_PARAM_INFO, "") end
	if REVLoaded then SVMainMenu.keysetting:addParam("nil","Sida's Auto Carry: Revamped found", SCRIPT_PARAM_INFO, "") end
	if MMALoaded then SVMainMenu.keysetting:addParam("nil","Marksmen Mighty Assistant found", SCRIPT_PARAM_INFO, "") end
	SVMainMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")
	SVMainMenu.keysetting:addParam("nil","Choose...", SCRIPT_PARAM_INFO, "")
	if SOWLoaded then
		if MMALoaded then
			if SACLoaded then
				OrbWalkerTable = { "SOW", "MMA", "Reborn"}
			elseif REVLoaded then
				OrbWalkerTable = { "SOW", "MMA", "Revamped"}
			else
				OrbWalkerTable = { "SOW", "MMA"}
			end
		else
			if SACLoaded then
				OrbWalkerTable = { "SOW", "Reborn"}
			elseif REVLoaded then
				OrbWalkerTable = { "SOW", "Revamped"}
			else
				OrbWalkerTable = { "SOW"}
			end
		end
	end
	for i=1,30 do
		if SVMainMenu.keysetting._param[i].text == "Choose..." then
			StartParam = i + 1
			break
		end
	end


	SVMainMenu.keysetting:addParam("AutoCarryOrb", "Orbwalker in AutoCarry: ", SCRIPT_PARAM_LIST, 1, OrbWalkerTable)
	SVMainMenu.keysetting:addParam("MixedModeOrb", "Orbwalker in MixedMode: ", SCRIPT_PARAM_LIST, 1, OrbWalkerTable)
	SVMainMenu.keysetting:addParam("LaneClearOrb", "Orbwalker in LaneClear: ", SCRIPT_PARAM_LIST, 1, OrbWalkerTable)
	SVMainMenu.keysetting:addParam("LastHitOrb", "Orbwalker in LastHit: ", SCRIPT_PARAM_LIST, 1, OrbWalkerTable)
	if SAC_V84 and SACLoaded then
	SVMainMenu.keysetting:addParam("SACAutoCarry","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam("SACMixedMode","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam("SACLaneClear","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam("SACLastHit","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACAutoCarry", AutoCarry.MODE_AUTOCARRY)
	Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACMixedMode", AutoCarry.MODE_MIXEDMODE)
	Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACLaneClear", AutoCarry.MODE_LANECLEAR)
	Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACLastHit", AutoCarry.MODE_LASTHIT)
	end

	for i, enemy in ipairs(GetEnemyHeroes()) do
--~ 	Gapcloser Menu Targeted Skills
		if isAGapcloserUnitTarget[enemy.charName] then
			SVMainMenu.anticapcloser:addSubMenu((enemy.charName).." "..(isAGapcloserUnitTarget[enemy.charName].spellKey), (enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey))
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam("sep", "Interrupt "..(enemy.charName).." "..(isAGapcloserUnitTarget[enemy.charName].spellKey)..":", SCRIPT_PARAM_INFO, "")
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, true)
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, false)
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, false)
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, false)
		end

--~ 	Gapcloser Menu NoTargeted Skills
		for _, TableInfo in pairs(isAGapcloserUnitNoTarget) do
			if TableInfo.champ == enemy.charName then
				SVMainMenu.anticapcloser:addSubMenu((enemy.charName).." "..(TableInfo.spellKey), (enemy.charName)..(TableInfo.spellKey))
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam("sep", "Interrupt "..(enemy.charName).." "..(TableInfo.spellKey)..":", SCRIPT_PARAM_INFO, "")
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, false)
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, false)
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, false)
			end
		end

--~ 	Autostunn Target Menu
		SVMainMenu.targets:addSubMenu(enemy.charName, enemy.charName)
		SVMainMenu.targets[enemy.charName]:addParam("sep", "Stunn "..(enemy.charName), SCRIPT_PARAM_INFO, "")
		SVMainMenu.targets[enemy.charName]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
		SVMainMenu.targets[enemy.charName]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.targets[enemy.charName]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.targets[enemy.charName]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.targets[enemy.charName]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, false)

--~ 	Interrupt Champs Menu
		for _, TableInfo in pairs(isAChampToInterrupt) do
			if TableInfo.champ == enemy.charName then
				SVMainMenu.interrupt:addSubMenu((enemy.charName).." "..(TableInfo.spellKey), (enemy.charName)..(TableInfo.spellKey))
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam("sep", "Interrupt "..(enemy.charName).." "..(TableInfo.spellKey), SCRIPT_PARAM_INFO, "")
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, true)
			end
		end

--~ 	Condemn Draw Menu
		SVMainMenu.condemndraw:addParam((enemy.charName), "Draw ".. enemy.charName .." Stunn-Circle", SCRIPT_PARAM_ONOFF, true)
	end

--~ 	AutoStunn Settings Menu
		SVMainMenu.autostunn:addParam("pushDistance", "Push Distance", SCRIPT_PARAM_SLICE, 390, 0, 450, 0)
--~ 		SVMainMenu.autostunn:addParam("accuracy", "Accuracy", SCRIPT_PARAM_SLICE, 5, 1, 10, 0)
		SVMainMenu.autostunn:addParam("towerstunn", "Stunn if Enemy lands unter a Tower", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.autostunn:addParam("trinket", "Use Auto-Trinket Bush", SCRIPT_PARAM_ONOFF, true)
		SVMainMenu.autostunn:addParam("target", "Stunn only Current Target", SCRIPT_PARAM_ONOFF, true)

--~ 	Gapcloser Overwrite Menu
		SVMainMenu.anticapcloser:addParam("fap", "", SCRIPT_PARAM_INFO, "","" )
		SVMainMenu.anticapcloser:addParam("fap", "Gapcloser Overwrite:", SCRIPT_PARAM_INFO, "","" )
		SVMainMenu.anticapcloser:addParam("OverwriteAutoCarry", "Enable All Gapcloser in AutoCarry", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.anticapcloser:addParam("OverwriteMixedMode", "Enable All Gapcloser in Mixedmode", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.anticapcloser:addParam("OverwriteLaneClear", "Enable All Gapcloser in LaneClear", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.anticapcloser:addParam("OverwriteLastHit", "Enable All Gapcloser in LastHit", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.anticapcloser:addParam("OverwriteAlways", "Enalbe All Gapcloser always", SCRIPT_PARAM_ONOFF, false)

--~ 	Draw Menu
		SVMainMenu.draw:addParam("DrawERange", "Draw E Range", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.draw:addParam("DrawAARange", "Draw Basicattack Range", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.draw:addParam("DrawNeededAutohits", "Draw Needed Autohits", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.draw:addParam("DrawEColor", "E Range Color", SCRIPT_PARAM_LIST, 1, { "Riot standard", "Green", "Blue", "Red", "Purple" })
		SVMainMenu.draw:addParam("DrawAAColor", "Basicattack Range Color", SCRIPT_PARAM_LIST, 1, { "Riot standard", "Green", "Blue", "Red", "Purple" })

--~ 	Autolevel Menu
		SVMainMenu.autolevel:addParam("UseAutoLevelfirst", "Use AutoLevelSpells Level 1-3", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.autolevel:addParam("UseAutoLevelrest", "Use AutoLevelSpells Level 4-18", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.autolevel:addParam("first3level", "Level 1-3:", SCRIPT_PARAM_LIST, 1, { "Q-W-E", "Q-E-W", "W-Q-E", "W-E-Q", "E-Q-W", "E-W-Q" })
		SVMainMenu.autolevel:addParam("restlevel", "Level 4-18:", SCRIPT_PARAM_LIST, 1, { "Q-W-E", "Q-E-W", "W-Q-E", "W-E-Q", "E-Q-W", "E-W-Q" })
		SVMainMenu.autolevel:addParam("fap", "", SCRIPT_PARAM_INFO, "","" )
		SVMainMenu.autolevel:addParam("fap", "You can Click on the \"Q-W-E\"", SCRIPT_PARAM_INFO, "","" )
		SVMainMenu.autolevel:addParam("fap", "to change the Autospellorder", SCRIPT_PARAM_INFO, "","" )

--~ 	Vip Menu
		SVMainMenu.vip:addParam("EPackets", "Use Packets for E Cast (VIP Only)", SCRIPT_PARAM_ONOFF, true)
--~ 		SVMainMenu.vip:addParam("vpred", "Use VPrediction (VIP Only)", SCRIPT_PARAM_ONOFF, true)
--~ 		SVMainMenu.vip:addParam("selector", "Use Selector (VIP Only) (Need Reload!)", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.vip:addParam("pr0diction", "Use Pr0diction (VIP Only)", SCRIPT_PARAM_ONOFF, false)

--~ 	PermaShow Menu
		SVMainMenu.permashowsettings:addParam("epermashow", "PermaShow \"E on Next BasicAttack\"", SCRIPT_PARAM_ONOFF, true)
		SVMainMenu.permashowsettings:addParam("carrypermashow", "PermaShow: AutoCarry", SCRIPT_PARAM_ONOFF, true)
		SVMainMenu.permashowsettings:addParam("mixedpermashow", "PermaShow: Mixed Mode", SCRIPT_PARAM_ONOFF, true)
		SVMainMenu.permashowsettings:addParam("laneclearpermashow", "PermaShow: Laneclear", SCRIPT_PARAM_ONOFF, true)
		SVMainMenu.permashowsettings:addParam("lasthitpermashow", "PermaShow: Last hit", SCRIPT_PARAM_ONOFF, true)

--~ 	BotRK Settings Menu
		SVMainMenu.botrksettings:addParam("botrkautocarry", "Use BotRK in AutoCarry", SCRIPT_PARAM_ONOFF, true)
		SVMainMenu.botrksettings:addParam("botrkmixedmode", "Use BotRK in MixedMode", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.botrksettings:addParam("botrklaneclear", "Use BotRK in LaneClear", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.botrksettings:addParam("botrklasthit", "Use BotRK in LastHit", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.botrksettings:addParam("botrkalways", "Use BotRK always", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.botrksettings:addParam("botrkmaxheal", "Max Own Health Percent", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
		SVMainMenu.botrksettings:addParam("botrkminheal", "Min Enemy Health Percent", SCRIPT_PARAM_SLICE, 20, 1, 100, 0)

--~ 	BilgeWater Settings Menu
		SVMainMenu.bilgesettings:addParam("bilgeautocarry", "Use BilgeWater in AutoCarry", SCRIPT_PARAM_ONOFF, true)
		SVMainMenu.bilgesettings:addParam("bilgemixedmode", "Use BilgeWater in MixedMode", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.bilgesettings:addParam("bilgelaneclear", "Use BilgeWater in LaneClear", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.bilgesettings:addParam("bilgelasthit", "Use BilgeWater in LastHit", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.bilgesettings:addParam("bilgealways", "Use BilgeWater always", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.bilgesettings:addParam("bilgemaxheal", "Max Own Health Percent", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
		SVMainMenu.bilgesettings:addParam("bilgeminheal", "Min Enemy Health Percent", SCRIPT_PARAM_SLICE, 20, 1, 100, 0)

--~ 	Tumble Settings Menu
		SVMainMenu.tumble:addParam("Qautocarry", "Use Tumble in AutoCarry", SCRIPT_PARAM_ONOFF, true)
		SVMainMenu.tumble:addParam("Qmixedmode", "Use Tumble in MixedMode", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.tumble:addParam("Qlaneclear", "Use Tumble in LaneClear", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.tumble:addParam("Qlasthit", "Use Tumble in LastHit", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.tumble:addParam("Qalways", "Use Tumble always", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.tumble:addParam("fap", "", SCRIPT_PARAM_INFO, "","" )
		SVMainMenu.tumble:addParam("QManaAutoCarry", "Min Mana to use Q in AutoCarry", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
		SVMainMenu.tumble:addParam("QManaMixedMode", "Min Mana to use Q in MixedMode", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		SVMainMenu.tumble:addParam("QManaLaneClear", "Min Mana to use Q in LaneClear", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		SVMainMenu.tumble:addParam("QManaLastHit", "Min Mana to use Q in LastHit", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

--~ 	Debug Settings Menu
		SVMainMenu.debug:addParam("stunndebug", "Debug AutoStunn", SCRIPT_PARAM_ONOFF, false)

--~ 	Walltumble Settings Menu
		SVMainMenu.walltumble:addParam("spot1", "Draw & Use Spot 1 (Drake-Spot)", SCRIPT_PARAM_ONOFF, true)
		SVMainMenu.walltumble:addParam("spot2", "Draw & Use Spot 2 (Min-Spot)", SCRIPT_PARAM_ONOFF, true)



	STS = SimpleTS(STS_LESS_CAST_PHYSICAL)
	SOWi = SOW(VP, STS)
	SOWi:LoadToMenu(SVSOWMenu)
	SOWi:RegisterBeforeAttackCallback(_PreAttack)
	SOWi:RegisterAfterAttackCallback(_AfterAttack)
	if VIP_USER and SVMainMenu.vip.pr0diction then
		require "Prodiction"
		Prod = ProdictManager.GetInstance()
		ProdE = Prod:AddProdictionObject(_E, 650, 2300, 0.311, 90)
	end

--~ 	if VIP_USER and SVMainMenu.vip.selector and FileExist(LIB_PATH.."Selector.lua") and 1==2 then
--~ 		Selector.Instance()
--~ 	else
--~ 		TSSMenu = scriptConfig("[SV] SimpleTargetSelector Settings", "SV_TSS")
		STS:AddToMenu(SVSTSMenu)
--~ 	end
		_PrintScriptMsg("Version "..SV_Version.." loaded")
		SVMainMenu._param[1].text = "HideParam"
		SVSOWMenu._param[1].text = "Set the Keysettings in the MainScript Menu!"
end

function _LoadTables()
	isAGapcloserUnitTarget = {
        ['Akali']       = {true, spell = "AkaliShadowDance", 	spellKey = "R"},
        ['Alistar']     = {true, spell = "Headbutt", 			spellKey = "W"},
        ['Diana']       = {true, spell = "DianaTeleport", 		spellKey = "R"},
        ['Irelia']      = {true, spell = "IreliaGatotsu",		spellKey = "Q"},
        ['Jax']         = {true, spell = "JaxLeapStrike", 		spellKey = "Q"},
        ['Jayce']       = {true, spell = "JayceToTheSkies",		spellKey = "Q"},
        ['Maokai']      = {true, spell = "MaokaiUnstableGrowth",spellKey = "W"},
        ['MonkeyKing']  = {true, spell = "MonkeyKingNimbus",	spellKey = "E"},
        ['Pantheon']    = {true, spell = "Pantheon_LeapBash",	spellKey = "W"},
        ['Poppy']       = {true, spell = "PoppyHeroicCharge",	spellKey = "E"},
		['Quinn']       = {true, spell = "QuinnE",				spellKey = "E"},
        ['XinZhao']     = {true, spell = "XenZhaoSweep",		spellKey = "E"},
        ['LeeSin']	    = {true, spell = "blindmonkqtwo",		spellKey = "Q"},
        ['Fizz']	    = {true, spell = "FizzPiercingStrike",	spellKey = "Q"},
        ['Rengar']	    = {true, spell = "RengarLeap",			spellKey = "Q/R"},
    }

	isAGapcloserUnitNoTarget = {
		["AatroxQ"]					= {true, champ = "Aatrox", 		range = 1000,  	projSpeed = 1200, spellKey = "Q"},
		["GragasE"]					= {true, champ = "Gragas", 		range = 600,   	projSpeed = 2000, spellKey = "E"},
		["GravesMove"]				= {true, champ = "Graves", 		range = 425,   	projSpeed = 2000, spellKey = "E"},
		["HecarimUlt"]				= {true, champ = "Hecarim", 	range = 1000,   projSpeed = 1200, spellKey = "R"},
		["JarvanIVDragonStrike"]	= {true, champ = "JarvanIV",	range = 770,   	projSpeed = 2000, spellKey = "Q"},
		["JarvanIVCataclysm"]		= {true, champ = "JarvanIV", 	range = 650,   	projSpeed = 2000, spellKey = "R"},
		["KhazixE"]					= {true, champ = "Khazix", 		range = 900,   	projSpeed = 2000, spellKey = "E"},
		["khazixelong"]				= {true, champ = "Khazix", 		range = 900,   	projSpeed = 2000, spellKey = "E"},
		["LeblancSlide"]			= {true, champ = "Leblanc", 	range = 600,   	projSpeed = 2000, spellKey = "W"},
		["LeblancSlideM"]			= {true, champ = "Leblanc", 	range = 600,   	projSpeed = 2000, spellKey = "WMimic"},
		["LeonaZenithBlade"]		= {true, champ = "Leona", 		range = 900,  	projSpeed = 2000, spellKey = "E"},
		["UFSlash"]					= {true, champ = "Malphite", 	range = 1000,  	projSpeed = 1800, spellKey = "R"},
		["RenektonSliceAndDice"]	= {true, champ = "Renekton", 	range = 450,  	projSpeed = 2000, spellKey = "E"},
		["SejuaniArcticAssault"]	= {true, champ = "Sejuani", 	range = 650,  	projSpeed = 2000, spellKey = "Q"},
		["ShenShadowDash"]			= {true, champ = "Shen", 		range = 575,  	projSpeed = 2000, spellKey = "E"},
		["RocketJump"]				= {true, champ = "Tristana", 	range = 900,  	projSpeed = 2000, spellKey = "W"},
		["slashCast"]				= {true, champ = "Tryndamere", 	range = 650,  	projSpeed = 1450, spellKey = "E"},
	}

	isAChampToInterrupt = {
                ["KatarinaR"]					= {true, champ = "Katarina",	spellKey = "R"},
                ["GalioIdolOfDurand"]			= {true, champ = "Galio",		spellKey = "R"},
                ["Crowstorm"]					= {true, champ = "FiddleSticks",spellKey = "R"},
                ["Drain"]						= {true, champ = "FiddleSticks",spellKey = "W"},
                ["AbsoluteZero"]				= {true, champ = "Nunu",		spellKey = "R"},
                ["ShenStandUnited"]				= {true, champ = "Shen",		spellKey = "R"},
                ["UrgotSwap2"]					= {true, champ = "Urgot",		spellKey = "R"},
                ["AlZaharNetherGrasp"]			= {true, champ = "Malzahar",	spellKey = "R"},
                ["FallenOne"]					= {true, champ = "Karthus",		spellKey = "R"},
                ["Pantheon_GrandSkyfall_Jump"]	= {true, champ = "Pantheon",	spellKey = "R"},
                ["VarusQ"]						= {true, champ = "Varus",		spellKey = "Q"},
                ["CaitlynAceintheHole"]			= {true, champ = "Caitlyn",		spellKey = "R"},
                ["MissFortuneBulletTime"]		= {true, champ = "MissFortune",	spellKey = "R"},
                ["InfiniteDuress"]				= {true, champ = "Warwick",		spellKey = "R"}
	}

	AutoLevelSpellTable = {
                ["SpellOrder"]	= {"QWE", "QEW", "WQE", "WEQ", "EQW", "EWQ"},
                ["QWE"]	= {1,2,3,1,1,4,1,2,1,2,4,2,2,3,3,4,3,3},
                ["QEW"]	= {1,3,2,1,1,4,1,3,1,3,4,3,3,2,2,4,2,2},
                ["WQE"]	= {2,1,3,2,2,4,2,1,2,1,4,1,1,3,3,4,3,3},
                ["WEQ"]	= {2,3,1,2,2,4,2,3,2,3,4,3,3,1,1,4,1,1},
                ["EQW"]	= {3,1,2,3,3,4,3,1,3,1,4,1,1,2,2,4,2,2},
                ["EWQ"]	= {3,2,1,3,3,4,3,2,3,2,4,2,2,1,1,4,1,1}
	}

	priorityTable = {

    AP = {
        "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus",
        "Kassadin", "Katarina", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna",
        "Rumble", "Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "MasterYi", "Velkoz"
    },
    Support = {
        "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Sona", "Soraka", "Thresh", "Zilean"
    },

    Tank = {
        "Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Shen", "Singed", "Skarner", "Volibear",
        "Warwick", "Yorick", "Zac", "Nunu", "Taric", "Alistar", "Braum",
    },

    AD_Carry = {
        "Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "KogMaw", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
        "Talon", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Zed", "Jinx" , "Lucian", "Yasuo",

    },

    Bruiser = {
        "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nautilus", "Nocturne", "Olaf", "Poppy",
        "Renekton", "Rengar", "Riven", "Shyvana", "Trundle", "Tryndamere", "Udyr", "Vi", "MonkeyKing", "XinZhao", "Aatrox",
    },

}

	ChampHitBoxes = {['RecItemsCLASSIC'] = 65, ['TeemoMushroom'] = 50.0, ['TestCubeRender'] = 65, ['Xerath'] = 65, ['Kassadin'] = 65, ['Rengar'] = 65, ['Thresh'] = 55.0, ['RecItemsTUTORIAL'] = 65, ['Ziggs'] = 55.0, ['ZyraPassive'] = 20.0, ['ZyraThornPlant'] = 20.0, ['KogMaw'] = 65, ['HeimerTBlue'] = 35.0, ['EliseSpider'] = 65, ['Skarner'] = 80.0, ['ChaosNexus'] = 65, ['Katarina'] = 65, ['Riven'] = 65, ['SightWard'] = 1, ['HeimerTYellow'] = 35.0, ['Ashe'] = 65, ['VisionWard'] = 1, ['TT_NGolem2'] = 80.0, ['ThreshLantern'] = 65, ['RecItemsCLASSICMap10'] = 65, ['RecItemsODIN'] = 65, ['TT_Spiderboss'] = 200.0, ['RecItemsARAM'] = 65, ['OrderNexus'] = 65, ['Soraka'] = 65, ['Jinx'] = 65, ['TestCubeRenderwCollision'] = 65, ['Red_Minion_Wizard'] = 48.0, ['JarvanIV'] = 65, ['Blue_Minion_Wizard'] = 48.0, ['TT_ChaosTurret2'] = 88.4, ['TT_ChaosTurret3'] = 88.4, ['TT_ChaosTurret1'] = 88.4, ['ChaosTurretGiant'] = 88.4, ['Dragon'] = 100.0, ['LuluSnowman'] = 50.0, ['Worm'] = 100.0, ['ChaosTurretWorm'] = 88.4, ['TT_ChaosInhibitor'] = 65, ['ChaosTurretNormal'] = 88.4, ['AncientGolem'] = 100.0, ['ZyraGraspingPlant'] = 20.0, ['HA_AP_OrderTurret3'] = 88.4, ['HA_AP_OrderTurret2'] = 88.4, ['Tryndamere'] = 65, ['OrderTurretNormal2'] = 88.4, ['Singed'] = 65, ['OrderInhibitor'] = 65, ['Diana'] = 65, ['HA_FB_HealthRelic'] = 65, ['TT_OrderInhibitor'] = 65, ['GreatWraith'] = 80.0, ['Yasuo'] = 65, ['OrderTurretDragon'] = 88.4, ['OrderTurretNormal'] = 88.4, ['LizardElder'] = 65.0, ['HA_AP_ChaosTurret'] = 88.4, ['Ahri'] = 65, ['Lulu'] = 65, ['ChaosInhibitor'] = 65, ['HA_AP_ChaosTurret3'] = 88.4, ['HA_AP_ChaosTurret2'] = 88.4, ['ChaosTurretWorm2'] = 88.4, ['TT_OrderTurret1'] = 88.4, ['TT_OrderTurret2'] = 88.4, ['TT_OrderTurret3'] = 88.4, ['LuluFaerie'] = 65, ['HA_AP_OrderTurret'] = 88.4, ['OrderTurretAngel'] = 88.4, ['YellowTrinketUpgrade'] = 1, ['MasterYi'] = 65, ['Lissandra'] = 65, ['ARAMOrderTurretNexus'] = 88.4, ['Draven'] = 65, ['FiddleSticks'] = 65, ['SmallGolem'] = 80.0, ['ARAMOrderTurretFront'] = 88.4, ['ChaosTurretTutorial'] = 88.4, ['NasusUlt'] = 80.0, ['Maokai'] = 80.0, ['Wraith'] = 50.0, ['Wolf'] = 50.0, ['Sivir'] = 65, ['Corki'] = 65, ['Janna'] = 65, ['Nasus'] = 80.0, ['Golem'] = 80.0, ['ARAMChaosTurretFront'] = 88.4, ['ARAMOrderTurretInhib'] = 88.4, ['LeeSin'] = 65, ['HA_AP_ChaosTurretTutorial'] = 88.4, ['GiantWolf'] = 65.0, ['HA_AP_OrderTurretTutorial'] = 88.4, ['YoungLizard'] = 50.0, ['Jax'] = 65, ['LesserWraith'] = 50.0, ['Blitzcrank'] = 80.0, ['brush_D_SR'] = 65, ['brush_E_SR'] = 65, ['brush_F_SR'] = 65, ['brush_C_SR'] = 65, ['brush_A_SR'] = 65, ['brush_B_SR'] = 65, ['ARAMChaosTurretInhib'] = 88.4, ['Shen'] = 65, ['Nocturne'] = 65, ['Sona'] = 65, ['ARAMChaosTurretNexus'] = 88.4, ['YellowTrinket'] = 1, ['OrderTurretTutorial'] = 88.4, ['Caitlyn'] = 65, ['Trundle'] = 65, ['Malphite'] = 80.0, ['Mordekaiser'] = 80.0, ['ZyraSeed'] = 65, ['Vi'] = 50, ['Tutorial_Red_Minion_Wizard'] = 48.0, ['Renekton'] = 80.0, ['Anivia'] = 65, ['Fizz'] = 65, ['Heimerdinger'] = 55.0, ['Evelynn'] = 65, ['Rumble'] = 80.0, ['Leblanc'] = 65, ['Darius'] = 80.0, ['OlafAxe'] = 50.0, ['Viktor'] = 65, ['XinZhao'] = 65, ['Orianna'] = 65, ['Vladimir'] = 65, ['Nidalee'] = 65, ['Tutorial_Red_Minion_Basic'] = 48.0, ['ZedShadow'] = 65, ['Syndra'] = 65, ['Zac'] = 80.0, ['Olaf'] = 65, ['Veigar'] = 55.0, ['Twitch'] = 65, ['Alistar'] = 80.0, ['Akali'] = 65, ['Urgot'] = 80.0, ['Leona'] = 65, ['Talon'] = 65, ['Karma'] = 65, ['Jayce'] = 65, ['Galio'] = 80.0, ['Shaco'] = 65, ['Taric'] = 65, ['TwistedFate'] = 65, ['Varus'] = 65, ['Garen'] = 65, ['Swain'] = 65, ['Vayne'] = 65, ['Fiora'] = 65, ['Quinn'] = 65, ['Kayle'] = 65, ['Blue_Minion_Basic'] = 48.0, ['Brand'] = 65, ['Teemo'] = 55.0, ['Amumu'] = 55.0, ['Annie'] = 55.0, ['Odin_Blue_Minion_caster'] = 48.0, ['Elise'] = 65, ['Nami'] = 65, ['Poppy'] = 55.0, ['AniviaEgg'] = 65, ['Tristana'] = 55.0, ['Graves'] = 65, ['Morgana'] = 65, ['Gragas'] = 80.0, ['MissFortune'] = 65, ['Warwick'] = 65, ['Cassiopeia'] = 65, ['Tutorial_Blue_Minion_Wizard'] = 48.0, ['DrMundo'] = 80.0, ['Volibear'] = 80.0, ['Irelia'] = 65, ['Odin_Red_Minion_Caster'] = 48.0, ['Lucian'] = 65, ['Yorick'] = 80.0, ['RammusPB'] = 65, ['Red_Minion_Basic'] = 48.0, ['Udyr'] = 65, ['MonkeyKing'] = 65, ['Tutorial_Blue_Minion_Basic'] = 48.0, ['Kennen'] = 55.0, ['Nunu'] = 65, ['Ryze'] = 65, ['Zed'] = 65, ['Nautilus'] = 80.0, ['Gangplank'] = 65, ['shopevo'] = 65, ['Lux'] = 65, ['Sejuani'] = 80.0, ['Ezreal'] = 65, ['OdinNeutralGuardian'] = 65, ['Khazix'] = 65, ['Sion'] = 80.0, ['Aatrox'] = 65, ['Hecarim'] = 80.0, ['Pantheon'] = 65, ['Shyvana'] = 50.0, ['Zyra'] = 65, ['Karthus'] = 65, ['Rammus'] = 65, ['Zilean'] = 65, ['Chogath'] = 80.0, ['Malzahar'] = 65, ['YorickRavenousGhoul'] = 1.0, ['YorickSpectralGhoul'] = 1.0, ['JinxMine'] = 65, ['YorickDecayedGhoul'] = 1.0, ['XerathArcaneBarrageLauncher'] = 65, ['Odin_SOG_Order_Crystal'] = 65, ['TestCube'] = 65, ['ShyvanaDragon'] = 80.0, ['FizzBait'] = 65, ['ShopKeeper'] = 65, ['Blue_Minion_MechMelee'] = 65.0, ['OdinQuestBuff'] = 65, ['TT_Buffplat_L'] = 65, ['TT_Buffplat_R'] = 65, ['KogMawDead'] = 65, ['TempMovableChar'] = 48.0, ['Lizard'] = 50.0, ['GolemOdin'] = 80.0, ['OdinOpeningBarrier'] = 65, ['TT_ChaosTurret4'] = 88.4, ['TT_Flytrap_A'] = 65, ['TT_Chains_Order_Periph'] = 65, ['TT_NWolf'] = 65.0, ['ShopMale'] = 65, ['OdinShieldRelic'] = 65, ['TT_Chains_Xaos_Base'] = 65, ['LuluSquill'] = 50.0, ['TT_Shopkeeper'] = 65, ['redDragon'] = 100.0, ['MonkeyKingClone'] = 65, ['Odin_skeleton'] = 65, ['OdinChaosTurretShrine'] = 88.4, ['Cassiopeia_Death'] = 65, ['OdinCenterRelic'] = 48.0, ['Ezreal_cyber_1'] = 65, ['Ezreal_cyber_3'] = 65, ['Ezreal_cyber_2'] = 65, ['OdinRedSuperminion'] = 55.0, ['TT_Speedshrine_Gears'] = 65, ['JarvanIVWall'] = 65, ['DestroyedNexus'] = 65, ['ARAMOrderNexus'] = 65, ['Red_Minion_MechCannon'] = 65.0, ['OdinBlueSuperminion'] = 55.0, ['SyndraOrbs'] = 65, ['LuluKitty'] = 50.0, ['SwainNoBird'] = 65, ['LuluLadybug'] = 50.0, ['CaitlynTrap'] = 65, ['TT_Shroom_A'] = 65, ['ARAMChaosTurretShrine'] = 88.4, ['Odin_Windmill_Propellers'] = 65, ['DestroyedInhibitor'] = 65, ['TT_NWolf2'] = 50.0, ['OdinMinionGraveyardPortal'] = 1.0, ['SwainBeam'] = 65, ['Summoner_Rider_Order'] = 65.0, ['TT_Relic'] = 65, ['odin_lifts_crystal'] = 65, ['OdinOrderTurretShrine'] = 88.4, ['SpellBook1'] = 65, ['Blue_Minion_MechCannon'] = 65.0, ['TT_ChaosInhibitor_D'] = 65, ['Odin_SoG_Chaos'] = 65, ['TrundleWall'] = 65, ['HA_AP_HealthRelic'] = 65, ['OrderTurretShrine'] = 88.4, ['OriannaBall'] = 48.0, ['ChaosTurretShrine'] = 88.4, ['LuluCupcake'] = 50.0, ['HA_AP_ChaosTurretShrine'] = 88.4, ['TT_Chains_Bot_Lane'] = 65, ['TT_NWraith2'] = 50.0, ['TT_Tree_A'] = 65, ['SummonerBeacon'] = 65, ['Odin_Drill'] = 65, ['TT_NGolem'] = 80.0, ['Shop'] = 65, ['AramSpeedShrine'] = 65, ['DestroyedTower'] = 65, ['OriannaNoBall'] = 65, ['Odin_Minecart'] = 65, ['Summoner_Rider_Chaos'] = 65.0, ['OdinSpeedShrine'] = 65, ['TT_Brazier'] = 65, ['TT_SpeedShrine'] = 65, ['odin_lifts_buckets'] = 65, ['OdinRockSaw'] = 65, ['OdinMinionSpawnPortal'] = 1.0, ['SyndraSphere'] = 48.0, ['TT_Nexus_Gears'] = 65, ['Red_Minion_MechMelee'] = 65.0, ['SwainRaven'] = 65, ['crystal_platform'] = 65, ['MaokaiSproutling'] = 48.0, ['Urf'] = 65, ['TestCubeRender10Vision'] = 65, ['MalzaharVoidling'] = 10.0, ['GhostWard'] = 1, ['MonkeyKingFlying'] = 65, ['LuluPig'] = 50.0, ['AniviaIceBlock'] = 65, ['TT_OrderInhibitor_D'] = 65, ['yonkey'] = 65, ['Odin_SoG_Order'] = 65, ['RammusDBC'] = 65, ['FizzShark'] = 65, ['LuluDragon'] = 50.0, ['OdinTestCubeRender'] = 65, ['OdinCrane'] = 65, ['TT_Tree1'] = 65, ['ARAMOrderTurretShrine'] = 88.4, ['TT_Chains_Order_Base'] = 65, ['Odin_Windmill_Gears'] = 65, ['ARAMChaosNexus'] = 65, ['TT_NWraith'] = 50.0, ['TT_OrderTurret4'] = 88.4, ['Odin_SOG_Chaos_Crystal'] = 65, ['TT_SpiderLayer_Web'] = 65, ['OdinQuestIndicator'] = 1.0, ['JarvanIVStandard'] = 65, ['TT_DummyPusher'] = 65, ['OdinClaw'] = 65, ['EliseSpiderling'] = 1.0, ['QuinnValor'] = 65, ['UdyrTigerUlt'] = 65, ['UdyrTurtleUlt'] = 65, ['UdyrUlt'] = 65, ['UdyrPhoenixUlt'] = 65, ['ShacoBox'] = 10, ['HA_AP_Poro'] = 65, ['AnnieTibbers'] = 80.0, ['UdyrPhoenix'] = 65, ['UdyrTurtle'] = 65, ['UdyrTiger'] = 65, ['HA_AP_OrderShrineTurret'] = 88.4, ['HA_AP_OrderTurretRubble'] = 65, ['HA_AP_Chains_Long'] = 65, ['HA_AP_OrderCloth'] = 65, ['HA_AP_PeriphBridge'] = 65, ['HA_AP_BridgeLaneStatue'] = 65, ['HA_AP_ChaosTurretRubble'] = 88.4, ['HA_AP_BannerMidBridge'] = 65, ['HA_AP_PoroSpawner'] = 50.0, ['HA_AP_Cutaway'] = 65, ['HA_AP_Chains'] = 65, ['HA_AP_ShpSouth'] = 65, ['HA_AP_HeroTower'] = 65, ['HA_AP_ShpNorth'] = 65, ['ChaosInhibitor_D'] = 65, ['ZacRebirthBloblet'] = 65, ['OrderInhibitor_D'] = 65, ['Nidalee_Spear'] = 65, ['Nidalee_Cougar'] = 65, ['TT_Buffplat_Chain'] = 65, ['WriggleLantern'] = 1, ['TwistedLizardElder'] = 65.0, ['RabidWolf'] = 65.0, ['HeimerTGreen'] = 50.0, ['HeimerTRed'] = 50.0, ['ViktorFF'] = 65, ['TwistedGolem'] = 80.0, ['TwistedSmallWolf'] = 50.0, ['TwistedGiantWolf'] = 65.0, ['TwistedTinyWraith'] = 50.0, ['TwistedBlueWraith'] = 50.0, ['TwistedYoungLizard'] = 50.0, ['Red_Minion_Melee'] = 48.0, ['Blue_Minion_Melee'] = 48.0, ['Blue_Minion_Healer'] = 48.0, ['Ghast'] = 60.0, ['blueDragon'] = 100.0, ['Red_Minion_MechRange'] = 65.0, ['Test_CubeSphere'] = 65,}

	ChampInfoTable = {}
	for i, enemy in ipairs(GetEnemyHeroes()) do
		ChampInfoTable[enemy.charName] = {CurrentVector = Vector(0,0,0), CurrentDirection = Vector(0,0,0), CurrentAngle = 0, CurrentHitBox = ChampHitBoxes[enemy.charName]}
	end

	TumbleSpots = {
		["VisionPos_1"] = { ["x"] = 11590.95, ["y"] = 52, ["z"] = 4656.26 },
		["VisionPos_2"] = { ["x"] = 6623, ["y"] = 56, ["z"] = 8649 },
		["StandPos_1"] = { ["x"] = 11590.95, ["y"] = 4656.26},
		["StandPos_2"] = { ["x"] = 6623.00, ["y"] = 8649.00 },
		["CastPos_1"] = { ["x"] = 11334.74, ["y"] = 4517.47 },
		["CastPos_2"] = { ["x"] = 6010.5869140625, ["y"] = 8508.8740234375 }
	}

	StunnFlyTime = {
		["700"] = 280,
		["650"] = 265,
		["600"] = 234,
		["550"] = 218,
		["500"] = 187,
		["450"] = 171,
		["400"] = 156,
		["350"] = 140,
		["300"] = 94,
		["250"] = 78,
		["200"] = 62,
		["150"] = 31,
		["100"] = 23,
		["50"] = 15,
	}
end

function _ArrangeEnemies()
	local priorityOrder = {
        [2] = {5,4,4,4,4},
        [3] = {5,4,4,3,3},
        [4] = {5,4,3,2,2},
        [5] = {5,4,3,2,1},
    }
	for i, enemy in ipairs(GetEnemyHeroes()) do
		for i=1,#priorityTable.AD_Carry do
			if enemy.charName == priorityTable.AD_Carry[i] then
				SVSTSMenu.STS[enemy.hash] = priorityOrder[#GetEnemyHeroes()][1]
			end
		end

		for i=1,#priorityTable.AP do
		if enemy.charName == priorityTable.AP[i] then
				SVSTSMenu.STS[enemy.hash] = priorityOrder[#GetEnemyHeroes()][2]
			end
		end

		for i=1,#priorityTable.Support do
			if enemy.charName == priorityTable.Support[i] then
				SVSTSMenu.STS[enemy.hash] = priorityOrder[#GetEnemyHeroes()][3]
			end
		end

		for i=1,#priorityTable.Bruiser do
			if enemy.charName == priorityTable.Bruiser[i] then
				SVSTSMenu.STS[enemy.hash] = priorityOrder[#GetEnemyHeroes()][4]
			end
		end

		for i=1,#priorityTable.Tank do
			if enemy.charName == priorityTable.Tank[i] then
				SVSTSMenu.STS[enemy.hash] = priorityOrder[#GetEnemyHeroes()][5]
			end
		end

	end
end

---------------------------------
--------- Message Funcs ---------
---------------------------------
function _PrintScriptMsg(Msg)
	PrintChat("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">"..Msg.."</font>")
end

function _ScriptDebugMsg(Msg, DebugMode)
	if SVMainMenu.debug[DebugMode] then
		print("<font color=\"#F0Ff8d\"><b>ShadowVayne Debug:</b></font> <font color=\"#FF0F0F\">"..Msg.."</font>")
	end
end

--------------------------------
---------- WallTumble ----------
--------------------------------
function RoundNumber(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

function _WallTumble()
	if VIP_USER then
		if myHero:CanUseSpell(_Q) ~= READY then TumbleOverWall_1, TumbleOverWall_2 = false,false end
		if TumbleOverWall_1 and SVMainMenu.walltumble.spot1 then
			if GetDistance(TumbleSpots.StandPos_1) <= 25 then
				TumbleOverWall_1 = false
				CastSpell(_Q, TumbleSpots.CastPos_1.x,  TumbleSpots.CastPos_1.y)
				myHero:HoldPosition()
			else
				if GetDistance(TumbleSpots.StandPos_1) > 25 then myHero:MoveTo(TumbleSpots.StandPos_1.x, TumbleSpots.StandPos_1.y) end
			end
		end
		if TumbleOverWall_2 and SVMainMenu.walltumble.spot2 then
			if GetDistance(TumbleSpots.StandPos_2) <= 25 then
				TumbleOverWall_2 = false
				CastSpell(_Q, TumbleSpots.CastPos_2.x,  TumbleSpots.CastPos_2.y)
				myHero:HoldPosition()
			else
				if GetDistance(TumbleSpots.StandPos_2) > 25 then myHero:MoveTo(TumbleSpots.StandPos_2.x, TumbleSpots.StandPos_2.y) end
			end
		end
	end
end

function _WallTumbleDraw()
	if VIP_USER then
		if SVMainMenu.walltumble.spot1 then
			if GetDistance(TumbleSpots.VisionPos_1) < 125 or GetDistance(TumbleSpots.VisionPos_1, mousePos) < 125 then
				DrawCircle(TumbleSpots.VisionPos_1.x, TumbleSpots.VisionPos_1.y, TumbleSpots.VisionPos_1.z, 100, 0x107458)
			else
				DrawCircle(TumbleSpots.VisionPos_1.x, TumbleSpots.VisionPos_1.y, TumbleSpots.VisionPos_1.z, 100, 0x80FFFF)
			end
		end
		if SVMainMenu.walltumble.spot2 then
			if GetDistance(TumbleSpots.VisionPos_2) < 125 or GetDistance(TumbleSpots.VisionPos_2, mousePos) < 125 then
				DrawCircle(TumbleSpots.VisionPos_2.x, TumbleSpots.VisionPos_2.y, TumbleSpots.VisionPos_2.z, 100, 0x107458)
			else
				DrawCircle(TumbleSpots.VisionPos_2.x, TumbleSpots.VisionPos_2.y, TumbleSpots.VisionPos_2.z, 100, 0x80FFFF)
			end
		end
	end
end

function OnSendPacket(p)
	if VIP_USER and ScriptStartOver then
		if p.header == 153 and p.size == 26 then
			if SVMainMenu.walltumble.spot1 then
				if GetDistance(TumbleSpots.VisionPos_1) < 125 or GetDistance(TumbleSpots.VisionPos_1, mousePos) < 125 then
					p.pos = 1
					P_NetworkID = p:DecodeF()
					P_SpellID = p:Decode1()
					if P_NetworkID == myHero.networkID and P_SpellID == _Q then
						if DontBlockNext then
							DontBlockNext = false
						else
							p:Block()
							DontBlockNext = true
							TumbleOverWall_1 = true
						end
					end
				end
			end

			if SVMainMenu.walltumble.spot2 then
				if GetDistance(TumbleSpots.VisionPos_2) < 125 or GetDistance(TumbleSpots.VisionPos_2, mousePos) < 125 then
					p.pos = 1
					P_NetworkID = p:DecodeF()
					P_SpellID = p:Decode1()
					if P_NetworkID == myHero.networkID and P_SpellID == _Q then
						if DontBlockNext then
							DontBlockNext = false
						else
							p:Block()
							DontBlockNext = true
							TumbleOverWall_2 = true
						end
					end
				end
			end
		end

		if p.header == 113 then
			p.pos = 1
			P_NetworkID = p:DecodeF()
			p:Decode1()
			P_X = p:DecodeF()
			P_X2 = RoundNumber(P_X, 2)
			P_Y = p:DecodeF()
			P_Y2 = RoundNumber(P_Y, 2)
			if TumbleOverWall_1 == true and SVMainMenu.walltumble.spot1 then
				RunToX, RunToY = TumbleSpots.StandPos_1.x, TumbleSpots.StandPos_1.y
				if not (P_X2 == RunToX and P_Y2 == RunToY) then
					p:Block()
					myHero:MoveTo(TumbleSpots.StandPos_1.x, TumbleSpots.StandPos_1.y)
				end
			end
			if TumbleOverWall_2 == true and SVMainMenu.walltumble.spot2 then
				RunToX, RunToY = TumbleSpots.StandPos_2.x, TumbleSpots.StandPos_2.y
				if not (P_X2 == RunToX and P_Y2 == RunToY) then
					p:Block()
					myHero:MoveTo(TumbleSpots.StandPos_2.x, TumbleSpots.StandPos_2.y)
				end
			end
		end
	end
end

--------------------------------
---------- Misc Funcs ----------
--------------------------------
function OnDraw()
	if ScriptOnLoadDone then
		if SVMainMenu.draw.DrawNeededAutohits then
			for i, enemy in ipairs(GetEnemyHeroes()) do
				DrawText(tostring(_GetNeededAutoHits(enemy)),16,GetUnitHPBarPos(enemy).x,GetUnitHPBarPos(enemy).y,0xFF80FF00)
			end
		end

		if SVMainMenu.draw.DrawERange then
			if SVMainMenu.draw.DrawEColor == 1 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 710, 0x80FFFF)
			elseif SVMainMenu.draw.DrawEColor == 2 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 710, 0x0080FF)
			elseif SVMainMenu.draw.DrawEColor == 3 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 710, 0x5555FF)
			elseif SVMainMenu.draw.DrawEColor == 4 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 710, 0xFF2D2D)
			elseif SVMainMenu.draw.DrawEColor == 5 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 710, 0x8B42B3)
			end
		end

		if SVMainMenu.draw.DrawAARange then
			if SVMainMenu.draw.DrawAAColor == 1 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 655, 0x80FFFF)
			elseif SVMainMenu.draw.DrawAAColor == 2 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 655, 0x0080FF)
			elseif SVMainMenu.draw.DrawAAColor == 3 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 655, 0x5555FF)
			elseif SVMainMenu.draw.DrawAAColor == 4 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 655, 0xFF2D2D)
			elseif SVMainMenu.draw.DrawAAColor == 5 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 655, 0x8B42B3)
			end
		end

		for i, enemy in ipairs(GetEnemyHeroes()) do
			if not _DrawStunnCircles then _DrawStunnCircles = {} end
			if SVMainMenu.condemndraw[enemy.charName] and _DrawStunnCircles[enemy.charName] ~= nil and myHero:CanUseSpell(_E) == READY and GetDistance(enemy) < 700 and not enemy.dead and enemy.visible then
				DrawCircle(_DrawStunnCircles[enemy.charName].x, _DrawStunnCircles[enemy.charName].y, _DrawStunnCircles[enemy.charName].z, 100, 0x8B42B3)
			end
		end
	end
end

function _CallBackAfterAA()
	if SVMainMenu.keysetting.basiccondemn and LastAttackedEnemy.type == myHero.type then -- Auto-E after AA
		CastSpell(_E, LastAttackedEnemy)
		SVMainMenu.keysetting.basiccondemn = false
	end
end

function _SetToggleMode()
	if OldToggleStatus ~= SVMainMenu.keysetting.togglemode then
		OldToggleStatus = SVMainMenu.keysetting.togglemode
		if SVMainMenu.keysetting.togglemode then
			SVMainMenu.keysetting._param[7].pType = SCRIPT_PARAM_ONKEYTOGGLE
			SVMainMenu.keysetting._param[8].pType = SCRIPT_PARAM_ONKEYTOGGLE
			SVMainMenu.keysetting._param[9].pType = SCRIPT_PARAM_ONKEYTOGGLE
			SVMainMenu.keysetting._param[10].pType = SCRIPT_PARAM_ONKEYTOGGLE
		else
			SVMainMenu.keysetting._param[7].pType = SCRIPT_PARAM_ONKEYDOWN
			SVMainMenu.keysetting._param[8].pType = SCRIPT_PARAM_ONKEYDOWN
			SVMainMenu.keysetting._param[9].pType = SCRIPT_PARAM_ONKEYDOWN
			SVMainMenu.keysetting._param[10].pType = SCRIPT_PARAM_ONKEYDOWN
		end
	end
end

function _GetRunningModes()
	if SVMainMenu.keysetting.autocarry and not ShadowVayneAutoCarry then
		SVMainMenu.keysetting.mixedmode = false
		SVMainMenu.keysetting.laneclear = false
		SVMainMenu.keysetting.lasthit = false
	end

	if SVMainMenu.keysetting.mixedmode and not ShadowVayneMixedMode then
		SVMainMenu.keysetting.autocarry = false
		SVMainMenu.keysetting.laneclear = false
		SVMainMenu.keysetting.lasthit = false
	end

	if SVMainMenu.keysetting.laneclear then
		SVMainMenu.keysetting.autocarry = false
		SVMainMenu.keysetting.mixedmode = false
		SVMainMenu.keysetting.lasthit = false
	end

	if SVMainMenu.keysetting.lasthit then
		SVMainMenu.keysetting.mixedmode = false
		SVMainMenu.keysetting.laneclear = false
		SVMainMenu.keysetting.autocarry = false
	end

	--~ Get the Keysettings from SV
	ShadowVayneAutoCarry = SVMainMenu.keysetting.autocarry
	ShadowVayneMixedMode = SVMainMenu.keysetting.mixedmode
	ShadowVayneLaneClear = SVMainMenu.keysetting.laneclear
	ShadowVayneLastHit = SVMainMenu.keysetting.lasthit

	if Recalling or RecallCast then
		ShadowVayneAutoCarry = false
		ShadowVayneMixedMode = false
		ShadowVayneLaneClear = false
		ShadowVayneLastHit = false
	end
	if SACLoaded then Keys.AutoCarry,Keys.MixedMode,Keys.LaneClear,Keys.LastHit = false,false,false,false end
	if RevampedLoaded then REVMenu.AutoCarry,REVMenu.MixedMode,REVMenu.LaneClear,REVMenu.LastHit = false,false,false,false end
	--if SOWLoaded then SVSOWMenu._param[7].key,SVSOWMenu._param[8].key,SVSOWMenu._param[9].key,SVSOWMenu._param[10].key = 5,5,5,5 end
	if SOWLoaded then SVSOWMenu.Mode0,SVSOWMenu.Mode1,SVSOWMenu.Mode2,SVSOWMenu.Mode3 = false,false,false,false end
	if MMALoaded then _G.MMA_Orbwalker,_G.MMA_HybridMode,_G.MMA_LaneClear,_G.MMA_LastHit = false,false,false,false end

	--~ Check if one List is Empty
	if SVMainMenu.keysetting._param[StartParam].listTable[SVMainMenu.keysetting.AutoCarryOrb] == nil then SVMainMenu.keysetting.AutoCarryOrb = 1 end
	if SVMainMenu.keysetting._param[StartParam+1].listTable[SVMainMenu.keysetting.MixedModeOrb] == nil then SVMainMenu.keysetting.MixedModeOrb = 1 end
	if SVMainMenu.keysetting._param[StartParam+2].listTable[SVMainMenu.keysetting.LaneClearOrb] == nil then SVMainMenu.keysetting.LaneClearOrb = 1 end
	if SVMainMenu.keysetting._param[StartParam+3].listTable[SVMainMenu.keysetting.LastHitOrb] == nil then SVMainMenu.keysetting.LastHitOrb = 1 end

	--~ Get what is Selected
	AutoCarryOrbText = SVMainMenu.keysetting._param[StartParam].listTable[SVMainMenu.keysetting.AutoCarryOrb]
	MixedModeOrbText = SVMainMenu.keysetting._param[StartParam+1].listTable[SVMainMenu.keysetting.MixedModeOrb]
	LaneClearOrbText = SVMainMenu.keysetting._param[StartParam+2].listTable[SVMainMenu.keysetting.LaneClearOrb]
	LastHitOrbText = SVMainMenu.keysetting._param[StartParam+3].listTable[SVMainMenu.keysetting.LastHitOrb]

	--~ Set the Modes
	if AutoCarryOrbText == "MMA" then _G.MMA_Orbwalker = ShadowVayneAutoCarry end
	if AutoCarryOrbText == "Reborn" then Keys.AutoCarry = ShadowVayneAutoCarry end
	if AutoCarryOrbText == "SOW" then SVSOWMenu.Mode0 = ShadowVayneAutoCarry end
	if AutoCarryOrbText == "Revamped" then REVMenu.AutoCarry = ShadowVayneAutoCarry end

	if MixedModeOrbText == "MMA" then _G.MMA_HybridMode = ShadowVayneMixedMode end
	if MixedModeOrbText == "Reborn" then Keys.MixedMode = ShadowVayneMixedMode end
	if MixedModeOrbText == "SOW" then SVSOWMenu.Mode1 = ShadowVayneMixedMode end
	if MixedModeOrbText == "Revamped" then REVMenu.MixedMode = ShadowVayneMixedMode end

	if LaneClearOrbText == "MMA" then _G.MMA_LaneClear = ShadowVayneLaneClear end
	if LaneClearOrbText == "Reborn" then Keys.LaneClear = ShadowVayneLaneClear end
	if LaneClearOrbText == "SOW" then SVSOWMenu.Mode2 = ShadowVayneLaneClear end
	if LaneClearOrbText == "Revamped" then REVMenu.LaneClear = ShadowVayneLaneClear end

	if LastHitOrbText == "MMA" then _G.MMA_LastHit = ShadowVayneLastHit end
	if LastHitOrbText == "Reborn" then Keys.LastHit = ShadowVayneLastHit end
	if LastHitOrbText == "SOW" then SVSOWMenu.Mode3 = ShadowVayneLastHit end
	if LastHitOrbText == "Revamped" then REVMenu.LastHit = ShadowVayneLastHit end

	if SAC_V84 and SACLoaded then
		if AutoCarryOrbText == "Reborn" then
			SVMainMenu.keysetting.SACAutoCarry = Keys.AutoCarry
		else
			SVMainMenu.keysetting.SACAutoCarry = false
		end
		if MixedModeOrbText == "Reborn" then
			SVMainMenu.keysetting.SACMixedMode = Keys.MixedMode
		else
			SVMainMenu.keysetting.SACMixedMode = false
		end
		if LaneClearOrbText == "Reborn" then
			SVMainMenu.keysetting.SACLaneClear = Keys.LaneClear
		else
			SVMainMenu.keysetting.SACLaneClear = false
		end
		if LastHitOrbText == "Reborn" then
			SVMainMenu.keysetting.SACLastHit = Keys.LastHit
		else
			SVMainMenu.keysetting.SACLastHit = false
		end
	end
end

function _CheckSACMMASOW()
	if _G.AutoCarry ~= nil then
		if _G.AutoCarry.Helper ~= nil then
			Skills, Keys, Items, Data, Jungle, Helper, MyHero, Minions, Crosshair, Orbwalker = AutoCarry.Helper:GetClasses()
			SACLoaded = true
		else
			if _G.AutoCarry.AutoCarry ~= nil then
				REVLoaded = true
				REVMenu = _G.AutoCarry.AutoCarry.MainMenu
			end
		end
	end

	if _G.Reborn_Loaded then
		SAC_V84 = true
	end

	if _G.MMA_Loaded then
		MMALoaded = true
	end

	if FileExist(SCRIPT_PATH.."/Common/SOW.lua") then
		SOWLoaded = true
	end
end

function _UseTumble()
	if IsAttacking == false and not myHero.dead and myHero:CanUseSpell(_Q) == READY and LastAttackedEnemy ~= nil and not LastAttackedEnemy.dead and LastAttackedEnemy.visible and not ShootRengar then
		if  (SVMainMenu.tumble.Qautocarry and ShadowVayneAutoCarry and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaAutoCarry)) or
			(SVMainMenu.tumble.Qmixedmode and ShadowVayneMixedMode and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaMixedMode)) or
			(SVMainMenu.tumble.Qlaneclear and ShadowVayneLaneClear and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaLaneClear)) or
			(SVMainMenu.tumble.Qlasthit and  ShadowVayneLastHit and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaLastHit)) or
			(SVMainMenu.tumble.Qalways) then
			local AfterTumblePos = myHero + (Vector(mousePos) - myHero):normalized() * 300
			if GetDistance(AfterTumblePos, LastAttackedEnemy) < 600 then
				CastSpell(_Q, mousePos.x, mousePos.z)
			end
		end
	end
end

function _UseSelector()
	if VIP_USER and SVMainMenu.vip.selector and _G.Selector_Enabled and ShadowVayneAutoCarry and FileExist(LIB_PATH.."Selector.lua") then
		local currentTarget = GetTarget()
		if currentTarget ~= nil and currentTarget.type == "obj_AI_Hero" and ValidTarget(currentTarget, 650, true) then
			selected = currentTarget
		else
			selected = nil
		end
		if selected ~= nil then
			SOW:ForceTarget(selected)
		else
			GetVIPSelectorTarget = Selector.GetTarget()
			if GetVIPSelectorTarget ~= nil and ValidTarget(GetVIPSelectorTarget) and GetDistance(GetVIPSelectorTarget) < 1000 then
				NewSOWTarget = GetVIPSelectorTarget
			else
				NewSOWTarget = LastAttackedEnemy
			end
			SOW:ForceTarget(NewSOWTarget)
		end
	end
end

function _UsePermaShows()
	CustomPermaShow("AutoCarry (Using "..AutoCarryOrbText..")", SVMainMenu.keysetting.autocarry, SVMainMenu.permashowsettings.carrypermashow, nil, 1426521024, nil, 1)
	CustomPermaShow("MixedMode (Using "..MixedModeOrbText..")", SVMainMenu.keysetting.mixedmode, SVMainMenu.permashowsettings.mixedpermashow, nil, 1426521024, nil, 2)
	CustomPermaShow("LaneClear (Using "..LaneClearOrbText..")", SVMainMenu.keysetting.laneclear, SVMainMenu.permashowsettings.laneclearpermashow, nil, 1426521024, nil, 3)
	CustomPermaShow("LastHit (Using "..LastHitOrbText..")", SVMainMenu.keysetting.lasthit, SVMainMenu.permashowsettings.lasthitpermashow, nil, 1426521024, nil, 4)
	CustomPermaShow("Auto-E after next BasicAttack", SVMainMenu.keysetting.basiccondemn, SVMainMenu.permashowsettings.epermashow, nil, 1426521024, nil,  5)
end

function _AutoLevelSpell()
	if GetGame().map.index == 8 and myHero.level < 4 then
		LevelSpell(_Q)
		LevelSpell(_W)
		LevelSpell(_E)
	end

	if SVMainMenu.autolevel.UseAutoLevelfirst and myHero.level < 4 then
		return AutoLevelSpellTable[AutoLevelSpellTable["SpellOrder"][SVMainMenu.autolevel.first3level]][myHero.level]
	end

	if SVMainMenu.autolevel.UseAutoLevelrest and myHero.level > 3 then
		return AutoLevelSpellTable[AutoLevelSpellTable["SpellOrder"][SVMainMenu.autolevel.restlevel]][myHero.level]
	end
end

function _GetNeededAutoHits(enemy)
		local PredictHP = math.ceil(enemy.health)
		local ThisAA = 0
		local BladeSlot = GetInventorySlotItem(3153)
		local TrueDMGPercent = ((enemy.maxHealth/100))*(3+(myHero:GetSpellData(_W).level))
		if myHero:GetSpellData(_W).level > 0 then TargetTrueDmg = math.floor((((enemy.maxHealth/100)*(3+(myHero:GetSpellData(_W).level)))+(10+(myHero:GetSpellData(_W).level)*10))/3) else	TargetTrueDmg = 0 end
		while PredictHP > 0 do
			ThisAA = ThisAA + 1
			DMGThisAA = math.floor((math.floor(myHero.totalDamage)) * 100 / (100 + enemy.armor))
			if BladeSlot ~= nil then BladeDMG = math.floor(math.floor(PredictHP)*5 / (100 + enemy.armor)) else BladeDMG = 0 end
			MyDMG = DMGThisAA + BladeDMG + TargetTrueDmg
			PredictHP = PredictHP - MyDMG
		end

		if ThisAA ~= math.floor(ThisAA/3)*3 then
			local PredictHP = math.ceil(enemy.health)
			for i = 1,math.floor(ThisAA/3)*3,1 do
				DMGThisAA = math.floor((math.floor(myHero.totalDamage)) * 100 / (100 + enemy.armor))
				if BladeSlot ~= nil then BladeDMG = math.floor(math.floor(PredictHP)*5 / (100 + enemy.armor)) else BladeDMG = 0 end
				MyDMG = DMGThisAA + BladeDMG + TargetTrueDmg
				PredictHP = PredictHP - MyDMG
			end

			for i = 1,2,1 do
				DMGThisAA = math.floor((math.floor(myHero.totalDamage)) * 100 / (100 + enemy.armor))
				if BladeSlot ~= nil then BladeDMG = math.floor(math.floor(PredictHP)*5 / (100 + enemy.armor)) else BladeDMG = 0 end
				MyDMG = DMGThisAA + BladeDMG
				PredictHP = PredictHP - MyDMG
			end

			if PredictHP > 0 then
				ThisAA = (math.ceil(ThisAA/3)*3)
			end
		end
	return ThisAA
end

function _ClickThreshLantern()
	if VIP_USER and SVMainMenu.keysetting.threshlantern and LanternObj then
		LanternPacket = CLoLPacket(0x39)
		LanternPacket:EncodeF(myHero.networkID)
		LanternPacket:EncodeF(LanternObj.networkID)
		LanternPacket.dwArg1 = 1
		LanternPacket.dwArg2 = 0
		SendPacket(LanternPacket)
	end
end

function _GenerateThreshLanter(Obj)
	if Obj.name == "ThreshLantern" then
		LanternObj = Obj
	end
end

---------------------------------
---------- Stunn Logic ----------
---------------------------------
function _CheckStunn()
	if not myHero.dead and myHero:CanUseSpell(_E) == READY and CastedLastE < GetTickCount() then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if GetDistance(enemy, myHero) <= 1000 and not enemy.dead and enemy.visible then
				if not VIP_USER then -- FREEUSER
					local CurrentDirection = (Vector(enemy) - ChampInfoTable[enemy.charName].CurrentVector)
					if CurrentDirection ~= Vector(0,0,0) then
						CurrentDirection = CurrentDirection:normalized()
					end
					ChampInfoTable[enemy.charName].CurrentAngle = ChampInfoTable[enemy.charName].CurrentDirection:dotP( CurrentDirection )
					ChampInfoTable[enemy.charName].CurrentDirection = CurrentDirection
					ChampInfoTable[enemy.charName].CurrentVector = Vector(enemy)
					if ChampInfoTable[enemy.charName].CurrentDirection ~= Vector(0,0,0) then
						if ChampInfoTable[enemy.charName].CurrentAngle and ChampInfoTable[enemy.charName].CurrentAngle > 0.8 then
							local AfterCastPos = Vector(enemy) + ChampInfoTable[enemy.charName].CurrentDirection * (enemy.ms * 0.0005)
							local timeElapsed = _GetCollisionTime(AfterCastPos, ChampInfoTable[enemy.charName].CurrentDirection, enemy.ms, myHero, 2200 )
							if timeElapsed ~= nil then
								StunnPos =  Vector(enemy) + ChampInfoTable[enemy.charName].CurrentDirection * enemy.ms * (timeElapsed + 0.5)/2
							end
						end
					else
						StunnPos = Vector(enemy)
					end
				end

				if VIP_USER and not SVMainMenu.vip.pr0diction then -- VPRED
					GroundDelay = 0.32
					EnemyPos = VP:GetPredictedPos(enemy, GroundDelay, enemy.ms, myHero, false)
					if EnemyPos ~= nil then
						EnemyDistance = GetDistance(EnemyPos)
						FlyTimeDelay = _GetFlyTime(math.floor(EnemyDistance))
						for i=1,10 do
							EnemyPos = VP:GetPredictedPos(enemy, GroundDelay+FlyTimeDelay, enemy.ms, EnemyPos, false)
							if EnemyPos~= nil then
								EnemyDistance = GetDistance(EnemyPos)
								FlyTimeDelay = _GetFlyTime(math.floor(EnemyDistance))
							end
						end
						StunnPos = VP:GetPredictedPos(enemy, GroundDelay+FlyTimeDelay, enemy.ms, EnemyPos, false)
					end
				end

				if VIP_USER and SVMainMenu.vip.pr0diction then -- PR0D
					GroundDelay = 0.32
					EnemyPos = Prodiction.GetTimePrediction(enemy, GroundDelay)
					if EnemyPos ~= nil then
						EnemyDistance = GetDistance(EnemyPos)
						FlyTimeDelay = _GetFlyTime(math.floor(EnemyDistance))
						for i=1,10 do
							EnemyPos = Prodiction.GetTimePrediction(enemy, GroundDelay+FlyTimeDelay)
							if EnemyPos~= nil then
								EnemyDistance = GetDistance(EnemyPos)
								FlyTimeDelay = _GetFlyTime(EnemyDistance)
							end
						end

						StunnPos = Prodiction.GetTimePrediction(enemy, GroundDelay+FlyTimeDelay)
					end
				end
				if StunnPos ~= nil and GetDistance(StunnPos) < 710 then
					_CheckWallStunn(StunnPos, enemy)
				end
			end
		end
	end
end

function _CheckWallStunn(StunnPos, enemy)
	if not _DrawStunnCircles then _DrawStunnCircles = {} end
	local BushFound, Bushpos = false, nil
	local FoundWall = false
	for i = 1, SVMainMenu.autostunn.pushDistance, 15  do
		local CheckWallPos = Vector(StunnPos) + (Vector(StunnPos) - myHero):normalized()*(i)
		if IsWallOfGrass(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) and not BushFound then
			BushFound = true
			BushPos = CheckWallPos
		end
		if IsWall(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) then
			if not FoundWall then _DrawStunnCircles = { [enemy.charName] = CheckWallPos };FoundWall = true end
			if 	(SVMainMenu.targets[enemy.charName][(enemy.charName).."AutoCarry"] and ShadowVayneAutoCarry) or
				(SVMainMenu.targets[enemy.charName][(enemy.charName).."MixedMode"] and ShadowVayneMixedMode) or
				(SVMainMenu.targets[enemy.charName][(enemy.charName).."LaneClear"] and ShadowVayneLaneClear) or
				(SVMainMenu.targets[enemy.charName][(enemy.charName).."LastHit"]   and ShadowVayneLastHit) or
				(SVMainMenu.targets[enemy.charName][(enemy.charName).."Always"])	then
				if UnderTurret(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z), true) then
					if SVMainMenu.autostunn.towerstunn then
					if SVMainMenu.autostunn.target then
						if STS:GetTarget(720) == enemy then
							CastSpell(_E, enemy)
							CastedLastE = GetTickCount() + 500
							break
						end
					else
						CastSpell(_E, enemy)
						CastedLastE = GetTickCount() + 500
						break
					end
					end
				else
					if SVMainMenu.autostunn.target then
						if STS:GetTarget(720) == enemy then
							CastSpell(_E, enemy)
							CastedLastE = GetTickCount() + 500
							if BushFound and SVMainMenu.autostunn.trinket and myHero:CanUseSpell(ITEM_7) == 0 then
								CastSpell(ITEM_7, BushPos.x, BushPos.z)
							end
							break
						end
					else
						CastSpell(_E, enemy)
						CastedLastE = GetTickCount() + 500
						if BushFound and SVMainMenu.autostunn.trinket and myHero:CanUseSpell(ITEM_7) == 0 then
							CastSpell(ITEM_7, BushPos.x, BushPos.z)
						end
						break
					end
					break
				end
			end
		end
	end
	if FoundWall == false then
		_DrawStunnCircles = { [enemy.charName] = nil }
	end
end

function _GetCollisionTime (targetPos, targetDir, targetSpeed, sourcePos, projSpeed ) --Function done by Yomie from EzCondemn
	local velocity = targetDir * targetSpeed

	local velocityX = velocity.x
	local velocityY = velocity.z

	local relStart = targetPos - sourcePos

	local relStartX = relStart.x
	local relStartY = relStart.z

	local a = velocityX * velocityX + velocityY * velocityY - projSpeed * projSpeed
	local b = 2 * velocityX * relStartX + 2 * velocityY * relStartY
	local c = relStartX * relStartX + relStartY * relStartY

	local disc = b * b - 4 * a * c

	if disc >= 0 then
		local t1 = -( b + math.sqrt( disc )) / (2 * a )
		local t2 = -( b - math.sqrt( disc )) / (2 * a )


		if t1 and t2 and t1 > 0 and t2 > 0 then
			if t1 > t2 then
				return t2
			else
				return t1
			end
		elseif t1 and t1 > 0 then
			return t1
		elseif t2 and t2 > 0 then
			return t2
		end
	end

	return nil
end

function _GetFlyTime(EnemyDistance)
		if EnemyDistance <  25 then FlyTimeDelay = 0 end
		if EnemyDistance >  24 and EnemyDistance <  75 then FlyTimeDelay = (StunnFlyTime["50"]/1000) end
		if EnemyDistance >  74 and EnemyDistance < 125 then FlyTimeDelay = (StunnFlyTime["100"]/1000) end
		if EnemyDistance > 124 and EnemyDistance < 175 then FlyTimeDelay = (StunnFlyTime["150"]/1000) end
		if EnemyDistance > 174 and EnemyDistance < 225 then FlyTimeDelay = (StunnFlyTime["200"]/1000) end
		if EnemyDistance > 224 and EnemyDistance < 275 then FlyTimeDelay = (StunnFlyTime["250"]/1000) end
		if EnemyDistance > 274 and EnemyDistance < 325 then FlyTimeDelay = (StunnFlyTime["300"]/1000) end
		if EnemyDistance > 324 and EnemyDistance < 375 then FlyTimeDelay = (StunnFlyTime["350"]/1000) end
		if EnemyDistance > 374 and EnemyDistance < 425 then FlyTimeDelay = (StunnFlyTime["400"]/1000) end
		if EnemyDistance > 424 and EnemyDistance < 475 then FlyTimeDelay = (StunnFlyTime["450"]/1000) end
		if EnemyDistance > 474 and EnemyDistance < 525 then FlyTimeDelay = (StunnFlyTime["500"]/1000) end
		if EnemyDistance > 524 and EnemyDistance < 575 then FlyTimeDelay = (StunnFlyTime["550"]/1000) end
		if EnemyDistance > 574 and EnemyDistance < 625 then FlyTimeDelay = (StunnFlyTime["600"]/1000) end
		if EnemyDistance > 624 and EnemyDistance < 675 then FlyTimeDelay = (StunnFlyTime["650"]/1000) end
		if EnemyDistance > 674 and EnemyDistance < 725 then FlyTimeDelay = (StunnFlyTime["700"]/1000) end
		if EnemyDistance > 724 then FlyTimeDelay = 280/1000 end
		return FlyTimeDelay
end

---------------------------------
----------- Callbacks -----------
---------------------------------
function _PreAttack()
	IsAttacking = true
end

function _AfterAttack()
	IsAttacking = false
end

--------------------------------
---------- Item Usage ----------
--------------------------------
function _UseBotRK()
	local BladeSlot = GetInventorySlotItem(3153)
	if LastAttackedEnemy ~= nil and GetDistance(LastAttackedEnemy) < 450 and not LastAttackedEnemy.dead and LastAttackedEnemy.visible and BladeSlot ~= nil and myHero:CanUseSpell(BladeSlot) == 0 then
		if (SVMainMenu.botrksettings.botrkautocarry and ShadowVayneAutoCarry) or
		 (SVMainMenu.botrksettings.botrkmixedmode and ShadowVayneMixedMode) or
		 (SVMainMenu.botrksettings.botrklaneclear and ShadowVayneLaneClear) or
		 (SVMainMenu.botrksettings.botrklasthit and ShadowVayneLastHit) or
		 (SVMainMenu.botrksettings.botrkalways) then
			if (math.floor(myHero.health / myHero.maxHealth * 100)) <= SVMainMenu.botrksettings.botrkmaxheal then
				if (math.floor(LastAttackedEnemy.health / LastAttackedEnemy.maxHealth * 100)) >= SVMainMenu.botrksettings.botrkminheal then
					CastSpell(BladeSlot, LastAttackedEnemy)
				end
			end
		end
	end
end

function _UseBilgeWater()
	local BilgeSlot = GetInventorySlotItem(3144)
	if LastAttackedEnemy ~= nil and GetDistance(LastAttackedEnemy) < 500 and not LastAttackedEnemy.dead and LastAttackedEnemy.visible and BilgeSlot ~= nil and myHero:CanUseSpell(BilgeSlot) == 0 then
		if (SVMainMenu.bilgesettings.bilgeautocarry and ShadowVayneAutoCarry) or
		 (SVMainMenu.bilgesettings.bilgemixedmode and ShadowVayneMixedMode) or
		 (SVMainMenu.bilgesettings.bilgelaneclear and ShadowVayneLaneClear) or
		 (SVMainMenu.bilgesettings.bilgelasthit and ShadowVayneLastHit) or
		 (SVMainMenu.bilgesettings.bilgealways) then
			if (math.floor(myHero.health / myHero.maxHealth * 100)) <= SVMainMenu.bilgesettings.bilgemaxheal then
				if (math.floor(LastAttackedEnemy.health / LastAttackedEnemy.maxHealth * 100)) >= SVMainMenu.bilgesettings.bilgeminheal then
					CastSpell(BilgeSlot, LastAttackedEnemy)
				end
			end
		end
	end
end

--------------------------------
---------- Menu Hooks ----------
--------------------------------
function scriptConfig:_DrawParam(varIndex)
	_CPS_Master = GetSave("scriptConfig")["Master"]
	_CPS_Master.py1 = 0
	_CPS_Master.py2 = _CPS_Master.py
	_CPS_Master.color = { lgrey = 1413167931, grey = 4290427578, green = 1409321728}
	_CPS_Master.fontSize = WINDOW_H and math.round(WINDOW_H / 54) or 14
	_CPS_Master.midSize = _CPS_Master.fontSize / 2
	_CPS_Master.cellSize = _CPS_Master.fontSize + 2
	_CPS_Master.width = WINDOW_W and math.round(WINDOW_W / 4.8) or 213
	_CPS_Master.row = _CPS_Master.width * 0.7
	_CPS_Master.row4 = _CPS_Master.width * 0.9
	_CPS_Master.row3 = _CPS_Master.width * 0.8
	_CPS_Master.row2 = _CPS_Master.width * 0.7
	_CPS_Master.row1 = _CPS_Master.width * 0.6

    local pVar = self._param[varIndex].var
	local pText = self._param[varIndex].text
	if self.name == "sidasacvayne" or self.name == "sidasacvayne_sidasacvaynesub" then
		self._param[varIndex].pType = 5
		self._param[varIndex].text = "ShadowVayne found. Set the Keysettings there!"
	end
	if (self.name == "sidasacsetup_sidasacautocarrysub" and pText == "Hotkey")
	or (self.name == "sidasacsetup_sidasacmixedmodesub" and pText == "Hotkey")
	or (self.name == "sidasacsetup_sidasaclaneclearsub" and pText == "Hotkey")
	or (self.name == "sidasacsetup_sidasaclasthitsub" and pText == "Hotkey")
	or (pVar == "ShadowHijacked")
	then
		self._param[varIndex].pType = 5
		self._param[varIndex].text = "ShadowVayne found. Set the Keysettings there!"
	end

	if not ((self.name == "SV_SOW" and pVar == "Mode1" and pText == "Mixed Mode!") -- SOW MixedMode
	or (self.name == "SV_SOW" and pVar == "Mode3" and pText == "Last hit!") -- SOW LastHit
	or (self.name == "SV_SOW" and pVar == "Mode2" and pText == "Laneclear!") -- SOW LaneClear
	or (self.name == "SV_SOW" and pVar == "Mode0" and pText == "Carry me!") -- SOW AutoCarry
	or (self.name == "SV_SOW" and pVar == "Hotkeys" and pText == "")
	or (self.name == "SV_MAIN_keysetting" and pVar == "SACAutoCarry")
	or (self.name == "SV_MAIN_keysetting" and pVar == "SACMixedMode")
	or (self.name == "SV_MAIN_keysetting" and pVar == "SACLaneClear")
	or (self.name == "SV_MAIN_keysetting" and pVar == "SACLastHit")
	or (self.name == "sidasacvayne" and pVar ~= "toggleMode")
	or (self.name == "sidasacvayne_sidasacvaynesub")
	or (pText == "HideParam")
	)
	then

--~ 		if string.find(pText, "Auto Carry") and self.name == "sidasacsetup_sidasacautocarrysub" then
--~ 			print(pVar)
--~ 		end
		DrawLine(self._x - 2, self._y + _CPS_Master.midSize, self._x + _CPS_Master.row3 - 2, self._y + _CPS_Master.midSize, _CPS_Master.cellSize, _CPS_Master.color.lgrey)
		DrawText(self._param[varIndex].text, _CPS_Master.fontSize, self._x, self._y, _CPS_Master.color.grey)
		if self._param[varIndex].pType == SCRIPT_PARAM_SLICE then
			DrawText(tostring(self[pVar]), _CPS_Master.fontSize, self._x + _CPS_Master.row2, self._y, _CPS_Master.color.grey)
			DrawLine(self._x + _CPS_Master.row3, self._y + _CPS_Master.midSize, self._x + _CPS_Master.width + 2, self._y + _CPS_Master.midSize, _CPS_Master.cellSize, _CPS_Master.color.lgrey)
			-- cursor
			self._param[varIndex].cursor = (self[pVar] - self._param[varIndex].min) / (self._param[varIndex].max - self._param[varIndex].min) * (_CPS_Master.width - _CPS_Master.row3)
			DrawLine(self._x + _CPS_Master.row3 + self._param[varIndex].cursor - 2, self._y + _CPS_Master.midSize, self._x + _CPS_Master.row3 + self._param[varIndex].cursor + 2, self._y + _CPS_Master.midSize, _CPS_Master.cellSize, 4292598640)
		elseif self._param[varIndex].pType == SCRIPT_PARAM_LIST then
			local text = tostring(self._param[varIndex].listTable[self[pVar]])
			local maxWidth = (_CPS_Master.width - _CPS_Master.row3) * 0.8
			local textWidth = GetTextArea(text, _CPS_Master.fontSize).x
			if textWidth > maxWidth then
				text = text:sub(1, math.floor(text:len() * maxWidth / textWidth)) .. ".."
			end
			DrawText(text, _CPS_Master.fontSize, self._x + _CPS_Master.row3, self._y, _CPS_Master.color.grey)
			if self._list then self._listY = self._y + _CPS_Master.cellSize end
		elseif self._param[varIndex].pType == SCRIPT_PARAM_INFO then
			if not (
			(self.name == "sidasacvayne")
			or (self.name == "sidasacsetup_sidasacautocarrysub" and pVar == "Active")
			or (self.name == "sidasacsetup_sidasacmixedmodesub" and pVar == "Active")
			or (self.name == "sidasacsetup_sidasaclaneclearsub" and pVar == "Active")
			or (self.name == "sidasacsetup_sidasaclasthitsub" and pVar == "Active")
			or (self.name == "MMA2013" and pVar == "ShadowHijacked")
			) then
				DrawText(tostring(self[pVar]), _CPS_Master.fontSize, self._x + _CPS_Master.row3 + 2, self._y, _CPS_Master.color.grey)
			end
		elseif self._param[varIndex].pType == SCRIPT_PARAM_COLOR then
			DrawRectangle(self._x + _CPS_Master.row3 + 2, self._y, 80, _CPS_Master.cellSize, ARGB(self[pVar][1], self[pVar][2], self[pVar][3], self[pVar][4]))
		else


			if (self._param[varIndex].pType == SCRIPT_PARAM_ONKEYDOWN or self._param[varIndex].pType == SCRIPT_PARAM_ONKEYTOGGLE) then
				DrawText(self:_txtKey(self._param[varIndex].key), _CPS_Master.fontSize, self._x + _CPS_Master.row2, self._y, _CPS_Master.color.grey)
			end
			DrawLine(self._x + _CPS_Master.row3, self._y + _CPS_Master.midSize, self._x + _CPS_Master.width + 2, self._y + _CPS_Master.midSize, _CPS_Master.cellSize, (self[pVar] and _CPS_Master.color.green or _CPS_Master.color.lgrey))
			DrawText((self[pVar] and "        ON" or "        OFF"), _CPS_Master.fontSize, self._x + _CPS_Master.row3 + 2, self._y, _CPS_Master.color.grey)
			end
		self._y = self._y + _CPS_Master.cellSize
	else
		self._param[varIndex].pType = 5
	end
end

function scriptConfig:_DrawSubInstance(index)
 	_CPS_Master = GetSave("scriptConfig")["Master"]
	_CPS_Master.py1 = 0
	_CPS_Master.py2 = _CPS_Master.py
	_CPS_Master.color = { lgrey = 1413167931, grey = 4290427578, red = 1422721024, green = 1409321728, ivory = 4294967280 }
	_CPS_Master.fontSize = WINDOW_H and math.round(WINDOW_H / 54) or 14
	_CPS_Master.midSize = _CPS_Master.fontSize / 2
	_CPS_Master.cellSize = _CPS_Master.fontSize + 2
	_CPS_Master.width = WINDOW_W and math.round(WINDOW_W / 4.8) or 213
	_CPS_Master.row = _CPS_Master.width * 0.7
	_CPS_Master.row4 = _CPS_Master.width * 0.9
	_CPS_Master.row3 = _CPS_Master.width * 0.8
	_CPS_Master.row2 = _CPS_Master.width * 0.7
	_CPS_Master.row1 = _CPS_Master.width * 0.6
	if (self._subInstances[index].name == "sidasacvayne_sidasacvaynesub") then
		self._subInstances[index].header = ""
		self._subMenuIndex = 0
	end
	if not ((self._subInstances[index].name == "sidasacvayne_sidasacvaynesub") or (self._subInstances[index].name == "sidasacvayne_sidasacvayneallowed")) then
		local pVar = self._subInstances[index].name
		local selected = self._subMenuIndex == index
		DrawLine(self._x - 2, self._y + _CPS_Master.midSize, self._x + _CPS_Master.width + 2, self._y + _CPS_Master.midSize, _CPS_Master.cellSize, (selected and _CPS_Master.color.red or _CPS_Master.color.lgrey))
		DrawText(self._subInstances[index].header, _CPS_Master.fontSize, self._x, self._y, (selected and _CPS_Master.color.ivory or _CPS_Master.color.grey))
		DrawText("        >>", _CPS_Master.fontSize, self._x + _CPS_Master.row3 + 2, self._y, (selected and _CPS_Master.color.ivory or _CPS_Master.color.grey))
		--_SC._Idraw.y = _SC._Idraw.y + _SC.draw.cellSize
		self._y = self._y + _CPS_Master.cellSize
	end
end