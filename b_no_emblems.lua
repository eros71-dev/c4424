-- This script disables the character emblems like in the old machinimas

-- Usual mod storage stuff
if (mod_storage_load_number("firstRunDone") == 0) then
    mod_storage_save_bool("hideEmblems", false)
end

_G.hideEmblems = tobool(mod_storage_load("hideEmblems"))

emblems = {"luigi_texture_l_cap", "mario_texture_m_cap", "mario_texture_m_logo", "mario_texture_m_blend", "toad_player_texture_spots", "toad_player_texture_cap"}
emblemswl = {"waluigi_custom_waluigi_cap_rgba16", "waluigi_custom_waluigi_glove_rgba16", "wario_texture_w_logo"}

local function on_no_emblems_command(msg)
    msg = string.lower(msg)
    if msg == "on" then
        djui_chat_message_create("Emblems shown.")
        _G.hideEmblems = false
        emblemFunc()
        mod_storage_save_bool("hideEmblems", _G.hideEmblems)
    elseif msg == "off" then
        djui_chat_message_create("Emblems hidden.")
        _G.hideEmblems = true
        emblemFunc()
        mod_storage_save_bool("hideEmblems", _G.hideEmblems)
    elseif msg == "info" then
        local modeText = "shown"
        if _G.hideEmblems then
            modeText = "hidden"
        end
        djui_chat_message_create("Emblems are " .. modeText .. ".")
    else
        djui_chat_message_create("Parameter must be ON, OFF, or info.")
    end
    return true
end

function emblemFunc()
    if _G.hideEmblems then
        for i = 1, #emblems do
            texture_override_set(emblems[i], get_texture_info("no_emblems"))
        end
        for i = 1, #emblemswl do
            texture_override_set(emblemswl[i], get_texture_info("no_emblemswl"))
        end
    else
        for i = 1, #emblems do
            texture_override_reset(emblems[i])
        end
        for i = 1, #emblemswl do
            texture_override_reset(emblemswl[i])
        end
    end
end

local function on_level_init()
    emblemFunc()
end

--[[local no_emblems = get_texture_info("no_emblems")
    local no_emblemswl = get_texture_info("no_emblemswl")
    for i = 1, #emblems do
        if msg == "off" then
            texture_override_set(emblems[i], no_emblems)
        elseif msg == "on" then
            texture_override_reset(emblems[i])
        end
    end
    for i = 1, #emblemswl do
        if msg == "off" then
            texture_override_set(emblemswl[i], no_emblemswl)
        elseif msg == "on" then
            texture_override_reset(emblemswl[i])
        end
    end]]--


hook_chat_command('emblems', "- [on|off] Disable the character emblems like in the old machinimas", on_no_emblems_command)
hook_event(HOOK_ON_LEVEL_INIT, on_level_init)