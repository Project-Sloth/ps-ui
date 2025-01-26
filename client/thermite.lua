local correctBlocksBasedOnGrid = {
    [5] = 10,
    [6] = 14,
    [7] = 18,
    [8] = 20,
    [9] = 24,
    [10] = 28,
}

--- Starts the Thermite game with the specified parameters.
--- @param cb function: Callback function that will receive the result of the game (true for success, false for failure).
--- @param time number|nil: Time duration for the game in seconds. Default is 10 if nil.
--- @param gridsize number|nil: Size of the game grid (number of blocks per side). Default is 6 if nil.
--- @param wrong number|nil: Maximum number of incorrect answers allowed. Default is 3 if nil.
--- @param correctBlocks number|nil: Number of correct blocks to display. If not provided, it is determined based on the grid size.
local function thermite(cb, time, gridsize, wrong, correctBlocks)
    -- Default values if parameters are not provided
    if time == nil then time = 10 end
    if gridsize <= 5 or gridsize == nil then gridsize = 6 end 
    if wrong == nil then wrong = 3 end

    local correctBlockCount = correctBlocks or correctBlocksBasedOnGrid[gridsize]
    DebugPrint("Thermite called with " .. correctBlockCount .. " correct blocks and " .. time .. " time")
    SendNUI("GameLauncher", cb, {  -- Use SendNUI with nil callback
        game = "MemoryGame",  -- Name of the game
        gameName = "Memory Game",  -- Display name of the game
        gameDescription = "Test your memory with Thermite! Match blocks on a grid before time runs out. Adjust grid size and incorrect answers for added challenge!",  -- Description of the game
        amountOfAnswers = correctBlockCount,  -- Number of correct blocks to display
        gameTime = time,  -- Time duration for the game
        maxAnswersIncorrect = wrong,  -- Maximum number of incorrect answers allowed
        displayInitialAnswersFor = 3,  -- Time to display initial answers (seconds)
        gridSize = gridsize,  -- Size of the game grid
    }, true)
end
exports("Thermite", thermite)