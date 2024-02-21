-- name: C4424
-- description: idk yet
-- deluxe: true

--[[

Possible features, name indicates who suggested it, not who implemented it:

    Agent X
unregistered hypercam // DONE
G_TF_BILERP (texture filtered) HUD
stretched viewport? ("widescreen")
shadow textures that are just completely empty
pitched up sounds
low framerate (shown in video, so i'll leave it here in case he wants to add it)

    Citra
missing textures
fucked up vertices

    eros71
broken animations
(bandicam variant for watermark?) // DONE
z-fighting

    SonicDark
texture corruption / bleeding
no M / emblems sometimes



(If you want to credit yourself for the stuff you've added, you can do so below like this)
Dev:
Feature1
Feature2
    <empty line>

----------------

eros71:
Watermarks
Classic mode

SonicDark:
no emblems
(Next dev here)
]]--

if not USING_COOPDX then djui_popup_create_global("This mod requires SM64Coop DX to work properly.", 2) end
-- afaik things like lua texture swapping require it, not sure if this line has to be in each lua file or just main -eros71


local function on_reset_mod_save_command()
    mod_storage_remove("firstRunDone")
    djui_popup_create("You may need to rehost in order to see the changes.", 2)
    return true
end

hook_chat_command("reset_c4424_data", "- This command will ERASE ALL c4424 data! Use with caution.",
    on_reset_mod_save_command)
