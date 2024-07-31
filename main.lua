-- main.lua
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
    gameState = "playing" -- can be "playing", "won", "draw"
    winner = nil
end

function love.draw()
    drawBoard()
    drawMarks()
    if gameState == "won" then
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
    for i = 1, 3 do
        if board[i][1] == player and board[i][2] == player and board[i][3] == player then
            return true
        end
        if board[1][i] == player and board[2][i] == player and board[3][i] == player then
            return true
        end
    end
    if board[1][1] == player and board[2][2] == player and board[3][3] == player then
        return true
    end
    if board[1][3] == player and board[2][2] == player and board[3][1] == player then
        return true
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
