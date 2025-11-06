function start( song )
    print(song)
    --                    id    filename  glsl ver
    createCustomShader("example", "example", 120) -- creating the shader
    --                       id      camera
    setCameraCustomShader("example", "game") -- setting shader to camGame
    setCameraCustomShader("example", "hud") -- setting shader to camHUD
end
function beatHit( beat )
    if curBeat == 25 then -- turning off shaders after 25 beats
        setCameraNoCustomShader("hud")
        setCameraNoCustomShader("game")
    end
    if curBeat == 30 then -- changing the icons to have a shader after 30 beats
        setActorCustomShader("example", "iconP1")
        setActorCustomShader("example", "iconP2")
    end
end
