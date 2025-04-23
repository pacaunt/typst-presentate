#import "presentate.typ": slide

#let plain-slide(..args) = {
  set page(margin: 0pt)
  slide(..args)
}

#let centered-slide(..args) = {
  set align(center + horizon)
  slide(..args)
}