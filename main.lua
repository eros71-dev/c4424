emblems = {"luigi_texture_l_cap", "mario_texture_m_cap", "mario_texture_m_logo", "mario_texture_m_blend", "toad_player_texture_spots", "toad_player_texture_cap"}
emblemswl = {"waluigi_custom_waluigi_cap_rgba16", "waluigi_custom_waluigi_glove_rgba16", "wario_texture_w_logo"}

function no_emblems(msg)
    local no_emblems = get_texture_info("no_emblems")
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
    end
end

hook_chat_command('emblems', "[on|off] Disable the character emblems like in the old machinimas", no_emblems)