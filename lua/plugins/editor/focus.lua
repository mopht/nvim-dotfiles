-- local code_runner_opts = {
--     filetype = {
--         java = {
--             "cd $dir ;",
--             "javac $fileName ;",
--             "java $fileNameWithoutExt",
--         },
--         python = "python3 -u",
--         typescript = "deno run",
--         rust = {
--             "cd $dir ;",
--             "rustc $fileName ;",
--             "$dir/$fileNameWithoutExt",
--         },
--         -- c = function()
--         --     local c_base = {
--         --         "cd $dir ;",
--         --         "gcc $fileName -o",
--         --         "/tmp/$fileNameWithoutExt",
--         --     }
--         --     local c_exec = {
--         --         "; /tmp/$fileNameWithoutExt ;",
--         --         "rm /tmp/$fileNameWithoutExt",
--         --     }
--         --     vim.ui.input({ prompt = "Add more args:" }, function(input)
--         --         c_base[4] = input
--         --         vim.print(vim.tbl_extend("force", c_base, c_exec))
--         --         require("code_runner.commands").run_from_fn(vim.list_extend(c_base, c_exec))
--         --     end)
--         -- end,
--         cpp = {
--             "cd $dir ;",
--             "clang++ -std=c++26 -stdlib=libc++ $fileName -o",
--             "$dir/$fileNameWithoutExt.out ;",
--             "$dir/$fileNameWithoutExt.out",
--         },
--     },
-- }

return {
    { name = "guess-indent.nvim", src = "NMAC427/guess-indent.nvim", pack = "opt", cmd = { "GuessIndent" },
    config = function() require("guess-indent").setup({}) end },
    { name = "twilight.nvim", src = "folke/twilight.nvim", pack = "opt", cmd = { "Twilight", "TwilightEnable", "TwilightDisable" },
    config = function() require("twilight").setup({}) end },
    { name = "zen-mode.nvim", src = "folke/zen-mode.nvim", pack = "opt", cmd = { "ZenMode" },
    config = function() require("zen-mode").setup({}) end },
    -- { name = "code_runner.nvim", src = "CRAG666/code_runner.nvim", pack = "opt", cmd = { "RunCode" },
    -- config = function() require("code_runner").setup(code_runner_opts) end },
}
