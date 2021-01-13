version = "0.0.3"
author = "disruptek"
description = "bloom filters"
license = "MIT"

when not defined(release):
  requires "https://github.com/disruptek/testes >= 1.0.0 & < 2.0.0"

task test, "run unit tests":
  when defined(windows):
    exec "testes.cmd"
  else:
    exec "testes"
