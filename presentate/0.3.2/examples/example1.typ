#import "../export.typ": *

#let (slide,) = presentate-config(freeze-counter: true)

#set page(paper: "presentation-16-9",)
#set text(size: 25pt, font: "Lato")

#set heading(numbering: "1.1.")

#slide(logical-slide: false, self => ([
  #set align(center + horizon)
  #set text(size: 2em, weight: "bold")

  Welcome!

], self))

#slide(logical-slide: false, self => ([
  #outline()
], self))

#slide(self => ([
  = A Simple Animation

  #set align(horizon)

  #show: pause.with(self) + self.push(1)

  Hello, Presentate 

  #pause(self)[Hello, Typst!] #self.push(1)


], self))

#slide(self => ([
  = Uncover and Only Function

  #set align(horizon)

  #uncover(self, 1, 3, 4, from: 6)[
    #set text(fill: red)
    This can be seen only in subslides 1, 3, 4, and from 6.
  ]
  #self.push((6,))

  #show: pause.with(self) + self.push(1)
  Use `uncover` for reserving space, and `only` for not reserving space. 

  #only(self, 2, 5)[
    #set text(fill: blue)
    This is on subslide 2 and 5.
  ] 

  _This text is moveable because `only` does not reserve space!_


], self))

#let myslide(fn, title: none, ..args) = {
  slide(..args, preamble: (self, body) => [
    #heading(level: 1, title) 
    #set align(center + horizon)
    #body
  ], fn)
}

#myslide(title: "Custom Slide", self => ([
  #show: pause.with(self) + self.push(1)
  Now, it's work!
], self))

#let qns = counter("question")
#let qn(txt) = {
  [
    #qns.step()
    #alias-counter("question").step()
    #context { qns.get().map(str).at(0) };. #txt
  ]
}

#let (slide,) = presentate-config(freeze-counter: true, frozen-counters: ("question": (
  real: qns, 
  cover: alias-counter("question")
)))

#slide(self => ([
  = Custom Frozen Counters 
  #show: pause.with(self) + self.push(1)
  #qn[ First Question]

  #show: pause.with(self) + self.push(1)
  #qn[ Second Question]

], self))

#slide(self => ([
  = Cool Movement
  #transform(self, [A], 
    place.with(dx: 1cm, dy: 1cm), 
    place.with(dx: 2cm, dy: 2cm), 
    place.with(dx: 3cm, dy: 3cm)
  )
  #self.push(4)
  $ #transform(hider: it => none, self, $a times a$, it => it, it => $a^2$) + c $
  #self.push(4)
], self))

#slide(s => ([
  = Hello 
  Does it capable of doing its own style? May be jaaa
], s))


