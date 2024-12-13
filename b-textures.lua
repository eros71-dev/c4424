local sEmblemTextures = {
    { name = "mario_texture_m_blend",               texture = TEX_WHITE },
    { name = "mario_texture_m_cap",                 texture = TEX_WHITE },
    { name = "mario_texture_m_logo",                texture = TEX_EMPTY },
    { name = "luigi_texture_l_cap",                 texture = TEX_WHITE },
    { name = "toad_player_texture_spots",           texture = TEX_WHITE },
    { name = "toad_player_texture_cap",             texture = TEX_WHITE },
    { name = "waluigi_custom_waluigi_cap_rgba16",   texture = TEX_WHITE },
    { name = "waluigi_custom_waluigi_glove_rgba16", texture = TEX_WHITE },
    { name = "wario_texture_w_logo",                texture = TEX_WHITE }
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
    if c4424HideEmblems and c4424Enabled then
        for _, v in ipairs(sEmblemTextures) do
            texture_override_set(v.name, v.texture)
        end
    else
        for _, v in ipairs(sEmblemTextures) do
            texture_override_reset(v.name)
        end
    end
end

function override_shadows()
    if c4424HideShadows and c4424Enabled then
        for i = 1, #sShadowTextures do
            texture_override_set(sShadowTextures[i], TEX_EMPTY)
        end
    else
        for i = 1, #sShadowTextures do
            texture_override_reset(sShadowTextures[i])
        end
    end
end