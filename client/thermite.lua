local open = false
local p = nil

RegisterNUICallback("thermite-callback", function(data, cb)
	SetNuiFocus(false, false)

    p:resolve(data.success)
    p = nil
    open = false

    cb("ok")
end)

local function Thermite(cb, time, gridsize, wrong)
    if not open then
        local _time = time and tonumber(time) or 10
        local _gridsize = gridsize and tonumber(gridsize) or 6
        local _wrong = wrong and tonumber(wrong) or 3

        p = promise.new()
        open = true

        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "thermite-start",
            time = _time,
            gridsize = _gridsize,
            wrong = _wrong
        })

        local result = Citizen.Await(p)

        cb(result)
    end
end
exports("Thermite", Thermite)