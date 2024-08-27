--- Shows the status bar with the given details.
--- @param title string: Title to display on the status bar.
--- @param description string: Description to display on the status bar.
--- @param icon string: Icon to display on the status bar.
--- @param values table: List of items to display in the status bar. Each item is typically a table with `key` and `value` fields.
local function statusShow(title, description, icon, values)
    DebugPrint("StatusBar called with " .. title .. " title, " .. description .. " description, " .. icon .. " icon, and " .. json.encode(values) .. " values")
    SendNUI("ShowStatusBar", nil, {
        title = title,
        description = description,
        icon = icon,
        items = values,
    }, false)
end
--- Hides the status bar.
local function statusHide()
    SendNUI("HideStatusBar", nil, {}, false)
end

--- Updates the status bar with new information.
--- @param title string: Title to display on the status bar.
--- @param values table: List of items to display in the status bar. Each item is typically a table with `key` and `value` fields.
local function statusUpdate(title, values)
    SendNUI("updateStatusBar", nil, {
        update = true,
        title = title,
        values = values,
    }, false)
end

exports("StatusShow", statusShow)
exports("StatusHide", statusHide)
exports("StatusUpdate", statusUpdate)