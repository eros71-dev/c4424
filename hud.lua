local TEX_HYPERCAM = get_texture_info("c4424_hypercam")
local TEX_BANDICAM = get_texture_info("c4424_bandicam")
local watermarkValue = 1

--- @param x integer
--- @param y integer
--- @param str string
local function print_text(x, y, str)
    djui_hud_print_text(str, x, y, 1)
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

local N64_WIDTH = 320
local N64_HEIGHT = 240
local crashAnim = -30
local function hud_render()
    -- Watermark
    --if not c4424Enabled then return end

    djui_hud_set_resolution(RESOLUTION_N64)
    local originalWidth = djui_hud_get_screen_width() + 1
    local boarderWidth = (originalWidth - N64_WIDTH)*0.5
    djui_hud_set_color(0, 0, 0, 255)
    djui_hud_render_rect(0, 0, boarderWidth, N64_HEIGHT)
    djui_hud_render_rect(originalWidth - boarderWidth, 0, boarderWidth, N64_HEIGHT)

    djui_hud_set_resolution(RESOLUTION_DJUI)
    djui_hud_set_color(255, 255, 255, 255)
    if watermarkValue == 0 then
        return
    elseif watermarkValue == 1 then
        djui_hud_render_texture(TEX_HYPERCAM, 0, 0, 1.5, 1.5)
    elseif watermarkValue == 2 then
        djui_hud_render_texture(TEX_BANDICAM, djui_hud_get_screen_width() * 0.5 - 128, 0, 1, 1)
    end

    -- Fake Not Responding Screen
    --[[
    crashAnim = crashAnim + 1
    djui_hud_set_color(255, 255, 255, 175*math.min(math.max(crashAnim/15, 0), 1))
    djui_hud_render_rect(0, 0, originalWidth, N64_HEIGHT)
    if crashAnim > 30 then
        set_window_title("SUPER MARIO 64 - Project 64 Version 1.6 (Not Responding)")
    end
    ]]
end

local function render_character_icon(x, y, scale) 
    if not _G.charSelectExists then
        djui_hud_render_texture(gMarioStates[0].character.hudHeadTexture, x, y, scale, scale)
    else
        _G.charSelect.character_render_life_icon(0, x, y, 1)
    end
end

local function hud_render_behind()
    djui_hud_set_resolution(RESOLUTION_N64)
    local originalWidth = djui_hud_get_screen_width()
    local leftEdge = (originalWidth - N64_WIDTH)*0.5
    local rightEdge = originalWidth - (originalWidth - N64_WIDTH)*0.5

    djui_hud_set_resolution(RESOLUTION_N64)
    djui_hud_set_filter(FILTER_LINEAR)
    djui_hud_set_font(FONT_HUD)
    djui_hud_set_color(255, 255, 255, 255)
    hud_hide()

    if obj_get_first_with_behavior_id(id_bhvActSelector) ~= nil or gNetworkPlayers[0].currActNum == 99 then return end

    -- Render Lives
    render_character_icon(leftEdge + 22, 15, 1)
    print_text(leftEdge + 38, 15, "@") -- 'X' glyph
    print_text_fmt_int(leftEdge + 54, 15, "%d", hud_get_value(HUD_DISPLAY_LIVES))

    -- Render Coins
    if course_is_main_course(gNetworkPlayers[0].currCourseNum) then
        print_text(leftEdge + 168, 15, "$") -- 'Coin' glyph
        print_text(leftEdge + 184, 15, "@") -- 'X' glyph
        print_text_fmt_int(leftEdge + 198, 15, "%d", hud_get_value(HUD_DISPLAY_COINS))
    end

    -- Render Stars
    local showX = 0
    local hudDisplayStars = hud_get_value(HUD_DISPLAY_STARS)
    -- prevent star count from flashing outside of castle
    if gNetworkPlayers[0].currCourseNum ~= COURSE_NONE then hud_set_flash(0) end

    if not (hud_get_flash() == 1 and get_global_timer() & 0x08) then
        if hudDisplayStars < 100 then
            showX = 1
        end
        print_text(rightEdge - 78, 15, "*") -- 'Star' glyph
        if showX == 1 then
            print_text(rightEdge - 62, 15, "@") -- 'X' glyph
        end
        print_text_fmt_int((showX * 14) + rightEdge - 62, 15, "%d", hud_get_value(HUD_DISPLAY_STARS))
    end

    -- Render Cam State
    local x = rightEdge - 54
    local y = 205
    local cameraHudStatus = hud_get_value(HUD_DISPLAY_CAMERA_STATUS)
    if cameraHudStatus == CAM_STATUS_NONE then return end
    djui_hud_render_texture(gTextures.camera, x, y, 1, 1)
    switch(cameraHudStatus & CAM_STATUS_MODE_GROUP, {
        [CAM_STATUS_MARIO] = function()
            render_character_icon(x + 16, y, 1)
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

    -- Render Timer
    if level_control_timer_running() ~= 0 then
        local timerValFrames = hud_get_value(HUD_DISPLAY_TIMER)
        local timerMins = math.floor(timerValFrames > 2100 and timerValFrames / (30 * 60) or 0)
        local timerSecs = math.floor(timerValFrames > 2100 and (timerValFrames / 30) % 60 or (timerValFrames / 30))
        local timerFracSecs = math.floor(((timerValFrames / 30) % 1) * 10)

        local text = "TIME"
        if timerMins == 0 and timerSecs == 69 then
            text = "NICE"
        elseif timerMins == 9 and timerSecs == 59 and timerFracSecs == 9 then
            text = "FUCK"
        end
        print_text(rightEdge - 150, 38, text)
        print_text_fmt_int(rightEdge - 91, 38, "%0d", timerMins)
        print_text_fmt_int(rightEdge - 71, 38, "%02d", timerSecs)
        print_text_fmt_int(rightEdge - 37, 38, "%d", timerFracSecs)
        djui_hud_render_texture(gTextures.apostrophe, rightEdge - 81, 32, 1, 1)
        djui_hud_render_texture(gTextures.double_quote, rightEdge - 46, 32, 1, 1)
    end
end

hook_event(HOOK_ON_HUD_RENDER, hud_render)
hook_event(HOOK_ON_HUD_RENDER_BEHIND, hud_render_behind)