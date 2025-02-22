local sReadonlyMetatable = {
    __index = function(table, key)
        return rawget(table, key)
    end,

    __newindex = function()
        error("Attempt to update a read-only table", 2)
    end
}

_G.C4424_MUSIC = function(filename, volume, displayName)
    return { stream = audio_stream_load(filename), volume = volume, displayName = displayName }
end

_G.c4424Api = {
    musicTable = {
        C4424_MUSIC("trance.mp3", 0.9, "Trance - 009 Sound System"),
        C4424_MUSIC("schemingweasel.mp3", 1.5, "Scheming Weasel - Kevin MacLeod"),
        C4424_MUSIC("monkeys.mp3", 1.0, "Monkeys Spinning Monkeys - Kevin MacLeod"),
        C4424_MUSIC("scatman_skiba.mp3", 1.0, "Scatman (ski-ba-bop-ba-dop-bop) - Scatman John"),
        C4424_MUSIC("scatmans_world.mp3", 1.0, "Scatman's World - Scatman John")
    }
}
setmetatable(_G.c4424Api, sReadonlyMetatable)

local currentMusic = 0

function handle_music()
    -- if C4424 or its music is disabled, stop it and resume sequence playing
    if not c4424Enabled or not c4424PlayMusic then
        if currentMusic ~= 0 then
            audio_stream_stop(_G.c4424Api.musicTable[currentMusic].stream)
            set_background_music(SEQ_PLAYER_LEVEL, gMarioStates[0].area.musicParam2, 0)
            currentMusic = 0
        end
        return
    end

    -- 30% chance to play custom music
    if math.random(1, 100) <= 30 then
        if currentMusic ~= 0 then
            audio_stream_stop(_G.c4424Api.musicTable[currentMusic].stream)
        end

        -- 25% chance of staying with the same song or switching to a new one in the music table
        currentMusic = if_then_else(
            math.random(1, 100) <= 25 or currentMusic == 0,
            math.random(1, #_G.c4424Api.musicTable),
            currentMusic
        )

        local music = _G.c4424Api.musicTable[currentMusic]
        audio_stream_play(music.stream, true, music.volume)
        audio_stream_set_looping(music.stream, true)
        set_background_music(SEQ_PLAYER_LEVEL, SEQ_SOUND_PLAYER, 0)

        -- djui_popup_create("Now playing:\n" .. music.displayName, 3)
    elseif currentMusic ~= 0 then
        audio_stream_stop(_G.c4424Api.musicTable[currentMusic].stream)
        set_background_music(SEQ_PLAYER_LEVEL, gMarioStates[0].area.musicParam2, 0)
        currentMusic = 0
    end

end