--[[

	Shadow Vayne Script by Superx321

	For Functions & Changelog, check the Thread on the BoL Forums:
	http://botoflegends.com/forum/topic/18939-shadow-vayne-the-mighty-hunter/
	]]
if myHero.charName ~= 'Vayne' then return end
------------------------
------ LoadScript ------
------------------------
function OnTick()
	if not _G.ShadowVayneLoaded then
		if FileExist(LIB_PATH..'SxOrbWalk.lua') then
			require 'SxOrbWalk'
		else
			print('<font color=\'#F0Ff8d\'><b>ShadowVayne:</b></font> <font color=\'#FF0F0F\'>Failed to Load Module SxOrbWalk. Please Download it from the Forums.</font>')
			Error = true
		end

		if FileExist(LIB_PATH..'CustomPermaShow.lua') then
			require 'CustomPermaShow'
		else
			print('<font color=\'#F0Ff8d\'><b>ShadowVayne:</b></font> <font color=\'#FF0F0F\'>Failed to Load Module CustomPermaShow. Please Download it from the Forums.</font>')
			Error = true
		end

		if FileExist(LIB_PATH..'VPrediction.lua') then
			require 'VPrediction'
			VP = VPrediction()
		else
			print('<font color=\'#F0Ff8d\'><b>ShadowVayne:</b></font> <font color=\'#FF0F0F\'>Failed to Load Module VPrediction. Please Download it from the Forums.</font>')
			Error = true
		end

		if not Error then
			_G.ShadowVayneLoaded = true
			ShadowVayne()
		end
	end
end

------------------------
------ ShadowVayne -----
------------------------
class 'ShadowVayne'
function ShadowVayne:__init()
	self.SxInfo = {}
	self.SxInfo.version = 4.07
	self.SxInfo.LastLevelCheck = 0
	self.SxInfo.LastHeroLevel = 0
	self.SxInfo.LastTarget = nil
	self.SxInfo.CurSkin = 0
	self.SxInfo.Items = {}
	self.SxInfo.MapIndex = GetGame().map.index

	print('<font color=\'#F0Ff8d\'><b>ShadowVayne:</b></font> <font color=\'#FF0F0F\'>Version '..self.SxInfo.version..' loaded</font>')

	self.LuaSocket = require('socket')
	self.AutoUpdate = {['Host'] = 'raw.githubusercontent.com', ['VersionLink'] = '/Superx321/BoL/master/common/ShadowVayneRework.Version', ['ScriptLink'] = '/Superx321/BoL/master/ShadowVayneRework.lua'}
	self:CheckUpdate()

	self:GenerateTables()
	self:GetOrbWalkers()
end

function ShadowVayne:CheckUpdate()
	if not self.AutoUpdate['VersionSocket'] then
		self.AutoUpdate['VersionSocket'] = self.LuaSocket.connect('sx-bol.de', 80)
		self.AutoUpdate['VersionSocket']:send('GET /BoL/TCPUpdater/GetScript.php?script='..self.AutoUpdate['Host']..self.AutoUpdate['VersionLink']..'&rand='..tostring(math.random(1000))..' HTTP/1.0\r\n\r\n')
	end

	if not self.AutoUpdate['ServerVersion'] and self.AutoUpdate['VersionSocket'] then
			self.AutoUpdate['VersionSocket']:settimeout(0, 'b')
			self.AutoUpdate['VersionSocket']:settimeout(99999999, 't')
			self.AutoUpdate['VersionReceive'], self.AutoUpdate['VersionStatus'] = self.AutoUpdate['VersionSocket']:receive('*a')
	end

	if not self.AutoUpdate['ServerVersion'] and self.AutoUpdate['VersionSocket'] and self.AutoUpdate['VersionStatus'] ~= 'timeout' and self.AutoUpdate['VersionReceive'] ~= nil then
		self.AutoUpdate['ServerVersion'] = tonumber(string.sub(self.AutoUpdate['VersionReceive'], string.find(self.AutoUpdate['VersionReceive'], '<bols'..'cript>')+11, string.find(self.AutoUpdate['VersionReceive'], '</bols'..'cript>')-1))
	end

	if self.AutoUpdate['ServerVersion'] and type(self.AutoUpdate['ServerVersion']) == 'number' and self.AutoUpdate['ServerVersion'] > self.Version and not self.AutoUpdate['Finished'] then
		self.AutoUpdate['ScriptSocket'] = self.LuaSocket.connect('sx-bol.de', 80)
		self.AutoUpdate['ScriptSocket']:send('GET /BoL/TCPUpdater/GetScript.php?script='..self.AutoUpdate['Host']..self.AutoUpdate['ScriptLink']..'&rand='..tostring(math.random(1000))..' HTTP/1.0\r\n\r\n')
		self.AutoUpdate['ScriptReceive'], self.AutoUpdate['ScriptStatus'] = self.AutoUpdate['ScriptSocket']:receive('*a')
		self.AutoUpdate['ScriptRAW'] = string.sub(self.AutoUpdate['ScriptReceive'], string.find(self.AutoUpdate['ScriptReceive'], '<bols'..'cript>')+11, string.find(self.AutoUpdate['ScriptReceive'], '</bols'..'cript>')-1)
		ScriptFileOpen = io.open(SCRIPT_PATH.._ENV.FILE_NAME, 'w+')
		ScriptFileOpen:write(self.AutoUpdate['ScriptRAW'])
		ScriptFileOpen:close()
		self.AutoUpdate['Finished'] = true
		print('<font color=\'#F0Ff8d\'><b>ShadowVayne:</b></font> <font color=\'#FF0F0F\'>New Version('..self.AutoUpdate['ServerVersion']..') downloaded, load it with F9!</font>')
	end

	if not self.AutoUpdate['Finished'] then
		DelayAction(function() self:CheckUpdate() end)
	end
end

function ShadowVayne:GenerateTables()
	self.isAGapcloserUnitTarget = {
        ['AkaliShadowDance']		= {true, Champ = 'Akali', 		spellKey = 'R'},
        ['Headbutt']     			= {true, Champ = 'Alistar', 	spellKey = 'W'},
        ['DianaTeleport']       	= {true, Champ = 'Diana', 		spellKey = 'R'},
        ['IreliaGatotsu']     		= {true, Champ = 'Irelia',		spellKey = 'Q'},
        ['JaxLeapStrike']         	= {true, Champ = 'Jax', 		spellKey = 'Q'},
        ['JayceToTheSkies']       	= {true, Champ = 'Jayce',		spellKey = 'Q'},
        ['MaokaiUnstableGrowth']    = {true, Champ = 'Maokai',		spellKey = 'W'},
        ['MonkeyKingNimbus']  		= {true, Champ = 'MonkeyKing',	spellKey = 'E'},
        ['Pantheon_LeapBash']   	= {true, Champ = 'Pantheon',	spellKey = 'W'},
        ['PoppyHeroicCharge']       = {true, Champ = 'Poppy',		spellKey = 'E'},
		['QuinnE']       			= {true, Champ = 'Quinn',		spellKey = 'E'},
        ['XenZhaoSweep']     		= {true, Champ = 'XinZhao',		spellKey = 'E'},
        ['blindmonkqtwo']	    	= {true, Champ = 'LeeSin',		spellKey = 'Q'},
        ['FizzPiercingStrike']	    = {true, Champ = 'Fizz',		spellKey = 'Q'},
        ['RengarLeap']	    		= {true, Champ = 'Rengar',		spellKey = 'Q/R'},
    }

	self.isAGapcloserUnitNoTarget = {
		['AatroxQ']					= {true, Champ = 'Aatrox', 		range = 1000,  	projSpeed = 1200, spellKey = 'Q'},
		['GragasE']					= {true, Champ = 'Gragas', 		range = 600,   	projSpeed = 2000, spellKey = 'E'},
		['GravesMove']				= {true, Champ = 'Graves', 		range = 425,   	projSpeed = 2000, spellKey = 'E'},
		['HecarimUlt']				= {true, Champ = 'Hecarim', 	range = 1000,   projSpeed = 1200, spellKey = 'R'},
		['JarvanIVDragonStrike']	= {true, Champ = 'JarvanIV',	range = 770,   	projSpeed = 2000, spellKey = 'Q'},
		['JarvanIVCataclysm']		= {true, Champ = 'JarvanIV', 	range = 650,   	projSpeed = 2000, spellKey = 'R'},
		['KhazixE']					= {true, Champ = 'Khazix', 		range = 900,   	projSpeed = 2000, spellKey = 'E'},
		['khazixelong']				= {true, Champ = 'Khazix', 		range = 900,   	projSpeed = 2000, spellKey = 'E'},
		['LeblancSlide']			= {true, Champ = 'Leblanc', 	range = 600,   	projSpeed = 2000, spellKey = 'W'},
		['LeblancSlideM']			= {true, Champ = 'Leblanc', 	range = 600,   	projSpeed = 2000, spellKey = 'WMimic'},
		['LeonaZenithBlade']		= {true, Champ = 'Leona', 		range = 900,  	projSpeed = 2000, spellKey = 'E'},
		['UFSlash']					= {true, Champ = 'Malphite', 	range = 1000,  	projSpeed = 1800, spellKey = 'R'},
		['RenektonSliceAndDice']	= {true, Champ = 'Renekton', 	range = 450,  	projSpeed = 2000, spellKey = 'E'},
		['SejuaniArcticAssault']	= {true, Champ = 'Sejuani', 	range = 650,  	projSpeed = 2000, spellKey = 'Q'},
		['ShenShadowDash']			= {true, Champ = 'Shen', 		range = 575,  	projSpeed = 2000, spellKey = 'E'},
		['RocketJump']				= {true, Champ = 'Tristana', 	range = 900,  	projSpeed = 2000, spellKey = 'W'},
		['slashCast']				= {true, Champ = 'Tryndamere', 	range = 650,  	projSpeed = 1450, spellKey = 'E'},
	}

	self.isAChampToInterrupt = {
                ['KatarinaR']					= {true, Champ = 'Katarina',	spellKey = 'R'},
                ['GalioIdolOfDurand']			= {true, Champ = 'Galio',		spellKey = 'R'},
                ['Crowstorm']					= {true, Champ = 'FiddleSticks',spellKey = 'R'},
                ['Drain']						= {true, Champ = 'FiddleSticks',spellKey = 'W'},
                ['AbsoluteZero']				= {true, Champ = 'Nunu',		spellKey = 'R'},
                ['ShenStandUnited']				= {true, Champ = 'Shen',		spellKey = 'R'},
                ['UrgotSwap2']					= {true, Champ = 'Urgot',		spellKey = 'R'},
                ['AlZaharNetherGrasp']			= {true, Champ = 'Malzahar',	spellKey = 'R'},
                ['FallenOne']					= {true, Champ = 'Karthus',		spellKey = 'R'},
                ['Pantheon_GrandSkyfall_Jump']	= {true, Champ = 'Pantheon',	spellKey = 'R'},
                ['VarusQ']						= {true, Champ = 'Varus',		spellKey = 'Q'},
                ['CaitlynAceintheHole']			= {true, Champ = 'Caitlyn',		spellKey = 'R'},
                ['MissFortuneBulletTime']		= {true, Champ = 'MissFortune',	spellKey = 'R'},
                ['InfiniteDuress']				= {true, Champ = 'Warwick',		spellKey = 'R'},
                ['LucianR']						= {true, Champ = 'Lucian',		spellKey = 'R'}
	}

	self.AutoLevelSpellTable = {
                ['SpellOrder']	= {'QWE', 'QEW', 'WQE', 'WEQ', 'EQW', 'EWQ'},
                ['QWE']	= {_Q,_W,_E,_Q,_Q,_R,_Q,_W,_Q,_W,_R,_W,_W,_E,_E,_R,_E,_E},
                ['QEW']	= {_Q,_E,_W,_Q,_Q,_R,_Q,_E,_Q,_E,_R,_E,_E,_W,_W,_R,_W,_W},
                ['WQE']	= {_W,_Q,_E,_W,_W,_R,_W,_Q,_W,_Q,_R,_Q,_Q,_E,_E,_R,_E,_E},
                ['WEQ']	= {_W,_E,_Q,_W,_W,_R,_W,_E,_W,_E,_R,_E,_E,_Q,_Q,_R,_Q,_Q},
                ['EQW']	= {_E,_Q,_W,_E,_E,_R,_E,_Q,_E,_Q,_R,_Q,_Q,_W,_W,_R,_W,_W},
                ['EWQ']	= {_E,_W,_Q,_E,_E,_R,_E,_W,_E,_W,_R,_W,_W,_Q,_Q,_R,_Q,_Q}
	}

	self.TumbleSpots = {
		['Drake'] = {
			['Name']	= 'Drake',
			['Circle'] 	= { ['x'] = 11590.95, ['y'] = 52, ['z'] = 4656.26 },
			['Stand']	= { ['x'] = 11590.95, ['y'] = 4656.26},
			['Cast']  	= { ['x'] = 11334.74, ['y'] = 4517.47 },
		},
		['Midlane'] = {
			['Name']	= 'Midlane',
			['Circle'] 	= { ['x'] = 6623, ['y'] = 56, ['z'] = 8649 },
			['Stand'] 	= { ['x'] = 6623.00, ['y'] = 8649.00 },
			['Cast'] 	= { ['x'] = 6010.5869140625, ['y'] = 8508.8740234375 },
		},
	}
end

function ShadowVayne:GetOrbWalkers()
	self.SxInfo.OrbWalkers = {}
	table.insert(self.SxInfo.OrbWalkers, 'SxOrb')

	if _G.MMA_Loaded then
		table.insert(self.SxInfo.OrbWalkers, 'MMA')
	end

	if _G.Reborn_Loaded then
		table.insert(self.SxInfo.OrbWalkers, 'Reborn R84')
		print('<font color=\'#F0Ff8d\'><b>ShadowVayne:</b></font> <font color=\'#FF0F0F\'>Waiting for SAC:R84 Auth</font>')
		DelayAction(function() self:WaitForReborn() end)
	else
		self:LoadMenu()
	end
end

function ShadowVayne:WaitForReborn()
	if _G.AutoCarry and _G.AutoCarry.Helper then
		_, SACKeys = _G.AutoCarry.Helper:GetClasses()
		self:LoadMenu()
	else
		DelayAction(function() self:WaitForReborn() end)
	end
end

function ShadowVayne:LoadMenu()
	SVMainMenu = scriptConfig('ShadowVayne', 'SV_MAIN')
	SVMainMenu:addSubMenu('[Condemn]: AntiGapCloser Settings', 'anticapcloser')
	SVMainMenu:addSubMenu('[Condemn]: AutoStun Settings', 'autostunn')
	SVMainMenu:addSubMenu('[Condemn]: AutoStun Targets', 'targets')
	SVMainMenu:addSubMenu('[Condemn]: Interrupt Settings', 'interrupt')
	SVMainMenu:addSubMenu('[Tumble]: Settings', 'tumble')
	SVMainMenu:addSubMenu('[Misc]: Key Settings', 'keysetting')
	SVMainMenu:addSubMenu('[Misc]: Toggle Settings', 'toggle')
	SVMainMenu:addSubMenu('[Misc]: AutoLevelSpells Settings', 'autolevel')
	SVMainMenu:addSubMenu('[Misc]: Draw Settings', 'draw')
	SVMainMenu:addSubMenu('[Misc]: PermaShow Settings', 'permashow')
	SVMainMenu:addSubMenu('[Misc]: WallTumble Settings', 'walltumble')
	if VIP_USER then
		SVMainMenu:addSubMenu('[Misc]: SkinHack', 'skinhack')
	end
	SVMainMenu:addSubMenu('[BotRK]: Settings', 'botrk')
	SVMainMenu:addSubMenu('[Bilgewater]: Settings', 'bilgewater')
	SVMainMenu:addSubMenu('[Youmuu\'s]: Settings', 'youmuus')

	-- KeySetting Menu
	SVMainMenu.keysetting:addParam('nil','Basic Key Settings', SCRIPT_PARAM_INFO, '')
	SVMainMenu.keysetting:addParam('AfterAACondemn','Condemn on next BasicAttack:', SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte( 'E' ))
	SVMainMenu.keysetting:addParam('ThreshLantern','Grab the Thresh lantern: ', SCRIPT_PARAM_ONKEYDOWN, false, string.byte( 'T' ))
	SVMainMenu.keysetting:addParam('WallTumble','Tumble over the Wall: ', SCRIPT_PARAM_ONKEYDOWN, false, VIP_USER and string.byte( 'Q' ) or string.byte( 'W' ))
	SVMainMenu.keysetting:addParam('nil','', SCRIPT_PARAM_INFO, '')
	SVMainMenu.keysetting:addParam('nil','General Key Settings', SCRIPT_PARAM_INFO, '')
--~ 	SVMainMenu.keysetting:addParam('togglemode','ToggleMode:', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam('FightMode','FightMode Key:', SCRIPT_PARAM_ONKEYDOWN, false, 32)
	SVMainMenu.keysetting:addParam('HarassMode','HarassMode Key:', SCRIPT_PARAM_ONKEYDOWN, false, string.byte( 'C' ))
	SVMainMenu.keysetting:addParam('LaneClear','LaneClear Mode Key:', SCRIPT_PARAM_ONKEYDOWN, false, string.byte( 'M' ))
	SVMainMenu.keysetting:addParam('LastHit','LastHit Mode Key:', SCRIPT_PARAM_ONKEYDOWN, false, string.byte( 'N' ))
	SVMainMenu.keysetting:addParam('nil','', SCRIPT_PARAM_INFO, '')
	SVMainMenu.keysetting:addParam('FightModeOrb', 'Orbwalker in FightMode: ', SCRIPT_PARAM_LIST, 1, self.SxInfo.OrbWalkers)
	SVMainMenu.keysetting:addParam('HarassModeOrb', 'Orbwalker in HarassMode: ', SCRIPT_PARAM_LIST, 1, self.SxInfo.OrbWalkers)
	SVMainMenu.keysetting:addParam('LaneClearOrb', 'Orbwalker in LaneClear: ', SCRIPT_PARAM_LIST, 1, self.SxInfo.OrbWalkers)
	SVMainMenu.keysetting:addParam('LastHitOrb', 'Orbwalker in LastHit: ', SCRIPT_PARAM_LIST, 1, self.SxInfo.OrbWalkers)

	-- SAC Reborn R84
	SVMainMenu.keysetting:addParam('SACAutoCarry','Hidden SAC R84 Param', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam('SACMixedMode','Hidden SAC R84 Param', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam('SACLaneClear','Hidden SAC R84 Param', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.keysetting:addParam('SACLastHit','Hidden SAC R84 Param', SCRIPT_PARAM_ONOFF, false)
	if _G.Reborn_Loaded and SACKeys then
		SACKeys:RegisterMenuKey(SVMainMenu.keysetting, 'SACAutoCarry', AutoCarry.MODE_AUTOCARRY)
		SACKeys:RegisterMenuKey(SVMainMenu.keysetting, 'SACMixedMode', AutoCarry.MODE_MIXEDMODE)
		SACKeys:RegisterMenuKey(SVMainMenu.keysetting, 'SACLaneClear', AutoCarry.MODE_LANECLEAR)
		SACKeys:RegisterMenuKey(SVMainMenu.keysetting, 'SACLastHit', AutoCarry.MODE_LASTHIT)
	end

	for index, param in pairs(SVMainMenu.keysetting._param) do
		if param['var'] == 'FightMode' then
			StartKeyParam = index
		end
		if param['var'] == 'FightModeOrb' then
			StartListParam = index
		end
	end
	if SVMainMenu.keysetting._param[StartListParam].listTable[SVMainMenu.keysetting.FightModeOrb] == nil then SVMainMenu.keysetting.FightModeOrb = 1 end
	if SVMainMenu.keysetting._param[StartListParam+1].listTable[SVMainMenu.keysetting.HarassModeOrb] == nil then SVMainMenu.keysetting.HarassModeOrb = 1 end
	if SVMainMenu.keysetting._param[StartListParam+2].listTable[SVMainMenu.keysetting.LaneClearOrb] == nil then SVMainMenu.keysetting.LaneClearOrb = 1 end
	if SVMainMenu.keysetting._param[StartListParam+3].listTable[SVMainMenu.keysetting.LastHitOrb] == nil then SVMainMenu.keysetting.LastHitOrb = 1 end

	-- GapCloser
	local FoundAGapCloser = false
	for index, data in pairs(self.isAGapcloserUnitTarget) do
		for index2, enemy in ipairs(GetEnemyHeroes()) do
			if data['Champ'] == enemy.charName then
				SVMainMenu.anticapcloser:addSubMenu(enemy.charName..' '..data.spellKey, enemy.charName)
				SVMainMenu.anticapcloser[enemy.charName]:addParam('fap', 'Pushback '..enemy.charName..' '..data.spellKey..'...', SCRIPT_PARAM_INFO, '')
				SVMainMenu.anticapcloser[enemy.charName]:addParam('FightMode', 'in FightMode', SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.anticapcloser[enemy.charName]:addParam('HarassMode', 'in HarassMode', SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.anticapcloser[enemy.charName]:addParam('LaneClear', 'in LaneClear', SCRIPT_PARAM_ONOFF, false)
				SVMainMenu.anticapcloser[enemy.charName]:addParam('LastHit', 'in LastHit', SCRIPT_PARAM_ONOFF, false)
				SVMainMenu.anticapcloser[enemy.charName]:addParam('Always', 'Always', SCRIPT_PARAM_ONOFF, false)
				FoundAGapCloser = true
			end
		end
	end
	for index, data in pairs(self.isAGapcloserUnitNoTarget) do
		for index2, enemy in ipairs(GetEnemyHeroes()) do
			if data['Champ'] == enemy.charName then
				SVMainMenu.anticapcloser:addSubMenu(enemy.charName..' '..data.spellKey, enemy.charName)
				SVMainMenu.anticapcloser[enemy.charName]:addParam('fap', 'Pushback '..enemy.charName..' '..data.spellKey..'...', SCRIPT_PARAM_INFO, '')
				SVMainMenu.anticapcloser[enemy.charName]:addParam('FightMode', 'in FightMode', SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.anticapcloser[enemy.charName]:addParam('HarassMode', 'in HarassMode', SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.anticapcloser[enemy.charName]:addParam('LaneClear', 'in LaneClear', SCRIPT_PARAM_ONOFF, false)
				SVMainMenu.anticapcloser[enemy.charName]:addParam('LastHit', 'in LastHit', SCRIPT_PARAM_ONOFF, false)
				SVMainMenu.anticapcloser[enemy.charName]:addParam('Always', 'Always', SCRIPT_PARAM_ONOFF, false)
				FoundAGapCloser = true
			end
		end
	end
	if not FoundAGapCloser then SVMainMenu.anticapcloser:addParam('nil','No Enemy Gapclosers found', SCRIPT_PARAM_INFO, '') end

	-- StunTargets
	local FoundStunTarget = false
	for index, enemy in ipairs(GetEnemyHeroes()) do
		SVMainMenu.targets:addSubMenu(enemy.charName, enemy.charName)
		SVMainMenu.targets[enemy.charName]:addParam('fap', 'Stun '..enemy.charName..'...', SCRIPT_PARAM_INFO, '')
		SVMainMenu.targets[enemy.charName]:addParam('FightMode', 'in FightMode', SCRIPT_PARAM_ONOFF, true)
		SVMainMenu.targets[enemy.charName]:addParam('HarassMode', 'in HarassMode', SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.targets[enemy.charName]:addParam('LaneClear', 'in LaneClear', SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.targets[enemy.charName]:addParam('LastHit', 'in LastHit', SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.targets[enemy.charName]:addParam('Always', 'Always', SCRIPT_PARAM_ONOFF, false)
		FoundStunTarget = true
	end
	if not FoundStunTarget then SVMainMenu.targets:addParam('nil','No Enemies to Stun found', SCRIPT_PARAM_INFO, '') end

	-- Interrupt
	local Foundinterrupt = false
	for index, data in pairs(self.isAChampToInterrupt) do
		for index, enemy in ipairs(GetEnemyHeroes()) do
			if data['Champ'] == enemy.charName then
				SVMainMenu.interrupt:addSubMenu(enemy.charName..' '..data.spellKey..'...', enemy.charName)
				SVMainMenu.interrupt[enemy.charName]:addParam('fap', 'Interrupt '..enemy.charName..' '..data.spellKey, SCRIPT_PARAM_INFO, '')
				SVMainMenu.interrupt[enemy.charName]:addParam('FightMode', 'in FightMode', SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[enemy.charName]:addParam('HarassMode', 'in HarassMode', SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[enemy.charName]:addParam('LaneClear', 'in LaneClear', SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[enemy.charName]:addParam('LastHit', 'in LastHit', SCRIPT_PARAM_ONOFF, true)
				SVMainMenu.interrupt[enemy.charName]:addParam('Always', 'Always', SCRIPT_PARAM_ONOFF, true)
				Foundinterrupt = true
			end
		end
	end
	if not Foundinterrupt then SVMainMenu.interrupt:addParam('nil','No Enemies to Interrupt found', SCRIPT_PARAM_INFO, '') end

	-- StunSettings
	SVMainMenu.autostunn:addParam('PushDistance', 'Push Distance', SCRIPT_PARAM_SLICE, 390, 0, 450, 0)
	SVMainMenu.autostunn:addParam('TowerStun', 'Stun if Enemy lands unter a Tower', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.autostunn:addParam('Trinket', 'Use Auto-Trinket Bush', SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.autostunn:addParam('Target', 'Stun only Current Target', SCRIPT_PARAM_ONOFF, true)

	-- Draw
	SVMainMenu.draw:addParam('AARange', 'Draw Basicattack Range', SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.draw:addParam('AAColor', 'Basicattack Range Color', SCRIPT_PARAM_COLOR, {141, 124, 4, 4})
	SVMainMenu.draw:addParam('ERange', 'Draw E Range', SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.draw:addParam('EColor', 'E Range Color', SCRIPT_PARAM_COLOR, {141, 124, 4, 4})

	-- AutoLevel
	SVMainMenu.autolevel:addParam('UseAutoLevelFirst', 'Use AutoLevelSpells Level 1-3', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.autolevel:addParam('UseAutoLevelRest', 'Use AutoLevelSpells Level 4-18', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.autolevel:addParam('First3Level', 'Level 1-3:', SCRIPT_PARAM_LIST, 1, { 'Q-W-E', 'Q-E-W', 'W-Q-E', 'W-E-Q', 'E-Q-W', 'E-W-Q' })
	SVMainMenu.autolevel:addParam('RestLevel', 'Level 4-18:', SCRIPT_PARAM_LIST, 1, { 'Q-W-E', 'Q-E-W', 'W-Q-E', 'W-E-Q', 'E-Q-W', 'E-W-Q' })
	SVMainMenu.autolevel:addParam('fap', '', SCRIPT_PARAM_INFO, '','' )
	SVMainMenu.autolevel:addParam('fap', 'You can Click on the \'Q-W-E\'', SCRIPT_PARAM_INFO, '','' )
	SVMainMenu.autolevel:addParam('fap', 'to change the AutoLevelOrder', SCRIPT_PARAM_INFO, '','' )

	-- PermaShow
	SVMainMenu.permashow:addParam('AfterAACondemn', 'PermaShow \'E on Next BasicAttack\'', SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.permashow:addParam('FightMode', 'PermaShow: FightMode', SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.permashow:addParam('HarassMode', 'PermaShow: HarassMode', SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.permashow:addParam('LaneClear', 'PermaShow: LaneClear', SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.permashow:addParam('LastHit', 'PermaShow: LastHit', SCRIPT_PARAM_ONOFF, true)

	-- BotRK
	SVMainMenu.botrk:addParam('FightMode', 'Use BotRK in FightMode', SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.botrk:addParam('HarassMode', 'Use BotRK in HarassMode', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.botrk:addParam('LaneClear', 'Use BotRK in LaneClear', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.botrk:addParam('LastHit', 'Use BotRK in LastHit', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.botrk:addParam('Always', 'Use BotRK Always', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.botrk:addParam('MaxOwnHealth', 'Max Own Health Percent', SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
	SVMainMenu.botrk:addParam('MinEnemyHealth', 'Min Enemy Health Percent', SCRIPT_PARAM_SLICE, 20, 1, 100, 0)

	-- Bilgewater
	SVMainMenu.bilgewater:addParam('FightMode', 'Use BilgeWater Cutlass in FightMode', SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.bilgewater:addParam('HarassMode', 'Use BilgeWater Cutlass in HarassMode', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.bilgewater:addParam('LaneClear', 'Use BilgeWater Cutlass in LaneClear', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.bilgewater:addParam('LastHit', 'Use BilgeWater Cutlass in LastHit', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.bilgewater:addParam('Always', 'Use BilgeWater Cutlass Always', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.bilgewater:addParam('MaxOwnHealth', 'Max Own Health Percent', SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
	SVMainMenu.bilgewater:addParam('MinEnemyHealth', 'Min Enemy Health Percent', SCRIPT_PARAM_SLICE, 20, 1, 100, 0)

	-- Yomuus
	SVMainMenu.youmuus:addParam('FightMode', 'Use Youmuus Ghostblade in FightMode', SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.youmuus:addParam('HarassMode', 'Use Youmuus Ghostblade in HarassMode', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.youmuus:addParam('LaneClear', 'Use Youmuus Ghostblade in LaneClear', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.youmuus:addParam('LastHit', 'Use Youmuus Ghostblade in LastHit', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.youmuus:addParam('Always', 'Use Youmuus Ghostblade Always', SCRIPT_PARAM_ONOFF, false)

	-- Tumble
	SVMainMenu.tumble:addParam('FightMode', 'Use Tumble in FightMode', SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.tumble:addParam('HarassMode', 'Use Tumble in HarassMode', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.tumble:addParam('LaneClear', 'Use Tumble in LaneClear', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.tumble:addParam('LastHit', 'Use Tumble in LastHit', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.tumble:addParam('Always', 'Use Tumble Always', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.tumble:addParam('fap', '', SCRIPT_PARAM_INFO, '','' )
	SVMainMenu.tumble:addParam('ManaFightMode', 'Min Mana to use Q in FightMode', SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
	SVMainMenu.tumble:addParam('ManaHarassMode', 'Min Mana to use Q in HarassMode', SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
	SVMainMenu.tumble:addParam('ManaLaneClear', 'Min Mana to use Q in LaneClear', SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
	SVMainMenu.tumble:addParam('ManaLastHit', 'Min Mana to use Q in LastHit', SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

	-- WallTumble
	SVMainMenu.walltumble:addParam('Drake', 'Draw & Use Spot 1 (Drake-Spot)', SCRIPT_PARAM_ONOFF, true)
	SVMainMenu.walltumble:addParam('Midlane', 'Draw & Use Spot 2 (Midlane-Spot)', SCRIPT_PARAM_ONOFF, true)

	-- Toggle
	SVMainMenu.toggle:addParam('FightMode', 'Make FightMode a Toggle', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.toggle:addParam('HarassMode', 'Make HarassMode a Toggle', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.toggle:addParam('LaneClear', 'Make LaneClear a Toggle', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.toggle:addParam('LastHit', 'Make LastHit a Toggle', SCRIPT_PARAM_ONOFF, false)
	SVMainMenu.toggle:addParam('RightClick', 'Disable Toggle on RightClick', SCRIPT_PARAM_ONOFF, false)

	if VIP_USER then
		-- SkinHack
		SVMainMenu.skinhack:addParam('Enabled', 'Enable Skinhack', SCRIPT_PARAM_ONOFF, false)
		SVMainMenu.skinhack:addParam('SkinId', 'Choose the Skin: ', SCRIPT_PARAM_LIST, 1, { 'No Skin', 'Vindicator', 'Aristocrat', 'Dragonslayer', 'Hearthseeker', 'SKT T1' })
	end

	self:MenuLoaded()
end

function ShadowVayne:MenuLoaded()
	SxOrb:LoadToMenu(nil, true)
	self:CheckLevelChange()
	self:HideOtherPermaShow()
	self:CheckItems()
	self:SwitchToggleMode()

	AddMsgCallback(function(msg,key) self:DoubleModeProtection(msg, key) end)

	AddTickCallback(function() self:ActivateModes() end)
	AddTickCallback(function() self:BotRK() end)
	AddTickCallback(function() self:BilgeWater() end)
	AddTickCallback(function() self:WallTumble() end)
	AddTickCallback(function() self:CondemnStun() end)

	AddCreateObjCallback(function(Obj) self:RengarObject(Obj) end)

	AddDrawCallback(function() self:PermaShows() end)
	AddDrawCallback(function() self:OnDraw() end)

	AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
	-- VIP Callbacks
	if VIP_USER then
		AddCreateObjCallback(function(Obj) self:ThreshObject(Obj) end)
		AddSendPacketCallback(function(p) self:OnSendPacket(p) end)
		self:SkinHack()
	end

end

function ShadowVayne:HideOtherPermaShow()
	_G.HidePermaShow['LaneClear OnHold:'] = true
	_G.HidePermaShow['Orbwalk OnHold:'] = true
	_G.HidePermaShow['LastHit OnHold:'] = true
	_G.HidePermaShow['HybridMode OnHold:'] = true
	_G.HidePermaShow['Condemn on next BasicAttack:'] = true
	_G.HidePermaShow['              Sida\'s Auto Carry: Reborn'] = true
	_G.HidePermaShow['Auto Carry'] = true
	_G.HidePermaShow['Last Hit'] = true
	_G.HidePermaShow['Mixed Mode'] = true
	_G.HidePermaShow['Lane Clear'] = true
	_G.HidePermaShow['Auto-Condemn'] = true
	_G.HidePermaShow['No mode active'] = true
	_G.HidePermaShow['ShadowVayne found. Set the Keysettings there!'] = true
end

function ShadowVayne:DoubleModeProtection(msg, key)
	if key == 2 and SVMainMenu.toggle['RightClick'] and self:CheckModesActive(SVMainMenu.toggle) then
		  SVMainMenu.keysetting.FightMode,SVMainMenu.keysetting.HarassMode,SVMainMenu.keysetting.LaneClear,SVMainMenu.keysetting.LastHit = false,false,false,false
	end

	if key == SVMainMenu.keysetting._param[StartKeyParam].key then -- FightMode
		  SVMainMenu.keysetting.HarassMode,SVMainMenu.keysetting.LaneClear,SVMainMenu.keysetting.LastHit = false,false,false
	end

	if key == SVMainMenu.keysetting._param[StartKeyParam+1].key then -- HarassMode
		  SVMainMenu.keysetting.FightMode,SVMainMenu.keysetting.LaneClear,SVMainMenu.keysetting.LastHit = false,false,false
	end

	if key == SVMainMenu.keysetting._param[StartKeyParam+2].key then -- LaneClear
		  SVMainMenu.keysetting.FightMode,SVMainMenu.keysetting.HarassMode,SVMainMenu.keysetting.LastHit = false,false,false
	end

	if key == SVMainMenu.keysetting._param[StartKeyParam+3].key then -- LastHit
		  SVMainMenu.keysetting.FightMode,SVMainMenu.keysetting.HarassMode,SVMainMenu.keysetting.LaneClear = false,false,false
	end
end

function ShadowVayne:ActivateModes()
	-- Get the Keysettings from SVMainMenu
	ShadowVayneFightMode = SVMainMenu.keysetting.FightMode
	ShadowVayneHarassMode = SVMainMenu.keysetting.HarassMode
	ShadowVayneLaneClear = SVMainMenu.keysetting.LaneClear
	ShadowVayneLastHit = SVMainMenu.keysetting.LastHit

	-- Get The Selected Orbwalker
	FightModeOrbText = SVMainMenu.keysetting._param[StartListParam].listTable[SVMainMenu.keysetting.FightModeOrb]
	HarassModeOrbText = SVMainMenu.keysetting._param[StartListParam+1].listTable[SVMainMenu.keysetting.HarassModeOrb]
	LaneClearOrbText = SVMainMenu.keysetting._param[StartListParam+2].listTable[SVMainMenu.keysetting.LaneClearOrb]
	LastHitOrbText = SVMainMenu.keysetting._param[StartListParam+3].listTable[SVMainMenu.keysetting.LastHitOrb]

	-- Activate MMA
	if FightModeOrbText == 'MMA' then _G.MMA_Orbwalker = ShadowVayneFightMode end
	if HarassModeOrbText == 'MMA' then _G.MMA_HybridMode = ShadowVayneHarassMode end
	if LaneClearOrbText == 'MMA' then _G.MMA_LaneClear = ShadowVayneLaneClear end
	if LastHitOrbText == 'MMA' then _G.MMA_LastHit = ShadowVayneLastHit end

	-- Activate SAC:Reborn R84
	if FightModeOrbText == 'Reborn R84' then SVMainMenu.keysetting.SACAutoCarry = ShadowVayneFightMode end
	if HarassModeOrbText == 'Reborn R84' then SVMainMenu.keysetting.SACMixedMode = ShadowVayneHarassMode end
	if LaneClearOrbText == 'Reborn R84' then SVMainMenu.keysetting.SACLaneClear = ShadowVayneLaneClear end
	if LastHitOrbText   == 'Reborn R84' then SVMainMenu.keysetting.SACLastHit = ShadowVayneLastHit end

	-- Activate SxOrbWalker
	if FightModeOrbText == 'SxOrb' then _G.SxOrbMenu.Mode.Fight = ShadowVayneFightMode end
	if HarassModeOrbText == 'SxOrb' then _G.SxOrbMenu.Mode.Harass = ShadowVayneHarassMode end
	if LaneClearOrbText == 'SxOrb' then _G.SxOrbMenu.Mode.LaneClear = ShadowVayneLaneClear end
	if LastHitOrbText   == 'SxOrb' then _G.SxOrbMenu.Mode.LastHit = ShadowVayneLastHit end
end

function ShadowVayne:CheckModesActive(Menu)
	if Menu['FightMode'] and SVMainMenu.keysetting.FightMode then
		return true
	elseif Menu['HarassMode'] and SVMainMenu.keysetting.HarassMode then
		return true
	elseif Menu['LaneClear'] and SVMainMenu.keysetting.LaneClear then
		return true
	elseif Menu['LastHit'] and SVMainMenu.keysetting.LastHit then
		return true
	elseif Menu['Always'] then
		return true
	else
		return false
	end
end

function ShadowVayne:CheckLevelChange()
	if self.SxInfo.MapIndex == 8 and myHero.level < 4 and SVMainMenu.autolevel.UseAutoLevelFirst then
		LevelSpell(_Q)
		LevelSpell(_W)
		LevelSpell(_E)
	end
	if self.SxInfo.LastLevelCheck + 100 < GetTickCount() then
		self.SxInfo.LastLevelCheck = GetTickCount()
		if myHero.level ~= self.SxInfo.LastHeroLevel then
			DelayAction(function() self:LevelUpSpell() end, 0.25)
			self.SxInfo.LastHeroLevel = myHero.level
		end
	end
	DelayAction(function() self:CheckLevelChange() end,0.25)
end

function ShadowVayne:LevelUpSpell()
	if SVMainMenu.autolevel.UseAutoLevelFirst and myHero.level < 4 then
		LevelSpell(self.AutoLevelSpellTable[self.AutoLevelSpellTable['SpellOrder'][SVMainMenu.autolevel.First3Level]][myHero.level])
	end

	if SVMainMenu.autolevel.UseAutoLevelRest and myHero.level > 3 then
		LevelSpell(self.AutoLevelSpellTable[self.AutoLevelSpellTable['SpellOrder'][SVMainMenu.autolevel.RestLevel]][myHero.level])
	end
end

function ShadowVayne:SkinHack()
	if SVMainMenu.skinhack.Enabled and self.SxInfo.CurSkin ~= SVMainMenu.skinhack.SkinId then
		local SkinIdSwap = { [1] = 6, [2] = 1, [3] = 2, [4] = 3, [5] = 4, [6] = 5 }
		self.SxInfo.CurSkin = SVMainMenu.skinhack.SkinId
		ShadowVayne:SkinChanger(myHero.charName, SkinIdSwap[self.SxInfo.CurSkin])
	end
	DelayAction(function() self:SkinHack() end, 0.5)
end

function ShadowVayne:PermaShows()
	CustomPermaShow('FightMode (Using '..FightModeOrbText..')', SVMainMenu.keysetting.FightMode, SVMainMenu.permashow.FightMode, nil, 1426521024, nil, 1)
	CustomPermaShow('HarassMode (Using '..HarassModeOrbText..')', SVMainMenu.keysetting.HarassMode, SVMainMenu.permashow.HarassMode, nil, 1426521024, nil, 2)
	CustomPermaShow('LaneClear (Using '..LaneClearOrbText..')', SVMainMenu.keysetting.LaneClear, SVMainMenu.permashow.LaneClear, nil, 1426521024, nil, 3)
	CustomPermaShow('LastHit (Using '..LastHitOrbText..')', SVMainMenu.keysetting.LastHit, SVMainMenu.permashow.LastHit, nil, 1426521024, nil, 4)
	CustomPermaShow('Auto-E after next BasicAttack', SVMainMenu.keysetting.AfterAACondemn, SVMainMenu.permashow.AfterAACondemn, nil, 1426521024, nil,  5)
end

function ShadowVayne:CheckItems()
	self.SxInfo.Items.BotRK = GetInventorySlotItem(3153)
	self.SxInfo.Items.BilgeWater = GetInventorySlotItem(3144)
	self.SxInfo.Items.Youmuus = GetInventorySlotItem(3142)
	DelayAction(function() self:CheckItems() end, 1)
end

function ShadowVayne:BotRK()
	if self.SxInfo.Items.BotRK and self:CheckModesActive(SVMainMenu.botrk) then
		if (math.floor(myHero.health / myHero.maxHealth * 100)) <= SVMainMenu.botrk.MaxOwnHealth then
			local Target = self:GetTarget()
			if Target and ValidTarget(Target, 510) then
				if (math.floor(Target.health / Target.maxHealth * 100)) >= SVMainMenu.botrk.MinEnemyHealth then
					if myHero:CanUseSpell(self.SxInfo.Items.BotRK) == 0 then
						CastSpell(self.SxInfo.Items.BotRK, Target)
					end
				end
			end
		end
	end
end

function ShadowVayne:BilgeWater()
	if self.SxInfo.Items.BilgeWater and self:CheckModesActive(SVMainMenu.bilgewater) then
		if (math.floor(myHero.health / myHero.maxHealth * 100)) <= SVMainMenu.bilgewater.MaxOwnHealth then
			local Target = self:GetTarget()
			if Target and ValidTarget(Target, 450) then
				if (math.floor(Target.health / Target.maxHealth * 100)) >= SVMainMenu.bilgewater.MinEnemyHealth then
					if myHero:CanUseSpell(self.SxInfo.Items.BilgeWater) == 0 then
						CastSpell(self.SxInfo.Items.BilgeWater, Target)
					end
				end
			end
		end
	end
end

function ShadowVayne:Youmuus()
	if self.SxInfo.Items.Youmuus and self:CheckModesActive(SVMainMenu.youmuus) then
		if myHero:CanUseSpell(self.SxInfo.Items.Youmuus) == 0 then
			CastSpell(self.SxInfo.Items.Youmuus)
		end
	end
end

function ShadowVayne:OnProcessSpell(unit, spell)
	if unit.team ~= myHero.team then
		if self.isAGapcloserUnitTarget[spell.name] then
			if spell.target and spell.target.networkID == myHero.networkID then
				if self:CheckModesActive(SVMainMenu.anticapcloser[unit.charName]) then CastSpell(_E, unit) end
			end
		end

		if self.isAChampToInterrupt[spell.name] and GetDistanceSqr(unit) <= 715*715 then
			if self:CheckModesActive(SVMainMenu.interrupt[unit.charName]) then CastSpell(_E, unit) end
		end

		if self.isAGapcloserUnitNoTarget[spell.name] and GetDistanceSqr(unit) <= 2000*2000 and (spell.target == nil or spell.target.isMe) then
			if self:CheckModesActive(SVMainMenu.anticapcloser[unit.charName]) then
				SpellInfo = {
					Source = unit,
					CastTime = os.clock(),
					StartPos = Point(spell.startPos.x, spell.startPos.z),
					EndPos = Point(spell.endPos.x, spell.endPos.z),
					Range = self.isAGapcloserUnitNoTarget[spell.name].range,
					Speed = self.isAGapcloserUnitNoTarget[spell.name].projSpeed,
				}
				self:CondemnGapCloser(SpellInfo)
			end
		end
	end
	if unit.isMe and spell.name:lower():find('attack') then
		DelayAction(function() self:Youmuus() end, spell.windUpTime)
		if spell.target then self.SxInfo.LastTarget = spell.target end
		if SVMainMenu.keysetting.AfterAACondemn and self.SxInfo.LastTarget.type == myHero.type then
			DelayAction(function() CastSpell(_E, self.SxInfo.LastTarget) end, spell.windUpTime)
			SVMainMenu.keysetting.AfterAACondemn = false
		else
			DelayAction(function() self:Tumble(self.SxInfo.LastTarget) end, spell.windUpTime)
		end

	end
	if unit.isMe then
		if spell.name == 'Recall' and self:CheckModesActive(SVMainMenu.toggle) then
			SVMainMenu.keysetting.FightMode,SVMainMenu.keysetting.HarassMode,SVMainMenu.keysetting.LaneClear,SVMainMenu.keysetting.LastHit = false,false,false,false
		end
		if spell.name == 'VayneCondemnMissile' then
			SxOrb:ResetAA()
		end
	end
end

function ShadowVayne:CondemnGapCloser(SpellInfo)
	if (os.clock() - SpellInfo.CastTime) <= (SpellInfo.Range/SpellInfo.Speed) and myHero:CanUseSpell(_E) == READY then
		local Direction     = (SpellInfo.EndPos - SpellInfo.StartPos):normalized()
		local StartPosition = SpellInfo.StartPos + Direction
		local EndPosition   = SpellInfo.StartPos + Direction * SpellInfo.Range
		local MyPosition = Point(myHero.x, myHero.z)
		local SkillShot = LineSegment(Point(StartPosition.x, StartPosition.y), Point(EndPosition.x, EndPosition.y))
		if GetDistanceSqr(MyPosition,SkillShot) <= 400*400 then
			CastSpell(_E, SpellInfo.Source)
		else
			DelayAction(function() self:CondemnGapCloser(SpellInfo) end)
		end
	end
end

function ShadowVayne:Tumble(Target)
	if Target and Target.type ~= 'obj_AI_Turret' then
		if  (SVMainMenu.tumble.FightMode and ShadowVayneFightMode and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.ManaFightMode)) or
			(SVMainMenu.tumble.HarassMode and ShadowVayneHarassMode and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.ManaHarassMode)) or
			(SVMainMenu.tumble.LaneClear and ShadowVayneLaneClear and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.ManaLaneClear)) or
			(SVMainMenu.tumble.LastHit and  ShadowVayneLastHit and (100/myHero.maxMana*myHero.mana > SVMainMenu.tumble.ManaLastHit)) or
			(SVMainMenu.tumble.Always) then
			local AfterTumblePos = myHero + (Vector(mousePos) - myHero):normalized() * 300
			local DistanceAfterTumble = GetDistanceSqr(AfterTumblePos, Target)
			if  DistanceAfterTumble < 630*630 and DistanceAfterTumble > 100*100 then
				CastSpell(_Q, mousePos.x, mousePos.z)
			end
			if GetDistanceSqr(Target) > 630*630 and DistanceAfterTumble < 630*630 then
				CastSpell(_Q, mousePos.x, mousePos.z)
			end
		end
	end

	if SxOrb:GetAACD() > 0.37 then
		DelayAction(function() self:Tumble(Target) end)
	end
end

function ShadowVayne:GapCloserRengar()
	if ValidTarget(RengarHero, 1000) and myHero:CanUseSpell(_E) == READY then
		CastSpell(_E, RengarHero)
		DelayAction(function() self:GapCloserRengar() end)
	end
end

function ShadowVayne:RengarObject(Obj)
	if Obj.name == 'Rengar_LeapSound.troy' then
		for index, enemy in pairs(GetEnemyHeroes()) do
			if enemy.charName == 'Rengar' then
				RengarHero = enemy
				break
			end
		end
		if RengarHero and GetDistanceSqr(RengarHero) < 1000*1000 then
			if self:CheckModesActive(SVMainMenu.anticapcloser['Rengar']) then
				self:GapCloserRengar()
			end
		end
	end
end

function ShadowVayne:ThreshObject(Obj)
	if Obj.name == 'ThreshLantern' then
		self:TreshLantern(Obj)
	end
end

function ShadowVayne:TreshLantern(LaternObj)
	if LaternObj and LaternObj.valid and SVMainMenu.keysetting.ThreshLantern then
		LanternPacket = CLoLPacket(0x3A)
		LanternPacket:EncodeF(myHero.networkID)
		LanternPacket:EncodeF(LanternObj.networkID)
		LanternPacket.dwArg1 = 1
		LanternPacket.dwArg2 = 0
		SendPacket(LanternPacket)
		DelayAction(function() self:TreshLantern(LaternObj) end)
	end
end

function ShadowVayne:OnDraw()
	if SVMainMenu.draw.AARange then
		self:CircleDraw(myHero.x, myHero.y, myHero.z, 570 + myHero.boundingRadius, ARGB(SVMainMenu.draw.AAColor[1], SVMainMenu.draw.AAColor[2],SVMainMenu.draw.AAColor[3],SVMainMenu.draw.AAColor[4]))
	end

	if SVMainMenu.draw.ERange then
		self:CircleDraw(myHero.x, myHero.y, myHero.z, 710, ARGB(SVMainMenu.draw.EColor[1], SVMainMenu.draw.EColor[2],SVMainMenu.draw.EColor[3],SVMainMenu.draw.EColor[4]))
	end

	if self.SxInfo.MapIndex == 1 then
		for index, tumblespot in pairs(self.TumbleSpots) do
			if SVMainMenu.walltumble[tumblespot['Name']] then
				if GetDistanceSqr(tumblespot['Circle']) < 125*125 or GetDistanceSqr(tumblespot['Circle'], mousePos) < 125*125 then
					self:CircleDraw(tumblespot['Circle']['x'], tumblespot['Circle']['y'], tumblespot['Circle']['z'], 100, 0xFF107458) -- green
				else
					self:CircleDraw(tumblespot['Circle']['x'], tumblespot['Circle']['y'], tumblespot['Circle']['z'], 100, 0xFF80FFFF) -- red
				end
			end
		end
	end
end

function ShadowVayne:SwitchToggleMode()
	if SVMainMenu.toggle.FightMode then
		SVMainMenu.keysetting._param[StartKeyParam].pType = SCRIPT_PARAM_ONKEYTOGGLE
	else
		SVMainMenu.keysetting._param[StartKeyParam].pType = SCRIPT_PARAM_ONKEYDOWN
	end

	if SVMainMenu.toggle.HarassMode then
		SVMainMenu.keysetting._param[StartKeyParam+1].pType = SCRIPT_PARAM_ONKEYTOGGLE
	else
		SVMainMenu.keysetting._param[StartKeyParam+1].pType = SCRIPT_PARAM_ONKEYDOWN
	end

	if SVMainMenu.toggle.LaneClear then
		SVMainMenu.keysetting._param[StartKeyParam+2].pType = SCRIPT_PARAM_ONKEYTOGGLE
	else
		SVMainMenu.keysetting._param[StartKeyParam+2].pType = SCRIPT_PARAM_ONKEYDOWN
	end

	if SVMainMenu.toggle.LastHit then
		SVMainMenu.keysetting._param[StartKeyParam+3].pType = SCRIPT_PARAM_ONKEYTOGGLE
	else
		SVMainMenu.keysetting._param[StartKeyParam+3].pType = SCRIPT_PARAM_ONKEYDOWN
	end

	DelayAction(function() self:SwitchToggleMode() end, 1)
end

function ShadowVayne:CheckWallStun(Target)
	CastPosition, HitChance, PredictPosition = VP:GetPredictedPos(Target, 0.3, 1600, myHero, false)
	if HitChance > 1 then
		for i = 1, SVMainMenu.autostunn.PushDistance, 60  do
			local CheckWallPos = Vector(PredictPosition) + (Vector(PredictPosition) - myHero):normalized()*(i)
			if IsWall(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) then
				if UnderTurret(CheckWallPos, true) then
					if SVMainMenu.autostunn.TowerStun then
						CastSpell(_E, Target)
						break
					end
				else
					CastSpell(_E, Target)
					break
				end
			end
		end
	end
end

function ShadowVayne:CondemnStun()
	if myHero:CanUseSpell(_E) == READY then
		if SVMainMenu.autostunn.Target then
			local Target = self:GetTarget()
			if Target and ValidTarget(Target, 710) and Target.type == myHero.type and self:CheckModesActive(SVMainMenu.targets[Target.charName]) then
				self:CheckWallStun(Target)
			end
		else
			for i, enemy in ipairs(GetEnemyHeroes()) do
				if enemy and ValidTarget(enemy, 710) and self:CheckModesActive(SVMainMenu.targets[enemy.charName]) then
					self:CheckWallStun(enemy)
				end
			end
		end
	end
end

function ShadowVayne:WallTumble()
	if myHero:CanUseSpell(_Q) == READY then
		for index, tumblespot in pairs(self.TumbleSpots) do
			if tumblespot['Force'] and SVMainMenu.walltumble[tumblespot['Name']] then
				if GetDistanceSqr(tumblespot['Stand']) < 25*25 then
					CastSpell(_Q, tumblespot['Cast']['x'], tumblespot['Cast']['y'])
					tumblespot['Force'] = false
					myHero:HoldPosition()
				else
					myHero:MoveTo(tumblespot['Stand']['x'], tumblespot['Stand']['y'])
				end
			end
		end

		if not VIP_USER and SVMainMenu.keysetting['WallTumble'] then
			for index, tumblespot in pairs(self.TumbleSpots) do
				if tumblespot['Force'] then
					tumblespot['Force'] = false
				else
					if SVMainMenu.walltumble[tumblespot['Name']] then
						if GetDistanceSqr(tumblespot['Circle']) < 125*125 or GetDistanceSqr(tumblespot['Circle'],mousePos) < 125*125 then
							tumblespot['Force'] = true
						end
					end
				end
			end
		end
	else
		self.TumbleSpots['Drake']['Force'] = false
		self.TumbleSpots['Midlane']['Force'] = false
	end
end

function ShadowVayne:OnSendPacket(p)
	if p.header == _G.Packet.headers.S_CAST then
		p.pos = 1
		P_NetworkID = p:DecodeF()
		P_SpellID = p:Decode1()
		if P_NetworkID == myHero.networkID and P_SpellID == _Q then
			for index, tumblespot in pairs(self.TumbleSpots) do
				if tumblespot['Force'] then
					tumblespot['Force'] = false
				else
					if SVMainMenu.walltumble[tumblespot['Name']] then
						if GetDistanceSqr(tumblespot['Circle']) < 125*125 or GetDistanceSqr(tumblespot['Circle'],mousePos) < 125*125 then
							p:Block()
							tumblespot['Force'] = true
						end
					end
				end
			end
		end
	end
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
	self:DrawCircle2(x, y, z, radius, color)
end

function ShadowVayne:SkinChanger(champ, skinId) -- Credits to shalzuth
	if VIP_USER then
		p = CLoLPacket(0x97) -- 0x97
		p:EncodeF(myHero.networkID)
		p.pos = 1
		t1 = p:Decode1()
		t2 = p:Decode1()
		t3 = p:Decode1()
		t4 = p:Decode1()
		p:Encode1(t1)
		p:Encode1(t2)
		p:Encode1(t3)
		p:Encode1(bit32.band(t4,0xB))
		p:Encode1(1)--hardcode 1 bitfield
		p:Encode4(skinId)
		for i = 1, #champ do
			p:Encode1(string.byte(champ:sub(i,i)))
		end
		for i = #champ + 1, 64 do
			p:Encode1(0)
		end
		p:Hide()
		RecvPacket(p)
	end
end

function ShadowVayne:GetTarget()
	return SxOrb:GetTarget()
end

------------------------
---- AddParam Hooks ----
------------------------
_G.scriptConfig.CustomaddParam = _G.scriptConfig.addParam
_G.scriptConfig.addParam = function(self, pVar, pText, pType, defaultValue, a, b, c, d)
 -- MMA Hook
if self.name == 'MMA2013' and pText:find('OnHold') then
	pType = 5
end

-- SAC:Reborn r83 Hook
if self.name:find('sidasacsetup_sidasac') and (pText == 'Auto Carry' or pText == 'Mixed Mode' or pText == 'Lane Clear' or pText == 'Last Hit') then
	pType=5
end

-- SAC:Reborn r84 Hook
if self.name:find('sidasacsetup_sidasac') and (pText == 'Hotkey') then
	pType=5
end

-- SAC:Reborn VayneMenu Hook
if self.name:find('sidasacvayne') then
	pType=5
end

-- SOW Hook
if self.name == 'SV_SOW' and pVar:find('Mode') then
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

	if self.name:find('sidasacsetup_sidasac') and (self._param[varIndex].text == 'Hotkey') then
		self._param[varIndex].text = 'ShadowVayne found. Set the Keysettings there!'
		self._param[varIndex].var = 'fap'
	end

	if self.name == 'MMA2014' and (self._param[varIndex].text:find('Spells on') or self._param[varIndex].text:find('Version')) then
	HideParam = true
		if not MMAParams then
			MMAParams = true
			self:addParam('nil','ShadowVayne found. Set the Keysettings there!', SCRIPT_PARAM_INFO, '')
			self:addParam('nil','ShadowVayne found. Set the Keysettings there!', SCRIPT_PARAM_INFO, '')
			self:addParam('nil','ShadowVayne found. Set the Keysettings there!', SCRIPT_PARAM_INFO, '')
			self:addParam('nil','ShadowVayne found. Set the Keysettings there!', SCRIPT_PARAM_INFO, '')
			self:addParam(self._param[varIndex].var, 'Use Spells On', SCRIPT_PARAM_LIST,1, {'None','All Units','Heroes Only','Minion Only'})
			self:addParam('mmaVersion','MMA - version:', SCRIPT_PARAM_INFO, '0.1416')
		end
	end

	if self.name:find('sidasacvayne') and not self._param[varIndex].text:find('ShadowVayne') then
		if not SACVayneParam then
			SACVayneParam = true
			self:addParam('nil','ShadowVayne found. Set the Keysettings there!', SCRIPT_PARAM_INFO, '')
		end
		HideParam = true
	end

	if self.name == 'SV_MAIN_keysetting' and self._param[varIndex].text:find('Hidden') then
		HideParam = true
	end

	if self.name == 'SV_SOW' and (self._param[varIndex].var == 'Hotkeys' or self._param[varIndex].var:find('Mode')) then HideParam = true end

	if (self.name == 'MMA2014' and self._param[varIndex].text:find('OnHold')) then HideParam = true end
	if not HideParam then
		_G.scriptConfig.CustomDrawParam(self, varIndex)
	end
end

-------------------------
----- SubMenu Hooks -----
-------------------------
_G.scriptConfig.CustomDrawSubInstance = _G.scriptConfig._DrawSubInstance
_G.scriptConfig._DrawSubInstance = function(self, index)
	if not self.name:find('sidasacvayne') then
		_G.scriptConfig.CustomDrawSubInstance(self, index)
	end
end

-------------------------
---- PermaShow Hooks ----
-------------------------
_G.scriptConfig.CustompermaShow = _G.scriptConfig.permaShow
_G.scriptConfig.permaShow = function(self, pVar)
	if not (self.name:find('sidasacvayne') or self.name == 'MMA2014') then
		_G.scriptConfig.CustompermaShow(self, pVar)
	end
end
