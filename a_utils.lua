USING_COOPDX = true

-- Recieves a value of any type and converts it into a boolean. (Taken from Flood)
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

-- Check if SM64Coop DX or not
if SM64COOPDX_VERSION == nil then
    djui_popup_create_global("This mod requires SM64Coop DX to work properly.", 2)
    play_sound(SOUND_MENU_CAMERA_BUZZ, gMarioStates[0].marioObj.header.gfx.cameraToObject)
    USING_COOPDX = false
end
