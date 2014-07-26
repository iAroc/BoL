----------------------
-------- SxOrb -------
----------------------
class "SxOrb"
function SxOrb:__init()
	self.IsBasicAttack = {["frostarrow"] = true,["CaitlynHeadshotMissile"] = true,["QuinnWEnhanced"] = true,["TrundleQ"] = true,["XenZhaoThrust"] = true,["XenZhaoThrust2"] = true,["XenZhaoThrust3"] = true,["GarenSlash2"] = true,["RenektonExecute"] = true,["RenektonSuperExecute"] = true,["KennenMegaProc"] = true,}
	self.projectilespeeds = {["Velkoz"]= 2000,["TeemoMushroom"] = math.huge,["TestCubeRender"] = math.huge ,["Xerath"] = 2000.0000 ,["Kassadin"] = math.huge ,["Rengar"] = math.huge ,["Thresh"] = 1000.0000 ,["Ziggs"] = 1500.0000 ,["ZyraPassive"] = 1500.0000 ,["ZyraThornPlant"] = 1500.0000 ,["KogMaw"] = 1800.0000 ,["HeimerTBlue"] = 1599.3999 ,["EliseSpider"] = 500.0000 ,["Skarner"] = 500.0000 ,["ChaosNexus"] = 500.0000 ,["Katarina"] = 467.0000 ,["Riven"] = 347.79999 ,["SightWard"] = 347.79999 ,["HeimerTYellow"] = 1599.3999 ,["Ashe"] = 2000.0000 ,["VisionWard"] = 2000.0000 ,["TT_NGolem2"] = math.huge ,["ThreshLantern"] = math.huge ,["TT_Spiderboss"] = math.huge ,["OrderNexus"] = math.huge ,["Soraka"] = 1000.0000 ,["Jinx"] = 2750.0000 ,["TestCubeRenderwCollision"] = 2750.0000 ,["Red_Minion_Wizard"] = 650.0000 ,["JarvanIV"] = 20.0000 ,["Blue_Minion_Wizard"] = 650.0000 ,["TT_ChaosTurret2"] = 1200.0000 ,["TT_ChaosTurret3"] = 1200.0000 ,["TT_ChaosTurret1"] = 1200.0000 ,["ChaosTurretGiant"] = 1200.0000 ,["Dragon"] = 1200.0000 ,["LuluSnowman"] = 1200.0000 ,["Worm"] = 1200.0000 ,["ChaosTurretWorm"] = 1200.0000 ,["TT_ChaosInhibitor"] = 1200.0000 ,["ChaosTurretNormal"] = 1200.0000 ,["AncientGolem"] = 500.0000 ,["ZyraGraspingPlant"] = 500.0000 ,["HA_AP_OrderTurret3"] = 1200.0000 ,["HA_AP_OrderTurret2"] = 1200.0000 ,["Tryndamere"] = 347.79999 ,["OrderTurretNormal2"] = 1200.0000 ,["Singed"] = 700.0000 ,["OrderInhibitor"] = 700.0000 ,["Diana"] = 347.79999 ,["HA_FB_HealthRelic"] = 347.79999 ,["TT_OrderInhibitor"] = 347.79999 ,["GreatWraith"] = 750.0000 ,["Yasuo"] = 347.79999 ,["OrderTurretDragon"] = 1200.0000 ,["OrderTurretNormal"] = 1200.0000 ,["LizardElder"] = 500.0000 ,["HA_AP_ChaosTurret"] = 1200.0000 ,["Ahri"] = 1750.0000 ,["Lulu"] = 1450.0000 ,["ChaosInhibitor"] = 1450.0000 ,["HA_AP_ChaosTurret3"] = 1200.0000 ,["HA_AP_ChaosTurret2"] = 1200.0000 ,["ChaosTurretWorm2"] = 1200.0000 ,["TT_OrderTurret1"] = 1200.0000 ,["TT_OrderTurret2"] = 1200.0000 ,["TT_OrderTurret3"] = 1200.0000 ,["LuluFaerie"] = 1200.0000 ,["HA_AP_OrderTurret"] = 1200.0000 ,["OrderTurretAngel"] = 1200.0000 ,["YellowTrinketUpgrade"] = 1200.0000 ,["MasterYi"] = math.huge ,["Lissandra"] = 2000.0000 ,["ARAMOrderTurretNexus"] = 1200.0000 ,["Draven"] = 1700.0000 ,["FiddleSticks"] = 1750.0000 ,["SmallGolem"] = math.huge ,["ARAMOrderTurretFront"] = 1200.0000 ,["ChaosTurretTutorial"] = 1200.0000 ,["NasusUlt"] = 1200.0000 ,["Maokai"] = math.huge ,["Wraith"] = 750.0000 ,["Wolf"] = math.huge ,["Sivir"] = 1750.0000 ,["Corki"] = 2000.0000 ,["Janna"] = 1200.0000 ,["Nasus"] = math.huge ,["Golem"] = math.huge ,["ARAMChaosTurretFront"] = 1200.0000 ,["ARAMOrderTurretInhib"] = 1200.0000 ,["LeeSin"] = math.huge ,["HA_AP_ChaosTurretTutorial"] = 1200.0000 ,["GiantWolf"] = math.huge ,["HA_AP_OrderTurretTutorial"] = 1200.0000 ,["YoungLizard"] = 750.0000 ,["Jax"] = 400.0000 ,["LesserWraith"] = math.huge ,["Blitzcrank"] = math.huge ,["ARAMChaosTurretInhib"] = 1200.0000 ,["Shen"] = 400.0000 ,["Nocturne"] = math.huge ,["Sona"] = 1500.0000 ,["ARAMChaosTurretNexus"] = 1200.0000 ,["YellowTrinket"] = 1200.0000 ,["OrderTurretTutorial"] = 1200.0000 ,["Caitlyn"] = 2500.0000 ,["Trundle"] = 347.79999 ,["Malphite"] = 1000.0000 ,["Mordekaiser"] = math.huge ,["ZyraSeed"] = math.huge ,["Vi"] = 1000.0000 ,["Tutorial_Red_Minion_Wizard"] = 650.0000 ,["Renekton"] = math.huge ,["Anivia"] = 1400.0000 ,["Fizz"] = math.huge ,["Heimerdinger"] = 1500.0000 ,["Evelynn"] = 467.0000 ,["Rumble"] = 347.79999 ,["Leblanc"] = 1700.0000 ,["Darius"] = math.huge ,["OlafAxe"] = math.huge ,["Viktor"] = 2300.0000 ,["XinZhao"] = 20.0000 ,["Orianna"] = 1450.0000 ,["Vladimir"] = 1400.0000 ,["Nidalee"] = 1750.0000 ,["Tutorial_Red_Minion_Basic"] = math.huge ,["ZedShadow"] = 467.0000 ,["Syndra"] = 1800.0000 ,["Zac"] = 1000.0000 ,["Olaf"] = 347.79999 ,["Veigar"] = 1100.0000 ,["Twitch"] = 2500.0000 ,["Alistar"] = math.huge ,["Akali"] = 467.0000 ,["Urgot"] = 1300.0000 ,["Leona"] = 347.79999 ,["Talon"] = math.huge ,["Karma"] = 1500.0000 ,["Jayce"] = 347.79999 ,["Galio"] = 1000.0000 ,["Shaco"] = math.huge ,["Taric"] = math.huge ,["TwistedFate"] = 1500.0000 ,["Varus"] = 2000.0000 ,["Garen"] = 347.79999 ,["Swain"] = 1600.0000 ,["Vayne"] = 2000.0000 ,["Fiora"] = 467.0000 ,["Quinn"] = 2000.0000 ,["Kayle"] = math.huge ,["Blue_Minion_Basic"] = math.huge ,["Brand"] = 2000.0000 ,["Teemo"] = 1300.0000 ,["Amumu"] = 500.0000 ,["Annie"] = 1200.0000 ,["Odin_Blue_Minion_caster"] = 1200.0000 ,["Elise"] = 1600.0000 ,["Nami"] = 1500.0000 ,["Poppy"] = 500.0000 ,["AniviaEgg"] = 500.0000 ,["Tristana"] = 2250.0000 ,["Graves"] = 3000.0000 ,["Morgana"] = 1600.0000 ,["Gragas"] = math.huge ,["MissFortune"] = 2000.0000 ,["Warwick"] = math.huge ,["Cassiopeia"] = 1200.0000 ,["Tutorial_Blue_Minion_Wizard"] = 650.0000 ,["DrMundo"] = math.huge ,["Volibear"] = 467.0000 ,["Irelia"] = 467.0000 ,["Odin_Red_Minion_Caster"] = 650.0000 ,["Lucian"] = 2800.0000 ,["Yorick"] = math.huge ,["RammusPB"] = math.huge ,["Red_Minion_Basic"] = math.huge ,["Udyr"] = 467.0000 ,["MonkeyKing"] = 20.0000 ,["Tutorial_Blue_Minion_Basic"] = math.huge ,["Kennen"] = 1600.0000 ,["Nunu"] = 500.0000 ,["Ryze"] = 2400.0000 ,["Zed"] = 467.0000 ,["Nautilus"] = 1000.0000 ,["Gangplank"] = 1000.0000 ,["Lux"] = 1600.0000 ,["Sejuani"] = 500.0000 ,["Ezreal"] = 2000.0000 ,["OdinNeutralGuardian"] = 1800.0000 ,["Khazix"] = 500.0000 ,["Sion"] = math.huge ,["Aatrox"] = 347.79999 ,["Hecarim"] = 500.0000 ,["Pantheon"] = 20.0000 ,["Shyvana"] = 467.0000 ,["Zyra"] = 1700.0000 ,["Karthus"] = 1200.0000 ,["Rammus"] = math.huge ,["Zilean"] = 1200.0000 ,["Chogath"] = 500.0000 ,["Malzahar"] = 2000.0000 ,["YorickRavenousGhoul"] = 347.79999 ,["YorickSpectralGhoul"] = 347.79999 ,["JinxMine"] = 347.79999 ,["YorickDecayedGhoul"] = 347.79999 ,["XerathArcaneBarrageLauncher"] = 347.79999 ,["Odin_SOG_Order_Crystal"] = 347.79999 ,["TestCube"] = 347.79999 ,["ShyvanaDragon"] = math.huge ,["FizzBait"] = math.huge ,["Blue_Minion_MechMelee"] = math.huge ,["OdinQuestBuff"] = math.huge ,["TT_Buffplat_L"] = math.huge ,["TT_Buffplat_R"] = math.huge ,["KogMawDead"] = math.huge ,["TempMovableChar"] = math.huge ,["Lizard"] = 500.0000 ,["GolemOdin"] = math.huge ,["OdinOpeningBarrier"] = math.huge ,["TT_ChaosTurret4"] = 500.0000 ,["TT_Flytrap_A"] = 500.0000 ,["TT_NWolf"] = math.huge ,["OdinShieldRelic"] = math.huge ,["LuluSquill"] = math.huge ,["redDragon"] = math.huge ,["MonkeyKingClone"] = math.huge ,["Odin_skeleton"] = math.huge ,["OdinChaosTurretShrine"] = 500.0000 ,["Cassiopeia_Death"] = 500.0000 ,["OdinCenterRelic"] = 500.0000 ,["OdinRedSuperminion"] = math.huge ,["JarvanIVWall"] = math.huge ,["ARAMOrderNexus"] = math.huge ,["Red_Minion_MechCannon"] = 1200.0000 ,["OdinBlueSuperminion"] = math.huge ,["SyndraOrbs"] = math.huge ,["LuluKitty"] = math.huge ,["SwainNoBird"] = math.huge ,["LuluLadybug"] = math.huge ,["CaitlynTrap"] = math.huge ,["TT_Shroom_A"] = math.huge ,["ARAMChaosTurretShrine"] = 500.0000 ,["Odin_Windmill_Propellers"] = 500.0000 ,["TT_NWolf2"] = math.huge ,["OdinMinionGraveyardPortal"] = math.huge ,["SwainBeam"] = math.huge ,["Summoner_Rider_Order"] = math.huge ,["TT_Relic"] = math.huge ,["odin_lifts_crystal"] = math.huge ,["OdinOrderTurretShrine"] = 500.0000 ,["SpellBook1"] = 500.0000 ,["Blue_Minion_MechCannon"] = 1200.0000 ,["TT_ChaosInhibitor_D"] = 1200.0000 ,["Odin_SoG_Chaos"] = 1200.0000 ,["TrundleWall"] = 1200.0000 ,["HA_AP_HealthRelic"] = 1200.0000 ,["OrderTurretShrine"] = 500.0000 ,["OriannaBall"] = 500.0000 ,["ChaosTurretShrine"] = 500.0000 ,["LuluCupcake"] = 500.0000 ,["HA_AP_ChaosTurretShrine"] = 500.0000 ,["TT_NWraith2"] = 750.0000 ,["TT_Tree_A"] = 750.0000 ,["SummonerBeacon"] = 750.0000 ,["Odin_Drill"] = 750.0000 ,["TT_NGolem"] = math.huge ,["AramSpeedShrine"] = math.huge ,["OriannaNoBall"] = math.huge ,["Odin_Minecart"] = math.huge ,["Summoner_Rider_Chaos"] = math.huge ,["OdinSpeedShrine"] = math.huge ,["TT_SpeedShrine"] = math.huge ,["odin_lifts_buckets"] = math.huge ,["OdinRockSaw"] = math.huge ,["OdinMinionSpawnPortal"] = math.huge ,["SyndraSphere"] = math.huge ,["Red_Minion_MechMelee"] = math.huge ,["SwainRaven"] = math.huge ,["crystal_platform"] = math.huge ,["MaokaiSproutling"] = math.huge ,["Urf"] = math.huge ,["TestCubeRender10Vision"] = math.huge ,["MalzaharVoidling"] = 500.0000 ,["GhostWard"] = 500.0000 ,["MonkeyKingFlying"] = 500.0000 ,["LuluPig"] = 500.0000 ,["AniviaIceBlock"] = 500.0000 ,["TT_OrderInhibitor_D"] = 500.0000 ,["Odin_SoG_Order"] = 500.0000 ,["RammusDBC"] = 500.0000 ,["FizzShark"] = 500.0000 ,["LuluDragon"] = 500.0000 ,["OdinTestCubeRender"] = 500.0000 ,["TT_Tree1"] = 500.0000 ,["ARAMOrderTurretShrine"] = 500.0000 ,["Odin_Windmill_Gears"] = 500.0000 ,["ARAMChaosNexus"] = 500.0000 ,["TT_NWraith"] = 750.0000 ,["TT_OrderTurret4"] = 500.0000 ,["Odin_SOG_Chaos_Crystal"] = 500.0000 ,["OdinQuestIndicator"] = 500.0000 ,["JarvanIVStandard"] = 500.0000 ,["TT_DummyPusher"] = 500.0000 ,["OdinClaw"] = 500.0000 ,["EliseSpiderling"] = 2000.0000 ,["QuinnValor"] = math.huge ,["UdyrTigerUlt"] = math.huge ,["UdyrTurtleUlt"] = math.huge ,["UdyrUlt"] = math.huge ,["UdyrPhoenixUlt"] = math.huge ,["ShacoBox"] = 1500.0000 ,["HA_AP_Poro"] = 1500.0000 ,["AnnieTibbers"] = math.huge ,["UdyrPhoenix"] = math.huge ,["UdyrTurtle"] = math.huge ,["UdyrTiger"] = math.huge ,["HA_AP_OrderShrineTurret"] = 500.0000 ,["HA_AP_Chains_Long"] = 500.0000 ,["HA_AP_BridgeLaneStatue"] = 500.0000 ,["HA_AP_ChaosTurretRubble"] = 500.0000 ,["HA_AP_PoroSpawner"] = 500.0000 ,["HA_AP_Cutaway"] = 500.0000 ,["HA_AP_Chains"] = 500.0000 ,["ChaosInhibitor_D"] = 500.0000 ,["ZacRebirthBloblet"] = 500.0000 ,["OrderInhibitor_D"] = 500.0000 ,["Nidalee_Spear"] = 500.0000 ,["Nidalee_Cougar"] = 500.0000 ,["TT_Buffplat_Chain"] = 500.0000 ,["WriggleLantern"] = 500.0000 ,["TwistedLizardElder"] = 500.0000 ,["RabidWolf"] = math.huge ,["HeimerTGreen"] = 1599.3999 ,["HeimerTRed"] = 1599.3999 ,["ViktorFF"] = 1599.3999 ,["TwistedGolem"] = math.huge ,["TwistedSmallWolf"] = math.huge ,["TwistedGiantWolf"] = math.huge ,["TwistedTinyWraith"] = 750.0000 ,["TwistedBlueWraith"] = 750.0000 ,["TwistedYoungLizard"] = 750.0000 ,["Red_Minion_Melee"] = math.huge ,["Blue_Minion_Melee"] = math.huge ,["Blue_Minion_Healer"] = 1000.0000 ,["Ghast"] = 750.0000 ,["blueDragon"] = 800.0000 ,["Red_Minion_MechRange"] = 3000.0000,}
	self.ResetSpells = {["PowerFist"]=true,["DariusNoxianTacticsONH"] = true,["Takedown"] = true,["Ricochet"] = true,["BlindingDart"] = false,["VayneTumble"] = true,["JaxEmpowerTwo"] = true,["MordekaiserMaceOfSpades"] = true,["SiphoningStrikeNew"] = true,["RengarQ"] = true,["YorickSpectral"] = true,["ViE"] = true,["GarenSlash3"] = true,["HecarimRamp"] = true,["XenZhaoComboTarget"] = true,["LeonaShieldOfDaybreak"] = true,["TalonNoxianDiplomacy"] = true,["TrundleTrollSmash"] = true,["VolibearQ"] = true,["PoppyDevastatingBlow"] = true,}
	hitboxes = {['RecItemsCLASSIC'] = 65, ['TeemoMushroom'] = 50.0, ['TestCubeRender'] = 65, ['Xerath'] = 65, ['Kassadin'] = 65, ['Rengar'] = 65, ['Thresh'] = 55.0, ['RecItemsTUTORIAL'] = 65, ['Ziggs'] = 55.0, ['ZyraPassive'] = 20.0, ['ZyraThornPlant'] = 20.0, ['KogMaw'] = 65, ['HeimerTBlue'] = 35.0, ['EliseSpider'] = 65, ['Skarner'] = 80.0, ['ChaosNexus'] = 65, ['Katarina'] = 65, ['Riven'] = 65, ['SightWard'] = 1, ['HeimerTYellow'] = 35.0, ['Ashe'] = 65, ['VisionWard'] = 1, ['TT_NGolem2'] = 80.0, ['ThreshLantern'] = 65, ['RecItemsCLASSICMap10'] = 65, ['RecItemsODIN'] = 65, ['TT_Spiderboss'] = 200.0, ['RecItemsARAM'] = 65, ['OrderNexus'] = 65, ['Soraka'] = 65, ['Jinx'] = 65, ['TestCubeRenderwCollision'] = 65, ['Red_Minion_Wizard'] = 48.0, ['JarvanIV'] = 65, ['Blue_Minion_Wizard'] = 48.0, ['TT_ChaosTurret2'] = 88.4, ['TT_ChaosTurret3'] = 88.4, ['TT_ChaosTurret1'] = 88.4, ['ChaosTurretGiant'] = 88.4, ['Dragon'] = 100.0, ['LuluSnowman'] = 50.0, ['Worm'] = 100.0, ['ChaosTurretWorm'] = 88.4, ['TT_ChaosInhibitor'] = 65, ['ChaosTurretNormal'] = 88.4, ['AncientGolem'] = 100.0, ['ZyraGraspingPlant'] = 20.0, ['HA_AP_OrderTurret3'] = 88.4, ['HA_AP_OrderTurret2'] = 88.4, ['Tryndamere'] = 65, ['OrderTurretNormal2'] = 88.4, ['Singed'] = 65, ['OrderInhibitor'] = 65, ['Diana'] = 65, ['HA_FB_HealthRelic'] = 65, ['TT_OrderInhibitor'] = 65, ['GreatWraith'] = 80.0, ['Yasuo'] = 65, ['OrderTurretDragon'] = 88.4, ['OrderTurretNormal'] = 88.4, ['LizardElder'] = 65.0, ['HA_AP_ChaosTurret'] = 88.4, ['Ahri'] = 65, ['Lulu'] = 65, ['ChaosInhibitor'] = 65, ['HA_AP_ChaosTurret3'] = 88.4, ['HA_AP_ChaosTurret2'] = 88.4, ['ChaosTurretWorm2'] = 88.4, ['TT_OrderTurret1'] = 88.4, ['TT_OrderTurret2'] = 88.4, ['TT_OrderTurret3'] = 88.4, ['LuluFaerie'] = 65, ['HA_AP_OrderTurret'] = 88.4, ['OrderTurretAngel'] = 88.4, ['YellowTrinketUpgrade'] = 1, ['MasterYi'] = 65, ['Lissandra'] = 65, ['ARAMOrderTurretNexus'] = 88.4, ['Draven'] = 65, ['FiddleSticks'] = 65, ['SmallGolem'] = 80.0, ['ARAMOrderTurretFront'] = 88.4, ['ChaosTurretTutorial'] = 88.4, ['NasusUlt'] = 80.0, ['Maokai'] = 80.0, ['Wraith'] = 50.0, ['Wolf'] = 50.0, ['Sivir'] = 65, ['Corki'] = 65, ['Janna'] = 65, ['Nasus'] = 80.0, ['Golem'] = 80.0, ['ARAMChaosTurretFront'] = 88.4, ['ARAMOrderTurretInhib'] = 88.4, ['LeeSin'] = 65, ['HA_AP_ChaosTurretTutorial'] = 88.4, ['GiantWolf'] = 65.0, ['HA_AP_OrderTurretTutorial'] = 88.4, ['YoungLizard'] = 50.0, ['Jax'] = 65, ['LesserWraith'] = 50.0, ['Blitzcrank'] = 80.0, ['brush_D_SR'] = 65, ['brush_E_SR'] = 65, ['brush_F_SR'] = 65, ['brush_C_SR'] = 65, ['brush_A_SR'] = 65, ['brush_B_SR'] = 65, ['ARAMChaosTurretInhib'] = 88.4, ['Shen'] = 65, ['Nocturne'] = 65, ['Sona'] = 65, ['ARAMChaosTurretNexus'] = 88.4, ['YellowTrinket'] = 1, ['OrderTurretTutorial'] = 88.4, ['Caitlyn'] = 65, ['Trundle'] = 65, ['Malphite'] = 80.0, ['Mordekaiser'] = 80.0, ['ZyraSeed'] = 65, ['Vi'] = 50, ['Tutorial_Red_Minion_Wizard'] = 48.0, ['Renekton'] = 80.0, ['Anivia'] = 65, ['Fizz'] = 65, ['Heimerdinger'] = 55.0, ['Evelynn'] = 65, ['Rumble'] = 80.0, ['Leblanc'] = 65, ['Darius'] = 80.0, ['OlafAxe'] = 50.0, ['Viktor'] = 65, ['XinZhao'] = 65, ['Orianna'] = 65, ['Vladimir'] = 65, ['Nidalee'] = 65, ['Tutorial_Red_Minion_Basic'] = 48.0, ['ZedShadow'] = 65, ['Syndra'] = 65, ['Zac'] = 80.0, ['Olaf'] = 65, ['Veigar'] = 55.0, ['Twitch'] = 65, ['Alistar'] = 80.0, ['Akali'] = 65, ['Urgot'] = 80.0, ['Leona'] = 65, ['Talon'] = 65, ['Karma'] = 65, ['Jayce'] = 65, ['Galio'] = 80.0, ['Shaco'] = 65, ['Taric'] = 65, ['TwistedFate'] = 65, ['Varus'] = 65, ['Garen'] = 65, ['Swain'] = 65, ['Vayne'] = 65, ['Fiora'] = 65, ['Quinn'] = 65, ['Kayle'] = 65, ['Blue_Minion_Basic'] = 48.0, ['Brand'] = 65, ['Teemo'] = 55.0, ['Amumu'] = 55.0, ['Annie'] = 55.0, ['Odin_Blue_Minion_caster'] = 48.0, ['Elise'] = 65, ['Nami'] = 65, ['Poppy'] = 55.0, ['AniviaEgg'] = 65, ['Tristana'] = 55.0, ['Graves'] = 65, ['Morgana'] = 65, ['Gragas'] = 80.0, ['MissFortune'] = 65, ['Warwick'] = 65, ['Cassiopeia'] = 65, ['Tutorial_Blue_Minion_Wizard'] = 48.0, ['DrMundo'] = 80.0, ['Volibear'] = 80.0, ['Irelia'] = 65, ['Odin_Red_Minion_Caster'] = 48.0, ['Lucian'] = 65, ['Yorick'] = 80.0, ['RammusPB'] = 65, ['Red_Minion_Basic'] = 48.0, ['Udyr'] = 65, ['MonkeyKing'] = 65, ['Tutorial_Blue_Minion_Basic'] = 48.0, ['Kennen'] = 55.0, ['Nunu'] = 65, ['Ryze'] = 65, ['Zed'] = 65, ['Nautilus'] = 80.0, ['Gangplank'] = 65, ['shopevo'] = 65, ['Lux'] = 65, ['Sejuani'] = 80.0, ['Ezreal'] = 65, ['OdinNeutralGuardian'] = 65, ['Khazix'] = 65, ['Sion'] = 80.0, ['Aatrox'] = 65, ['Hecarim'] = 80.0, ['Pantheon'] = 65, ['Shyvana'] = 50.0, ['Zyra'] = 65, ['Karthus'] = 65, ['Rammus'] = 65, ['Zilean'] = 65, ['Chogath'] = 80.0, ['Malzahar'] = 65, ['YorickRavenousGhoul'] = 1.0, ['YorickSpectralGhoul'] = 1.0, ['JinxMine'] = 65, ['YorickDecayedGhoul'] = 1.0, ['XerathArcaneBarrageLauncher'] = 65, ['Odin_SOG_Order_Crystal'] = 65, ['TestCube'] = 65, ['ShyvanaDragon'] = 80.0, ['FizzBait'] = 65, ['ShopKeeper'] = 65, ['Blue_Minion_MechMelee'] = 65.0, ['OdinQuestBuff'] = 65, ['TT_Buffplat_L'] = 65, ['TT_Buffplat_R'] = 65, ['KogMawDead'] = 65, ['TempMovableChar'] = 48.0, ['Lizard'] = 50.0, ['GolemOdin'] = 80.0, ['OdinOpeningBarrier'] = 65, ['TT_ChaosTurret4'] = 88.4, ['TT_Flytrap_A'] = 65, ['TT_Chains_Order_Periph'] = 65, ['TT_NWolf'] = 65.0, ['ShopMale'] = 65, ['OdinShieldRelic'] = 65, ['TT_Chains_Xaos_Base'] = 65, ['LuluSquill'] = 50.0, ['TT_Shopkeeper'] = 65, ['redDragon'] = 100.0, ['MonkeyKingClone'] = 65, ['Odin_skeleton'] = 65, ['OdinChaosTurretShrine'] = 88.4, ['Cassiopeia_Death'] = 65, ['OdinCenterRelic'] = 48.0, ['Ezreal_cyber_1'] = 65, ['Ezreal_cyber_3'] = 65, ['Ezreal_cyber_2'] = 65, ['OdinRedSuperminion'] = 55.0, ['TT_Speedshrine_Gears'] = 65, ['JarvanIVWall'] = 65, ['DestroyedNexus'] = 65, ['ARAMOrderNexus'] = 65, ['Red_Minion_MechCannon'] = 65.0, ['OdinBlueSuperminion'] = 55.0, ['SyndraOrbs'] = 65, ['LuluKitty'] = 50.0, ['SwainNoBird'] = 65, ['LuluLadybug'] = 50.0, ['CaitlynTrap'] = 65, ['TT_Shroom_A'] = 65, ['ARAMChaosTurretShrine'] = 88.4, ['Odin_Windmill_Propellers'] = 65, ['DestroyedInhibitor'] = 65, ['TT_NWolf2'] = 50.0, ['OdinMinionGraveyardPortal'] = 1.0, ['SwainBeam'] = 65, ['Summoner_Rider_Order'] = 65.0, ['TT_Relic'] = 65, ['odin_lifts_crystal'] = 65, ['OdinOrderTurretShrine'] = 88.4, ['SpellBook1'] = 65, ['Blue_Minion_MechCannon'] = 65.0, ['TT_ChaosInhibitor_D'] = 65, ['Odin_SoG_Chaos'] = 65, ['TrundleWall'] = 65, ['HA_AP_HealthRelic'] = 65, ['OrderTurretShrine'] = 88.4, ['OriannaBall'] = 48.0, ['ChaosTurretShrine'] = 88.4, ['LuluCupcake'] = 50.0, ['HA_AP_ChaosTurretShrine'] = 88.4, ['TT_Chains_Bot_Lane'] = 65, ['TT_NWraith2'] = 50.0, ['TT_Tree_A'] = 65, ['SummonerBeacon'] = 65, ['Odin_Drill'] = 65, ['TT_NGolem'] = 80.0, ['Shop'] = 65, ['AramSpeedShrine'] = 65, ['DestroyedTower'] = 65, ['OriannaNoBall'] = 65, ['Odin_Minecart'] = 65, ['Summoner_Rider_Chaos'] = 65.0, ['OdinSpeedShrine'] = 65, ['TT_Brazier'] = 65, ['TT_SpeedShrine'] = 65, ['odin_lifts_buckets'] = 65, ['OdinRockSaw'] = 65, ['OdinMinionSpawnPortal'] = 1.0, ['SyndraSphere'] = 48.0, ['TT_Nexus_Gears'] = 65, ['Red_Minion_MechMelee'] = 65.0, ['SwainRaven'] = 65, ['crystal_platform'] = 65, ['MaokaiSproutling'] = 48.0, ['Urf'] = 65, ['TestCubeRender10Vision'] = 65, ['MalzaharVoidling'] = 10.0, ['GhostWard'] = 1, ['MonkeyKingFlying'] = 65, ['LuluPig'] = 50.0, ['AniviaIceBlock'] = 65, ['TT_OrderInhibitor_D'] = 65, ['yonkey'] = 65, ['Odin_SoG_Order'] = 65, ['RammusDBC'] = 65, ['FizzShark'] = 65, ['LuluDragon'] = 50.0, ['OdinTestCubeRender'] = 65, ['OdinCrane'] = 65, ['TT_Tree1'] = 65, ['ARAMOrderTurretShrine'] = 88.4, ['TT_Chains_Order_Base'] = 65, ['Odin_Windmill_Gears'] = 65, ['ARAMChaosNexus'] = 65, ['TT_NWraith'] = 50.0, ['TT_OrderTurret4'] = 88.4, ['Odin_SOG_Chaos_Crystal'] = 65, ['TT_SpiderLayer_Web'] = 65, ['OdinQuestIndicator'] = 1.0, ['JarvanIVStandard'] = 65, ['TT_DummyPusher'] = 65, ['OdinClaw'] = 65, ['EliseSpiderling'] = 1.0, ['QuinnValor'] = 65, ['UdyrTigerUlt'] = 65, ['UdyrTurtleUlt'] = 65, ['UdyrUlt'] = 65, ['UdyrPhoenixUlt'] = 65, ['ShacoBox'] = 10, ['HA_AP_Poro'] = 65, ['AnnieTibbers'] = 80.0, ['UdyrPhoenix'] = 65, ['UdyrTurtle'] = 65, ['UdyrTiger'] = 65, ['HA_AP_OrderShrineTurret'] = 88.4, ['HA_AP_OrderTurretRubble'] = 65, ['HA_AP_Chains_Long'] = 65, ['HA_AP_OrderCloth'] = 65, ['HA_AP_PeriphBridge'] = 65, ['HA_AP_BridgeLaneStatue'] = 65, ['HA_AP_ChaosTurretRubble'] = 88.4, ['HA_AP_BannerMidBridge'] = 65, ['HA_AP_PoroSpawner'] = 50.0, ['HA_AP_Cutaway'] = 65, ['HA_AP_Chains'] = 65, ['HA_AP_ShpSouth'] = 65, ['HA_AP_HeroTower'] = 65, ['HA_AP_ShpNorth'] = 65, ['ChaosInhibitor_D'] = 65, ['ZacRebirthBloblet'] = 65, ['OrderInhibitor_D'] = 65, ['Nidalee_Spear'] = 65, ['Nidalee_Cougar'] = 65, ['TT_Buffplat_Chain'] = 65, ['WriggleLantern'] = 1, ['TwistedLizardElder'] = 65.0, ['RabidWolf'] = 65.0, ['HeimerTGreen'] = 50.0, ['HeimerTRed'] = 50.0, ['ViktorFF'] = 65, ['TwistedGolem'] = 80.0, ['TwistedSmallWolf'] = 50.0, ['TwistedGiantWolf'] = 65.0, ['TwistedTinyWraith'] = 50.0, ['TwistedBlueWraith'] = 50.0, ['TwistedYoungLizard'] = 50.0, ['Red_Minion_Melee'] = 48.0, ['Blue_Minion_Melee'] = 48.0, ['Blue_Minion_Healer'] = 48.0, ['Ghast'] = 60.0, ['blueDragon'] = 100.0, ['Red_Minion_MechRange'] = 65.0, ['Test_CubeSphere'] = 65,}
	self.SpellData = {
	["Akali"] =  { [_Q]= {Type = "Targeted", Collision = false, Range = 600, Speed = 1000, Delay = 0.65, Width = 0} },
	["Anivia"] =  { [_E]= {Type = "Targeted", Collision = false, Range = 650, Speed = 1200, Delay = 0.5, Width = 0} },
	["Annie"] =  { [_Q]= {Type = "Targeted", Collision = false, Range = 625, Speed = 1400, Delay = 0.5, Width = 0} },
	["Brand"] =  { [_Q]= {Type = "Linear", Collision = true, Range = 1150, Speed = 1200, Delay = 0.5, Width = 80} },
	["Brand"] =  { [_E]= {Type = "Linear", Collision = false, Range = 900, Speed = 1800, Delay = 0.5, Width = 0} },
	["Cassiopeia"] =  { [_E]= {Type = "Linear", Collision = false, Range = 700, Speed = 1900, Delay = 0.5, Width = 0} },
	["Corki"] =  { [_R]= {Type = "Linear", Collision = true, Range = 1250, Speed = 825, Delay = 0.5, Width = 45} },
	["Mundo"] =  { [_Q]= {Type = "Linear", Collision = true, Range = 1000, Speed = 1500, Delay = 0.5, Width = 75} },
	["Elise"] =  { [_Q]= {Type = "Targeted", Collision = false, Range = 625, Speed = 2200, Delay = 0.5, Width = 0} },
	["Ezreal"] = { [_Q]= {Type = "Linear", Collision = true, Range = 1000, Speed = 2000, Delay = 0.25, Width = 70   } },
	["Fizz"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 550, Speed = math.huge, Delay = 0.25, Width = 0   } },
	["Gankplank"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 625, Speed = 2000, Delay = 0.25, Width = 0   } },
	["Graves"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 1100, Speed = 900, Delay = 0.25, Width = 10   } },
	["Irilia"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 650, Speed = 2200, Delay = 0, Width = 0   } },
	["Janna"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 600, Speed = 1600, Delay = 0.5, Width = 0   } },
	["JarvanIV"] = { [_Q]= {Type = "Linear", Collision = false, Range = 600, Speed = 1600, Delay = 0.5, Width = 0   } },
	["JarvanIV"] = { [_E]= {Type = "Targeted", Collision = false, Range = 830, Speed = math.huge, Delay = 0.5, Width = 70   } },
	["Jax"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 700, Speed = math.huge, Delay = 0.5, Width = 0   } },
	["Jinx"] = { [_W]= {Type = "Linear", Collision = true, Range = 1400, Speed = 1200, Delay = 0.5, Width = 70   } },
	["Karthus"] = { [_Q]= {Type = "Circle", Collision = false, Range = 870, Speed = math.huge, Delay = 0.5, Width = 150   } },
	["Kassadin"] = { [_Q]= {Type = "Circle", Collision = false, Range = 650, Speed = 1400, Delay = 0.5, Width = 0   } },
	["Katarina"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 675, Speed = 1800, Delay = 0.5, Width = 0   } },
	["Kayle"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 650, Speed = 1500, Delay = 0.5, Width = 0   } },
	["Kennen"] = { [_Q]= {Type = "Linear", Collision = true, Range = 990, Speed = 1700, Delay = 0.5, Width = 50   } },
	["Khazix"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 325, Speed = math.huge, Delay = 0.5, Width = 0   } },
	["KogMaw"] = { [_Q]= {Type = "Linear", Collision = true, Range = 625, Speed = math.huge, Delay = 0.5, Width = 0   } },
	["Leblanc"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 700, Speed = 2000, Delay = 0.5, Width = 0   } },
	["LeeSin"] = { [_Q]= {Type = "Linear", Collision = false, Range = 1000, Speed = 1700, Delay = 0.5, Width = 0   } },
	["Leona"] = { [_E]= {Type = "Linear", Collision = false, Range = 1050, Speed = 2000, Delay = 0.5, Width = 100   } },
	["Lucian"] = { [_Q]= {Type = "Linear", Collision = false, Range = 530, Speed = math.huge, Delay = 0.5, Width = 50   } },
	["Malphite"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 625, Speed = 1200, Delay = 0.5, Width = 0   } },
	["MissFortune"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 650, Speed = 1400, Delay = 0.5, Width = 0   } },
	["Nidalee"] = { [_Q]= {Type = "Linear", Collision = true, Range = 1400, Speed = 1300, Delay = 0.5, Width = 50   } },
	["Nunu"] = { [_E]= {Type = "Targeted", Collision = true, Range = 550, Speed = 1000, Delay = 0.5, Width = 0   } },
	["Olaf"] = { [_Q]= {Type = "Linear", Collision = false, Range = 950, Speed = 1600, Delay = 0.5, Width = 80   } },
	["Olaf"] = { [_E]= {Type = "Targeted", Collision = false, Range = 325, Speed = math.huge, Delay = 0.5, Width = 0   } },
	["Pantheon"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 600, Speed = 1500, Delay = 0.5, Width = 0   } },
	["Rengar"] = { [_E]= {Type = "Targeted", Collision = false, Range = 1000, Speed = 1500, Delay = 0.5, Width = 50   } },
	["Rumble"] = { [_E]= {Type = "Linear", Collision = true, Range = 850, Speed = 1200, Delay = 0.5, Width = 50   } },
	["Ryze"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 625, Speed = 1400, Delay = 0.5, Width = 0   } },
	["Ryze"] = { [_W]= {Type = "Targeted", Collision = false, Range = 600, Speed = math.huge, Delay = 0.5, Width = 0   } },
	["Ryze"] = { [_E]= {Type = "Targeted", Collision = false, Range = 600, Speed = 1000, Delay = 0.5, Width = 0   } },
	["Shaco"] = { [_E]= {Type = "Targeted", Collision = false, Range = 625, Speed = 1400, Delay = 0.5, Width = 0   } },
	["Shen"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 475, Speed = 1500, Delay = 0.5, Width = 0   } },
	["Singed"] = { [_E]= {Type = "Targeted", Collision = false, Range = 125, Speed = math.huge, Delay = 0.5, Width = 0   } },
	["Sion"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 550, Speed = 1600, Delay = 0.5, Width = 0   } },
	["Soraka"] = { [_E]= {Type = "Targeted", Collision = false, Range = 725, Speed = math.huge, Delay = 0.5, Width = 0   } },
	["Teemo"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 580, Speed = 1500, Delay = 0.5, Width = 0   } },
	["Urgot"] = { [_Q]= {Type = "Linear", Collision = true, Range = 1000, Speed = 1600, Delay = 0.5, Width = 80   } },
	["Vayne"] = { [_E]= {Type = "Targeted", Collision = false, Range = 450, Speed = 1200, Delay = 0.5, Width = 0   } },
	["Veigar"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 650, Speed = 1500, Delay = 0.5, Width = 0   } },
	["Viktor"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 600, Speed = 1400, Delay = 0.5, Width = 0   } },
	["Vladimir"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 600, Speed = 1400, Delay = 0.5, Width = 0   } },
	["Warwick"] = { [_Q]= {Type = "Targeted", Collision = false, Range = 400, Speed = math.huge, Delay = 0.5, Width = 0   } },
	["Yorick"] = { [_W]= {Type = "Circle", Collision = false, Range = 600, Speed = math.huge, Delay = 0.5, Width = 200   } },
	["Yorick"] = { [_E]= {Type = "Targeted", Collision = false, Range = 550, Speed = math.huge, Delay = 0.5, Width = 200  } },
}
	MyTrueRange = myHero.range + hitboxes[myHero.charName] + 10
	_G.SxOrbMenu = {}
	self.WaitForAA = false
	self.Attackenabled = true
	self.LastAA = 0
	self.NextAA = 0
	self.LastAction = 0
	self.LastDrawTick = 0
	self.Minions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_HEALTH_ASC)
	self.JungleMinions = minionManager(MINION_JUNGLE, 2000, myHero, MINION_SORT_MAXHEALTH_DEC)
	self.OtherMinions = minionManager(MINION_OTHER, 2000, myHero, MINION_SORT_HEALTH_ASC)
	self.MinionAttacks = {}
	self.CastedMinionAttacks = {}
	self.BeforeAttackCallbacks = {}
	self.OnAttackCallbacks = {}
	self.AfterAttackCallbacks = {}
	self.SpellResetCallbacks = {}
	self.MinionTargetStore = {}
	self.KillAbleMinions = {}
	self.BaseWindUpTime = 3
	self.BaseAnimationTime = 0.65
	self.Version = 0.9
	print("<font color=\"#F0Ff8d\"><b>SxOrbWalk:</b></font> <font color=\"#FF0F0F\">Version "..self.Version.." loaded</font>")
	self.LuaSocket = require("socket")
	self.AutoUpdate = {["Host"] = "raw.githubusercontent.com", ["VersionLink"] = "/Superx321/BoL/master/SxOrbWalk.Version", ["ScriptLink"] = "/Superx321/BoL/master/SxOrbWalk.lua"}
	AddTickCallback(function() self:CheckUpdate() end)
	AddTickCallback(function() self:OnTick() end)
	AddTickCallback(function() self:ClearMinionTargetStore() end)
	AddDrawCallback(function() self:OnDraw() end)
	AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
	AddProcessSpellCallback(function(unit, spell) self:GetMinionTargets(unit, spell) end)
end

function SxOrb:CheckUpdate()
	if not self.AutoUpdate["VersionSocket"] then
		self.AutoUpdate["VersionSocket"] = self.LuaSocket.connect("sx-bol.de", 80)
		self.AutoUpdate["VersionSocket"]:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.AutoUpdate["Host"]..self.AutoUpdate["VersionLink"].."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
	end

	if not self.AutoUpdate["ServerVersion"] and self.AutoUpdate["VersionSocket"] then
			self.AutoUpdate["VersionSocket"]:settimeout(0)
			self.AutoUpdate["VersionReceive"], self.AutoUpdate["VersionStatus"] = self.AutoUpdate["VersionSocket"]:receive('*a')
	end

	if not self.AutoUpdate["ServerVersion"] and self.AutoUpdate["VersionSocket"] and self.AutoUpdate["VersionStatus"] ~= 'timeout' and self.AutoUpdate["VersionReceive"] ~= nil then
		self.AutoUpdate["ServerVersion"] = tonumber(string.sub(self.AutoUpdate["VersionReceive"], string.find(self.AutoUpdate["VersionReceive"], "<bols".."cript>")+11, string.find(self.AutoUpdate["VersionReceive"], "</bols".."cript>")-1))
	end

	if self.AutoUpdate["ServerVersion"] and type(self.AutoUpdate["ServerVersion"]) == "number" and self.AutoUpdate["ServerVersion"] > self.Version and not self.AutoUpdate["Finished"] then
		self.AutoUpdate["ScriptSocket"] = self.LuaSocket.connect("sx-bol.de", 80)
		self.AutoUpdate["ScriptSocket"]:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.AutoUpdate["Host"]..self.AutoUpdate["ScriptLink"].."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
		self.AutoUpdate["ScriptReceive"], self.AutoUpdate["ScriptStatus"] = self.AutoUpdate["ScriptSocket"]:receive('*a')
		self.AutoUpdate["ScriptRAW"] = tonumber(string.sub(self.AutoUpdate["ScriptReceive"], string.find(self.AutoUpdate["ScriptReceive"], "<bols".."cript>")+11, string.find(self.AutoUpdate["ScriptReceive"], "</bols".."cript>")-1))
		ScriptFileOpen = io.open(SCRIPT_PATH.._ENV.FILE_NAME, "w+")
		ScriptFileOpen:write(self.AutoUpdate["ScriptRAW"])
		ScriptFileOpen:close()
		self.AutoUpdate["Finished"] = true
		print("<font color=\"#F0Ff8d\"><b>SxOrbWalk:</b></font> <font color=\"#FF0F0F\">New Version("..self.AutoUpdate["ServerVersion"]..") downloaded, load it with F9!</font>")
	end
end

function SxOrb:LoadToMenu(MainMenu, NoMenuKeys)
	if MainMenu then
		self.SxOrbMenu = MainMenu
	else
		self.SxOrbMenu = scriptConfig("SxOrbwalker", "SxOrb")
	end
	_G.SxOrbMenu = self.SxOrbMenu
	self.SxOrbMenu:addSubMenu("General Settings", "generalsettings")
	self.SxOrbMenu.generalsettings:addParam("Enabled", "Enabled", SCRIPT_PARAM_ONOFF, true)
	if VIP_USER and FileExist(LIB_PATH.."Selector.lua") then
		self.SxOrbMenu.generalsettings:addParam("Selector", "Use VIP Selector", SCRIPT_PARAM_ONOFF, false)
	end

	self.SxOrbMenu:addSubMenu("Farm Settings", "farmsettings")
	self.SxOrbMenu.farmsettings:addParam("FarmDelay", "Farm Delay", SCRIPT_PARAM_SLICE, 0, -150, 150)
	self.SxOrbMenu.farmsettings:addParam("WindUpTime", "Extra WindUp Time", SCRIPT_PARAM_SLICE, 0,  -150, 150)
	self.SxOrbMenu.farmsettings:addParam("farmoverharass", "Focus LastHit over Harass", SCRIPT_PARAM_ONOFF, true)
	self.SxOrbMenu.farmsettings:addParam("spellfarm", "Use Spells to secure LastHits", SCRIPT_PARAM_ONOFF, true)

	self.SxOrbMenu:addSubMenu("Mastery Settings", "masterysettings")
	self.SxOrbMenu.masterysettings:addParam("Butcher", "Mastery: Butcher", SCRIPT_PARAM_ONOFF, false)
	self.SxOrbMenu.masterysettings:addParam("Havoc", "Mastery: Havoc", SCRIPT_PARAM_ONOFF, false)
	self.SxOrbMenu.masterysettings:addParam("ArcaneBlade", "Mastery: ArcaneBlade", SCRIPT_PARAM_ONOFF, false)

	if not NoMenuKeys then
		self.SxOrbMenu:addSubMenu("Hotkey Settings", "hotkeysettings")
		self.SxOrbMenu.hotkeysettings:addParam("AutoCarry", "AutoCarry", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		self.SxOrbMenu.hotkeysettings:addParam("MixedMode", "MixedMode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		self.SxOrbMenu.hotkeysettings:addParam("LaneClear", "LaneClear", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
		self.SxOrbMenu.hotkeysettings:addParam("LastHit", "LastHit", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
	end

	self.SxOrbMenu:addSubMenu("Draw Settings", "drawsettings")
	self.SxOrbMenu.drawsettings:addParam("AARange", "Draw AA Range", SCRIPT_PARAM_ONOFF, false)
	self.SxOrbMenu.drawsettings:addParam("MinionHPBar", "Draw LastHit-Line on Minions", SCRIPT_PARAM_ONOFF, false)
	self.SxOrbMenu.drawsettings:addParam("MinionCircle", "Draw LastHit-Circle", SCRIPT_PARAM_ONOFF, false)

	self.SxOrbMenu:addSubMenu("TargetPriority Settings", "targetsettings")
	for i, enemy in pairs(GetEnemyHeroes()) do
		self.SxOrbMenu.targetsettings:addParam(enemy.charName,enemy.charName, SCRIPT_PARAM_SLICE, 1, 1, #GetEnemyHeroes(), 0)
	end
	self.SxOrbMenu.targetsettings:addParam("fap","", SCRIPT_PARAM_INFO, "")
	self.SxOrbMenu.targetsettings:addParam("fap","Higher Number = Higher Focus", SCRIPT_PARAM_INFO, "")
	self.SxOrbMenu.targetsettings:addParam("fap","Means:", SCRIPT_PARAM_INFO, "")
	self.SxOrbMenu.targetsettings:addParam("fap","EnemyAdc = 5", SCRIPT_PARAM_INFO, "")
	self.SxOrbMenu.targetsettings:addParam("fap","EnemyTank = 1", SCRIPT_PARAM_INFO, "")
	self:LoadPriority()

	self.NoMenuKeys = NoMenuKeys
end

function SxOrb:LoadPriority()
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
	local EnemiesFound = 0
	for z=1,#priorityTable.AD_Carry do
		for i=1,#GetEnemyHeroes() do
			if priorityTable.AD_Carry[z] == self.SxOrbMenu.targetsettings._param[i].text then
				self.SxOrbMenu.targetsettings[self.SxOrbMenu.targetsettings._param[i].text] = #GetEnemyHeroes() - EnemiesFound
				EnemiesFound = EnemiesFound + 1
			end
		end
	end

	for z=1,#priorityTable.AP do
		for i=1,#GetEnemyHeroes() do
			if priorityTable.AP[z] == self.SxOrbMenu.targetsettings._param[i].text then
				self.SxOrbMenu.targetsettings[self.SxOrbMenu.targetsettings._param[i].text] = #GetEnemyHeroes() - EnemiesFound
				EnemiesFound = EnemiesFound + 1
			end
		end
	end

	for z=1,#priorityTable.Bruiser do
		for i=1,#GetEnemyHeroes() do
			if priorityTable.Bruiser[z] == self.SxOrbMenu.targetsettings._param[i].text then
				self.SxOrbMenu.targetsettings[self.SxOrbMenu.targetsettings._param[i].text] = #GetEnemyHeroes() - EnemiesFound
				EnemiesFound = EnemiesFound + 1
			end
		end
	end

	for z=1,#priorityTable.Support do
		for i=1,#GetEnemyHeroes() do
			if priorityTable.Support[z] == self.SxOrbMenu.targetsettings._param[i].text then
				self.SxOrbMenu.targetsettings[self.SxOrbMenu.targetsettings._param[i].text] = #GetEnemyHeroes() - EnemiesFound
				EnemiesFound = EnemiesFound + 1
			end
		end
	end

	for z=1,#priorityTable.Tank do
		for i=1,#GetEnemyHeroes() do
			if priorityTable.Tank[z] == self.SxOrbMenu.targetsettings._param[i].text then
				self.SxOrbMenu.targetsettings[self.SxOrbMenu.targetsettings._param[i].text] = #GetEnemyHeroes() - EnemiesFound
				EnemiesFound = EnemiesFound + 1
			end
		end
	end
end

function SxOrb:OnTick()
	if not self.SxOrbMenu.generalsettings.Enabled then return end
	self:UpdateMinions()
	if (self.SxOrbMenu.hotkeysettings and self.SxOrbMenu.hotkeysettings.AutoCarry) or _G.SxOrbMenu.AutoCarry then
		self:CarryMode("AutoCarry")
	end

	if (self.SxOrbMenu.hotkeysettings and self.SxOrbMenu.hotkeysettings.MixedMode) or _G.SxOrbMenu.MixedMode then
		self:CarryMode("MixedMode")
	end

	if (self.SxOrbMenu.hotkeysettings and self.SxOrbMenu.hotkeysettings.LaneClear) or _G.SxOrbMenu.LaneClear then
		self:CarryMode("LaneClear")
	end

	if (self.SxOrbMenu.hotkeysettings and self.SxOrbMenu.hotkeysettings.LastHit) or _G.SxOrbMenu.LastHit then
		self:CarryMode("LastHit")
	end
end

function SxOrb:ClearMinionTargetStore()
	for i, Data in pairs(self.MinionTargetStore) do
		local Source = objManager:GetObjectByNetworkId(self.MinionTargetStore[i].SourceMinion)
		local Target = objManager:GetObjectByNetworkId(self.MinionTargetStore[i].LastTarget)
		if not Source then
			table.remove(self.MinionTargetStore, i)
		else
			if Source.health < 1 then
				table.remove(self.MinionTargetStore, i)
			end
		end
		if not Target then
			table.remove(self.MinionTargetStore, i)
		else
			if Target.health < 1 then
				table.remove(self.MinionTargetStore, i)
			end
		end
	end
end

function SxOrb:UpdateMinions()
	self.Minions:update()
	self.JungleMinions:update()
	self.OtherMinions:update()
end

function SxOrb:CarryMode(Mode)
	if not self.WaitForAA and self:CanAttack() and self.Attackenabled then
		if Mode == "AutoCarry" then
			self:AutoCarry()
		end

		if Mode == "MixedMode" then
			if self.SxOrbMenu.farmsettings.farmoverharass then
				self:LastHit()
				if not self.WaitForAA then self:AutoCarry() end
			else
				self:AutoCarry()
				if not self.WaitForAA then self:LastHit() end
			end
		end

		if Mode == "LaneClear" then
			self:LastHit()
			if not self.WaitForAA then self:LaneClear() end
			if not self.WaitForAA then self:AutoCarry() end
		end

		if Mode == "LastHit" then
			self:LastHit()
		end
	end

	if self:CanMove() and not self.WaitForAA then
		if not self:CanAttack() and self.Attackenabled and self.SxOrbMenu.farmsettings.spellfarm then
			if Mode == "MixedMode" or Mode == "LaneClear" or Mode == "LastHit" then
				for index, minion in pairs(self.Minions.objects) do
					if self:ValidTarget(minion) and self.MinionToLastHit ~= minion then
						local NextAAArriveTick = (self.LastAA + self:GetAnimationTime()) + self:GetFlyTicks(minion) - self:GetLatency() - self:GetWindUpTime()
						DmgToMinion, DmgToMinion2 = self:GetPredictDmg(minion, NextAAArriveTick)
						if DmgToMinion + DmgToMinion2 > minion.health then
							self:KillMinionWithSpell(minion)
						end
					end
				end
			end
		end
		self:OrbWalk()
	end
end

function SxOrb:KillMinionWithSpell(minion)
	local GetDmgTable = { [0] = "Q", [1] = "W", [2] = "E", [3] = "R"}
	if self.SpellData and self.SpellData[myHero.charName] then
		for i=0,4 do
			if self.SpellData[myHero.charName][i] then
				if not self.SpellData[myHero.charName][i]["Collision"] then
					DmgToMinion, DmgToMinion2 = self:GetPredictDmg(minion, self.SpellData[myHero.charName][i]["Delay"] + (GetDistance(minion)/self.SpellData[myHero.charName][i]["Speed"]))
					Dmg, Dmgtype = getDmg(GetDmgTable[i], minion, myHero)
					if Dmg > (minion.health - DmgToMinion) then
						CastSpell(i, minion)
						self.BlockedMinion = minion
						self.WaitForAA = false
					end
				else
					-- Collision scheiss
				end
			end
		end
	end
end

function SxOrb:AutoCarry()
	local Target = self:GetTarget()
	if Target and self:ValidTarget(Target) then
		self:StartAttack(Target, true)
	end
end

function SxOrb:LastHit()
	for index, minion in pairs(self.Minions.objects) do
		if self:ValidTarget(minion) then
			if self:IsKillAbleMinion(minion) then break end
		end
	end
end

function SxOrb:LaneClear()
	if self.WaitForMinion and self:ValidTarget(self.WaitForMinion) then
		if self:IsKillAbleMinion(self.WaitForMinion) then self.WaitForMinion = false end
	else
		self.WaitForMinion = false
	end

	for index, minion in pairs(self.Minions.objects) do
		if self:ValidTarget(minion) and not self.WaitForMinion then
			local MyAADmg = self:CalcAADmg(minion)
			local MyArriveTick = GetTickCount() + self:GetFlyTicks(minion)
			local MyArriveTick2 = MyArriveTick + self:GetAnimationTime() + self:GetFlyTicks(minion) + 70
			DmgToMinion, DmgToMinion2 = self:GetPredictDmg(minion, MyArriveTick2)

			if DmgToMinion + DmgToMinion2 > minion.health then
				self.WaitForMinion = minion
				break
			else
				if DmgToMinion > 0 then CalcDmg = (MyAADmg * 1.1) + DmgToMinion else CalcDmg = MyAADmg end
				if CalcDmg < minion.health then
					self:StartAttack(minion)
					break
				else
					self.WaitForMinion = minion
				end
			end
		end
	end

	for index, minion in pairs(self.JungleMinions.objects) do
		if self:ValidTarget(minion) then
			self:StartAttack(minion)
			break
		end
	end

	for index, minion in pairs(self.OtherMinions.objects) do
		if self:ValidTarget(minion) then
			self:StartAttack(minion)
			break
		end
	end
end

function SxOrb:IsKillAbleMinion(minion)
	local MyAADmg = self:CalcAADmg(minion)
	local MyArriveTick = GetTickCount() + self:GetFlyTicks(minion) - self:GetLatency()
	local DmgToMinion = self:GetPredictDmg(minion, MyArriveTick)
	if (MyAADmg + DmgToMinion) > minion.health and DmgToMinion < minion.health then
		self:StartAttack(minion)
		return true
	end
	return false
end

function SxOrb:GetPredictDmg(minion, endtick) -- minus = früher, plus = später
	local MyArriveTick = endtick
	local StartTick = GetTickCount()
	local DmgToMinion = 0
	local DmgToMinion2 = 0
	for i = 1, #self.MinionTargetStore do
		if minion.networkID == self.MinionTargetStore[i].LastTarget then
			local Source = objManager:GetObjectByNetworkId(self.MinionTargetStore[i].SourceMinion)
			local Target = objManager:GetObjectByNetworkId(self.MinionTargetStore[i].LastTarget)
			if Source and Source.valid and Target and Target.valid then
				local FlyTime = GetDistance(Source, Target) / self.MinionTargetStore[i].ProjectileSpeed
				local NextAAStart = self.MinionTargetStore[i].LastAttack + (self.MinionTargetStore[i].LastAttackCD * 1000)
				if Source.charName:lower():find("wizard") then Extra = 10 else Extra = 30 end
				local ArriveTick = self.MinionTargetStore[i].LastAttack + math.round((FlyTime + self.MinionTargetStore[i].LastWindUpTime)*1000,0) + Extra
				local ArriveTick2 = NextAAStart + math.round((FlyTime + self.MinionTargetStore[i].LastWindUpTime)*1000,0) + Extra

				if ArriveTick > StartTick and ArriveTick < MyArriveTick then
					DmgToMinion = DmgToMinion + self.MinionTargetStore[i].SpellDmg
				end

				if ArriveTick2 > StartTick and ArriveTick2 < MyArriveTick then
					DmgToMinion2 = DmgToMinion2 + self.MinionTargetStore[i].SpellDmg
				end
			end
		end
	end
	if minion.charName:lower():find("cannon") and DmgToMinion > 20 then DmgToMinion = DmgToMinion - 20 end
	return DmgToMinion, DmgToMinion2
end

function SxOrb:GetFlyTicks(Target)
	-- + = Shoot earlier, - = Shoot later
	return math.round((((GetDistance(myHero, Target) / (self.projectilespeeds[myHero.charName])) + (1 / (myHero.attackSpeed * self.BaseWindUpTime)))*1000),0)
end

function SxOrb:StartAttack(Target, NoDelay)
--~ 	if not (self.BlockedMinion and self:ValidTarget(self.BlockedMinion)) then
		table.insert(self.KillAbleMinions, Target)
		self.BlockedMinion = nil
		self.WaitForAA = true
		self.LastAA = GetTickCount() + self:GetWindUpTime()
		self:Attack(Target)
		self:BeforeAttack(Target)
		self.MinionToLastHit = Target
		if NoDelay then
			self:Attack(Target)
		else
			DelayAction(function() self:Attack(Target) end, 0.07)
		end
--~ 	end
end

function SxOrb:Attack(Target)
	myHero:Attack(Target)
	if self:ValidTarget(Target) and self.WaitForAA then
		DelayAction(function() self:Attack(Target) end, 0)
	else
		self.WaitForAA = false
	end
end

function SxOrb:OrbWalk()
	MouseMove = Vector(myHero) + (Vector(mousePos) - Vector(myHero)):normalized() * 500
	myHero:MoveTo(MouseMove.x, MouseMove.z)
end

function SxOrb:CheckAACancel(AANetwordID)
	local AAObj = objManager:GetObjectByNetworkId(AANetwordID)
	if AAObj and AAObj.valid then
		--
	else
		if not self:CanMove(100) then
			DelayAction(function() self:CheckAACancel(AANetwordID) end, 0)
		else
			self.WaitForAA = false
		end
	end
end

function SxOrb:OnDraw()
	if self.SxOrbMenu.drawsettings.AARange then
		self:CircleDraw(myHero.x, myHero.y, myHero.z, MyTrueRange, 4294967295)
	end

	if self.SxOrbMenu.drawsettings.MinionHPBar then
		self:DrawMinionHPBar()
	end

	if self.SxOrbMenu.drawsettings.MinionCircle then
		for i=1,#self.KillAbleMinions do
			if self:ValidTarget(self.KillAbleMinions[i]) then
				self:CircleDraw(self.KillAbleMinions[i].x, self.KillAbleMinions[i].y, self.KillAbleMinions[i].z, 150, 4294967295)
			end
		end
	end


--~ 	if self.WaitForMinion then
--~ 		self:CircleDraw(self.WaitForMinion.x, self.WaitForMinion.y, self.WaitForMinion.z, 100, 4294967295)
--~ 	end

--~ 	if self.TrackMinion then
--~ 		local Source = objManager:GetObjectByNetworkId(self.TrackMinion.SourceMinion)
--~ 		local Target = objManager:GetObjectByNetworkId(self.TrackMinion.LastTarget)
--~ 		if Target and Target.valid and Target.health > 0 then
--~ 			self:CircleDraw(Source.x, Source.y, Source.z, 100, 4294967295)
--~ 			local FlyTime = GetDistance(Source, Target) / self.TrackMinion.ProjectileSpeed
--~ 			local ArriveTick = self.TrackMinion.LastAttack + math.round((FlyTime + self.TrackMinion.LastWindUpTime)*1000,0)
--~ 			if GetTickCount() > ArriveTick - 70 - self:GetLatency() then
--~ 				self:CircleDraw(Target.x, Target.y, Target.z, 100, 4294967295)
--~ 			end

--~ 			if GetTickCount() > ArriveTick + 500 then
--~ 				self.TrackMinion = nil
--~ 			end
--~ 		else
--~ 			self.TrackMinion = nil
--~ 		end
--~ 	end
end

function SxOrb:DisableAttacks()
	self.Attackenabled = false
end

function SxOrb:EnableAttacks()
	self.Attackenabled = false
end

function SxOrb:BeforeAttack(target)
	local result = false
	for i, cb in ipairs(self.BeforeAttackCallbacks) do
		local ri = cb(target)
		if ri then
			result = true
		end
	end
	return result
end

function SxOrb:RegisterBeforeAttackCallback(f)
	table.insert(self.BeforeAttackCallbacks, f)
end

function SxOrb:OnAttack(target)
	for i, cb in ipairs(self.OnAttackCallbacks) do
		cb(target)
	end
end

function SxOrb:RegisterOnAttackCallback(f)
	table.insert(self.OnAttackCallbacks, f)
end

function SxOrb:AfterAttack(target)
	for i, cb in ipairs(self.AfterAttackCallbacks) do
		cb(target)
	end
end

function SxOrb:RegisterAfterAttackCallback(f)
	table.insert(self.AfterAttackCallbacks, f)
end

function SxOrb:SpellResetCallback()
	for i, cb in ipairs(self.SpellResetCallbacks) do
		cb()
	end
end

function SxOrb:RegisterSpellResetCallback(f)
	table.insert(self.SpellResetCallbacks, f)
end

function SxOrb:DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
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

function SxOrb:DrawCircle2(x, y, z, radius, color)
 local vPos1 = Vector(x, y, z)
 local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
 local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
 local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
 if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
  self:DrawCircleNextLvl(x, y, z, radius, 1, color, 75)
 end
end

function SxOrb:CircleDraw(x,y,z,radius, color)
	self:DrawCircle2(x, y, z, radius, color)
end

function SxOrb:CalcAADmg(minion)
	local RawDMG = myHero:CalcDamage(minion)
	RawDMG = RawDMG + self:BonusDamage(minion)
	if self.SxOrbMenu.masterysettings.Havoc then
		RawDMG = RawDMG*1.03
	end
	if self.SxOrbMenu.masterysettings.Butcher then
		RawDMG = RawDMG + 2
	end
	if self.SxOrbMenu.masterysettings.ArcaneBlade then
		RawDMG = RawDMG + myHero.ap * 0.05
	end
	return RawDMG
end

function SxOrb:BonusDamage(minion) -- C&P from SOW
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

function SxOrb:GetAnimationTime()
	return (1 / (myHero.attackSpeed * self.BaseAnimationTime)*1000)
end

function SxOrb:GetWindUpTime()
	return (1 / (myHero.attackSpeed * self.BaseWindUpTime)*1000)
end

function SxOrb:GetLatency()
	return GetLatency()/2
end

function SxOrb:CanAttack()
	if GetTickCount() > (self.LastAA + self:GetAnimationTime() - self:GetLatency()) then
		return true
	else
		return false
	end
end

function SxOrb:CanMove()
	if GetTickCount() > (self.LastAction + self:GetWindUpTime() - self:GetLatency() + self.SxOrbMenu.farmsettings.WindUpTime + 10) then
		return true
	else
		return false
	end
end

function SxOrb:OnProcessSpell(unit, spell)
	if unit.isMe then
		self.WaitForAA = false
		self.LastAction = GetTickCount()
		if spell.target then self.LastTarget = spell.target end
		if (spell.name:lower():find("attack") or self.IsBasicAttack[spell.name]) then
			self.LastAA = GetTickCount()
			self.BaseAnimationTime = 1 / (spell.animationTime * myHero.attackSpeed)
			self.BaseWindUpTime = 1 / (spell.windUpTime * myHero.attackSpeed)
			self:CheckAACancel(spell.projectileID)
			self:OnAttack(self.LastTarget)
			DelayAction(function() self:AfterAttack(self.LastTarget) end, spell.windUpTime - (GetLatency()/2000) + self.SxOrbMenu.farmsettings.WindUpTime / 1000)
		end

		if self.ResetSpells[spell.name] then
				self.LastAA = GetTickCount() - self:GetAnimationTime() + self:GetWindUpTime() - self:GetLatency()
			DelayAction(function() self:SpellResetCallback() end, spell.windUpTime - (GetLatency()/2000) + self.SxOrbMenu.farmsettings.WindUpTime / 1000)
		end
	end
end

function SxOrb:GetMinionTargets(unit, spell)
	if spell and spell.name and spell.name:lower():find("attack") and unit and unit.networkID and unit.type == "obj_AI_Minion" and spell.target and spell.target.type == "obj_AI_Minion" and unit.team == myHero.team then
		local Data = {SourceMinion = unit.networkID, LastAttack = GetTickCount(), LastTarget = spell.target.networkID, LastAttackCD = spell.animationTime, Unit = unit, LastWindUpTime = spell.windUpTime, ProjectileSpeed = self.projectilespeeds[unit.charName], SpellDmg = unit:CalcDamage(spell.target)}
		table.insert(self.MinionTargetStore, Data)
		if unit.charName:lower():find("wizard") and not self.TrackMinion and GetDistance(unit) < 2000 and GetTarget() and unit == GetTarget() then
			self.TrackMinion = Data
		end

	end
end

function SxOrb:GetAACount(enemy)
	EnemyHP = math.ceil(enemy.health)
	if myHero.charName == "Vayne" then
		if myHero:GetSpellData(_W).level > 0 then TargetTrueDmg = math.floor((((enemy.maxHealth/100)*(3+(myHero:GetSpellData(_W).level)))+(10+(myHero:GetSpellData(_W).level)*10))/3) else TargetTrueDmg = 0 end
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
	else
		AADMG = math.floor((math.floor(myHero.totalDamage)) * 100 / (100 + enemy.armor))
		NeededAA = math.ceil(EnemyHP / AADMG)
		return NeededAA
	end
end

function SxOrb:ValidTarget(Target)
	if Target and Target.health > 0 and ValidTarget(Target) and Target.team ~= myHero.team and GetDistance(Target) < (myHero.range + hitboxes[myHero.charName] + (hitboxes[Target.charName] and hitboxes[Target.charName] or 0) - 20) then
		return true
	else
		return false
	end
end

function SxOrb:GetTarget()
	if not self.SxOrbMenu then
		self.SxOrbMenu = _G.SxOrbMenu
	end
	local SelectedTarget = GetTarget()
	local TargetTable = { ["Hero"] = nil, ["AA"] = math.huge }
	if SelectedTarget and SelectedTarget.type == myHero.type and self:ValidTarget(SelectedTarget) then
		return SelectedTarget
	else
		if self.SxOrbMenu.generalsettings.Selector and FileExist(LIB_PATH.."Selector.lua") then
			if not SelectorInit then
				require("Selector")
				Selector.Instance()
				SelectorInit = true
			end
			SelectorTarget = Selector.GetTarget(SelectorMenu.Get().mode, nil, {distance = myHero.range + hitboxes[myHero.charName] + 20})
			if SelectorTarget and self:ValidTarget(SelectorTarget) then
				return SelectorTarget
			end
		else
			for i, enemy in pairs(GetEnemyHeroes()) do
				if self:ValidTarget(enemy) then
					NeededAA = self:GetAACount(enemy)
					if (NeededAA < TargetTable.AA) or (NeededAA == TargetTable.AA and self.SxOrbMenu.targetsettings[enemy.charName] > self.SxOrbMenu.targetsettings[TargetTable["Hero"].charName]) then
						TargetTable.AA = NeededAA
						TargetTable.Hero = enemy
					end
				end
			end
			return TargetTable["Hero"]
		end
	end
end

function SxOrb:DrawRectangleAL(x, y, w, h, color)
	local Points = {}
	Points[1] = D3DXVECTOR2(math.floor(x), math.floor(y))
	Points[2] = D3DXVECTOR2(math.floor(x + w), math.floor(y))
	DrawLines2(Points, math.floor(h), color)
end

function SxOrb:DrawMinionHPBar()
	for i,minion in pairs(self.Minions.objects) do
		if GetDistanceSqr(minion) < 1000*1000 then
			local MinionBarPos = GetUnitHPBarPos(minion)
			local MyDmgToMinion = self:CalcAADmg(minion)
			local DrawDistance = math.floor(63 / (minion.maxHealth / MyDmgToMinion))
--~ 			for i=1,math.ceil(minion.health / MyDmgToMinion) do
				self:DrawRectangleAL(MinionBarPos.x - 32 + DrawDistance * 1, MinionBarPos.y, 1, 4, 4278190080)
--~ 			end
		end
	end
end

function OnLoad()
	if myHero.range > 1 then
	SxOW = SxOrb()
	SxOW:LoadToMenu()
	else
	DelayAction(function() OnLoad() end, 0)
	end
end