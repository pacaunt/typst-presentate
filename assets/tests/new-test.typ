#import "../../src/export.typ": *

#set page(paper: "presentation-16-9")
#set heading(numbering: "1.1 ")
#set text(size: 25pt)

#let prior = state("prior")
= GREAT
#let dummy() = [
  #context prior.update(here())
  #let body = [== Hello]
  #for i in range(1, 10) [
    #if i > 1 {
      context {
        let loc = prior.get()
        let c = counter(heading)
        c.update(c.at(selector(loc)))
        body
      }
    } else {
      body
    }

  ]
]

#for i in range(4) [
  #dummy()
]

#repr($root(2, x)$)

#repr($sqrt(x)$.body)
#pagebreak()
#slide[
  #repr($binom(n, k, p, n)$)
  $ sqrt(x pause x) root(3, x) binom(n, k) $
]


#slide[
  = Jump Test
  #let jump = jump.with(hider: text.with(fill: gray))
  #jump(none) // To tell Presentate to use the set hider
  First #pause
  Second
]

#slide[
  = Change `hider` on the fly

  // Approach I: use `#jump()`
  #let grayed-mode = jump(none, hider: text.with(fill: gray.transparentize(50%)))
  // Approach II: use internal state changer
  #let grayed-mode = store.updater(s => {
    s.at(0).pause-state.hider = text.with(fill: gray.transparentize(50%))
    s
  })

  - First Point #pause
  - Second Point #grayed-mode // After this, it becomes gray.
    #pause
  - Third Point
]
