local open = false
local varCallback = nil

RegisterNUICallback("var-callback", function(data, cb)
	SetNuiFocus(false, false)

    varCallback(data.success)

    open = false

    cb("ok")
end)

local function VarHack(callback, blocks, speed)
    local _blocks =  (blocks or blocks < 1 or blocks > 15) and tonumber(blocks) or 5
    local _speed = (speed or speed < 2) and tonumber(speed) or 10

    if not open then
        open = true
        varCallback = callback

        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "var-start",
            blocks = _blocks,
            speed = _speed
        })
    end
end
exports("VarHack", VarHack)