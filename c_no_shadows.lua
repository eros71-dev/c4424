-- This script disables the shadows like in some crappy emulators

-- Usual mod storage stuff
if (mod_storage_load_number("firstRunDone") == 0) then
    mod_storage_save_bool("hideShadows", false)
end

_G.hideShadows = tobool(mod_storage_load("hideShadows"))

local function on_no_shadows_command(msg)
    msg = string.lower(msg)
    if msg == "on" then
        djui_chat_message_create("Shadows shown.")
        _G.hideShadows = false
        shadowFunc()
        mod_storage_save_bool("hideShadows", _G.hideShadows)
    elseif msg == "off" then
        djui_chat_message_create("Shadows hidden.")
        _G.hideShadows = true
        shadowFunc()
        mod_storage_save_bool("hideShadows", _G.hideShadows)
    elseif msg == "info" then
        local modeText = "shown"
        if _G.hideShadows then
            modeText = "hidden"
        end
        djui_chat_message_create("Shadows are " .. modeText .. ".")
    else
        djui_chat_message_create("Parameter must be ON, OFF, or info.")
    end
    return true
end

function shadowFunc()
    if _G.hideShadows then
        texture_override_set("texture_shadow_quarter_circle", emptyTexture)
        texture_override_set("texture_shadow_quarter_square", emptyTexture)
        texture_override_set("texture_shadow_spike_ext", emptyTexture)
    else
        texture_override_reset("texture_shadow_quarter_circle")
        texture_override_reset("texture_shadow_quarter_square")
        texture_override_reset("texture_shadow_spike_ext")
    end
end

local function on_level_init()
    shadowFunc()
end

hook_chat_command('shadows', "- [on|off] Disable some shadows", on_no_shadows_command)
hook_event(HOOK_ON_LEVEL_INIT, on_level_init)
