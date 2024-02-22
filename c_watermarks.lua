-- Vars
local hypercamWatermark = get_texture_info("hypercam_watermark")
local bandicamWatermark = get_texture_info("bandicam_watermark")

-- Usual mod storage stuff
if (mod_storage_load_number("firstRunDone") == 0) then
    mod_storage_save_number("firstRunDone", 1)
    mod_storage_save_number("watermarkType", 1)
end

local watermarkType = tonumber(mod_storage_load("watermarkType"))

-- Funcs

local function on_hud_render()
    djui_hud_set_resolution(RESOLUTION_DJUI)
    local width = djui_hud_get_screen_width()
    if gfx_get_adjust_for_aspect_ratio() then
        if watermarkType == 1 then
            djui_hud_render_texture(hypercamWatermark, 0, 0, 1, 1)
        elseif watermarkType == 2 then
            djui_hud_render_texture(bandicamWatermark, (width / 2) - 128, -4, 1, 1)
        end
    else
        if watermarkType == 1 then
            djui_hud_render_texture(hypercamWatermark, 0, 0, 1, 1)
        elseif watermarkType == 2 then
            djui_hud_render_texture(bandicamWatermark, (width / 2) - 128 * 3, -4, 1, 1)
        end
    end
end


local function on_watermark_command(msg)
    if msg == "0" then
        djui_chat_message_create("Watermark disabled.")
        watermarkType = 0
    elseif msg == "1" then
        djui_chat_message_create("Watermark set to \"Unregistered HyperCam 2\".")
        watermarkType = 1
    elseif msg == "2" then
        djui_chat_message_create("Watermark set to \"Bandicam\".")
        watermarkType = 2
    elseif msg == "info" then
        -- Watermark type is set to 0 (disabled), 1 (Hypercam), or 2 (Bandicam)."
        local watermarkName = "Disabled"
        if watermarkType == 1 then
            watermarkName = "Unregistered HyperCam 2"
        elseif watermarkType == 2 then
            watermarkName = "Bandicam"
        end
        djui_chat_message_create("Watermark type is set to " .. watermarkType .. " (" .. watermarkName .. ").")
    else
        djui_chat_message_create("Watermark type must be 0, 1, or 2.")
    end
    if watermarkType == nil then
        watermarkType = 1
        djui_chat_message_create("Watermark type was nil, setting to 1. Report to devs if seen.")
    end
    mod_storage_save_number("watermarkType", watermarkType)
    return true
end

-- Hooks

hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_chat_command("watermark", "- [0|1|2|info] 0 = disabled, 1 = Hypercam, 2 = Bandicam.", on_watermark_command)
