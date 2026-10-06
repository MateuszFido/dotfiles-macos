return {
    {
        "esmuellert/codediff.nvim",
        cmd = "CodeDiff",
        keys = {
            { "<leader>gr", "<cmd>CodeDiff<cr>", desc = "Review changes (CodeDiff)" },
            { "<leader>gR", "<cmd>CodeDiff --staged<cr>", desc = "Review staged changes (CodeDiff)" },
        },
    },
    {
        "carderne/pi-nvim",
        main = "pi-nvim",
        cmd = { "Pi", "PiSend", "PiSendFile", "PiSendSelection", "PiSendBuffer", "PiPing", "PiSessions" },
        opts = { set_default_keymaps = false },
        keys = {
            { "<leader>pp", "<cmd>Pi<cr>", desc = "Ask Pi about this file" },
            -- A colon command preserves the visual range for the Pi dialog.
            { "<leader>pp", ":Pi<cr>", mode = "x", desc = "Ask Pi about selection" },
            { "<leader>ps", ":PiSendSelection<cr>", mode = "x", desc = "Send selection and question to Pi" },
            { "<leader>pf", "<cmd>PiSendFile<cr>", desc = "Send file and question to Pi" },
            { "<leader>pl", "<cmd>PiSessions<cr>", desc = "Choose Pi session" },
            { "<leader>pi", "<cmd>PiPing<cr>", desc = "Check Pi connection" },
        },
    },
    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                { "<leader>p", group = "Pi", mode = { "n", "x" } },
            },
        },
    },
}
