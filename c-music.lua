local currentMusic = 0

function handle_classic_music()
    if not c4424PlayMusic or not c4424Enabled then
        if currentMusic ~= 0 then
            audio_stream_stop(_G.c4424Api.musicTable[currentMusic].stream)
            currentMusic = 0
        end
        set_background_music(SEQ_PLAYER_LEVEL, gMarioStates[0].area.musicParam2, 0)
        return
    end

    -- 25% chance of playing the music
    if math.random(1, 100) > 25 then
        -- 50% chance to just be the same music
        local newMusic = if_then_else(
            math.random(1, 100) <= 50 and currentMusic ~= 0,
            currentMusic,
            math.random(1, #_G.c4424Api.musicTable)
        )
        if newMusic == currentMusic then
            set_background_music(SEQ_PLAYER_LEVEL, 0, 0)
            return
        end

        if currentMusic ~= 0 then audio_stream_stop(_G.c4424Api.musicTable[currentMusic].stream) end

        local music = _G.c4424Api.musicTable[newMusic]
        currentMusic = newMusic
        audio_stream_play(music.stream, true, music.volume)
        audio_stream_set_looping(music.stream, true)
        set_background_music(SEQ_PLAYER_LEVEL, 0, 0)
    end
    -- djui_popup_create("Now playing: " .. music.displayName, 2)
end

function stop_sequence_music()
    -- if audio music is playing, stop sequence music
    if currentMusic ~= 0 then
        set_background_music(SEQ_PLAYER_LEVEL, 0, 0)
    end
end