-- Classic mode
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
end


local function on_classic_mode_command(msg)
    msg = string.lower(msg)
    if msg == "on" then
       djui_chat_message_create("Classic mode enabled.")
       classicMode = true
       mod_storage_save_bool("classicMode", classicMode)
    elseif msg == "off" then
        djui_chat_message_create("Classic mode disabled.")
        classicMode = false
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

-- Hooks

hook_chat_command("classic_mode", "- [on|off|info] Changes some settings to make the game more \"nostalgic\".", on_classic_mode_command)