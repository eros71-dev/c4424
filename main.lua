-- name: C4424
-- description: C\\#09b6ca\\4\\#baab16\\4\\#1a2ec4\\2\\#e93ee3\\4\n\\#dcdcdc\\By The C4424 Team\n\nEnough creepypastas, give me a comfortingpasta instead.\n\nComfortingpasta? Soothingpasta?...\n\n\nUnscarypasta?\n\nI don't know, just bring me back to the good old days.

local sSavedSettings      = {
    bouncyLevelBounds = gServerSettings.bouncyLevelBounds,
    stayInLevelAfterStar = gServerSettings.stayInLevelAfterStar,
    skipIntro = gServerSettings.skipIntro,
    bubbleDeath = gServerSettings.bubbleDeath,
    enablePlayerList = gServerSettings.enablePlayerList,
    enablePlayersInLevelDisplay = gServerSettings.enablePlayersInLevelDisplay,
    nametags = gServerSettings.nametags,
    pauseAnywhere = gServerSettings.pauseAnywhere,
    pauseExitAnywhere = gLevelValues.pauseExitAnywhere,
    respawnShellBoxes = gBehaviorValues.RespawnShellBoxes
}

local sWatermarkNames     = {
    [WATERMARK_NONE] = "None",
    [WATERMARK_HYPERCAM] = "Hypercam",
    [WATERMARK_BANDICAM] = "Bandicam"
}

c4424Enabled              = not mod_storage_load_bool_2("c4424_enabled")
c4424HideEmblems          = mod_storage_load_bool_2("hide_emblems")
c4424HideShadows          = mod_storage_load_bool_2("hide_shadows")
c4424PlayMusic            = mod_storage_load_bool_2("play_music")
c4424ForceMario           = mod_storage_load_bool_2("force_mario")
c4424Watermark            = if_then_else(mod_storage_exists("watermark"), mod_storage_load_number("watermark"), WATERMARK_HYPERCAM)
c4424ForceAspectRatio     = mod_storage_load_bool_2("force_aspect_ratio") -- Forces C4424's 4:3

local shouldPlayMamaSound = true -- Forced ON for now

-- Mod storage save function
local function c4424_save()
    mod_storage_save_bool("c4424_enabled", c4424Enabled)
    mod_storage_save_bool("hide_emblems", c4424HideEmblems)
    mod_storage_save_bool("hide_shadows", c4424HideShadows)
    mod_storage_save_bool("play_music", c4424PlayMusic)
    mod_storage_save_number("watermark", c4424Watermark)
    mod_storage_save_bool("force_mario", c4424ForceMario)
    mod_storage_save_bool("force_aspect_ratio", c4424ForceAspectRatio)
end

local function toggle_c4424()
    if not c4424Enabled then
        sSavedSettings = {
            bouncyLevelBounds = gServerSettings.bouncyLevelBounds,
            stayInLevelAfterStar = gServerSettings.stayInLevelAfterStar,
            skipIntro = gServerSettings.skipIntro,
            bubbleDeath = gServerSettings.bubbleDeath,
            enablePlayerList = gServerSettings.enablePlayerList,
            enablePlayersInLevelDisplay = gServerSettings.enablePlayersInLevelDisplay,
            nametags = gServerSettings.nametags,
            pauseAnywhere = gServerSettings.pauseAnywhere,
            pauseExitAnywhere = gLevelValues.pauseExitAnywhere,
            respawnShellBoxes = gBehaviorValues.RespawnShellBoxes
        }
    end

    c4424Enabled = not c4424Enabled
    override_emblems()
    override_shadows()

    if c4424Enabled then
        gServerSettings.bouncyLevelBounds = BOUNCY_LEVEL_BOUNDS_OFF
        gServerSettings.stayInLevelAfterStar = 0
        gServerSettings.skipIntro = false
        gServerSettings.bubbleDeath = false
        gServerSettings.enablePlayerList = false
        gServerSettings.enablePlayersInLevelDisplay = false
        gServerSettings.nametags = false
        gServerSettings.pauseAnywhere = false
        gLevelValues.pauseExitAnywhere = false
        gBehaviorValues.RespawnShellBoxes = false

        handle_music()

        set_window_title("SUPER MARIO 64 - Project 64 Version 1.6")
    else
        gServerSettings.bouncyLevelBounds = sSavedSettings.bouncyLevelBounds
        gServerSettings.stayInLevelAfterStar = sSavedSettings.stayInLevelAfterStar
        gServerSettings.skipIntro = sSavedSettings.skipIntro
        gServerSettings.bubbleDeath = sSavedSettings.bubbleDeath
        gServerSettings.enablePlayerList = sSavedSettings.enablePlayerList
        gServerSettings.enablePlayersInLevelDisplay = sSavedSettings.enablePlayersInLevelDisplay
        gServerSettings.nametags = sSavedSettings.nametags
        gServerSettings.pauseAnywhere = sSavedSettings.pauseAnywhere
        gLevelValues.pauseExitAnywhere = sSavedSettings.pauseExitAnywhere
        gBehaviorValues.RespawnShellBoxes = sSavedSettings.respawnShellBoxes

        handle_music()
        reset_window_title()
    end
end
--toggle_c4424()

--- @param m MarioState
local function mario_update(m)
    if not active_player(m) then return end

    gNetworkPlayers[m.playerIndex].overrideModelIndex = if_then_else(c4424Enabled and c4424ForceMario, CT_MARIO,
        gNetworkPlayers[0].modelIndex)

    if not c4424Enabled then return end

    --1% chance
    if shouldPlayMamaSound and m.hurtCounter == 1 and math.random(1, 100) <= 1 then
        audio_sample_play(SOUND_CUSTOM_MAMA, m.pos, 1)
        shouldPlayMamaSound = false
    end
end

local function on_warp()
    handle_music()
end

local function on_hud_render()
    if not c4424Enabled then return end

    if c4424ForceAspectRatio then
        djui_hud_set_resolution(RESOLUTION_N64)

        djui_hud_set_color(0, 0, 0, 255)

        local width = djui_hud_get_screen_width() + 30
        local height = djui_hud_get_screen_height()
        djui_hud_render_rect(0, 0, width, 8)
        djui_hud_render_rect(0, height - 8, width, 8)
    end

    djui_hud_set_resolution(RESOLUTION_DJUI)

    djui_hud_set_color(255, 255, 255, 255)

    if c4424Watermark == WATERMARK_HYPERCAM then
        djui_hud_render_texture(TEX_HYPERCAM, 0, 0, 1.5, 1.5)
    elseif c4424Watermark == WATERMARK_BANDICAM then
        djui_hud_render_texture(TEX_BANDICAM, djui_hud_get_screen_width() * 0.5 - 128, 0, 1, 1)
    end
end

local function on_hud_render_behind()
    if not c4424Enabled then
        local flags = hud_get_value(HUD_DISPLAY_FLAGS)
        if flags == HUD_DISPLAY_FLAGS_C4424 or flags == HUD_DISPLAY_FLAGS_C4424 | HUD_DISPLAY_FLAGS_COIN_COUNT then
            hud_set_value(HUD_DISPLAY_FLAGS,
                HUD_DISPLAY_FLAGS_LIVES | HUD_DISPLAY_FLAGS_STAR_COUNT | HUD_DISPLAY_FLAGS_CAMERA |
                HUD_DISPLAY_FLAGS_CAMERA_AND_POWER | HUD_DISPLAY_FLAGS_POWER)
        end
        return
    end

    --render_vanilla_hud()
end

local function on_exit()
    c4424_save()
end


local function on_set_enable_c4424()
    toggle_c4424()
end

local function on_set_hide_emblems()
    c4424HideEmblems = not c4424HideEmblems
    override_emblems()
    c4424_save()
end

local function on_set_hide_shadows()
    c4424HideShadows = not c4424HideShadows
    override_shadows()
    c4424_save()
end

local function on_set_play_music()
    c4424PlayMusic = not c4424PlayMusic
    handle_music()
    c4424_save()
end

local function on_set_force_mario()
    c4424ForceMario = not c4424ForceMario
    c4424_save()
end

local function on_set_force_aspect_ratio()
    c4424ForceAspectRatio = not c4424ForceAspectRatio
    c4424_save()
end

local function on_set_watermark(index, value)
    c4424Watermark = value
    if value == WATERMARK_NONE then
        update_mod_menu_element_name(index, "Watermark: None")
    elseif value == WATERMARK_HYPERCAM then
        update_mod_menu_element_name(index, "Watermark: Hypercam")
    elseif value == WATERMARK_BANDICAM then
        update_mod_menu_element_name(index, "Watermark: Bandicam")
    end
end


hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_event(HOOK_ON_WARP, on_warp)
hook_event(HOOK_ON_HUD_RENDER_BEHIND, on_hud_render_behind)
hook_event(HOOK_ON_EXIT, on_exit)

hook_mod_menu_checkbox("Enable C4424", c4424Enabled, on_set_enable_c4424)
hook_mod_menu_checkbox("Hide Emblems", c4424HideEmblems, on_set_hide_emblems)
hook_mod_menu_checkbox("Hide Shadows", c4424HideShadows, on_set_hide_shadows)
hook_mod_menu_checkbox("Play Music", c4424PlayMusic, on_set_play_music)
hook_mod_menu_checkbox("Force Mario", c4424ForceMario, on_set_force_mario)
hook_mod_menu_checkbox("Force Classic Aspect Ratio", c4424ForceAspectRatio, on_set_force_aspect_ratio)
hook_mod_menu_slider("Watermark: " .. sWatermarkNames[c4424Watermark], c4424Watermark, WATERMARK_NONE, WATERMARK_BANDICAM,
    on_set_watermark)
