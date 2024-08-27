--- Sets the display state for the NUI with an optional image.
--- @param bool boolean: Determines whether to show or hide the NUI. `true` to show, `false` to hide.
--- @param img string|nil: URL of the image to display. Ignored if `bool` is `false`.
local function setDisplay(bool, img)
    DebugPrint("ShowImage called with " .. tostring(bool) .. " bool and " .. img .. " img")
    SendNUI("ShowImage", nil, {
        url = bool and img or nil,
        show = bool,
    }, true)
end

--- Shows an image by setting the display state to `true`.
--- @param img string: URL of the image to display.
local function showImage(img)
    setDisplay(true, img)
end

--- NUI callback for handling the image display state change.
--- @param data table: Data received from the NUI callback.
--- @field data.show boolean: Indicates whether the image was shown or hidden.
--- @param cb function: Callback function to signal completion of the NUI callback.
RegisterNUICallback("showItemImage-callback", function(data, cb)
    setDisplay(false)
    SetNuiFocus(false, false)
    cb('ok')
end)

exports("ShowImage", showImage)