--[[

	Shadow Vayne Script by Superx321

	For Functions & Changelog, check the Thread on the BoL Forums:
	http://botoflegends.com/forum/topic/18939-shadow-vayne-the-mighty-hunter/
	]]
if myHero.charName ~= "Vayne" then return end


------------------------
------ AutoUpdate ------
------------------------
_OwnEnv = GetCurrentEnv().FILE_NAME:gsub(".lua", "")
DrawDoneDelay = 5
_G.DebugAutoUpdate = true
_G.VayneScriptName = "ShadowVayne"
version = 0.4

function _ScriptAutoUpdate(StartMessage)

	_AutoUpdates = {
-- Name				Host							Type		Version													Script																												VersionCheckString, LocalVersion, ServerVersion
{"VPrediction",		"raw.githubusercontent.com",	"Lib",		"/Hellsing/BoL/master/version/VPrediction.version",		"/Hellsing/BoL/master/common/VPrediction.lua",																		"local version",nil,nil},
--{"SOW",				"raw.githubusercontent.com",	"Lib",		"/Hellsing/BoL/master/version/SOW.version",				"/Hellsing/BoL/master/common/SOW.lua",																				"local version",nil,nil},
{"SourceLib",		"raw.githubusercontent.com",	"Lib",		"/TheRealSource/public/master/common/SourceLib.version","/TheRealSource/public/master/common/SourceLib.lua",																"local version",nil,nil},
{"Selector",		"raw.githubusercontent.com",	"Lib",		"/pqmailer/BoL_Scripts/master/Paid/Selector.revision",	"/pqmailer/BoL_Scripts/master/Paid/Selector.lua",																	"@version",nil,nil},
{"CustomPermaShow",	"raw.githubusercontent.com",	"Lib",		"/Superx321/BoL/master/common/CustomPermaShow.Version",	"/Superx321/BoL/master/common/CustomPermaShow.lua",																	"version =",nil,nil},
{"ShadowVayneLib",	"raw.githubusercontent.com",	"Lib",		"/Superx321/BoL/master/common/ShadowVayneLib.Version",	"/Superx321/BoL/master/common/ShadowVayneLib.lua",																	"version =",nil,nil},
{"Prodiction",		"bitbucket.org",				"Lib",		nil,													"/Klokje/public-klokjes-bol-scripts/raw/1467bf108b116274f8763693b00b7d977faf7735/Test/Prodiction/Prodiction.lua",	"--Prodiction",nil,1.1},
{_OwnEnv,			"raw.githubusercontent.com",	"Script",	"/Superx321/BoL/master/ShadowVayne.Version",			"/Superx321/BoL/master/ShadowVayne.lua",																			"version =",nil,nil},
}
	NeedUpdateTable = {}
	UpdateDrawMsgs = {}
	function _Receive()
		if Error then return end
		if not UpdateVersionDone then
			if not UpdateVersionStarted then
				TcpVersionSocket = socket.connect("sx-bol.de", 80)
				if type(TcpVersionSocket) == "userdata" then
					_AddUpdateDrawMsg("VersionSocket Connected", "green")
				else
					_AddUpdateDrawMsg("Failed to Connect VersionSocket", "red")
					Error = true
					return
				end
				_CheckOnlineVersion = {}
				for i=1,#_AutoUpdates do
					if _AutoUpdates[i][4] ~= nil then
						table.insert(_CheckOnlineVersion, _AutoUpdates[i])
					end
				end

				SendString = "GET /BoL/ScriptUpdates/VersionCheck.php?count="..#_CheckOnlineVersion
				for i=1,#_CheckOnlineVersion do
					SendString = SendString .. "&"..i.."_script=".._CheckOnlineVersion[i][4].."&"..i.."_host=".._CheckOnlineVersion[i][2]
				end
				_AddUpdateDrawMsg("Sending VersionCheck")
				TcpVersionSocket:send(SendString .. " HTTP/1.0\r\n\r\n")
				UpdateVersionStarted = true
			end
			TcpVersionSocket:settimeout(0)
			 TcpVersionReceive, TcpVersionStatus = TcpVersionSocket:receive('*a')
			if TcpVersionStatus ~= "timeout" then
				if TcpVersionReceive ~= nil then
					_AddUpdateDrawMsg("Got VersionCheck answer", "green")
					_AddUpdateDrawMsg("", "green")
					for i=1,#_CheckOnlineVersion do
						_CheckOnlineVersion[i][7] = tonumber(_GetVersion(_CheckOnlineVersion[i][1])) or 0
						_CheckOnlineVersion[i][8] = tonumber(string.sub(TcpVersionReceive, string.find(TcpVersionReceive, "<"..i.."_script>")+10, string.find(TcpVersionReceive, "</"..i.."_script>")-1))

						if _CheckOnlineVersion[i][8] > _CheckOnlineVersion[i][7] then
							_AddUpdateDrawMsg(_CheckOnlineVersion[i][1].." needs an Update (Local: ".._CheckOnlineVersion[i][7]..", Server: ".._CheckOnlineVersion[i][8]..")", "red")
--~ 							_PrintUpdateMsg("Updateing (".._CheckOnlineVersion[i][7].." => ".._CheckOnlineVersion[i][8].."), please wait...", _CheckOnlineVersion[i][1])
							table.insert(NeedUpdateTable, _CheckOnlineVersion[i])
						else
							_AddUpdateDrawMsg(_CheckOnlineVersion[i][1].." dont need an Update (Local: ".._CheckOnlineVersion[i][7]..", Server: ".._CheckOnlineVersion[i][8]..")", "green")
						end
					end
					UpdateVersionDone = true
				else
					if not retry then retry = 1 else retry = retry + 1 end
					_AddUpdateDrawMsg("VersionCheck was nil, retry["..retry.."]", "red")
					TcpVersionSocket = socket.connect("sx-bol.de", 80)
					if type(TcpVersionSocket) == "userdata" then
						_AddUpdateDrawMsg("VersionSocket Connected, retry["..retry.."]", "green")
					else
						_AddUpdateDrawMsg("Failed to Connect VersionSocket, retry["..retry.."]", "red")
						Error = true
						return
					end
					SendString = "GET /BoL/ScriptUpdates/VersionCheck.php?count="..#_CheckOnlineVersion
					for i=1,#_CheckOnlineVersion do
						SendString = SendString .. "&"..i.."_script=".._CheckOnlineVersion[i][4]
					end
					TcpVersionSocket:send(SendString .. " HTTP/1.0\r\n\r\n")
				end
			end
		end

		if UpdateVersionDone and not CheckRestVersions then
			for i=1,#_AutoUpdates do
				if _AutoUpdates[i][4] == nil then
					_AutoUpdates[i][7] = tonumber(_GetVersion(_AutoUpdates[i][1])) or 0
					if _AutoUpdates[i][8] > _AutoUpdates[i][7] then
						_AddUpdateDrawMsg(_AutoUpdates[i][1].." needs an Update (Local: ".._AutoUpdates[i][7]..", Server: ".._AutoUpdates[i][8]..")", "red")
--~ 						_PrintUpdateMsg("Updating (".._AutoUpdates[i][7].." => ".._AutoUpdates[i][8].."), please wait...", _AutoUpdates[i][1])
						table.insert(NeedUpdateTable, _AutoUpdates[i])
					else
						_AddUpdateDrawMsg(_AutoUpdates[i][1].." dont need an Update (Local: ".._AutoUpdates[i][7]..", Server: ".._AutoUpdates[i][8]..")", "green")
					end
				end
			end
			CheckRestVersions = true
		end

		if CheckRestVersions and not UpdateScriptDone then
			_AddUpdateDrawMsg("", "green")
			for i=1,#NeedUpdateTable do
				TcpScriptSocket = socket.connect("sx-bol.de", 80)
				if type(TcpScriptSocket) == "userdata" then
					_AddUpdateDrawMsg("ScriptSocket("..NeedUpdateTable[i][1]..") Connected", "green")
				else
					_AddUpdateDrawMsg("Failed to Connect ScriptSocket("..NeedUpdateTable[i][1]..")", "red")
					Error = true
					return
				end
				SendString = "GET /BoL/ScriptUpdates/ScriptDownload.php?path="..NeedUpdateTable[i][5].."&host="..NeedUpdateTable[i][2]
				TcpScriptSocket:send(SendString .. " HTTP/1.0\r\n\r\n")
				ServerScript = TcpScriptSocket:receive('*a')
				if ServerScript == nil then	_AddUpdateDrawMsg("ScriptUpdate("..NeedUpdateTable[i][1]..") answer was nil", "red") else
					_AddUpdateDrawMsg("Script("..NeedUpdateTable[i][1]..") Updated", "green")
--~ 					_PrintUpdateMsg("Updated ("..NeedUpdateTable[i][7].." => "..NeedUpdateTable[i][8]..")", NeedUpdateTable[i][1])
					SaveString = string.sub(ServerScript, string.find(ServerScript, "<script>")+8, string.find(ServerScript, "</script>")-1)
					_AddUpdateDrawMsg("Updated(".. NeedUpdateTable[i][1] ..") String Lengh: "..string.len(SaveString))
					if string.len(SaveString) > 1000 then
						_SaveToFile(NeedUpdateTable[i][1], SaveString)
					else
						_AddUpdateDrawMsg(NeedUpdateTable[i][1]..": UpdateString to short", "red")
					end
				end
			end
			UpdateScriptDone = true
			_AddUpdateDrawMsg("AutoUpdate Ended")
		end

		if UpdateScriptDone then
			if not AutoUpdateDone then
				for i=1,#_AutoUpdates do
					if _AutoUpdates[i][3] == "Lib" then
						_RequireWithoutUpdate(_AutoUpdates[i][1])
					end
				end
				_OnLoad()
				AutoUpdateDone = true
				_PrintUpdateMsg("Version ".. _G.CassioVersion .." loaded")
				DelayAction(function() _G.DebugAutoUpdate = false end, DrawDoneDelay)
			end
		end
	end

	function _GetVersion(_ScriptName)
		for i = 1,#_AutoUpdates do
			if _AutoUpdates[i][1] == _ScriptName then
				if _AutoUpdates[i][3] == "Lib" then
					SavePath = LIB_PATH.._ScriptName..".lua"
				else
					SavePath = SCRIPT_PATH.._ScriptName..".lua"
				end
				LibNumber = i
				break
			end
		end

		if FileExist(SavePath) then
			_ScriptFile = io.open(SavePath, "r")
			_ScriptString = _ScriptFile:read("*a")
			_ScriptFile:close()
			_ScriptVersionPos = _ScriptString:find(_AutoUpdates[LibNumber][6])
			if _ScriptVersionPos ~= nil then
				_ScriptVersionString = string.sub(_ScriptString, _ScriptVersionPos + string.len(_AutoUpdates[LibNumber][6]) + 1, _ScriptVersionPos + string.len(_AutoUpdates[LibNumber][6]) + 1 + 10)
				_ScriptVersion = string.match(_ScriptVersionString, "%d *.*%d")
			end
			if _ScriptVersion == 2.431 then _ScriptVersion = math.huge end -- VPred 2.431
			if _ScriptVersion == nil then _ScriptVersion = 0 end
			return _ScriptVersion
		else
			return 0
		end
	end

	function _SwapAutoUpdate(SwapState, _ScriptName)
		_ScriptNameFile = io.open(LIB_PATH.._ScriptName..".lua", "r")
		_ScriptNameString = _ScriptNameFile:read("*a")
		_ScriptNameFile:close()
		if SwapState == "true" then
			_ScriptNameString = _ScriptNameString:gsub("AUTOUPDATE = false", "AUTOUPDATE = true") 		-- SOW & VPrediction
			_ScriptNameString = _ScriptNameString:gsub("autoUpdate   = false", "autoUpdate   = true") 	-- SourceLib
			_ScriptNameString = _ScriptNameString:gsub("AutoUpdate = false", "AutoUpdate = true") 		-- Selector
		else
			_ScriptNameString = _ScriptNameString:gsub("AUTOUPDATE = true", "AUTOUPDATE = false") 		-- SOW & VPrediction
			_ScriptNameString = _ScriptNameString:gsub("autoUpdate   = true", "autoUpdate   = false") 	-- SourceLib
			_ScriptNameString = _ScriptNameString:gsub("AutoUpdate = true", "AutoUpdate = false") 		-- Selector
		end
		_ScriptNameFile = io.open(LIB_PATH.._ScriptName..".lua", "w+")
		_ScriptNameFile:write(_ScriptNameString)
		_ScriptNameFile:close()
	end

	function _RequireWithoutUpdate(_ScriptName)
		_SwapAutoUpdate("false", _ScriptName)
		loadfile(LIB_PATH .. _ScriptName..".lua")()
		_SwapAutoUpdate("true", _ScriptName)
	end

	function _PrintUpdateMsg(Msg, _ScriptName)
		if _ScriptName == nil or _ScriptName == _OwnEnv then
			print("<font color=\"#F0Ff8d\"><b>".._G.VayneScriptName..":</b></font> <font color=\"#FF0F0F\">"..Msg.."</font>")
		else
			print("<font color=\"#F0Ff8d\"><b>".._G.VayneScriptName.."(".._ScriptName.."):</b></font> <font color=\"#FF0F0F\">"..Msg.."</font>")
		end
	end

	function _SaveToFile(_ScriptName, RawScript)
		for i = 1,#_AutoUpdates do
			if _AutoUpdates[i][1] == _ScriptName then
				if _AutoUpdates[i][3] == "Lib" then
					SavePath = LIB_PATH.._ScriptName..".lua"
				else
					SavePath = SCRIPT_PATH.._ScriptName..".lua"
				end
				break
			end
		end
		_ScriptNameFile = io.open(SavePath, "w+")
		_ScriptNameFile:write(RawScript)
		_ScriptNameFile:close()
	end

	function _AddUpdateDrawMsg(Msg, Color)
		local AlradyAdded = false
		for i=1,#UpdateDrawMsgs do
			if UpdateDrawMsgs[i][1] == Msg then
				AlradyAdded = true
				break
			end
		end

		if not AlradyAdded then
			if Color == nil then Color = "white" end
			table.insert(UpdateDrawMsgs, {Msg, Color})
		end
	end

	function _DrawUpdateMsg()
		if _G.DebugAutoUpdate then
			Color = {
			["white"] =RGBA(0xFF,0xFF,0xFF,0xFF),
			["green"] =RGBA(0x45,0x8B,0x00,0xFF),
			["red"] =RGBA(0xB2,0x22,0x22,0xFF),
			}
			for i=1,#UpdateDrawMsgs do
				DrawText(UpdateDrawMsgs[i][1], 15, 10, i*11, Color[UpdateDrawMsgs[i][2]])
			end
		end
	end


	if StartMessage ~= nil then _PrintUpdateMsg(StartMessage, ScriptName) end
	_AddUpdateDrawMsg("Init AutoUpdate")
	socket = require("socket")
	AddTickCallback(_Receive)
	AddDrawCallback(_DrawUpdateMsg)
end


-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------

------------------------
------ MainScript ------
------------------------
function _PrintScriptMsg(Msg)
	PrintChat("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">"..Msg.."</font>")
end

function _SwapAutoUpdate(SwapState, LibName)
	LibNameFile = io.open(LIB_PATH.."/"..LibName..".lua", "r")
	LibNameString = LibNameFile:read("*a")
	LibNameFile:close()
	if SwapState == "true" then
		LibNameString = LibNameString:gsub("AUTOUPDATE = false", "AUTOUPDATE = true") 		-- SOW & VPrediction
		LibNameString = LibNameString:gsub("autoUpdate   = false", "autoUpdate   = true") 	-- SourceLib
		LibNameString = LibNameString:gsub("AutoUpdate = false", "AutoUpdate = true") 		-- Selector
	else
		LibNameString = LibNameString:gsub("AUTOUPDATE = true", "AUTOUPDATE = false") 		-- SOW & VPrediction
		LibNameString = LibNameString:gsub("autoUpdate   = true", "autoUpdate   = false") 	-- SourceLib
		LibNameString = LibNameString:gsub("AutoUpdate = true", "AutoUpdate = false") 		-- Selector
	end
	LibNameFile = io.open(LIB_PATH..LibName..".lua", "w+")
	LibNameFile:write(LibNameString)
	LibNameFile:close()
end

function _RequireWithoutUpdate(LibName)
_SwapAutoUpdate("false", LibName)
require (LibName)
_SwapAutoUpdate("true", LibName)
end

function OnLoad()
	_PrintUpdateMsg("Checking Libs Updates, please wait...")
	_AutoUpdate()
end

function OnTick() if type(_OnTick) == "function" then _OnTick() end end
function OnProcessSpell(unit, spell) if type(_OnProcessSpell) == "function" then _OnProcessSpell(unit, spell) end  end
function OnCreateObj(Obj) if type(_OnCreateObj) == "function" then _OnCreateObj(Obj) end  end
function OnWndMsg(msg, key) if type(_OnWndMsg) == "function" then _OnWndMsg(msg, key) end  end
function OnDraw() if type(_OnDraw) == "function" then _OnDraw() end  end
function OnCreateObj(Obj) if type(_OnCreateObj) == "function" then _OnCreateObj(Obj) end  end
function OnSendPacket(p) if type(_OnSendPacket) == "function" then _OnSendPacket(p) end  end


------------------------
---- AddParam Hooks ----
------------------------
_G.scriptConfig.CustomaddParam = _G.scriptConfig.addParam
_G.scriptConfig.addParam = function(self, pVar, pText, pType, defaultValue, a, b, c, d)

 -- MMA Hook
if self.name == "MMA2013" and pText:find("OnHold") then
	pType = 5
end

-- SAC:Reborn r83 Hook
if self.name:find("sidasacsetup_sidasac") and (pText == "Auto Carry" or pText == "Mixed Mode" or pText == "Lane Clear" or pText == "Last Hit") then
	pType=5
end

-- SAC:Reborn r84 Hook
if self.name:find("sidasacsetup_sidasac") and (pText == "Hotkey") then
	pType=5
end

-- SAC:Reborn VayneMenu Hook
if self.name:find("sidasacvayne") then
	pType=5
end

-- SOW Hook
if self.name == "SV_SOW" and pVar:find("Mode") then
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

	if self.name:find("sidasacsetup_sidasac") and (self._param[varIndex].text == "Hotkey") then
		self._param[varIndex].text = "ShadowVayne found. Set the Keysettings there!"
		self._param[varIndex].var = "sep"
	end

	if self.name == "MMA2013" and (self._param[varIndex].text:find("Spells on") or self._param[varIndex].text:find("Version")) then
	HideParam = true
		if not MMAParams then
			MMAParams = true
			self:addParam("nil","ShadowVayne found. Set the Keysettings there!", SCRIPT_PARAM_INFO, "")
			self:addParam("nil","ShadowVayne found. Set the Keysettings there!", SCRIPT_PARAM_INFO, "")
			self:addParam("nil","ShadowVayne found. Set the Keysettings there!", SCRIPT_PARAM_INFO, "")
			self:addParam("nil","ShadowVayne found. Set the Keysettings there!", SCRIPT_PARAM_INFO, "")
			self:addParam(self._param[varIndex].var, "Use Spells On", SCRIPT_PARAM_LIST,1, {"None","All Units","Heroes Only","Minion Only"})
			self:addParam("mmaVersion","MMA - version:", SCRIPT_PARAM_INFO, "0.1408")
		end
	end

	if self.name:find("sidasacvayne") and not self._param[varIndex].text:find("ShadowVayne") then
		if not SACVayneParam then
			SACVayneParam = true
			self:addParam("nil","ShadowVayne found. Set the Keysettings there!", SCRIPT_PARAM_INFO, "")
		end
		HideParam = true
	end

	if self.name == "SV_MAIN_keysetting" and self._param[varIndex].text:find("Hidden") then
		HideParam = true
	end

	if self.name == "SV_SOW" and (self._param[varIndex].var == "Hotkeys" or self._param[varIndex].var:find("Mode")) then HideParam = true end

	if (self.name == "MMA2013" and self._param[varIndex].text:find("OnHold")) then HideParam = true end
	if not HideParam then
		_G.scriptConfig.CustomDrawParam(self, varIndex)
	end
end

-------------------------
----- SubMenu Hooks -----
-------------------------
_G.scriptConfig.CustomDrawSubInstance = _G.scriptConfig._DrawSubInstance
_G.scriptConfig._DrawSubInstance = function(self, index)
	if not self.name:find("sidasacvayne") then
		_G.scriptConfig.CustomDrawSubInstance(self, index)
	end
end