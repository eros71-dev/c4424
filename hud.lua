local SCREEN_WIDTH = 320
local SCREEN_HEIGHT = 240

local HUD_TOP_Y = 209

local function gfx_dimensions_rect_from_left_edge(v)
    return v
end

local function gfx_dimensions_rect_from_right_edge(v)
    return djui_hud_get_screen_width() - v
end

local function gfx_dimensions_rect_from_top_edge(v)
    return SCREEN_HEIGHT - v - 16
end

--- @param x integer
--- @param y integer
--- @param str string
local function print_text(x, y, str)
    djui_hud_print_text(str, x, gfx_dimensions_rect_from_top_edge(y), 1)
end

--- @param x integer
--- @param y integer
--- @param str string
--- @param n integer
local function print_text_fmt_int(x, y, str, n)
    str = string.format(str, n)
    str = str:gsub("-", "M")
    print_text(x, y, str)
end

local function render_hud_mario_lives()
    djui_hud_render_texture(gMarioStates[0].character.hudHeadTexture, gfx_dimensions_rect_from_left_edge(22), gfx_dimensions_rect_from_top_edge(HUD_TOP_Y), 1, 1)
    print_text(gfx_dimensions_rect_from_left_edge(38), HUD_TOP_Y, "@") -- 'X' glyph
    print_text_fmt_int(gfx_dimensions_rect_from_left_edge(54), HUD_TOP_Y, "%d", hud_get_value(HUD_DISPLAY_LIVES))
end

local function render_hud_coins()
    print_text(168, HUD_TOP_Y, "$") -- 'Coin' glyph
    print_text(184, HUD_TOP_Y, "@") -- 'X' glyph
    print_text_fmt_int(198, HUD_TOP_Y, "%d", hud_get_value(HUD_DISPLAY_COINS))
end

local function render_hud_camera_status()
    local x = gfx_dimensions_rect_from_right_edge(54)
    local y = 205
    local cameraHudStatus = hud_get_value(HUD_DISPLAY_CAMERA_STATUS)

    if cameraHudStatus == CAM_STATUS_NONE then return end

    djui_hud_render_texture(gTextures.camera, x, y, 1, 1)

    switch(cameraHudStatus & CAM_STATUS_MODE_GROUP, {
        [CAM_STATUS_MARIO] = function()
            djui_hud_render_texture(gMarioStates[0].character.hudHeadTexture, x + 16, y, 1, 1)
        end,
        [CAM_STATUS_LAKITU] = function()
            djui_hud_render_texture(gTextures.lakitu, x + 16, y, 1, 1)
        end,
        [CAM_STATUS_FIXED] = function()
            djui_hud_render_texture(gTextures.no_camera, x + 16, y, 1, 1)
        end
    })

    switch(cameraHudStatus & CAM_STATUS_C_MODE_GROUP, {
        [CAM_STATUS_C_DOWN] = function()
            djui_hud_render_texture(gTextures.arrow_down, x + 4, y + 16, 1, 1)
        end,
        [CAM_STATUS_C_UP] = function()
            djui_hud_render_texture(gTextures.arrow_up, x + 4, y - 8, 1, 1)
        end
    })
end

local HUD_STARS_X = 78

local function render_hud_stars()
    local showX = 0
    local hudDisplayStars = hud_get_value(HUD_DISPLAY_STARS)

    -- prevent star count from flashing outside of castle
    if gNetworkPlayers[0].currCourseNum ~= COURSE_NONE then hud_set_flash(0) end

    if hud_get_flash() == 1 and get_global_timer() & 0x08 then
        return
    end

    if hudDisplayStars < 100 then
        showX = 1
    end

    print_text(gfx_dimensions_rect_from_right_edge(HUD_STARS_X), HUD_TOP_Y, "*") -- 'Star' glyph
    if showX == 1 then
        print_text(gfx_dimensions_rect_from_right_edge(HUD_STARS_X) + 16, HUD_TOP_Y, "@") -- 'X' glyph
    end
    print_text_fmt_int((showX * 14) + gfx_dimensions_rect_from_right_edge(HUD_STARS_X - 16),
                       HUD_TOP_Y, "%d", hud_get_value(HUD_DISPLAY_STARS))
end

local function render_hud_timer()
    local timerValFrames = hud_get_value(HUD_DISPLAY_TIMER)
    local timerMins = timerValFrames / (30 * 60)
    local timerSecs = (timerValFrames / 30) % 60
    local timerFracSecs = ((timerValFrames / 30) % 1) * 10

    print_text(gfx_dimensions_rect_from_right_edge(150), 185, "TIME")
    print_text_fmt_int(gfx_dimensions_rect_from_right_edge(91), 185, "%0d", math.floor(timerMins))
    print_text_fmt_int(gfx_dimensions_rect_from_right_edge(71), 185, "%02d", math.floor(timerSecs))
    print_text_fmt_int(gfx_dimensions_rect_from_right_edge(37), 185, "%d", math.floor(timerFracSecs))
    djui_hud_render_texture(gTextures.apostrophe, gfx_dimensions_rect_from_right_edge(81), 32, 1, 1)
    djui_hud_render_texture(gTextures.double_quote, gfx_dimensions_rect_from_right_edge(46), 32, 1, 1)
end

function render_vanilla_hud()
    if hud_is_hidden() or obj_get_first_with_behavior_id(id_bhvActSelector) ~= nil or gNetworkPlayers[0].currActNum == 99 then return end

    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_filter(FILTER_LINEAR)
    djui_hud_set_font(FONT_HUD)
    djui_hud_set_color(255, 255, 255, 255)
    hud_set_value(HUD_DISPLAY_FLAGS, HUD_DISPLAY_FLAGS_C4424)

    render_hud_mario_lives()
    if course_is_main_course(gNetworkPlayers[0].currCourseNum) then render_hud_coins() end
    render_hud_stars()
    render_hud_camera_status()
    if level_control_timer_running() ~= 0 then render_hud_timer() end
end