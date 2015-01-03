--[[
Script: MiniMapTimers by Aroc

v1.0 - Release
v1.1 - Fixed a Few Bugs
]]

local AllMiniMapObjects = {
    ['summonerRift'] = {
        [TEAM_BLUE] = {
            ['Red'] = {
                ['CampInfos'] = {
                    ['Name'] = 'RedBuff',
                    ['Spawn'] = 115,
                    ['Respawn'] = 300,
                    ['Pos'] = {7750, 4002},
                    ['DoPing'] = true,
                },
                ['SRU_Red4.1.1'] = {},
                ['SRU_RedMini4.1.2'] = {},
                ['SRU_RedMini4.1.3'] = {},
            },
            ['Krug'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Krugs',
                    ['Spawn'] = 115,
                    ['Respawn'] = 100,
                    ['Pos'] = {8414,2752},
                },
                ['SRU_Krug5.1.2'] = {},
                ['SRU_KrugMini5.1.1'] = {},
            },
            ['Razorbeak'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Razorbeaks',
                    ['Spawn'] = 115,
                    ['Respawn'] = 100,
                    ['Pos'] = {6974,5376},
                },
                ['SRU_Razorbeak3.1.1'] = {},
                ['SRU_RazorbeakMini3.1.2'] = {},
                ['SRU_RazorbeakMini3.1.3'] = {},
                ['SRU_RazorbeakMini3.1.4'] = {},
            },
            ['Gromp'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Gromp',
                    ['Spawn'] = 115,
                    ['Respawn'] = 100,
                    ['Pos'] = {2074,8356},
                },
                ['SRU_Gromp13.1.1'] = {},
            },
            ['Blue'] = {
                ['CampInfos'] = {
                    ['Name'] = 'BlueBuff',
                    ['Spawn'] = 115,
                    ['Respawn'] = 300,
                    ['Pos'] = {3916, 7858},
                    ['DoPing'] = true,
                },
                ['SRU_Blue1.1.1'] = {},
                ['SRU_BlueMini1.1.2'] = {},
                ['SRU_BlueMini21.1.3'] = {},
            },
            ['Wolves'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Wolves',
                    ['Spawn'] = 115,
                    ['Respawn'] = 300,
                    ['Pos'] = {3762,6500},
                },
                ['SRU_Murkwolf2.1.1'] = {},
                ['SRU_MurkwolfMini2.1.2'] = {},
                ['SRU_MurkwolfMini2.1.3'] = {},
            },
            ['MidInihibitor'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Midlane Inhibitor',
                    ['Spawn'] = 0,
                    ['Respawn'] = 240,
                    ['Pos'] = {3203, 3208},
                    ['DoPing'] = true,
                },
                ['Barracks_T1_C1'] = {},
            },
            ['BotInihibitor'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Botlane Inhibitor',
                    ['Spawn'] = 0,
                    ['Respawn'] = 240,
                    ['Pos'] = {3452, 1236},
                    ['DoPing'] = true,
                },
                ['Barracks_T1_R1'] = {},
            },
            ['TopInihibitor'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Toplane Inhibitor',
                    ['Spawn'] = 0,
                    ['Respawn'] = 240,
                    ['Pos'] = {1171, 3571},
                    ['DoPing'] = true,
                },
                ['Barracks_T1_L1'] = {},
            },
        },
        [TEAM_RED] = {
            ['Red'] = {
                ['CampInfos'] = {
                    ['Name'] = 'RedBuff',
                    ['Spawn'] = 115,
                    ['Respawn'] = 300,
                    ['Pos'] = {7024, 10886},
                    ['DoPing'] = true,
                },
                ['SRU_Red10.1.1'] = {},
                ['SRU_RedMini10.1.2'] = {},
                ['SRU_RedMini10.1.3'] = {},
            },
            ['Krug'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Krugs',
                    ['Spawn'] = 115,
                    ['Respawn'] = 100,
                    ['Pos'] = {6430,12172},
                },
                ['SRU_Krug11.1.2'] = {},
                ['SRU_KrugMini11.1.1'] = {},
            },
            ['Razorbeak'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Razorbeaks',
                    ['Spawn'] = 115,
                    ['Respawn'] = 100,
                    ['Pos'] = {7812,9496},
                },
                ['SRU_Razorbeak9.1.1'] = {},
                ['SRU_RazorbeakMini9.1.2'] = {},
                ['SRU_RazorbeakMini9.1.3'] = {},
                ['SRU_RazorbeakMini9.1.4'] = {},
            },
            ['Gromp'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Gromp',
                    ['Spawn'] = 115,
                    ['Respawn'] = 100,
                    ['Pos'] = {10910, 8314},
                },
                ['SRU_Gromp14.1.1'] = {},
            },
            ['Blue'] = {
                ['CampInfos'] = {
                    ['Name'] = 'BlueBuff',
                    ['Spawn'] = 115,
                    ['Respawn'] = 300,
                    ['Pos'] = {10922, 7058},
                    ['DoPing'] = true,
                },
                ['SRU_Blue7.1.1'] = {},
                ['SRU_BlueMini7.1.2'] = {},
                ['SRU_BlueMini27.1.3'] = {},
            },
            ['Wolves'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Wolves',
                    ['Spawn'] = 115,
                    ['Respawn'] = 100,
                    ['Pos'] = {12722, 6358},
                },
                ['SRU_Murkwolf8.1.1'] = {},
                ['SRU_MurkwolfMini8.1.2'] = {},
                ['SRU_MurkwolfMini8.1.3'] = {},
            },
            ['MidInihibitor'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Midlane Inhibitor',
                    ['Spawn'] = 0,
                    ['Respawn'] = 240,
                    ['Pos'] = {11598, 11667},
                    ['DoPing'] = true,
                },
                ['Barracks_T2_C1'] = {},
            },
            ['BotInihibitor'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Botlane Inhibitor',
                    ['Spawn'] = 0,
                    ['Respawn'] = 240,
                    ['Pos'] = {13604, 11316},
                    ['DoPing'] = true,
                },
                ['Barracks_T2_R1'] = {},
            },
            ['TopInihibitor'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Toplane Inhibitor',
                    ['Spawn'] = 0,
                    ['Respawn'] = 240,
                    ['Pos'] = {11261, 13676},
                    ['DoPing'] = true,
                },
                ['Barracks_T2_L1'] = {},
            },
        },
        [TEAM_NEUTRAL] = {
            ['Dragon'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Dragon',
                    ['Spawn'] = 150,
                    ['Respawn'] = 360,
                    ['Pos'] = {9808, 4388},
                    ['DoPing'] = true,
                },
                ['SRU_Dragon6.1.1'] = {},
            },
            ['Baron'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Baron',
                    ['Spawn'] = 1200,
                    ['Respawn'] = 420,
                    ['Pos'] = {4874, 10306},
                    ['DoPing'] = true,
                },
                ['SRU_Dragon6.1.1'] = {},
            },
            ['Crab_South'] = {
                ['CampInfos'] = {
                    ['Name'] = 'South Crab',
                    ['Spawn'] = 150,
                    ['Respawn'] = 180,
                    ['Pos'] = {10544,5206},
                },
                ['Sru_Crab15.1.1'] = {},
            },
            ['Crab_North'] = {
                ['CampInfos'] = {
                    ['Name'] = 'North Crab',
                    ['Spawn'] = 150,
                    ['Respawn'] = 180,
                    ['Pos'] = {4306,9650},
                },
                ['Sru_Crab16.1.1'] = {},
            },
        },
    },
    ['howlingAbyss'] = {
        [TEAM_RED] = {
            ['Inhibitor'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Inhibitor',
                    ['Spawn'] = 0,
                    ['Respawn'] = 240,
                    ['Pos'] = {9689, 9524},
                    ['DoPing'] = true,
                },
                ['Barracks_T2_C1'] = {},
            },
        },
        [TEAM_BLUE] = {
            ['Inhibitor'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Inhibitor',
                    ['Spawn'] = 0,
                    ['Respawn'] = 240,
                    ['Pos'] = {3110, 3189},
                    ['DoPing'] = true,
                },
                ['Barracks_T1_C1'] = {},
            },
        },
        [TEAM_NEUTRAL] = {
            ['Heal1'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Heal 1',
                    ['Spawn'] = 190,
                    ['Respawn'] = 41,
                    ['Pos'] = {7582, 6785},
                },
                ['HA_AP_HealthRelic1.1.1'] = {},
            },
            ['Heal2'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Heal 2',
                    ['Spawn'] = 190,
                    ['Respawn'] = 41,
                    ['Pos'] = {5929,5190},
                },
                ['HA_AP_HealthRelic2.1.1'] = {},
            },
            ['Heal3'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Heal 3',
                    ['Spawn'] = 190,
                    ['Respawn'] = 41,
                    ['Pos'] = {8893,7889},
                },
                ['HA_AP_HealthRelic3.1.1'] = {},
            },
            ['Heal4'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Heal 4',
                    ['Spawn'] = 190,
                    ['Respawn'] = 41,
                    ['Pos'] = {4790,3934},
                },
                ['HA_AP_HealthRelic4.1.1'] = {},
            },
        }
    },
    ['crystalScar'] = {
        ['HealPads'] = {
            [1] = {['Pos'] = {3639, 1490}, ['Spawn'] = 120, ['Respawn'] = 31,  },
            [2] = {['Pos'] = {6949, 2855}, ['Spawn'] = 120, ['Respawn'] = 31,  },
            [3] = {['Pos'] = {10242, 1519},['Spawn'] = 120, ['Respawn'] = 31,  },
            [4] = {['Pos'] = {9573, 5530}, ['Spawn'] = 120, ['Respawn'] = 31,  },
            [5] = {['Pos'] = {12881, 8294},['Spawn'] = 120, ['Respawn'] = 31,  },
            [6] = {['Pos'] = {8972, 9329}, ['Spawn'] = 120, ['Respawn'] = 31,  },
            [7] = {['Pos'] = {6947, 12116},['Spawn'] = 120, ['Respawn'] = 31,  },
            [8] = {['Pos'] = {4948, 9329}, ['Spawn'] = 120, ['Respawn'] = 31,  },
            [9] = {['Pos'] = {1027, 8288}, ['Spawn'] = 120, ['Respawn'] = 31,  },
            [10] = {['Pos'] = {4324, 5500},['Spawn'] = 120, ['Respawn'] = 31,  },
            [11] = {['Pos'] = {6401, 6462},['Spawn'] = 180, ['Respawn'] = 180, },
            [12] = {['Pos'] = {7474, 6462},['Spawn'] = 180, ['Respawn'] = 180, },
        }
    },
    ['twistedTreeline'] = {
        [TEAM_RED] = {
            ['TopInhibitor'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Toplane Inhibitor',
                    ['Spawn'] = 0,
                    ['Respawn'] = 240,
                    ['Pos'] = {2146, 8420},
                    ['DoPing'] = true,
                },
                ['Barracks_T1_L1'] = {},
            },
            ['BotInhibitor'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Botlane Inhibitor',
                    ['Spawn'] = 0,
                    ['Respawn'] = 240,
                    ['Pos'] = {2146, 6146},
                    ['DoPing'] = true,
                },
                ['Barracks_T1_R1'] = {},
            },

        },
        [TEAM_BLUE] = {
            ['TopInhibitor'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Toplane Inhibitor',
                    ['Spawn'] = 0,
                    ['Respawn'] = 240,
                    ['Pos'] = {13275, 8416},
                    ['DoPing'] = true,
                },
                ['Barracks_T2_L1'] = {},
            },
            ['BotInhibitor'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Botlane Inhibitor',
                    ['Spawn'] = 0,
                    ['Respawn'] = 240,
                    ['Pos'] = {13285, 6124},
                    ['DoPing'] = true,
                },
                ['Barracks_T2_R1'] = {},
            },

        },
        [TEAM_NEUTRAL] = {
            ['Altar_L'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Left Altar',
                    ['Spawn'] = 180,
                    ['Respawn'] = 90,
                    ['Pos'] = {5330, 6759},
                    ['DoPing'] = true,
                },
                ['TT_Audio-Altar_West_Unlocked.troy'] = {},
            },
            ['Altar_R'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Right Altar',
                    ['Spawn'] = 180,
                    ['Respawn'] = 90,
                    ['Pos'] = {10070, 6763},
                    ['DoPing'] = true,
                },
                ['TT_Audio-Altar_East_Unlocked.troy'] = {},
            },
            ['Wraith_L'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Left Wraiths',
                    ['Spawn'] = 100,
                    ['Respawn'] = 50,
                    ['Pos'] = {4398, 5817},
                },
                ['TT_NWraith1.1.1'] = {},
                ['TT_NWraith21.1.2'] = {},
                ['TT_NWraith21.1.3'] = {},
            },
            ['Golem_L'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Left Golems',
                    ['Spawn'] = 100,
                    ['Respawn'] = 50,
                    ['Pos'] = {5120,7937},
                },
                ['TT_NGolem2.1.1'] = {},
                ['TT_NWraith22.1.2'] = {},
            },
            ['Wolves_L'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Left Wolves',
                    ['Spawn'] = 100,
                    ['Respawn'] = 50,
                    ['Pos'] = {6084, 6099},
                },
                ['TT_NWolf3.1.1'] = {},
                ['TT_NWWolf23.1.2'] = {},
                ['TT_NWWolf23.1.3'] = {},
            },
            ['Wraith_R'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Right Wraiths',
                    ['Spawn'] = 100,
                    ['Respawn'] = 50,
                    ['Pos'] = {10984, 5835},
                },
                ['TT_NWraith4.1.1'] = {},
                ['TT_NWraith24.1.2'] = {},
                ['TT_NWraith24.1.3'] = {},
            },
            ['Golem_R'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Right Golems',
                    ['Spawn'] = 100,
                    ['Respawn'] = 50,
                    ['Pos'] = {10360, 7897},
                },
                ['TT_NGolem5.1.1'] = {},
                ['TT_NWraith25.1.2'] = {},
            },
            ['Wolves_R'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Right Wolves',
                    ['Spawn'] = 100,
                    ['Respawn'] = 50,
                    ['Pos'] = {9436, 6027},
                },
                ['TT_NWolf6.1.1'] = {},
                ['TT_NWWolf63.1.2'] = {},
                ['TT_NWWolf63.1.3'] = {},
            },
            ['Vilemaw'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Vilemaw',
                    ['Spawn'] = 600,
                    ['Respawn'] = 300,
                    ['Pos'] = {7734, 9833},
                    ['DoPing'] = true,
                },
                ['TT_Spiderboss8.1.1'] = {},
            },
            ['Relic'] = {
                ['CampInfos'] = {
                    ['Name'] = 'Health Relic',
                    ['Spawn'] = 180,
                    ['Respawn'] = 90,
                    ['Pos'] = {7731,6722},
                },
                ['TT_Relic7.1.1'] = {},
            },
        },
    },
}

local mapName = GetGame().map.shortName
local MiniMapObjects = AllMiniMapObjects[mapName]
local printspawntime = false

function OnLoad()
    AMM = scriptConfig("Minimap Timers", "AcMinimapTimers")
    AMM:addSubMenu('Own Team', 'OwnTeam')
    AMM.OwnTeam:addParam("ChatOnRespawn", "Chat on Respawn", SCRIPT_PARAM_ONOFF, true)
    AMM.OwnTeam:addParam("ChatPreRespawn", "Chat before Respawn", SCRIPT_PARAM_ONOFF, true)
    if VIP_USER then
        AMM.OwnTeam:addParam("PingOnRespawn", "Ping on Respawn", SCRIPT_PARAM_ONOFF, true)
        AMM.OwnTeam:addParam("PingPreRespawn", "Ping before Respawn", SCRIPT_PARAM_ONOFF, true)
    end

    AMM:addSubMenu('Enemy Team', 'EnemyTeam')
    AMM.EnemyTeam:addParam("ChatOnRespawn", "Chat on Respawn", SCRIPT_PARAM_ONOFF, true)
    AMM.EnemyTeam:addParam("ChatPreRespawn", "Chat before Respawn", SCRIPT_PARAM_ONOFF, true)
    if VIP_USER then
        AMM.EnemyTeam:addParam("PingOnRespawn", "Ping on Respawn", SCRIPT_PARAM_ONOFF, true)
        AMM.EnemyTeam:addParam("PingPreRespawn", "Ping before Respawn", SCRIPT_PARAM_ONOFF, true)
    end

    AMM:addSubMenu('Settings', 'Settings')
    AMM.Settings:addParam("Draw", "Draw on Minimap", SCRIPT_PARAM_ONOFF, true)
    AMM.Settings:addParam("AdviceTime", "Advice Time in Seconds", SCRIPT_PARAM_SLICE, 20, 1, 40, 0)
    AMM.Settings:addParam("TextSize", "TextSize on Minimap", SCRIPT_PARAM_SLICE, 11, 1, 30, 0)
    AMM.Settings:addParam('DrawColor', 'Color to Draw on Minimap', SCRIPT_PARAM_COLOR, {255, 255, 255, 255})

    if mapName == 'crystalScar' then return end
    for i=1, objManager.maxObjects, 1 do
        local obj = objManager:getObject(i)
        if obj and obj.name then
            for Team,Camps in pairs(MiniMapObjects) do
                for Camp, Creeps in pairs(Camps) do
                    if not Creeps['CampInfos']['MiniMap'] then
                        Creeps['CampInfos']['MiniMap'] = GetMinimap(Creeps['CampInfos']['Pos'][1],Creeps['CampInfos']['Pos'][2])
                    end
                    for Creep, Infos in pairs(Creeps) do
                        if Creep == obj.name then
                            Infos['Creep'] = obj
                            Creeps['CampInfos']['Seen'] = true
                        end
                    end
                end
            end
        end
    end
end

function OnTick()
    if mapName == 'crystalScar' then return end
    for Team,Camps in pairs(MiniMapObjects) do
        for Camp, Creeps in pairs(Camps) do
            Creeps['CampInfos'].Alive = false
            Creeps['CampInfos'].Missing = false
            for Creep, Infos in pairs(Creeps) do
                if Creep ~= 'CampInfos' and Creeps['CampInfos'].Seen then
                    if (Infos['Creep'] and Infos['Creep'].health and Infos['Creep'].health == 0) then
                        Infos['Creep'] = nil
                    end

                    if Infos['Creep'] then
                        Creeps['CampInfos'].Alive = true
                    else
                        Creeps['CampInfos'].Missing = true
                    end
                end
            end

            if Creeps['CampInfos'].Seen and not Creeps['CampInfos'].Alive and Creeps['CampInfos'].Missing and not Creeps['CampInfos'].NextRespawn then -- Camp died
                Creeps['CampInfos'].NextRespawn = GetInGameTimer() + Creeps['CampInfos'].Respawn
            end

            local TeamText = ''
            if Team == myHero.team then TeamText = 'Our ' end
            if Team == TEAM_ENEMY then TeamText = 'Their ' end

            if Creeps['CampInfos']['NextRespawn'] and Creeps['CampInfos']['NextRespawn'] < GetInGameTimer() then -- Camp respawned
                Creeps['CampInfos'].Seen = false
                Creeps['CampInfos'].NextRespawn = nil
                Creeps['CampInfos'].DidAdvice = false
                if Creeps['CampInfos']['DoPing'] then
                    if AMM[myHero.team == Team and 'OwnTeam' or 'EnemyTeam']['ChatOnRespawn'] then
                        print("<font color='#00FFCC'>"..TeamText..Creeps['CampInfos']['Name'].."</font><font color='#FFAA00'> has respawned</font>")
                    end
                    if VIP_USER and AMM[myHero.team == Team and 'OwnTeam' or 'EnemyTeam']['PingOnRespawn'] then
                        PingOnPos(Creeps['CampInfos']['Pos'][1],Creeps['CampInfos']['Pos'][2])
                    end
                end
            end

            if Creeps['CampInfos']['NextRespawn'] and (Creeps['CampInfos']['NextRespawn'] - AMM.Settings.AdviceTime) < GetInGameTimer() and not Creeps['CampInfos'].DidAdvice and Creeps['CampInfos']['DoPing'] then
                Creeps['CampInfos'].DidAdvice = true
                if AMM[myHero.team == Team and 'OwnTeam' or 'EnemyTeam']['ChatPreRespawn'] then
                    print("<font color='#00FFCC'>"..TeamText..Creeps['CampInfos']['Name'].."</font><font color='#FFAA00'> respawns in </font><font color='#00FFCC'>"..AMM.Settings.AdviceTime.." sec</font>")
                end
                if VIP_USER and AMM[myHero.team == Team and 'OwnTeam' or 'EnemyTeam']['PingPreRespawn'] then
                    PingOnPos(Creeps['CampInfos']['Pos'][1],Creeps['CampInfos']['Pos'][2])
                end
            end

            if not Creeps['CampInfos']['NextRespawn'] and GetInGameTimer() < Creeps['CampInfos']['Spawn'] + 1 and Creeps['CampInfos']['DoPing'] and not Creeps['CampInfos']['Name']:find('Inhibitor') then
                if (Creeps['CampInfos']['Spawn'] - AMM.Settings.AdviceTime) < GetInGameTimer() and not Creeps['CampInfos']['DidFirstAdvice'] then
                    Creeps['CampInfos']['DidFirstAdvice'] = true
                    if AMM[myHero.team == Team and 'OwnTeam' or 'EnemyTeam']['ChatPreRespawn'] then
                        print("<font color='#00FFCC'>"..TeamText..Creeps['CampInfos']['Name'].."</font><font color='#FFAA00'> spawns in </font><font color='#00FFCC'>"..AMM.Settings.AdviceTime.." sec</font>")
                    end
                    if VIP_USER and AMM[myHero.team == Team and 'OwnTeam' or 'EnemyTeam']['PingPreRespawn'] then
                        PingOnPos(Creeps['CampInfos']['Pos'][1],Creeps['CampInfos']['Pos'][2])
                    end
                end

                if Creeps['CampInfos']['Spawn'] < GetInGameTimer() and not Creeps['CampInfos']['DidFirstAdvice2'] then
                    Creeps['CampInfos']['DidFirstAdvice2'] = true
                    if AMM[myHero.team == Team and 'OwnTeam' or 'EnemyTeam']['ChatOnRespawn'] then
                        print("<font color='#00FFCC'>"..TeamText..Creeps['CampInfos']['Name'].."</font><font color='#FFAA00'> has spawned</font>")
                    end
                    if VIP_USER and AMM[myHero.team == Team and 'OwnTeam' or 'EnemyTeam']['PingOnRespawn'] then
                        PingOnPos(Creeps['CampInfos']['Pos'][1],Creeps['CampInfos']['Pos'][2])
                    end
                end
            end
        end
    end
end

function OnDraw()
    if not AMM.Settings.Draw then return end
    if mapName == 'crystalScar' then
        for i=1,#MiniMapObjects['HealPads'] do
            local HealPad = MiniMapObjects['HealPads'][i]
            local GameTime = GetInGameTimer()
            if GameTime < HealPad['Spawn'] and not HealPad['NextSpawn'] then HealPad['NextSpawn'] = HealPad['Spawn'] end
            if HealPad['NextSpawn'] and HealPad['NextSpawn'] > GameTime then
                if printspawntime then GameTime = 0 end
                local Min = math.floor((HealPad['NextSpawn'] - GameTime)/60)
                local Sec = math.floor(HealPad['NextSpawn'] - GameTime - (Min*60))
                if Sec < 10 then Sec = '0'..Sec end
                local MiniMapPos = GetMinimap(HealPad['Pos'][1], HealPad['Pos'][2])
                DrawText(Min..':'..Sec, 11, MiniMapPos['x']-10, MiniMapPos['y']-4, ARGB(AMM.Settings.DrawColor[1],AMM.Settings.DrawColor[2],AMM.Settings.DrawColor[3],AMM.Settings.DrawColor[4]))
            end
        end
    else
        local GameTime = GetInGameTimer()
        for Team,Camps in pairs(MiniMapObjects) do
            for Camp, Creeps in pairs(Camps) do
                if GameTime < Creeps['CampInfos']['Spawn'] then -- Pre Init Spawn
                    local Min = math.floor((Creeps['CampInfos']['Spawn'] - GameTime)/60)
                    local Sec = math.ceil(Creeps['CampInfos']['Spawn'] - GameTime - (Min*60))
                    if Sec < 10 then Sec = '0'..Sec end
                    DrawText(Min..':'..Sec, AMM.Settings.TextSize, Creeps['CampInfos']['MiniMap'].x-10, Creeps['CampInfos']['MiniMap'].y-4, ARGB(AMM.Settings.DrawColor[1],AMM.Settings.DrawColor[2],AMM.Settings.DrawColor[3],AMM.Settings.DrawColor[4]))
                else
                    if Creeps['CampInfos']['NextRespawn'] then
                        local Min = math.floor((Creeps['CampInfos']['NextRespawn'] - GameTime)/60)
                        local Sec = math.ceil(Creeps['CampInfos']['NextRespawn'] - GameTime - (Min*60))
                        if Sec < 10 then Sec = '0'..Sec end
                        DrawText(Min..':'..Sec, AMM.Settings.TextSize, Creeps['CampInfos']['MiniMap'].x-10, Creeps['CampInfos']['MiniMap'].y-4, ARGB(AMM.Settings.DrawColor[1],AMM.Settings.DrawColor[2],AMM.Settings.DrawColor[3],AMM.Settings.DrawColor[4]))
                    end
                end
            end
        end
    end
end

function OnCreateObj(obj)
    DelayAction(function()
        if mapName == 'crystalScar' then
            if obj and obj.type and obj.type == 'obj_GeneralParticleEmitter' and obj.name == 'odin_heal_rune.troy' then
                for i=1,#MiniMapObjects['HealPads'] do
                    local HealPad = MiniMapObjects['HealPads'][i]
                    if math.floor(obj.x) == HealPad['Pos'][1] and math.floor(obj.z) == HealPad['Pos'][2] then
                        HealPad['NextSpawn'] = nil
                    end
                end
            end
        else
            if obj and obj.name and (obj.type == 'obj_AI_Minion' or obj.type == 'obj_BarracksDampener') and not obj.name:find('Minion') then
                for Team,Camps in pairs(MiniMapObjects) do
                    for Camp, Creeps in pairs(Camps) do
                        for Creep, Infos in pairs(Creeps) do
                            if Creep == obj.name then
                                Infos['Creep'] = obj
                                Creeps['CampInfos']['Seen'] = true
                            end
                        end
                    end
                end
            end
        end
    end, 0.1)
end

function OnDeleteObj(obj)
    if mapName == 'crystalScar' then
        if obj and obj.name and obj.name == 'odin_heal_rune.troy' then
            for i=1,#MiniMapObjects['HealPads'] do
                local HealPad = MiniMapObjects['HealPads'][i]
                if math.floor(obj.x) == HealPad['Pos'][1] and math.floor(obj.z) == HealPad['Pos'][2] then
                    HealPad['NextSpawn'] = GetInGameTimer() + HealPad['Respawn']
                end
            end
        end
    else
        if obj and obj.name and (obj.type == 'obj_AI_Minion' or obj.type == 'obj_BarracksDampener') and not obj.name:find('Minion') then
            for Team,Camps in pairs(MiniMapObjects) do
                for Camp, Creeps in pairs(Camps) do
                    for Creep, Infos in pairs(Creeps) do
                        if Creep == obj.name then
                            Infos['Creep'] = nil
                        end
                    end
                end
            end
        end
    end
end

function PingOnPos(PosX, PosY)
    local myp = CLoLPacket(0x0060)
    myp:Encode4(0)
    myp:Encode4(0)
    myp:Encode1(5)
    myp:EncodeF(0)
    myp:EncodeF(PosX)
    myp:EncodeF(PosY)
    myp:Encode1(11)
    RecvPacket(myp)
end