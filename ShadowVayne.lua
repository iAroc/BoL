--[[

	Shadow Vayne Script by Superx321
	Version: 3.17

	For Functions & Changelog, check the Thread on the BoL Forums:
	http://botoflegends.com/forum/topic/18939-shadow-vayne-the-mighty-hunter/
	]]

if myHero.charName ~= "Vayne" then return end

------------------------
------ AutoUpdate ------
------------------------
 function _AutoUpdate()
	if not GetLibsStarted then
		SVVersion =  tonumber(_GetLocalVersion("ShadowVayne"))

		SVUpdateMenu = scriptConfig("[ShadowVayne] UpdateSettings", "SV_UPDATE")
		SVMainMenu = scriptConfig("[ShadowVayne] MainScript", "SV_MAIN")
		SVSOWMenu = scriptConfig("[ShadowVayne] SimpleOrbWalker Settings", "SV_SOW")
		SVTSMenu = scriptConfig("[ShadowVayne] TargetSelector Settings", "SV_TS")

		SVUpdateMenu:addParam("UseAutoCheck","Check for Updates", SCRIPT_PARAM_ONOFF, true)
		SVUpdateMenu:addParam("UseAutoLoad","Automatic Download Updates", SCRIPT_PARAM_ONOFF, true)

		SVUpdateMenu:addParam("version","ShadowVayne Version:", SCRIPT_PARAM_INFO, "v"..SVVersion)

		_AutoUpdates = {
			{["Name"] = "VPrediction", 		["Version"] = "/Hellsing/BoL/master/version/VPrediction.version", 		["Script"] = "/Hellsing/BoL/master/common/VPrediction.lua"},
			{["Name"] = "SOW", 				["Version"] = "/Hellsing/BoL/master/version/SOW.version", 				["Script"] = "/Hellsing/BoL/master/common/SOW.lua"},
			{["Name"] = "CustomPermaShow", 	["Version"] = "/Superx321/BoL/master/common/CustomPermaShow.Version", 	["Script"] = "/Superx321/BoL/master/common/CustomPermaShow.lua"},
			{["Name"] = "SourceLib", 		["Version"] = "/TheRealSource/public/master/common/SourceLib.version", 	["Script"] = "/TheRealSource/public/master/common/SourceLib.lua"},
			{["Name"] = "Selector", 		["Version"] = "/pqmailer/BoL_Scripts/master/Paid/Selector.revision", 	["Script"] = "/pqmailer/BoL_Scripts/master/Paid/Selector.lua"},
			{["Name"] = "ShadowVayne", 		["Version"] = "/Superx321/BoL/master/ShadowVayne.Version", 				["Script"] = "/Superx321/BoL/master/ShadowVayne.lua"},
		}
		GetLibsStarted = true
		socket = require("socket")
		LibsDone = 0
		SocketsClosed = 0
		GotVersions = 0
		clientversion = {}
		clientscript = {}

		for i=1,#_AutoUpdates do
		clientversion[i] = socket.connect("reddi-ts.de", 80)
		clientversion[i]:send("GET /BoL/Scripts.php?path=".._AutoUpdates[i]["Version"].."&rand="..tonumber(math.random(10000)).." HTTP/1.0\r\n\r\n")
		end

		for i=1,#_AutoUpdates do
		clientscript[i] = socket.connect("reddi-ts.de", 80)
		clientscript[i]:send("GET /BoL/Scripts.php?path=".._AutoUpdates[i]["Script"].."&rand="..tonumber(math.random(10000)).." HTTP/1.0\r\n\r\n")
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
			if tonumber(_GetLocalVersion(_AutoUpdates[i]["Name"])) == nil then
				LocalVersion = 0
			else
				LocalVersion = tonumber(_GetLocalVersion(_AutoUpdates[i]["Name"]))
			end
			if tonumber(_AutoUpdates[i]["ServerVersion"]) > LocalVersion then
				_AutoUpdates[i]["OldVersion"] = LocalVersion
				if _AutoUpdates[i]["Name"] == "ShadowVayne" then
					if SVUpdateMenu.UseAutoCheck then
						if SVUpdateMenu.UseAutoLoad then
							LibNameFile = io.open(SCRIPT_PATH.. GetCurrentEnv().FILE_NAME, "w+")
							LibNameString = _AutoUpdates[i]["ScriptRaw"]
							LibNameFindCache = string.find(LibNameString, "text/html")
							LibNameStringSub = string.sub(LibNameString, LibNameFindCache+13)
							LibNameFile:write(LibNameStringSub)
							LibNameFile:close()
							_PrintUpdateMsg("Updated Version ".._AutoUpdates[i]["OldVersion"].." => "..tonumber(_AutoUpdates[i]["ServerVersion"]).."", _AutoUpdates[i]["Name"])
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
		AutoUpdateDone = true
	else
		_AutoUpdate()
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
		if tonumber(FileVersion) == nil then FileVersion = 0 end
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

------------------------
------ MainScript ------
------------------------
function _PrintScriptMsg(Msg)
	PrintChat("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">"..Msg.."</font>")
end

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

function _CheckOrbWalkers()
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
		SACLoaded = true
	end

	if _G.MMA_Loaded then
		MMALoaded = true
	end

	if _G.SOWLoaded then
		SOWLoaded = true
	end
end

function _LoadSOWSTS()
	VP = VPrediction(true)
	STS = SimpleTS(STS_LESS_CAST_PHYSICAL)
	SOWi = SOW(VP, STS)
	SOWi:LoadToMenu(SVSOWMenu)
	STS:AddToMenu(SVTSMenu)
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

	if SOWLoaded then SVMainMenu.keysetting:addParam("nil","SOW found", SCRIPT_PARAM_INFO, "") end
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

--~ SAC R84 FIX
		SVMainMenu.keysetting:addParam("SACAutoCarry","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.keysetting:addParam("SACMixedMode","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.keysetting:addParam("SACLaneClear","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.keysetting:addParam("SACLastHit","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	if SACLoaded then
		Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACAutoCarry", AutoCarry.MODE_AUTOCARRY)
		Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACMixedMode", AutoCarry.MODE_MIXEDMODE)
		Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACLaneClear", AutoCarry.MODE_LANECLEAR)
		Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACLastHit", AutoCarry.MODE_LASTHIT)
	end

	if SVMainMenu.keysetting._param[StartParam+0].listTable[SVMainMenu.keysetting.AutoCarryOrb] == nil then SVMainMenu.keysetting.AutoCarryOrb = 1 end
	if SVMainMenu.keysetting._param[StartParam+1].listTable[SVMainMenu.keysetting.MixedModeOrb] == nil then SVMainMenu.keysetting.MixedModeOrb = 1 end
	if SVMainMenu.keysetting._param[StartParam+2].listTable[SVMainMenu.keysetting.LaneClearOrb] == nil then SVMainMenu.keysetting.LaneClearOrb = 1 end
	if SVMainMenu.keysetting._param[StartParam+3].listTable[SVMainMenu.keysetting.LastHitOrb] == nil then SVMainMenu.keysetting.LastHitOrb = 1 end

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
                ["InfiniteDuress"]				= {true, champ = "Warwick",		spellKey = "R"},
                ["LucianR"]						= {true, champ = "Lucian",		spellKey = "R"}

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

function _GetRunningModes()
	--~ Get the Keysettings from SVMainMenu
	ShadowVayneAutoCarry = SVMainMenu.keysetting.autocarry
	ShadowVayneMixedMode = SVMainMenu.keysetting.mixedmode
	ShadowVayneLaneClear = SVMainMenu.keysetting.laneclear
	ShadowVayneLastHit = SVMainMenu.keysetting.lasthit

	--~ Recall-Check when ToggleMode is on
	if (Recalling or RecallCast) and SVMainMenu.keysetting.togglemode then
		ShadowVayneAutoCarry = false
		ShadowVayneMixedMode = false
		ShadowVayneLaneClear = false
		ShadowVayneLastHit = false
	end

	--~ Reset All Modes
	if SACLoaded then Keys.AutoCarry,Keys.MixedMode,Keys.LaneClear,Keys.LastHit = false,false,false,false end
	if RevampedLoaded then REVMenu.AutoCarry,REVMenu.MixedMode,REVMenu.LaneClear,REVMenu.LastHit = false,false,false,false end
	if SOWLoaded then SVSOWMenu.Mode0,SVSOWMenu.Mode1,SVSOWMenu.Mode2,SVSOWMenu.Mode3 = false,false,false,false end
	if MMALoaded then _G.MMA_Orbwalker,_G.MMA_HybridMode,_G.MMA_LaneClear,_G.MMA_LastHit = false,false,false,false end

	--~ Get The Selected Orbwalker
	AutoCarryOrbText = SVMainMenu.keysetting._param[StartParam].listTable[SVMainMenu.keysetting.AutoCarryOrb]
	MixedModeOrbText = SVMainMenu.keysetting._param[StartParam+1].listTable[SVMainMenu.keysetting.MixedModeOrb]
	LaneClearOrbText = SVMainMenu.keysetting._param[StartParam+2].listTable[SVMainMenu.keysetting.LaneClearOrb]
	LastHitOrbText = SVMainMenu.keysetting._param[StartParam+3].listTable[SVMainMenu.keysetting.LastHitOrb]

	--~ Activate MMA
	if AutoCarryOrbText == "MMA" then _G.MMA_Orbwalker = ShadowVayneAutoCarry end
	if MixedModeOrbText == "MMA" then _G.MMA_HybridMode = ShadowVayneMixedMode end
	if LaneClearOrbText == "MMA" then _G.MMA_LaneClear = ShadowVayneLaneClear end
	if LastHitOrbText == "MMA" then _G.MMA_LastHit = ShadowVayneLastHit end

	--~ Activate SAC:Reborn
	if AutoCarryOrbText == "Reborn" then Keys.AutoCarry = ShadowVayneAutoCarry end
	if MixedModeOrbText == "Reborn" then Keys.MixedMode = ShadowVayneMixedMode end
	if LaneClearOrbText == "Reborn" then Keys.LaneClear = ShadowVayneLaneClear end
	if LastHitOrbText == "Reborn" then Keys.LastHit = ShadowVayneLastHit end

	--~ Activate SAC:Reborn R84 FIX
	if AutoCarryOrbText == "Reborn" then SVMainMenu.keysetting.SACAutoCarry = ShadowVayneAutoCarry end
	if MixedModeOrbText == "Reborn" then SVMainMenu.keysetting.SACMixedMode = ShadowVayneMixedMode end
	if LaneClearOrbText == "Reborn" then SVMainMenu.keysetting.SACLaneClear = ShadowVayneLaneClear end
	if LastHitOrbText == "Reborn" then SVMainMenu.keysetting.SACLastHit = ShadowVayneLastHit end

	--~ Activate SAC:Revamped
	if AutoCarryOrbText == "Revamped" then REVMenu.AutoCarry = ShadowVayneAutoCarry end
	if MixedModeOrbText == "Revamped" then REVMenu.MixedMode = ShadowVayneMixedMode end
	if LaneClearOrbText == "Revamped" then REVMenu.LaneClear = ShadowVayneLaneClear end
	if LastHitOrbText == "Revamped" then REVMenu.LastHit = ShadowVayneLastHit end

	--~ Activate SOW
	if AutoCarryOrbText == "SOW" then SVSOWMenu.Mode0 = ShadowVayneAutoCarry end
	if MixedModeOrbText == "SOW" then SVSOWMenu.Mode1 = ShadowVayneMixedMode end
	if LaneClearOrbText == "SOW" then SVSOWMenu.Mode2 = ShadowVayneLaneClear end
	if LastHitOrbText == "SOW" then SVSOWMenu.Mode3 = ShadowVayneLastHit end
end

function _AutoLevelSpell()
	if GetGame().map.index ~= 4 and myHero.level < 4 then
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

function _UsePermaShows()
	CustomPermaShow("AutoCarry (Using "..AutoCarryOrbText..")", SVMainMenu.keysetting.autocarry, SVMainMenu.permashowsettings.carrypermashow, nil, 1426521024, nil, 1)
	CustomPermaShow("MixedMode (Using "..MixedModeOrbText..")", SVMainMenu.keysetting.mixedmode, SVMainMenu.permashowsettings.mixedpermashow, nil, 1426521024, nil, 2)
	CustomPermaShow("LaneClear (Using "..LaneClearOrbText..")", SVMainMenu.keysetting.laneclear, SVMainMenu.permashowsettings.laneclearpermashow, nil, 1426521024, nil, 3)
	CustomPermaShow("LastHit (Using "..LastHitOrbText..")", SVMainMenu.keysetting.lasthit, SVMainMenu.permashowsettings.lasthitpermashow, nil, 1426521024, nil, 4)
	CustomPermaShow("Auto-E after next BasicAttack", SVMainMenu.keysetting.basiccondemn, SVMainMenu.permashowsettings.epermashow, nil, 1426521024, nil,  5)
end

function _GetSTSTarget()
	STSTarget = STS:GetTarget(myHero.range)
end

function _UseBotRK()
	local BladeSlot = GetInventorySlotItem(3153)
	if STSTarget ~= nil and GetDistance(STSTarget) < 450 and not STSTarget.dead and STSTarget.visible and BladeSlot ~= nil and myHero:CanUseSpell(BladeSlot) == 0 then
		if (SVMainMenu.botrksettings.botrkautocarry and ShadowVayneAutoCarry) or
		 (SVMainMenu.botrksettings.botrkmixedmode and ShadowVayneMixedMode) or
		 (SVMainMenu.botrksettings.botrklaneclear and ShadowVayneLaneClear) or
		 (SVMainMenu.botrksettings.botrklasthit and ShadowVayneLastHit) or
		 (SVMainMenu.botrksettings.botrkalways) then
			if (math.floor(myHero.health / myHero.maxHealth * 100)) <= SVMainMenu.botrksettings.botrkmaxheal then
				if (math.floor(STSTarget.health / STSTarget.maxHealth * 100)) >= SVMainMenu.botrksettings.botrkminheal then
					CastSpell(BladeSlot, STSTarget)
				end
			end
		end
	end
end

function _UseBilgeWater()
	local BilgeSlot = GetInventorySlotItem(3144)
	if STSTarget ~= nil and GetDistance(STSTarget) < 500 and not STSTarget.dead and STSTarget.visible and BilgeSlot ~= nil and myHero:CanUseSpell(BilgeSlot) == 0 then
		if (SVMainMenu.bilgesettings.bilgeautocarry and ShadowVayneAutoCarry) or
		 (SVMainMenu.bilgesettings.bilgemixedmode and ShadowVayneMixedMode) or
		 (SVMainMenu.bilgesettings.bilgelaneclear and ShadowVayneLaneClear) or
		 (SVMainMenu.bilgesettings.bilgelasthit and ShadowVayneLastHit) or
		 (SVMainMenu.bilgesettings.bilgealways) then
			if (math.floor(myHero.health / myHero.maxHealth * 100)) <= SVMainMenu.bilgesettings.bilgemaxheal then
				if (math.floor(STSTarget.health / STSTarget.maxHealth * 100)) >= SVMainMenu.bilgesettings.bilgeminheal then
					CastSpell(BilgeSlot, STSTarget)
				end
			end
		end
	end
end

function _NonTargetGapCloserAfterCast()
	if spellExpired == false and (GetTickCount() - informationTable.spellCastedTick) <= (informationTable.spellRange/informationTable.spellSpeed)*1000 then
		local spellDirection     = (informationTable.spellEndPos - informationTable.spellStartPos):normalized()
		local spellStartPosition = informationTable.spellStartPos + spellDirection
		local spellEndPosition   = informationTable.spellStartPos + spellDirection * informationTable.spellRange
		local heroPosition = Point(myHero.x, myHero.z)
		local SkillShot = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))
		if heroPosition:distance(SkillShot) <= 300 then
			CastSpell(_E, informationTable.spellSource)
		end
	else
		spellExpired = true
		informationTable = {}
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

function _CheckRengarExist()
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if enemy.charName == "Rengar" then
			RengarHero = enemy
		end
	end
end

function _CheckRengarGapcloser()
	if ShootRengar and not RengarHero.dead and RengarHero.health > 0 and GetDistanceSqr(RengarHero) < 1000*1000 then
		CastSpell(_E, RengarHero)
	else
		ShootRengar = false
	end
end

function _UseTumble()
	if IsAttacking then return end
	if myHero.dead then return end
	if myHero:CanUseSpell(_Q) ~= READY then return end
	if ShootRengar then return end
	if not LastAttackedEnemy then return end
	if LastAttackedEnemy.dead then return end
	if LastAttackedEnemy.health < 1 then return end
	if ShadowVayneAutoCarry and STSTarget then
		TumbleTarget = STSTarget
	else
		TumbleTarget = LastAttackedEnemy
	end

	if  (SVMainMenu.tumble.Qautocarry and ShadowVayneAutoCarry and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaAutoCarry)) or
		(SVMainMenu.tumble.Qmixedmode and ShadowVayneMixedMode and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaMixedMode)) or
		(SVMainMenu.tumble.Qlaneclear and ShadowVayneLaneClear and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaLaneClear)) or
		(SVMainMenu.tumble.Qlasthit and  ShadowVayneLastHit and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaLastHit)) or
		(SVMainMenu.tumble.Qalways) then
		local AfterTumblePos = myHero + (Vector(mousePos) - myHero):normalized() * 300
		if GetDistance(AfterTumblePos, TumbleTarget) < 600 then
			if NextAA > GetTickCount() then
				CastSpell(_Q, mousePos.x, mousePos.z)
			end
		end
	end
end

function OnProcessSpell(unit, spell)
	if not ScriptLoaded then return end
	if myHero.dead then return end
	if unit.team ~= myHero.team then
		-- AntiGapCloser Targeted Spells
		if isAGapcloserUnitTarget[unit.charName] and spell.name == isAGapcloserUnitTarget[unit.charName].spell then
			if spell.target ~= nil and spell.target.hash == myHero.hash then
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then CastSpell(_E, unit) end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then CastSpell(_E, unit) end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then CastSpell(_E, unit) end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then CastSpell(_E, unit) end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."Always"] then CastSpell(_E, unit) end
				if SVMainMenu.autostunn.OverwriteAutoCarry and ShadowVayneAutoCarry then  CastSpell(_E, unit) end
				if SVMainMenu.autostunn.OverwriteMixedMode and ShadowVayneMixedMode then  CastSpell(_E, unit) end
				if SVMainMenu.autostunn.OverwriteLaneClear and ShadowVayneLaneClear then  CastSpell(_E, unit) end
				if SVMainMenu.autostunn.OverwriteLastHit and ShadowVayneLastHit then  CastSpell(_E, unit) end
				if SVMainMenu.autostunn.Overwritealways then  CastSpell(_E, unit) end
			end
		end

		-- AntiGapCloser Interrupt Spells
		if isAChampToInterrupt[spell.name] and unit.charName == isAChampToInterrupt[spell.name].champ and GetDistanceSqr(unit) <= 715*715 then
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then CastSpell(_E, unit) end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then CastSpell(_E, unit) end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then CastSpell(_E, unit) end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then CastSpell(_E, unit) end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."Always"] then CastSpell(_E, unit) end
		end

		if isAGapcloserUnitNoTarget[spell.name] and GetDistanceSqr(unit) <= 2000*2000 and (spell.target == nil or spell.target.isMe) then
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

	if unit.isMe then
		if spell.name:lower():find("attack") then
			LastAttackedEnemy = spell.target
			TimeToNextAA = math.floor((spell.animationTime - (GetLatency() / 2000))*1000)
			WindUpTime = math.floor((spell.windUpTime - (GetLatency() / 2000))*1000)
			NextAA = GetTickCount() + TimeToNextAA - WindUpTime - WindUpTime
			IsAttacking = true
			DelayAction(function() IsAttacking = false end, spell.windUpTime - (GetLatency() / 2000))
			if SVMainMenu.keysetting.basiccondemn and spell.target.type == myHero.type then
				SVMainMenu.keysetting.basiccondemn = false
				DelayAction(function() CastSpell(_E, LastAttackedEnemy) end, spell.windUpTime - GetLatency() / 2000)
			else
				SVMainMenu.keysetting.basiccondemn = false
			end
		end

		if spell.name == "Recall" then
			RecallCast = true
			DelayAction(function() RecallCast = false end, 0.75)
		end

		if spell.name:find("VayneCondemn") then
			ShootRengar = false
		end
	end
end

function OnCreateObj(Obj)
	if not AutoUpdateDone then return end
	if not ScriptLoaded then return end
	if myHero.dead then  return end

	if Obj.name == "ThreshLantern" then
		LanternObj = Obj
	end

	if RengarHero ~= nil and Obj.name == "Rengar_LeapSound.troy" and GetDistanceSqr(RengarHero) < 1000*1000 then
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

function OnWndMsg(msg, key)
	if not ScriptLoaded then return end

	if not SVMainMenu.keysetting.togglemode then return end

	if key == SVMainMenu.keysetting._param[7].key then -- AutoCarry
		  SVMainMenu.keysetting.mixedmode,SVMainMenu.keysetting.laneclear,SVMainMenu.keysetting.lasthit = false,false,false
	end

	if key == SVMainMenu.keysetting._param[8].key then -- MixedMode
		  SVMainMenu.keysetting.autocarry,SVMainMenu.keysetting.laneclear,SVMainMenu.keysetting.lasthit = false,false,false
	end

	if key == SVMainMenu.keysetting._param[9].key then -- LaneClear
		  SVMainMenu.keysetting.autocarry,SVMainMenu.keysetting.mixedmode,SVMainMenu.keysetting.lasthit = false,false,false
	end

	if key == SVMainMenu.keysetting._param[10].key then -- LastHit
		  SVMainMenu.keysetting.autocarry,SVMainMenu.keysetting.mixedmode,SVMainMenu.keysetting.laneclear = false,false,false
	end
end

function OnDraw()
	if not ScriptLoaded then return end

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

function OnLoad()
	_AutoUpdate()
end

function OnTick()
	if not AutoUpdateDone then return end
	if myHero.dead then return end

	if not ScriptLoaded then
		ScriptLoaded = true
		_RequireWithoutUpdate("VPrediction")
		_RequireWithoutUpdate("SourceLib")
		_RequireWithoutUpdate("SOW")
		_RequireWithoutUpdate("CustomPermaShow")
		if FileExist(LIB_PATH.."Prodiction.lua") then require "Prodiction" end
		if VIP_USER then _RequireWithoutUpdate("Selector") end
		_PrintScriptMsg("Version "..SVVersion.." loaded")
		_CheckOrbWalkers()
		_CheckRengarExist()
		_LoadSOWSTS()
		_LoadTables()
		_LoadMenu()
		autoLevelSetFunction(_AutoLevelSpell)
		autoLevelSetSequence({0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
		_G.HidePermaShow["LaneClear OnHold:"] = true
		_G.HidePermaShow["Orbwalk OnHold:"] = true
		_G.HidePermaShow["LastHit OnHold:"] = true
		_G.HidePermaShow["HybridMode OnHold:"] = true
		_G.HidePermaShow["Condemn on next BasicAttack:"] = true
		_G.HidePermaShow["              Sida's Auto Carry: Reborn"] = true
		_G.HidePermaShow["Auto Carry"] = true
		_G.HidePermaShow["Last Hit"] = true
		_G.HidePermaShow["Mixed Mode"] = true
		_G.HidePermaShow["Lane Clear"] = true
		_G.HidePermaShow["Auto-Condemn"] = true
		_G.HidePermaShow["No mode active"] = true
		_G.HidePermaShow["ShadowVayne found. Set the Keysettings there!"] = true
	else
		_GetRunningModes()
		_UsePermaShows()
		_GetSTSTarget()
		_UseBotRK()
		_UseBilgeWater()
		_SetToggleMode()
		_ClickThreshLantern()
		_WallTumble()
		_UseTumble()

		if myHero:CanUseSpell(_E) == READY then
			_NonTargetGapCloserAfterCast()
			_CheckRengarGapcloser()
			_CheckStunn()
		end
	end
end

---------------------------------
---------- Stunn Logic ----------
---------------------------------
function _CheckStunn()
	if myHero.dead then return end
	if not CastedLastE then CastedLastE = 0 end
	if CastedLastE > GetTickCount() then return end
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if GetDistance(enemy) <= 1000 and not enemy.dead and enemy.visible then
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
						if SVMainMenu.autostunn.target and STSTarget then
							if STSTarget == enemy then
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
					if SVMainMenu.autostunn.target and STSTarget then
						if STSTarget == enemy then
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

function OnSendPacket(p)
	if not VIP_USER then return end
	if not ScriptLoaded then return end
	if myHero.dead then return end

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

------------------------
---- AddParam Hooks ----
------------------------
_G.scriptConfig.CustomaddParam = _G.scriptConfig.addParam
_G.scriptConfig.addParam = function(self, pVar, pText, pType, defaultValue, a, b, c, d)

 -- MMA Hook
if self.name == "MMA2013" and pText:find("OnHold") then	pType = 5 end

-- SAC:Reborn r83 Hook
if self.name:find("sidasacsetup_sidasac") and (pText == "Auto Carry" or pText == "Mixed Mode" or pText == "Lane Clear" or pText == "Last Hit") then
	pVar = "sep"
	pText = "ShadowVayne found. Set the Keysettings there!"
	pType=5
end

-- SAC:Reborn r84 Hook
if self.name:find("sidasacsetup_sidasac") and (pText == "Hotkey") then
	pVar = "sep"
	pText = "ShadowVayne found. Set the Keysettings there!"
	pType=5
end

-- SAC:Reborn VayneMenu Hook
if self.name:find("sidasacvayne") then
	pVar = "sep"
	pType=5
end

-- SOW Hook
if self.name == "SV_SOW" and pVar:find("Mode") then
	pType=5
end

 _G.scriptConfig.CustomaddParam(self, pVar, pText, pType, defaultValue, a, b, c, d)
end

-------------------------
---- DrawParam Hooks ----
-------------------------
_G.scriptConfig.CustomDrawParam = _G.scriptConfig._DrawParam
_G.scriptConfig._DrawParam = function(self, varIndex)
	local HideParam = false
	if self.name == "MMA2013" and (self._param[varIndex].text:find("Spells on") or self._param[varIndex].text:find("Version")) then
	HideParam = true
		if not MMAParams then
			MMAParams = true
			self:addParam("nil","ShadowVayne found. Set the Keysettings there!", SCRIPT_PARAM_INFO, "")
			self:addParam("nil","ShadowVayne found. Set the Keysettings there!", SCRIPT_PARAM_INFO, "")
			self:addParam("nil","ShadowVayne found. Set the Keysettings there!", SCRIPT_PARAM_INFO, "")
			self:addParam("nil","ShadowVayne found. Set the Keysettings there!", SCRIPT_PARAM_INFO, "")
			self:addParam(self._param[varIndex].var, "Use Spells On", SCRIPT_PARAM_LIST,1, {"None","All Units","Heroes Only","Minion Only"})
			self:addParam("mmaVersion","MMA - version:", SCRIPT_PARAM_INFO, "0.1408")
		end
	end

	if self.name:find("sidasacvayne") and not self._param[varIndex].text:find("ShadowVayne") then
		if not SACVayneParam then
			SACVayneParam = true
			self:addParam("nil","ShadowVayne found. Set the Keysettings there!", SCRIPT_PARAM_INFO, "")
		end
		HideParam = true
	end

	if self.name == "SV_MAIN_keysetting" and self._param[varIndex].text:find("Hidden") then
		HideParam = true
	end

	if self.name == "SV_SOW" and (self._param[varIndex].var == "Hotkeys" or self._param[varIndex].var:find("Mode")) then HideParam = true end

	if (self.name == "MMA2013" and self._param[varIndex].text:find("OnHold")) then HideParam = true end
	if not HideParam then
		_G.scriptConfig.CustomDrawParam(self, varIndex)
	end
end

-------------------------
----- SubMenu Hooks -----
-------------------------
_G.scriptConfig.CustomDrawSubInstance = _G.scriptConfig._DrawSubInstance
_G.scriptConfig._DrawSubInstance = function(self, index)
	if not self.name:find("sidasacvayne") then
		_G.scriptConfig.CustomDrawSubInstance(self, index)
	end
end

------------------------
----- Unused Funcs -----
------------------------
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