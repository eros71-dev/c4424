-- name: C4424
-- description: idk yet

--[[

Possible features:

    Agent X
unregistered hypercam
G_TF_BILERP (texture filtered) HUD
stretched viewport? ("widescreen")
shadow textures that are just completely empty
pitched up sounds

    Citra
missing textures
fucked up vertices

    eros71
broken animations
(bandicam variant for watermark?)
z-fighting

    SonicDark
texture corruption / bleeding
no M / emblems sometimes
]]--

local watermarkType = 1
local hypercamWatermark = get_texture_info("hypercam_watermark")
local bandicamWatermark = get_texture_info("bandicam_watermark")

-- HUD / UI
local function on_hud_render()
    djui_hud_set_resolution(RESOLUTION_DJUI)
    local width = djui_hud_get_screen_width()
    local height = djui_hud_get_screen_height()
    if watermarkType == 1 then
        djui_hud_render_texture(hypercamWatermark, 0, 0, 1, 1)
    elseif watermarkType == 2 then
        djui_hud_render_texture(bandicamWatermark, (width/2)-128, -4, 1, 1)
    end
end


local function on_watermark_command(msg)
    if msg == "0" then
       djui_chat_message_create("Watermark disabled.")
       watermarkType = 0
       return true
    elseif msg == "1" then
       djui_chat_message_create("Watermark set to \"Unregistered HyperCam 2\".")
       watermarkType = 1
       return true
    elseif msg == "2" then
        djui_chat_message_create("Watermark set to \"Bandicam\".")
        watermarkType = 2
        return true
    elseif msg == "" then
        djui_chat_message_create("[0|1|2] 0 = disabled, 1 = Hypercam, 2 = Bandicam.")
        return true
    else
        djui_chat_message_create("Watermark type must be 0, 1, or 2.")
        return true
    end
    return false
 end

hook_event(HOOK_ON_HUD_RENDER, on_hud_render)
hook_chat_command("watermark", "[0|1|2] 0 = disabled, 1 = Hypercam, 2 = Bandicam.", on_watermark_command)