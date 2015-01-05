--[[

	Shadow Vayne Script by Aroc

	For Functions & Changelog, check the Thread on the BoL Forums:
	http://botoflegends.com/forum/topic/18939-shadow-vayne-the-mighty-hunter/
	]]
if myHero.charName ~= 'Vayne' then return end

class "SxUpdate"
function SxUpdate:__init(LocalVersion, Host, VersionPath, ScriptPath, SavePath, Callback)
    self.Callback = Callback
    self.LocalVersion = LocalVersion
    self.Host = Host
    self.VersionPath = VersionPath
    self.ScriptPath = ScriptPath
    self.SavePath = SavePath
    self.LuaSocket = require("socket")
    AddTickCallback(function() self:GetOnlineVersion() end)
    DelayAction(function() self.UpdateDone = true end, 2)
end

function SxUpdate:GetOnlineVersion()
    if self.UpdateDone then return end
    if not self.OnlineVersion and not self.VersionSocket then
        self.VersionSocket = self.LuaSocket.connect("sx-bol.eu", 80)
        self.VersionSocket:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.Host..self.VersionPath.."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
    end

    if not self.OnlineVersion and self.VersionSocket then
        self.VersionSocket:settimeout(0, 'b')
        self.VersionSocket:settimeout(99999999, 't')
        self.VersionReceive, self.VersionStatus = self.VersionSocket:receive('*a')
    end

    if not self.OnlineVersion and self.VersionSocket and self.VersionStatus ~= 'timeout' then
        if self.VersionReceive then
            self.OnlineVersion = tonumber(string.sub(self.VersionReceive, string.find(self.VersionReceive, "<bols".."cript>")+11, string.find(self.VersionReceive, "</bols".."cript>")-1))
            if not self.OnlineVersion then print(self.VersionReceive) end
        else
            print('AutoUpdate Failed')
            self.OnlineVersion = 0
        end
        self:DownloadUpdate()
    end
end

function SxUpdate:DownloadUpdate()
    if self.OnlineVersion > self.LocalVersion then
        self.ScriptSocket = self.LuaSocket.connect("sx-bol.eu", 80)
        self.ScriptSocket:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.Host..self.ScriptPath.."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
        self.ScriptReceive, self.ScriptStatus = self.ScriptSocket:receive('*a')
        self.ScriptRAW = string.sub(self.ScriptReceive, string.find(self.ScriptReceive, "<bols".."cript>")+11, string.find(self.ScriptReceive, "</bols".."cript>")-1)
        local ScriptFileOpen = io.open(self.SavePath, "w+")
        ScriptFileOpen:write(self.ScriptRAW)
        ScriptFileOpen:close()
    end

    if type(self.Callback) == 'function' then
        self.Callback(self.OnlineVersion)
    end
    self.UpdateDone = true
end

------------------------
------ LoadScript ------
------------------------
function OnLoad()
    require 'SxOrbWalk'
    require 'VPrediction'
    VP = VPrediction()
    DelayAction(function()
        if not SxOrb or not SxOrb.Version or SxOrb.Version < 2.11 then print('<font color=\'#F0Ff8d\'><b>ShadowVayne:</b></font> <font color=\'#FF0F0F\'>Loading Failed. Please Update SxOrbWalk to newest Version</font>') return end
        if not VP or not VP.version or VP.version < 1.4 then print('<font color=\'#F0Ff8d\'><b>ShadowVayne:</b></font> <font color=\'#FF0F0F\'>Loading Failed. Please Update VPrediction to newest Version</font>') return end
        ShadowVayne()
    end,0.1)
end

------------------------
------ ShadowVayne -----
------------------------
class 'ShadowVayne'
function ShadowVayne:__init()
    self.version = 5.09
    self.LastTarget = nil
    self.LastLevelCheck = 0
    self.Items = {}
    self.MapIndex = GetGame().map.index
    print('<font color=\'#F0Ff8d\'><b>ShadowVayne:</b></font> <font color=\'#FF0F0F\'>Version '..self.version..' loaded</font>')
    SxUpdate(self.version,
        "raw.githubusercontent.com",
        "/Superx321/BoL/master/ShadowVayne.Version",
        "/Superx321/BoL/master/ShadowVayne.lua",
        SCRIPT_PATH.."ShadowVayne.lua",
        function(NewVersion) if NewVersion > self.version then print("<font color=\"#F0Ff8d\"><b>ShadowVayne: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") else print("<font color=\"#F0Ff8d\"><b>ShadowVayne: </b></font> <font color=\"#FF0F0F\">You have the Latest Version</b></font>") end end)
    self:GenerateTables()
    self:GetOrbWalkers()
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

    self.Color = { Red = ARGB(0xFF,0xFF,0,0),Green = ARGB(0xFF,0,0xFF,0),Blue = ARGB(0xFF,0,0,0xFF), White = ARGB(0xFF,0xFF,0xFF,0xFF), Black = ARGB(0xFF, 0x00, 0x00, 0x00) }
end

function ShadowVayne:GetOrbWalkers()
    self.OrbWalkers = {}
    table.insert(self.OrbWalkers, 'SxOrb')

    if _G.MMA_Loaded then
        table.insert(self.OrbWalkers, 'MMA')
    end

    if _G.Reborn_Loaded then
        table.insert(self.OrbWalkers, 'SAC:Reborn')
        print('<font color=\'#F0Ff8d\'><b>ShadowVayne:</b></font> <font color=\'#FF0F0F\'>Waiting for SAC:Reborn Auth</font>')
        AddTickCallback(function() self:WaitForReborn() end)
    else
        self:LoadMenu()
    end
end

function ShadowVayne:WaitForReborn()
    if self.Loaded then return end
    if _G.AutoCarry then
        self:LoadMenu()
    end
end

function ShadowVayne:LoadMenu()
    self.Menu = scriptConfig('ShadowVayne', 'SV_MAIN')
    self.Menu:addSubMenu('[Condemn]: AntiGapCloser Settings', 'anticapcloser')
    self.Menu:addSubMenu('[Condemn]: AutoStun Settings', 'autostunn')
    self.Menu:addSubMenu('[Condemn]: AutoStun Targets', 'targets')
    self.Menu:addSubMenu('[Condemn]: Interrupt Settings', 'interrupt')
    self.Menu:addSubMenu('[Tumble]: Settings', 'tumble')
    self.Menu:addSubMenu('[Misc]: Key Settings', 'keysetting')
    self.Menu:addSubMenu('[Misc]: AutoLevelSpells Settings', 'autolevel')
    self.Menu:addSubMenu('[Misc]: Draw Settings', 'draw')
    self.Menu:addSubMenu('[BotRK]: Settings', 'botrk')
    self.Menu:addSubMenu('[Bilgewater]: Settings', 'bilgewater')
    self.Menu:addSubMenu('[Youmuu\'s]: Settings', 'youmuus')

    -- KeySetting Menu
    self.Menu.keysetting:addParam('nil','Basic Key Settings', SCRIPT_PARAM_INFO, '')
    self.Menu.keysetting:addParam('AfterAACondemn','Condemn on next BasicAttack:', SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte( 'E' ))
    self.Menu.keysetting:addParam('nil','', SCRIPT_PARAM_INFO, '')
    self.Menu.keysetting:addParam('FightModeOrb', 'Orbwalker in FightMode: ', SCRIPT_PARAM_LIST, 1, self.OrbWalkers)
    self.Menu.keysetting:addParam('HarassModeOrb', 'Orbwalker in HarassMode: ', SCRIPT_PARAM_LIST, 1, self.OrbWalkers)
    self.Menu.keysetting:addParam('LaneClearOrb', 'Orbwalker in LaneClear: ', SCRIPT_PARAM_LIST, 1, self.OrbWalkers)
    self.Menu.keysetting:addParam('LastHitOrb', 'Orbwalker in LastHit: ', SCRIPT_PARAM_LIST, 1, self.OrbWalkers)

    for index, param in pairs(self.Menu.keysetting._param) do
        if param['var'] == 'FightModeOrb' then
            self.StartListParam = index
        end
    end
    if self.Menu.keysetting._param[self.StartListParam].listTable[self.Menu.keysetting.FightModeOrb] == nil then self.Menu.keysetting.FightModeOrb = 1 end
    if self.Menu.keysetting._param[self.StartListParam+1].listTable[self.Menu.keysetting.HarassModeOrb] == nil then self.Menu.keysetting.HarassModeOrb = 1 end
    if self.Menu.keysetting._param[self.StartListParam+2].listTable[self.Menu.keysetting.LaneClearOrb] == nil then self.Menu.keysetting.LaneClearOrb = 1 end
    if self.Menu.keysetting._param[self.StartListParam+3].listTable[self.Menu.keysetting.LastHitOrb] == nil then self.Menu.keysetting.LastHitOrb = 1 end

    -- GapCloser
    local FoundAGapCloser = false
    for index, data in pairs(self.isAGapcloserUnitTarget) do
        for index2, enemy in ipairs(GetEnemyHeroes()) do
            if data['Champ'] == enemy.charName then
                self.Menu.anticapcloser:addSubMenu(enemy.charName..' '..data.spellKey, enemy.charName)
                self.Menu.anticapcloser[enemy.charName]:addParam('fap', 'Pushback '..enemy.charName..' '..data.spellKey..'...', SCRIPT_PARAM_INFO, '')
                self.Menu.anticapcloser[enemy.charName]:addParam('FightMode', 'in FightMode', SCRIPT_PARAM_ONOFF, true)
                self.Menu.anticapcloser[enemy.charName]:addParam('HarassMode', 'in HarassMode', SCRIPT_PARAM_ONOFF, true)
                self.Menu.anticapcloser[enemy.charName]:addParam('LaneClear', 'in LaneClear', SCRIPT_PARAM_ONOFF, false)
                self.Menu.anticapcloser[enemy.charName]:addParam('LastHit', 'in LastHit', SCRIPT_PARAM_ONOFF, false)
                self.Menu.anticapcloser[enemy.charName]:addParam('Always', 'Always', SCRIPT_PARAM_ONOFF, false)
                FoundAGapCloser = true
            end
        end
    end
    for index, data in pairs(self.isAGapcloserUnitNoTarget) do
        for index2, enemy in ipairs(GetEnemyHeroes()) do
            if data['Champ'] == enemy.charName then
                self.Menu.anticapcloser:addSubMenu(enemy.charName..' '..data.spellKey, enemy.charName)
                self.Menu.anticapcloser[enemy.charName]:addParam('fap', 'Pushback '..enemy.charName..' '..data.spellKey..'...', SCRIPT_PARAM_INFO, '')
                self.Menu.anticapcloser[enemy.charName]:addParam('FightMode', 'in FightMode', SCRIPT_PARAM_ONOFF, true)
                self.Menu.anticapcloser[enemy.charName]:addParam('HarassMode', 'in HarassMode', SCRIPT_PARAM_ONOFF, true)
                self.Menu.anticapcloser[enemy.charName]:addParam('LaneClear', 'in LaneClear', SCRIPT_PARAM_ONOFF, false)
                self.Menu.anticapcloser[enemy.charName]:addParam('LastHit', 'in LastHit', SCRIPT_PARAM_ONOFF, false)
                self.Menu.anticapcloser[enemy.charName]:addParam('Always', 'Always', SCRIPT_PARAM_ONOFF, false)
                FoundAGapCloser = true
            end
        end
    end
    if not FoundAGapCloser then self.Menu.anticapcloser:addParam('nil','No Enemy Gapclosers found', SCRIPT_PARAM_INFO, '') end

    -- StunTargets
    local FoundStunTarget = false
    for index, enemy in ipairs(GetEnemyHeroes()) do
        self.Menu.targets:addSubMenu(enemy.charName, enemy.charName)
        self.Menu.targets[enemy.charName]:addParam('fap', 'Stun '..enemy.charName..'...', SCRIPT_PARAM_INFO, '')
        self.Menu.targets[enemy.charName]:addParam('FightMode', 'in FightMode', SCRIPT_PARAM_ONOFF, true)
        self.Menu.targets[enemy.charName]:addParam('HarassMode', 'in HarassMode', SCRIPT_PARAM_ONOFF, false)
        self.Menu.targets[enemy.charName]:addParam('LaneClear', 'in LaneClear', SCRIPT_PARAM_ONOFF, false)
        self.Menu.targets[enemy.charName]:addParam('LastHit', 'in LastHit', SCRIPT_PARAM_ONOFF, false)
        self.Menu.targets[enemy.charName]:addParam('Always', 'Always', SCRIPT_PARAM_ONOFF, false)
        FoundStunTarget = true
    end
    if not FoundStunTarget then self.Menu.targets:addParam('nil','No Enemies to Stun found', SCRIPT_PARAM_INFO, '') end

    -- Interrupt
    local Foundinterrupt = false
    for index, data in pairs(self.isAChampToInterrupt) do
        for index, enemy in ipairs(GetEnemyHeroes()) do
            if data['Champ'] == enemy.charName then
                self.Menu.interrupt:addSubMenu(enemy.charName..' '..data.spellKey..'...', enemy.charName)
                self.Menu.interrupt[enemy.charName]:addParam('fap', 'Interrupt '..enemy.charName..' '..data.spellKey, SCRIPT_PARAM_INFO, '')
                self.Menu.interrupt[enemy.charName]:addParam('FightMode', 'in FightMode', SCRIPT_PARAM_ONOFF, true)
                self.Menu.interrupt[enemy.charName]:addParam('HarassMode', 'in HarassMode', SCRIPT_PARAM_ONOFF, true)
                self.Menu.interrupt[enemy.charName]:addParam('LaneClear', 'in LaneClear', SCRIPT_PARAM_ONOFF, true)
                self.Menu.interrupt[enemy.charName]:addParam('LastHit', 'in LastHit', SCRIPT_PARAM_ONOFF, true)
                self.Menu.interrupt[enemy.charName]:addParam('Always', 'Always', SCRIPT_PARAM_ONOFF, true)
                Foundinterrupt = true
            end
        end
    end
    if not Foundinterrupt then self.Menu.interrupt:addParam('nil','No Enemies to Interrupt found', SCRIPT_PARAM_INFO, '') end

    -- StunSettings
    self.Menu.autostunn:addParam('PushDistance', 'Push Distance', SCRIPT_PARAM_SLICE, 390, 0, 450, 0)
    self.Menu.autostunn:addParam('TowerStun', 'Stun if Enemy lands unter a Tower', SCRIPT_PARAM_ONOFF, false)
    self.Menu.autostunn:addParam('Trinket', 'Use Auto-Trinket Bush', SCRIPT_PARAM_ONOFF, true)
    self.Menu.autostunn:addParam('Target', 'Stun only Current Target', SCRIPT_PARAM_ONOFF, true)

    -- Draw
    self.Menu.draw:addParam('ERange', 'Draw E Range', SCRIPT_PARAM_ONOFF, true)
    self.Menu.draw:addParam('EColor', 'E Range Color', SCRIPT_PARAM_COLOR, {141, 124, 4, 4})

    -- AutoLevel
    self.Menu.autolevel:addParam('UseAutoLevelFirst', 'Use AutoLevelSpells Level 1-3', SCRIPT_PARAM_ONOFF, false)
    self.Menu.autolevel:addParam('UseAutoLevelRest', 'Use AutoLevelSpells Level 4-18', SCRIPT_PARAM_ONOFF, false)
    self.Menu.autolevel:addParam('First3Level', 'Level 1-3:', SCRIPT_PARAM_LIST, 1, { 'Q-W-E', 'Q-E-W', 'W-Q-E', 'W-E-Q', 'E-Q-W', 'E-W-Q' })
    self.Menu.autolevel:addParam('RestLevel', 'Level 4-18:', SCRIPT_PARAM_LIST, 1, { 'Q-W-E', 'Q-E-W', 'W-Q-E', 'W-E-Q', 'E-Q-W', 'E-W-Q' })
    self.Menu.autolevel:addParam('fap', '', SCRIPT_PARAM_INFO, '','' )
    self.Menu.autolevel:addParam('fap', 'You can Click on the \'Q-W-E\'', SCRIPT_PARAM_INFO, '','' )
    self.Menu.autolevel:addParam('fap', 'to change the AutoLevelOrder', SCRIPT_PARAM_INFO, '','' )

    -- BotRK
    self.Menu.botrk:addParam('FightMode', 'Use BotRK in FightMode', SCRIPT_PARAM_ONOFF, true)
    self.Menu.botrk:addParam('HarassMode', 'Use BotRK in HarassMode', SCRIPT_PARAM_ONOFF, false)
    self.Menu.botrk:addParam('LaneClear', 'Use BotRK in LaneClear', SCRIPT_PARAM_ONOFF, false)
    self.Menu.botrk:addParam('LastHit', 'Use BotRK in LastHit', SCRIPT_PARAM_ONOFF, false)
    self.Menu.botrk:addParam('Always', 'Use BotRK Always', SCRIPT_PARAM_ONOFF, false)
    self.Menu.botrk:addParam('MaxOwnHealth', 'Max Own Health Percent', SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
    self.Menu.botrk:addParam('MinEnemyHealth', 'Min Enemy Health Percent', SCRIPT_PARAM_SLICE, 20, 1, 100, 0)

    -- Bilgewater
    self.Menu.bilgewater:addParam('FightMode', 'Use BilgeWater Cutlass in FightMode', SCRIPT_PARAM_ONOFF, true)
    self.Menu.bilgewater:addParam('HarassMode', 'Use BilgeWater Cutlass in HarassMode', SCRIPT_PARAM_ONOFF, false)
    self.Menu.bilgewater:addParam('LaneClear', 'Use BilgeWater Cutlass in LaneClear', SCRIPT_PARAM_ONOFF, false)
    self.Menu.bilgewater:addParam('LastHit', 'Use BilgeWater Cutlass in LastHit', SCRIPT_PARAM_ONOFF, false)
    self.Menu.bilgewater:addParam('Always', 'Use BilgeWater Cutlass Always', SCRIPT_PARAM_ONOFF, false)
    self.Menu.bilgewater:addParam('MaxOwnHealth', 'Max Own Health Percent', SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
    self.Menu.bilgewater:addParam('MinEnemyHealth', 'Min Enemy Health Percent', SCRIPT_PARAM_SLICE, 20, 1, 100, 0)

    -- Yomuus
    self.Menu.youmuus:addParam('FightMode', 'Use Youmuus Ghostblade in FightMode', SCRIPT_PARAM_ONOFF, true)
    self.Menu.youmuus:addParam('HarassMode', 'Use Youmuus Ghostblade in HarassMode', SCRIPT_PARAM_ONOFF, false)
    self.Menu.youmuus:addParam('LaneClear', 'Use Youmuus Ghostblade in LaneClear', SCRIPT_PARAM_ONOFF, false)
    self.Menu.youmuus:addParam('LastHit', 'Use Youmuus Ghostblade in LastHit', SCRIPT_PARAM_ONOFF, false)
    self.Menu.youmuus:addParam('Always', 'Use Youmuus Ghostblade Always', SCRIPT_PARAM_ONOFF, false)

    -- Tumble
    self.Menu.tumble:addParam('FightMode', 'Use Tumble in FightMode', SCRIPT_PARAM_ONOFF, true)
    self.Menu.tumble:addParam('HarassMode', 'Use Tumble in HarassMode', SCRIPT_PARAM_ONOFF, false)
    self.Menu.tumble:addParam('LaneClear', 'Use Tumble in LaneClear', SCRIPT_PARAM_ONOFF, false)
    self.Menu.tumble:addParam('LastHit', 'Use Tumble in LastHit', SCRIPT_PARAM_ONOFF, false)
    self.Menu.tumble:addParam('Always', 'Use Tumble Always', SCRIPT_PARAM_ONOFF, false)
    self.Menu.tumble:addParam('fap', '', SCRIPT_PARAM_INFO, '','' )
    self.Menu.tumble:addParam('ManaFightMode', 'Min Mana to use Q in FightMode', SCRIPT_PARAM_SLICE, 0, 0, 100, 0)
    self.Menu.tumble:addParam('ManaHarassMode', 'Min Mana to use Q in HarassMode', SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
    self.Menu.tumble:addParam('ManaLaneClear', 'Min Mana to use Q in LaneClear', SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
    self.Menu.tumble:addParam('ManaLastHit', 'Min Mana to use Q in LastHit', SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

    self:MenuLoaded()
end

function ShadowVayne:MenuLoaded()
    self.Loaded = true
    SxOrb:LoadToMenu(nil)
    AddTickCallback(function() self:CheckLevelChange() end)
    AddTickCallback(function() self:CheckItems() end)
    AddTickCallback(function() self:ActivateModes() end)
    AddTickCallback(function() self:BotRK() end)
    AddTickCallback(function() self:BilgeWater() end)
    AddTickCallback(function() self:CondemnStun() end)

    AddDrawCallback(function() self:OnDraw() end)

    AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
end

function ShadowVayne:ActivateModes()
    -- Get The Selected Orbwalker
    self.IsFight, self.IsHarass, self.IsLaneClear, self.IsLastHit = false,false,false,false
    self.FightModeOrbText = self.Menu.keysetting._param[self.StartListParam].listTable[self.Menu.keysetting.FightModeOrb]
    self.HarassModeOrbText = self.Menu.keysetting._param[self.StartListParam+1].listTable[self.Menu.keysetting.HarassModeOrb]
    self.LaneClearOrbText = self.Menu.keysetting._param[self.StartListParam+2].listTable[self.Menu.keysetting.LaneClearOrb]
    self.LastHitOrbText = self.Menu.keysetting._param[self.StartListParam+3].listTable[self.Menu.keysetting.LastHitOrb]

    -- Activate MMA
    if self.FightModeOrbText == 'MMA' then self.IsFight = _G.MMA_IsOrbwalking end
    if self.HarassModeOrbText == 'MMA' then self.IsHarass = _G.MMA_IsHybrid end
    if self.LaneClearOrbText == 'MMA' then self.IsLaneClear = _G.MMA_IsClearing end
    if self.LastHitOrbText == 'MMA' then self.IsLastHit = _G.MMA_IsLasthitting end

    -- Activate SAC:Reborn
    if self.FightModeOrbText == 'SAC:Reborn' then self.IsFight = _G.AutoCarry.Keys.AutoCarry end
    if self.HarassModeOrbText == 'SAC:Reborn' then self.IsHarass = _G.AutoCarry.Keys.MixedMode end
    if self.LaneClearOrbText == 'SAC:Reborn' then self.IsLaneClear = _G.AutoCarry.Keys.LaneClear end
    if self.LastHitOrbText   == 'SAC:Reborn' then self.IsLastHit = _G.AutoCarry.Keys.LastHit end

    -- Activate SxOrbWalker
    if self.FightModeOrbText == 'SxOrb' then self.IsFight = SxOrb.IsFight end
    if self.HarassModeOrbText == 'SxOrb' then self.IsHarass = SxOrb.IsHarass end
    if self.LaneClearOrbText == 'SxOrb' then self.IsLaneClear = SxOrb.IsLaneClear end
    if self.LastHitOrbText   == 'SxOrb' then self.IsLastHit = SxOrb.IsLastHit end
end

function ShadowVayne:CheckModesActive(Menu)
    if Menu.FightMode and self.IsFight then
        return true
    elseif Menu.HarassMode and self.IsHarass then
        return true
    elseif Menu.LaneClear and self.IsLaneClear then
        return true
    elseif Menu.LastHit and self.IsLastHit then
        return true
    elseif Menu.Always then
        return true
    else
        return false
    end
end

function ShadowVayne:CheckLevelChange()
    if self.LastLevelCheck + 250 < GetTickCount() then
        if self.MapIndex == 8 and myHero.level < 4 and self.Menu.autolevel.UseAutoLevelFirst then
            LevelSpell(_Q)
            LevelSpell(_W)
            LevelSpell(_E)
        end

        self.LastLevelCheck = GetTickCount()
        if myHero.level ~= self.LastHeroLevel then
            DelayAction(function() self:LevelUpSpell() end, 0.25)
            self.LastHeroLevel = myHero.level
        end
    end
end

function ShadowVayne:LevelUpSpell()
    if self.Menu.autolevel.UseAutoLevelFirst and myHero.level < 4 then
        LevelSpell(self.AutoLevelSpellTable[self.AutoLevelSpellTable['SpellOrder'][self.Menu.autolevel.First3Level]][myHero.level])
    end

    if self.Menu.autolevel.UseAutoLevelRest and myHero.level > 3 then
        LevelSpell(self.AutoLevelSpellTable[self.AutoLevelSpellTable['SpellOrder'][self.Menu.autolevel.RestLevel]][myHero.level])
    end
end

function ShadowVayne:CheckItems()
    if (self.LastItemCheck or 0) + 250 < GetTickCount() then
        self.LastItemCheck = GetTickCount()
        self.Items.BotRK = GetInventorySlotItem(3153)
        self.Items.BilgeWater = GetInventorySlotItem(3144)
        self.Items.Youmuus = GetInventorySlotItem(3142)
    end
end

function ShadowVayne:BotRK()
    if self.Items.BotRK and self:CheckModesActive(self.Menu.botrk) then
        if (math.floor(myHero.health / myHero.maxHealth * 100)) <= self.Menu.botrk.MaxOwnHealth then
            local Target = self:GetTarget()
            if Target and ValidTarget(Target, 510) then
                if (math.floor(Target.health / Target.maxHealth * 100)) >= self.Menu.botrk.MinEnemyHealth then
                    if myHero:CanUseSpell(self.Items.BotRK) == 0 then
                        CastSpell(self.Items.BotRK, Target)
                    end
                end
            end
        end
    end
end

function ShadowVayne:BilgeWater()
    if self.Items.BilgeWater and self:CheckModesActive(self.Menu.bilgewater) then
        if (math.floor(myHero.health / myHero.maxHealth * 100)) <= self.Menu.bilgewater.MaxOwnHealth then
            local Target = self:GetTarget()
            if Target and ValidTarget(Target, 450) then
                if (math.floor(Target.health / Target.maxHealth * 100)) >= self.Menu.bilgewater.MinEnemyHealth then
                    if myHero:CanUseSpell(self.Items.BilgeWater) == 0 then
                        CastSpell(self.Items.BilgeWater, Target)
                    end
                end
            end
        end
    end
end

function ShadowVayne:Youmuus()
    if self.Items.Youmuus and self:CheckModesActive(self.Menu.youmuus) then
        if myHero:CanUseSpell(self.Items.Youmuus) == 0 then
            CastSpell(self.Items.Youmuus)
        end
    end
end

function ShadowVayne:OnProcessSpell(unit, spell)
    if unit.team ~= myHero.team then
        if self.isAGapcloserUnitTarget[spell.name] then
            if spell.target and spell.target.networkID == myHero.networkID then
                if self:CheckModesActive(self.Menu.anticapcloser[unit.charName]) then CastSpell(_E, unit) end
            end
        end

        if self.isAChampToInterrupt[spell.name] and GetDistanceSqr(unit) <= 715*715 then
            if self:CheckModesActive(self.Menu.interrupt[unit.charName]) then CastSpell(_E, unit) end
        end

        if self.isAGapcloserUnitNoTarget[spell.name] and GetDistanceSqr(unit) <= 2000*2000 and (spell.target == nil or (spell.target and spell.target.isMe)) then
            if self:CheckModesActive(self.Menu.anticapcloser[unit.charName]) then
                SpellInfo = {
                    Source = unit,
                    CastTime = os.clock(),
                    --~ 					Direction = (spell.endPos - spell.startPos):normalized(),
                    StartPos = Point(unit.pos.x, unit.pos.z),
                    Range = self.isAGapcloserUnitNoTarget[spell.name].range,
                    Speed = self.isAGapcloserUnitNoTarget[spell.name].projSpeed,
                }
                --                self:CondemnGapCloser(SpellInfo)
            end
        end
    end

    if unit.isMe and spell.name:lower():find('attack') then
        DelayAction(function() self:Youmuus() end, spell.windUpTime)
        if spell.target then self.LastTarget = spell.target end
        if self.Menu.keysetting.AfterAACondemn and self.LastTarget.type == myHero.type then
            DelayAction(function() CastSpell(_E, self.LastTarget) end, spell.windUpTime + GetLatency()/2000)
            self.Menu.keysetting.AfterAACondemn = false
        else
            DelayAction(function() self:Tumble(self.LastTarget) end, spell.windUpTime + GetLatency()/2000)
        end
    end
end

function ShadowVayne:CondemnGapCloser(SpellInfo)
    if (os.clock() - SpellInfo.CastTime) <= (SpellInfo.Range/SpellInfo.Speed) and myHero:CanUseSpell(_E) == READY then
        local EndPosition = Vector(SpellInfo.StartPos) + (Vector(SpellInfo.StartPos) - SpellInfo.EndPos):normalized()*(SpellInfo.Range)
        local StartPosition = SpellInfo.StartPos + SpellInfo.Direction
        local EndPosition   = SpellInfo.StartPos + (SpellInfo.Direction * SpellInfo.Range)
        local MyPosition = Point(myHero.x, myHero.z)
        local SkillShot = LineSegment(Point(StartPosition.x, StartPosition.y), Point(EndPosition.x, EndPosition.y))
        if GetDistanceSqr(MyPosition,SkillShot) <= 400*400 then
            self.CondemnTarget = SpellInfo.Source
        else
            DelayAction(function() self:CondemnGapCloser(SpellInfo) end)
        end
    end
end

function ShadowVayne:Tumble(Target)
    if Target and Target.type ~= 'obj_AI_Turret' then
        local ManaCalc = 100/myHero.maxMana*myHero.mana
        if  (self.Menu.tumble.FightMode and self.IsFight and (ManaCalc > self.Menu.tumble.ManaFightMode)) or
                (self.Menu.tumble.HarassMode and self.IsHarass and (ManaCalc > self.Menu.tumble.ManaHarassMode)) or
                (self.Menu.tumble.LaneClear and self.IsLaneClear and (ManaCalc > self.Menu.tumble.ManaLaneClear)) or
                (self.Menu.tumble.LastHit and  self.IsLastHit and (ManaCalc > self.Menu.tumble.ManaLastHit)) or
                (self.Menu.tumble.Always) then
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
end

function ShadowVayne:OnDraw()
    if self.Menu.draw.ERange then
        self:CircleDraw(myHero.x, myHero.y, myHero.z, 710, ARGB(self.Menu.draw.EColor[1], self.Menu.draw.EColor[2],self.Menu.draw.EColor[3],self.Menu.draw.EColor[4]))
    end

    if self.Menu.keysetting.AfterAACondemn then
        local myPos = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
        DrawText("Auto-Condemn After Next AA is on!!",15, myPos.x, myPos.y, self.Color.Red)
    end
end

function ShadowVayne:CheckWallStun(Target)
    local Pos, Hitchance, PredictPos = VP:GetLineCastPosition(Target, 0.350, 0, 600, 2200, myHero, false)
    if Hitchance > 1 then
        local checks = 30
        local CheckD = math.ceil(self.Menu.autostunn.PushDistance / checks)
        local FoundGrass = false
        for i = 1, checks  do
            local CheckWallPos = Vector(PredictPos) + Vector(Vector(PredictPos) - Vector(myHero)):normalized()*(CheckD*i)
            if not FoundGrass and IsWallOfGrass(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) then
                FoundGrass = CheckWallPos
            end
            if IsWall(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) then
                if UnderTurret(CheckWallPos, true) then
                    if self.Menu.autostunn.TowerStun then
                        CastSpell(_E, Target)
                        break
                    end
                else
                    CastSpell(_E, Target)
                    if FoundGrass then DelayAction(function() CastSpell(ITEM_7) end, 0.25) end
                    break
                end
            end
        end
    end
end

function ShadowVayne:CondemnStun()
    if myHero:CanUseSpell(_E) == READY then
        if self.Menu.autostunn.Target then
            local Target = self:GetTarget()
            if Target and Target.type == myHero.type and ValidTarget(Target, 710) and self:CheckModesActive(self.Menu.targets[Target.charName]) then
                self:CheckWallStun(Target)
            end
        else
            for i, enemy in ipairs(GetEnemyHeroes()) do
                if enemy and ValidTarget(enemy, 710) and self:CheckModesActive(self.Menu.targets[enemy.charName]) then
                    self:CheckWallStun(enemy)
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

function ShadowVayne:GetTarget()
    if self.IsFight then
        if self.FightModeOrbText == 'MMA' then return _G.MMA_ConsideredTarget() end
        if self.FightModeOrbText == 'SAC:Reborn' then return _G.AutoCarry.Crosshair:GetTarget() end
        if self.FightModeOrbText == 'SxOrb' then return SxOrb:GetTarget() end
    elseif self.IsHarass then
        if self.HarassModeOrbText == 'MMA' then return _G.MMA_ConsideredTarget() end
        if self.HarassModeOrbText == 'SAC:Reborn' then return _G.AutoCarry.Crosshair:GetTarget() end
        if self.HarassModeOrbText == 'SxOrb' then return SxOrb:GetTarget() end
    elseif self.IsLastHit then
        if self.LastHitOrbText == 'MMA' then return _G.MMA_ConsideredTarget() end
        if self.LastHitOrbText == 'SAC:Reborn' then return _G.AutoCarry.Crosshair:GetTarget() end
        if self.LastHitOrbText == 'SxOrb' then return SxOrb:GetTarget() end
    elseif self.IsLaneClear then
        if self.LaneClearOrbText == 'MMA' then return _G.MMA_ConsideredTarget() end
        if self.LaneClearOrbText == 'SAC:Reborn' then return _G.AutoCarry.Crosshair:GetTarget() end
        if self.LaneClearOrbText == 'SxOrb' then return SxOrb:GetTarget() end
    end
end