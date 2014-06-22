--[[

	Shadow Vayne Script by Superx321

	For Functions & Changelog, check the Thread on the BoL Forums:
	http://botoflegends.com/forum/topic/18939-shadow-vayne-the-mighty-hunter/
	]]
if myHero.charName ~= "Vayne" then return end

_OwnEnv = GetCurrentEnv().FILE_NAME:gsub(".lua", "")

ShadowVersion = 0.8

------------------------
------ MainScript ------
------------------------
function OnLoad()
	TCPU = TCPUpdater()
	TCPU:AddScript("VPrediction","Lib","raw.githubusercontent.com","/Hellsing/BoL/master/common/VPrediction.lua","/Hellsing/BoL/master/version/VPrediction.version","local version", "Free")
	TCPU:AddScript("SourceLib","Lib","raw.githubusercontent.com","/TheRealSource/public/master/common/SourceLib.lua","/TheRealSource/public/master/common/SourceLib.version","local version")
	TCPU:AddScript("Selector","Lib","raw.githubusercontent.com","/pqmailer/BoL_Scripts/master/Paid/Selector.lua","/pqmailer/BoL_Scripts/master/Paid/Selector.revision","@version", "VIP")
	TCPU:AddScript("CustomPermaShow","Lib","raw.githubusercontent.com","/Superx321/BoL/master/common/CustomPermaShow.lua","/Superx321/BoL/master/common/CustomPermaShow.Version","version =", "Free")
	TCPU:AddScript("ShadowVayneLib","Lib","raw.githubusercontent.com","/Superx321/BoL/master/common/ShadowVayneLib.lua","/Superx321/BoL/master/common/ShadowVayneLib.Version","version =", "Free")
	TCPU:AddScript("Prodiction","Lib","bitbucket.org","/Klokje/public-klokjes-bol-scripts/raw/1467bf108b116274f8763693b00b7d977faf7735/Test/Prodiction/Prodiction.lua",nil,"--Prodiction", "VIP", 1.1)
	TCPU:AddScript(_OwnEnv,"Script","raw.githubusercontent.com","/Superx321/BoL/master/ShadowVayne.lua","/Superx321/BoL/master/ShadowVayne.Version","ShadowVersion =")
end

function OnTick()
	if not _G.ShadowVayneLoaded then
		local NeedWait = false
		for i, UpdateStatus in pairs(_G.TCPUpdates) do
			if UpdateStatus == false then
				NeedWait = true
				break
			end
		end
		if NeedWait == false then
			_G.ShadowVayneLoaded = true
			ShadowVayne()
		end
	end
end

------------------------
------ TCPUpdater ------
------------------------
class "TCPUpdater"
function TCPUpdater:__init()
	_G.TCPUpdates = {}
	_G.TCPUpdaterLoaded = true
	self.AutoUpdates = {}
	self.LuaSocket = require("socket")
	AddTickCallback(function() self:GetOnlineVersion() end)
	AddTickCallback(function() self:GetScriptPath() end)
	AddTickCallback(function() self:GetLocalVersion() end)
	AddTickCallback(function() self:DownloadUpdate() end)
end

function TCPUpdater:GetScriptPath()
	for i=1,#self.AutoUpdates do
		if not self.AutoUpdates[i]["ScriptPath"] then
			if self.AutoUpdates[i]["Type"] == "Lib" then
				self.AutoUpdates[i]["ScriptPath"] = LIB_PATH..self.AutoUpdates[i]["Name"]..".lua"
			else
				self.AutoUpdates[i]["ScriptPath"] = SCRIPT_PATH..self.AutoUpdates[i]["Name"]..".lua"
			end
		end
	end
end

function TCPUpdater:GetOnlineVersion()
	for i=1,#self.AutoUpdates do
		if not self.AutoUpdates[i]["ServerVersion"] and not self.AutoUpdates[i]["VersionSocket"] then
			self.AutoUpdates[i]["VersionSocket"] = self.LuaSocket.connect("sx-bol.eu", 80)
			self.AutoUpdates[i]["VersionSocket"]:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.AutoUpdates[i]["Host"]..self.AutoUpdates[i]["VersionLink"].."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
		end

		if not self.AutoUpdates[i]["ServerVersion"] and self.AutoUpdates[i]["VersionSocket"] then
			self.AutoUpdates[i]["VersionSocket"]:settimeout(0)
			self.AutoUpdates[i]["VersionReceive"], self.AutoUpdates[i]["VersionStatus"] = self.AutoUpdates[i]["VersionSocket"]:receive('*a')
		end

		if self.AutoUpdates[i]["VersionStatus"] ~= 'timeout' and self.AutoUpdates[i]["VersionReceive"] == nil then
			self.AutoUpdates[i]["VersionSocket"] = nil
		end

		if not self.AutoUpdates[i]["ServerVersion"] and self.AutoUpdates[i]["VersionSocket"] and self.AutoUpdates[i]["VersionStatus"] ~= 'timeout' and self.AutoUpdates[i]["VersionReceive"] ~= nil then
			self.AutoUpdates[i]["ServerVersion"] = tonumber(string.sub(self.AutoUpdates[i]["VersionReceive"], string.find(self.AutoUpdates[i]["VersionReceive"], "<bols".."cript>")+11, string.find(self.AutoUpdates[i]["VersionReceive"], "</bols".."cript>")-1))
		end
	end
end

function TCPUpdater:GetLocalVersion()
	for i=1,#self.AutoUpdates do
		if not self.AutoUpdates[i]["LocalVersion"] and self.AutoUpdates[i]["ScriptPath"] then
			if FileExist(self.AutoUpdates[i]["ScriptPath"]) then
				self.FileOpen = io.open(self.AutoUpdates[i]["ScriptPath"], "r")
				self.FileString = self.FileOpen:read("*a")
				self.FileOpen:close()
				VersionPos = self.FileString:find(self.AutoUpdates[i]["VersionSearchString"])
				if VersionPos ~= nil then
					self.VersionString = string.sub(self.FileString, VersionPos + string.len(self.AutoUpdates[i]["VersionSearchString"]) + 1, VersionPos + string.len(self.AutoUpdates[i]["VersionSearchString"]) + 11)
					self.AutoUpdates[i]["LocalVersion"] = tonumber(string.match(self.VersionString, "%d *.*%d"))
				end
				if self.AutoUpdates[i]["LocalVersion"] == 2.431 then self.AutoUpdates[i]["LocalVersion"] = 99 end -- VPred 2.431
				if self.AutoUpdates[i]["LocalVersion"] == nil then self.AutoUpdates[i]["LocalVersion"] = 0 end
			else
				self.AutoUpdates[i]["LocalVersion"] = 0
			end
		end
	end
end

function TCPUpdater:DownloadUpdate()
	for i=1,#self.AutoUpdates do
		if self.AutoUpdates[i]["LocalVersion"] and self.AutoUpdates[i]["ServerVersion"] and self.AutoUpdates[i]["ServerVersion"] > self.AutoUpdates[i]["LocalVersion"] and not self.AutoUpdates[i]["Updated"] then
			if not self.AutoUpdates[i]["ScriptSocket"] then
				self.AutoUpdates[i]["ScriptSocket"] = self.LuaSocket.connect("sx-bol.eu", 80)
				self.AutoUpdates[i]["ScriptSocket"]:send("GET /BoL/TCPUpdater/GetScript.php?script="..self.AutoUpdates[i]["Host"]..self.AutoUpdates[i]["ScriptLink"].."&rand="..tostring(math.random(1000)).." HTTP/1.0\r\n\r\n")
			end

			if self.AutoUpdates[i]["ScriptSocket"] then
				self.AutoUpdates[i]["ScriptReceive"] = self.AutoUpdates[i]["ScriptSocket"]:receive('*a')
			end

			if self.AutoUpdates[i]["ScriptSocket"] and self.AutoUpdates[i]["ScriptReceive"] ~= nil and not self.AutoUpdates[i]["Updated"] then
				self.FileOpen = io.open(self.AutoUpdates[i]["ScriptPath"], "w+")
				self.FileOpen:write(string.sub(self.AutoUpdates[i]["ScriptReceive"], string.find(self.AutoUpdates[i]["ScriptReceive"], "<bols".."cript>")+11, string.find(self.AutoUpdates[i]["ScriptReceive"], "</bols".."cript>")-1))
				self.FileOpen:close()
				if self.AutoUpdates[i]["ScriptRequire"] ~= nil and self.AutoUpdates[i]["Type"] == "Lib" then
					if self.AutoUpdates[i]["ScriptRequire"] == "VIP" then
						if VIP_USER then
							loadfile(LIB_PATH ..self.AutoUpdates[i]["Name"]..".lua")()
						end
					else
						loadfile(LIB_PATH ..self.AutoUpdates[i]["Name"]..".lua")()
					end
				end
				self.AutoUpdates[i]["Updated"] = true
				_G.TCPUpdates[self.AutoUpdates[i]["Name"]] = true
			end
		end

		if self.AutoUpdates[i]["LocalVersion"] and self.AutoUpdates[i]["ServerVersion"] and self.AutoUpdates[i]["ServerVersion"] <= self.AutoUpdates[i]["LocalVersion"] and not self.AutoUpdates[i]["Updated"] then
			if self.AutoUpdates[i]["ScriptRequire"] ~= nil and self.AutoUpdates[i]["Type"] == "Lib" then
				if self.AutoUpdates[i]["ScriptRequire"] == "VIP" then
					if VIP_USER then
						loadfile(LIB_PATH..self.AutoUpdates[i]["Name"]..".lua")()
					end
				else
					loadfile(LIB_PATH..self.AutoUpdates[i]["Name"]..".lua")()
				end
			end
			self.AutoUpdates[i]["Updated"] = true
			_G.TCPUpdates[self.AutoUpdates[i]["Name"]] = true
		end
	end
end

function TCPUpdater:AddScript(Name, Type, Host, ScriptLink, VersionLink, VersionSearchString, ScriptRequire, ServerVersion)
	table.insert(self.AutoUpdates, {["Name"] = Name, ["Type"] = Type, ["Host"] = Host, ["ScriptLink"] = ScriptLink, ["VersionLink"] = VersionLink, ["VersionSearchString"] = VersionSearchString, ["ScriptRequire"] = ScriptRequire, ["ServerVersion"] = ServerVersion})
	_G.TCPUpdates[Name] = false
end

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