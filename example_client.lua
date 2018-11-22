local cs = require 'cs'
local client = cs.client


client.enabled = true
client.start('207.254.45.246:22122') -- IP address ('127.0.0.1' is same computer) and port of server


-- Client connects to server. It gets a unique `id` to identify it.
--
-- `client.share` represents the shared state that server can write to and any client can read from.
-- `client.home` represents the home for this client that only it can write to and only server can
-- read from. `client.id` is the `id` for this client (set once it connects).
--
-- Client can also send or receive individual messages to or from server.


local share = client.share -- Maps to `server.share` -- can read
local home = client.home -- Maps to `server.homes[id]` with our `id` -- can write


function client.connect() -- Called on connect from server
end

function client.disconnect() -- Called on disconnect from server
end

function client.receive(...) -- Called when server does `server.send(id, ...)` with our `id`
end


-- Client gets all Love events

function client.load()
    home.mouse = {}
    home.mouse.x, home.mouse.y = love.mouse.getPosition()
end

function client.update(dt)
    home.mouse.x, home.mouse.y = love.mouse.getPosition()
end

function client.draw()
    if client.connected then
        -- Draw other mice
        for id, mouse in pairs(share.mice) do
            if id ~= client.id then -- Only draw others' mice this way
                love.graphics.setColor(mouse.r, mouse.g, mouse.b)
                love.graphics.circle('fill', mouse.x, mouse.y, 30, 30)
            end
        end

        -- Draw our own mouse in a special way (bigger radius)
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle('fill', home.mouse.x, home.mouse.y, 40, 40)

        -- Draw our ping
        love.graphics.print('ping: ' .. client.getPing(), 20, 20)
        love.graphics.print('\nfps: ' .. love.timer.getFPS(), 20, 20)
    else
        love.graphics.print('not connected', 20, 20)
    end
end
