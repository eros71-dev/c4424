-- If mario's health is less than it just was, play sound
local mamaSound = audio_stream_load("mama.mp3")
local mamaSoundChance = 15

-- Classic mode

-- user settings
local prefersFreeCam = camera_config_is_free_cam_enabled()
local prefersAnalogCam = camera_config_is_analog_cam_enabled()
local preferredCharType = gNetworkPlayers[0].overrideModelIndex

-- Usual mod storage stuff
if (mod_storage_load_number("firstRunDone") == 0) then
    mod_storage_save_number("firstRunDone", 1)
    mod_storage_save_bool("classicMode", true)
end

classicMode = tobool(mod_storage_load("classicMode"))
emptyTexture = get_texture_info("empty")

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
    shadowFunc()

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
    if classicMode then
        -- Force emblems on
        _G.hideEmblems = false
        _G.hideShadows = true
        gNetworkPlayers[0].overrideModelIndex = CT_MARIO
        gNetworkPlayers[0].overridePaletteIndex = PALETTE_MARIO
        emblemFunc()
        shadowFunc()

        -- Make widescreen act like Jabo's plugin, force 30fps (or less), and other settings

        -- Force og cam
        camera_config_enable_analog_cam(false)
        camera_config_enable_free_cam(false)

        -- Set window name to "SUPER MARIO 64 - Project64 Version 1.6" and change icon to PJ64's

    else
        -- Reset stuff
        _G.hideEmblems = tobool(mod_storage_load("hideEmblems"))
        _G.hideShadows = tobool(mod_storage_load("hideShadows"))
        gNetworkPlayers[0].overrideModelIndex = preferredCharType
        gNetworkPlayers[0].overridePaletteIndex = 255
        emblemFunc()
        shadowFunc()
        
        -- Reset widescreen, fps, and other settings

        -- Reset cam
        camera_config_enable_analog_cam(prefersAnalogCam)
        camera_config_enable_free_cam(prefersFreeCam)

        -- Reset window name and icon

    end
end

local function on_level_init()
    if classicMode then
        gNetworkPlayers[0].overrideModelIndex = CT_MARIO
        gNetworkPlayers[0].overridePaletteIndex = PALETTE_MARIO
    end
end

---@param m MarioState
local function mario_update_local(m)
    if classicMode and  math.random(1, 100) == mamaSoundChance then
        if m.hurtCounter > 0 then
            audio_stream_play(mamaSound, false, 0.5)
        end
    end
end

-- Hooks

hook_chat_command("classic_mode", "- [on|off|info] Changes some settings to make the game more \"nostalgic\".",
    on_classic_mode_command)
hook_event(HOOK_ON_LEVEL_INIT, on_level_init)

---@param m MarioState
hook_event(HOOK_MARIO_UPDATE, mario_update_local)