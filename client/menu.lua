local storedData = {}

---Creates a menu and registers its events.
---@param menuData table: Data for the menu, including items and submenus.
local function createMenu(menuData)
    for _, item in ipairs(menuData) do
        storedData[item.id] = item
        if item.subMenu then
            for _, subItem in ipairs(item.subMenu) do
                storedData[subItem.id] = subItem
            end
        end
    end

    SendNUI("ShowMenu", nil, {
        menuData = menuData
    }, true)
end

--- Event handler for creating a menu from a network event.
--- @param menuData table: Data for the menu, including items and submenus.
RegisterNetEvent("ps-ui:CreateMenu", function(menuData)
    if not menuData then
        return
    end

    createMenu(menuData)
end)

--- Closes the current menu.
local function hideMenu()
    SendNUI("HideMenu", nil, {}, false)
    storedData = {}
end

--- NUI callback for closing the menu.
--- @param data any: Data from the NUI (not used in this function).
--- @param cb function: Callback function to signal completion of the NUI callback.
RegisterNUICallback('menuClose', function(data, cb)
    SetNuiFocus(false, false)
    storedData = {}
    cb('ok')
end)

--- NUI callback for menu item selection.
--- @param data table: Data from the NUI, including event details.
--- @param cb function: Callback function to signal completion of the NUI callback. The callback should be called with a string status, e.g., 'ok' or an error message.
RegisterNUICallback('MenuSelect', function(data, cb)
    local menuData = storedData[data.data.id]
    if menuData then
        if menuData.server then
            TriggerServerEvent(menuData.event, table.unpack(menuData.args))
        else
            TriggerEvent(menuData.event, table.unpack(menuData.args))
        end

        SetNuiFocus(false, false)
        storedData = {}
    end
    cb('ok')
end)

exports("CreateMenu", createMenu)
exports("HideMenu", hideMenu)