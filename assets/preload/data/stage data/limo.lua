-- same time that 'start' is called for regular modcharts :flushed:
function create(stage)
	print(stage .. " is our stage!")

	set("car.x", -12600)
	set("car.y", randomFloat(140, 250))
	set("car.velocity.x", 0)

	if animatedBackgrounds then
		createSound("pass1", "carPass0")
		createSound("pass2", "carPass1")
	end
end

local danceValue = false
local carCanGoVroom = true
local funnyTimer = 0
local time = 0

function update(elapsed)
	if animatedBackgrounds then
		time = time + elapsed
		funnyTimer = funnyTimer + elapsed

		if not carCanGoVroom and funnyTimer >= 2 then
			set("car.x", -12600)
			set("car.y", randomFloat(140, 250))
			set("car.velocity.x", 0)

			carCanGoVroom = true
		end
	end
end

-- everytime a beat hit is called on the song this happens
function beatHit(beat)
	if animatedBackgrounds then
		danceValue = not danceValue

		if danceValue then
			playAnimation("dancer1", "danceRight", true)
			playAnimation("dancer2", "danceRight", true)
			playAnimation("dancer3", "danceRight", true)
			playAnimation("dancer4", "danceRight", true)
		else
			playAnimation("dancer1", "danceLeft", true)
			playAnimation("dancer2", "danceLeft", true)
			playAnimation("dancer3", "danceLeft", true)
			playAnimation("dancer4", "danceLeft", true)
		end

		if randomInt(1,10) == 3 and carCanGoVroom then
			playSound("pass" .. tostring(randomInt(1,2)), true)

			set("car.velocity.x", (randomFloat(170, 220) / FlxG.elapsed) * 3)

			carCanGoVroom = false
			funnyTimer = 0
		end
	end
end