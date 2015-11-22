----------------------------
----- SxOrbWalk Loader -----
----------------------------
class "SxOrbWalkLoader"
function SxOrbWalkLoader:__init(retry)
    self.retry = retry or 1
    self.answer = ''
    if FileExist(LIB_PATH.."SxOrbWalk.lua") then
        local fFunc = loadfile(LIB_PATH.."SxOrbWalk.lua")
        if type(fFunc) == 'function' then
            require('SxOrbWalk')
            SxOrb:LoadToMenu()
        else
            self.forceDownload = true
        end
    end
    if not FileExist(LIB_PATH.."SxOrbWalk.lua") or self.forceDownload then
        print('Downloading SxOrbWalk, please wait'..(retry and ' (try #'..retry..')' or ''))
        self:CreateSocket()
        AddTickCallback(function() self:GetScript() end)
    end
end

function SxOrbWalkLoader:CreateSocket()
    self.socket = require('socket')
    self.tcp = self.socket.tcp()
    self.tcp:settimeout(0, 'b')
    self.tcp:settimeout(999999, 't')
    self.tcp:connect('sx-bol.eu', 80)
end

function SxOrbWalkLoader:GetScript()
    if self.gotBolSite then return end
    self.receive, self.status, self.snipped = self.tcp:receive(1024)
    if self.status and not string.find(self.status,'Socket') then
        self.socketReady = true
    end
    if self.socketReady and not self.reqSent then
        self.tcp:send('GET /BoL/TCPUpdater/GetScript6.php?script='..Base64Encode('raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua')..' HTTP/1.1\r\nHost: sx-bol.eu\r\n\r\n')
        self.reqSent = true
    end
    self.answer = self.answer .. (self.receive or self.snipped)
    if self.answer:sub(-4) == '\r\n\r\n' then
        self.gotBolSite = true
        self.header = self.answer:find('\r\n\r\n')
        self.body = self.answer:sub(self.header+4)
        self.script = {}
        local nextScriptLine = false
        self.body:gsub('(.-)(\r\n)',function(line)
            if self.error then return end
            if not nextScriptLine then
                nextScriptLine = tonumber(line,16)
            else
                if #line == nextScriptLine then
                    self.script[#self.script+1] = line
                    nextScriptLine = false
                else
                    print('Download Error')
                    self.error = true
                end
            end
        end)
        if self.error then SxOrbWalkLoader(self.retry+1) return end
        self.script = table.concat(self.script)
        self.scriptStart = self.script:find('<scr'..'ipt>')
        self.script = Base64Decode(self.script:sub(self.scriptStart+8,-10))
        local f =  io.open(LIB_PATH..'/SxOrbWalk.lua','w+')
        f:write(self.script)
        f:close()
        require('SxOrbWalk')
        SxOrb:LoadToMenu()
    end
end

SxOrbWalkLoader()
