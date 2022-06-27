local currentText = ""
local currentColor = "primary"

exports("DisplayText", function(text, color)
    local _text = text and text or ""
    local _color = color and color or "primary"

    currentText = _text
    currentColor = _color

    SendNUIMessage({
        action = "display",
        text = currentText,
        color = currentColor
    })
end)

exports("HideText", function()
    currentText = ""
    currentColor = "primary"

    SendNUIMessage({
        action = "hide"
    })
end)

exports("UpdateText", function(text)
    if text == nil then
        currentText = ""
    else
        currentText = text
    end
    
    SendNUIMessage({
        action = "update",
        text = currentText
    })
end)