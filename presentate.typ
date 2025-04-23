#import "utils.typ": *
#import "animation.typ": *

#let indices = counter("_presentate_indices")

#let alias-counter(name) = counter("presentate-cover-" + name + "-counter")

#let default-frozen-counters = (
  "math.equation": (
    real: counter(math.equation),
    cover: alias-counter("math.equation"),
  ),
  "heading": (
    real: counter(heading),
    cover: alias-counter("heading"),
  ),
  "image": (
    real: counter(figure.where(kind: "image")),
    cover: alias-counter("image"),
  ),
  "table": (
    real: counter(figure.where(kind: "table")),
    cover: alias-counter("table"),
  ),
  "quote": (
    real: counter(quote),
    cover: alias-counter("quote"),
  ),
  "footnote": (
    real: counter(footnote),
    cover: alias-counter("footer"),
  ),
)

#let pdfpc-slide-markers(self) = context [
  #metadata((t: "NewSlide")) <pdfpc>
  #metadata((t: "Idx", v: indices.get().first())) <pdfpc>
  #metadata((t: "Overlay", v: self.subslide - 1)) <pdfpc>
  #metadata((t: "LogicalSlide", v: counter(page).get().first())) <pdfpc>
]


#let subslide(
  self,
  body-fn,
  wrapper: none,
) = {
  // `wrapper` is a slide wrapper.
  show: wrapper.with(self)

  pdfpc-slide-markers(self)

  set heading(outlined: self.subslide == 1)

  if self.freeze-counter {
    for c in self.frozen-counters.values().map(it => it.cover) {
      c.update(0)
    }
  }
  // the content is here.
  body-fn((self,)).at(0)

  if self.freeze-counter and self.subslide != self.steps {
    context {
      // Get current values of cover counters
      let cover-counter-values = self.frozen-counters.values().map(it => it.cover.get())
      // Update normal counters based on cover counter values
      for (real, cover) in self
        .frozen-counters
        .values()
        .map(it => it.real)
        .zip(cover-counter-values) {
        real.update((..n) => {
          subtract-array(n.pos().map(it => it), cover)
        })
      }
    }
  }
  // Draft Mode
  if self.drafted {
    place(center + horizon, text(fill: gray.transparentize(70%), str(self.subslide), size: 3in))
  }

  // For retaining subslide
  if self.subslide > 1 and not self.handout {
    counter(page).update(x => x - 1)
  }
  indices.step()
  pagebreak(weak: true)
}




#let apply-cover-counters(cont, covering: default-frozen-counters) = {
  let is-numbering(element) = element.at("numbering") != none

  show math.equation.where(block: true): it => {
    it
    if is-numbering(it) {
      covering.at("math.equation").cover.step()
    }
  }
  show heading: it => {
    it
    if is-numbering(it) { covering.at("heading").cover.step(level: it.level) }
  }
  show figure.where(kind: "image"): it => {
    it
    if is-numbering(it) { covering.at("image").cover.step() }
  }
  show figure.where(kind: "table"): it => {
    it
    if is-numbering(it) { covering.at("table").cover.step() }
  }
  show quote: it => {
    it
    if is-numbering(it) { covering.at("quote").cover.step() }
  }
  show footnote: it => {
    it
    if is-numbering(it) { covering.at("footnote").cover.step() }
  }
  cont
}

// default values
#let states = (
  handout: false,
  drafted: true,
  subslide: 1,
  pauses: 0,
  dynamics: (),
  logical-slide: 1,
  steps: 1,
  cover: hide,
  freeze-counter: true,
  frozen-counters: default-frozen-counters,
)

#let slide(
  steps: auto,
  self: states,
  body-fn,
  preamble: (self, body) => body,
  wrapper: (self, slide) => slide,
  logical-slide: true,
) = {
  show: it => {
    if self.freeze-counter {
      show: apply-cover-counters.with(covering: self.frozen-counters)
      it
    } else {
      it
    }
  }

  assert(
    type(body-fn) == function and body-fn((self,)).len() == 2,
    message: "body-fn must be a function that returns an array of (1) content and (2) the `self` argument.",
  )

  // the body-fn must accept an array so that it can be pushed
  // with pauses or dynamic function indices. However, to obtain
  // the information, original dictionary must be extracted.
  let info = body-fn((self,)).at(-1)

  // the states are stored in the first index of the array.
  // then, normal integers are number of pauses and array indices
  // are the indices of dynamic function like `uncover` and `only`.
  self = info.remove(0)
  self.dynamics = info.filter(it => type(it) == array).flatten()
  self.pauses = info.filter(it => type(it) == int).sum(default: 0)

  self.steps = if steps == auto {
    calc.max(self.pauses + 1, ..self.dynamics)
  } else {
    steps
  }

  // `preamble` is a content wrapper.
  body-fn = self => (
    preamble(self.first(), body-fn(self).first()),
    body-fn(self).last(),
  )

  if self.handout {
    self.subslide = self.steps
    subslide(self, body-fn, wrapper: wrapper)
  } else {
    for i in range(1, self.steps + 1) {
      self.subslide = i
      self.pauses = 0
      self.dynamics = ()
      subslide(self, body-fn, wrapper: wrapper)
    }
  }

  if not logical-slide {
    counter(page).update(x => x - 1)
  }
}

#let presentate-config(
  handout: false,
  drafted: false,
  cover: superhide,
  freeze-counter: true,
  frozen-counters: (:),
  theme: it => (:),
) = {
  assert(
    type(frozen-counters) == dictionary,
    message: "frozen-counters must be in the form `name: (real: counter(name), cover: alias-counter(name))`.",
  )

  let merged-states = merge-dicts(
    (
      handout: handout,
      drafted: drafted,
      uncover: uncover,
      freeze-counter: freeze-counter,
      pause: pause,
      frozen-counters: frozen-counters,
    ),
    base: states,
  )

  return (
    slide: slide.with(self: merged-states),
    ..theme(merged-states),
  )
}

