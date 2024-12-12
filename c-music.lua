_G.c4424.sMusicTable = {
    { stream = audio_stream_load("trance.mp3"),         volume = 0.8, displayName = "Trance - 009 Sound System" },
    { stream = audio_stream_load("schemingweasel.mp3"), volume = 1.2, displayName = "Scheming Weasel - Kevin MacLeod" },
    { stream = audio_stream_load("monkeys.mp3"),        volume = 1.1, displayName = "Monkeys Spinning Monkeys - Kevin MacLeod" },
    { stream = audio_stream_load("wallpaper.mp3"),      volume = 1.1, displayName = "Wallpaper - Kevin MacLeod" }
}

levelSeq = 0
local currentMusic = 0

function handle_classic_music()
    if not playMusic or not c4424Enabled then
        if currentMusic ~= 0 then
            audio_stream_stop(_G.c4424.sMusicTable[currentMusic].stream)
            currentMusic = 0
        end
        set_background_music(SEQ_PLAYER_LEVEL, levelSeq, 0)
        return
    end

    -- 25% chance of playing the music
    if math.random(1, 100) > 25 then
        local newMusic = if_then_else(math.random(1, 100) <= 50 and currentMusic ~= 0, currentMusic,
            math.random(1, #_G.c4424.sMusicTable))                                                                                          -- 50% chance to just be the same music
        if newMusic == currentMusic then
            set_background_music(SEQ_PLAYER_LEVEL, 0, 0)
            return
        end

        if currentMusic ~= 0 then audio_stream_stop(_G.c4424.sMusicTable[currentMusic].stream) end

        local music = _G.c4424.sMusicTable[newMusic]
        currentMusic = newMusic
        audio_stream_play(music.stream, true, music.volume)
        audio_stream_set_looping(music.stream, true)
        set_background_music(SEQ_PLAYER_LEVEL, 0, 0)
    end
    -- djui_popup_create("Now playing: " .. music.displayName, 2)
end

local function on_level_init()
    -- If audio music is playing stop sequence music
    if currentMusic ~= 0 then
        set_background_music(SEQ_PLAYER_LEVEL, 0, 0)
    end
end

hook_event(HOOK_ON_LEVEL_INIT, on_level_init)
