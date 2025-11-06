local uTime = 0.0

function createPost()
    initShader('wiggle', 'wiggle')
    setShaderProperty('wiggle', 'uSpeed', 2)
    setShaderProperty('wiggle', 'uFrequency', 4)
    setShaderProperty('wiggle', 'uWaveAmplitude', 0.017)
    setShaderProperty('wiggle', 'effectType', 0)
    setShaderProperty('wiggle', 'uTime', 0)
    setActorShader('evilSchoolBG', 'wiggle')
    setActorShader('evilSchoolFG', 'wiggle')
end

function update(elapsed)
    uTime = uTime + elapsed
    setShaderProperty('wiggle', 'uTime', uTime)
end