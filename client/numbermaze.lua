--- Starts the maze game.
--- @param callback function: Callback function to handle the result of the game (true for success, false for failure).
--- @param speed number|nil: Time duration of the game in seconds. Defaults to 10 seconds if nil.
local function Maze(callback, speed)
    if speed == nil then speed = 10 end  -- Default to 10 seconds if speed is nil
    DebugPrint("Maze called with " .. speed .. " speed")
    SendNUI("GameLauncher", callback, {
        game = "NumberMaze",  -- Name of the game
        gameName = "NumberMaze",  -- Display name of the game
        gameDescription = "Test your skills in the Number Maze! Race against the clock to find the correct sequence and beat the challenge. Can you solve it before time runs out?",  -- Description of the game
        gameTime = speed,  -- Time duration of the game
        triggerEvent = 'maze-callback',  -- Event to trigger on completion
        maxAnswersIncorrect = 2,  -- Maximum number of incorrect answers allowed
    }, true)
end
exports("Maze", Maze)