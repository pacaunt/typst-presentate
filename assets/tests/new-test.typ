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
