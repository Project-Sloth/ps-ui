# Script Archived & Merged into ps_lib

This script has been **archived** and its entire functionality has been **merged into the [`ps_lib` library**.](https://github.com/Project-Sloth/ps_lib)

Going forward, all updates, patches, and new features will be maintained in the [`ps_lib` repository.](https://github.com/Project-Sloth/ps_lib)

# ps-ui

For all support questions, ask in our [Discord](https://www.discord.gg/projectsloth) support chat. 
Do not create issues on GitHub if you need help. Issues are for bug reporting and new features only.

# Installation
* Download ZIP
* Drag and drop resource into your server files
* Start resource through server.cfg
* Restart your server.

# Usage

* Check exports below.
* Each interface lua has all the details you need.

# Minigames

# Number Maze

Start a Number Maze game with a callback for success or failure.

```lua 
exports['ps-ui']:Maze(function(success)
    if success then
        print("success")
    else
        print("fail")
    end
end, timeLimit)  -- Hack Time Limit in seconds
```
<img src="https://github.com/user-attachments/assets/c75772bf-a4c9-4b0e-9678-a916bcdb5f3a" alt="Number Maze" width="300"/>

# Notify

Display a notification with text, type, and duration.

```lua
exports['ps-ui']:Notify('Your message', 'notification-type', duration)
```
<img src="https://github.com/user-attachments/assets/e8bfeb42-0459-4630-88db-938a83f14db9" alt="Number Maze" width="300"/>

# Circle

Start a Circle game with a callback for success or failure.

```lua
exports['ps-ui']:Circle(function(success)
    if success then
        print("success")
    else
        print("fail")
    end
end, numCircles, time)  -- Number of Circles, Time in milliseconds
```

<img src="https://github.com/user-attachments/assets/a22280ce-d0d8-4b52-b24e-84e27dfac65e" alt="Number Maze" width="300"/>

# Scrambler

Start a Scrambler game with a callback for success or failure.

```lua
exports['ps-ui']:Scrambler(function(success)
    if success then
        print("success")
    else
        print("fail")
    end
end, type, time, mirrored)  -- Type options: alphabet, numeric, alphanumeric, greek, braille, runes; Time in seconds; Mirrored options: 0, 1, 2
```
<img src="https://github.com/user-attachments/assets/b667785f-3901-46bd-883b-6de8473175c7" alt="Scrambler" width="300"/>

# Var

Start a VAR Hack game with a callback for success or failure.

```lua
exports['ps-ui']:VarHack(function(success)
    if success then
        print("success")
    else
        print("fail")
    end
end, numBlocks, time)  -- Number of Blocks, Time in seconds
```
<img src="https://github.com/user-attachments/assets/5f914e19-28cf-44f0-a675-24551c564259" alt="Var" width="300"/>

# Thermite

Start a Thermite game with a callback for success or failure.

```lua
exports['ps-ui']:Thermite(function(success)
    if success then
        print("success")
    else
        print("fail")
    end
end, time, gridSize, incorrectBlocks)  -- Time in seconds, Grid Size (5-10), Incorrect Blocks
```
<img src="https://github.com/user-attachments/assets/57ab24fc-fd64-4286-9f0e-b7b4685bd45b" alt="Thermite" width="300"/>

# Context Menu

Create a menu with submenus and events.

```lua
exports['ps-ui']:CreateMenu({
    {
        id = "examplemenu", -- has to be unique
        header = "Menu Header",
        text = "Menu Text",
        icon = "icon-class",
        color = "color",
        event = "event-name",
        args = {arg1, arg2},
        server = false,
        subMenu = {
            {
                id = "examplesubmenu", -- has to be unique
                header = 'Submenu Header',
                icon = 'icon-class',
                color = 'color',
                event = "event-name",
                args = {arg1, arg2},
            },
        },
    },
}) 
```

Hide the currently displayed menu

```lua
exports['ps-ui']:HideMenu()
```

<img src="https://github.com/user-attachments/assets/a0c09553-599b-4a1a-bdf2-cc5216c2f06b" alt="Context Menu" width="300"/>

# Status

### Toggle the display of status with information

```lua
exports['ps-ui']:StatusShow("Title", "Description", "icon", 
{
    {key = "Key1", value = "Value1"}, 
    {key = "Key2", value = "Value2"}, 
    {key = "Key3", value = "Value3"}
})
```
<img src="https://github.com/user-attachments/assets/12cd55f8-33e9-4f5f-975d-66a4881ce7fd" alt="Status" width="300"/>

# Display Text

Display text with a specified color

```lua
exports['ps-ui']:DisplayText("Your text", "color")
```

Hide the currently displayed text

```lua
exports['ps-ui']:HideText()
```

<img src="https://github.com/user-attachments/assets/64690b39-3d86-4056-96ec-0e325b545575" alt="Show Text" width="300"/>

# Input

Display an input form and print the input values.

```lua
local input = exports['ps-ui']:Input({
    {
        id = '1',
        label = 'Label',
        type = "input-type",
        icon = "icon-class"
    },
    -- Add more inputs as needed
})
for k, v in pairs(input) do 
    print(k, v.id, v.value)
end
```
<img src="https://github.com/user-attachments/assets/c0dce6ca-c025-4c19-99b2-7ad137e61273" alt="Input" width="300"/>

# Show Image

Displays an image from a URL.

```lua
exports['ps-ui']:ShowImage("imageURL")
```
<img src="https://github.com/user-attachments/assets/646d2f48-3e36-414c-8cd4-3323832c30f0" alt="Show Image" width="300"/>

# Credits
* [complexza](https://github.com/complexza)
* [MonkeyWhisper](https://github.com/MonkeyWhisper)
* [Snipe](https://github.com/pushkart2)
* [Skeleton Networks](https://github.com/skeletonnetworks)
* Project Sloth Team
