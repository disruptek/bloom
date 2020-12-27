version = "0.0.1"
author = "disruptek"
description = "bloom filters"
license = "MIT"

requires "https://github.com/disruptek/testes >= 0.7.1 & < 1.0.0"

task test, "run unit tests":
  when defined(windows):
    exec "testes.cmd"
  else:
    exec "testes"
