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
<img src="https://github.com/user-attachments/assets/8798dd02-6737-4526-9da6-aa78b66492e8" alt="Number Maze" width="300"/>

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

<img src="https://github.com/user-attachments/assets/39b85867-65f3-46b0-bb87-36aee70971a6" alt="Number Maze" width="300"/>

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
<img src="https://github.com/user-attachments/assets/f7831e0d-b80b-44ae-abd3-d950332fcb68" alt="Scrambler" width="300"/>

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

<img src="https://github.com/user-attachments/assets/e28b1278-bd36-4421-8994-8830277caa1c" alt="Var" width="300"/>

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
<img src="https://github.com/user-attachments/assets/b3ccef39-27fc-4eb7-84af-f100a499662e" alt="Thermite" width="300"/>

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

<img src="https://github.com/user-attachments/assets/5389ad62-02f8-4b86-a533-e1c2ffc0f9b8" alt="Context Menu" width="300"/>

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

<img src="https://github.com/user-attachments/assets/faee2f3c-a198-46c8-86c5-c0a495ef678b" alt="Status" width="300"/>

# Display Text

Display text with a specified color

```lua
exports['ps-ui']:DisplayText("Your text", "color")
```

Hide the currently displayed text

```lua
exports['ps-ui']:HideText()
```

<img src="https://github.com/user-attachments/assets/741184fb-c5c8-4209-9bb5-2c4a643f792a" alt="Show Text" width="300"/>

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

<img src="https://github.com/user-attachments/assets/93aa24f9-824b-47cf-bc1e-bbf993edca51" alt="Input" width="300"/>

# Show Image

Displays an image from a URL.

```lua
exports['ps-ui']:ShowImage("imageURL")
```
<img src="https://github.com/user-attachments/assets/918f7ba9-6fab-4c47-8936-56cdd4d188e0" alt="Show Image" width="300"/>

# Credits
* [complexza](https://github.com/complexza)
* [MonkeyWhisper](https://github.com/MonkeyWhisper)
* [Snipe](https://github.com/pushkart2)
* [Skeleton Networks](https://github.com/skeletonnetworks)
* Project Sloth Team
