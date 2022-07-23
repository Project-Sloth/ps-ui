local open = false
local scramblerCallback = nil

RegisterNUICallback("scrambler-callback", function(data, cb)
	SetNuiFocus(false, false)

    scramblerCallback(data.success)

    open = false

    cb("ok")
end)

local function Scrambler(callback, type, time, mirrored)
    local _type = type and type or "alphabet"
    local _time = time and tonumber(time) or 10
    local _mirrored = mirrored and tonumber(mirrored) or 0

    if not open then
        scramblerCallback = callback
        open = true

        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "scrambler-start",
            type = _type,
            time = _time,
            mirrored = _mirrored
        })
    end
end
exports("Scrambler", Scrambler)