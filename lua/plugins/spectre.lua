return {
  "nvim-pack/nvim-spectre",
  config = function()
    -- alt + ss
    vim.keymap.set("n", "<leader>ßß", '<cmd>lua require("spectre").toggle()<CR>', {
      desc = "Toggle Spectre",
    })
    -- alt + sw
    vim.keymap.set("n", "<leader>ßΩ", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
      desc = "Search current word",
    })
    -- alt + dd
    vim.keymap.set("n", "<leader>∂∂", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
      desc = "Search on current file",
    })
  end,
}
