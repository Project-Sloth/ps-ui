local p = nil

--- Starts a circle game and handles the result.
--- @param cb function: Callback function that will receive the result of the game (true for success, false for failure)
--- @param circles number|nil: Number of circles in the game (default is 1 if nil or less than 1)
--- @param seconds number|nil: Time duration of the game in seconds (default is 10 if nil or less than 1)
local function circle(cb, circles, seconds)
    if circles == nil or circles < 1 then circles = 1 end
    if seconds == nil or seconds < 1 then seconds = 10 end
    DebugPrint("Circle called with " .. circles .. " circles and " .. seconds .. " seconds")
    p = promise.new()
    SendNUIMessage({
        action = 'CircleGame',
        data = {
            circles = circles,
            time = seconds,
        }
    })
    SetNuiFocus(true, true)
    local result = Citizen.Await(p)
    cb(result)
end

--- Callback for when the game finishes.
--- @param data any: Data sent from the NUI (not used in this function)
--- @param cb function: Callback function to signal completion of the NUI callback (must be called to complete the NUI callback)
RegisterNuiCallback('circle-result', function(data, cb)
    local result = data.endResult
    p:resolve(result)
    p = nil
    SetNuiFocus(false, false)
    cb('ok')
end)

exports("Circle", circle)