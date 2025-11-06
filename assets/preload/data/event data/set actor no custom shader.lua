function onEvent(name, position, argument1, argument2)
    if string.lower(name) == "set actor no custom shader" then
        setActorNoCustomShader(argument1)
    end
end