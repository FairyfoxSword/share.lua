local cs = require 'cs'
local client = cs.client


client.enabled = true
client.start('127.0.0.1:22122') -- IP address ('127.0.0.1' is same computer) and port of server


-- Client connects to server. It gets a unique `id` to identify it.
--
-- `client.share` represents the shared state that server can write to and any client can read from.
-- `client.home` represents the home for this client that only it can write to and only server can
-- read from. `client.id` is the `id` for this client (set once it connects).
--
-- Client can also send individual messages using `client.send(...)` to server.


local share = client.share -- Maps to `server.share` -- can read
local home = client.home -- Maps to `server.homes[client.id]` -- can write


function client.connect() -- Called on connect from server
end

function client.disconnect() -- Called on disconnect from server
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
        -- Draw our own mouse in a special way (bigger radius)
        love.graphics.circle('fill', home.mouse.x, home.mouse.y, 40, 40)

        -- Draw other mice
        for id, mouse in pairs(share.mice) do
            if id ~= client.id then -- Only throw others' mice this way
                love.graphics.circle('fill', home.mouse.x, home.mouse.y, 30, 30)
            end
        end
    else
        love.graphics.print('not connected', 20, 20)
    end
end
