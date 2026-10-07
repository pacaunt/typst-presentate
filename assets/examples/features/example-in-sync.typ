#import "../../../src/export.typ": *

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#slide[
  = Content in Sync
  #table(columns: (1fr, 1fr), stroke: 1pt)[
    First

    #pause
    I am

    #pause 

    in sync.
  ][ 
    // Use `meanwhile` to reset the pauses.
    #meanwhile
    Second

    #pause
    I am

    #pause 

    in sync.

    #pause 
    Heheh
  ]
]