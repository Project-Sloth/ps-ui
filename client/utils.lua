local callback = nil
local isActive = false
local debug = false

-- When the NUI is closed, call the callback function and returns result
RegisterNUICallback('minigame:callback', function(res, cb)
    SetNuiFocus(false, false)

    if callback then
        callback(res)
    end

    DebugPrint("Minigame closed. Result: " .. tostring(res))

    isActive = false

    cb('ok')
end)

-- Sends a NUI message to the UI
---@param action string -- Action to be sent to the NUI
---@param cb fun()|nil -- Callback function to be called when the NUI is closed, or nil if no callback is needed
---@param data table -- Data to be sent to the NUI
---@param nuiFocus boolean -- Whether to set NUI focus or not
function SendNUI(action, cb, data, nuiFocus)
    if not isActive then
        isActive = true
        SetNuiFocus(nuiFocus, nuiFocus)
        SendNUIMessage({
            action = action,
            data = data
        })
        if not cb then
            isActive = false
        end
    end

    if cb then
        callback = cb
    end
end


-- Debug function to print to the console
function DebugPrint(...)
	if not debug then return end
	local args <const> = { ... }

	local appendStr = ''
	for _, v in ipairs(args) do
		appendStr = appendStr .. ' ' .. tostring(v)
	end
	local msgTemplate = '^3[%s]^0%s'
	local finalMsg = msgTemplate:format("ps-ui", appendStr)
	print(finalMsg)
end