local sEmblemTextures = {
    "mario_texture_m_cap",
    "mario_texture_m_logo",
    "luigi_texture_l_cap",
    "toad_player_texture_spots",
    "toad_player_texture_cap",
    "waluigi_custom_waluigi_cap_rgba16",
    "waluigi_custom_waluigi_glove_rgba16",
    "wario_texture_w_logo"
}

local sShadowTextures = {
    "texture_shadow_quarter_circle",
    "texture_shadow_quarter_square",
    "texture_shadow_spike_ext",
    "outside_0900BC00",
    "generic_0900B000",
    "grass_0900B000"
}

function override_emblems()
    if hideEmblems and c4424Enabled then
        for i = 1, #sEmblemTextures do
            -- Wario and Waluigi haven't been updated yet
            texture_override_set(sEmblemTextures[i], if_then_else(sEmblemTextures[i]:find("waluigi") or sEmblemTextures[i]:find("wario"), TEX_EMPTY, TEX_WHITE))
        end
    else
        for i = 1, #sEmblemTextures do
            texture_override_reset(sEmblemTextures[i])
        end
    end
end
override_emblems()

function override_shadows()
    if hideShadows and c4424Enabled then
        for i = 1, #sShadowTextures do
            texture_override_set(sShadowTextures[i], TEX_EMPTY)
        end
    else
        for i = 1, #sShadowTextures do
            texture_override_reset(sShadowTextures[i])
        end
    end
end
override_shadows()