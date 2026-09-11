# vyShade

A lightweight color viewer for Neovim.
Type a hex color in any buffer and vyShade drops a virtual-text swatch right
next to it, tinted with the color you wrote.

```
const brand = "#ff6b35";  -- 󱓻 #ff6b35 <-- inline virtual text
```

## Features

- **Hex color swatches** — `#RRGGBB` (6-digit, case-insensitive) gets a
  virtual-text square rendered in its exact color
- **LSP color support** — colors reported by servers with `colorProvider` (e.g.
  CSS/HTML language servers) are highlighted too
- **Two render modes** — inline virtual-text swatch, or paint the color text
  itself with the color as background
- **Contrast-aware** — in `bg` mode the foreground flips to white or black based
  on luminance, so text stays readable
- **Performance-minded** — only visible lines are scanned, and insert mode
  re-scans just the current line
- **Self-cleaning** — swatches update in place as you edit; stale extmarks are
  removed when text changes

## Requirements

- Neovim **0.9+** (uses `nvim_buf_set_extmark`, `nvim_set_hl`, and inline
  virtual text)
- A **Nerd Font** in your terminal to render the default swatch icon — or set
  `virt_text` to any string you like (e.g. `"▉"`)

## Installation

### lazy.nvim

```lua
{
  "VyLowry7337/vyShade",
  lazy = false,          -- loads at startup so colors are highlighted everywhere
  opts = {},             -- or your config, see below
}
```

Or as a lazy-loaded plugin for a specific filetype:

```lua
{
  "VyLowry7337/vyShade",
  ft = { "css", "html", "javascript", "typescript", "lua", "python" },
  opts = {},
}
```

### vim packages (native `:packadd`)

Clone the repo into your `pack` directory and add it to your runtimepath:

```sh
git clone https://github.com/VyLowry7337/vyShade ~/.local/share/nvim/site/pack/vendor/start/vyShade
```

The `start/` directory auto-loads the plugin on startup — no extra config
needed.
If you prefer manual loading, clone into `pack/vendor/opt/vyShade` and add this
to your config:

```vim
packadd vyshade
lua require("VyShade").setup()
```

### vim-plug

```vim
Plug 'VyLowry7337/vyShade'
```

## Usage

vyShade is fully automatic.
Call `setup()` once and it runs:

```lua
require("VyShade").setup()
```

That's it.
Highlighting happens on buffer enter, text changes, scrolling, window resize,
and LSP attach — only for listed buffers.

## Configuration

`setup()` takes an optional table.
Everything below is the default:

```lua
require("VyShade").setup({
  mode = "virtual",            -- "virtual" | "bg"
  virt_text = "󱓻 ",           -- swatch string (virtual mode only)
  highlight = {
    hex = true,                -- highlight #RRGGBB hex codes
    lspvars = true,            -- highlight LSP documentColor values
  },
})
```

| Option | Type | Default | Description |
|---|---|---|---|
| `mode` | `string` | `"virtual"` | `"virtual"` renders an inline virtual-text swatch after each color. `"bg"` paints the color text itself with the color as its background (foreground auto-picks black/white for contrast). |
| `virt_text` | `string` | `"󱓻 "` | The string rendered as the swatch in `"virtual"` mode. Ignored in `"bg"` mode. |
| `highlight.hex` | `boolean` | `true` | Enable hex-code detection (`#RRGGBB`). |
| `highlight.lspvars` | `boolean` | `true` | Enable LSP `documentColor` highlighting for servers that support it. |

## How it works

vyShade scans visible lines for `#RRGGBB` patterns and registers each unique
color as a cached highlight group (`hex_ff0000`, `hex_00ff00`, …).
In `"virtual"` mode the swatch is an inline virtual-text extmark tinted with
that group; in `"bg"` mode the color span itself gets the group.

- Highlight groups are created with `default = true`, so colorschemes can
  override them
- Extmarks are de-duplicated — re-highlighting the same range replaces in place
  instead of stacking
- Only the visible window range is scanned (`w0`–`w$`), keeping it fast on large
  files
- LSP colors are fetched via `textDocument/documentColor` and
  alpha-premultiplied into the final hex

## License

MIT
