#import "../presentate.typ": *

#let (slide,) = presentate-config()

#let palette = (
  main: eastern,
  text: black,
  sub: gray,
)

#let default-info = (
  author: [AUTHOR],
  title: [TITLE],
  date: [DATETIME],
  institute: [INSTITUTE OF PRESENTATION],
  logo: align(
    horizon + center,
    circle(
      radius: 1cm,
      fill: eastern,
      text(fill: white)[LOGO],
    ),
  ),
  last-topic: () => query(selector(heading.where(level: 2).before(here()))).at(
    -1,
    default: box[],
  ),
  last-section: () => query(selector(heading.where(level: 1).before(here()))).at(
    -1,
    default: box[],
  ),
  freeze-counter: true,
  palette: palette,
  new-section-slide: true, 
)

#let title-slide(logical-slide: false, ..args) = {
  slide(
    ..args,
    logical-slide: logical-slide,
    preamble: (self, body) => [
      #set align(center + horizon)
      #set text(size: 2em, weight: "bold")

      #self.title
      #v(-0.5em)

      #set text(size: 0.4em, fill: gray)
      #self.author
    ],
    it => ([], it),
  )
}

#let simple-plain-slide(body-fn, ..args) = {
  slide(..args, body-fn)
}

#let simple-focus-slide(body-fn, logical-slide: false, ..args) = {
  slide(
    ..args,
    logical-slide: logical-slide,
    body-fn,
    wrapper: (self, body) => {
      set page(fill: self.palette.main)
      body
    },
    preamble: (self, body) => {
      set align(center + horizon)
      set text(fill: white, weight: "bold", size: 1.2em)
      body
    },
  )
}

#let simple-slide(body-fn, ..args, title: auto) = {
  slide(
    ..args,
    wrapper: (self, body) => [
      #set page(
        header: [
          #set text(size: 0.6em, fill: gray)
          #context (self.last-section)().body
          #h(1fr)
          #place(right, self.logo)
        ],
        footer: [
          #set text(size: 0.6em, fill: gray)
          #(self.author)
          #h(1fr)
          #context {
            let arr = counter(page).get() + counter(page).final()
            arr.map(str).join(" / ")
          }
        ],
      )
      #body
    ],
    preamble: (self, body) => [
      #if title == auto {
        context (self.last-topic)()
      } else if title != none {
        heading(level: 2, title)
      } else {
        none
      }
      #v(1em)
      #body
    ],
    body-fn,
  )
}

#let simple-template(body, self: none) = {
  set page(paper: "presentation-16-9")
  set text(size: 25pt)
  show heading.where(level: 1): it => {
    slide(
      self: self,
      logical-slide: false,
      self => (
        [
          #set align(center + horizon)
          #it
        ],
        self,
      ),
    )
  }
  body
}


#let simple(states, ..info) = {
  info = merge-dicts(info.named(), base: default-info)
  states = merge-dicts(info, base: states)
  (
    title-slide: title-slide.with(self: states),
    slide: simple-slide.with(self: states),
    template: simple-template.with(self: states),
    plain-slide: simple-plain-slide.with(self: states),
    focus-slide: simple-focus-slide.with(self: states),
  )
}
