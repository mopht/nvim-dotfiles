-- nvim-dap. Adapters and configurations come from the language plugins.
return {
    { "mfussenegger/nvim-dap", lazy = true,
    cmd = {
        "DapContinue",
        "DapNew",
        "DapToggleBreakpoint",
        "DapClearBreakpoints",
        "DapToggleRepl",
        "DapStepOver",
        "DapStepInto",
        "DapStepOut",
        "DapPause",
        "DapTerminate",
        "DapDisconnect",
        "DapRestartFrame",
        "DapEval",
        "DapSetLogLevel",
        "DapShowLog",
    } },
}
