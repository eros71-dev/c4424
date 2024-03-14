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

--c4424Enabled = false
watermarkTex = TEX_HYPERCAM

local sSavedSettings = {
    bouncyLevelBounds = gServerSettings.bouncyLevelBounds,
    bubbleDeath = gServerSettings.bubbleDeath,
    nametags = gServerSettings.nametags,
    stayInLevelAfterStar = gServerSettings.stayInLevelAfterStar,
    fixVanishFloors = gLevelValues.fixVanishFloors,
    pauseExitAnywhere = gLevelValues.pauseExitAnywhere,
    respawnShellBoxes = gBehaviorValues.RespawnShellBoxes,
    enablePlayerList = gServerSettings.enablePlayerList,
    enablePlayersInLevelDisplay = gServerSettings.enablePlayersInLevelDisplay,
    freeCam = camera_config_is_free_cam_enabled(),
}

-- Default settings
c4424Enabled = true
hideEmblems = true
hideShadows = true
playMusic = true
watermarkValue = 1
--stretchWidescreen = true
--highPitch = false
forceMario = true

local shouldPlayMamaSound = true

local function update_saved_settings()
    sSavedSettings = {
        bouncyLevelBounds = gServerSettings.bouncyLevelBounds,
        bubbleDeath = gServerSettings.bubbleDeath,
        nametags = gServerSettings.nametags,
        stayInLevelAfterStar = gServerSettings.stayInLevelAfterStar,
        fixVanishFloors = gLevelValues.fixVanishFloors,
        pauseExitAnywhere = gLevelValues.pauseExitAnywhere,
        respawnShellBoxes = gBehaviorValues.RespawnShellBoxes,
        enablePlayerList = gServerSettings.enablePlayerList,
        enablePlayersInLevelDisplay = gServerSettings.enablePlayersInLevelDisplay,
        freeCam = camera_config_is_free_cam_enabled(),
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
        gServerSettings.enablePlayerList = false
        gServerSettings.enablePlayersInLevelDisplay = false

        gLevelValues.fixVanishFloors = false
        gLevelValues.pauseExitAnywhere = false
        gBehaviorValues.RespawnShellBoxes = false

        --camera_config_enable_free_cam(false) -- I'll be honest this may be a bit annoying later on

        handle_classic_music()

        set_window_title("SUPER MARIO 64 - Project 64 Version 1.6")
    else
        gServerSettings.bouncyLevelBounds = sSavedSettings.bouncyLevelBounds
        gServerSettings.bubbleDeath = sSavedSettings.bubbleDeath
        gServerSettings.nametags = sSavedSettings.nametags
        gServerSettings.stayInLevelAfterStar = sSavedSettings.stayInLevelAfterStar
        gServerSettings.enablePlayerList = sSavedSettings.enablePlayerList
        gServerSettings.enablePlayersInLevelDisplay = sSavedSettings.enablePlayersInLevelDisplay

        gLevelValues.fixVanishFloors = sSavedSettings.fixVanishFloors
        gLevelValues.pauseExitAnywhere = sSavedSettings.pauseExitAnywhere
        gBehaviorValues.RespawnShellBoxes = sSavedSettings.respawnShellBoxes

        --camera_config_enable_free_cam(sSavedSettings.freeCam)

        handle_classic_music()
        reset_window_title()
    end
end
toggle_c4424()

local function update()
    if not c4424Enabled then return end
    for i = 0, MAX_PLAYERS - 1 do
        gNetworkPlayers[i].overrideModelIndex = if_then_else(forceMario, CT_MARIO, gNetworkPlayers[0].modelIndex)
    end
end


--- @param m MarioState
local function mario_update(m)
    if not active_player(m) or not c4424Enabled then return end

    --10% chance
    if m.hurtCounter == 1 and math.random(1, 100) <= 10 and shouldPlayMamaSound then
        audio_sample_play(SOUND_CUSTOM_MAMA, m.pos, 1)
        shouldPlayMamaSound = false
    end

    if m.hurtCounter == 0 then
        shouldPlayMamaSound = true
    end
end

local function on_hud_render()
    if not c4424Enabled then return end

    djui_hud_set_resolution(RESOLUTION_DJUI)

    djui_hud_set_color(255, 255, 255, 255)

    if watermarkValue == 0 then
        return
    elseif watermarkValue == 1 then
        djui_hud_render_texture(TEX_HYPERCAM, 0, 0, 1.5, 1.5)
    elseif watermarkValue == 2 then
        djui_hud_render_texture(TEX_BANDICAM, djui_hud_get_screen_width() * 0.5 - 128, 0, 1, 1)
    end
end

-- it isn't necessary to have the following for hooks: all in 1 file, strict function naming, the hooked function in the same file
-- but I just abide by these anyway because I just think it's cleaner
local function on_level_init()
    levelSeq = get_current_background_music()
    handle_classic_music()
    -- Load preferences
    load_mod_storage()
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
        -- 0 = disabled, 1 = hypercam, 2 = bandicam
        if watermarkValue == 0 then
            watermarkValue = 1
            djui_chat_message_create("[C4424] Watermark: Hypercam")
        elseif watermarkValue == 1 then
            watermarkValue = 2
            djui_chat_message_create("[C4424] Watermark: Bandicam")
        else
            watermarkValue = 0
            djui_chat_message_create("[C4424] Watermark: Disabled")
        end
    elseif args[1] == "forceMario" then
        forceMario = not forceMario
        djui_chat_message_create("[C4424] Force Mario: " .. on_or_off_inverted(forceMario)) -- Why do I have to invert this one?
    elseif args[1] == "toggle" then
        toggle_c4424()
        djui_chat_message_create("[C4424] Status: " .. on_or_off_string(c4424Enabled, "Enabled", "Disabled"))
    elseif args[1] == "info" then
        debug_print_vars()
    else
        djui_chat_message_create(
            "c4424 - \\#00ffff\\[info|toggle|emblem|shadow|music|watermark|forceMario]")
    end

    save_mod_storage()
    return true
end

hook_event(HOOK_UPDATE, update)
hook_event(HOOK_MARIO_UPDATE, mario_update)
hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_event(HOOK_ON_LEVEL_INIT, on_level_init)
hook_event(HOOK_ON_HUD_RENDER_BEHIND, on_hud_render_behind)

hook_chat_command("c4424",
    "\\#00ffff\\[info|toggle|emblem|shadow|music|watermark|forceMario]",
    on_c4424_command)
