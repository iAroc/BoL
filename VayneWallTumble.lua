if myHero.charName ~= "Vayne" then return end
if not VIP_USER then return end

local TumbleSpots = {
		["VisionPos_1"] = { ["x"] = 11589, ["y"] = 52, ["z"] = 4657 },
		["VisionPos_2"] = { ["x"] = 6623, ["y"] = 56, ["z"] = 8649 },
		["StandPos_1"] = { ["x"] = 11590.95, ["y"] = 4656.26 },
		["StandPos_2"] = { ["x"] = 6623.00, ["y"] = 8649.00 },
		["CastPos_1"] = { ["x"] = 11334.74, ["y"] = 4517.47 },
		["CastPos_2"] = { ["x"] = 6010.5869140625, ["y"] = 8508.8740234375 }
	}


function OnLoad()
AddDrawCallback(_WallTumbleDraw)
AddTickCallback(_WallTumble)
end

function RoundNumber(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

function _WallTumble()
	if VIP_USER then
		if TumbleOverWall_1 then
			if myHero:CanUseSpell(_Q) ~= READY then TumbleOverWall_1 = false;myHero:HoldPosition() end
			if GetDistance(TumbleSpots.StandPos_1) <= 25 then
				TumbleOverWall_1 = false
				CastSpell(_Q, TumbleSpots.CastPos_1.x,  TumbleSpots.CastPos_1.y)
				myHero:HoldPosition()
			else
				if GetDistance(TumbleSpots.StandPos_1) > 25 then myHero:MoveTo(TumbleSpots.StandPos_1.x, TumbleSpots.StandPos_1.y) end
			end
		end
		if TumbleOverWall_2 then
			if myHero:CanUseSpell(_Q) ~= READY then TumbleOverWall_2 = false;myHero:HoldPosition() end
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
		if GetDistance(TumbleSpots.VisionPos_1) < 125 or GetDistance(TumbleSpots.VisionPos_1, mousePos) < 125 then
			DrawCircle(TumbleSpots.VisionPos_1.x, TumbleSpots.VisionPos_1.y, TumbleSpots.VisionPos_1.z, 100, 0x107458)
		else
			DrawCircle(TumbleSpots.VisionPos_1.x, TumbleSpots.VisionPos_1.y, TumbleSpots.VisionPos_1.z, 100, 0x80FFFF)
		end
		if GetDistance(TumbleSpots.VisionPos_2) < 125 or GetDistance(TumbleSpots.VisionPos_2, mousePos) < 125 then
			DrawCircle(TumbleSpots.VisionPos_2.x, TumbleSpots.VisionPos_2.y, TumbleSpots.VisionPos_2.z, 100, 0x107458)
		else
			DrawCircle(TumbleSpots.VisionPos_2.x, TumbleSpots.VisionPos_2.y, TumbleSpots.VisionPos_2.z, 100, 0x80FFFF)
		end
	end
end

function OnSendPacket(p)
	if p.header == _G.Packet.headers.S_CAST then
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

	if p.header == _G.Packet.headers.S_MOVE then
		p.pos = 1
		P_NetworkID = p:DecodeF()
		p:Decode1()
		P_X = p:DecodeF()
		P_X2 = tonumber(string.format("%." .. (2) .. "f", P_X))

		P_Y = p:DecodeF()
		P_Y2 = tonumber(string.format("%." .. (2) .. "f", P_Y))
		if TumbleOverWall_1 == true then
			RunToX, RunToY = TumbleSpots.StandPos_1.x, TumbleSpots.StandPos_1.y
			if not (P_X2 == RunToX and P_Y2 == RunToY) then
				p:Block()
				myHero:MoveTo(TumbleSpots.StandPos_1.x, TumbleSpots.StandPos_1.y)
			end
		end
		if TumbleOverWall_2 == true then
			RunToX, RunToY = TumbleSpots.StandPos_2.x, TumbleSpots.StandPos_2.y
			if not (P_X2 == RunToX and P_Y2 == RunToY) then
				p:Block()
				myHero:MoveTo(TumbleSpots.StandPos_2.x, TumbleSpots.StandPos_2.y)
			end
		end
	end
end