if vim.g.neovide then
    -- vim.o.guifont = "Maple Mono NF:h19:#e-subpixelantialias"     -- NF = Nerd Font glyphs
    vim.opt.linespace = 10
    -- vim.o.guifont = "Maple_Mono:h16:#e-subpixelantialias"     -- text below applies for VimScript
    vim.o.guifont = "Operator Mono Lig, Maple Mono NF:h20:#e-subpixelantialias"
    local blur = 0.45
    vim.g.neovide_opacity = blur
    vim.g.neovide_normal_opacity = blur
    -- vim.g.neovide_cursor_vfx_mode = "ripple"
    vim.g.neovide_window_blurred = true
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_remember_window_size = true
    vim.g.neovide_fullscreen = false
    -- vim.g.neovide_cursor_smooth_blink = true
    -- vim.g.neovide_profiler=true
    -- vim.g.neovide_cursor_animation_length = 0.07
    vim.g.neovide_floating_shadow = true
end
