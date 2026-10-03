--  ╭─ AI ──────────────────────────────────────────────────────╮
--  │  Claude Code inside Neovim: a terminal split on the right  │
--  │  plus the IDE protocol, so selections, @-mentions and      │
--  │  proposed edits arrive as real nvim diffs.                 │
--  ╰───────────────────────────────────────────────────────────╯

return {
  {
    "coder/claudecode.nvim",
    -- `cmd` lets lazy.nvim create command stubs that load the plugin on first use,
    -- so `:ClaudeCode` and friends work on a fresh start (a keys-only spec defers
    -- loading until a <leader>a* mapping is pressed).
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
    keys = {
      { "<leader>ac", "<cmd>ClaudeCode<CR>",            desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<CR>",       desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<CR>",   desc = "Resume a session" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<CR>", desc = "Continue last session" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<CR>", desc = "Pick model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<CR>",       desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<CR>",        mode = "v", desc = "Send selection" },
      -- Same key inside the file tree sends whatever node is under the cursor.
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<CR>",
        ft = { "NvimTree" },
        desc = "Add file from tree",
      },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<CR>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<CR>",   desc = "Reject diff" },
      { "<leader>ai", "<cmd>ClaudeCodeStatus<CR>",     desc = "Connection status" },
    },
    opts = {
      -- Jump into the chat after sending, so you can type the follow-up straight away.
      focus_after_send = true,
      terminal = {
        -- Plain :terminal in a split. The snacks.nvim provider is nicer to look
        -- at but would pull in a whole plugin suite for one window.
        provider = "native",
        split_side = "right",
        split_width_percentage = 0.35,
        auto_close = true,
      },
      diff_opts = {
        layout = "vertical",
        open_in_new_tab = true,
        -- Leave the cursor in the chat; review with <leader>aa / <leader>ad.
        keep_terminal_focus = false,
      },
    },
  },
}
