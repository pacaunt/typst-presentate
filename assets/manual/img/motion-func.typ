#import "../../../src/export.typ": *
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example
#slide[
  = Arrhenius Equation
  #motion(
    s => [
      #let tag = tag.with(s) // a shorthand
      $ k = tag("A", A) exp(-tag("Ea", E_a)/(R T)) $
    ],
    controls: (
      ("A.start", "Ea.start", "exp.start"),
      ("A", it => $underbrace(it, "Preexponential\nFactor")$),
      ("Ea", it => $overbrace(it, "Activation Energy")$),
    ),
  )
]