local player1 = { up = 'w', down = 's', score = 0 }
local player2 = { up = 'up', down = 'down', score = 0 }
local paddle = { speed = 200, width = 20, height = 100 }
local ball = { x = 0, y = 0, vx = 0, vy = 0, width = 10, height = 10 }
local sounds = {}
local gamestate = 'start'

local reset = function()
  ball.x = love.graphics.getWidth() / 2
  ball.y = love.graphics.getHeight() / 2
  ball.vx = 250
  ball.vy = 250
  if love.math.random() > .5 then
    ball.vx = -ball.vx
  end
  if love.math.random() > .5 then
    ball.vy = -ball.vy
  end
end


function love.load()
  sounds.bounce = love.audio.newSource('assets/sounds/pop.mp3', 'static')
  sounds.score = love.audio.newSource('assets/sounds/score.mp3', 'static')
  player1.x = 50
  player1.y = love.graphics.getHeight() / 2 - 50
  player2.x = love.graphics.getWidth() - 70
  player2.y = love.graphics.getHeight() / 2 - 50
  reset()
end

function love.keypressed(key)
  if (key == 'p') then
    if (gamestate == 'paused') then
      gamestate = 'running'
    else
      gamestate = 'paused'
    end
  end

  if (gamestate == 'start') then
    gamestate = 'running'
  end

end

function love.update(dt)
  if not(gamestate == 'running') then return end

  -- Check for collision with walls and bounce if needed.
  if (ball.y < 0) then
    ball.vy = -ball.vy
    sounds.bounce:play()
  elseif (ball.y > love.graphics.getHeight() - ball.height) then
    ball.vy = -ball.vy
    sounds.bounce:play()
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
    sounds.bounce:play()
  end

  if not(ball.x + ball.width < player2.x  or player2.x + paddle.width < ball.x  or
         ball.y + ball.height < player2.y or player2.y + paddle.height < ball.y ) then
    ball.vx = -ball.vx
    sounds.bounce:play()
  end


  -- Handle scoring.
  if ball.x <= 0 then
    player2.score = player2.score + 1
    sounds.score:play()
    reset()
  end

  if ball.x >= love.graphics.getWidth() then
    player1.score = player1.score + 1
    sounds.score:play()
    reset()
  end
end


function love.draw()
  love.graphics.setColor(255, 255, 255)

  if (gamestate == 'start') then
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.printf('Press any key to begin.', 200, 200, 600, 'center')
    return
  end

  if (gamestate == 'paused') then
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.printf('Paused. Press "p" to return.', 200, 200, 600, 'center')
    return
  end

  love.graphics.rectangle('fill', player1.x, player1.y, paddle.width, paddle.height)
  love.graphics.rectangle('fill', player2.x, player2.y, paddle.width, paddle.height)
  love.graphics.rectangle('fill', ball.x, ball.y, ball.width, ball.height)
  love.graphics.setFont(love.graphics.newFont(40))
  love.graphics.print(string.format('%d | %d', player1.score, player2.score), love.graphics.getWidth() / 2 - 45, 40)
end
