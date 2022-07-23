local p = nil

local function Circle(cb, circles, seconds)
    local _circles = (circles or circles < 1) and tonumber(circles) or 1
    local _seconds = (seconds or seconds < 1) and tonumber(seconds) or 10

    p = promise.new()

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "circle-start",
        circles = _circles,
		time = _seconds
    })

    local result = Citizen.Await(p)

    cb(result)
end
exports("Circle", Circle)

RegisterNUICallback("circle-fail", function(data, cb)
    p:resolve(false)
    p = nil

    SetNuiFocus(false, false)

    cb("ok")
end)

RegisterNUICallback("circle-success", function(data, cb)
    p:resolve(true)
    p = nil

    SetNuiFocus(false, false)

    cb("ok")
end)