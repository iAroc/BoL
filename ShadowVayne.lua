--[[

	Shadow Vayne Script by Superx321
	Version: 2.52

	For Functions & Changelog, check the Thread on the BoL Forums:
	http://botoflegends.com/forum/topic/18939-shadow-vayne-the-mighty-hunter/

	If anything is not working or u wish a new Function, let me know it

	Thx to Jus & Hellsing for minor helping, Manciuszz for his Gapcloserlist and Klokje for his Interruptlist
	]]

if myHero.charName ~= "Vayne" then return end
local informationTable, AAInfoTable, CastedLastE, ScriptStartTick = {}, {}, 0, 0
local TickCountScriptStart, OnLoadDone, spellExpired, Beta = GetTickCount(), nil, true, false

if VIP_USER then
	require "VPrediction"
	VP = VPrediction()
end

function OnLoad()
	_LoadTables()
	_CheckSAC()
	_LoadMenu()
	AddTickCallback(_GetRunningModes)
	AddTickCallback(_CheckEnemyStunnAble)
	AddTickCallback(_GetUpdate)
	AddTickCallback(_NonTargetGapCloserAfterCast)
	autoLevelSetFunction(_AutoLevelSpell)
	autoLevelSetSequence({0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
end

function OnDraw()
	if VayneMenu.draw.DrawNeededAutohits then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			DrawText(tostring(_GetNeededAutoHits(enemy)),16,GetUnitHPBarPos(enemy).x,GetUnitHPBarPos(enemy).y,0xFF80FF00)
		end
	end

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
		-- AntiGapCloser Targeted Spells
		if isAGapcloserUnitTarget[unit.charName] and spell.name == isAGapcloserUnitTarget[unit.charName].spell and unit.team ~= myHero.team then
			if spell.target ~= nil and spell.target.hash == myHero.hash then
				if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."AutoCarry"] and ShadowVayneAutoCarry then _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / AutoCarry Mode") end
				if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LastHit"] and ShadowVayneMixedMode then _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Lasthit Mode") end
				if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."MixedMode"] and ShadowVayneLaneClear then _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Mixed Mode") end
				if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."LaneClear"] and ShadowVayneLastHit then _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Laneclear Mode") end
				if VayneMenu.anticapcloser[(unit.charName)..(isAGapcloserUnitTarget[unit.charName].spellKey)][(unit.charName).."Always"] then _CastESpell(unit, "Gapcloser Targeted ("..(spell.name)..") / Always") end
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
			if spell.name:find("Attack") and VayneMenu.keysetting.basiccondemn and spell.target.type == myHero.type then -- Auto-E after AA
				_CastESpell(spell.target, "E After Autohit ("..(spell.target.charName)..")", (spell.windUpTime - GetLatency() / 2000))
				VayneMenu.keysetting.basiccondemn = false
			end

			if spell.name:find("CondemnMissile") then -- E detected, cooldown for next E 500 ticks
				CastedLastE = GetTickCount() + 500
			end
		end

		if isAGapcloserUnitNoTarget[spell.name] and GetDistance(unit) <= 2000 and (spell.target == nil or spell.target.isMe) and unit.team ~= myHero.team then
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

function _AutoLevelSpell()
	if VayneMenu.autolevel.UseAutoLevelfirst and myHero.level < 4 then
		return AutoLevelSpellTable[AutoLevelSpellTable["SpellOrder"][VayneMenu.autolevel.first3level]][myHero.level]
	end

	if VayneMenu.autolevel.UseAutoLevelrest and myHero.level > 3 then
		return AutoLevelSpellTable[AutoLevelSpellTable["SpellOrder"][VayneMenu.autolevel.restlevel]][myHero.level]
	end
end

function _GetNeededAutoHits(enemy)
	local PredictHP = enemy.health
	local PrintHP = ""
	for i = 1,50,1 do
		ThisAA = i
		DMGThisAA = math.floor((math.floor(myHero.totalDamage)) * 100 / (100 + enemy.armor))
		BladeDMG = math.floor(math.floor(PredictHP)*5 / (100 + enemy.armor))
		TargetTrueDmg = math.floor(((((enemy.maxHealth)/100)*(VayneDamage[tostring(myHero:GetSpellData(_W).level)].MaxHPDmg))+(VayneDamage[tostring(myHero:GetSpellData(_W).level)].BaseDMG))/3)
		MyDMG = DMGThisAA + BladeDMG + TargetTrueDmg
		PredictHP = PredictHP - MyDMG
		if PredictHP <= 0 then
			AutoHitsNeeded = i
			break
		end
	end
	return AutoHitsNeeded
end

function _CastESpell(Target, Reason, Delay)
	if VIP_USER and VayneMenu.misc.EPackets then
		DelayAction(function() Packet('S_CAST', { spellId = _E, targetNetworkId = Target.networkID }):send(true) end, Delay)
	else
		DelayAction(function() CastSpell(_E, Target) end, Delay)
	end
end

function _CheckEnemyStunnAble()
	if not myHero.dead and myHero:CanUseSpell(_E) == READY and CastedLastE < GetTickCount() then
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if 	(VayneMenu.targets[enemy.charName][(enemy.charName).."AutoCarry"] and ShadowVayneAutoCarry) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."MixedMode"] and ShadowVayneMixedMode) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."LaneClear"] and ShadowVayneLaneClear) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."LastHit"] and ShadowVayneLastHit) or
				(VayneMenu.targets[enemy.charName][(enemy.charName).."Always"])	then
				if GetDistance(enemy) <= 715 and not enemy.dead and enemy.visible then
					if VIP_USER and VayneMenu.misc.vpred then --If VIP User
						local CastPosition,  HitChance, PredictEnemyPos = VP:GetLineCastPosition(enemy, 0.25, 65, 715, 2500, myHero, false)  -- Enemy, Delay, Range (scan?), Speed, Source, collosion)
						for i = 1, VayneMenu.autostunn.accuracy*2  do
								local CheckWallPos = PredictEnemyPos + (Vector(PredictEnemyPos) - myHero):normalized()*math.ceil((VayneMenu.autostunn.pushDistance/(VayneMenu.autostunn.accuracy*2))*i)
								if not BushFound and IsWallOfGrass(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) then
									BushFound = true
									BushPos = CheckWallPos
								end
								if IsWall(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) then
									if UnderTurret(ChecksWallPos, true) then
											if VayneMenu.autostunn.towerstunn then
												if GetDistance(enemy) <= 650 then
													_CastESpell(enemy, "AutoStunn Undertower ("..(enemy.charName)..")")
													if BushFound and VayneMenu.autostunn.trinket then DelayAction(function() CastSpell(ITEM_7, BushPos.x, BushPos.z) end, 0.25)	else BushFound = false end
													break
												end
											end
									else
										_CastESpell(enemy, "AutoStunn Not Undertower ("..(enemy.charName)..")")
										if BushFound and VayneMenu.autostunn.trinket then DelayAction(function() CastSpell(ITEM_7, BushPos.x, BushPos.z) end, 0.25)	else BushFound = false end
										break
									end
								end
							end
						end
					else --If FreeUser or not using VPred
						local CastPosition,  HitChance, PredictEnemyPos = VP:GetLineCastPosition(enemy, 0.25, 65, 715, 2500, myHero, false)  -- Enemy, Delay, Range (scan?), Speed, Source, collosion)
						for i = 1, VayneMenu.autostunn.accuracy*2  do
								local CheckWallPos = PredictEnemyPos + (Vector(PredictEnemyPos) - myHero):normalized()*math.ceil((VayneMenu.autostunn.pushDistance/(VayneMenu.autostunn.accuracy*2))*i)
								if not BushFound and IsWallOfGrass(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) then
									BushFound = true
									BushPos = CheckWallPos
								end
								if IsWall(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) then
									if UnderTurret(ChecksWallPos, true) then
											if VayneMenu.autostunn.towerstunn then
												if GetDistance(enemy) <= 715 then
													_CastESpell(enemy, "AutoStunn Undertower ("..(enemy.charName)..")")
													if BushFound and VayneMenu.autostunn.trinket then DelayAction(function() CastSpell(ITEM_7, BushPos.x, BushPos.z) end, 0.25)	else BushFound = false end
													break
												end
											end
									else
										_CastESpell(enemy, "AutoStunn Not Undertower ("..(enemy.charName)..")")
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
				if VayneMenu.misc.EPackets then _CastESpell(informationTable.spellSource, "Gapcloser NonTargeted ("..(informationTable.spellName)..")") end
			end
		else
			spellExpired = true
			informationTable = {}
		end
	end
end

function _PrintScriptMsg(Msg)
			print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">"..Msg.."</font>")
end

function _GetRunningModes()
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

function _LoadMenu()
	VayneMenu = scriptConfig("Shadow Vayne", "ShadowVayne")
	VayneMenu:addSubMenu("Key Settings", "keysetting")
	VayneMenu:addSubMenu("AntiGapCloser Settings", "anticapcloser")
	VayneMenu:addSubMenu("AutoStunn Settings", "autostunn")
	VayneMenu:addSubMenu("AutoStunn Targets", "targets")
	VayneMenu:addSubMenu("Interrupt Settings", "interrupt")
	VayneMenu:addSubMenu("Draw Settings", "draw")
	VayneMenu:addSubMenu("AutoLevelSpells Settings", "autolevel")
	VayneMenu:addSubMenu("Misc Settings", "misc")

	if not SACLoaded and not RevampedLoaded then
		VayneMenu.keysetting:addParam("autocarry","Auto Carry Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "V" ))
		VayneMenu.keysetting:addParam("mixedmode","Mixed Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "C" ))
		VayneMenu.keysetting:addParam("laneclear","Lane Clear Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "M" ))
		VayneMenu.keysetting:addParam("lasthit","Last Hit Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "N" ))
	end

	VayneMenu.keysetting:addParam("basiccondemn","Condemn on next BasicAttack:", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte( "E" ))
	VayneMenu.keysetting.basiccondemn = false

	if SACLoaded then
		VayneMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")
		VayneMenu.keysetting:addParam("nil","Sida's AutoCarry Reborn found", SCRIPT_PARAM_INFO, "")
		VayneMenu.keysetting:addParam("nil","It will use the Keysettings from there", SCRIPT_PARAM_INFO, "")
		DelayAction(function() print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">SAC:Reborn found. Using the Keysettings from there</font>") end, 1)
	end

	if RevampedLoaded then
		VayneMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")
		VayneMenu.keysetting:addParam("nil","Sida's AutoCarry Revamped found", SCRIPT_PARAM_INFO, "")
		VayneMenu.keysetting:addParam("nil","It will use the Keysettings from there", SCRIPT_PARAM_INFO, "")
		DelayAction(function() print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">SAC:Revamped found. Using the Keysettings from there</font>") end, 1)
	end

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
		VayneMenu.autostunn:addParam("accuracy", "Accuracy", SCRIPT_PARAM_SLICE, 5, 1, 10, 0)
		VayneMenu.autostunn:addParam("towerstunn", "Stunn if Enemy lands unter a Tower", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.autostunn:addParam("trinket", "Use Auto-Trinket Bush", SCRIPT_PARAM_ONOFF, true)

--~ 	Draw Menu
		VayneMenu.draw:addParam("DrawERange", "Draw E Range", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.draw:addParam("DrawEColor", "E Range Color", SCRIPT_PARAM_LIST, 1, { "Riot standard", "Green", "Blue", "Red", "Purple" })
		VayneMenu.draw:addParam("DrawNeededAutohits", "Draw Needed Autohits", SCRIPT_PARAM_ONOFF, false)

--~ 	Autolevel Menu
		VayneMenu.autolevel:addParam("UseAutoLevelfirst", "Use AutoLevelSpells Level 1-3", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.autolevel:addParam("UseAutoLevelrest", "Use AutoLevelSpells Level 4-18", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.autolevel:addParam("first3level", "Level 1-3:", SCRIPT_PARAM_LIST, 1, { "Q-W-E", "Q-E-W", "W-Q-E", "W-E-Q", "E-Q-W", "E-W-Q" })
		VayneMenu.autolevel:addParam("restlevel", "Level 4-18:", SCRIPT_PARAM_LIST, 1, { "Q-W-E", "Q-E-W", "W-Q-E", "W-E-Q", "E-Q-W", "E-W-Q" })
		VayneMenu.autolevel:addParam("fap", "", SCRIPT_PARAM_INFO, "","" )
		VayneMenu.autolevel:addParam("fap", "You can Click on the \"Q-W-E\"", SCRIPT_PARAM_INFO, "","" )
		VayneMenu.autolevel:addParam("fap", "to change the Autospellorder", SCRIPT_PARAM_INFO, "","" )

--~ 	Misc Menu
		VayneMenu.misc:addParam("EPackets", "Use Packets for E Cast (VIP Only)", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.misc:addParam("vpred", "Use VPrediction (VIP Only)", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.misc:addParam("epermashow", "PermaShow \"E on Next BasicAttack\"", SCRIPT_PARAM_ONOFF, true)
--~ 		VayneMenu.misc:addParam("debug", "Debug Print", SCRIPT_PARAM_ONOFF, false)
--~ 		VayneMenu.misc:addParam("KS3rdW", "Use E for 3rd Ring Proc Kill", SCRIPT_PARAM_ONOFF, true)

--~ 	Permashow
		if VayneMenu.misc.epermashow then
			VayneMenu.keysetting:permaShow("basiccondemn")
		end
end

function _CheckSAC()
	if AutoCarry ~= nil then
		if AutoCarry.Helper ~= nil then
			Skills, Keys, Items, Data, Jungle, Helper, MyHero, Minions, Crosshair, Orbwalker = AutoCarry.Helper:GetClasses()
			SACLoaded = true
		else
			RevampedLoaded = true
		end
	end
end

function _GetUpdate()
	if not AlreadyChecked then
		if not OnLoadDone then
			if Beta then SCRIPT_NAME = "ShadowVayneBeta" else SCRIPT_NAME = "ShadowVayne" end
				OwnScriptFile = io.open(SCRIPT_PATH..(GetCurrentEnv().FILE_NAME), "r")
				LocalVersion = string.sub(OwnScriptFile:read("*a"), 51, 54)
				FileClose = OwnScriptFile:close()
				_PrintScriptMsg("Loaded Version: "..(LocalVersion))
			OnLoadDone = true
			SHADOWVAYNE_SCRIPT_URL = "http://raw.github.com/Superx321/BoL/master/"..SCRIPT_NAME..".lua?rand="..tostring(math.random(1,10000))
			SHADOWVAYNE_PATH = SCRIPT_PATH..(GetCurrentEnv().FILE_NAME)
			ServerVersion = string.sub(GetWebResult("raw.github.com", "/Superx321/BoL/master/"..SCRIPT_NAME..".lua?rand="..tostring(math.random(1,10000))), 51, 54)
		end
		if GetTickCount() > (ScriptStartTick + 3000) then
			if ServerVersion ~= nil then
				if tonumber(LocalVersion) < tonumber(ServerVersion) then
					_PrintScriptMsg("New Version ("..(ServerVersion)..") available, downloading...")
					DownloadFile(SHADOWVAYNE_SCRIPT_URL, SHADOWVAYNE_PATH, function () _PrintScriptMsg("Updated to Version "..(ServerVersion)..". Please reload with F9") end)
				else
					_PrintScriptMsg("No Updates available")
				end
				AlreadyChecked = true
			else
				ScriptStartTick = ScriptStartTick + 3000
			end
		end
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

	VayneDamage = {
				["0"] = {BaseDMG = 00, MaxHPDmg = 0},
				["1"] = {BaseDMG = 20, MaxHPDmg = 4},
				["2"] = {BaseDMG = 30, MaxHPDmg = 5},
				["3"] = {BaseDMG = 40, MaxHPDmg = 6},
				["4"] = {BaseDMG = 50, MaxHPDmg = 7},
				["5"] = {BaseDMG = 60, MaxHPDmg = 8},
				["Q"] = {30, 35, 40, 45, 50}
	}
end