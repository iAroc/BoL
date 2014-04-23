--[[

	Shadow Vayne Script by Superx321

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
]]

if myHero.charName ~= "Vayne" then return end

spellExpired = false
local informationTable = {}
local VP = nil

local version = 1.9
local AUTOUPDATE = true

local SHADOWVAYNE_SCRIPT_URL = "https://raw.github.com/Superx321/BoL/master/ShadowVayne.lua"
local SHADOWVAYNE_PATH = SCRIPT_PATH.."ShadowVayne.lua"
local NeedReload = false

if AUTOUPDATE then
	math.randomseed(os.time())
	local WebResult = GetWebResult("raw.github.com", "/Superx321/BoL/master/ShadowVayne.lua?rand="..tostring(math.random(1,10000)))
	if WebResult then
		local ServerVersionPos = string.find(WebResult, "local version =")
		local ServerVersion = string.sub(WebResult, ServerVersionPos+16, ServerVersionPos+19)
		local ServerVersionFinal = math.floor(tonumber(ServerVersion)*100)
		local LocalVersionFinal = version*100
		if LocalVersionFinal < ServerVersionFinal then
			print("<font color=\"#6699ff\"><b>ShadowVayne:</b></font> <font color=\"#FFFFFF\">New Version aviable, dont press F9 until its finished</font>")
			DownloadFile(SHADOWVAYNE_SCRIPT_URL, SHADOWVAYNE_PATH, function () print("<font color=\"#6699ff\"><b>ShadowVayne:</b></font> <font color=\"#FFFFFF\">Updated to newest Version. Please reload with F9</font>") end)
			NeedReload = true
		else
			print("<font color=\"#6699ff\"><b>ShadowVayne:</b></font> <font color=\"#FFFFFF\">No Updates aviable. Loaded Version "..version.."</font>")
		end
	end
end

if NeedReload then return end

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
        ['XinZhao']     = {true, spell = "XenZhaoSweep",		spellKey = "E"}
    }

local isAGapcloserUnitNoTarget = {
		["AatroxQ"]					= {true, champ = "Aatrox", 		range = 1000,  	projSpeed = 1200, spellKey = "Q"},
		["GragasBodySlam"]			= {true, champ = "Gragas", 		range = 600,   	projSpeed = 2000, spellKey = "E"},
		["GravesMove"]				= {true, champ = "Graves", 		range = 425,   	projSpeed = 2000, spellKey = "E"},
		["HecarimUlt"]				= {true, champ = "Hecarim", 	range = 1000,   projSpeed = 1200, spellKey = "R"},
		["JarvanIVDragonStrike"]	= {true, champ = "JarvanIV",	range = 770,   	projSpeed = 2000, spellKey = "Q"},
		["JarvanIVCataclysm"]		= {true, champ = "JarvanIV", 	range = 650,   	projSpeed = 2000, spellKey = "R"},
		["KhazixE"]					= {true, champ = "Khazix", 		range = 900,   	projSpeed = 2000, spellKey = "E"},
		["LeblancSlide"]			= {true, champ = "Leblanc", 	range = 600,   	projSpeed = 2000, spellKey = "W"},
		["LeblancSlideM"]			= {true, champ = "Leblanc", 	range = 600,   	projSpeed = 2000, spellKey = "WMimic"},
		["blindmonkqtwo"]			= {true, champ = "LeeSin", 		range = 1300,  	projSpeed = 1800, spellKey = "Q"},
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

function OnLoad()
	VayneMenu = scriptConfig("Shadow Vayne", "ShadowVayne")
	VayneMenu:addSubMenu("Key Settings", "keysetting")
	VayneMenu.keysetting:addParam("autocarry","Auto Carry Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "V" ))
	VayneMenu.keysetting:addParam("mixedmode","Mixed Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "C" ))
	VayneMenu.keysetting:addParam("laneclear","Lane Clear Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "M" ))
	VayneMenu.keysetting:addParam("lasthit","Last Hit Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "N" ))
	VayneMenu.keysetting:addParam("basiccondemn","Condemn on next BasicAttack:", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte( "E" ))
	VayneMenu.keysetting.basiccondemn = false
	VayneMenu.keysetting:permaShow("basiccondemn")

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
			VayneMenu.targets[enemy.charName]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, true)
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

	if VIP_USER then
		VP = VPrediction()
	end
local AutoLevelSpells = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
autoLevelSetFunction(AutoLevelSpell)
autoLevelSetSequence(AutoLevelSpells)
end

function OnTick()
	if not myHero.dead and myHero:CanUseSpell(_E) == READY then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			local PredictPosition = enemy
			if VIP_USER then local CastPosition,  HitChance,  PredictPosition = VP:GetLineCastPosition(enemy, 0.5, 65, 650, 1200, myHero, false) end

			if (VayneMenu.targets[enemy.charName][(enemy.charName).."AutoCarry"] and VayneMenu.keysetting.autocarry) or
			(VayneMenu.targets[enemy.charName][(enemy.charName).."MixedMode"] and VayneMenu.keysetting.mixedmode) or
			(VayneMenu.targets[enemy.charName][(enemy.charName).."LaneClear"] and VayneMenu.keysetting.laneclear) or
			(VayneMenu.targets[enemy.charName][(enemy.charName).."LastHit"] and VayneMenu.keysetting.lasthit) or
			(VayneMenu.targets[enemy.charName][(enemy.charName).."Always"])	then
				if GetDistance(PredictPosition) <= 715 and not enemy.dead and enemy.visible then
					local PushPos = PredictPosition + (Vector(PredictPosition) - myHero):normalized()*VayneMenu.autostunn.pushDistance
					local CheckWallDistance = math.ceil((VayneMenu.autostunn.pushDistance)/VayneMenu.autostunn.accuracy)
					for k=1, VayneMenu.autostunn.accuracy, 1 do
						local ChecksWallPos = PredictPosition + (Vector(PredictPosition) - myHero):normalized()*(CheckWallDistance*k)
						local PosIsWall = IsWall(D3DXVECTOR3(ChecksWallPos.x, ChecksWallPos.y, ChecksWallPos.z))
						if PosIsWall then
							if UnderTurret(ChecksWallPos, true) then
								if VayneMenu.autostunn.towerstunn then
									CastSpell(_E, PredictPosition)
									break
								end
							else
								CastSpell(_E, PredictPosition)
								if VayneMenu.autostunn.trinked then
									for k=1, VayneMenu.autostunn.accuracy, 1 do
										local ChecksWallPos = PredictPosition + (Vector(PredictPosition) - myHero):normalized()*(CheckWallDistance*k)
										local PosIsWallOfGrass = IsWallOfGrass(D3DXVECTOR3(ChecksWallPos.x, ChecksWallPos.y, ChecksWallPos.z))
										if PosIsWallOfGrass then
											CastSpell(ITEM_7, ChecksWallPos)
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
end

function OnDraw()
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
	if isAGapcloserUnitTarget[unit.charName] and spell.name == isAGapcloserUnitTarget[unit.charName].spell then
		if spell.target ~= nil and spell.target.hash == myHero.hash then
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."AutoCarry"] and VayneMenu.keysetting.autocarry then CastSpell(_E, unit) end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LastHit"] and VayneMenu.keysetting.mixedmode then CastSpell(_E, unit) end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."MixedMode"] and VayneMenu.keysetting.laneclear then CastSpell(_E, unit) end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LaneClear"] and VayneMenu.keysetting.lasthit then CastSpell(_E, unit) end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."Always"] then  CastSpell(_E, unit) end
		end
	end

	if isAChampToInterrupt[spell.name] and unit.charName == isAChampToInterrupt[spell.name].champ and GetDistance(unit) <= 715 then
		if VayneMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."AutoCarry"] and VayneMenu.keysetting.autocarry then CastSpell(_E, unit) end
		if VayneMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."LastHit"] and VayneMenu.keysetting.mixedmode then CastSpell(_E, unit) end
		if VayneMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."MixedMode"] and VayneMenu.keysetting.laneclear then CastSpell(_E, unit) end
		if VayneMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."LaneClear"] and VayneMenu.keysetting.lasthit then CastSpell(_E, unit) end
		if VayneMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."Always"] then  CastSpell(_E, unit) end
	end

	if unit.hash == myHero.hash and spell.name:find("Attack") and VayneMenu.keysetting.basiccondemn then
		SpellTarget = spell.target
		DelayAction(function() CastSpell(_E, SpellTarget) end, spell.windUpTime - GetLatency() / 1000)
		VayneMenu.keysetting.basiccondemn = false
	end

	if isAGapcloserUnitNoTarget[spell.name] and unit.charName == isAGapcloserUnitNoTarget[spell.name].champ and GetDistance(unit) <= 2000 then
		if spellExpired ~= nil and VayneMenu.keysetting.autocarry ~= nil and VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."AutoCarry"] ~= nil then
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."AutoCarry"] and VayneMenu.keysetting.autocarry then spellExpired = false end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."LastHit"] and VayneMenu.keysetting.mixedmode then spellExpired = false end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."MixedMode"] and VayneMenu.keysetting.laneclear then spellExpired = false end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."LaneClear"] and VayneMenu.keysetting.lasthit then spellExpired = false end
			if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."Always"] then spellExpired = false end
			informationTable = {
				spellSource = unit,
				spellCastedTick = GetTickCount(),
				spellStartPos = Point(spell.startPos.x, spell.startPos.z),
				spellEndPos = Point(spell.endPos.x, spell.endPos.z),
				spellRange = isAGapcloserUnitNoTarget[spell.name].range,
				spellSpeed = isAGapcloserUnitNoTarget[spell.name].projSpeed,
			}
		end
	end
end

function AutoLevelSpell()
	if VayneMenu.autolevel.UseAutoLevelfirst and myHero.level < 4 then
		return AutoLevelSpellTable[AutoLevelSpellTable["SpellOrder"][VayneMenu.autolevel.first3level]][myHero.level]
	end

	if VayneMenu.autolevel.UseAutoLevelrest and myHero.level > 3 then
		return AutoLevelSpellTable[AutoLevelSpellTable["SpellOrder"][VayneMenu.autolevel.restlevel]][myHero.level]
	end
end