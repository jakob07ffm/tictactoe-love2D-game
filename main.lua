function love.load()
    love.window.setTitle("Tic-Tac-Toe")
    love.window.setMode(600, 600)
    cellSize = 200
    currentPlayer = 'X'
    board = {
        {'', '', ''},
        {'', '', ''},
        {'', '', ''}
    }
    gameState = "playing"
    winner = nil
    winPatterns = {
        {{1, 1}, {1, 2}, {1, 3}},
        {{2, 1}, {2, 2}, {2, 3}},
        {{3, 1}, {3, 2}, {3, 3}},
        {{1, 1}, {2, 1}, {3, 1}},
        {{1, 2}, {2, 2}, {3, 2}},
        {{1, 3}, {2, 3}, {3, 3}},
        {{1, 1}, {2, 2}, {3, 3}},
        {{1, 3}, {2, 2}, {3, 1}}
    }
end

function love.draw()
    drawBoard()
    drawMarks()
    if gameState == "won" then
        love.graphics.setColor(0, 1, 0)
        drawWinningLine()
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(winner .. " wins!", 0, 550, 600, 'center')
    elseif gameState == "draw" then
        love.graphics.printf("It's a draw!", 0, 550, 600, 'center')
    end
end

function drawBoard()
    love.graphics.setLineWidth(5)
    for i = 1, 2 do
        love.graphics.line(i * cellSize, 0, i * cellSize, 600)
        love.graphics.line(0, i * cellSize, 600, i * cellSize)
    end
end

function drawMarks()
    for y = 1, 3 do
        for x = 1, 3 do
            if board[y][x] == 'X' then
                drawX(x, y)
            elseif board[y][x] == 'O' then
                drawO(x, y)
            end
        end
    end
end

function drawX(x, y)
    local cx = (x - 1) * cellSize + cellSize / 2
    local cy = (y - 1) * cellSize + cellSize / 2
    local offset = cellSize / 4
    love.graphics.line(cx - offset, cy - offset, cx + offset, cy + offset)
    love.graphics.line(cx + offset, cy - offset, cx - offset, cy + offset)
end

function drawO(x, y)
    local cx = (x - 1) * cellSize + cellSize / 2
    local cy = (y - 1) * cellSize + cellSize / 2
    local radius = cellSize / 4
    love.graphics.circle("line", cx, cy, radius)
end

function drawWinningLine()
    local startX, startY, endX, endY
    for _, pattern in ipairs(winPatterns) do
        if board[pattern[1][1]][pattern[1][2]] == winner and
           board[pattern[2][1]][pattern[2][2]] == winner and
           board[pattern[3][1]][pattern[3][2]] == winner then
            startX = (pattern[1][2] - 1) * cellSize + cellSize / 2
            startY = (pattern[1][1] - 1) * cellSize + cellSize / 2
            endX = (pattern[3][2] - 1) * cellSize + cellSize / 2
            endY = (pattern[3][1] - 1) * cellSize + cellSize / 2
            love.graphics.line(startX, startY, endX, endY)
            break
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 and gameState == "playing" then
        local gridX = math.ceil(x / cellSize)
        local gridY = math.ceil(y / cellSize)
        if board[gridY][gridX] == '' then
            board[gridY][gridX] = currentPlayer
            if checkWin(currentPlayer) then
                gameState = "won"
                winner = currentPlayer
            elseif checkDraw() then
                gameState = "draw"
            else
                currentPlayer = currentPlayer == 'X' and 'O' or 'X'
            end
        end
    elseif button == 1 and gameState ~= "playing" then
        love.load()
    end
end

function checkWin(player)
    for _, pattern in ipairs(winPatterns) do
        if board[pattern[1][1]][pattern[1][2]] == player and
           board[pattern[2][1]][pattern[2][2]] == player and
           board[pattern[3][1]][pattern[3][2]] == player then
            return true
        end
    end
    return false
end

function checkDraw()
    for y = 1, 3 do
        for x = 1, 3 do
            if board[y][x] == '' then
                return false
            end
        end
    end
    return true
end
