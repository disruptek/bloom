version = "0.0.3"
author = "disruptek"
description = "bloom filters"
license = "MIT"

when not defined(release):
  requires "https://github.com/disruptek/balls#rc"

task test, "run unit tests":
  when defined(windows):
    exec "balls.cmd"
  else:
    exec "balls"
