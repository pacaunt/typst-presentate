#import "./presentate.typ": presentate_slide 

#let plainSlide(..args) = {
  set page(footer: none, header: none)
  presentate_slide(..args)
}

#let rawSlide(..args) = {
  set page(footer: none, header: none, margin: 0pt)
  presentate_slide(..args)
}
