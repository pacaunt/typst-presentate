#import "@local/presentate:0.2.3": *
#import "@preview/layout-ltd:0.1.0": layout-limiter
#show: layout-limiter.with(max-iterations: 3)

#set page(paper: "presentation-16-9")
#set text(size: 25pt)

#slide[
  = Content in Sync
  #table(columns: (1fr, 1fr), stroke: 1pt)[
    First

    #show: pause;
    I am

    #show: pause;

    in sync.
  ][
    // `[]` is a dummy content.
    #uncover(1, [], update-pause: true)
    Second

    #show: pause;
    I am

    #show: pause;

    in sync.

    #show: pause
    Heheh
  ]
]

#slide[
  #step-item[
    - A
      #step-item[
        - H 
        - I 
        - J
      ]
    - B
    - C
  ]
]

#slide[
  A 
  #show: pause.with(update: false)
  B
  #show: pause 
  C 
]