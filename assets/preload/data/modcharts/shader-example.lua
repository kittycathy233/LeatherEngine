function start( song )
    --                    id    filename  camera
    createCustomShader("example", "example", 120)
    --                       id      camera
    setCameraCustomShader("example", "game")
    setCameraCustomShader("example", "hud")
end