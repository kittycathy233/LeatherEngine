function onEvent(name, position, argument1, argument2)
    if string.lower(name) == "set camera no custom shader" then
        if argument1 ~= "hud" or argument1 ~= "game" then
            setCameraNoCustomShader("hud")
            setCameraNoCustomShader("game")
        else
            setCameraNoCustomShader(argument1)
        end
    end
end