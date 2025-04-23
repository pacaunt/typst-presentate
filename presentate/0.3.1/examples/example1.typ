#import "../export.typ": *

#let (slide,) = presentate-config()

#set page(paper: "presentation-16-9",)
#set text(size: 25pt, font: "Lato")

#slide(self => body([
  #set align(center + horizon)
  #set text(size: 2em, weight: "bold")

  Welcome!

], self))

#slide(self => body([
  = A Simple Animation

  #set align(horizon)

  #show: pause.with(self) + self.push(0)

  Hello, Presentate 

  #pause(self)[Hello, Typst!] #self.push(0)


], self))


