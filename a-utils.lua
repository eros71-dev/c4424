-- API stuff for addons
_G.c4424 = {}

if SM64COOPDX_VERSION == nil then
    local first = false
    hook_event(HOOK_ON_LEVEL_INIT, function()
        if not first then
            first = true
            play_sound(SOUND_MENU_CAMERA_BUZZ, gMarioStates[0].marioObj.header.gfx.cameraToObject)
            djui_chat_message_create(
                "\\#ff7f7f\\C4424 is not supported with sm64ex-coop\nas it uses sm64coopdx exclusive Lua functionality.\n\\#dcdcdc\\To play this mod, try out sm64coopdx at\n\\#7f7fff\\https://sm64coopdx.com")
        end
    end)
    return
end

--- Recieves a value of any type and converts it into a boolean. (Taken from Flood)
function tobool(v)
    local type = type(v)
    if type == "boolean" then
        return v
    elseif type == "number" then
        return v == 1
    elseif type == "string" then
        return v == "true"
    elseif type == "table" or type == "function" or type == "thread" or type == "userdata" then
        return true
    end
    return false
end

--- @param value boolean
--- Returns an ON or OFF string depending on the boolean value
function on_or_off(value)
    if value then return "\\#ff0000\\OFF" end
    return "\\#00ff00\\ON"
end

--- @param value boolean
--- Returns an ON or OFF string depending on the boolean value
function on_or_off_inverted(value)
    if value then return "\\#00ff00\\ON" end
    return "\\#ff0000\\OFF"
end

--- @param value boolean
--- Returns a string depending on the boolean value
function on_or_off_string(value, stringOn, stringOff)
    if value then return "\\#00ff00\\" .. stringOn end
    return "\\#ff0000\\" .. stringOff
end

--- @param cond boolean
--- Human readable ternary operator
function if_then_else(cond, ifTrue, ifFalse)
    if cond then return ifTrue end
    return ifFalse
end

--- @param m MarioState
--- Checks if the player is active
function active_player(m)
    local np = gNetworkPlayers[m.playerIndex]
    if m.playerIndex == 0 then
        return true
    end
    if not np.connected then
        return false
    end
    if np.currCourseNum ~= gNetworkPlayers[0].currCourseNum then
        return false
    end
    if np.currActNum ~= gNetworkPlayers[0].currActNum then
        return false
    end
    if np.currLevelNum ~= gNetworkPlayers[0].currLevelNum then
        return false
    end
    if np.currAreaIndex ~= gNetworkPlayers[0].currAreaIndex then
        return false
    end
    return true
end

--- @param s string
--- Splits a string between every space
function split(s)
    local result = {}
    for match in (s):gmatch(string.format("[^%s]+", " ")) do
        table.insert(result, match)
    end
    return result
end

--- @param param number
--- @param caseTable table
--- Switch statement function
function switch(param, caseTable)
    local case = caseTable[param]
    if case then return case() end
    local def = caseTable['default']
    return def and def() or nil
end

function debug_print_vars()
    djui_chat_message_create("c4424Enabled: " .. tostring(c4424Enabled) .. "\n" ..
        "hideEmblems: " .. tostring(hideEmblems) .. "\n" ..
        "hideShadows: " .. tostring(hideShadows) .. "\n" ..
        "playMusic: " .. tostring(playMusic) .. "\n" ..
        "watermarkValue: " .. tostring(watermarkValue) .. "\n" ..
        "forceMario: " .. tostring(forceMario)
    )
end

-- Mod storage save function
function save_mod_storage()
    mod_storage_save_bool("c4424Enabled", c4424Enabled)
    mod_storage_save_bool("hideEmblems", hideEmblems)
    mod_storage_save_bool("hideShadows", hideShadows)
    mod_storage_save_bool("playMusic", playMusic)
    mod_storage_save_number("watermarkValue", watermarkValue)
    mod_storage_save_bool("forceMario", forceMario)

    --debug_print_vars()
end

-- Mod storage load function
function load_mod_storage()
    c4424Enabled = mod_storage_load_bool("c4424Enabled")
    hideEmblems = mod_storage_load_bool("hideEmblems")
    hideShadows = mod_storage_load_bool("hideShadows")
    playMusic = mod_storage_load_bool("playMusic")
    watermarkValue = mod_storage_load_number("watermarkValue")
    forceMario = mod_storage_load_bool("forceMario")

    --debug_print_vars()

    override_emblems()
    override_shadows()

    if c4424Enabled then
        set_window_title("SUPER MARIO 64 - Project 64 Version 1.6")
    end
end

-- In loving memory of the stretched widescreen and high pitch options, so long, king.