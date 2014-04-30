--[[

	Shadow Vayne Script by Superx321
	Version: 2.40

	Functions:
	- AntiCapCloser with Settings
	- AutoStunn with Settings
	- Autotrinket on Stunn
	- Draw E Range
	- Interrupt Enemyspells
	- Auto-E on Next Basicattack


	Thx to Jus and Hellsing for helping
	Thx to Manciuszz for his Vayne Script
	Thx to Klokje for his interrupt Script

	Changelog:
	v1.0:	-Release
	v1.1:	-Changed Maokai Capcloser Q -> W
			-Changed Jayce Capcloser W -> Q
	v1.2:	-Added VPrediction for VIP
	v1.3:	-Fixed Bugsplat on AutoE Basicattack (hopefully)
	v1.4:	-Found the Bugsplat, Fixed
	v1.5:	-Autoupdate Added
	v1.6:	-Fixxed the field nil Error on line 298
	v1.7:	-Fixxed Autoupdate
	v1.8:	-Fixxed GetWebResult
	v1.9:	-Added AutoLevelSpell
	v2.0:	-Fixed Error on Line 298 (for the 3rd time)
			-Changed the AutoUpdater, so u can name the Script whatever u want
			-Fixed that it wont AutoE NonTarget Gapcloser (such as Shyvana R)
			-Fixed that it wont AutoE LeeSin Second Q
			-Fixed Gragas E
			-Added Misc Settings Menu
			-Added Using VPred to Misc Menu (VIP Only)
			-Added Using Packets to Misc Menu (VIP Only)
			-Added Kill-E with 3rd Ring
	v2.1:	-Fixed AutoUpdate
	v2.11:	-It will only E Champs now
	v2.12:	-Fixed Autotrinked (Typo)
	v2.13:	-Changed some Typo's
	v2.20:	-Changed Stunn-Code from OnTick -> Own Func, for later AddCallBack
			-Changed Stunnratio and VP, should now stunn better
			-Changed Search-For-Wall logic, should now take less fps
			-Fixed Autotrinked complete
			-Deactivated "Use E for 3rd Ring Proc Kill", since its Random E sometimes (will Reactivate in next updates)
			-Added Misc -> Debug, if u get Random E's, activate it to see why my Script used Condemn
	v2.21:	-Added Debug for NonTargetGapCloser
	v2.22:	-Fixed a Bug in the AutoUpdate
	v2.23:	-Finally Fixed the "field nil" Error
			-Added SAC Interaction, if SAC is loaded, it will automatic use the Keysettings from there
	v2.24:	-Change some things in the Autoupdater
	v2.25:	-More Changes on Autoupdater
	v2.40:	-Fixxed some Stunn-issues
			-Added Revamped Support
]]

if myHero.charName ~= "Vayne" then return end
spellExpired = true
local informationTable = {}
local AAInfoTable = {}
local LastHittedTargetNetworkID, LastHittedTargetStacks, LastHittedTargetTick = nil, nil, 0
local VP = nil
local CastedLastE = 0
local TickCountScriptStart, OnLoadDone, Beta = GetTickCount(), nil, false

function GetUpdate()
	if not AlreadyChecked then
		if not OnLoadDone then
			if Beta then SCRIPT_NAME = "ShadowVayneBeta" else SCRIPT_NAME = "ShadowVayne" end
				OwnScriptFile = io.open(SCRIPT_PATH..(GetCurrentEnv().FILE_NAME), "r")
				LocalVersion = string.sub(OwnScriptFile:read("*a"), 51, 54)
				FileClose = OwnScriptFile:close()
			print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">Loaded Version "..(LocalVersion).."</font>")
			OnLoadDone = true
			SHADOWVAYNE_SCRIPT_URL = "http://raw.github.com/Superx321/BoL/master/"..SCRIPT_NAME..".lua?rand="..tostring(math.random(1,100000))
			SHADOWVAYNE_PATH = SCRIPT_PATH..(GetCurrentEnv().FILE_NAME)
			ServerVersion = string.sub(GetWebResult("raw.github.com", "/Superx321/BoL/master/"..SCRIPT_NAME..".lua?rand="..tostring(math.random(1,100000))), 51, 54)
		end
		if GetTickCount() > (TickCountScriptStart + 3000) then
			if tonumber(LocalVersion) < tonumber(ServerVersion) then
				print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">New Version ("..(ServerVersion)..") available, downloading...</font>")
				DownloadFile(SHADOWVAYNE_SCRIPT_URL, SHADOWVAYNE_PATH, function () print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">Updated to Version "..(ServerVersion)..". Please reload with F9</font>") end)
			else
				print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">No Updates available</font>")
			end
			AlreadyChecked = true
		end
	end
end


if VIP_USER then
	require "VPrediction"
end

local isAGapcloserUnitTarget = {
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

local isAGapcloserUnitNoTarget = {
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


local isAChampToInterrupt = {
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

local AutoLevelSpellTable = {
                ["SpellOrder"]	= {"QWE", "QEW", "WQE", "WEQ", "EQW", "EWQ"},
                ["QWE"]	= {1,2,3,1,1,4,1,2,1,2,4,2,2,3,3,4,3,3},
                ["QEW"]	= {1,3,2,1,1,4,1,3,1,3,4,3,3,2,2,4,2,2},
                ["WQE"]	= {2,1,3,2,2,4,2,1,2,1,4,1,1,3,3,4,3,3},
                ["WEQ"]	= {2,3,1,2,2,4,2,3,2,3,4,3,3,1,1,4,1,1},
                ["EQW"]	= {3,1,2,3,3,4,3,1,3,1,4,1,1,2,2,4,2,2},
                ["EWQ"]	= {3,2,1,3,3,4,3,2,3,2,4,2,2,1,1,4,1,1}
	}

local VayneDamage = {
				["0"] = {BaseDMG = 00, MaxHPDmg = 0},
				["1"] = {BaseDMG = 20, MaxHPDmg = 4},
				["2"] = {BaseDMG = 30, MaxHPDmg = 5},
				["3"] = {BaseDMG = 40, MaxHPDmg = 6},
				["4"] = {BaseDMG = 50, MaxHPDmg = 7},
				["5"] = {BaseDMG = 60, MaxHPDmg = 8},
				["Q"] = {30, 35, 40, 45, 50}
	}

function OnLoad()
	VayneMenu = scriptConfig("Shadow Vayne", "ShadowVayne")
	VayneMenu:addSubMenu("Key Settings", "keysetting")
	if AutoCarry == nil then Skills, Keys, Items, Data, Jungle, Helper, MyHero, Minions, Crosshair, Orbwalker = AutoCarry.Helper:GetClasses() end
	if Keys == nil then
		VayneMenu.keysetting:addParam("autocarry","Auto Carry Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "V" ))
		VayneMenu.keysetting:addParam("mixedmode","Mixed Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "C" ))
		VayneMenu.keysetting:addParam("laneclear","Lane Clear Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "M" ))
		VayneMenu.keysetting:addParam("lasthit","Last Hit Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "N" ))
	end
	VayneMenu.keysetting:addParam("basiccondemn","Condemn on next BasicAttack:", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte( "E" ))
	VayneMenu.keysetting.basiccondemn = false
	VayneMenu.keysetting:permaShow("basiccondemn")

	if Keys ~= nil then
		VayneMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")
		VayneMenu.keysetting:addParam("nil","Sida's AutoCarry found", SCRIPT_PARAM_INFO, "")
		VayneMenu.keysetting:addParam("nil","It will use the Keysettings from there", SCRIPT_PARAM_INFO, "")
		Skills, Keys, Items, Data, Jungle, Helper, MyHero, Minions, Crosshair, Orbwalker = AutoCarry.Helper:GetClasses()
	end


	VayneMenu:addSubMenu("AntiGapCloser Settings", "anticapcloser")
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if isAGapcloserUnitTarget[enemy.charName] then
			VayneMenu.anticapcloser:addSubMenu((enemy.charName).." "..(isAGapcloserUnitTarget[enemy.charName].spellKey), (enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey))
			VayneMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam("sep", "Interrupt "..(enemy.charName).." "..(isAGapcloserUnitTarget[enemy.charName].spellKey)..":", SCRIPT_PARAM_INFO, "")
			VayneMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
			VayneMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, true)
			VayneMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, false)
			VayneMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, false)
			VayneMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, false)
		end

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
	end
	VayneMenu:addSubMenu("AutoStunn Settings", "autostunn")
	VayneMenu.autostunn:addParam("pushDistance", "Push Distance", SCRIPT_PARAM_SLICE, 390, 0, 450, 0)
	VayneMenu.autostunn:addParam("accuracy", "Accuracy", SCRIPT_PARAM_SLICE, 5, 1, 10, 0)
	VayneMenu.autostunn:addParam("towerstunn", "Stunn if Enemy lands unter a Tower", SCRIPT_PARAM_ONOFF, false)
	VayneMenu.autostunn:addParam("trinket", "Use Auto-Trinket Bush", SCRIPT_PARAM_ONOFF, true)
	VayneMenu:addSubMenu("AutoStunn Targets", "targets")
		for i, enemy in ipairs(GetEnemyHeroes()) do
			VayneMenu.targets:addSubMenu(enemy.charName, enemy.charName)
			VayneMenu.targets[enemy.charName]:addParam("sep", "Stunn "..(enemy.charName), SCRIPT_PARAM_INFO, "")
			VayneMenu.targets[enemy.charName]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
			VayneMenu.targets[enemy.charName]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, false)
			VayneMenu.targets[enemy.charName]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, false)
			VayneMenu.targets[enemy.charName]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, false)
			VayneMenu.targets[enemy.charName]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, false)
		end
	VayneMenu:addSubMenu("Interrupt Settings", "interrupt")
		for i, enemy in ipairs(GetEnemyHeroes()) do
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
	VayneMenu:addSubMenu("Draw Settings", "draw")
	VayneMenu.draw:addParam("DrawERange", "Draw E Range", SCRIPT_PARAM_ONOFF, false)
	VayneMenu.draw:addParam("DrawEColor", "E Range Color", SCRIPT_PARAM_LIST, 1, { "Riot standard", "Green", "Blue", "Red", "Purple" })

	VayneMenu:addSubMenu("AutoLevelSpells Settings", "autolevel")
	VayneMenu.autolevel:addParam("UseAutoLevelfirst", "Use AutoLevelSpells Level 1-3", SCRIPT_PARAM_ONOFF, false)
	VayneMenu.autolevel:addParam("UseAutoLevelrest", "Use AutoLevelSpells Level 4-18", SCRIPT_PARAM_ONOFF, false)
	VayneMenu.autolevel:addParam("first3level", "Level 1-3:", SCRIPT_PARAM_LIST, 1, { "Q-W-E", "Q-E-W", "W-Q-E", "W-E-Q", "E-Q-W", "E-W-Q" })
	VayneMenu.autolevel:addParam("restlevel", "Level 4-18:", SCRIPT_PARAM_LIST, 1, { "Q-W-E", "Q-E-W", "W-Q-E", "W-E-Q", "E-Q-W", "E-W-Q" })

		VayneMenu:addSubMenu("Misc Settings", "misc")
	if VIP_USER then
		VayneMenu.misc:addParam("EPackets", "Use Packets for E Cast", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.misc:addParam("vpred", "Use VPrediction", SCRIPT_PARAM_ONOFF, true)
	end
--~ 		VayneMenu.misc:addParam("KS3rdW", "Use E for 3rd Ring Proc Kill", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.misc:addParam("debug", "Debug Print", SCRIPT_PARAM_ONOFF, false)

	if VIP_USER then
		VP = VPrediction()
	end
local AutoLevelSpells = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
autoLevelSetFunction(AutoLevelSpell)
autoLevelSetSequence(AutoLevelSpells)

end

function CheckEnemyStunnAble()
--~ print(math.ceil((VayneMenu.autostunn.pushDistance/VayneMenu.autostunn.accuracy)))
	if not myHero.dead and myHero:CanUseSpell(_E) == READY and CastedLastE < GetTickCount() then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if 	(VayneMenu.targets[enemy.charName][(enemy.charName).."AutoCarry"] and ShadowVayneAutoCarry) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."MixedMode"] and ShadowVayneMixedMode) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."LaneClear"] and ShadowVayneLaneClear) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."LastHit"] and ShadowVayneLastHit) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."Always"])	then
				if GetDistance(enemy) <= 715 and not enemy.dead and enemy.visible then
					if VIP_USER and VayneMenu.misc.vpred then local CastPosition,  HitChance, enemy = VP:GetLineCastPosition(enemy, 0.26, 0, (GetDistance(enemy)+VayneMenu.autostunn.pushDistance), VP:GetProjectileSpeed(myHero), myHero, false) end
--~ 								if VIP_USER then local CastPosition,  HitChance,  enemy = VP:GetLineCastPosition(enemy, 0.5, 65, 650, 1200, myHero, false) end
--~ 					print(enemy.charName)

					for i = 1, VayneMenu.autostunn.accuracy  do
						local CheckWallPos = enemy + (Vector(enemy) - myHero):normalized()*math.ceil((VayneMenu.autostunn.pushDistance/VayneMenu.autostunn.accuracy)*i)
						if not BushFound and IsWallOfGrass(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) then
							BushFound = true
							BushPos = CheckWallPos
						end
						if IsWall(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) then
							if UnderTurret(ChecksWallPos, true) then
									if VayneMenu.autostunn.towerstunn then
										CastESpell(enemy, "AutoStunn Undertower ("..(enemy.charName)..")")
										if BushFound and VayneMenu.autostunn.trinket then DelayAction(function() CastSpell(ITEM_7, BushPos.x, BushPos.z) end, 0.25)	else BushFound = false end
										break
									end
							else
								CastESpell(enemy, "AutoStunn Not Undertower ("..(enemy.charName)..")")
								if BushFound and VayneMenu.autostunn.trinket then DelayAction(function() CastSpell(ITEM_7, BushPos.x, BushPos.z) end, 0.25)	else BushFound = false end
								break
							end
						end
					end
				end
			end
		end
	end
end

function GetRunningModes()
	if Keys ~= nil then
		ShadowVayneAutoCarry = Keys.AutoCarry
		ShadowVayneMixedMode = Keys.MixedMode
		ShadowVayneLaneClear = Keys.LastHit
		ShadowVayneLastHit = Keys.LaneClear
	else
		ShadowVayneAutoCarry = VayneMenu.keysetting.autocarry
		ShadowVayneMixedMode = VayneMenu.keysetting.mixedmode
		ShadowVayneLaneClear = VayneMenu.keysetting.laneclear
		ShadowVayneLastHit = VayneMenu.keysetting.lasthit
	end
end



function OnTick()
--~ print(ShadowVayneAutoCarry)
GetRunningModes()
CheckEnemyStunnAble()
GetUpdate()
--~ PrintFloatText(myHero, 10, "1234")
--~ print(Crosshair.Attack_Crosshair)

	if not myHero.dead and myHero:CanUseSpell(_E) == READY then
		if spellExpired == false and (GetTickCount() - informationTable.spellCastedTick) <= (informationTable.spellRange/informationTable.spellSpeed)*1000 then
			local spellDirection     = (informationTable.spellEndPos - informationTable.spellStartPos):normalized()
			local spellStartPosition = informationTable.spellStartPos + spellDirection
			local spellEndPosition   = informationTable.spellStartPos + spellDirection * informationTable.spellRange
			local heroPosition = Point(myHero.x, myHero.z)
			local SkillShot = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))
			if heroPosition:distance(SkillShot) <= 250 then
				if VayneMenu.misc.EPackets then CastESpell(informationTable.spellSource, "Gapcloser NonTargeted ("..(informationTable.spellName)..")") end
			end
		else
			spellExpired = true
			informationTable = {}
		end
	end

--~ 	if (LastHittedTargetTick + 3000) < GetTickCount() and LastHittedTargetStacks ~= 0 then
--~ 		LastHittedTargetStacks = 0
--~ 		LastHittedTargetNetworkID = nil
--~ 	end
end

function OnDraw()
--~ vPos = GetUnitHPBarPos(myHero)

--~   DrawText("Log Enabled",16,vPos.x,vPos.y,0xFF80FF00)
  if VayneMenu.draw.DrawERange then
		if VayneMenu.draw.DrawEColor == 1 then
			DrawCircle(myHero.x, myHero.y, myHero.z, 715, 0x80FFFF)
		elseif VayneMenu.draw.DrawEColor == 2 then
			DrawCircle(myHero.x, myHero.y, myHero.z, 715, 0x0080FF)
		elseif VayneMenu.draw.DrawEColor == 3 then
			DrawCircle(myHero.x, myHero.y, myHero.z, 715, 0x5555FF)
		elseif VayneMenu.draw.DrawEColor == 4 then
			DrawCircle(myHero.x, myHero.y, myHero.z, 715, 0xFF2D2D)
		elseif VayneMenu.draw.DrawEColor == 5 then
			DrawCircle(myHero.x, myHero.y, myHero.z, 715, 0x8B42B3)
		end
	end
end

function OnProcessSpell(unit, spell)
	if not myHero.dead then
		if isAGapcloserUnitTarget[unit.charName] and spell.name == isAGapcloserUnitTarget[unit.charName].spell and unit.team ~= myHero.team then
			if spell.target ~= nil and spell.target.hash == myHero.hash then
				if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / AutoCarry Mode") end
				if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Lasthit Mode") end
				if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Mixed Mode") end
				if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Laneclear Mode") end
				if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."Always"] then CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Always") end
			end
		end

		if isAChampToInterrupt[spell.name] and unit.charName == isAChampToInterrupt[spell.name].champ and GetDistance(unit) <= 715 and unit.team ~= myHero.team then
			if VayneMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then CastESpell(unit, "Interrupt ("..(spell.name)..") / AutoCarry Mode") end
			if VayneMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then CastESpell(unit, "Interrupt ("..(spell.name)..") / Lasthit Mode") end
			if VayneMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then CastESpell(unit, "Interrupt ("..(spell.name)..") / Mixed Mode") end
			if VayneMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then CastESpell(unit, "Interrupt ("..(spell.name)..") / Laneclear Mode") end
			if VayneMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."Always"] then CastESpell(unit, "Interrupt ("..(spell.name)..") / Always") end
		end

		if unit.hash == myHero.hash and spell.name:find("Attack") and VayneMenu.keysetting.basiccondemn and spell.target.type == myHero.type then
			CastESpell(spell.target, "E After Autohit ("..(spell.target.charName)..")", (spell.windUpTime - GetLatency() / 2000))
			VayneMenu.keysetting.basiccondemn = false
		end

		if unit.isMe and spell.name:find("CondemnMissile") then
				CastedLastE = GetTickCount() + 500
		end

--~ 		if unit.hash == myHero.hash and spell.name:find("Attack") then
--~ 			if spell.name:find("Tumble") then TumbleDMG = (myHero.totalDamage)/(100/(VayneDamage["Q"][myHero:GetSpellData(_Q).level])) else TumbleDMG = 0 end
--~ 			AAInfoTable = {
--~ 				spellCastedTick = GetTickCount(),
--~ 				spellTarget = spell.target,
--~ 				spellTumbleDMG = TumbleDMG,
--~ 				spellwindUpTime = spell.windUpTime
--~ 			}
--~ 		end
--~ print(spell.name)
		if unit.charName ~= nil and isAGapcloserUnitNoTarget[spell.name] and unit.charName == isAGapcloserUnitNoTarget[spell.name].champ and GetDistance(unit) <= 2000 and spellExpired == true and (spell.target == nil or spell.target.isMe) and unit.team ~= myHero.team then
			if VayneMenu.misc.debug then
				if spell.target == nil then SpellTargetName = "nil" else SpellTargetName = spell.target.charName end
				print(" ")
				print("<font color=\"#662f8d\"><b>Debug is on. Please Screen this and send it in the Thread</b></font>")
				print("<font color=\"#6648da\"><b>SpellName:</b></font> <font color=\"#FF48da\">"..(spell.name).." </font>   <font color=\"#6648da\"><b>SpellTarget: </b></font><font color=\"#FF48da\">"..(SpellTargetName).."</font>")
				print("<font color=\"#6648da\"><b>Distance:</b></font> <font color=\"#FF48da\">"..(math.round(GetDistance(unit))).." </font>   <font color=\"#6648da\"><b>SpellExpired: </b></font><font color=\"#FF48da\">"..tostring(spellExpired).."</font>")
				print("<font color=\"#6648da\"><b>UnitName:</b></font> <font color=\"#FF48da\">"..(unit.charName).." </font>   <font color=\"#6648da\"><b>IsGapCloser: </b></font><font color=\"#FF48da\">"..tostring((isAGapcloserUnitNoTarget[spell.name][1])).."</font>")
				print("<font color=\"#6648da\"><b>GapCloserName:</b></font> <font color=\"#FF48da\">"..(isAGapcloserUnitNoTarget[spell.name].champ).." </font>   <font color=\"#6648da\"><b>GapCloseKey: </b></font><font color=\"#FF48da\">"..(isAGapcloserUnitNoTarget[spell.name].spellKey).."</font>")
				print("<font color=\"#6648da\"><b>VanyeMenu #1:</b></font> <font color=\"#FF48da\">"..((unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)).."</font>")
				print(" ")
			end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."AutoCarry"] then
				if ShadowVayneAutoCarry then
					spellExpired = false
				end
			end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then spellExpired = false end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then spellExpired = false end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then spellExpired = false end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then spellExpired = false end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."Always"] then spellExpired = false end
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

--~ function OnCreateObj(obj)
--~ 	if obj.name == "vayne_basicAttack_mis.troy" or obj.name == "vayne_critAttack_mis.troy" then
--~ 		if  AAInfoTable.spellTarget.type == myHero.type then
--~ 			if ((GetTickCount())- AAInfoTable.spellCastedTick) < 200 then
--~ 				if LastHittedTargetNetworkID == AAInfoTable.spellTarget.networkID then
--~ 					LastHittedTargetStacks = LastHittedTargetStacks + 1
--~ 					if LastHittedTargetStacks == 4 then
--~ 						LastHittedTargetStacks = 1
--~ 					end
--~ 					if LastHittedTargetStacks == 2 and (VayneMenu.misc.KS3rdW) and myHero:CanUseSpell(_E) == READY then
--~ 						TargetTrueDmg = math.floor((((AAInfoTable.spellTarget.maxHealth)/100)*(VayneDamage[tostring(myHero:GetSpellData(_W).level)].MaxHPDmg))+(VayneDamage[tostring(myHero:GetSpellData(_W).level)].BaseDMG))
--~ 						DMGThisAA = myHero:CalcDamage(AAInfoTable.spellTarget,myHero.totalDamage+AAInfoTable.spellTumbleDMG)
--~ 						SpellTarget = AAInfoTable.spellTarget
--~ 						if (TargetTrueDmg+DMGThisAA) > AAInfoTable.spellTarget.health+50 then
--~ 							CastESpell(_E, SpellTarget, AAInfoTable.spellwindUpTime - GetLatency() / 2000)
--~ 							if VIP_USER and VayneMenu.misc.EPackets then
--~ 								DelayAction(function() Packet('S_CAST', { spellId = _E, targetNetworkId = SpellTarget.networkID }):send() end, AAInfoTable.spellwindUpTime - GetLatency() / 2000)
--~ 							else
--~ 								CastESpell(_E, SpellTarget, AAInfoTable.spellwindUpTime - GetLatency() / 2000)
--~ 								DelayAction(function() CastESpell(_E, SpellTarget) end, AAInfoTable.spellwindUpTime - GetLatency() / 2000)
--~ 							end
--~ 						end
--~ 					end
--~ 				else
--~ 					LastHittedTargetNetworkID = AAInfoTable.spellTarget.networkID
--~ 					LastHittedTargetStacks = 1
--~ 				end
--~ 			end
--~ 		end
--~ 	end
--~ end

function CastESpell(Target, Reason, Delay)
	if VIP_USER and VayneMenu.misc.EPackets then
		DelayAction(function() Packet('S_CAST', { spellId = _E, targetNetworkId = Target.networkID }):send(true) end, Delay)
	else
		DelayAction(function() CastSpell(_E, Target) end, Delay)
	end

	if VayneMenu.misc.debug then
		print("Casting E Spell")
		print("Target: "..(Target.charName))
		print("Reason: "..(Reason))
	end
end

--~ function OnDeleteObj(obj)
--~ 	if obj.name == "vayne_basicAttack_mis.troy" or obj.name == "vayne_critAttack_mis.troy" then
--~ 		LastHittedTargetTick = GetTickCount()
--~ 	end
--~ end

function AutoLevelSpell()
	if VayneMenu.autolevel.UseAutoLevelfirst and myHero.level < 4 then
		return AutoLevelSpellTable[AutoLevelSpellTable["SpellOrder"][VayneMenu.autolevel.first3level]][myHero.level]
	end

	if VayneMenu.autolevel.UseAutoLevelrest and myHero.level > 3 then
		return AutoLevelSpellTable[AutoLevelSpellTable["SpellOrder"][VayneMenu.autolevel.restlevel]][myHero.level]
	end
end