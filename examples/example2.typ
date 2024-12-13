#import "../export.typ": *

#let (presentate-slide,) = presentate-config()

#set text(size: 25pt)
#set page(paper: "presentation-16-9", numbering: "1", number-align: right)
#set heading(numbering: "1.1")

#presentate-slide(
  steps: 4,
  self => [
    = Hello Typst!
    #alter(self, 4, [
        This is the first slide in `presentate`

        #one-by-one(
          self,
          [
            You can see this time the heading has numbered!

          ],
          [
            By default, `page`, `equation` `figure`, `quote`, and `heading` counters are frozen.
          ],
          [
            By the way, you can change the layout by `alter` function
          ],
        )],
      it => align(horizon, it),
    )
  ],
)

#set math.equation(numbering: "(1)")

#let my-label(self, x) = if self.subslide == 1 {
  label(x)
}

#presentate-slide(
  steps: 5,
  self => [
    == `math.equation` example
    #my-label(self, "first")


    For example, the following equation:

    #one-by-one(
      self,
      [

        $ E = m c^2 $#my-label(self, "eq1")
        $ a^2 + b^2 = c^2 $#my-label(self, "eq2")
      ],
      [
        It is shown with the same number!
      ],
      [
        However, it is still not referencable.
        Typst will complain you about the labeled content occuring multiple times in the document.
      ],
      [
        So I hacked with `self.subslide`:

        @eq1 is from Eistein. \
        @eq2 is from Pythagoras.
      ],
    )
  ],
)

#presentate-slide(
  steps: 2,
  self => [
    == More equations
    #set align(horizon)

    $ K E = 1 / 2 m v^2 $
    #pause(
      self,
      self => [
        As mentioned in @first, the equation numbering is working!
      ],
    )
  ],
)