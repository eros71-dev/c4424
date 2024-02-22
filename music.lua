local currentSong = nil
local chancePercent = 15


-- Usual mod storage stuff
if (mod_storage_load_number("firstRunDone") == 0) then
    mod_storage_save_bool("showSongName", false)
    mod_storage_save_bool("playYtMusic", true)
end

local showSongName = tobool(mod_storage_load("showSongName"))
local playYtMusic = tobool(mod_storage_load("playYtMusic"))

-- Array of epic overused yt background music
songs = {
    [1] = { name = "trance", volume = 0.8, displayName = "Trance - 009 Sound System" },
    [2] = { name = "schemingweasel", volume = 1.2, displayName = "Scheming Weasel - Kevin MacLeod" },
    [3] = { name = "monkeys", volume = 1.1, displayName = "Monkeys Spinning Monkeys - Kevin MacLeod" },
    [4] = { name = "wallpaper", volume = 1.1, displayName = "Wallpaper - Kevin MacLeod" }
}

function on_level_init()
    local alredyShown = false
    if playYtMusic then
        if currentSong ~= nil then
            audio_stream_stop(currentSong)
            audio_stream_destroy(currentSong)
            currentSong = nil
        end
        -- variant% chance to play a song
        if math.random(1, 100) <= chancePercent then
            -- Stop SM64's default music
            set_background_music(0, 0, 0)
            -- Randomly select a song from the list to play
            local songID = songs[math.random(1, #songs)]
            currentSong = audio_stream_load(songID.name .. ".mp3")
            if currentSong ~= nil then
                audio_stream_set_looping(currentSong, true)
                audio_stream_play(currentSong, true, 1.1)
                if showSongName and not alredyShown then
                    djui_popup_create("Now playing: " .. songID.displayName, 1)
                    alreadyShown = true
                end
            else
                djui_popup_create('Missing audio!: ' .. songID.name, 1)
                print("Attempted to load filed audio file, but couldn't find it on the system: " .. songID.name)
            end
        end
    else
        if currentSong ~= nil then
            audio_stream_stop(currentSong)
            audio_stream_destroy(currentSong)
            currentSong = nil
        end
    end
end

function on_song_name_command(msg)
    msg = string.lower(msg)
    if msg == "on" then
        djui_chat_message_create("Song name display enabled.")
        showSongName = true
    elseif msg == "off" then
        djui_chat_message_create("Song name display disabled.")
        showSongName = false
    elseif msg == "info" then
        local modeText = "disabled"
        if showSongName then
            modeText = "enabled"
        end
        djui_chat_message_create("Song name display is " .. modeText .. ".")
    else
        djui_chat_message_create("Parameter must be ON, OFF, or info.")
    end
    mod_storage_save_bool("showSongName", showSongName)
    return true
end

function on_play_yt_music_command(msg)
    msg = string.lower(msg)
    if msg == "on" then
        playYtMusic = true
        mod_storage_save_bool("playYtMusic", playYtMusic)
        djui_chat_message_create("Overused YT background music enabled.")
    elseif msg == "off" then
        playYtMusic = false
        mod_storage_save_bool("playYtMusic", playYtMusic)
        djui_chat_message_create("Overused YT background music disabled.")
    elseif msg == "info" then
        local modeText = "disabled"
        if playYtMusic then
            modeText = "enabled"
        end
        djui_chat_message_create("Overused YT background music is " .. modeText .. ".")
    else
        djui_chat_message_create("Parameter must be ON, OFF, or info.")
    end
    return true
end

local function update()
    if currentSong ~= nil and get_current_background_music() ~= 0 then
        set_background_music(0, 0, 0)
    end
end

hook_event(HOOK_ON_LEVEL_INIT, on_level_init)
hook_event(HOOK_UPDATE, update)
hook_chat_command("show_song_name", "- [on|off] Toggles the display of the currently playing song.", on_song_name_command)
hook_chat_command("play_yt_music",
    "- [on|off] Plays a random song from a list of overused (copyright-free) YT background music.",
    on_play_yt_music_command)
