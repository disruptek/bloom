import std/random
import std/strformat
import std/intsets
import std/times

import balls
import bloom

when defined(js):
  const
    k = 6             ## layer count
    n = 16384         ## layer size
    x = 10_000        ## random entries
    y = 10_000_000    ## highest integer

else:
  const
    k = 20            ## layer count
    n = 65535         ## layer size
    x = 100_000       ## random entries
    y = 100_000_000   ## highest integer

suite "bloom":
  var filter: ref Bloom[k, n]
  var found: ref IntSet
  var count, unfound: int
  var needle: int

  test "setup some random data":
    count = 0
    randomize()
    filter = new (ref Bloom[k, n])
    found = new (ref IntSet)
    found[] = initIntSet()
    while count < x:
      let q = rand(y)
      if q notin found[]:
        found[].incl q
        inc count

  test "perform insertion on the filter":
    for q in found[]:
      filter[].add q

  test "save a needle":
    while true:
      needle = rand(y)
      if needle notin filter[]:
        if needle notin found[]:
          break

  test "stringification":
    checkpoint fmt"filter has {k} layers of {n} units; distribution:"
    checkpoint $filter[]
    checkpoint fmt"filter size: {filter.sizeof} bytes"

  test "calculate false positives":
    count = 0
    while unfound != x:
      let q = rand(y)
      if q notin found[]:
        inc unfound
        if q in filter[]:
          inc count
    checkpoint fmt"{count} false positives, or {100 * count / x:0.2f}%"
    check count.float < 0.02 * x

  test "calculate false negatives":
    count = 0
    for q in found[].items:
      if q notin filter[]:
        inc count
    checkpoint fmt"{count} false negatives, or {100 * count / x:0.2f}%"
    check count == 0

  test "check the speed":
    when defined(windows):
      skip"windows is slow"
    elif defined(js):
      skip"javascript couldn't be buggered"
    else:
      let clock = cpuTime()
      check needle notin found[]
      let lap = cpuTime()
      check needle notin filter[]
      let done = cpuTime()
      var (a, b) = (done - lap, lap - clock)
      var fast = "bloom"
      if a > b:
        swap(a, b)
        fast = "intset"
      checkpoint fmt"{fast} was {100 * (a / b):0.2f}% faster"
