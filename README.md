# duqtalk.nvim

Chat through DuckDuckGo AI inside Neovim.

## Prerequisites

* [duqtalk](https://github.com/pawemix/duqtalk) utility installed and available
  in `PATH`

## Installation

With `lazy.nvim`:

```lua
{
    "pawemix/duqtalk.nvim",
    keys = {
        { "<leader>da", function() require("duqtalk").interact() end },
    },
}
```

## Usage

When in Normal mode, hit `<leader>da` (or any other keymap that you've configured for `interact()`) to **send the current line as a query to DuckDuckGo AI Chat**. Once retrieved, the response will be appended right under that line.


