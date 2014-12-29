if myHero.charName ~= "Vayne" or not VIP_USER then return end

local DoTumble = false

function OnSendPacket(p)
    if p.header == 0x00DE then
        p.pos = 26
        if p:Decode1() == _Q and not DoTumble then

            if  GetDistanceSqr(mousePos, Point(12060, 4806)) < 80*80 then
                myHero:MoveTo(12060, 4806)
                DoTumble = 1
                p:Block()
            end

            if GetDistanceSqr(mousePos, Point(6962, 8952)) < 80*80 then
                myHero:MoveTo(6962, 8952)
                DoTumble = 2
                p:Block()
            end
        elseif DoTumble then
            DoTumble = false
        end
    end
end

function OnTick()
    if DoTumble == 1 then
        if myHero.x == 12060 and myHero.z == 4806 then
            CastSpell(_Q,11745.198242188,4625.4379882813)
        else
            myHero:MoveTo(12060, 4806)
        end
    elseif DoTumble == 2 then
        if myHero.x == 6962 and myHero.z == 8952 then
            CastSpell(_Q,6667.3271484375,8794.64453125)
        else
            myHero:MoveTo(6962, 8952)
        end
    end
end

function OnDraw()
    if GetDistanceSqr(mousePos, Point(12060, 4806)) > 80*80 then
        DrawCircle(12060, 51, 4806,80, ARGB(0xFF,0xFF,0,0))
    else
        DrawCircle(12060, 51, 4806,80, ARGB(0xFF,0,0xFF,0))
    end

    if GetDistanceSqr(mousePos, Point(6962, 8952)) > 80*80 then
        DrawCircle(6962, 51, 8952,80, ARGB(0xFF,0xFF,0,0))
    else
        DrawCircle(6962, 51, 8952,80, ARGB(0xFF,0,0xFF,0))
    end
end