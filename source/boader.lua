local pd <const> = playdate
local gfx <const> = pd.graphics

function makeBoader(image)
    boader = gfx.sprite.new(image)
    boader:moveTo(100, 60)
    boader:add()
end
