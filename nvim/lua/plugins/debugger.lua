return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {
          virt_text_pos = "inline",
          all_references = true,
          only_first_definition = false,
          highlight_changed_variables = true,
          clear_on_continue = true,
        },
      },
    },
  },
}
