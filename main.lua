local player1 = { up = 'w', down = 's', score = 0 }
local player2 = { up = 'up', down = 'down', score = 0 }
local paddle = { speed = 200, width = 20, height = 100 }
local ball = { x = 0, y = 0, vx = 0, vy = 0, width = 10, height = 10 }


local reset = function()
  ball.x = love.graphics.getWidth() / 2
  ball.y = love.graphics.getHeight() / 2

  -- TODO start random
  ball.vx = 150
  ball.vy = 150
end


function love.load()
  player1.x = 50
  player1.y = love.graphics.getHeight() / 2 - 50
  player2.x = love.graphics.getWidth() - 70
  player2.y = love.graphics.getHeight() / 2 - 50
  reset()
end


function love.update(dt)

  -- Check for collision with walls and bounce if needed.
  if (ball.y < 0) then
    ball.vy = -ball.vy
  elseif (ball.y > love.graphics.getHeight() - ball.height) then
    ball.vy = -ball.vy
  end

  -- Handle ball movement.
  ball.x = ball.x - (ball.vx * dt)
  ball.y = ball.y + (ball.vy / 2 * dt)


  -- Handle player controls.
  if love.keyboard.isDown(player1.down) and player1.y < (love.graphics.getHeight() - paddle.height) then
    player1.y = player1.y + (paddle.speed * dt)
  elseif love.keyboard.isDown(player1.up) and player1.y > 0 then
    player1.y = player1.y - (paddle.speed * dt)
  end

  if love.keyboard.isDown(player2.down) and player2.y < (love.graphics.getHeight() - paddle.height) then
    player2.y = player2.y + (paddle.speed * dt)
  elseif love.keyboard.isDown(player2.up) and player2.y > 0 then
    player2.y = player2.y - (paddle.speed * dt)
  end

  -- Handle ball / paddle collisions.
  if not(ball.x + ball.width < player1.x  or player1.x + paddle.width < ball.x  or
         ball.y + ball.height < player1.y or player1.y + paddle.height < ball.y ) then
    ball.vx = -ball.vx
  end

  if not(ball.x + ball.width < player2.x  or player2.x + paddle.width < ball.x  or
         ball.y + ball.height < player2.y or player2.y + paddle.height < ball.y ) then
    ball.vx = -ball.vx
  end


  -- Handle scoring.
  if ball.x <= 0 then
    player2.score = player2.score + 1
    reset()
  end

  if ball.x >= love.graphics.getWidth() then
    player1.score = player1.score + 1
    reset()
  end
end


function love.draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle('fill', player1.x, player1.y, paddle.width, paddle.height)
  love.graphics.rectangle('fill', player2.x, player2.y, paddle.width, paddle.height)
  love.graphics.rectangle('fill', ball.x, ball.y, ball.width, ball.height)
  love.graphics.setFont(love.graphics.newFont(40))
  love.graphics.print(string.format('%d | %d', player1.score, player2.score), love.graphics.getWidth() / 2 - 45, 40)
end
