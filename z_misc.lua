-- Classic mode

-- Usual mod storage stuff
if (mod_storage_load_number("firstRunDone") == 0) then
    mod_storage_save_number("firstRunDone", 1)
    mod_storage_save_bool("classicMode", true)
end

local classicMode = tobool(mod_storage_load("classicMode"))

if classicMode then
    gServerSettings.bouncyLevelBounds = BOUNCY_LEVEL_BOUNDS_OFF
    gServerSettings.bubbleDeath = false
    gServerSettings.enableCheats = false
    gServerSettings.enablePlayerList = false
    gServerSettings.enablePlayersInLevelDisplay = false
    gServerSettings.nametags = false
    gServerSettings.playerInteractions = PLAYER_INTERACTIONS_PVP
    gServerSettings.skipIntro = false
    gServerSettings.stayInLevelAfterStar = false

    -- Disable shellbox respawn and the like

    -- Disable exit anywhere

    -- Other stuff
    hideEmblems = false
    emblemFunc()

    camera_config_enable_analog_cam(false)
    camera_config_enable_free_cam(false)
end


local function on_classic_mode_command(msg)
    msg = string.lower(msg)
    if msg == "on" then
        djui_chat_message_create("Classic mode enabled.")
        classicMode = true
        other_classic_mode_shits()
        mod_storage_save_bool("classicMode", classicMode)
    elseif msg == "off" then
        djui_chat_message_create("Classic mode disabled.")
        classicMode = false
        other_classic_mode_shits()
        mod_storage_save_bool("classicMode", classicMode)
    elseif msg == "info" then
        local modeText = "disabled"
        if classicMode then
            modeText = "enabled"
        end
        djui_chat_message_create("Classic mode is " .. modeText .. ".")
    else
        djui_chat_message_create("Parameter must be ON, OFF, or info.")
    end
    return true
end

function other_classic_mode_shits()
    -- Force emblems on
    _G.hideEmblems = false
    gNetworkPlayers[0].overrideModelIndex = CT_MARIO
    gNetworkPlayers[0].overridePaletteIndex = PALETTE_MARIO
    emblemFunc()

    -- Make widescreen act like Jabo's plugin
    
    -- Force og cam
    camera_config_enable_analog_cam(false)
    camera_config_enable_free_cam(false)
end

local function on_level_init()
    if classicMode then
        gNetworkPlayers[0].overrideModelIndex = CT_MARIO
        gNetworkPlayers[0].overridePaletteIndex = PALETTE_MARIO
    end
end

-- Hooks

hook_chat_command("classic_mode", "- [on|off|info] Changes some settings to make the game more \"nostalgic\".",
    on_classic_mode_command)
hook_event(HOOK_ON_LEVEL_INIT, on_level_init)
-- Textures (names in bin folder, .c files)
--texture_override_set("outside_09001000", get_texture_info("empty")) -- test thing
