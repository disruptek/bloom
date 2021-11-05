version = "0.0.3"
author = "disruptek"
description = "bloom filters"
license = "MIT"

when not defined(release):
  requires "https://github.com/disruptek/balls >= 3.0.0 & < 4.0.0"

task test, "run unit tests":
  when defined(windows):
    exec "balls.cmd"
  else:
    exec "balls"
