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

function OnLoad()
    SxUpdate(1,
        "raw.githubusercontent.com",
        "/Superx321/BoL/master/ShadowVayne.Version",
        "/Superx321/BoL/master/ShadowVayne.lua",
        SCRIPT_PATH.."ShadowVayne.lua",
        function(NewVersion) if NewVersion > 1 then print("<font color=\"#F0Ff8d\"><b>ShadowVayne: </b></font> <font color=\"#FF0F0F\">Updated to "..NewVersion..". Please Reload with 2x F9</b></font>") else print("<font color=\"#F0Ff8d\"><b>ShadowVayne: </b></font> <font color=\"#FF0F0F\">You have the Latest Version</b></font>") end end)
end