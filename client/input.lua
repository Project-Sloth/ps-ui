local p = nil
local active = false

--- Displays an input form and waits for user input.
--- @param InputData table: Data to be used for the input form, typically includes fields like labels, types, and icons.
--- @return table: User input data as returned from the form.
local function input(InputData)
    DebugPrint("Input called with " .. json.encode(InputData))
    p = promise.new()
    while active do Wait(0) end
    active = true
    SendNUIMessage({
        action = "ShowInput",
        data = InputData
    })
    SetNuiFocus(true, true)

    local inputs = Citizen.Await(p)
    return inputs
end

--- Callback for handling user input.
--- @param data table: Data received from the NUI input form, includes user input values.
--- @param cb function: Callback function to signal completion of the NUI callback (must be called to complete the NUI callback).
RegisterNUICallback('input-callback', function(data, cb)
    SetNuiFocus(false, false)
    p:resolve(data)
    p = nil
    active = false
    cb('ok')
end)

--- Callback for closing the input form.
--- @param data any: Data sent from the NUI (not used in this function).
--- @param cb function: Callback function to signal completion of the NUI callback (must be called to complete the NUI callback).
RegisterNUICallback('input-close', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

exports("Input", input)