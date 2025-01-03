#import "@preview/alchemist:0.1.2": *
#import "@preview/cetz:0.3.1": canvas, draw

#import "../export.typ": *

#let (presentate-slide,) = presentate-config()

#set page(paper: "presentation-16-9")
#set align(center)
#set text(size: 25pt)

#set math.equation(numbering: "(1)")
#set heading(numbering: "1.1.")

#presentate-slide(
  steps: 5,
  self => [

    = Heading

    == This is the second heading
    #pause(
      self,
      self => [
        $ a^2 $
      ],
    )

    #lorem(10)

    $ b^2 $

  ],
)


#presentate-slide(
  steps: 5,
  self => [

    = Heading Second

    == This is the second heading For Real
    $ a^2 $

    #lorem(10)

    $ b^2 $

  ],
)

#presentate-slide(
  steps: 5,
  self => [

    = Heading Second

    == This is the second heading For Real
    $ a^2 $

    #lorem(10)

    $ b^2 $

  ],
)

#presentate-slide(
  steps: 5,
  self => [

    = Heading Second

    == This is the second heading For Real
    $ a^2 $

    #lorem(10)

    $ b^2 $

  ],
)

#presentate-slide(
  steps: 5,
  self => [

    = Heading Second

    == This is the second heading For Real
    $ a^2 $

    #lorem(10)

    $ b^2 $

  ],
)

#presentate-slide(
  steps: 5,
  self => [

    = Heading Second

    == This is the second heading For Real
    $ a^2 $

    #lorem(10)

    $ b^2 $

  ],
)

#presentate-slide(
  steps: 5,
  self => [

    = Heading Second

    == This is the second heading For Real
    $ a^2 $

    #lorem(10)

    $ b^2 $

  ],
)








