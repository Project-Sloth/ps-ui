local p = nil
local Active = false

local function Input(InputData)
    p = promise.new()

    while Active do
        Citizen.Wait(0)
    end

    Active = true

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "input",
        data = InputData
    })

    local inputs = Citizen.Await(p)

    return inputs
end
exports("Input", Input)

RegisterNUICallback("input-callback", function(data, cb)
	SetNuiFocus(false, false)

    p:resolve(data.input)
    p = nil
    Active = false

    cb("ok")
end)

RegisterNUICallback("input-close", function(data, cb)
    SetNuiFocus(false, false)
    
    cb("ok")
end)