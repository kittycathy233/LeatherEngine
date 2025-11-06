function onEvent(name, position, argument1, argument2)
    if string.lower(name) == "create custom shader" then
        createCustomShader(argument1, argument2)
    end
end