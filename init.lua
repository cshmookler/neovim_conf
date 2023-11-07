-- Set Neovim options.
require("options")()

-- Install required programs (if not already installed).
require("bootstrap")()

-- Install plugins (if not already installed).
require("plugin_list")()

-- Key mappings.
require("key_mappings")()
