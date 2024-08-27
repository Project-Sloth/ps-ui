--- Starts the scrambler game.
--- @param callback function: Callback function to handle the result of the game (true for success, false for failure).
--- @param type string|nil: Type of the game (e.g., 'alphabet', 'numeric'). Defaults to "alphabet" if nil.
--- @param time number|nil: Time duration of the game in seconds. Defaults to 10 seconds if nil.
--- @param mirrored number|nil: Option to include mirrored text (0: Normal, 1: Normal + Mirrored, 2: Mirrored only). Defaults to 0 if nil.
local function scrambler(callback, type, time, mirrored)
    if type == nil then type = "alphabet" end  -- Default to "alphabet" if type is nil
    if time == nil then time = 10 end  -- Default to 10 seconds if time is nil
    if mirrored == nil then mirrored = 0 end  -- Default to 0 if mirrored is nil
    DebugPrint("Scrambler called with " .. type .. " type and " .. time .. " time")
    SendNUI("GameLauncher", callback, {  -- Use SendNUI with nil callback
        game = "Scramber",  -- Internal name of the game
        gameName = "Scrambler",  -- Display name of the game
        gameDescription = "Challenge your brain with the Scrambler game! Depending on your choice, you'll either unscramble letters or numbers, with an option for mirrored text. Can you solve the puzzles before time runs out?",  -- Description of the game
        amountOfAnswers = 4,  -- Number of answers to provide in the game
        gameTime = time,  -- Time duration of the game
        sets = type,  -- Type of the game
        changeBoardAfter = 1,  -- Specifies if the board should change after a certain condition
    }, true)
end
exports("Scrambler", scrambler)