local sReadonlyMetatable = {
    __index = function(table, key)
        return rawget(table, key)
    end,

    __newindex = function()
        error("Attempt to update a read-only table", 2)
    end
}

_G.c4424Api = {
    musicTable = {
        { stream = audio_stream_load("trance.mp3"),         volume = 0.9, displayName = "Trance - 009 Sound System" },
        { stream = audio_stream_load("schemingweasel.mp3"), volume = 1.5, displayName = "Scheming Weasel - Kevin MacLeod" },
        { stream = audio_stream_load("monkeys.mp3"),        volume = 1.0, displayName = "Monkeys Spinning Monkeys - Kevin MacLeod" },
        { stream = audio_stream_load("wallpaper.mp3"),      volume = 1.0, displayName = "Wallpaper - Kevin MacLeod" }
    }
}
setmetatable(_G.c4424Api, sReadonlyMetatable)

TEX_EMPTY = get_texture_info("c4424_empty")
TEX_WHITE = get_texture_info("c4424_white")

TEX_HYPERCAM = get_texture_info("c4424_hypercam")
TEX_BANDICAM = get_texture_info("c4424_bandicam")

SOUND_CUSTOM_MAMA = audio_sample_load("mama.mp3")

HUD_DISPLAY_FLAGS_C4424 = HUD_DISPLAY_FLAGS_CAMERA_AND_POWER | HUD_DISPLAY_FLAGS_POWER

WATERMARK_NONE = 0
WATERMARK_HYPERCAM = 1
WATERMARK_BANDICAM = 2