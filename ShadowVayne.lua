--[[

	Shadow Vayne Script by Superx321
	Version: 3.07

	For Functions & Changelog, check the Thread on the BoL Forums:
	http://botoflegends.com/forum/topic/18939-shadow-vayne-the-mighty-hunter/

	If anything is not working or u wish a new Function, let me know it

	Thx to Jus & Hellsing for minor helping, Manciuszz for his Gapcloserlist and Klokje for his Interruptlist
	]]
if myHero.charName ~= "Vayne" then return end
if not VIP_USER then
	rawset(_G, "LoadVIPScript", function() return end)
end
MainScriptName = GetCurrentEnv().FILE_NAME

local informationTable, AAInfoTable, CastedLastE, ScriptStartTick = {}, {}, 0, 0
local TickCountScriptStart, OnLoadDone, spellExpired, Beta = GetTickCount(), nil, true, false
local ScriptOnLoadDone, LastAttackedEnemy = false, nil
local LastPrioUpdate = 0
local DownloadStarted = false
local HookSOWMenu = {}
LastE = 0

_SC = { init = true, initDraw = true, menuKey = 16, useTS = false, menuIndex = -1, instances = {}, _changeKey = false, _changeKeyInstance = false, _sliceInstance = false, _listInstance = false }
if not GetSave("scriptConfig")["Master"] then GetSave("scriptConfig")["Master"] = {} end
_SC.master = GetSave("scriptConfig")["Master"]
_SC.masterIndex = 0

_G.scriptConfig.CustomaddParam = _G.scriptConfig.addParam
_G.scriptConfig.addParam = function(self, pVar, pText, pType, defaultValue, a, b, c, d)
if pVar == "scriptActive" or pVar == "lastHitting" or pVar == "laneClear" or pVar == "hybridMode" then pVar = "ShadowHijacked" end
if (self.name == "sidasacsetup_sidasacautocarrysub" and pText == "Hotkey")
	or (self.name == "sidasacsetup_sidasacmixedmodesub" and pText == "Hotkey")
	or (self.name == "sidasacsetup_sidasaclaneclearsub" and pText == "Hotkey")
	or (self.name == "sidasacsetup_sidasaclasthitsub" and pText == "Hotkey") then
pText = "ShadowVayne found. Set the Keysettings there!"
pType = 5
end
--~ if pType:lower():find("hotkey") then print(pText, " ", pType, " ", defaultValue," ", a," ",b," ",pVar.name) end
 _G.scriptConfig.CustomaddParam(self, pVar, pText, pType, defaultValue, a, b, c, d)
 end

 CustomRequire = function(LibName, LoadedMsg, VersionHost, VersionPath, ScriptPath, UpdatedMsg, FastLoadVersion, DownloadMsg, WaitScriptLoaded)
	if WaitScriptLoaded and not ScriptStartOver then
		DelayAction(function() CustomRequire(LibName, nil, VersionHost, VersionPath, ScriptPath, "<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">LibName Updated, please reload</font>", nil, DownloadMsg, true) end, 0.5)
	else
		if not DoingALib then
			DoingALib = true
			if not _RequireTable then _RequireTable = {} end
			if not _RequireTable[LibName] then _RequireTable[LibName] = {} end

			local GetLocalVersion = function()
				if not FileExist(LIB_PATH..LibName..".lua") then
					LibNameFile = io.open(LIB_PATH.."/"..LibName..".lua", "w+")
					LibNameFile:write("version = 0")
					LibNameFile:close()
				end
				LibNameFile = io.open(LIB_PATH.."/"..LibName..".lua", "r")
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

			local SwapAutoUpdate = function(SwapState)
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
				LibNameFile = io.open(LIB_PATH.."/"..LibName..".lua", "w+")
				LibNameFile:write(StartString..ReplaceString..EndString)
				LibNameFile:close()
			end

			local RequireTheLib = function()
				SwapAutoUpdate(false)
				require(LibName)
				if LoadedMsg ~= nil then
					LoadedMsg = string.gsub(LoadedMsg, "localversion", GetLocalVersion())
					print(LoadedMsg)
				end
				if UpdatedMsg ~= nil and _RequireTable[LibName]["oldversion"] ~= nil then
					UpdatedMsg = string.gsub(UpdatedMsg, "localversion", _RequireTable[LibName]["oldversion"])
					UpdatedMsg = string.gsub(UpdatedMsg, "serverversion", _RequireTable[LibName]["newversion"])
					UpdatedMsg = string.gsub(UpdatedMsg, "LibName", LibName)
					print(UpdatedMsg)
				end
				SwapAutoUpdate(true)
				 _RequireTable[LibName]["required"] = true
				DoingALib = false
			end

			local AfterDownloadFile = function()
				_RequireTable[LibName]["updated"] = true
				RequireTheLib()
			end

			local AfterGetVersion = function(WebDataVersion)
				WebVersion = tonumber(WebDataVersion)
				LocalVersion = tonumber(GetLocalVersion())
				if WebVersion > LocalVersion then
					_RequireTable[LibName]["oldversion"] = LocalVersion
					_RequireTable[LibName]["newversion"] = WebVersion
					DownloadMsg = string.gsub(DownloadMsg, "LibName", LibName)
					print(DownloadMsg)
					DelayAction(function() DownloadFile(ScriptPath.."?rand="..tostring(math.random(1000)), LIB_PATH..LibName..".lua", function() AfterDownloadFile();_RequireTable[LibName]["waitinglateupdate"] = false end) end, 1)
				else
					_RequireTable[LibName]["updated"] = false
					_RequireTable[LibName]["waitinglateupdate"] = false
					RequireTheLib()
				end
			end

			if VersionHost ~= nil and VersionPath ~= nil and ScriptPath~= nil then
				if FastLoadVersion ~= nil and tonumber(FastLoadVersion*1000) <= tonumber(GetLocalVersion()*1000) then
					RequireTheLib()
					DelayAction(function() CustomRequire(LibName, nil, VersionHost, VersionPath, ScriptPath, "<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">LibName Updated, please reload</font>", nil, DownloadMsg, true) end, 0.5)
					_RequireTable[LibName]["waitinglateupdate"] = true
				else
					GetAsyncWebResult(VersionHost, VersionPath, tostring(math.random(1000)), function(x) AfterGetVersion(x) end)
				end
			else
				RequireTheLib()
			end
		else
			DelayAction(function() CustomRequire(LibName, LoadedMsg, VersionHost, VersionPath, ScriptPath, UpdatedMsg, FastLoadVersion, DownloadMsg) end, 0.5)
		end
	end
end
CustomRequire("SourceLib", nil, "raw.github.com", "/TheRealSource/public/master/common/SourceLib.version", "http://raw.github.com/TheRealSource/public/master/common/SourceLib.lua", "<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">LibName Updated</font>", 1.059, "<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">Updating SourceLib, please wait...</font>")
CustomRequire("SOW", nil, "raw.github.com", "/Hellsing/BoL/master/version/SOW.version", "http://raw.github.com/Hellsing/BoL/master/common/SOW.lua", "<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">LibName Updated</font>", 1.129, "<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">Updating SOW, please wait...</font>")
--~ CustomRequire("VPrediction")
CustomRequire("VPrediction", nil, "raw.github.com", "/Hellsing/BoL/master/version/VPrediction.version", "http://raw.github.com/Hellsing/BoL/master/common/VPrediction.lua", "<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">LibName Updated</font>", 2.50, "<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">Updating VPrediction, please wait...</font>")
CustomRequire("Selector", nil, "raw.github.com", "/pqmailer/BoL_Scripts/master/Paid/Selector.revision", "http://raw.github.com/pqmailer/BoL_Scripts/master/Paid/Selector.lua", "<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">LibName Updated</font>", 0.12, "<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">Updating Selector, please wait...</font>")
CustomRequire("CustomPermaShow", nil, "raw.github.com", "/Superx321/BoL/master/common/CustomPermaShow.Version", "http://raw.github.com/Superx321/BoL/master/common/CustomPermaShow.lua", "<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">LibName Updated</font>", 1.02, "<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">Updating LibName, please wait...</font>")
--~ require "VPrediction2431"
--~ require "VPrediction"
--~ _RequireTable["VPrediction"] = {["required"] = true}

function _GetLocalVersion(LibName, StartPos, EndPos)
	if LibName == "SHADOWVAYNE" then
		LibNameFile = io.open(SCRIPT_PATH.."/"..MainScriptName, "r")
		LibNameString = LibNameFile:read("*a")
		LibNameFile:close()
		return tonumber(string.sub(LibNameString, 51, 54))
	else
		LibNameFile = io.open(LIB_PATH.."/"..LibName..".lua", "r")
		LibNameString = LibNameFile:read("*a")
		LibNamePos, Dummy = string.find(LibNameString, "local version =")
		if LibNamePos == nil then LibNamePos, Dummy = string.find(LibNameString, "@version") end
		LibNameFile:close()
		return tonumber(string.sub(LibNameString, LibNamePos+StartPos, LibNamePos+EndPos))
	end
end

function _CheckScriptUpdate()
	if (_RequireTable["SourceLib"]["waitinglateupdate"] ~= nil and _RequireTable["SourceLib"]["waitinglateupdate"] == true)
	or (_RequireTable["SOW"]["waitinglateupdate"] ~= nil and _RequireTable["SOW"]["waitinglateupdate"] == true)
	or (_RequireTable["VPrediction"]["waitinglateupdate"] ~= nil and _RequireTable["VPrediction"]["waitinglateupdate"] == true)
	or (_RequireTable["Selector"]["waitinglateupdate"] ~= nil and _RequireTable["Selector"]["waitinglateupdate"] == true)
	or (_RequireTable["CustomPermaShow"]["waitinglateupdate"] ~= nil and _RequireTable["CustomPermaShow"]["waitinglateupdate"] == true)
	then UpdateWait = true else UpdateWait = false end

	if not UpdateFinished and not UpdateWait then
		if not DownloadingLib and _LibUpdateTable["SHADOWVAYNE"]["SERVERVERSION"] == nil then
			DownloadingLib = true
			GetAsyncWebResult("raw.github.com", _LibUpdateTable["SHADOWVAYNE"]["VERSION"], tostring(math.random(1000)), function(x) _LibUpdateTable["SHADOWVAYNE"]["SERVERVERSION"] = tonumber(x);DelayAction(function() DownloadingLib = false end, 0.5) end)
		end

		if not DownloadingLib and _LibUpdateTable["SHADOWVAYNE"]["SERVERVERSION"] ~= nil then
			if _LibUpdateTable["SHADOWVAYNE"]["SERVERVERSION"] > _GetLocalVersion("SHADOWVAYNE") then
				_PrintScriptMsg("New Update available: Version ".._LibUpdateTable["SHADOWVAYNE"]["SERVERVERSION"])
				if VayneMenu.autoup.autoupcheck then
					_PrintScriptMsg("Downloading, please wait...")
					DelayAction(function() DownloadFile(_LibUpdateTable["SHADOWVAYNE"]["SCRIPT"], SCRIPT_PATH.."/"..MainScriptName, function() DelayAction(function() DownloadingLib = false end, 0.5);_PrintScriptMsg("Successfully updated to Version ".._LibUpdateTable["SHADOWVAYNE"]["SERVERVERSION"]);_PrintScriptMsg("Please Reload with F9") end) end, 1)
					UpdateFinished = true
					DownloadingLib = true
				else
					UpdateFinished = true
					_PrintScriptMsg("AutoUpdate is off. Turn it on for Auto-Download")
				end
			else
				_PrintScriptMsg("No Updates available.")
				UpdateFinished = true
			end
		end
	end
end

function OnTick()
	if _LibUpdateTable == nil then
		_LibUpdateTable = { ["SHADOWVAYNE"] = {} }
		_LibUpdateTable["SHADOWVAYNE"]["VERSION"] = "/Superx321/BoL/master/ShadowVayne.Version"
		_LibUpdateTable["SHADOWVAYNE"]["SCRIPT"] = "http://raw.github.com/Superx321/BoL/master/ShadowVayne.lua"
	end
	if not ScriptStartOver
	and _RequireTable["SourceLib"] ~= nil and _RequireTable["SourceLib"]["required"] == true
	and _RequireTable["VPrediction"] ~= nil and _RequireTable["VPrediction"]["required"] == true
	and _RequireTable["SOW"] ~= nil and _RequireTable["SOW"]["required"] == true
	and _RequireTable["Selector"] ~= nil and _RequireTable["Selector"]["required"] == true
	and _RequireTable["CustomPermaShow"] ~= nil and _RequireTable["CustomPermaShow"]["required"] == true then
		_CheckSACMMASOW()
		if SAC_V84 and not SACLoaded then
			if not AuthWaitPrint then _PrintScriptMsg("Waiting for SAC:Reborn Auth");AuthWaitPrint=true end
			SACWait = true
		end

		if SAC_V84 and SACLoaded then
			SACWait = false
		end

		if not SACWait then
			print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">All Libs loaded</font>")
			ScriptStartOver = true
			VP = VPrediction(true)
			_LoadTables()
			_HijackPrintChat()
			_LoadMenu()
			AddTickCallback(_CheckScriptUpdate)
			AddTickCallback(_GetRunningModes)
			if VIP_USER then
				AddTickCallback(_CheckEnemyStunnAbleBeta)
			else
				AddTickCallback(_CheckEnemyStunnAble)
			end
			AddTickCallback(_NonTargetGapCloserAfterCast)
			AddTickCallback(_ClickThreshLantern)
			AddTickCallback(_UsePermaShows)
			AddTickCallback(_UseSelector)
			AddTickCallback(_UseTumble)
			AddTickCallback(_UseBotRK)
			AddTickCallback(_UseBilgeWater)
			AddTickCallback(_SetToggleMode)
			AddTickCallback(_WallTumble)
			AddDrawCallback(_WallTumbleDraw)
			autoLevelSetFunction(_AutoLevelSpell)
			autoLevelSetSequence({0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
			ScriptOnLoadDone = true
			_G.HidePermaShow = {["LaneClear OnHold:"] = true,["Orbwalk OnHold:"] = true, ["LastHit OnHold:"] = true, ["HybridMode OnHold:"] = true,}
			_G.HidePermaShow["Condemn on next BasicAttack:"] = true
			_G.HidePermaShow["Auto Carry"] = true
			_G.HidePermaShow["Last Hit"] = true
			_G.HidePermaShow["Mixed Mode"] = true
			_G.HidePermaShow["Lane Clear"] = true
			_G.HidePermaShow["              Sida's Auto Carry: Reborn"] = true
			_G.HidePermaShow["Auto-Condemn"] = true
			_G.HidePermaShow["ShadowVayne found. Set the Keysettings there!"] = true
		end
	end
end

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

function _SetToggleMode()
	if VayneMenu.keysetting.togglemode then
		VayneMenu.keysetting._param[7].pType = SCRIPT_PARAM_ONKEYTOGGLE
		VayneMenu.keysetting._param[8].pType = SCRIPT_PARAM_ONKEYTOGGLE
		VayneMenu.keysetting._param[9].pType = SCRIPT_PARAM_ONKEYTOGGLE
		VayneMenu.keysetting._param[10].pType = SCRIPT_PARAM_ONKEYTOGGLE
	else
		VayneMenu.keysetting._param[7].pType = SCRIPT_PARAM_ONKEYDOWN
		VayneMenu.keysetting._param[8].pType = SCRIPT_PARAM_ONKEYDOWN
		VayneMenu.keysetting._param[9].pType = SCRIPT_PARAM_ONKEYDOWN
		VayneMenu.keysetting._param[10].pType = SCRIPT_PARAM_ONKEYDOWN
	end
end

function RoundNumber(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

function _WallTumble()
	if VIP_USER then
		if myHero:CanUseSpell(_Q) ~= READY then TumbleOverWall_1, TumbleOverWall_2 = false,false end
		if TumbleOverWall_1 and VayneMenu.walltumble.spot1 then
			if GetDistance(TumbleSpots.StandPos_1) <= 25 then
				TumbleOverWall_1 = false
				CastSpell(_Q, TumbleSpots.CastPos_1.x,  TumbleSpots.CastPos_1.y)
				myHero:HoldPosition()
			else
				if GetDistance(TumbleSpots.StandPos_1) > 25 then myHero:MoveTo(TumbleSpots.StandPos_1.x, TumbleSpots.StandPos_1.y) end
			end
		end
		if TumbleOverWall_2 and VayneMenu.walltumble.spot2 then
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
		if VayneMenu.walltumble.spot1 then
			if GetDistance(TumbleSpots.VisionPos_1) < 125 or GetDistance(TumbleSpots.VisionPos_1, mousePos) < 125 then
				DrawCircle(TumbleSpots.VisionPos_1.x, TumbleSpots.VisionPos_1.y, TumbleSpots.VisionPos_1.z, 100, 0x107458)
			else
				DrawCircle(TumbleSpots.VisionPos_1.x, TumbleSpots.VisionPos_1.y, TumbleSpots.VisionPos_1.z, 100, 0x80FFFF)
			end
		end
		if VayneMenu.walltumble.spot2 then
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
			if VayneMenu.walltumble.spot1 then
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

			if VayneMenu.walltumble.spot2 then
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
			if TumbleOverWall_1 == true and VayneMenu.walltumble.spot1 then
				RunToX, RunToY = TumbleSpots.StandPos_1.x, TumbleSpots.StandPos_1.y
				if not (P_X2 == RunToX and P_Y2 == RunToY) then
					p:Block()
					myHero:MoveTo(TumbleSpots.StandPos_1.x, TumbleSpots.StandPos_1.y)
				end
			end
			if TumbleOverWall_2 == true and VayneMenu.walltumble.spot2 then
				RunToX, RunToY = TumbleSpots.StandPos_2.x, TumbleSpots.StandPos_2.y
				if not (P_X2 == RunToX and P_Y2 == RunToY) then
					p:Block()
					myHero:MoveTo(TumbleSpots.StandPos_2.x, TumbleSpots.StandPos_2.y)
				end
			end
		end
	end
end

function _CallBackAfterAA()
	if VayneMenu.keysetting.basiccondemn and LastAttackedEnemy.type == myHero.type then -- Auto-E after AA
		CastSpell(_E, LastAttackedEnemy)
		VayneMenu.keysetting.basiccondemn = false
	end
end

function _UseTumble()
	if IsAttacking == false and not myHero.dead and myHero:CanUseSpell(_Q) == READY and LastAttackedEnemy ~= nil then
		if  (VayneMenu.tumble.Qautocarry and ShadowVayneAutoCarry and (100/myHero.maxMana*myHero.mana > VayneMenu.tumble.QManaAutoCarry)) or
			(VayneMenu.tumble.Qmixedmode and ShadowVayneMixedMode and (100/myHero.maxMana*myHero.mana > VayneMenu.tumble.QManaMixedMode)) or
			(VayneMenu.tumble.Qlaneclear and ShadowVayneLaneClear and (100/myHero.maxMana*myHero.mana > VayneMenu.tumble.QManaLaneClear)) or
			(VayneMenu.tumble.Qlasthit and  ShadowVayneLastHit and (100/myHero.maxMana*myHero.mana > VayneMenu.tumble.QManaLastHit)) or
			(VayneMenu.tumble.Qalways) then
			local AfterTumblePos = myHero + (Vector(mousePos) - myHero):normalized() * 295
			if GetDistance(AfterTumblePos, LastAttackedEnemy) < 650 then
				CastSpell(_Q, mousePos.x, mousePos.z)
			end
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

function enc(data)
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

function OnDraw()
	if ScriptOnLoadDone then
		if VayneMenu.draw.DrawNeededAutohits then
			for i, enemy in ipairs(GetEnemyHeroes()) do
				DrawText(tostring(_GetNeededAutoHits(enemy)),16,GetUnitHPBarPos(enemy).x,GetUnitHPBarPos(enemy).y,0xFF80FF00)
			end
		end

		if VayneMenu.draw.DrawERange then
			if VayneMenu.draw.DrawEColor == 1 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 710, 0x80FFFF)
			elseif VayneMenu.draw.DrawEColor == 2 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 710, 0x0080FF)
			elseif VayneMenu.draw.DrawEColor == 3 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 710, 0x5555FF)
			elseif VayneMenu.draw.DrawEColor == 4 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 710, 0xFF2D2D)
			elseif VayneMenu.draw.DrawEColor == 5 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 710, 0x8B42B3)
			end
		end

		if VayneMenu.draw.DrawAARange then
			if VayneMenu.draw.DrawAAColor == 1 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 655, 0x80FFFF)
			elseif VayneMenu.draw.DrawAAColor == 2 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 655, 0x0080FF)
			elseif VayneMenu.draw.DrawAAColor == 3 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 655, 0x5555FF)
			elseif VayneMenu.draw.DrawAAColor == 4 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 655, 0xFF2D2D)
			elseif VayneMenu.draw.DrawAAColor == 5 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 655, 0x8B42B3)
			end
		end
	end
end

function OnProcessSpell(unit, spell)
	if not myHero.dead and ScriptOnLoadDone then
		-- AntiGapCloser Targeted Spells
		if isAGapcloserUnitTarget[unit.charName] and spell.name == isAGapcloserUnitTarget[unit.charName].spell and unit.team ~= myHero.team then
			if spell.target ~= nil and spell.target.hash == myHero.hash then
				if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / AutoCarry Mode") end
				if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Lasthit Mode") end
				if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Mixed Mode") end
				if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Laneclear Mode") end
				if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."Always"] then _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Always") end
				if VayneMenu.autostunn.OverwriteAutoCarry and ShadowVayneAutoCarry then  _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / AutoCarry Mode") end
				if VayneMenu.autostunn.OverwriteMixedMode and ShadowVayneMixedMode then  _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / AutoCarry Mode") end
				if VayneMenu.autostunn.OverwriteLaneClear and ShadowVayneLaneClear then  _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / AutoCarry Mode") end
				if VayneMenu.autostunn.OverwriteLastHit and ShadowVayneLastHit then  _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / AutoCarry Mode") end
				if VayneMenu.autostunn.Overwritealways then  _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / AutoCarry Mode") end
			end
		end

		-- AntiGapCloser Interrupt Spells
		if isAChampToInterrupt[spell.name] and unit.charName == isAChampToInterrupt[spell.name].champ and GetDistance(unit) <= 715 and unit.team ~= myHero.team then
			if VayneMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then _CastESpell(unit, "Interrupt ("..(spell.name)..") / AutoCarry Mode") end
			if VayneMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then _CastESpell(unit, "Interrupt ("..(spell.name)..") / Lasthit Mode") end
			if VayneMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then _CastESpell(unit, "Interrupt ("..(spell.name)..") / Mixed Mode") end
			if VayneMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then _CastESpell(unit, "Interrupt ("..(spell.name)..") / Laneclear Mode") end
			if VayneMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."Always"] then _CastESpell(unit, "Interrupt ("..(spell.name)..") / Always") end
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

		--~ 			if spell.name:find("VayneCondemn") then -- E detected, cooldown for next E 500 ticks
--~ 				CastedLastE = GetTickCount() + 500
--~ 			end
--~ 		end

		if isAGapcloserUnitNoTarget[spell.name] and GetDistance(unit) <= 2000 and (spell.target == nil or spell.target.isMe) and unit.team ~= myHero.team then
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then spellExpired = false end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then spellExpired = false end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then spellExpired = false end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then spellExpired = false end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."Always"] then spellExpired = false end
			if VayneMenu.autostunn.OverwriteAutoCarry and ShadowVayneAutoCarry then spellExpired = false end
			if VayneMenu.autostunn.OverwriteMixedMode and ShadowVayneMixedMode then spellExpired = false end
			if VayneMenu.autostunn.OverwriteLaneClear and ShadowVayneLaneClear then spellExpired = false end
			if VayneMenu.autostunn.OverwriteLastHit and ShadowVayneLastHit then spellExpired = false end
			if VayneMenu.autostunn.Overwritealways then spellExpired = false end
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

function _AutoLevelSpell()
	if GetGame().map.index == 8 and myHero.level < 4 then
		LevelSpell(_Q)
		LevelSpell(_W)
		LevelSpell(_E)
	end

	if VayneMenu.autolevel.UseAutoLevelfirst and myHero.level < 4 then
		return AutoLevelSpellTable[AutoLevelSpellTable["SpellOrder"][VayneMenu.autolevel.first3level]][myHero.level]
	end

	if VayneMenu.autolevel.UseAutoLevelrest and myHero.level > 3 then
		return AutoLevelSpellTable[AutoLevelSpellTable["SpellOrder"][VayneMenu.autolevel.restlevel]][myHero.level]
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

function _UseSelector()
	if VIP_USER and UseVIPSelector and _G.Selector_Enabled then
		local currentTarget = GetTarget()
		if currentTarget ~= nil and currentTarget.type == "obj_AI_Hero" and ValidTarget(currentTarget, 550, true) then
			selected = currentTarget
		else
			selected = nil
		end
		if selected ~= nil then
			SOW:ForceTarget(selected)
		else
			GetVIPSelectorTarget = Selector.GetTarget()
			if GetVIPSelectorTarget ~= nil and ValidTarget(GetVIPSelectorTarget) then
				SOW:ForceTarget(GetVIPSelectorTarget)
			end
		end
	end
end

function _UsePermaShows()
	CustomPermaShow("AutoCarry (Using "..AutoCarryOrbText..")", VayneMenu.keysetting.autocarry, VayneMenu.permashowsettings.carrypermashow, nil, 1426521024, nil, 1)
	CustomPermaShow("MixedMode (Using "..MixedModeOrbText..")", VayneMenu.keysetting.mixedmode, VayneMenu.permashowsettings.mixedpermashow, nil, 1426521024, nil, 2)
	CustomPermaShow("LaneClear (Using "..LaneClearOrbText..")", VayneMenu.keysetting.laneclear, VayneMenu.permashowsettings.laneclearpermashow, nil, 1426521024, nil, 3)
	CustomPermaShow("LastHit (Using "..LastHitOrbText..")", VayneMenu.keysetting.lasthit, VayneMenu.permashowsettings.lasthitpermashow, nil, 1426521024, nil, 4)
	CustomPermaShow("Auto-E after next BasicAttack", VayneMenu.keysetting.basiccondemn, VayneMenu.permashowsettings.epermashow, nil, 1426521024, nil,  5)
end

function OnCreateObj(Obj)
	if Obj.name == "ThreshLantern" then
		LanternObj = Obj
	end
end

function _CastESpell(Target, Reason, Delay)
	if VIP_USER and VayneMenu.vip.EPackets then
		DelayAction(function() Packet('S_CAST', { spellId = _E, targetNetworkId = Target.networkID }):send(true) end, Delay)
	else
		DelayAction(function() CastSpell(_E, Target) end, Delay)
	end
	CastedLastE = GetTickCount() + 500
end

function _CheckEnemyStunnAble()
	if not myHero.dead and myHero:CanUseSpell(_E) == READY and CastedLastE < GetTickCount() then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if 	(VayneMenu.targets[enemy.charName][(enemy.charName).."AutoCarry"] and ShadowVayneAutoCarry) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."MixedMode"] and ShadowVayneMixedMode) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."LaneClear"] and ShadowVayneLaneClear) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."LastHit"] and ShadowVayneLastHit) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."Always"])	then
				if GetDistance(enemy, myHero) <= 1000 and not enemy.dead and enemy.visible then
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
					if GetDistance(Vector(StunnPos), myHero) <= 710 then
						local BushFound, Bushpos = false, nil
						for i = 1, VayneMenu.autostunn.pushDistance, 10  do
							local CheckWallPos = Vector(StunnPos) + (Vector(StunnPos) - myHero):normalized()*(i)
							if IsWallOfGrass(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) and not BushFound then
								BushFound = true
								BushPos = CheckWallPos
							end
							if IsWall(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) then
								if UnderTurret(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z), true) then
									if VayneMenu.autostunn.towerstunn then
										_CastPacketSpell(_E, enemy)
										CastedLastE = GetTickCount() + 500
										_ScriptDebugMsg("Target: "..(enemy.charName)..", Reason: Autostunn, Field: UnderTower, Bush: "..(tostring(BushFound)), "stunndebug")
										break
									end
								else
									_CastPacketSpell(_E, enemy)
									if BushFound and VayneMenu.autostunn.trinket and myHero:CanUseSpell(ITEM_7) == 0 then
										CastSpell(ITEM_7, BushPos.x, BushPos.z)
									end
									_ScriptDebugMsg("Target: "..(enemy.charName)..", Reason: Autostunn, Field: NoTower, Bush: "..(tostring(BushFound)), "stunndebug")
									break
								end
							end
						end
					end
				end
			end
		end
	end
end

function _CheckStunnAngle(enemy)
	local CurrentDirection = (Vector(enemy) - ChampInfoTable[enemy.charName].CurrentVector)
	if CurrentDirection ~= Vector(0,0,0) then
		CurrentDirection = CurrentDirection:normalized()
	end
	ChampInfoTable[enemy.charName].CurrentAngle = ChampInfoTable[enemy.charName].CurrentDirection:dotP( CurrentDirection )
	ChampInfoTable[enemy.charName].CurrentDirection = CurrentDirection
	ChampInfoTable[enemy.charName].CurrentVector = Vector(enemy)
	if ChampInfoTable[enemy.charName].CurrentAngle and ChampInfoTable[enemy.charName].CurrentAngle > 0.8 then
		return true
	else
		return false
	end
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
		if EnemyDistance > 724 then FlyTimeDelay = 280 end
		return FlyTimeDelay
end

function _GetEnemyStunnPos(enemy)
--~ 	if _CheckStunnAngle(enemy) then
		GroundDelay = 0.32
		EnemyPos = VP:GetPredictedPos(enemy, GroundDelay, enemy.ms, myHero, false)
		EnemyDistance = GetDistance(EnemyPos)
		FlyTimeDelay = _GetFlyTime(math.floor(EnemyDistance))
		for i=1,10 do
			EnemyPos = VP:GetPredictedPos(enemy, GroundDelay+FlyTimeDelay, enemy.ms, EnemyPos, false)
			EnemyDistance = GetDistance(EnemyPos)
			FlyTimeDelay = _GetFlyTime(EnemyDistance)
		end
		return VP:GetPredictedPos(enemy, GroundDelay+FlyTimeDelay, enemy.ms, EnemyPos, false)
--~ 	else
--~ 		return false
--~ 	end
end

function _CheckEnemyStunnAbleBeta()
	if not myHero.dead and myHero:CanUseSpell(_E) == READY and LastE < GetTickCount() then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if 	(VayneMenu.targets[enemy.charName][(enemy.charName).."AutoCarry"] and ShadowVayneAutoCarry) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."MixedMode"] and ShadowVayneMixedMode) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."LaneClear"] and ShadowVayneLaneClear) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."LastHit"] and ShadowVayneLastHit) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."Always"])	then
				if not (VayneMenu.autostunn.target and LastAttackedEnemy ~= enemy) then
					if GetDistance(enemy, myHero) <= 1500 and not enemy.dead and enemy.visible then
						EnemyStunnPos = _GetEnemyStunnPos(enemy)
						if EnemyStunnPos ~= false and GetDistance(enemy,EnemyStunnPos) < 300 and GetDistance(EnemyStunnPos) < 650 then
							local BushFound, Bushpos = false, nil
							for i = 1, VayneMenu.autostunn.pushDistance, 10  do
								local CheckWallPos = Vector(EnemyStunnPos) + (Vector(EnemyStunnPos) - myHero):normalized()*(i)
								if IsWallOfGrass(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) and not BushFound then
									BushFound = true
									BushPos = CheckWallPos
								end
								if IsWall(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) and GetDistance(EnemyStunnPos) < 650 then
									if UnderTurret(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z), true) then
										if VayneMenu.autostunn.towerstunn then
											CastSpell(_E, enemy)
											LastE = GetTickCount() + 500
											DrawCirclePos = CheckWallPos
											_ScriptDebugMsg("Target: "..(enemy.charName)..", Reason: Autostunn, Field: UnderTower, Bush: "..(tostring(BushFound)), "stunndebug")
											break
										end
									else
										CastSpell(_E, enemy)
										DrawCirclePos = CheckWallPos
										LastE = GetTickCount() + 500
										if BushFound and VayneMenu.autostunn.trinket and myHero:CanUseSpell(ITEM_7) == 0 then
											CastSpell(ITEM_7, BushPos.x, BushPos.z)
										end
										_ScriptDebugMsg("Target: "..(enemy.charName)..", Reason: Autostunn, Field: NoTower, Bush: "..(tostring(BushFound)), "stunndebug")
										break
									end
								end
							end
						end
					end
				end
			end
		end
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

function _CastPacketSpell(SpellToCast, TargetToCast)
	if VIP_USER and VayneMenu.vip.EPackets then
		Packet('S_CAST', { spellId = SpellToCast, targetNetworkId = TargetToCast.networkID }):send(true)
		CastedLastE = GetTickCount() + 500
	else
		CastSpell(_E, TargetToCast)
		CastedLastE = GetTickCount() + 500
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
				if VayneMenu.vip.EPackets then _CastESpell(informationTable.spellSource, "Gapcloser NonTargeted ("..(informationTable.spellName)..")") end
			end
		else
			spellExpired = true
			informationTable = {}
		end
	end
end

function _PrintScriptMsg(Msg)
	PrintChat("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">"..Msg.."</font>")
end

function _ScriptDebugMsg(Msg, DebugMode)
	if VayneMenu.debug[DebugMode] then
		print("<font color=\"#F0Ff8d\"><b>ShadowVayne Debug:</b></font> <font color=\"#FF0F0F\">"..Msg.."</font>")
	end
end

function _GetRunningModes()
	if VayneMenu.keysetting.autocarry and not ShadowVayneAutoCarry then
		VayneMenu.keysetting.mixedmode = false
		VayneMenu.keysetting.laneclear = false
		VayneMenu.keysetting.lasthit = false
	end

	if VayneMenu.keysetting.mixedmode and not ShadowVayneMixedMode then
		VayneMenu.keysetting.autocarry = false
		VayneMenu.keysetting.laneclear = false
		VayneMenu.keysetting.lasthit = false
	end

	if VayneMenu.keysetting.laneclear then
		VayneMenu.keysetting.autocarry = false
		VayneMenu.keysetting.mixedmode = false
		VayneMenu.keysetting.lasthit = false
	end

	if VayneMenu.keysetting.lasthit then
		VayneMenu.keysetting.mixedmode = false
		VayneMenu.keysetting.laneclear = false
		VayneMenu.keysetting.autocarry = false
	end

	--~ Get the Keysettings from SV
	ShadowVayneAutoCarry = VayneMenu.keysetting.autocarry
	ShadowVayneMixedMode = VayneMenu.keysetting.mixedmode
	ShadowVayneLaneClear = VayneMenu.keysetting.laneclear
	ShadowVayneLastHit = VayneMenu.keysetting.lasthit

	if Recalling or RecallCast then
		ShadowVayneAutoCarry = false
		ShadowVayneMixedMode = false
		ShadowVayneLaneClear = false
		ShadowVayneLastHit = false
	end
	if SACLoaded then Keys.AutoCarry,Keys.MixedMode,Keys.LaneClear,Keys.LastHit = false,false,false,false end
	if RevampedLoaded then REVMenu.AutoCarry,REVMenu.MixedMode,REVMenu.LaneClear,REVMenu.LastHit = false,false,false,false end
	--if SOWLoaded then SOWMenu._param[7].key,SOWMenu._param[8].key,SOWMenu._param[9].key,SOWMenu._param[10].key = 5,5,5,5 end
	if SOWLoaded then SOWMenu.Mode0,SOWMenu.Mode1,SOWMenu.Mode2,SOWMenu.Mode3 = false,false,false,false end
	if MMALoaded then _G.MMA_Orbwalker,_G.MMA_HybridMode,_G.MMA_LaneClear,_G.MMA_LastHit = false,false,false,false end

	--~ Check if one List is Empty
	if VayneMenu.keysetting._param[StartParam].listTable[VayneMenu.keysetting.AutoCarryOrb] == nil then VayneMenu.keysetting.AutoCarryOrb = 1 end
	if VayneMenu.keysetting._param[StartParam+1].listTable[VayneMenu.keysetting.MixedModeOrb] == nil then VayneMenu.keysetting.MixedModeOrb = 1 end
	if VayneMenu.keysetting._param[StartParam+2].listTable[VayneMenu.keysetting.LaneClearOrb] == nil then VayneMenu.keysetting.LaneClearOrb = 1 end
	if VayneMenu.keysetting._param[StartParam+3].listTable[VayneMenu.keysetting.LastHitOrb] == nil then VayneMenu.keysetting.LastHitOrb = 1 end

	--~ Get what is Selected
	AutoCarryOrbText = VayneMenu.keysetting._param[StartParam].listTable[VayneMenu.keysetting.AutoCarryOrb]
	MixedModeOrbText = VayneMenu.keysetting._param[StartParam+1].listTable[VayneMenu.keysetting.MixedModeOrb]
	LaneClearOrbText = VayneMenu.keysetting._param[StartParam+2].listTable[VayneMenu.keysetting.LaneClearOrb]
	LastHitOrbText = VayneMenu.keysetting._param[StartParam+3].listTable[VayneMenu.keysetting.LastHitOrb]

	--~ Set the Modes
	if AutoCarryOrbText == "MMA" then _G.MMA_Orbwalker = ShadowVayneAutoCarry end
	if AutoCarryOrbText == "Reborn" then Keys.AutoCarry = ShadowVayneAutoCarry end
	if AutoCarryOrbText == "SOW" then SOWMenu.Mode0 = ShadowVayneAutoCarry end
	if AutoCarryOrbText == "Revamped" then REVMenu.AutoCarry = ShadowVayneAutoCarry end

	if MixedModeOrbText == "MMA" then _G.MMA_HybridMode = ShadowVayneMixedMode end
	if MixedModeOrbText == "Reborn" then Keys.MixedMode = ShadowVayneMixedMode end
	if MixedModeOrbText == "SOW" then SOWMenu.Mode1 = ShadowVayneMixedMode end
	if MixedModeOrbText == "Revamped" then REVMenu.MixedMode = ShadowVayneMixedMode end

	if LaneClearOrbText == "MMA" then _G.MMA_LaneClear = ShadowVayneLaneClear end
	if LaneClearOrbText == "Reborn" then Keys.LaneClear = ShadowVayneLaneClear end
	if LaneClearOrbText == "SOW" then SOWMenu.Mode2 = ShadowVayneLaneClear end
	if LaneClearOrbText == "Revamped" then REVMenu.LaneClear = ShadowVayneLaneClear end

	if LastHitOrbText == "MMA" then _G.MMA_LastHit = ShadowVayneLastHit end
	if LastHitOrbText == "Reborn" then Keys.LastHit = ShadowVayneLastHit end
	if LastHitOrbText == "SOW" then SOWMenu.Mode3 = ShadowVayneLastHit end
	if LastHitOrbText == "Revamped" then REVMenu.LastHit = ShadowVayneLastHit end

	if SAC_V84 and SACLoaded then
		if AutoCarryOrbText == "Reborn" then
			VayneMenu.keysetting.SACAutoCarry = Keys.AutoCarry
		else
			VayneMenu.keysetting.SACAutoCarry = false
		end
		if MixedModeOrbText == "Reborn" then
			VayneMenu.keysetting.SACMixedMode = Keys.MixedMode
		else
			VayneMenu.keysetting.SACMixedMode = false
		end
		if LaneClearOrbText == "Reborn" then
			VayneMenu.keysetting.SACLaneClear = Keys.LaneClear
		else
			VayneMenu.keysetting.SACLaneClear = false
		end
		if LastHitOrbText == "Reborn" then
			VayneMenu.keysetting.SACLastHit = Keys.LastHit
		else
			VayneMenu.keysetting.SACLastHit = false
		end
	end
end

function _HijackPrintChat()
	_G.CustomPrintChat = _G.PrintChat
	_G.PrintChat =
	function(Arg1)
		if not string.find(Arg1, "Selector") then
			CustomPrintChat(Arg1)
		end
	end
end

function _LoadMenu()
	VayneMenu = scriptConfig("[SV] ShadowVayne", "SV_MAIN")
	SOWMenu = scriptConfig("[SV] SimpleOrbWalker Settings", "SV_SOW")
	VayneMenu:addSubMenu("[Condemn]: AntiGapCloser Settings", "anticapcloser")
	VayneMenu:addSubMenu("[Condemn]: AutoStunn Settings", "autostunn")
	VayneMenu:addSubMenu("[Condemn]: AutoStunn Targets", "targets")
	VayneMenu:addSubMenu("[Condemn]: Interrupt Settings", "interrupt")
	VayneMenu:addSubMenu("[Tumble]: Settings", "tumble")
	VayneMenu:addSubMenu("[Misc]: Key Settings", "keysetting")
	VayneMenu:addSubMenu("[Misc]: TS Settings", "tssetting")
	VayneMenu:addSubMenu("[Misc]: AutoLevelSpells Settings", "autolevel")
	VayneMenu:addSubMenu("[Misc]: VIP Settings", "vip")
	VayneMenu:addSubMenu("[Misc]: PermaShow Settings", "permashowsettings")
	VayneMenu:addSubMenu("[Misc]: AutoUpdate Settings", "autoup")
	VayneMenu:addSubMenu("[Misc]: Draw Settings", "draw")
	VayneMenu:addSubMenu("[Misc]: WallTumble Settings", "walltumble")
	VayneMenu:addSubMenu("[BotRK]: Settings", "botrksettings")
	VayneMenu:addSubMenu("[Bilgewater]: Settings", "bilgesettings")
	VayneMenu:addSubMenu("[QSS]: Settings", "qqs")
	VayneMenu:addSubMenu("[Debug]: Settings", "debug")
	VayneMenu.qqs:addParam("nil","QSS/Cleanse is not Supported yet", SCRIPT_PARAM_INFO, "")

	VayneMenu.keysetting:addParam("nil","Basic Key Settings", SCRIPT_PARAM_INFO, "")
	VayneMenu.keysetting:addParam("basiccondemn","Condemn on next BasicAttack:", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte( "E" ))
	VayneMenu.keysetting:addParam("threshlantern","Grab the Thresh lantern: ", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "T" ))
	VayneMenu.keysetting.basiccondemn = false
	VayneMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")
	VayneMenu.keysetting:addParam("nil","General Key Settings", SCRIPT_PARAM_INFO, "")
	VayneMenu.keysetting:addParam("togglemode","ToggleMode:", SCRIPT_PARAM_ONOFF, false)
	VayneMenu.keysetting:addParam("autocarry","Auto Carry Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "V" ))
	VayneMenu.keysetting:addParam("mixedmode","Mixed Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "C" ))
	VayneMenu.keysetting:addParam("laneclear","Lane Clear Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "M" ))
	VayneMenu.keysetting:addParam("lasthit","Last Hit Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "N" ))
	VayneMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")

	if SOWLoaded then VayneMenu.keysetting:addParam("nil","SimpleOrbWalker found", SCRIPT_PARAM_INFO, "") end
	if SACLoaded then VayneMenu.keysetting:addParam("nil","Sida's Auto Carry: Reborn found", SCRIPT_PARAM_INFO, "") end
	if REVLoaded then VayneMenu.keysetting:addParam("nil","Sida's Auto Carry: Revamped found", SCRIPT_PARAM_INFO, "") end
	if MMALoaded then VayneMenu.keysetting:addParam("nil","Marksmen Mighty Assistant found", SCRIPT_PARAM_INFO, "") end
	VayneMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")
	VayneMenu.keysetting:addParam("nil","Choose...", SCRIPT_PARAM_INFO, "")
	if SOWLoaded then
		if MMALoaded then
			if SACLoaded then
				OrbWalkerTable = { "SOW", "MMA", "Reborn"}
				StartParam = 17
			elseif REVLoaded then
				OrbWalkerTable = { "SOW", "MMA", "Revamped"}
				StartParam = 17
			else
				OrbWalkerTable = { "SOW", "MMA"}
				StartParam = 16
			end
		else
			if SACLoaded then
				OrbWalkerTable = { "SOW", "Reborn"}
				StartParam = 16
			elseif REVLoaded then
				OrbWalkerTable = { "SOW", "Revamped"}
				StartParam = 16
			else
				OrbWalkerTable = { "SOW"}
				StartParam = 15
			end
		end
	end


	VayneMenu.keysetting:addParam("AutoCarryOrb", "Orbwalker in AutoCarry: ", SCRIPT_PARAM_LIST, 1, OrbWalkerTable)
	VayneMenu.keysetting:addParam("MixedModeOrb", "Orbwalker in MixedMode: ", SCRIPT_PARAM_LIST, 1, OrbWalkerTable)
	VayneMenu.keysetting:addParam("LaneClearOrb", "Orbwalker in LaneClear: ", SCRIPT_PARAM_LIST, 1, OrbWalkerTable)
	VayneMenu.keysetting:addParam("LastHitOrb", "Orbwalker in LastHit: ", SCRIPT_PARAM_LIST, 1, OrbWalkerTable)
	if SAC_V84 and SACLoaded then
	VayneMenu.keysetting:addParam("SACAutoCarry","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	VayneMenu.keysetting:addParam("SACMixedMode","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	VayneMenu.keysetting:addParam("SACLaneClear","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	VayneMenu.keysetting:addParam("SACLastHit","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	Keys:RegisterMenuKey(VayneMenu.keysetting, "SACAutoCarry", AutoCarry.MODE_AUTOCARRY)
	Keys:RegisterMenuKey(VayneMenu.keysetting, "SACMixedMode", AutoCarry.MODE_MIXEDMODE)
	Keys:RegisterMenuKey(VayneMenu.keysetting, "SACLaneClear", AutoCarry.MODE_LANECLEAR)
	Keys:RegisterMenuKey(VayneMenu.keysetting, "SACLastHit", AutoCarry.MODE_LASTHIT)
	end

	VayneMenu.tssetting:addParam("UsedTS", "Choose your TargetSelector (need Reload!):", SCRIPT_PARAM_LIST, 1, {"Simple Target Selector", "VIP Target Selector"})
	if VIP_USER and VayneMenu.tssetting.UsedTS == 2 then UserVIPSelector = true end
	for i, enemy in ipairs(GetEnemyHeroes()) do
--~ 	Gapcloser Menu Targeted Skills
		if isAGapcloserUnitTarget[enemy.charName] then
			VayneMenu.anticapcloser:addSubMenu((enemy.charName).." "..(isAGapcloserUnitTarget[enemy.charName].spellKey), (enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey))
			VayneMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam("sep", "Interrupt "..(enemy.charName).." "..(isAGapcloserUnitTarget[enemy.charName].spellKey)..":", SCRIPT_PARAM_INFO, "")
			VayneMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
			VayneMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, true)
			VayneMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, false)
			VayneMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, false)
			VayneMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, false)
		end

--~ 	Gapcloser Menu NoTargeted Skills
		for _, TableInfo in pairs(isAGapcloserUnitNoTarget) do
			if TableInfo.champ == enemy.charName then
				VayneMenu.anticapcloser:addSubMenu((enemy.charName).." "..(TableInfo.spellKey), (enemy.charName)..(TableInfo.spellKey))
				VayneMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam("sep", "Interrupt "..(enemy.charName).." "..(TableInfo.spellKey)..":", SCRIPT_PARAM_INFO, "")
				VayneMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
				VayneMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, true)
				VayneMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, false)
				VayneMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, false)
				VayneMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, false)
			end
		end

--~ 	Autostunn Target Menu
		VayneMenu.targets:addSubMenu(enemy.charName, enemy.charName)
		VayneMenu.targets[enemy.charName]:addParam("sep", "Stunn "..(enemy.charName), SCRIPT_PARAM_INFO, "")
		VayneMenu.targets[enemy.charName]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.targets[enemy.charName]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.targets[enemy.charName]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.targets[enemy.charName]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.targets[enemy.charName]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, false)

--~ 	Interrupt Champs Menu
		for _, TableInfo in pairs(isAChampToInterrupt) do
			if TableInfo.champ == enemy.charName then
				VayneMenu.interrupt:addSubMenu((enemy.charName).." "..(TableInfo.spellKey), (enemy.charName)..(TableInfo.spellKey))
				VayneMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam("sep", "Interrupt "..(enemy.charName).." "..(TableInfo.spellKey), SCRIPT_PARAM_INFO, "")
				VayneMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
				VayneMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, true)
				VayneMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, true)
				VayneMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, true)
				VayneMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, true)
			end
		end
	end

--~ 	AutoStunn Settings Menu
		VayneMenu.autostunn:addParam("pushDistance", "Push Distance", SCRIPT_PARAM_SLICE, 390, 0, 450, 0)
--~ 		VayneMenu.autostunn:addParam("accuracy", "Accuracy", SCRIPT_PARAM_SLICE, 5, 1, 10, 0)
		VayneMenu.autostunn:addParam("towerstunn", "Stunn if Enemy lands unter a Tower", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.autostunn:addParam("trinket", "Use Auto-Trinket Bush", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.autostunn:addParam("target", "Stunn only Current Target", SCRIPT_PARAM_ONOFF, true)

--~ 	Gapcloser Overwrite Menu
		VayneMenu.anticapcloser:addParam("fap", "", SCRIPT_PARAM_INFO, "","" )
		VayneMenu.anticapcloser:addParam("fap", "Gapcloser Overwrite:", SCRIPT_PARAM_INFO, "","" )
		VayneMenu.anticapcloser:addParam("OverwriteAutoCarry", "Enable All Gapcloser in AutoCarry", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.anticapcloser:addParam("OverwriteMixedMode", "Enable All Gapcloser in Mixedmode", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.anticapcloser:addParam("OverwriteLaneClear", "Enable All Gapcloser in LaneClear", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.anticapcloser:addParam("OverwriteLastHit", "Enable All Gapcloser in LastHit", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.anticapcloser:addParam("OverwriteAlways", "Enalbe All Gapcloser always", SCRIPT_PARAM_ONOFF, false)

--~ 	Draw Menu
		VayneMenu.draw:addParam("DrawERange", "Draw E Range", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.draw:addParam("DrawAARange", "Draw Basicattack Range", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.draw:addParam("DrawNeededAutohits", "Draw Needed Autohits", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.draw:addParam("DrawEColor", "E Range Color", SCRIPT_PARAM_LIST, 1, { "Riot standard", "Green", "Blue", "Red", "Purple" })
		VayneMenu.draw:addParam("DrawAAColor", "Basicattack Range Color", SCRIPT_PARAM_LIST, 1, { "Riot standard", "Green", "Blue", "Red", "Purple" })

--~ 	Autolevel Menu
		VayneMenu.autolevel:addParam("UseAutoLevelfirst", "Use AutoLevelSpells Level 1-3", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.autolevel:addParam("UseAutoLevelrest", "Use AutoLevelSpells Level 4-18", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.autolevel:addParam("first3level", "Level 1-3:", SCRIPT_PARAM_LIST, 1, { "Q-W-E", "Q-E-W", "W-Q-E", "W-E-Q", "E-Q-W", "E-W-Q" })
		VayneMenu.autolevel:addParam("restlevel", "Level 4-18:", SCRIPT_PARAM_LIST, 1, { "Q-W-E", "Q-E-W", "W-Q-E", "W-E-Q", "E-Q-W", "E-W-Q" })
		VayneMenu.autolevel:addParam("fap", "", SCRIPT_PARAM_INFO, "","" )
		VayneMenu.autolevel:addParam("fap", "You can Click on the \"Q-W-E\"", SCRIPT_PARAM_INFO, "","" )
		VayneMenu.autolevel:addParam("fap", "to change the Autospellorder", SCRIPT_PARAM_INFO, "","" )

--~ 	Vip Menu
		VayneMenu.vip:addParam("EPackets", "Use Packets for E Cast (VIP Only)", SCRIPT_PARAM_ONOFF, true)
--~ 		VayneMenu.vip:addParam("vpred", "Use VPrediction (VIP Only)", SCRIPT_PARAM_ONOFF, true)
--~ 		VayneMenu.vip:addParam("selector", "Use Selector (VIP Only)", SCRIPT_PARAM_ONOFF, true)

--~ 	PermaShow Menu
		VayneMenu.permashowsettings:addParam("epermashow", "PermaShow \"E on Next BasicAttack\"", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.permashowsettings:addParam("carrypermashow", "PermaShow: AutoCarry", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.permashowsettings:addParam("mixedpermashow", "PermaShow: Mixed Mode", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.permashowsettings:addParam("laneclearpermashow", "PermaShow: Laneclear", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.permashowsettings:addParam("lasthitpermashow", "PermaShow: Last hit", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.keysetting:permaShow("basiccondemn")

--~ 	AutoUpdate
		VayneMenu.autoup:addParam("autoupcheck", "AutoUpdate", SCRIPT_PARAM_ONOFF, true)
--~ 		VayneMenu.autoup:addParam("autoupdown", "Download Available Updates", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.autoup:addParam("fap", "", SCRIPT_PARAM_INFO, "","" )
		VayneMenu.autoup:addParam("fap", "Set this to off", SCRIPT_PARAM_INFO, "","" )
		VayneMenu.autoup:addParam("fap", "for not download Updates automaticly", SCRIPT_PARAM_INFO, "","" )

--~ 	BotRK Settings Menu
		VayneMenu.botrksettings:addParam("botrkautocarry", "Use BotRK in AutoCarry", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.botrksettings:addParam("botrkmixedmode", "Use BotRK in MixedMode", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.botrksettings:addParam("botrklaneclear", "Use BotRK in LaneClear", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.botrksettings:addParam("botrklasthit", "Use BotRK in LastHit", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.botrksettings:addParam("botrkalways", "Use BotRK always", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.botrksettings:addParam("botrkmaxheal", "Max Own Health Percent", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
		VayneMenu.botrksettings:addParam("botrkminheal", "Min Enemy Health Percent", SCRIPT_PARAM_SLICE, 20, 1, 100, 0)

--~ 	BilgeWater Settings Menu
		VayneMenu.bilgesettings:addParam("bilgeautocarry", "Use BilgeWater in AutoCarry", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.bilgesettings:addParam("bilgemixedmode", "Use BilgeWater in MixedMode", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.bilgesettings:addParam("bilgelaneclear", "Use BilgeWater in LaneClear", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.bilgesettings:addParam("bilgelasthit", "Use BilgeWater in LastHit", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.bilgesettings:addParam("bilgealways", "Use BilgeWater always", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.bilgesettings:addParam("bilgemaxheal", "Max Own Health Percent", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
		VayneMenu.bilgesettings:addParam("bilgeminheal", "Min Enemy Health Percent", SCRIPT_PARAM_SLICE, 20, 1, 100, 0)

--~ 	Tumble Settings Menu
		VayneMenu.tumble:addParam("Qautocarry", "Use Tumble in AutoCarry", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.tumble:addParam("Qmixedmode", "Use Tumble in MixedMode", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.tumble:addParam("Qlaneclear", "Use Tumble in LaneClear", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.tumble:addParam("Qlasthit", "Use Tumble in LastHit", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.tumble:addParam("Qalways", "Use Tumble always", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.tumble:addParam("fap", "", SCRIPT_PARAM_INFO, "","" )
		VayneMenu.tumble:addParam("QManaAutoCarry", "Min Mana to use Q in AutoCarry", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
		VayneMenu.tumble:addParam("QManaMixedMode", "Min Mana to use Q in MixedMode", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		VayneMenu.tumble:addParam("QManaLaneClear", "Min Mana to use Q in LaneClear", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		VayneMenu.tumble:addParam("QManaLastHit", "Min Mana to use Q in LastHit", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

--~ 	Debug Settings Menu
		VayneMenu.debug:addParam("stunndebug", "Debug AutoStunn", SCRIPT_PARAM_ONOFF, false)

--~ 	Walltumble Settings Menu
		VayneMenu.walltumble:addParam("spot1", "Draw & Use Spot 1 (Drake-Spot)", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.walltumble:addParam("spot2", "Draw & Use Spot 2 (Min-Spot)", SCRIPT_PARAM_ONOFF, true)

	STS = SimpleTS(STS_LESS_CAST_PHYSICAL)
	SOWi = SOW(VP, STS)
	SOWi:LoadToMenu(SOWMenu)
	SOWi:RegisterBeforeAttackCallback(_PreAttack)
	SOWi:RegisterAfterAttackCallback(_AfterAttack)
	if UserVIPSelector then
		Selector.Instance()
	else
		TSSMenu = scriptConfig("[SV] SimpleTargetSelector Settings", "SV_TSS")
		STS:AddToMenu(TSSMenu)
	end
		_PrintScriptMsg("Version ".._GetLocalVersion("SHADOWVAYNE").." loaded")
end

function _PreAttack()
	IsAttacking = true
end

function _AfterAttack()
	IsAttacking = false
end

function _CheckUpdate_ShadowVayne()
	--~ Get Local Version
	if LocalVersion_ShadowVayne == nil then
		LocalVersionFile = io.open(SCRIPT_PATH..(GetCurrentEnv().FILE_NAME), "r")
		LocalVersion_ShadowVayne = string.sub(LocalVersionFile:read("*a"), 51, 54)
		LocalVersionFile:close()
	end

	if SV_AutoUpdate then
		--~ Get Server Version
		if ServerVersion_ShadowVayne == nil then
			if not Downloading and not Downloaded_ShadowVayne then
				SHADOWVAYNE_SCRIPT_URL = "http://raw.github.com/Superx321/BoL/master/ShadowVayne.lua?rand="..tostring(math.random(1,10000))
				SHADOWVAYNE_PATH = LIB_PATH.."/ShadowVayne.Version"
				DownloadFile(SHADOWVAYNE_SCRIPT_URL, SHADOWVAYNE_PATH, function ()
					Downloading = false
						end)
				Downloading = true
				Downloaded_ShadowVayne = true
			end
			if FileExist(LIB_PATH.."/ShadowVayne.Version") and not Downloading then
				ServerVersionFile = io.open((LIB_PATH.."/ShadowVayne.Version"), "r")
				ServerVersion_ShadowVayne = string.sub(ServerVersionFile:read("*a"), 51, 54)
				ServerVersionFile:close()
			end
		end


		--~ Check for Updates
		if ServerVersion_ShadowVayne ~= nil and LocalVersion_ShadowVayne ~= nil then
			if ServerVersion_ShadowVayne > LocalVersion_ShadowVayne then
				_PrintScriptMsg("New Version ("..ServerVersion_ShadowVayne..") available, downloading...")
				infile = io.open(LIB_PATH.."/ShadowVayne.Version", "r")
				instr = infile:read("*a")
				infile:close()

				outfile = io.open(SCRIPT_PATH..(GetCurrentEnv().FILE_NAME), "w")
				outfile:write(instr)
				outfile:close()
				_PrintScriptMsg("Updated to Version "..(ServerVersion_ShadowVayne)..". Please reload with F9")
				UpdateDone_ShadowVayne = true
			else
				_PrintScriptMsg("No Updates available. Loaded Version "..LocalVersion_ShadowVayne)
				UpdateDone_ShadowVayne = true
			end
		end
	else
		_PrintScriptMsg("AutoUpdate is off. Loaded Version "..LocalVersion_ShadowVayne)
		UpdateDone_ShadowVayne = true
	end
end

function StringDecrypt(data)
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

function _UseBotRK()
	local BladeSlot = GetInventorySlotItem(3153)
	if LastAttackedEnemy ~= nil and GetDistance(LastAttackedEnemy) < 450 and not LastAttackedEnemy.dead and LastAttackedEnemy.visible and BladeSlot ~= nil and myHero:CanUseSpell(BladeSlot) == 0 then
		if (VayneMenu.botrksettings.botrkautocarry and ShadowVayneAutoCarry) or
		 (VayneMenu.botrksettings.botrkmixedmode and ShadowVayneMixedMode) or
		 (VayneMenu.botrksettings.botrklaneclear and ShadowVayneLaneClear) or
		 (VayneMenu.botrksettings.botrklasthit and ShadowVayneLastHit) or
		 (VayneMenu.botrksettings.botrkalways) then
			if (math.floor(myHero.health / myHero.maxHealth * 100)) <= VayneMenu.botrksettings.botrkmaxheal then
				if (math.floor(LastAttackedEnemy.health / LastAttackedEnemy.maxHealth * 100)) >= VayneMenu.botrksettings.botrkminheal then
					CastSpell(BladeSlot, LastAttackedEnemy)
				end
			end
		end
	end
end

function _UseBilgeWater()
	local BilgeSlot = GetInventorySlotItem(3144)
	if LastAttackedEnemy ~= nil and GetDistance(LastAttackedEnemy) < 500 and not LastAttackedEnemy.dead and LastAttackedEnemy.visible and BilgeSlot ~= nil and myHero:CanUseSpell(BilgeSlot) == 0 then
		if (VayneMenu.bilgesettings.bilgeautocarry and ShadowVayneAutoCarry) or
		 (VayneMenu.bilgesettings.bilgemixedmode and ShadowVayneMixedMode) or
		 (VayneMenu.bilgesettings.bilgelaneclear and ShadowVayneLaneClear) or
		 (VayneMenu.bilgesettings.bilgelasthit and ShadowVayneLastHit) or
		 (VayneMenu.bilgesettings.bilgealways) then
			if (math.floor(myHero.health / myHero.maxHealth * 100)) <= VayneMenu.bilgesettings.bilgemaxheal then
				if (math.floor(LastAttackedEnemy.health / LastAttackedEnemy.maxHealth * 100)) >= VayneMenu.bilgesettings.bilgeminheal then
					CastSpell(BilgeSlot, LastAttackedEnemy)
				end
			end
		end
	end
end

function _ClickThreshLantern()
	if VIP_USER and VayneMenu.keysetting.threshlantern and LanternObj then
		LanternPacket = CLoLPacket(0x39)
		LanternPacket:EncodeF(myHero.networkID)
		LanternPacket:EncodeF(LanternObj.networkID)
		LanternPacket.dwArg1 = 1
		LanternPacket.dwArg2 = 0
		SendPacket(LanternPacket)
	end
end

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

function _DownloadLib(FilePath, LibName, VersionString, VersionLine)
	if FileExist(SCRIPT_PATH.."Common/"..LibName..".lua") then NeedDownLoad = false else NeedDownLoad = true end

	if FileExist(SCRIPT_PATH.."Common/"..LibName..".lua") and VersionString ~= nil then
		LibFile = io.open(SCRIPT_PATH.."/Common/"..LibName..".lua", "r")
		if VersionLine ~= nil and VersionLine > 1 then
			for i = 1, VersionLine-1 do DummyLine = LibFile:read() end
		end
		FirstLine = LibFile:read()
		LibFile:close()
		if FirstLine ~= VersionString then NeedDownLoad = true else NeedDownLoad = false end
	end

	if not DownloadStarted and NeedDownLoad == true then
		DownloadStarted = true
		_PrintScriptMsg("Downloading Library ("..LibName.."), please wait until its finished")
		DownloadFile(FilePath.."?rand="..tostring(math.random(1,10000)), SCRIPT_PATH.."Common/"..LibName..".lua",  function() DownloadStarted, HadToDownload = false, true end)
	end

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
        ['LeeSin']	    = {true, spell = "blindmonkqtwo",		spellKey = "Q"}
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
		["slashCast"]				= {true, champ = "Tryndamere", 	range = 650,  	projSpeed = 1450, spellKey = "E"}
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
        "Rumble", "Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "MasterYi", "Velkoz",
    },
    Support = {
        "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Sona", "Soraka", "Thresh", "Zilean", "Braum",
    },

    Tank = {
        "Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Shen", "Singed", "Skarner", "Volibear",
        "Warwick", "Yorick", "Zac", "Nunu", "Taric", "Alistar",
    },

    AD_Carry = {
        "Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "KogMaw", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
        "Talon", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Zed", "Jinx" , "Lucian",

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