-- Starts the VarHack game with the specified parameters.
--- @param callback function: Callback function that will receive the result of the game (true for success, false for failure).
--- @param blocks number|nil: Number of blocks in the game. Default is 5 if nil or out of range (1-15).
--- @param speed number|nil: Speed of the game in seconds. Default is 20 if nil or less than 2.
local function varHack(callback, blocks, speed)
    if speed == nil or (speed < 2) then speed = 20 end  -- Default speed if not provided or less than 2
    if blocks == nil or (blocks < 1 or blocks > 15) then blocks = 5 end  -- Default blocks if not provided or out of range (1-15
    DebugPrint("VarHack called with " .. blocks .. " blocks and " .. speed .. " speed")
    SendNUI("GameLauncher", callback, {
        game = "NumberPuzzle",  -- Name of the game
        gameName = "NumberPuzzle",  -- Display name of the game
        gameDescription = "Test your skills with VarHack! Solve the number puzzle by matching blocks within the time limit. Adjust the number of blocks and game speed for a personalized challenge!",  -- Description of the game
        gameTime = 15,  -- Duration of the game in seconds
        triggerEvent = 'var-callback',  -- Event to trigger on game completion
        maxAnswersIncorrect = 2,  -- Maximum number of incorrect answers allowed
        amountOfAnswers = blocks,  -- Number of blocks in the game
        timeForNumberDisplay = 3,  -- Time to display numbers (seconds)
    }, true)
end
exports("VarHack", varHack)
