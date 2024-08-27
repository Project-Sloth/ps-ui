local storedText = ""
local storedColor = "primary"

--- Displays text with a specified color and icon.
--- @param text string|nil: The text to display (defaults to an empty string if nil)
--- @param color string|nil: The color for the text (defaults to "primary" if nil)
--- @param icon string|nil: The icon to display (defaults to 'fa-solid fa-circle-info' if nil)
exports("DisplayText", function(text, color, icon)
    if text == nil then storedText = "" else storedText = text end
    if color == nil then storedColor = "primary" else storedColor = color end
    DebugPrint("DisplayText called with " .. text .. " text and " .. color .. " color")
    SendNUIMessage({
        action = "ShowDrawTextMenu",
        data = {
            title = "No Title",  -- Static title for the text display
            keys = storedText,         -- The text to display
            icon = icon or 'fa-solid fa-circle-info',  -- Icon to display (default is 'fa-solid fa-circle-info')
            color = storedColor,       -- Color of the text
        }
    })
end)

--- Hides the currently displayed text.
exports("HideText", function()
    storedText = ""
    storedColor = "primary"
    SendNUIMessage({
        action = "HideDrawTextMenu",
    })
end)

--- Updates the displayed text.
--- @param text string|nil: The new text to display (defaults to an empty string if nil)
exports("UpdateText", function(text, color, icon)
    if text == nil then storedText = "" else storedText = text end
    if color == nil then storedColor = "primary" else storedColor = color end
    SendNUIMessage({
        action = "ShowDrawTextMenu",
        data = {
            keys = storedText,         -- The updated text to display
            icon = icon or 'fa-solid fa-circle-info',  -- Icon to display (default is 'fa-solid fa-circle-info')
            color = storedColor,       -- Color of the text
        }
    })
end)