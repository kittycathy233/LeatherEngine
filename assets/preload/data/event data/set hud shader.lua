function onEvent(name, position, argument1, argument2)
    if string.lower(name) == "set hud shader" then
        setCameraCustomShader(argument1, argument2, "hud")
    end
end