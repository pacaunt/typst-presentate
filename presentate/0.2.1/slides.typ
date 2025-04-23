#import "presentate.typ": presentate-slide

#let plain-slide(..args) = {
  set page(margin: none)
  presentate-slide(..args)
}

#let centered-slide(..args) = {
  set align(center + horizon)
  presentate-slide(..args)
}