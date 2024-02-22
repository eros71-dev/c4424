-- name: C4424
-- description: Enough creepypastas, give me a comfortingpasta instead.\n\nComfortingpasta? Soothingpasta?...\n\n\nUnscarypasta?\n\nI don't know, just bring me back to the good old days.\n\nBy lots of people, credits in the code.
-- deluxe: true

if SM64COOPDX_VERSION == nil then return end

TEX_EMPTY = get_texture_info("c4424_empty")
TEX_WHITE = get_texture_info("c4424_white")
local TEX_HYPERCAM = get_texture_info("c4424_hypercam")
local TEX_BANDICAM = get_texture_info("c4424_bandicam")

local SOUND_CUSTOM_MAMA = audio_sample_load("mama.mp3")

HUD_DISPLAY_FLAGS_C4424 = HUD_DISPLAY_FLAGS_CAMERA_AND_POWER | HUD_DISPLAY_FLAGS_POWER

c4424Enabled = false
local watermarkTex = TEX_HYPERCAM

local sSavedSettings = {
    bouncyLevelBounds = gServerSettings.bouncyLevelBounds,
    bubbleDeath = gServerSettings.bubbleDeath,
    nametags = gServerSettings.nametags,
    stayInLevelAfterStar = gServerSettings.stayInLevelAfterStar,
    fixVanishFloors = gLevelValues.fixVanishFloors,
    pauseExitAnywhere = gLevelValues.pauseExitAnywhere,
    respawnShellBoxes = gBehaviorValues.RespawnShellBoxes,
    freeCam = camera_config_is_free_cam_enabled(),
    noteFreq = smlua_audio_utils_get_note_freq_scale()
}

local function update_saved_settings()
    sSavedSettings = {
        bouncyLevelBounds = gServerSettings.bouncyLevelBounds,
        bubbleDeath = gServerSettings.bubbleDeath,
        nametags = gServerSettings.nametags,
        stayInLevelAfterStar = gServerSettings.stayInLevelAfterStar,
        fixVanishFloors = gLevelValues.fixVanishFloors,
        pauseExitAnywhere = gLevelValues.pauseExitAnywhere,
        respawnShellBoxes = gBehaviorValues.RespawnShellBoxes,
        freeCam = camera_config_is_free_cam_enabled(),
        noteFreq = smlua_audio_utils_get_note_freq_scale()
    }
end

local function toggle_c4424()
    if not c4424Enabled then
        update_saved_settings()
    end
    c4424Enabled = not c4424Enabled
    override_emblems()
    override_shadows()

    if c4424Enabled then
        gServerSettings.bouncyLevelBounds = BOUNCY_LEVEL_BOUNDS_OFF
        gServerSettings.bubbleDeath = false
        gServerSettings.nametags = false
        gServerSettings.stayInLevelAfterStar = 0

        gLevelValues.fixVanishFloors = false
        gLevelValues.pauseExitAnywhere = false
        gBehaviorValues.RespawnShellBoxes = false

        camera_config_enable_free_cam(false)

        smlua_audio_utils_set_note_freq_scale(1.02)
        set_window_title("SUPER MARIO 64 - Project 64 Version 1.6")
    else
        gServerSettings.bouncyLevelBounds = sSavedSettings.bouncyLevelBounds
        gServerSettings.bubbleDeath = sSavedSettings.bubbleDeath
        gServerSettings.nametags = sSavedSettings.nametags
        gServerSettings.stayInLevelAfterStar = sSavedSettings.stayInLevelAfterStar

        gLevelValues.fixVanishFloors = sSavedSettings.fixVanishFloors
        gLevelValues.pauseExitAnywhere = sSavedSettings.pauseExitAnywhere
        gBehaviorValues.RespawnShellBoxes = sSavedSettings.respawnShellBoxes

        camera_config_enable_free_cam(sSavedSettings.freeCam)

        handle_classic_music()
        smlua_audio_utils_set_note_freq_scale(sSavedSettings.noteFreq)
        reset_window_title()
    end
end
toggle_c4424()

local function update()
    for i = 0, MAX_PLAYERS - 1 do
        gNetworkPlayers[i].overrideModelIndex = if_then_else(c4424Enabled, CT_MARIO, gNetworkPlayers[0].modelIndex)
    end

    gfx_enable_adjust_for_aspect_ratio(not c4424Enabled or djui_hud_is_pause_menu_created())
end

--- @param m MarioState
local function mario_update(m)
    if not active_player(m) or not c4424Enabled then return end

    if m.hurtCounter == 1 then
        audio_sample_play(SOUND_CUSTOM_MAMA, m.pos, 1)
    end
end

local function on_hud_render()
    if not c4424Enabled then return end

    djui_hud_set_resolution(RESOLUTION_DJUI)

    djui_hud_set_color(255, 255, 255, 255)
    if watermarkTex == TEX_HYPERCAM then
        djui_hud_render_texture(TEX_HYPERCAM, 0, 0, 1.5, 1.5)
    else
        djui_hud_render_texture(TEX_BANDICAM, djui_hud_get_screen_width() * 0.5 - 128, 0, 1, 1)
    end
end

-- it isn't necessary to have the following for hooks: all in 1 file, strict function naming, the hooked function in the same file
-- but I just abide by these anyway because I just think it's cleaner
local function on_level_init()
    handle_classic_music()
end

local function on_hud_render_behind()
    if not c4424Enabled then
        local flags = hud_get_value(HUD_DISPLAY_FLAGS)
        if flags == HUD_DISPLAY_FLAGS_C4424 or flags == HUD_DISPLAY_FLAGS_C4424 | HUD_DISPLAY_FLAGS_COIN_COUNT then
            hud_set_value(HUD_DISPLAY_FLAGS, HUD_DISPLAY_FLAGS_LIVES | HUD_DISPLAY_FLAGS_STAR_COUNT | HUD_DISPLAY_FLAGS_CAMERA | HUD_DISPLAY_FLAGS_CAMERA_AND_POWER | HUD_DISPLAY_FLAGS_POWER)
        end
        return
    end

    render_vanilla_hud()
end


local function on_c4424_command(msg)
    local args = split(msg)
    if args[1] == "emblem" then
        hideEmblems = not hideEmblems
        override_emblems()
        djui_chat_message_create("[C4424] Emblem status: " .. on_or_off(hideEmblems))
    elseif args[1] == "shadow" then
        hideShadows = not hideShadows
        override_shadows()
        djui_chat_message_create("[C4424] Shadow status: " .. on_or_off(hideShadows))
    elseif args[1] == "music" then
        playMusic = not playMusic
        handle_classic_music()
        djui_chat_message_create("[C4424] Music status: " .. on_or_off(playMusic))
    elseif args[1] == "watermark" then
        if watermarkTex == TEX_HYPERCAM then
            watermarkTex = TEX_BANDICAM
            djui_chat_message_create("[C4424] Watermark: Bandicam")
        else
            watermarkTex = TEX_HYPERCAM
            djui_chat_message_create("[C4424] Watermark: Hypercam")
        end
    else
        toggle_c4424()
        djui_chat_message_create("[C4424] Status: " .. on_or_off(c4424Enabled))
    end

    return true
end

hook_event(HOOK_UPDATE, update)
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_event(HOOK_ON_LEVEL_INIT, on_level_init)
hook_event(HOOK_ON_HUD_RENDER_BEHIND, on_hud_render_behind)

hook_chat_command("c4424", "\\#00ffff\\[emblem|shadow|music|watermark]\\#7f7f7f\\ (leave blank to toggle C4424 on or off)", on_c4424_command)