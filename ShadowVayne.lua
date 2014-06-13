--[[

	Shadow Vayne Script by Superx321

	For Functions & Changelog, check the Thread on the BoL Forums:
	http://botoflegends.com/forum/topic/18939-shadow-vayne-the-mighty-hunter/
	]]
if myHero.charName ~= "Vayne" then return end

------------------------
------ AutoUpdate ------
------------------------
function _AutoUpdate(Force)
	_AutoUpdates = {
		{["Name"] = "VPrediction", 		["Version"] = "/Hellsing/BoL/master/version/VPrediction.version", 		["Script"] = "/Hellsing/BoL/master/common/VPrediction.lua"},
		{["Name"] = "SOW", 				["Version"] = "/Hellsing/BoL/master/version/SOW.version", 				["Script"] = "/Hellsing/BoL/master/common/SOW.lua"},
		{["Name"] = "SourceLib", 		["Version"] = "/TheRealSource/public/master/common/SourceLib.version", 	["Script"] = "/TheRealSource/public/master/common/SourceLib.lua"},
		{["Name"] = "Selector", 		["Version"] = "/pqmailer/BoL_Scripts/master/Paid/Selector.revision", 	["Script"] = "/pqmailer/BoL_Scripts/master/Paid/Selector.lua"},
		{["Name"] = "CustomPermaShow", 	["Version"] = "/Superx321/BoL/master/common/CustomPermaShow.Version", 	["Script"] = "/Superx321/BoL/master/common/CustomPermaShow.lua"},
		{["Name"] = "ShadowVayneLib", 	["Version"] = "/Superx321/BoL/master/common/ShadowVayneLib.Version", 	["Script"] = "/Superx321/BoL/master/common/ShadowVayneLib.lua"},
	}
	socket = require("socket")
	TcpSocket = socket.connect("reddi-ts.de", 80)
	SendString = "GET /BoL/Scripts.php?rand="..tonumber(math.random(10000)).."&scripts="..#_AutoUpdates
	for i=1,#_AutoUpdates do
		if _AutoUpdates[i]["Version"] ~= nil then
			SendString = SendString .. "&"..i.."_version=".._AutoUpdates[i]["Version"]
		else
			SendString = SendString .. "&"..i.."_version=nil"
		end
		SendString = SendString .. "&"..i.."_script=".._AutoUpdates[i]["Script"]
	end

	TcpSocket:send(SendString .. " HTTP/1.0\r\n\r\n")
	TcpReceive = TcpSocket:receive('*a')

	for i=1,#_AutoUpdates do
		_AutoUpdates[i]["ServerVersion"] = tonumber(string.sub(TcpReceive, string.find(TcpReceive, "<"..i.."_version>")+11, string.find(TcpReceive, "</"..i.."_version>")-1))
		_AutoUpdates[i]["ServerScript"] = string.sub(TcpReceive, string.find(TcpReceive, "<"..i.."_script>")+10, string.find(TcpReceive, "</"..i.."_script>")-1)
		_AutoUpdates[i]["LocalVersion"] = tonumber(_GetLocalVersion(_AutoUpdates[i]["Name"])) or 0
		if _AutoUpdates[i]["ServerVersion"] > _AutoUpdates[i]["LocalVersion"] or Force == true then
			if Force ~= true then _PrintUpdateMsg("Updated Version ".._AutoUpdates[i]["LocalVersion"].." => ".._AutoUpdates[i]["ServerVersion"].."", _AutoUpdates[i]["Name"]) end
			LibNameFile = io.open(LIB_PATH.._AutoUpdates[i]["Name"]..".lua", "w+")
			LibNameString = _AutoUpdates[i]["ServerScript"]
			LibNameFile:write(LibNameString)
			LibNameFile:close()
		end
		_RequireWithoutUpdate(_AutoUpdates[i]["Name"])
	end
end

function _GetLocalVersion(LibName)
	if FileExist(LIB_PATH..LibName..".lua") then
		LibNameFile = io.open(LIB_PATH..LibName..".lua", "r")
		LibNameString = LibNameFile:read("*a")
		LibNameFile:close()
		LibNameVersionPos = LibNameString:lower():find("version")
		if type(LibNameVersionPos) == "number" then
			for i = 1,20 do
				GetCurrentChar = string.sub(LibNameString, LibNameVersionPos+i, LibNameVersionPos+i)
				if type(tonumber(GetCurrentChar)) == "number" then
					VersionNumberStartPos = LibNameVersionPos+i
					break
				end
			end

			for i = 0,20 do
				GetCurrentChar = string.sub(LibNameString, VersionNumberStartPos+i, VersionNumberStartPos+i)
				if type(tonumber(GetCurrentChar)) ~= "number" and GetCurrentChar ~= "." then
					VersionNumberEndPos = VersionNumberStartPos+i-1
					break
				end
			end
			FileVersion = string.sub(LibNameString, VersionNumberStartPos, VersionNumberEndPos)
			if tonumber(FileVersion) == nil then FileVersion = 0 end
			if FileVersion == "2.431" then
				return 5
			else
				return FileVersion
			end
		else
			return 0
		end
	else
		return 0
	end
end

function _PrintUpdateMsg(Msg, LibName)
	if LibName == nil or LibName == "ShadowVayneLib" then
		print("<font color=\"#F0Ff8d\"><b>ShadowVayne:</b></font> <font color=\"#FF0F0F\">"..Msg.."</font>")
	else
		print("<font color=\"#F0Ff8d\"><b>ShadowVayne("..LibName.."):</b></font> <font color=\"#FF0F0F\">"..Msg.."</font>")
	end
end

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
	DelayAction(function()
		if type(_OnTick) ~= "function" then
			_PrintScriptMsg("LoadingError detected. Restarting, please wait...")
			for i=1,#_AutoUpdates do
				package.loaded[_AutoUpdates[i]["Name"]] = nil
			end
			_AutoUpdate(true)
		end
	end, 0)

	_AutoUpdate()
end

function OnTick() if type(_OnTick) == "function" then _OnTick() end end
function OnProcessSpell() if type(_OnProcessSpell) == "function" then _OnProcessSpell() end  end
function OnCreateObj() if type(_OnCreateObj) == "function" then _OnCreateObj() end  end
function OnWndMsg() if type(_OnWndMsg) == "function" then _OnWndMsg() end  end
function OnDraw() if type(_OnDraw) == "function" then _OnDraw() end  end
function OnCreateObj() if type(_OnCreateObj) == "function" then _OnCreateObj() end  end

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