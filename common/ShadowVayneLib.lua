--[[

	Shadow Vayne Script by Superx321

	For Functions & Changelog, check the Thread on the BoL Forums:
	http://botoflegends.com/forum/topic/18939-shadow-vayne-the-mighty-hunter/
	]]

------------------------
------ MainScript ------
------------------------
class "ShadowVayne"
function ShadowVayne:__init()
	self.ShadowTable = {}
	self.ShadowTable.version = 3.32
	self.LastLevelSpell = 0
	self.LastTumble = 0
	self.ForceAA = false
	CondemnLastE = 0
	print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">Version "..self.ShadowTable.version.." loaded</font>")

	self:GetOrbWalkers()
	self:GenerateTables()

	self:LoadMainMenu()
	self:FillMenu_KeySetting()
	self:FillMenu_Autolevel()
	self:FillMenu_GapCloser()
	self:FillMenu_StunTarget()
	self:FillMenu_Interrupt()
	self:FillMenu_StunSettings()
	self:FillMenu_Draw()
	self:FillMenu_PermaShow()
	self:FillMenu_BotRK()
	self:FillMenu_BilgeWater()
	self:FillMenu_Tumble()
	self:FillMenu_WallTumble()

	self:LoadTS()
	self:LoadSOW()
	self:ArrangeEnemies()
	self:LoadRengar()
	self:LoadCustomPermaShow()

	AddTickCallback(function() self:ActivateModes() end)
	AddTickCallback(function() self:AutoLevelSpell() end)
	AddTickCallback(function() self:PermaShows() end)
	AddTickCallback(function() self:BotRK() end)
	AddTickCallback(function() self:BilgeWater() end)
	AddTickCallback(function() self:GapCloserAfterCast() end)
	AddTickCallback(function() self:GapCloserRengar() end)
	AddTickCallback(function() self:SwitchToggleMode() end)
	AddTickCallback(function() self:TreshLantern() end)
	AddTickCallback(function() self:Tumble() end)
	AddTickCallback(function() self:CondemnStun() end)
	AddTickCallback(function() self:WallTumble() end)
	AddTickCallback(function() self:UpdateHeroDirection() end)

	AddCreateObjCallback(function(Obj) self:RengarObject(Obj) end)
	AddCreateObjCallback(function(Obj) self:ThreshObject(Obj) end)

	AddProcessSpellCallback(function(unit, spell) self:ProcessSpell_GapCloser(unit, spell) end)
	AddProcessSpellCallback(function(unit, spell) self:ProcessSpell_Interrupt(unit, spell) end)
	AddProcessSpellCallback(function(unit, spell) self:ProcessSpell_CondemnAfterAA(unit, spell) end)
	AddProcessSpellCallback(function(unit, spell) self:ProcessSpell_Recall(unit, spell) end)
	AddProcessSpellCallback(function(unit, spell) self:ProcessSpell_AllowTumble(unit, spell) end)

	AddDrawCallback(function() self:Draw_WallTumble() end)
	AddDrawCallback(function() self:Draw_CondemnRange() end)
	AddDrawCallback(function() self:Draw_AARange() end)

	AddSendPacketCallback(function(p) self:SendPacket_WallTumble(p) end)

	AddMsgCallback(function(msg,key) self:DoubleModeProtection(msg, key) end)
end

function ShadowVayne:GetOrbWalkers()
	self.ShadowTable.OrbWalkers = {}
	table.insert(self.ShadowTable.OrbWalkers, "SOW")

	if _G.Reborn_Loaded then
		Skills, Keys, Items, Data, Jungle, Helper, MyHero, Minions, Crosshair, Orbwalker = AutoCarry.Helper:GetClasses()
		table.insert(self.ShadowTable.OrbWalkers, "Reborn R84")
	end

	if _G.MMA_Loaded then
		table.insert(self.ShadowTable.OrbWalkers, "MMA")
	end

	if _G.AutoCarry ~= nil and not _G.Reborn_Loaded then
		if _G.AutoCarry.Helper ~= nil then
			Skills, Keys, Items, Data, Jungle, Helper, MyHero, Minions, Crosshair, Orbwalker = AutoCarry.Helper:GetClasses()
			table.insert(self.ShadowTable.OrbWalkers, "Reborn R83")
		else
			if _G.AutoCarry.AutoCarry ~= nil then
				table.insert(self.ShadowTable.OrbWalkers, "Revamped")
			end
		end
	end
end

function ShadowVayne:GenerateTables()
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
                ["QWE"]	= {_Q,_W,_E,_Q,_Q,_R,_Q,_W,_Q,_W,_R,_W,_W,_E,_E,_R,_E,_E},
                ["QEW"]	= {_Q,_E,_W,_Q,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_W,_W,_R,_W,_W},
                ["WQE"]	= {_W,_Q,_E,_W,_W,_R,_W,_Q,_W,_Q,_R,_Q,_Q,_E,_E,_R,_E,_E},
                ["WEQ"]	= {_W,_E,_Q,_W,_W,_R,_W,_E,_W,_E,_R,_E,_E,_Q,_Q,_R,_Q,_Q},
                ["EQW"]	= {_E,_Q,_W,_E,_E,_R,_E,_Q,_E,_Q,_R,_Q,_Q,_W,_W,_R,_W,_W},
                ["EWQ"]	= {_E,_W,_Q,_E,_E,_R,_E,_W,_E,_W,_R,_W,_W,_Q,_Q,_R,_Q,_Q}
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


	heroDirDB = {}
	for i, enemy in ipairs(GetEnemyHeroes()) do
			heroDirDB[enemy.name] = {lastVec = Vector(0,0,0), dir = Vector(0,0,0), lastAngle = 0, index = i}
	end


	TumbleSpots = {
		["VisionPos_1"] = { ["x"] = 11590.95, ["y"] = 52, ["z"] = 4656.26 },
		["VisionPos_2"] = { ["x"] = 6623, ["y"] = 56, ["z"] = 8649 },
		["StandPos_1"] = { ["x"] = 11590.95, ["y"] = 4656.26},
		["StandPos_2"] = { ["x"] = 6623.00, ["y"] = 8649.00 },
		["CastPos_1"] = { ["x"] = 11334.74, ["y"] = 4517.47 },
		["CastPos_2"] = { ["x"] = 6010.5869140625, ["y"] = 8508.8740234375 }
	}


end

function ShadowVayne:LoadMainMenu()
	SVMainMenu = scriptConfig("[ShadowVayne] MainScript", "SV_MAIN")
	SVMainMenu:addSubMenu("[Condemn]: AntiGapCloser Settings", "anticapcloser")
	SVMainMenu:addSubMenu("[Condemn]: AutoStun Settings", "autostunn")
	SVMainMenu:addSubMenu("[Condemn]: AutoStun Targets", "targets")
	SVMainMenu:addSubMenu("[Condemn]: Interrupt Settings", "interrupt")
	SVMainMenu:addSubMenu("[Tumble]: Settings", "tumble")
	SVMainMenu:addSubMenu("[Misc]: Key Settings", "keysetting")
	SVMainMenu:addSubMenu("[Misc]: AutoLevelSpells Settings", "autolevel")
	SVMainMenu:addSubMenu("[Misc]: PermaShow Settings", "permashowsettings")
	SVMainMenu:addSubMenu("[Misc]: Draw Settings", "draw")
	SVMainMenu:addSubMenu("[Misc]: WallTumble Settings", "walltumble")
	SVMainMenu:addSubMenu("[BotRK]: Settings", "botrksettings")
	SVMainMenu:addSubMenu("[Bilgewater]: Settings", "bilgesettings")
end

function ShadowVayne:FillMenu_KeySetting()
	SVMainMenu.keysetting:addParam("nil","Basic Key Settings", SCRIPT_PARAM_INFO, "")
	SVMainMenu.keysetting:addParam("basiccondemn","Condemn on next BasicAttack:", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte( "E" ))
	SVMainMenu.keysetting:addParam("threshlantern","Grab the Thresh lantern: ", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "T" ))
	SVMainMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")
	SVMainMenu.keysetting:addParam("nil","General Key Settings", SCRIPT_PARAM_INFO, "")
	SVMainMenu.keysetting:addParam("togglemode","ToggleMode:", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam("autocarry","Auto Carry Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "V" ))
	SVMainMenu.keysetting:addParam("mixedmode","Mixed Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "C" ))
	SVMainMenu.keysetting:addParam("laneclear","Lane Clear Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "M" ))
	SVMainMenu.keysetting:addParam("lasthit","Last Hit Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "N" ))
	SVMainMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")
	SVMainMenu.keysetting:addParam("AutoCarryOrb", "Orbwalker in AutoCarry: ", SCRIPT_PARAM_LIST, 1, self.ShadowTable.OrbWalkers)
	SVMainMenu.keysetting:addParam("MixedModeOrb", "Orbwalker in MixedMode: ", SCRIPT_PARAM_LIST, 1, self.ShadowTable.OrbWalkers)
	SVMainMenu.keysetting:addParam("LaneClearOrb", "Orbwalker in LaneClear: ", SCRIPT_PARAM_LIST, 1, self.ShadowTable.OrbWalkers)
	SVMainMenu.keysetting:addParam("LastHitOrb", "Orbwalker in LastHit: ", SCRIPT_PARAM_LIST, 1, self.ShadowTable.OrbWalkers)
	--~ SAC R84 FIX
	SVMainMenu.keysetting:addParam("SACAutoCarry","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam("SACMixedMode","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam("SACLaneClear","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam("SACLastHit","Hidden SAC V84 Param", SCRIPT_PARAM_ONOFF, false)
	if _G.Reborn_Loaded then
		Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACAutoCarry", AutoCarry.MODE_AUTOCARRY)
		Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACMixedMode", AutoCarry.MODE_MIXEDMODE)
		Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACLaneClear", AutoCarry.MODE_LANECLEAR)
		Keys:RegisterMenuKey(SVMainMenu.keysetting, "SACLastHit", AutoCarry.MODE_LASTHIT)
	end

	if SVMainMenu.keysetting._param[12].listTable[SVMainMenu.keysetting.AutoCarryOrb] == nil then SVMainMenu.keysetting.AutoCarryOrb = 1 end
	if SVMainMenu.keysetting._param[13].listTable[SVMainMenu.keysetting.MixedModeOrb] == nil then SVMainMenu.keysetting.MixedModeOrb = 1 end
	if SVMainMenu.keysetting._param[14].listTable[SVMainMenu.keysetting.LaneClearOrb] == nil then SVMainMenu.keysetting.LaneClearOrb = 1 end
	if SVMainMenu.keysetting._param[15].listTable[SVMainMenu.keysetting.LastHitOrb] == nil then SVMainMenu.keysetting.LastHitOrb = 1 end
end

function ShadowVayne:FillMenu_GapCloser()
	local FoundAGapCloser = false
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if isAGapcloserUnitTarget[enemy.charName] then
			SVMainMenu.anticapcloser:addSubMenu((enemy.charName).." "..(isAGapcloserUnitTarget[enemy.charName].spellKey), (enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey))
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam("sep", "Interrupt "..(enemy.charName).." "..(isAGapcloserUnitTarget[enemy.charName].spellKey)..":", SCRIPT_PARAM_INFO, "")
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, true)
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, false)
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, false)
			SVMainMenu.anticapcloser[(enemy.charName)..(isAGapcloserUnitTarget[enemy.charName].spellKey)]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, false)
			FoundAGapCloser = true
		end

		for _, TableInfo in pairs(isAGapcloserUnitNoTarget) do
			if TableInfo.champ == enemy.charName then
				SVMainMenu.anticapcloser:addSubMenu((enemy.charName).." "..(TableInfo.spellKey), (enemy.charName)..(TableInfo.spellKey))
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam("sep", "Interrupt "..(enemy.charName).." "..(TableInfo.spellKey)..":", SCRIPT_PARAM_INFO, "")
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, false)
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, false)
				SVMainMenu.anticapcloser[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, false)
				FoundAGapCloser = true
			end
		end
	end

	if not FoundAGapCloser then SVMainMenu.anticapcloser:addParam("nil","No Enemy Gapclosers found", SCRIPT_PARAM_INFO, "") end
end

function ShadowVayne:FillMenu_StunTarget()
	local FoundStunTarget = false
	for i, enemy in ipairs(GetEnemyHeroes()) do
		SVMainMenu.targets:addSubMenu(enemy.charName, enemy.charName)
		SVMainMenu.targets[enemy.charName]:addParam("sep", "Stun "..(enemy.charName), SCRIPT_PARAM_INFO, "")
		SVMainMenu.targets[enemy.charName]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
		SVMainMenu.targets[enemy.charName]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.targets[enemy.charName]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.targets[enemy.charName]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.targets[enemy.charName]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, false)
		FoundStunTarget = true
	end

	if not FoundStunTarget then SVMainMenu.targets:addParam("nil","No Enemies to Stun found", SCRIPT_PARAM_INFO, "") end
end

function ShadowVayne:FillMenu_Interrupt()
	local Foundinterrupt = false
	for i, enemy in ipairs(GetEnemyHeroes()) do
		for _, TableInfo in pairs(isAChampToInterrupt) do
			if TableInfo.champ == enemy.charName then
				SVMainMenu.interrupt:addSubMenu((enemy.charName).." "..(TableInfo.spellKey), (enemy.charName)..(TableInfo.spellKey))
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam("sep", "Interrupt "..(enemy.charName).." "..(TableInfo.spellKey), SCRIPT_PARAM_INFO, "")
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."AutoCarry", "in AutoCarry", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."MixedMode", "in MixedMode", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LaneClear", "in LaneClear", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."LastHit", "in LastHit", SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[(enemy.charName)..(TableInfo.spellKey)]:addParam((enemy.charName).."Always", "Always", SCRIPT_PARAM_ONOFF, true)
				Foundinterrupt = true
			end
		end
	end

	if not Foundinterrupt then SVMainMenu.interrupt:addParam("nil","No Enemies to Interrupt found", SCRIPT_PARAM_INFO, "") end
end

function ShadowVayne:FillMenu_StunSettings()
	SVMainMenu.autostunn:addParam("pushDistance", "Push Distance", SCRIPT_PARAM_SLICE, 390, 0, 450, 0)
	SVMainMenu.autostunn:addParam("towerstunn", "Stunn if Enemy lands unter a Tower", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.autostunn:addParam("trinket", "Use Auto-Trinket Bush", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.autostunn:addParam("target", "Stunn only Current Target", SCRIPT_PARAM_ONOFF, true)
end

function ShadowVayne:FillMenu_Draw()
	SVMainMenu.draw:addParam("DrawAARange", "Draw Basicattack Range", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.draw:addParam("DrawERange", "Draw E Range", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.draw:addParam("drawecolor", "E Range Color", SCRIPT_PARAM_COLOR, {141, 124, 4, 4})
	SVMainMenu.draw:addParam("drawaacolor", "Basicattack Range Color", SCRIPT_PARAM_COLOR, {141, 124, 4, 4})
	SVMainMenu.draw:addParam("LagFree", "Use LagFreeCircles", SCRIPT_PARAM_ONOFF, false)
end

function ShadowVayne:FillMenu_Autolevel()
		SVMainMenu.autolevel:addParam("UseAutoLevelfirst", "Use AutoLevelSpells Level 1-3", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.autolevel:addParam("UseAutoLevelrest", "Use AutoLevelSpells Level 4-18", SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.autolevel:addParam("first3level", "Level 1-3:", SCRIPT_PARAM_LIST, 1, { "Q-W-E", "Q-E-W", "W-Q-E", "W-E-Q", "E-Q-W", "E-W-Q" })
		SVMainMenu.autolevel:addParam("restlevel", "Level 4-18:", SCRIPT_PARAM_LIST, 1, { "Q-W-E", "Q-E-W", "W-Q-E", "W-E-Q", "E-Q-W", "E-W-Q" })
		SVMainMenu.autolevel:addParam("fap", "", SCRIPT_PARAM_INFO, "","" )
		SVMainMenu.autolevel:addParam("fap", "You can Click on the \"Q-W-E\"", SCRIPT_PARAM_INFO, "","" )
		SVMainMenu.autolevel:addParam("fap", "to change the Autospellorder", SCRIPT_PARAM_INFO, "","" )
end

function ShadowVayne:FillMenu_PermaShow()
	SVMainMenu.permashowsettings:addParam("epermashow", "PermaShow \"E on Next BasicAttack\"", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.permashowsettings:addParam("carrypermashow", "PermaShow: AutoCarry", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.permashowsettings:addParam("mixedpermashow", "PermaShow: Mixed Mode", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.permashowsettings:addParam("laneclearpermashow", "PermaShow: Laneclear", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.permashowsettings:addParam("lasthitpermashow", "PermaShow: Last hit", SCRIPT_PARAM_ONOFF, true)
end

function ShadowVayne:FillMenu_BotRK()
	SVMainMenu.botrksettings:addParam("botrkautocarry", "Use BotRK in AutoCarry", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.botrksettings:addParam("botrkmixedmode", "Use BotRK in MixedMode", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.botrksettings:addParam("botrklaneclear", "Use BotRK in LaneClear", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.botrksettings:addParam("botrklasthit", "Use BotRK in LastHit", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.botrksettings:addParam("botrkalways", "Use BotRK always", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.botrksettings:addParam("botrkmaxheal", "Max Own Health Percent", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
	SVMainMenu.botrksettings:addParam("botrkminheal", "Min Enemy Health Percent", SCRIPT_PARAM_SLICE, 20, 1, 100, 0)
end

function ShadowVayne:FillMenu_BilgeWater()
	SVMainMenu.bilgesettings:addParam("bilgeautocarry", "Use BilgeWater in AutoCarry", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.bilgesettings:addParam("bilgemixedmode", "Use BilgeWater in MixedMode", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.bilgesettings:addParam("bilgelaneclear", "Use BilgeWater in LaneClear", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.bilgesettings:addParam("bilgelasthit", "Use BilgeWater in LastHit", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.bilgesettings:addParam("bilgealways", "Use BilgeWater always", SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.bilgesettings:addParam("bilgemaxheal", "Max Own Health Percent", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
	SVMainMenu.bilgesettings:addParam("bilgeminheal", "Min Enemy Health Percent", SCRIPT_PARAM_SLICE, 20, 1, 100, 0)
end

function ShadowVayne:FillMenu_Tumble()
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
end

function ShadowVayne:FillMenu_WallTumble()
	SVMainMenu.walltumble:addParam("spot1", "Draw & Use Spot 1 (Drake-Spot)", SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.walltumble:addParam("spot2", "Draw & Use Spot 2 (Min-Spot)", SCRIPT_PARAM_ONOFF, true)
end

function ShadowVayne:LoadSOW()
	SVSOWMenu = scriptConfig("[ShadowVayne] SimpleOrbWalker Settings", "SV_SOW")
	VP = VPrediction()
	SOWi = SOW(VP)
	SOWi:LoadToMenu(SVSOWMenu)
end

function ShadowVayne:LoadTS()
	SVTSMenu = scriptConfig("[ShadowVayne] TargetSelector", "SV_TS")
	for i, enemy in pairs(GetEnemyHeroes()) do
		SVTSMenu:addParam(enemy.charName,enemy.charName, SCRIPT_PARAM_SLICE, 1, 1, #GetEnemyHeroes(), 0)
	end
	SVTSMenu:addParam("fap","", SCRIPT_PARAM_INFO, "")
	SVTSMenu:addParam("fap","Higher Number = Higher Focus", SCRIPT_PARAM_INFO, "")
	SVTSMenu:addParam("fap","Means:", SCRIPT_PARAM_INFO, "")
	SVTSMenu:addParam("fap","EnemyAdc = 5", SCRIPT_PARAM_INFO, "")
	SVTSMenu:addParam("fap","EnemyTank = 1", SCRIPT_PARAM_INFO, "")
end

function ShadowVayne:ArrangeEnemies()
	local EnemiesFound = 0
	for z=1,#priorityTable.AD_Carry do
		for i=1,#GetEnemyHeroes() do
			if priorityTable.AD_Carry[z] == SVTSMenu._param[i].text then
				SVTSMenu[SVTSMenu._param[i].text] = #GetEnemyHeroes() - EnemiesFound
				EnemiesFound = EnemiesFound + 1
			end
		end
	end

	for z=1,#priorityTable.AP do
		for i=1,#GetEnemyHeroes() do
			if priorityTable.AP[z] == SVTSMenu._param[i].text then
				SVTSMenu[SVTSMenu._param[i].text] = #GetEnemyHeroes() - EnemiesFound
				EnemiesFound = EnemiesFound + 1
			end
		end
	end

	for z=1,#priorityTable.Bruiser do
		for i=1,#GetEnemyHeroes() do
			if priorityTable.Bruiser[z] == SVTSMenu._param[i].text then
				SVTSMenu[SVTSMenu._param[i].text] = #GetEnemyHeroes() - EnemiesFound
				EnemiesFound = EnemiesFound + 1
			end
		end
	end

	for z=1,#priorityTable.Support do
		for i=1,#GetEnemyHeroes() do
			if priorityTable.Support[z] == SVTSMenu._param[i].text then
				SVTSMenu[SVTSMenu._param[i].text] = #GetEnemyHeroes() - EnemiesFound
				EnemiesFound = EnemiesFound + 1
			end
		end
	end

	for z=1,#priorityTable.Tank do
		for i=1,#GetEnemyHeroes() do
			if priorityTable.Tank[z] == SVTSMenu._param[i].text then
				SVTSMenu[SVTSMenu._param[i].text] = #GetEnemyHeroes() - EnemiesFound
				EnemiesFound = EnemiesFound + 1
			end
		end
	end
end

function ShadowVayne:DoubleModeProtection(msg, key)
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

function ShadowVayne:LoadRengar()
	for i, enemy in ipairs(GetEnemyHeroes()) do
		if enemy.charName == "Rengar" then
			RengarHero = enemy
		end
	end
end

function ShadowVayne:LoadCustomPermaShow()
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
end

function ShadowVayne:ActivateModes()
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

	--~ Get The Selected Orbwalker
	AutoCarryOrbText = SVMainMenu.keysetting._param[12].listTable[SVMainMenu.keysetting.AutoCarryOrb]
	MixedModeOrbText = SVMainMenu.keysetting._param[13].listTable[SVMainMenu.keysetting.MixedModeOrb]
	LaneClearOrbText = SVMainMenu.keysetting._param[14].listTable[SVMainMenu.keysetting.LaneClearOrb]
	LastHitOrbText = SVMainMenu.keysetting._param[15].listTable[SVMainMenu.keysetting.LastHitOrb]

	--~ Activate MMA
	if AutoCarryOrbText == "MMA" then _G.MMA_Orbwalker = ShadowVayneAutoCarry end
	if MixedModeOrbText == "MMA" then _G.MMA_HybridMode = ShadowVayneMixedMode end
	if LaneClearOrbText == "MMA" then _G.MMA_LaneClear = ShadowVayneLaneClear end
	if LastHitOrbText == "MMA" then _G.MMA_LastHit = ShadowVayneLastHit end

	--~ Activate SAC:Reborn R83
	if AutoCarryOrbText == "Reborn R83" then Keys.AutoCarry = ShadowVayneAutoCarry end
	if MixedModeOrbText == "Reborn R83" then Keys.MixedMode = ShadowVayneMixedMode end
	if LaneClearOrbText == "Reborn R83" then Keys.LaneClear = ShadowVayneLaneClear end
	if LastHitOrbText   == "Reborn R83" then Keys.LastHit = ShadowVayneLastHit end

	--~ Activate SAC:Reborn R84
	if AutoCarryOrbText == "Reborn R84" then SVMainMenu.keysetting.SACAutoCarry = ShadowVayneAutoCarry end
	if MixedModeOrbText == "Reborn R84" then SVMainMenu.keysetting.SACMixedMode = ShadowVayneMixedMode end
	if LaneClearOrbText == "Reborn R84" then SVMainMenu.keysetting.SACLaneClear = ShadowVayneLaneClear end
	if LastHitOrbText   == "Reborn R84" then SVMainMenu.keysetting.SACLastHit = ShadowVayneLastHit end

	--~ Activate SAC:Revamped
--~ 	if AutoCarryOrbText == "Revamped" then REVMenu.AutoCarry = ShadowVayneAutoCarry end
--~ 	if MixedModeOrbText == "Revamped" then REVMenu.MixedMode = ShadowVayneMixedMode end
--~ 	if LaneClearOrbText == "Revamped" then REVMenu.LaneClear = ShadowVayneLaneClear end
--~ 	if LastHitOrbText == "Revamped" then REVMenu.LastHit = ShadowVayneLastHit end

	--~ Activate SOW
	if AutoCarryOrbText == "SOW" then SVSOWMenu.Mode0 = ShadowVayneAutoCarry end
	if MixedModeOrbText == "SOW" then SVSOWMenu.Mode1 = ShadowVayneMixedMode end
	if LaneClearOrbText == "SOW" then SVSOWMenu.Mode2 = ShadowVayneLaneClear end
	if LastHitOrbText == "SOW" then SVSOWMenu.Mode3 = ShadowVayneLastHit end
end

function ShadowVayne:AutoLevelSpell()
	if self.LastLevelSpell + 250 < GetTickCount() then
		self.LastLevelSpell = GetTickCount()
		if GetGame().map.index == 8 and myHero.level < 4 and SVMainMenu.autolevel.UseAutoLevelfirst then
			LevelSpell(_Q)
			LevelSpell(_W)
			LevelSpell(_E)
		end
		if SVMainMenu.autolevel.UseAutoLevelfirst and myHero.level < 4 then
			LevelSpell(AutoLevelSpellTable[AutoLevelSpellTable["SpellOrder"][SVMainMenu.autolevel.first3level]][myHero.level])
		end

		if SVMainMenu.autolevel.UseAutoLevelrest and myHero.level > 3 then
			LevelSpell(AutoLevelSpellTable[AutoLevelSpellTable["SpellOrder"][SVMainMenu.autolevel.restlevel]][myHero.level])
		end
	end
end

function ShadowVayne:PermaShows()
	CustomPermaShow("AutoCarry (Using "..AutoCarryOrbText..")", SVMainMenu.keysetting.autocarry, SVMainMenu.permashowsettings.carrypermashow, nil, 1426521024, nil, 1)
	CustomPermaShow("MixedMode (Using "..MixedModeOrbText..")", SVMainMenu.keysetting.mixedmode, SVMainMenu.permashowsettings.mixedpermashow, nil, 1426521024, nil, 2)
	CustomPermaShow("LaneClear (Using "..LaneClearOrbText..")", SVMainMenu.keysetting.laneclear, SVMainMenu.permashowsettings.laneclearpermashow, nil, 1426521024, nil, 3)
	CustomPermaShow("LastHit (Using "..LastHitOrbText..")", SVMainMenu.keysetting.lasthit, SVMainMenu.permashowsettings.lasthitpermashow, nil, 1426521024, nil, 4)
	CustomPermaShow("Auto-E after next BasicAttack", SVMainMenu.keysetting.basiccondemn, SVMainMenu.permashowsettings.epermashow, nil, 1426521024, nil,  5)
end

function ShadowVayne:GetTarget()
	local TargetTable = { ["Hero"] = nil, ["AA"] = math.huge }
	for i, enemy in pairs(GetEnemyHeroes()) do
		if ValidTarget(enemy, 650) then
			NeededAA = self:GetAACount(enemy)
			if (NeededAA < TargetTable.AA) or (NeededAA == TargetTable.AA and SVTSMenu[enemy.charName] > SVTSMenu[TargetTable["Hero"].charName]) then
				TargetTable.AA = NeededAA
				TargetTable.Hero = enemy
			end
		end
	end
	return TargetTable["Hero"]
end

function ShadowVayne:GetAACount(enemy)
		EnemyHP = math.ceil(enemy.health)
		if myHero:GetSpellData(_W).level > 0 then TargetTrueDmg = math.floor((((enemy.maxHealth/100)*(3+(myHero:GetSpellData(_W).level)))+(10+(myHero:GetSpellData(_W).level)*10))/3) else	TargetTrueDmg = 0 end
		AADMG = math.floor((math.floor(myHero.totalDamage)) * 100 / (100 + enemy.armor)) + TargetTrueDmg
		DMGThisAA = AADMG + TargetTrueDmg
		NeededAA = math.ceil(EnemyHP / DMGThisAA)
		NeededAARoundDown = (math.floor(NeededAA/3))*3
		DMGWithAA = NeededAARoundDown * DMGThisAA
		PredictHP = EnemyHP - DMGWithAA
		RestAA = math.ceil(PredictHP / AADMG)

		if RestAA > 2 then
			return NeededAA
		else
			return NeededAARoundDown + RestAA
		end
end

function ShadowVayne:BotRK()
	local BladeSlot = GetInventorySlotItem(3153)
	local Target = self:GetTarget()
	if Target ~= nil and GetDistance(Target) < 450 and not Target.dead and Target.visible and BladeSlot ~= nil and myHero:CanUseSpell(BladeSlot) == 0 then
		if (SVMainMenu.botrksettings.botrkautocarry and ShadowVayneAutoCarry) or
		 (SVMainMenu.botrksettings.botrkmixedmode and ShadowVayneMixedMode) or
		 (SVMainMenu.botrksettings.botrklaneclear and ShadowVayneLaneClear) or
		 (SVMainMenu.botrksettings.botrklasthit and ShadowVayneLastHit) or
		 (SVMainMenu.botrksettings.botrkalways) then
			if (math.floor(myHero.health / myHero.maxHealth * 100)) <= SVMainMenu.botrksettings.botrkmaxheal then
				if (math.floor(Target.health / Target.maxHealth * 100)) >= SVMainMenu.botrksettings.botrkminheal then
					CastSpell(BladeSlot, Target)
				end
			end
		end
	end
end

function ShadowVayne:BilgeWater()
	local BilgeSlot = GetInventorySlotItem(3144)
	local Target = self:GetTarget()
	if Target ~= nil and GetDistance(Target) < 500 and not Target.dead and Target.visible and BilgeSlot ~= nil and myHero:CanUseSpell(BilgeSlot) == 0 then
		if (SVMainMenu.bilgesettings.bilgeautocarry and ShadowVayneAutoCarry) or
		 (SVMainMenu.bilgesettings.bilgemixedmode and ShadowVayneMixedMode) or
		 (SVMainMenu.bilgesettings.bilgelaneclear and ShadowVayneLaneClear) or
		 (SVMainMenu.bilgesettings.bilgelasthit and ShadowVayneLastHit) or
		 (SVMainMenu.bilgesettings.bilgealways) then
			if (math.floor(myHero.health / myHero.maxHealth * 100)) <= SVMainMenu.bilgesettings.bilgemaxheal then
				if (math.floor(Target.health / Target.maxHealth * 100)) >= SVMainMenu.bilgesettings.bilgeminheal then
					CastSpell(BilgeSlot, Target)
				end
			end
		end
	end
end

function ShadowVayne:GapCloserAfterCast()
	if spellExpired == false and (GetTickCount() - informationTable.spellCastedTick) <= (informationTable.spellRange/informationTable.spellSpeed)*1000 and myHero:CanUseSpell(_E) == READY then
		local spellDirection     = (informationTable.spellEndPos - informationTable.spellStartPos):normalized()
		local spellStartPosition = informationTable.spellStartPos + spellDirection
		local spellEndPosition   = informationTable.spellStartPos + spellDirection * informationTable.spellRange
		local heroPosition = Point(myHero.x, myHero.z)
		local SkillShot = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))
		if heroPosition:distance(SkillShot) <= 350 then
			CastSpell(_E, informationTable.spellSource)
		end
	else
		spellExpired = true
		informationTable = {}
	end
end

function ShadowVayne:GapCloserRengar()
	if ShootRengar and not RengarHero.dead and RengarHero.health > 0 and GetDistanceSqr(RengarHero) < 1000*1000 and myHero:CanUseSpell(_E) == READY then
		CastSpell(_E, RengarHero)
	else
		ShootRengar = false
	end
end

function ShadowVayne:RengarObject(Obj)
	if RengarHero ~= nil and Obj.name == "Rengar_LeapSound.troy" and GetDistanceSqr(RengarHero) < 1000*1000 then
		if SVMainMenu.anticapcloser[("Rengar")..(isAGapcloserUnitTarget["Rengar"].spellKey)][("Rengar").."AutoCarry"] and ShadowVayneAutoCarry then ShootRengar = true end
		if SVMainMenu.anticapcloser[("Rengar")..(isAGapcloserUnitTarget["Rengar"].spellKey)][("Rengar").."LastHit"] and ShadowVayneMixedMode then ShootRengar = true end
		if SVMainMenu.anticapcloser[("Rengar")..(isAGapcloserUnitTarget["Rengar"].spellKey)][("Rengar").."MixedMode"] and ShadowVayneLaneClear then ShootRengar = true end
		if SVMainMenu.anticapcloser[("Rengar")..(isAGapcloserUnitTarget["Rengar"].spellKey)][("Rengar").."LaneClear"] and ShadowVayneLastHit then ShootRengar = true end
		if SVMainMenu.anticapcloser[("Rengar")..(isAGapcloserUnitTarget["Rengar"].spellKey)][("Rengar").."Always"] then ShootRengar = true end
	end
end

function ShadowVayne:ThreshObject(Obj)
	if Obj.name == "ThreshLantern" then
		LanternObj = Obj
	end
end

function ShadowVayne:SwitchToggleMode()
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

function ShadowVayne:TreshLantern()
	if VIP_USER and SVMainMenu.keysetting.threshlantern and LanternObj then
		LanternPacket = CLoLPacket(0x39)
		LanternPacket:EncodeF(myHero.networkID)
		LanternPacket:EncodeF(LanternObj.networkID)
		LanternPacket.dwArg1 = 1
		LanternPacket.dwArg2 = 0
		SendPacket(LanternPacket)
	end
end

function ShadowVayne:Tumble(LastTarget, LastWindUptime)
	if LastTarget then
		Target = LastTarget
	else
		if not ShadowVayneAutoCarry then
			Target = self.LastAATarget
		else
			Target = self:GetTarget()
		end
	end
	if not myHero.dead and myHero:CanUseSpell(_Q) == READY and ValidTarget(Target, 850) and self.LastTumble + 1000 < GetTickCount() then
		if  (SVMainMenu.tumble.Qautocarry and ShadowVayneAutoCarry and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaAutoCarry)) or
			(SVMainMenu.tumble.Qmixedmode and ShadowVayneMixedMode and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaMixedMode)) or
			(SVMainMenu.tumble.Qlaneclear and ShadowVayneLaneClear and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaLaneClear)) or
			(SVMainMenu.tumble.Qlasthit and  ShadowVayneLastHit and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.QManaLastHit)) or
			(SVMainMenu.tumble.Qalways) then
			local AfterTumblePos = myHero + (Vector(mousePos) - myHero):normalized() * 300
			if GetDistance(AfterTumblePos, Target) < 650 and GetDistance(AfterTumblePos, Target) > 250 and AllowTumble then
				CastSpell(_Q, mousePos.x, mousePos.z)
				self.LastTumble = GetTickCount()
--~ 				SOW:resetAA()
--~ 				if Target then
--~ 					self.ForceAA = true
--~ 					DelayAction(function() self:AfterTumbleForceAA(Target) end, 0.2)
--~ 				end
			end
			if GetDistance(AfterTumblePos, Target) < 650 and GetDistance(Target) > 650 then
				CastSpell(_Q, mousePos.x, mousePos.z)
				self.LastTumble = GetTickCount()
--~ 				SOW:resetAA()
--~ 				if Target then
--~ 					self.ForceAA = true
--~ 					DelayAction(function() self:AfterTumbleForceAA(Target) end, 0.2)
--~ 				end
			end
		end
	end
end

function ShadowVayne:AfterTumbleForceAA(Target)
	if self.ForceAA then
		if ValidTarget(Target, 650) then
			print("FORCE")
			myHero:Attack(Target)
			DelayAction(function() self:AfterTumbleForceAA(Target) end, 0.1)
		else
			self.ForceAA = false
		end
	end
end

function ShadowVayne:ProcessSpell_GapCloser(unit, spell)
	if unit.team ~= myHero.team then
		if isAGapcloserUnitTarget[unit.charName] and spell.name == isAGapcloserUnitTarget[unit.charName].spell then
			if spell.target ~= nil and spell.target.hash == myHero.hash then
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then CastSpell(_E, unit) end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then CastSpell(_E, unit) end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then CastSpell(_E, unit) end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then CastSpell(_E, unit) end
				if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."Always"] then CastSpell(_E, unit) end
			end
		end

		if isAGapcloserUnitNoTarget[spell.name] and GetDistanceSqr(unit) <= 2000*2000 and (spell.target == nil or spell.target.isMe) then
			if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then spellExpired = false end
			if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then spellExpired = false end
			if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then spellExpired = false end
			if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then spellExpired = false end
			if SVMainMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitNoTarget[spell.name].spellKey)][(unit.charName).."Always"] then spellExpired = false end
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

function ShadowVayne:ProcessSpell_Interrupt(unit, spell)
	if unit.team ~= myHero.team then
		if isAChampToInterrupt[spell.name] and unit.charName == isAChampToInterrupt[spell.name].champ and GetDistanceSqr(unit) <= 715*715 then
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then CastSpell(_E, unit) end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then CastSpell(_E, unit) end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then CastSpell(_E, unit) end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then CastSpell(_E, unit) end
			if SVMainMenu.interrupt[(unit.charName)..(isAChampToInterrupt[spell.name].spellKey)][(unit.charName).."Always"] then CastSpell(_E, unit) end
		end
	end
end

function ShadowVayne:ProcessSpell_CondemnAfterAA(unit, spell)
	if unit.isMe then
		if spell.name:lower():find("attack") then
			if SVMainMenu.keysetting.basiccondemn and spell.target.type == myHero.type then
				SVMainMenu.keysetting.basiccondemn = false
				self.AACondemn = spell.target
				DelayAction(function() CastSpell(_E, self.AACondemn) end, spell.windUpTime - GetLatency() / 2000)
			else
				SVMainMenu.keysetting.basiccondemn = false
			end
		end
	end
end

function ShadowVayne:ProcessSpell_Recall(unit, spell)
	if unit.isMe then
		if spell.name == "Recall" then
			RecallCast = true
			DelayAction(function() RecallCast = false end, 0.75)
		end
	end
end

function ShadowVayne:ProcessSpell_AllowTumble(unit, spell)
	if unit.isMe then
		if spell.name:lower():find("attack") and not spell.name:lower():find("tumble") then
			self.LastAATarget = spell.target
			DelayAction(function() AllowTumble = true end, spell.windUpTime - GetLatency() / 2000)
			DelayAction(function() AllowTumble = false end, (spell.animationTime - GetLatency() / 2000) - (spell.windUpTime))
		end
		if spell.name:lower():find("attack") and spell.name:lower():find("tumble") then
			self.ForceAA = false
		end
	end
end

function ShadowVayne:Draw_WallTumble()
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

function ShadowVayne:Draw_CondemnRange()
	if SVMainMenu.draw.DrawERange then
		self:CircleDraw(myHero.x, myHero.y, myHero.z, 710, ARGB(SVMainMenu.draw.drawecolor[1], SVMainMenu.draw.drawecolor[2],SVMainMenu.draw.drawecolor[3],SVMainMenu.draw.drawecolor[4]))
	end
end

function ShadowVayne:Draw_AARange()
	if SVMainMenu.draw.DrawAARange then
		self:CircleDraw(myHero.x, myHero.y, myHero.z, 655, ARGB(SVMainMenu.draw.drawaacolor[1], SVMainMenu.draw.drawaacolor[2],SVMainMenu.draw.drawaacolor[3],SVMainMenu.draw.drawaacolor[4]))
	end
end

function ShadowVayne:CheckWallStun(PredictPos, Source)
	local BushFound, Bushpos = false, nil
	for i = 1, SVMainMenu.autostunn.pushDistance, 50  do
		local CheckWallPos = Vector(PredictPos) + (Vector(PredictPos) - myHero):normalized()*(i)
		local CheckVector = D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)
		if not BushFound and IsWallOfGrass(CheckVector) then
			BushFound = true
			BushPos = CheckWallPos
		end
		if IsWall(CheckVector) then
			if UnderTurret(CheckVector, true) then
				if SVMainMenu.autostunn.towerstunn then
					AllowTumble = false
					CastSpell(_E, Source)
					CondemnLastE = GetTickCount()
					break
				end
			else
				AllowTumble = false
				CastSpell(_E, Source)
				CondemnLastE = GetTickCount()
				if BushFound and SVMainMenu.autostunn.trinket and myHero:CanUseSpell(ITEM_7) == 0 then
					CastSpell(ITEM_7, BushPos.x, BushPos.z)
				end
				break
			end
		end
	end
end

function ShadowVayne:CondemnStun()
	local Target = self:GetTarget()
	if myHero:CanUseSpell(_E) == READY and GetTickCount() > (CondemnLastE + 1000) then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if SVMainMenu.autostunn.target then enemy = Target end
			if enemy == nil then return end
			if 	(SVMainMenu.targets[enemy.charName][(enemy.charName).."AutoCarry"] and ShadowVayneAutoCarry) or
			(SVMainMenu.targets[enemy.charName][(enemy.charName).."MixedMode"] and ShadowVayneMixedMode) or
			(SVMainMenu.targets[enemy.charName][(enemy.charName).."LaneClear"] and ShadowVayneLaneClear) or
			(SVMainMenu.targets[enemy.charName][(enemy.charName).."LastHit"]   and ShadowVayneLastHit) or
			(SVMainMenu.targets[enemy.charName][(enemy.charName).."Always"])	then
				if GetDistance(enemy) <= 1000 and not enemy.dead and enemy.visible then
					if not VIP_USER then -- FREEUSER
						StunPos = self:GetCondemCollisionTime(enemy)
						if StunPos ~= nil and GetDistance(StunPos) < 710 then
							self:CheckWallStun(StunPos, enemy)
						end

					end

					if VIP_USER then -- PR0D
						StunPos = Prodiction.GetPrediction(enemy, 650, 1200, 0.4, 10, myHero)
						if StunPos ~= nil and GetDistanceSqr(StunPos) < 650*650 then
							self:CheckWallStun(StunPos, enemy)
						end
					end
				end
			end
		end
	end
end

function ShadowVayne:WallTumble()
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

function ShadowVayne:SendPacket_WallTumble(p)
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
		P_X2 = tonumber(string.format("%." .. (2) .. "f", P_X))

		P_Y = p:DecodeF()
		P_Y2 = tonumber(string.format("%." .. (2) .. "f", P_Y))
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

function ShadowVayne:UpdateHeroDirection() --Function done by Yomie from EzCondemn
	for heroName, heroObj in pairs(heroDirDB) do
		local hero = heroManager:GetHero(heroObj.index)
		local currentVec = Vector(hero)
		local dir = (currentVec - heroObj.lastVec)

		if dir ~= Vector(0,0,0) then
			dir = dir:normalized()
		end

		heroObj.lastAngle = heroObj.dir:dotP( dir )
		heroObj.dir = dir
		heroObj.lastVec = currentVec
	end
end

function ShadowVayne:GetCondemCollisionTime(target) --Function done by Yomie from EzCondemn
	local heroObj = heroDirDB[target.name]

	if heroObj.dir ~= Vector(0,0,0) then

	if heroObj.lastAngle and heroObj.lastAngle < .8 then
		return nil
	end


	local windupPos = Vector(target) + heroObj.dir * (target.ms * 250/1000)
	local timeElapsed = self:GetCollisionTime(windupPos, heroObj.dir, target.ms, myHero, 2000 )

	if timeElapsed == nil then
		return nil
	end

	return Vector(target) + heroObj.dir * target.ms * (timeElapsed + .25)/2

	end

	return Vector(target)
end

function ShadowVayne:GetCollisionTime (targetPos, targetDir, targetSpeed, sourcePos, projSpeed ) --Function done by Yomie from EzCondemn
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

function ShadowVayne:DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
 radius = radius or 300
 quality = math.max(8,math.floor(180/math.deg((math.asin((chordlength/(2*radius)))))))
 quality = 2 * math.pi / quality
 radius = radius*.92
 local points = {}
 for theta = 0, 2 * math.pi + quality, quality do
  local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
  points[#points + 1] = D3DXVECTOR2(c.x, c.y)
 end
 DrawLines2(points, width or 1, color or 4294967295)
end

function ShadowVayne:DrawCircle2(x, y, z, radius, color)
 local vPos1 = Vector(x, y, z)
 local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
 local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
 local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
 if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
  self:DrawCircleNextLvl(x, y, z, radius, 1, color, 75)
 end
end

function ShadowVayne:CircleDraw(x,y,z,radius, color)
	if SVMainMenu.draw.LagFree then
		self:DrawCircle2(x, y, z, radius, color)
	else
		DrawCircle(x, y, z, radius, color)
	end
end

---------------------
-------- SOW --------
---------------------
class "SOW"
function SOW:__init(VP)
	_G.SOWLoaded = true

	self.ProjectileSpeed = myHero.range > 300 and VP:GetProjectileSpeed(myHero) or math.huge
	self.BaseWindupTime = 3
	self.BaseAnimationTime = 0.65
	self.DataUpdated = false

	self.VP = VP

	--Callbacks
	self.AfterAttackCallbacks = {}
	self.OnAttackCallbacks = {}
	self.BeforeAttackCallbacks = {}

	self.AttackTable =
		{
			["Ashes Q"] = "frostarrow",
		}

	self.NoAttackTable =
		{
			["Shyvana1"] = "shyvanadoubleattackdragon",
			["Shyvana2"] = "ShyvanaDoubleAttack",
			["Wukong"] = "MonkeyKingDoubleAttack",
		}

	self.AttackResetTable =
		{
			["vayne"] = _Q,
			["darius"] = _W,
			["fiora"] = _E,
			["gangplank"] = _Q,
			["jax"] = _W,
			["leona"] = _Q,
			["mordekaiser"] = _Q,
			["nasus"] = _Q,
			["nautilus"] = _W,
			["nidalee"] = _Q,
			["poppy"] = _Q,
			["renekton"] = _W,
			["rengar"] = _Q,
			["shyvana"] = _Q,
			["sivir"] = _W,
			["talon"] = _Q,
			["trundle"] = _Q,
			["vi"] = _E,
			["volibear"] = _Q,
			["xinzhao"] = _Q,
			["monkeyking"] = _Q,
			["yorick"] = _Q,
			["cassiopeia"] = _E,
			["garen"] = _Q,
			["khazix"] = _Q,
		}

	self.LastAttack = 0
	self.EnemyMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_MAXHEALTH_ASC)
	self.JungleMinions = minionManager(MINION_JUNGLE, 2000, myHero, MINION_SORT_MAXHEALTH_DEC)
	self.OtherMinions = minionManager(MINION_OTHER, 2000, myHero, MINION_SORT_HEALTH_ASC)

	GetSave("SOW").FarmDelay = GetSave("SOW").FarmDelay and GetSave("SOW").FarmDelay or 0
	GetSave("SOW").ExtraWindUpTime = GetSave("SOW").ExtraWindUpTime and GetSave("SOW").ExtraWindUpTime or 50
	GetSave("SOW").Mode3 = GetSave("SOW").Mode3 and GetSave("SOW").Mode3 or string.byte("X")
	GetSave("SOW").Mode2 = GetSave("SOW").Mode2 and GetSave("SOW").Mode2 or string.byte("V")
	GetSave("SOW").Mode1 = GetSave("SOW").Mode1 and GetSave("SOW").Mode1 or string.byte("C")
	GetSave("SOW").Mode0 = GetSave("SOW").Mode0 and GetSave("SOW").Mode0 or 32

	self.Attacks = true
	self.Move = true
	self.mode = -1
	self.checkcancel = 0

	AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
end

function SOW:LoadToMenu(m, STS)
	if not m then
		self.Menu = scriptConfig("Simple OrbWalker", "SOW")
	else
		self.Menu = m
	end

	if STS then
		self.STS = STS
		self.STS.VP = self.VP
	end

	self.Menu:addParam("Enabled", "Enabled", SCRIPT_PARAM_ONOFF, true)
	self.Menu:addParam("FarmDelay", "Farm Delay", SCRIPT_PARAM_SLICE, -150, 0, 150)
	self.Menu:addParam("ExtraWindUpTime", "Extra WindUp Time", SCRIPT_PARAM_SLICE, -150,  0, 150)

	self.Menu.FarmDelay = GetSave("SOW").FarmDelay
	self.Menu.ExtraWindUpTime = GetSave("SOW").ExtraWindUpTime

	self.Menu:addParam("Attack",  "Attack", SCRIPT_PARAM_LIST, 2, { "Only Farming", "Farming + Carry mode"})
	self.Menu:addParam("Mode",  "Orbwalking mode", SCRIPT_PARAM_LIST, 1, { "To mouse", "To target"})

	self.Menu:addParam("Hotkeys", "", SCRIPT_PARAM_INFO, "")

	self.Menu:addParam("Mode3", "Last hit!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	self.Mode3ParamID = #self.Menu._param
	self.Menu:addParam("Mode1", "Mixed Mode!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	self.Mode1ParamID = #self.Menu._param
	self.Menu:addParam("Mode2", "Laneclear!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
	self.Mode2ParamID = #self.Menu._param
	self.Menu:addParam("Mode0", "Carry me!", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	self.Mode0ParamID = #self.Menu._param

	self.Menu._param[self.Mode3ParamID].key = GetSave("SOW").Mode3
	self.Menu._param[self.Mode2ParamID].key = GetSave("SOW").Mode2
	self.Menu._param[self.Mode1ParamID].key = GetSave("SOW").Mode1
	self.Menu._param[self.Mode0ParamID].key = GetSave("SOW").Mode0

	AddTickCallback(function() self:OnTick() end)
	AddTickCallback(function() self:CheckConfig() end)
end

function SOW:CheckConfig()
	GetSave("SOW").FarmDelay = self.Menu.FarmDelay
	GetSave("SOW").ExtraWindUpTime = self.Menu.ExtraWindUpTime

	GetSave("SOW").Mode3 = self.Menu._param[self.Mode3ParamID].key
	GetSave("SOW").Mode2 = self.Menu._param[self.Mode2ParamID].key
	GetSave("SOW").Mode1 = self.Menu._param[self.Mode1ParamID].key
	GetSave("SOW").Mode0 = self.Menu._param[self.Mode0ParamID].key
end

function SOW:DisableAttacks()
	self.Attacks = false
end

function SOW:EnableAttacks()
	self.Attacks = true
end

function SOW:ForceTarget(target)
	self.forcetarget = target
end

function SOW:GetTime()
	return os.clock()
end

function SOW:MyRange(target)
	local myRange = myHero.range + self.VP:GetHitBox(myHero)
	if target and ValidTarget(target) then
		myRange = myRange + self.VP:GetHitBox(target)
	end
	return myRange - 20
end

function SOW:InRange(target)
	local MyRange = self:MyRange(target)
	if target and GetDistanceSqr(target.visionPos, myHero.visionPos) <= MyRange * MyRange then
		return true
	end
end

function SOW:ValidTarget(target)
	if target and target.type and (target.type == "obj_BarracksDampener" or target.type == "obj_HQ")  then
		return false
	end
	return ValidTarget(target) and self:InRange(target)
end

function SOW:Attack(target)
	self.LastAttack = self:GetTime() + self:Latency()
	myHero:Attack(target)
end

function SOW:WindUpTime(exact)
	return (1 / (myHero.attackSpeed * self.BaseWindupTime)) + (exact and 0 or GetSave("SOW").ExtraWindUpTime / 1000)
end

function SOW:AnimationTime()
	return (1 / (myHero.attackSpeed * self.BaseAnimationTime))
end

function SOW:Latency()
	return GetLatency() / 2000
end

function SOW:CanAttack()
	if self.LastAttack <= self:GetTime() then
		return (self:GetTime() + self:Latency()  > self.LastAttack + self:AnimationTime())
	end
	return false
end

function SOW:CanMove()
	if self.LastAttack <= self:GetTime() then
		return ((self:GetTime() + self:Latency() > self.LastAttack + self:WindUpTime()) or self.ParticleCreated) and not _G.evade
	end
end

function SOW:BeforeAttack(target)
	local result = false
	for i, cb in ipairs(self.BeforeAttackCallbacks) do
		local ri = cb(target, self.mode)
		if ri then
			result = true
		end
	end
	return result
end

function SOW:RegisterBeforeAttackCallback(f)
	table.insert(self.BeforeAttackCallbacks, f)
end

function SOW:OnAttack(target)
	for i, cb in ipairs(self.OnAttackCallbacks) do
		cb(target, self.mode)
	end
end

function SOW:RegisterOnAttackCallback(f)
	table.insert(self.OnAttackCallbacks, f)
end

function SOW:AfterAttack(target)
	for i, cb in ipairs(self.AfterAttackCallbacks) do
		cb(target, self.mode)
	end
end

function SOW:RegisterAfterAttackCallback(f)
	table.insert(self.AfterAttackCallbacks, f)
end

function SOW:MoveTo(x, y)
	myHero:MoveTo(x, y)
end

function SOW:OrbWalk(target, point)
	point = point or self.forceorbwalkpos
	if self.Attacks and self:CanAttack() and self:ValidTarget(target) and not self:BeforeAttack(target) then
		self:Attack(target)
	elseif self:CanMove() and self.Move then
		if not point then
			local OBTarget = GetTarget() or target
			if self.Menu.Mode == 1 or not OBTarget then
				local Mv = Vector(myHero) + 400 * (Vector(mousePos) - Vector(myHero)):normalized()
				self:MoveTo(Mv.x, Mv.z)
			elseif GetDistanceSqr(OBTarget) > 100*100 + math.pow(self.VP:GetHitBox(OBTarget), 2) then
				local point = self.VP:GetPredictedPos(OBTarget, 0, 2*myHero.ms, myHero, false)
				if GetDistanceSqr(point) < 100*100 + math.pow(self.VP:GetHitBox(OBTarget), 2) then
					point = Vector(Vector(myHero) - point):normalized() * 50
				end
				self:MoveTo(point.x, point.z)
			end
		else
			self:MoveTo(point.x, point.z)
		end
	end
end

function SOW:IsAttack(SpellName)
	return (SpellName:lower():find("attack") or table.contains(self.AttackTable, SpellName:lower())) and not table.contains(self.NoAttackTable, SpellName:lower())
end

function SOW:IsAAReset(SpellName)
	local SpellID
	if SpellName:lower() == myHero:GetSpellData(_Q).name:lower() then
		SpellID = _Q
	elseif SpellName:lower() == myHero:GetSpellData(_W).name:lower() then
		SpellID = _W
	elseif SpellName:lower() == myHero:GetSpellData(_E).name:lower() then
		SpellID = _E
	elseif SpellName:lower() == myHero:GetSpellData(_R).name:lower() then
		SpellID = _R
	end

	if SpellID then
		return self.AttackResetTable[myHero.charName:lower()] == SpellID
	end
	return false
end

function SOW:OnProcessSpell(unit, spell)
	if unit.isMe and self:IsAttack(spell.name) then
		if self.debugdps then
			DPS = DPS and DPS or 0
			print("DPS: "..(1000/(self:GetTime()- DPS)).." "..(1000/(self:AnimationTime())))
			DPS = self:GetTime()
		end
		if not self.DataUpdated and not spell.name:lower():find("card") then
			self.BaseAnimationTime = 1 / (spell.animationTime * myHero.attackSpeed)
			self.BaseWindupTime = 1 / (spell.windUpTime * myHero.attackSpeed)
			if self.debug then
				print("<font color=\"#FF0000\">Basic Attacks data updated: </font>")
				print("<font color=\"#FF0000\">BaseWindupTime: "..self.BaseWindupTime.."</font>")
				print("<font color=\"#FF0000\">BaseAnimationTime: "..self.BaseAnimationTime.."</font>")
				print("<font color=\"#FF0000\">ProjectileSpeed: "..self.ProjectileSpeed.."</font>")
			end
			self.DataUpdated = true
		end
		self.LastAttack = self:GetTime() - self:Latency()
		self.checking = true
		self.LastAttackCancelled = false
		self:OnAttack(spell.target)
		self.checkcancel = self:GetTime()
		self.LastTarget = spell.target
		DelayAction(function(t) self:AfterAttack(t) end, self:WindUpTime() - self:Latency(), {spell.target})

	elseif unit.isMe and self:IsAAReset(spell.name) then
		DelayAction(function() self:resetAA() end, 0.25)
--~ 		DelayAction(function() if self.LastTarget ~= nil and self:ValidTarget(self.LastTarget) then myHero:Attack(self.LastTarget) end end, 0.25)
	end
end

function SOW:resetAA()
	self.LastAttack = 0
end

function SOW:BonusDamage(minion)
	local AD = myHero:CalcDamage(minion, myHero.totalDamage)
	local BONUS = 0
	if myHero.charName == 'Vayne' then
		if myHero:GetSpellData(_Q).level > 0 and myHero:CanUseSpell(_Q) == SUPRESSED then
			BONUS = BONUS + myHero:CalcDamage(minion, ((0.05 * myHero:GetSpellData(_Q).level) + 0.25 ) * myHero.totalDamage)
		end
		if not VayneCBAdded then
			VayneCBAdded = true
			function VayneParticle(obj)
				if GetDistance(obj) < 1000 and obj.name:lower():find("vayne_w_ring2.troy") then
					VayneWParticle = obj
				end
			end
			AddCreateObjCallback(VayneParticle)
		end
		if VayneWParticle and VayneWParticle.valid and GetDistance(VayneWParticle, minion) < 10 then
			BONUS = BONUS + 10 + 10 * myHero:GetSpellData(_W).level + (0.03 + (0.01 * myHero:GetSpellData(_W).level)) * minion.maxHealth
		end
	elseif myHero.charName == 'Teemo' and myHero:GetSpellData(_E).level > 0 then
		BONUS = BONUS + myHero:CalcMagicDamage(minion, (myHero:GetSpellData(_E).level * 10) + (myHero.ap * 0.3) )
	elseif myHero.charName == 'Corki' then
		BONUS = BONUS + myHero.totalDamage/10
	elseif myHero.charName == 'MissFortune' and myHero:GetSpellData(_W).level > 0 then
		BONUS = BONUS + myHero:CalcMagicDamage(minion, (4 + 2 * myHero:GetSpellData(_W).level) + (myHero.ap/20))
	elseif myHero.charName == 'Varus' and myHero:GetSpellData(_W).level > 0 then
		BONUS = BONUS + (6 + (myHero:GetSpellData(_W).level * 4) + (myHero.ap * 0.25))
	elseif myHero.charName == 'Caitlyn' then
			if not CallbackCaitlynAdded then
				function CaitlynParticle(obj)
					if GetDistance(obj) < 100 and obj.name:lower():find("caitlyn_headshot_rdy") then
							HeadShotParticle = obj
					end
				end
				AddCreateObjCallback(CaitlynParticle)
				CallbackCaitlynAdded = true
			end
			if HeadShotParticle and HeadShotParticle.valid then
				BONUS = BONUS + AD * 1.5
			end
	elseif myHero.charName == 'Orianna' then
		BONUS = BONUS + myHero:CalcMagicDamage(minion, 10 + 8 * ((myHero.level - 1) % 3))
	elseif myHero.charName == 'TwistedFate' then
			if not TFCallbackAdded then
				function TFParticle(obj)
					if GetDistance(obj) < 100 and obj.name:lower():find("cardmaster_stackready.troy") then
						TFEParticle = obj
					elseif GetDistance(obj) < 100 and obj.name:lower():find("card_blue.troy") then
						TFWParticle = obj
					end
				end
				AddCreateObjCallback(TFParticle)
				TFCallbackAdded = true
			end
			if TFEParticle and TFEParticle.valid then
				BONUS = BONUS + myHero:CalcMagicDamage(minion, myHero:GetSpellData(_E).level * 15 + 40 + 0.5 * myHero.ap)
			end
			if TFWParticle and TFWParticle.valid then
				BONUS = BONUS + math.max(myHero:CalcMagicDamage(minion, myHero:GetSpellData(_W).level * 20 + 20 + 0.5 * myHero.ap) - 40, 0)
			end
	elseif myHero.charName == 'Draven' then
			if not CallbackDravenAdded then
				function DravenParticle(obj)
					if GetDistance(obj) < 100 and obj.name:lower():find("draven_q_buf") then
							DravenParticleo = obj
					end
				end
				AddCreateObjCallback(DravenParticle)
				CallbackDravenAdded = true
			end
			if DravenParticleo and DravenParticleo.valid then
				BONUS = BONUS + AD * (0.3 + (0.10 * myHero:GetSpellData(_Q).level))
			end
	elseif myHero.charName == 'Nasus' and VIP_USER then
		if myHero:GetSpellData(_Q).level > 0 and myHero:CanUseSpell(_Q) == SUPRESSED then
			local Qdamage = {30, 50, 70, 90, 110}
			NasusQStacks = NasusQStacks or 0
			BONUS = BONUS + myHero:CalcDamage(minion, 10 + 20 * (myHero:GetSpellData(_Q).level) + NasusQStacks)
			if not RecvPacketNasusAdded then
				function NasusOnRecvPacket(p)
					if p.header == 0xFE and p.size == 0xC then
						p.pos = 1
						pNetworkID = p:DecodeF()
						unk01 = p:Decode2()
				 		unk02 = p:Decode1()
						stack = p:Decode4()
						if pNetworkID == myHero.networkID then
							NasusQStacks = stack
						end
					end
				end
				RecvPacketNasusAdded = true
				AddRecvPacketCallback(NasusOnRecvPacket)
			end
		end
	elseif myHero.charName == "Ziggs" then
		if not CallbackZiggsAdded then
			function ZiggsParticle(obj)
				if GetDistance(obj) < 100 and obj.name:lower():find("ziggspassive") then
						ZiggsParticleObj = obj
				end
			end
			AddCreateObjCallback(ZiggsParticle)
			CallbackZiggsAdded = true
		end
		if ZiggsParticleObj and ZiggsParticleObj.valid then
			local base = {20, 24, 28, 32, 36, 40, 48, 56, 64, 72, 80, 88, 100, 112, 124, 136, 148, 160}
			BONUS = BONUS + myHero:CalcMagicDamage(minion, base[myHero.level] + (0.25 + 0.05 * (myHero.level % 7)) * myHero.ap)
		end
	end

	return BONUS
end

function SOW:KillableMinion()
	local result
	for i, minion in ipairs(self.EnemyMinions.objects) do
		local time = self:WindUpTime(true) + GetDistance(minion.visionPos, myHero.visionPos) / self.ProjectileSpeed - 0.07
		local PredictedHealth = self.VP:GetPredictedHealth(minion, time, GetSave("SOW").FarmDelay / 1000)
		if self:ValidTarget(minion) and PredictedHealth < self.VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0) + self:BonusDamage(minion) and PredictedHealth > -40 then
			result = minion
			break
		end
	end
	return result
end

function SOW:ShouldWait()
	for i, minion in ipairs(self.EnemyMinions.objects) do
		local time = self:AnimationTime() + GetDistance(minion.visionPos, myHero.visionPos) / self.ProjectileSpeed - 0.07
		if self:ValidTarget(minion) and self.VP:GetPredictedHealth2(minion, time * 2) < (self.VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0) + self:BonusDamage(minion)) then
			return true
		end
	end
end

function SOW:ValidStuff()
	local result = self:GetTarget()

	if result then
		return result
	end

	for i, minion in ipairs(self.EnemyMinions.objects) do
		local time = self:AnimationTime() + GetDistance(minion.visionPos, myHero.visionPos) / self.ProjectileSpeed - 0.07
		local pdamage2 = minion.health - self.VP:GetPredictedHealth(minion, time, GetSave("SOW").FarmDelay / 1000)
		local pdamage = self.VP:GetPredictedHealth2(minion, time * 2)
		if self:ValidTarget(minion) and ((pdamage) > 2*self.VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0) + self:BonusDamage(minion) or pdamage2 == 0) then
			return minion
		end
	end

	for i, minion in ipairs(self.JungleMinions.objects) do
		if self:ValidTarget(minion) then
			return minion
		end
	end

	for i, minion in ipairs(self.OtherMinions.objects) do
		if self:ValidTarget(minion) then
			return minion
		end
	end
end

function SOW:GetTarget(OnlyChampions)
	local result
	local healthRatio

	if ShadowVayne:GetTarget() ~= nil then
		return ShadowVayne:GetTarget()
	end

	if self:ValidTarget(self.forcetarget) then
		return self.forcetarget
	elseif self.forcetarget ~= nil then
		return nil
	end

	if (not self.STS or not OnlyChampions) and self:ValidTarget(GetTarget()) and (GetTarget().type == myHero.type or (not OnlyChampions)) then
		return GetTarget()
	end

	if self.STS then
		local oldhitboxmode = self.STS.hitboxmode
		self.STS.hitboxmode = true

		result = self.STS:GetTarget(myHero.range)

		self.STS.hitboxmode = oldhitboxmode
		return result
	end

	for i, champion in ipairs(GetEnemyHeroes()) do
		local hr = champion.health / myHero:CalcDamage(champion, 200)
		if self:ValidTarget(champion) and ((healthRatio == nil) or hr < healthRatio) then
			result = champion
			healthRatio = hr
		end
	end

	return result
end

function SOW:Farm(mode, point)
	if mode == 1 then
		self.EnemyMinions:update()
		local target = self:KillableMinion() or self:GetTarget()
		self:OrbWalk(target, point)
		self.mode = 1
	elseif mode == 2 then
		self.EnemyMinions:update()
		self.OtherMinions:update()
		self.JungleMinions:update()

		local target = self:KillableMinion()
		if target then
			self:OrbWalk(target, point)
		elseif not self:ShouldWait() then

			if self:ValidTarget(self.lasttarget) then
				target = self.lasttarget
			else
				target = self:ValidStuff()
			end
			self.lasttarget = target

			self:OrbWalk(target, point)
		else
			self:OrbWalk(nil, point)
		end
		self.mode = 2
	elseif mode == 3 then
		self.EnemyMinions:update()
		local target = self:KillableMinion()
		self:OrbWalk(target, point)
		self.mode = 3
	end
end

function SOW:OnTick()
	if not self.Menu.Enabled then return end
	if self.Menu.Mode0 then
		local target = self:GetTarget(true)
		if self.Menu.Attack == 2 then
			self:OrbWalk(target)
		else
			self:OrbWalk()
		end
		self.mode = 0
	elseif self.Menu.Mode1 then
		self:Farm(1)
	elseif self.Menu.Mode2 then
		self:Farm(2)
	elseif self.Menu.Mode3 then
		self:Farm(3)
	else
		self.mode = -1
	end
end

function SOW:DrawAARange(width, color)
	local p = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
	if OnScreen(p.x, p.y) then
		DrawCircle3D(myHero.x, myHero.y, myHero.z, self:MyRange() + 25, width or 1, color or ARGB(255, 255, 0, 0))
	end
end


--~ ---------------------------------
--~ ---------- Stunn Logic ----------
--~ ---------------------------------

--~ function _GetFlyTime(EnemyDistance)
--~ 		if EnemyDistance <  25 then FlyTimeDelay = 0 end
--~ 		if EnemyDistance >  24 and EnemyDistance <  75 then FlyTimeDelay = (StunnFlyTime["50"]/1000) end
--~ 		if EnemyDistance >  74 and EnemyDistance < 125 then FlyTimeDelay = (StunnFlyTime["100"]/1000) end
--~ 		if EnemyDistance > 124 and EnemyDistance < 175 then FlyTimeDelay = (StunnFlyTime["150"]/1000) end
--~ 		if EnemyDistance > 174 and EnemyDistance < 225 then FlyTimeDelay = (StunnFlyTime["200"]/1000) end
--~ 		if EnemyDistance > 224 and EnemyDistance < 275 then FlyTimeDelay = (StunnFlyTime["250"]/1000) end
--~ 		if EnemyDistance > 274 and EnemyDistance < 325 then FlyTimeDelay = (StunnFlyTime["300"]/1000) end
--~ 		if EnemyDistance > 324 and EnemyDistance < 375 then FlyTimeDelay = (StunnFlyTime["350"]/1000) end
--~ 		if EnemyDistance > 374 and EnemyDistance < 425 then FlyTimeDelay = (StunnFlyTime["400"]/1000) end
--~ 		if EnemyDistance > 424 and EnemyDistance < 475 then FlyTimeDelay = (StunnFlyTime["450"]/1000) end
--~ 		if EnemyDistance > 474 and EnemyDistance < 525 then FlyTimeDelay = (StunnFlyTime["500"]/1000) end
--~ 		if EnemyDistance > 524 and EnemyDistance < 575 then FlyTimeDelay = (StunnFlyTime["550"]/1000) end
--~ 		if EnemyDistance > 574 and EnemyDistance < 625 then FlyTimeDelay = (StunnFlyTime["600"]/1000) end
--~ 		if EnemyDistance > 624 and EnemyDistance < 675 then FlyTimeDelay = (StunnFlyTime["650"]/1000) end
--~ 		if EnemyDistance > 674 and EnemyDistance < 725 then FlyTimeDelay = (StunnFlyTime["700"]/1000) end
--~ 		if EnemyDistance > 724 then FlyTimeDelay = 280/1000 end
--~ 		return FlyTimeDelay
--~ end

--~ ------------------------
--~ ----- Unused Funcs -----
--~ ------------------------
