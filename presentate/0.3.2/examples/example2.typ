#import "../export.typ": * 
#let (slide, title-slide, focus-slide, plain-slide) = presentate-config(freeze-counter: true, theme: themes.simple)

#set page(paper: "presentation-16-9")
#set text(size: 25pt, font: "Lato")

#set heading(numbering: "1.1.")
#show math.equation: set text(font: "Lete Sans Math")
#show heading.where(level: 1): it => {
  focus-slide(s => (it, s))
}

#set math.equation(numbering: "(1)")
= Hello Gradar
#slide(wrapper: {
  (self, body) => {
    set page(fill: luma(20))
    set text(fill: white)
    set align(center + horizon)
    body
  }
}, s => ([
 #progress(s, hider: it => none, left-on-slide: false,
  [Howdy!], 
  [This is Tan], 
  [Nice to Meet You!], 
  [Ya]

 )
 #s.push(4)
 #show: pause.with(s) + s.push(1)
 This 
], s))

#slide(title: "Hello", s => ([
  Gradar is a girl who lives in london.
], s))