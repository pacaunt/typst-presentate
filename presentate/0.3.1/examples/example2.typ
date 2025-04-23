#import "../export.typ": * 

#let (slide,) = presentate-config(freeze-counter: true)

#set page(paper: "presentation-16-9", numbering: "1")
#set text(size: 25pt, font: "Lato")

#set heading(numbering: "1.1.")
#show math.equation: set text(font: "Lete Sans Math")

#set math.equation(numbering: "(1)")

#slide(self => body([
  #outline()
], self))

#slide(self => body([
  = Some Maths 

  #set align(horizon)

  #show: pause.with(self) + self.push(0)
  Pythagorean Theorem
    #show: pause.with(self) + self.push(0)

    $ a^2 + b^2 = pause(self, c^2) #self.push(0) $

    #show: pause.with(self) + self.push(0)

    Where $c$ is bigger than $a$ and $b$.
], self))

  #import "@preview/cetz:0.3.2"
#slide(self => body([
  = Some figures

  In `CeTZ` we can hide:
  #figure(
    cetz.canvas(length: 2cm, {
      import cetz.draw: * 
      self.at(0).cover = hide.with(bounds: true)
      pause(self, {
        circle((), fill: red)
      })
      self.push(0)
      pause(self, {
        circle((rel: (1, 0)), fill: blue)
      })
      self.push(0)
      pause(self, {
        circle((rel: (1, 0)), fill: green)
      })
      self.push(0)
    })
  )

  #only(self, 2)[Is that cool?]
], self))

#import "@preview/mannot:0.2.1": *

#slide(self => body([
  = Hey `mannot`


  $ 
    alter(self ,#2, E, mark.with(tag:#<energy>)) = 
    alter(self, #3, m, mark.with(tag:#<mass>)) 
    alter(self, #4, c^2, mark.with(tag:#<speed>))
  $

  #only(self, 2)[#annot(<energy>)[This is energy]]
  #self.push(2)
  #only(self, 3)[#annot(<mass>)[This is mass]]
  #self.push(3)
  #only(self, 4)[#annot(<mass>)[Speed of Light]]
  #self.push(4)

  #show: pause.with(self, delay: 3)
  #self.push((0,) * 4)
  This is an equation from Eistein.

], self))

#import "@preview/pinit:0.2.2": *

#slide(self => body([
  = `pinit` is here! 
  $ #pin(1)a^2#pin(2) + #pin(3)b^2#pin(4) = #pin(5)c^2#pin(6) $

  #only(self, 2)[
    #pinit-highlight(1, 2)
    #pinit-highlight(3, 4)
  ]
    
  #self.push(2)

  $a$ and $b$ are some constant. 
  #show: pause.with(self, delay: 1) + self.push((0, 0))
  While $c$  is the hypotenuse.

  #pause(self)[It is verbose. But it is very fast and powerful.] #self.push(0)
], self))
