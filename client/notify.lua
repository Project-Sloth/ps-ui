--- Sends a notification to the user.
--- @param text string: The text content of the notification.
--- @param type string|nil: The type of notification (e.g., 'primary', 'success', 'error'). Defaults to 'primary' if nil.
--- @param length number|nil: Duration of the notification in milliseconds. Defaults to 5000 milliseconds (5 seconds) if nil.
local function notify(text, type, length)
    type = type or 'primary'  -- Default to 'primary' if type is nil
    length = length or 5000  -- Default to 5000 milliseconds if length is nil
    DebugPrint("Notify called with " .. text .. " text and " .. type .. " type")
    SendNUI("ShowNotification", nil, {
        text = text,       -- Notification text
        type = type,       -- Notification type
        length = length    -- Duration of the notification
    }, false)
end

--- Network event handler for sending a notification.
RegisterNetEvent('ps-ui:Notify', notify)

exports('Notify', notify)