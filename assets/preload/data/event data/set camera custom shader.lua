function onEvent(name, position, argument1, argument2)
    if string.lower(name) == "set camera custom shader" then
        if argument2 ~= "hud" or agument2 ~= "game" then
            setCameraCustomShader(argument1, "hud")
            setCameraCustomShader(argument1, "game")
        else
            setCameraCustomShader(argument1, argument2)
        end
    end
end