local function CreateMenu(MenuData)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "menu-open",
        data = MenuData
    })
end
exports("CreateMenu", CreateMenu)

RegisterNetEvent("ps-ui:CreateMenu", function(MenuData)
    CreateMenu(MenuData)
end)

local function CloseMenu()
    SetNuiFocus(false, false)
end
exports("CloseMenu", CloseMenu)

RegisterNetEvent("ps-ui:CloseMenu", function()
    CloseMenu()
end)

RegisterNUICallback("menuClose", function(data, cb)
    CloseMenu()

    cb("ok")
end)

RegisterNUICallback("MenuSelect", function(data, cb)
    if data.data.event then
        if data.data.server then
            TriggerServerEvent(data.data.event, table.unpack(data.data.args))
        else
            TriggerEvent(data.data.event, table.unpack(data.data.args))
        end
    end

    cb("ok")
end)