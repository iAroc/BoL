--[[

	Shadow Vayne Script by Superx321
	Version: 2.70

	For Functions & Changelog, check the Thread on the BoL Forums:
	http://botoflegends.com/forum/topic/18939-shadow-vayne-the-mighty-hunter/

	If anything is not working or u wish a new Function, let me know it

	Thx to Jus & Hellsing for minor helping, Manciuszz for his Gapcloserlist and Klokje for his Interruptlist
	]]

if myHero.charName ~= "Vayne" then return end
local informationTable, AAInfoTable, CastedLastE, ScriptStartTick = {}, {}, 0, 0
local TickCountScriptStart, OnLoadDone, spellExpired, Beta = GetTickCount(), nil, true, false
local ScriptOnLoadDone, LastAttackedEnemy = false, nil
local LastPrioUpdate = 0

function OnTick()
	if not ScriptOnLoadDone then
		_DownloadLib("TheRealSource/public/raw/master/common/SourceLib.lua", "SourceLib")
		_DownloadLib("honda7/BoL/raw/master/Common/VPrediction.lua", "VPrediction")
		_DownloadLib("honda7/BoL/raw/master/Common/SOW.lua", "SOW")
		if FileExist(SCRIPT_PATH.."/Common/SOW.lua") and FileExist(SCRIPT_PATH.."/Common/VPrediction.lua") and FileExist(SCRIPT_PATH.."/Common/SourceLib.lua") then
			if HadToDownload then _PrintScriptMsg("All Librarys are successfully downloaded") end
			require "SourceLib"
			require "VPrediction"
			require "SOW"
			VP = VPrediction(true)
			_LoadTables()
			_CheckSACMMASOW()
			_LoadMenu()
			AddTickCallback(_GetRunningModes)
			AddTickCallback(_CheckEnemyStunnAbleBeta)
			AddTickCallback(_GetUpdate)
			AddTickCallback(_NonTargetGapCloserAfterCast)
			AddTickCallback(_SetNewTarget)
			AddTickCallback(_UseBotRK)
			AddTickCallback(_ClickThreshLantern)
			AddCreateObjCallback(_ThreshLanternObj)
			autoLevelSetFunction(_AutoLevelSpell)
			autoLevelSetSequence({0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0})
			ScriptOnLoadDone = true
		end
	end
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
				DrawCircle(myHero.x, myHero.y, myHero.z, 615, 0x80FFFF)
			elseif VayneMenu.draw.DrawAAColor == 2 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 615, 0x0080FF)
			elseif VayneMenu.draw.DrawAAColor == 3 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 615, 0x5555FF)
			elseif VayneMenu.draw.DrawAAColor == 4 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 615, 0xFF2D2D)
			elseif VayneMenu.draw.DrawAAColor == 5 then
				DrawCircle(myHero.x, myHero.y, myHero.z, 615, 0x8B42B3)
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
				if VayneMenu.keysetting.basiccondemn and spell.target.type == myHero.type then -- Auto-E after AA
					_CastESpell(spell.target, "E After Autohit ("..(spell.target.charName)..")", (spell.windUpTime - GetLatency() / 2000))
					VayneMenu.keysetting.basiccondemn = false
				end
			end


			if spell.name:find("VayneCondemn") then -- E detected, cooldown for next E 500 ticks
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

function _SetNewTarget()
	if not myHero.dead and SOWLoaded and LastPrioUpdate + 100 < GetTickCount() then
		LastPrioUpdate = GetTickCount()
		local PrioOrder = 1
		local AATable = {}
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if GetDistance(enemy) < 700 and not enemy.dead and enemy.visible then
				AATable[(_GetNeededAutoHits(enemy))] = enemy
			end
		end
		for NeedAA, Champ in _SortAATable(AATable) do
			SOWi:ForceTarget(Champ)
			break
		end
	end
end

function _GetNeededAutoHits(enemy)
		local PredictHP = math.ceil(enemy.health)
		local ThisAA = 0
		local BladeSlot = GetInventorySlotItem(3153)
		if myHero:GetSpellData(_W).level > 0 then TargetTrueDmg = math.floor((((enemy.maxHealth/100)*((3+myHero:GetSpellData(_W).level)/100))+(10 +(myHero:GetSpellData(_W).level)*10))/3) else	TargetTrueDmg = 0 end
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

function _SetNewPrioOrder()
	if LastPrioUpdate + 100 < GetTickCount() and SOWLoaded then
		LastPrioUpdate = GetTickCount()
		local PrioOrder = 1
		local AATable = {}
		for i, enemy in ipairs(GetEnemyHeroes()) do
			AATable[(_GetNeededAutoHits(enemy))] = enemy.hash
		end
		for NeedAA, ChampHash in _SortAATable(AATable) do
			for i, enemy in ipairs(GetEnemyHeroes()) do
				if enemy.hash == ChampHash then
					if enemy.dead then
						VayneMenu.STS.STS[ChampHash] = 5
					else
						VayneMenu.STS.STS[ChampHash] = PrioOrder
					end
					PrioOrder = PrioOrder + 1
					break
				end
			end
		end
	end
end

function _SortAATable(t, f)
	local a = {}
		for n in pairs(t) do table.insert(a, n) end
			table.sort(a, f)
			local i = 0
			local iter = function ()
			i = i + 1
			if a[i] == nil then
				return nil
			else
				return a[i], t[a[i]]
			end
		end
    return iter
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
				if GetDistance(enemy, myHero) <= 715 and not enemy.dead and enemy.visible then
					if VIP_USER and VayneMenu.vip.vpred then
						local CastPosition,  HitChance, enemy = VP:GetLineCastPosition(enemy, 0.30, 65, 1200, 2000, myHero, false)  -- Enemy, Delay, Range (scan?), Speed, Source, collosion)
					else
						local PredictEnemyPos = enemy
					end
					for i = 1, VayneMenu.autostunn.accuracy  do
						local CheckWallPos = enemy + (Vector(enemy) - myHero):normalized()*(math.ceil(VayneMenu.autostunn.pushDistance/VayneMenu.autostunn.accuracy)*i)
--~ 						if not BushFound and IsWallOfGrass(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) then
--~ 							BushFound = true
--~ 							BushPos = CheckWallPos
--~ 						end
						if IsWall(D3DXVECTOR3(CheckWallPos.x, CheckWallPos.y, CheckWallPos.z)) then
							if UnderTurret(ChecksWallPos, true) then
								if VayneMenu.autostunn.towerstunn then
									if GetDistance(enemy, myHero) <= 715 then
										_CastESpell(enemy, "AutoStunn Undertower ("..(enemy.charName)..")")
--~ 										if BushFound and VayneMenu.autostunn.trinket then DelayAction(function() CastSpell(ITEM_7, BushPos.x, BushPos.z) end, 0.25)	else BushFound = false end
										break
									end
								end
							else
								if GetDistance(CheckWallPos, enemy) < VayneMenu.autostunn.pushDistance then	_CastESpell(enemy, "AutoStunn Not Undertower ("..(enemy.charName)..")") end
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

function _CheckEnemyStunnAbleBeta()
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
	CastPacket = CLoLPacket(0x99)
	CastPacket:EncodeF(myHero.networkID)
	CastPacket:Encode1(SpellToCast)
	CastPacket:EncodeF(TargetToCast.x)
	CastPacket:EncodeF(TargetToCast.z)
	CastPacket:EncodeF(TargetToCast.x)
	CastPacket:EncodeF(TargetToCast.z)
	CastPacket:EncodeF(TargetToCast.networkID)
	CastPacket.dwArg1 = 1
	CastPacket.dwArg2 = 0
	SendPacket(CastPacket)
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
	print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">"..Msg.."</font>")
end

function _ScriptDebugMsg(Msg, DebugMode)
	if VayneMenu.debug[DebugMode] then
		print("<font color=\"#F0Ff8d\"><b>ShadowVayne Debug:</b></font> <font color=\"#FF0F0F\">"..Msg.."</font>")
	end
end

function _GetRunningModes()
	if SACLoaded then
		ShadowVayneAutoCarry = Keys.AutoCarry
		ShadowVayneMixedMode = Keys.MixedMode
		ShadowVayneLaneClear = Keys.LastHit
		ShadowVayneLastHit = Keys.LaneClear
	elseif SOWLoaded then
		ShadowVayneAutoCarry = VayneMenu.sow.Mode0
		ShadowVayneMixedMode = VayneMenu.sow.Mode1
		ShadowVayneLaneClear = VayneMenu.sow.Mode2
		ShadowVayneLastHit = VayneMenu.sow.Mode3
	elseif RevampedLoaded then
		ShadowVayneAutoCarry = AutoCarry.MainMenu.AutoCarry
		ShadowVayneMixedMode = AutoCarry.MainMenu.MixedMode
		ShadowVayneLaneClear = AutoCarry.MainMenu.LaneClear
		ShadowVayneLastHit = AutoCarry.MainMenu.LastHit
	else
		ShadowVayneAutoCarry = VayneMenu.keysetting.autocarry
		ShadowVayneMixedMode = VayneMenu.keysetting.mixedmode
		ShadowVayneLaneClear = VayneMenu.keysetting.laneclear
		ShadowVayneLastHit = VayneMenu.keysetting.lasthit
	end
end

function _LoadMenu()
	VayneMenu = scriptConfig("Shadow Vayne", "ShadowVayne")
	VayneMenu:addSubMenu("[Condemn]: AntiGapCloser Settings", "anticapcloser")
	VayneMenu:addSubMenu("[Condemn]: AutoStunn Settings", "autostunn")
	VayneMenu:addSubMenu("[Condemn]: AutoStunn Targets", "targets")
	VayneMenu:addSubMenu("[Condemn]: Interrupt Settings", "interrupt")
	VayneMenu:addSubMenu("[Misc]: Key Settings", "keysetting")
	VayneMenu:addSubMenu("[Misc]: AutoLevelSpells Settings", "autolevel")
	VayneMenu:addSubMenu("[Misc]: VIP Settings", "vip")
	VayneMenu:addSubMenu("[Misc]: PermaShow Settings", "permashowsettings")
	VayneMenu:addSubMenu("[Misc]: AutoUpdate Settings", "autoup")
	VayneMenu:addSubMenu("[Misc]: Draw Settings", "draw")
	VayneMenu:addSubMenu("[BotRK]: Settings", "botrksettings")
	VayneMenu:addSubMenu("[QSS]: Settings", "qqs")
	VayneMenu:addSubMenu("[Debug]: Settings", "debug")

	VayneMenu.qqs:addParam("nil","QSS/Cleanse is not Supported yet", SCRIPT_PARAM_INFO, "")

	if SOWLoaded then
		require "SOW"
	  	VayneMenu:addSubMenu("[Sow]: Orbwalker Settings", "sow")
		if FileExist(SCRIPT_PATH.."/Common/SourceLib.lua") then
			require "SourceLib"
--~ 			VayneMenu:addSubMenu("[Sow]: Target selector", "STS")
			STS = SimpleTS(STS_LESS_CAST_PHYSICAL)
			SOWi = SOW(VP, STS)
			SOWi:LoadToMenu(VayneMenu.sow)
--~ 			STS:AddToMenu(VayneMenu.STS)
		else
			SOWi = SOW(VP)
			SOWi:LoadToMenu(VayneMenu.sow)
		end
	end

	if not SACLoaded and not RevampedLoaded and not SOWLoaded then
		VayneMenu.keysetting:addParam("autocarry","Auto Carry Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "V" ))
		VayneMenu.keysetting:addParam("mixedmode","Mixed Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "C" ))
		VayneMenu.keysetting:addParam("laneclear","Lane Clear Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "M" ))
		VayneMenu.keysetting:addParam("lasthit","Last Hit Mode Key:", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "N" ))
	end

	VayneMenu.keysetting:addParam("basiccondemn","Condemn on next BasicAttack:", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte( "E" ))
	VayneMenu.keysetting:addParam("threshlantern","Grab the Thresh lantern: ", SCRIPT_PARAM_ONKEYDOWN, false, string.byte( "T" ))
	VayneMenu.keysetting.basiccondemn = false

	if SACLoaded then
		VayneMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")
		VayneMenu.keysetting:addParam("nil","Sida's AutoCarry Reborn found", SCRIPT_PARAM_INFO, "")
		VayneMenu.keysetting:addParam("nil","It will use the Keysettings from there", SCRIPT_PARAM_INFO, "")
		DelayAction(function()  _PrintScriptMsg("SAC:Reborn found. Using the Keysettings from there") end, 1)
	end

	if RevampedLoaded then
		VayneMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")
		VayneMenu.keysetting:addParam("nil","Sida's AutoCarry Revamped found", SCRIPT_PARAM_INFO, "")
		VayneMenu.keysetting:addParam("nil","It will use the Keysettings from there", SCRIPT_PARAM_INFO, "")
		DelayAction(function()  _PrintScriptMsg("SAC:Revamped found. Using the Keysettings from there") end, 1)
	end

	if SOWLoaded then
		VayneMenu.keysetting:addParam("nil","", SCRIPT_PARAM_INFO, "")
		VayneMenu.keysetting:addParam("nil","Simple Orbwalker found.", SCRIPT_PARAM_INFO, "")
		VayneMenu.keysetting:addParam("nil","It will use the Keysettings from there", SCRIPT_PARAM_INFO, "")
		DelayAction(function() _PrintScriptMsg("SOW found. It will use the Keysettings from there") end, 1)
		if not FileExist(SCRIPT_PATH.."/Common/SourceLib.lua") then DelayAction(function() _PrintScriptMsg("SourceLib not found. Please download SourceLib from the Forum") end, 1) end
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
--~ 		VayneMenu.autostunn:addParam("accuracy", "Accuracy", SCRIPT_PARAM_SLICE, 5, 1, 10, 0)
		VayneMenu.autostunn:addParam("towerstunn", "Stunn if Enemy lands unter a Tower", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.autostunn:addParam("trinket", "Use Auto-Trinket Bush", SCRIPT_PARAM_ONOFF, true)

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
		VayneMenu.vip:addParam("vpred", "Use VPrediction (VIP Only)", SCRIPT_PARAM_ONOFF, true)

--~ 	PermaShow Menu
		VayneMenu.permashowsettings:addParam("epermashow", "PermaShow \"E on Next BasicAttack\"", SCRIPT_PARAM_ONOFF, true)
		if SOWLoaded then
			VayneMenu.permashowsettings:addParam("carrypermashow", "PermaShow SOW: \"Carry Me!\"", SCRIPT_PARAM_ONOFF, true)
			VayneMenu.permashowsettings:addParam("mixedpermashow", "PermaShow SOW: \"Mixed Mode!\"", SCRIPT_PARAM_ONOFF, true)
			VayneMenu.permashowsettings:addParam("laneclearpermashow", "PermaShow SOW: \"Laneclear!\"", SCRIPT_PARAM_ONOFF, true)
			VayneMenu.permashowsettings:addParam("lasthitpermashow", "PermaShow SOW: \"Last hit!\"", SCRIPT_PARAM_ONOFF, true)
		end

--~ 	AutoUpdate Menu
		VayneMenu.autoup:addParam("autoupcheck", "Check for Updates", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.autoup:addParam("autoupdown", "Download Available Updates", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.autoup:addParam("fap", "", SCRIPT_PARAM_INFO, "","" )
		VayneMenu.autoup:addParam("fap", "The first will check if download is available", SCRIPT_PARAM_INFO, "","" )
		VayneMenu.autoup:addParam("fap", "The second will download it", SCRIPT_PARAM_INFO, "","" )

--~ 	Permashow
		if VayneMenu.permashowsettings.epermashow then VayneMenu.keysetting:permaShow("basiccondemn") end
		if SOWLoaded then
			if VayneMenu.permashowsettings.carrypermashow then VayneMenu.sow:permaShow("Mode0") end
			if VayneMenu.permashowsettings.mixedpermashow then VayneMenu.sow:permaShow("Mode1") end
			if VayneMenu.permashowsettings.laneclearpermashow then VayneMenu.sow:permaShow("Mode2") end
			if VayneMenu.permashowsettings.lasthitpermashow then VayneMenu.sow:permaShow("Mode3") end
		end

--~ 	BotRK Settings Menu
		VayneMenu.botrksettings:addParam("botrkautocarry", "Use BotRK in AutoCarry", SCRIPT_PARAM_ONOFF, true)
		VayneMenu.botrksettings:addParam("botrkmixedmode", "Use BotRK in MixedMode", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.botrksettings:addParam("botrklaneclear", "Use BotRK in LaneClear", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.botrksettings:addParam("botrklasthit", "Use BotRK in LastHit", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.botrksettings:addParam("botrkalways", "Use BotRK always", SCRIPT_PARAM_ONOFF, false)
		VayneMenu.botrksettings:addParam("botrkmaxheal", "Max Own Health Percent", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
		VayneMenu.botrksettings:addParam("botrkminheal", "Min Enemy Health Percent", SCRIPT_PARAM_SLICE, 20, 1, 100, 0)

--~ 	Debug Settings Menu
		VayneMenu.debug:addParam("stunndebug", "Debug AutoStunn", SCRIPT_PARAM_ONOFF, false)

end

function _CheckSACMMASOW()
	if AutoCarry ~= nil then
		if AutoCarry.Helper ~= nil then
			Skills, Keys, Items, Data, Jungle, Helper, MyHero, Minions, Crosshair, Orbwalker = AutoCarry.Helper:GetClasses()
			SACLoaded = true
		else
			RevampedLoaded = true
		end
	end

	if _G.MMA_Loaded then
		MMALoaded = true
	end

	if not MMALoaded and not SACLoaded and not RevampedLoaded then
		if not FileExist(SCRIPT_PATH.."/Common/SOW.lua") then
			DelayAction(function() _PrintScriptMsg("No Orbwalker found. It will use the raw Keysettings") end, 1)
			DelayAction(function() _PrintScriptMsg("Download SOW from the Forum") end, 1)
		else
			SOWLoaded = true
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
			ServerWebResult = GetWebResult("raw.github.com", "/Superx321/BoL/master/"..SCRIPT_NAME..".lua?rand="..tostring(math.random(1,10000)))
			if ServerWebResult ~= nil then
				ServerVersion = string.sub(ServerWebResult, 51, 54)
			else
				ServerVersion = nil
			end
		end
		if GetTickCount() > (ScriptStartTick + 3000) and VayneMenu.autoup.autoupcheck then
			if ServerVersion ~= nil then
				if tonumber(LocalVersion) < tonumber(ServerVersion) then
					if VayneMenu.autoup.autoupdown then
						_PrintScriptMsg("New Version ("..(ServerVersion)..") available, downloading...")
						DownloadFile(SHADOWVAYNE_SCRIPT_URL, SHADOWVAYNE_PATH, function () _PrintScriptMsg("Updated to Version "..(ServerVersion)..". Please reload with F9") end)
					else
						_PrintScriptMsg("New Version is available. Turn on AutoUpdate or download manually")
					end
				else
					_PrintScriptMsg("No Updates available")
				end
				AlreadyChecked = true
			else
				ScriptStartTick = ScriptStartTick + 3000
				ServerWebResult = GetWebResult("raw.github.com", "/Superx321/BoL/master/"..SCRIPT_NAME..".lua?rand="..tostring(math.random(1,10000)))
				if ServerWebResult ~= nil then ServerVersion = string.sub(ServerWebResult, 51, 54) end
			end
		end
	end
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

function _ThreshLanternObj(Obj)
	if Obj.name == "ThreshLantern" then
		LanternObj = Obj
	end
end

function _ClickThreshLantern()
	if VayneMenu.keysetting.threshlantern and LanternObj then
		LanternPacket = CLoLPacket(0x39)
		LanternPacket:EncodeF(myHero.networkID)
		LanternPacket:EncodeF(LanternObj.networkID)
		LanternPacket.dwArg1 = 1
		LanternPacket.dwArg2 = 0
		SendPacket(LanternPacket)
	end
end

function _DownloadLib(FilePath, LibName)
	if not FileExist(SCRIPT_PATH.."Common/"..LibName..".lua") then
		if not DownloadStarted then
			DownloadStarted = true
			_PrintScriptMsg("Downloading Library ("..LibName.."), please wait until its finished")
			DownloadFile("http://github.com/"..FilePath.."?rand="..tostring(math.random(1,10000)), SCRIPT_PATH.."Common/"..LibName..".lua",  function() DownloadStarted, HadToDownload = false, true end)
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

	ChampHitBoxes = {['RecItemsCLASSIC'] = 65, ['TeemoMushroom'] = 50.0, ['TestCubeRender'] = 65, ['Xerath'] = 65, ['Kassadin'] = 65, ['Rengar'] = 65, ['Thresh'] = 55.0, ['RecItemsTUTORIAL'] = 65, ['Ziggs'] = 55.0, ['ZyraPassive'] = 20.0, ['ZyraThornPlant'] = 20.0, ['KogMaw'] = 65, ['HeimerTBlue'] = 35.0, ['EliseSpider'] = 65, ['Skarner'] = 80.0, ['ChaosNexus'] = 65, ['Katarina'] = 65, ['Riven'] = 65, ['SightWard'] = 1, ['HeimerTYellow'] = 35.0, ['Ashe'] = 65, ['VisionWard'] = 1, ['TT_NGolem2'] = 80.0, ['ThreshLantern'] = 65, ['RecItemsCLASSICMap10'] = 65, ['RecItemsODIN'] = 65, ['TT_Spiderboss'] = 200.0, ['RecItemsARAM'] = 65, ['OrderNexus'] = 65, ['Soraka'] = 65, ['Jinx'] = 65, ['TestCubeRenderwCollision'] = 65, ['Red_Minion_Wizard'] = 48.0, ['JarvanIV'] = 65, ['Blue_Minion_Wizard'] = 48.0, ['TT_ChaosTurret2'] = 88.4, ['TT_ChaosTurret3'] = 88.4, ['TT_ChaosTurret1'] = 88.4, ['ChaosTurretGiant'] = 88.4, ['Dragon'] = 100.0, ['LuluSnowman'] = 50.0, ['Worm'] = 100.0, ['ChaosTurretWorm'] = 88.4, ['TT_ChaosInhibitor'] = 65, ['ChaosTurretNormal'] = 88.4, ['AncientGolem'] = 100.0, ['ZyraGraspingPlant'] = 20.0, ['HA_AP_OrderTurret3'] = 88.4, ['HA_AP_OrderTurret2'] = 88.4, ['Tryndamere'] = 65, ['OrderTurretNormal2'] = 88.4, ['Singed'] = 65, ['OrderInhibitor'] = 65, ['Diana'] = 65, ['HA_FB_HealthRelic'] = 65, ['TT_OrderInhibitor'] = 65, ['GreatWraith'] = 80.0, ['Yasuo'] = 65, ['OrderTurretDragon'] = 88.4, ['OrderTurretNormal'] = 88.4, ['LizardElder'] = 65.0, ['HA_AP_ChaosTurret'] = 88.4, ['Ahri'] = 65, ['Lulu'] = 65, ['ChaosInhibitor'] = 65, ['HA_AP_ChaosTurret3'] = 88.4, ['HA_AP_ChaosTurret2'] = 88.4, ['ChaosTurretWorm2'] = 88.4, ['TT_OrderTurret1'] = 88.4, ['TT_OrderTurret2'] = 88.4, ['TT_OrderTurret3'] = 88.4, ['LuluFaerie'] = 65, ['HA_AP_OrderTurret'] = 88.4, ['OrderTurretAngel'] = 88.4, ['YellowTrinketUpgrade'] = 1, ['MasterYi'] = 65, ['Lissandra'] = 65, ['ARAMOrderTurretNexus'] = 88.4, ['Draven'] = 65, ['FiddleSticks'] = 65, ['SmallGolem'] = 80.0, ['ARAMOrderTurretFront'] = 88.4, ['ChaosTurretTutorial'] = 88.4, ['NasusUlt'] = 80.0, ['Maokai'] = 80.0, ['Wraith'] = 50.0, ['Wolf'] = 50.0, ['Sivir'] = 65, ['Corki'] = 65, ['Janna'] = 65, ['Nasus'] = 80.0, ['Golem'] = 80.0, ['ARAMChaosTurretFront'] = 88.4, ['ARAMOrderTurretInhib'] = 88.4, ['LeeSin'] = 65, ['HA_AP_ChaosTurretTutorial'] = 88.4, ['GiantWolf'] = 65.0, ['HA_AP_OrderTurretTutorial'] = 88.4, ['YoungLizard'] = 50.0, ['Jax'] = 65, ['LesserWraith'] = 50.0, ['Blitzcrank'] = 80.0, ['brush_D_SR'] = 65, ['brush_E_SR'] = 65, ['brush_F_SR'] = 65, ['brush_C_SR'] = 65, ['brush_A_SR'] = 65, ['brush_B_SR'] = 65, ['ARAMChaosTurretInhib'] = 88.4, ['Shen'] = 65, ['Nocturne'] = 65, ['Sona'] = 65, ['ARAMChaosTurretNexus'] = 88.4, ['YellowTrinket'] = 1, ['OrderTurretTutorial'] = 88.4, ['Caitlyn'] = 65, ['Trundle'] = 65, ['Malphite'] = 80.0, ['Mordekaiser'] = 80.0, ['ZyraSeed'] = 65, ['Vi'] = 50, ['Tutorial_Red_Minion_Wizard'] = 48.0, ['Renekton'] = 80.0, ['Anivia'] = 65, ['Fizz'] = 65, ['Heimerdinger'] = 55.0, ['Evelynn'] = 65, ['Rumble'] = 80.0, ['Leblanc'] = 65, ['Darius'] = 80.0, ['OlafAxe'] = 50.0, ['Viktor'] = 65, ['XinZhao'] = 65, ['Orianna'] = 65, ['Vladimir'] = 65, ['Nidalee'] = 65, ['Tutorial_Red_Minion_Basic'] = 48.0, ['ZedShadow'] = 65, ['Syndra'] = 65, ['Zac'] = 80.0, ['Olaf'] = 65, ['Veigar'] = 55.0, ['Twitch'] = 65, ['Alistar'] = 80.0, ['Akali'] = 65, ['Urgot'] = 80.0, ['Leona'] = 65, ['Talon'] = 65, ['Karma'] = 65, ['Jayce'] = 65, ['Galio'] = 80.0, ['Shaco'] = 65, ['Taric'] = 65, ['TwistedFate'] = 65, ['Varus'] = 65, ['Garen'] = 65, ['Swain'] = 65, ['Vayne'] = 65, ['Fiora'] = 65, ['Quinn'] = 65, ['Kayle'] = 65, ['Blue_Minion_Basic'] = 48.0, ['Brand'] = 65, ['Teemo'] = 55.0, ['Amumu'] = 55.0, ['Annie'] = 55.0, ['Odin_Blue_Minion_caster'] = 48.0, ['Elise'] = 65, ['Nami'] = 65, ['Poppy'] = 55.0, ['AniviaEgg'] = 65, ['Tristana'] = 55.0, ['Graves'] = 65, ['Morgana'] = 65, ['Gragas'] = 80.0, ['MissFortune'] = 65, ['Warwick'] = 65, ['Cassiopeia'] = 65, ['Tutorial_Blue_Minion_Wizard'] = 48.0, ['DrMundo'] = 80.0, ['Volibear'] = 80.0, ['Irelia'] = 65, ['Odin_Red_Minion_Caster'] = 48.0, ['Lucian'] = 65, ['Yorick'] = 80.0, ['RammusPB'] = 65, ['Red_Minion_Basic'] = 48.0, ['Udyr'] = 65, ['MonkeyKing'] = 65, ['Tutorial_Blue_Minion_Basic'] = 48.0, ['Kennen'] = 55.0, ['Nunu'] = 65, ['Ryze'] = 65, ['Zed'] = 65, ['Nautilus'] = 80.0, ['Gangplank'] = 65, ['shopevo'] = 65, ['Lux'] = 65, ['Sejuani'] = 80.0, ['Ezreal'] = 65, ['OdinNeutralGuardian'] = 65, ['Khazix'] = 65, ['Sion'] = 80.0, ['Aatrox'] = 65, ['Hecarim'] = 80.0, ['Pantheon'] = 65, ['Shyvana'] = 50.0, ['Zyra'] = 65, ['Karthus'] = 65, ['Rammus'] = 65, ['Zilean'] = 65, ['Chogath'] = 80.0, ['Malzahar'] = 65, ['YorickRavenousGhoul'] = 1.0, ['YorickSpectralGhoul'] = 1.0, ['JinxMine'] = 65, ['YorickDecayedGhoul'] = 1.0, ['XerathArcaneBarrageLauncher'] = 65, ['Odin_SOG_Order_Crystal'] = 65, ['TestCube'] = 65, ['ShyvanaDragon'] = 80.0, ['FizzBait'] = 65, ['ShopKeeper'] = 65, ['Blue_Minion_MechMelee'] = 65.0, ['OdinQuestBuff'] = 65, ['TT_Buffplat_L'] = 65, ['TT_Buffplat_R'] = 65, ['KogMawDead'] = 65, ['TempMovableChar'] = 48.0, ['Lizard'] = 50.0, ['GolemOdin'] = 80.0, ['OdinOpeningBarrier'] = 65, ['TT_ChaosTurret4'] = 88.4, ['TT_Flytrap_A'] = 65, ['TT_Chains_Order_Periph'] = 65, ['TT_NWolf'] = 65.0, ['ShopMale'] = 65, ['OdinShieldRelic'] = 65, ['TT_Chains_Xaos_Base'] = 65, ['LuluSquill'] = 50.0, ['TT_Shopkeeper'] = 65, ['redDragon'] = 100.0, ['MonkeyKingClone'] = 65, ['Odin_skeleton'] = 65, ['OdinChaosTurretShrine'] = 88.4, ['Cassiopeia_Death'] = 65, ['OdinCenterRelic'] = 48.0, ['Ezreal_cyber_1'] = 65, ['Ezreal_cyber_3'] = 65, ['Ezreal_cyber_2'] = 65, ['OdinRedSuperminion'] = 55.0, ['TT_Speedshrine_Gears'] = 65, ['JarvanIVWall'] = 65, ['DestroyedNexus'] = 65, ['ARAMOrderNexus'] = 65, ['Red_Minion_MechCannon'] = 65.0, ['OdinBlueSuperminion'] = 55.0, ['SyndraOrbs'] = 65, ['LuluKitty'] = 50.0, ['SwainNoBird'] = 65, ['LuluLadybug'] = 50.0, ['CaitlynTrap'] = 65, ['TT_Shroom_A'] = 65, ['ARAMChaosTurretShrine'] = 88.4, ['Odin_Windmill_Propellers'] = 65, ['DestroyedInhibitor'] = 65, ['TT_NWolf2'] = 50.0, ['OdinMinionGraveyardPortal'] = 1.0, ['SwainBeam'] = 65, ['Summoner_Rider_Order'] = 65.0, ['TT_Relic'] = 65, ['odin_lifts_crystal'] = 65, ['OdinOrderTurretShrine'] = 88.4, ['SpellBook1'] = 65, ['Blue_Minion_MechCannon'] = 65.0, ['TT_ChaosInhibitor_D'] = 65, ['Odin_SoG_Chaos'] = 65, ['TrundleWall'] = 65, ['HA_AP_HealthRelic'] = 65, ['OrderTurretShrine'] = 88.4, ['OriannaBall'] = 48.0, ['ChaosTurretShrine'] = 88.4, ['LuluCupcake'] = 50.0, ['HA_AP_ChaosTurretShrine'] = 88.4, ['TT_Chains_Bot_Lane'] = 65, ['TT_NWraith2'] = 50.0, ['TT_Tree_A'] = 65, ['SummonerBeacon'] = 65, ['Odin_Drill'] = 65, ['TT_NGolem'] = 80.0, ['Shop'] = 65, ['AramSpeedShrine'] = 65, ['DestroyedTower'] = 65, ['OriannaNoBall'] = 65, ['Odin_Minecart'] = 65, ['Summoner_Rider_Chaos'] = 65.0, ['OdinSpeedShrine'] = 65, ['TT_Brazier'] = 65, ['TT_SpeedShrine'] = 65, ['odin_lifts_buckets'] = 65, ['OdinRockSaw'] = 65, ['OdinMinionSpawnPortal'] = 1.0, ['SyndraSphere'] = 48.0, ['TT_Nexus_Gears'] = 65, ['Red_Minion_MechMelee'] = 65.0, ['SwainRaven'] = 65, ['crystal_platform'] = 65, ['MaokaiSproutling'] = 48.0, ['Urf'] = 65, ['TestCubeRender10Vision'] = 65, ['MalzaharVoidling'] = 10.0, ['GhostWard'] = 1, ['MonkeyKingFlying'] = 65, ['LuluPig'] = 50.0, ['AniviaIceBlock'] = 65, ['TT_OrderInhibitor_D'] = 65, ['yonkey'] = 65, ['Odin_SoG_Order'] = 65, ['RammusDBC'] = 65, ['FizzShark'] = 65, ['LuluDragon'] = 50.0, ['OdinTestCubeRender'] = 65, ['OdinCrane'] = 65, ['TT_Tree1'] = 65, ['ARAMOrderTurretShrine'] = 88.4, ['TT_Chains_Order_Base'] = 65, ['Odin_Windmill_Gears'] = 65, ['ARAMChaosNexus'] = 65, ['TT_NWraith'] = 50.0, ['TT_OrderTurret4'] = 88.4, ['Odin_SOG_Chaos_Crystal'] = 65, ['TT_SpiderLayer_Web'] = 65, ['OdinQuestIndicator'] = 1.0, ['JarvanIVStandard'] = 65, ['TT_DummyPusher'] = 65, ['OdinClaw'] = 65, ['EliseSpiderling'] = 1.0, ['QuinnValor'] = 65, ['UdyrTigerUlt'] = 65, ['UdyrTurtleUlt'] = 65, ['UdyrUlt'] = 65, ['UdyrPhoenixUlt'] = 65, ['ShacoBox'] = 10, ['HA_AP_Poro'] = 65, ['AnnieTibbers'] = 80.0, ['UdyrPhoenix'] = 65, ['UdyrTurtle'] = 65, ['UdyrTiger'] = 65, ['HA_AP_OrderShrineTurret'] = 88.4, ['HA_AP_OrderTurretRubble'] = 65, ['HA_AP_Chains_Long'] = 65, ['HA_AP_OrderCloth'] = 65, ['HA_AP_PeriphBridge'] = 65, ['HA_AP_BridgeLaneStatue'] = 65, ['HA_AP_ChaosTurretRubble'] = 88.4, ['HA_AP_BannerMidBridge'] = 65, ['HA_AP_PoroSpawner'] = 50.0, ['HA_AP_Cutaway'] = 65, ['HA_AP_Chains'] = 65, ['HA_AP_ShpSouth'] = 65, ['HA_AP_HeroTower'] = 65, ['HA_AP_ShpNorth'] = 65, ['ChaosInhibitor_D'] = 65, ['ZacRebirthBloblet'] = 65, ['OrderInhibitor_D'] = 65, ['Nidalee_Spear'] = 65, ['Nidalee_Cougar'] = 65, ['TT_Buffplat_Chain'] = 65, ['WriggleLantern'] = 1, ['TwistedLizardElder'] = 65.0, ['RabidWolf'] = 65.0, ['HeimerTGreen'] = 50.0, ['HeimerTRed'] = 50.0, ['ViktorFF'] = 65, ['TwistedGolem'] = 80.0, ['TwistedSmallWolf'] = 50.0, ['TwistedGiantWolf'] = 65.0, ['TwistedTinyWraith'] = 50.0, ['TwistedBlueWraith'] = 50.0, ['TwistedYoungLizard'] = 50.0, ['Red_Minion_Melee'] = 48.0, ['Blue_Minion_Melee'] = 48.0, ['Blue_Minion_Healer'] = 48.0, ['Ghast'] = 60.0, ['blueDragon'] = 100.0, ['Red_Minion_MechRange'] = 65.0, ['Test_CubeSphere'] = 65,}

	ChampInfoTable = {}
	for i, enemy in ipairs(GetEnemyHeroes()) do
		ChampInfoTable[enemy.charName] = {CurrentVector = Vector(0,0,0), CurrentDirection = Vector(0,0,0), CurrentAngle = 0, CurrentHitBox = ChampHitBoxes[enemy.charName]}
	end


end