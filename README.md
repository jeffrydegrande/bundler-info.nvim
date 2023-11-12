# Bundler-Info

This is a Neovim plugin written in Lua that displays available updates for your
Ruby gems through bundler right inside your Gemfile.

## Features

- Automatically checks for available gem updates when you open a Gemfile.

## Installation

Install with lazy:

```
{
    "jeffrydegrande/bundler-info.nvim",
    config = function()
        require("bundler-info").setup()
    end,
},
```

## Usage

Just open any Gemfile in Neovim, the plugin will automatically display any availabe updates.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License

[MIT](https://choosealicense.com/licenses/mit/)
