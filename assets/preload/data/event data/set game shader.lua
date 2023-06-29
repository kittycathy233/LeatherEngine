function onEvent(name, position, argument1, argument2)
    if string.lower(name) == "set game shader" then
        setCameraCustomShader(argument1, argument2, "game")
    end
end