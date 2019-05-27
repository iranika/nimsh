# Package

version       = "0.1.0"
author        = "iranika"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["nimsh"]


# Dependencies

requires "nim >= 0.19.4"
requires "cligen >= 0.9.15"
