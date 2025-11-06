function onEvent(name, position, argument1, argument2)
    if string.lower(name) == "set actor custom shader" then
        setActorCustomShader(argument1, argument2)
    end
end