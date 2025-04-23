#import "utils.typ": *



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
)


#let subslide(self, body-fn, frozen-counters: default-frozen-counters) = {
  set heading(outlined: self.subslide == 1)

  if self.freeze-counter {
    for c in frozen-counters.values().map(it => it.cover) {
      c.update(0)
    }
  }

  body-fn((self,)).body

  if self.freeze-counter and self.subslide != self.steps {
    context {
      // Get current values of cover counters
      let cover-counter-values = frozen-counters.values().map(it => it.cover.get())
      // Update normal counters based on cover counter values
      for (real, cover) in frozen-counters.values().map(it => it.real).zip(cover-counter-values) {
        real.update((..n) => {
          subtract-array(n.pos().map(it => it), cover)
        })
      }
    }
  }

  if self.drafted {
    place(center + horizon, text(fill: gray.transparentize(70%), str(self.subslide), size: 3in))
  }

  if self.subslide > 1 {
    counter(page).update(x => x - 1)
  }
  pagebreak(weak: true)
}



#let pause(self, body, hider: none, delay: 0, updated: none) = {
  self = self.flatten()

  let info = self.remove(0)
  let shown-idx = count0(self) + 1 + delay

  if hider == none {
    hider = info.cover
  }

  if shown-idx < info.subslide {
    body
  } else {
    hider(body)
  }
}

#let uncover(self, from: none, ..when-and-content, hider: none) = {
  let self = self.flatten().at(0)
  hider = if hider == none { self.cover } else { hider }
  assert(type(hider) == function, message: "hider must be a function")

  let present_index = when-and-content.pos()
  let body = present_index.pop()

  if self.subslide in present_index or { type(from) == int and self.subslide >= from } {
    body
  } else {
    hider(body)
  }
}

#let only(self, from: none, ..when-and-content, hider: it => none) = {
  uncover(self, from: from, hider: hider, ..when-and-content)
}

#let alter(self, from: none, ..when-and-before, after) = {
  let change_index = when-and-before.pos()
  let before = change_index.pop()
  if type(after) == function { after = after(before) }
  change_index += (after,)
  uncover(self, from: from, ..change_index, hider: it => before)
}

#let change(self, when, before, after) = {
  after = if type(after) == function { after(before) } else { after }
  uncover(self, from: when, after, hider: it => before)
}

#let apply-cover-counters(cont, covering: default-frozen-counters) = {
  let is-numbering(element) = element.has("numbering")

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
  cont
}

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
  logical-slide: true,
) = {
  let frozen-counters = merge-dicts(self.frozen-counters, base: default-frozen-counters)
  show: it => {
    if self.freeze-counter {
      show: apply-cover-counters.with(covering: frozen-counters)
      it
    } else {
      it
    }
  }

  let info = body-fn((self,)).info.flatten()
  let self = info.remove(0)
  for n in info {
    if n == 0 {
      self.pauses += 1
    } else {
      self.dynamics += (n,)
    }
  }
  self.steps = if steps == auto {
    calc.max(self.pauses + 1, ..self.dynamics, 1)
  } else {
    steps
  }
  if self.handout {
    self.subslide = self.steps
    return subslide(self, body-fn, frozen-counters: frozen-counters)
  }
  for i in range(1, self.steps + 1) {
    self.subslide = i
    subslide(self, body-fn, frozen-counters: frozen-counters)
  }
  if not logical-slide {
    counter(page).update(x => x - 1)
  }
}

#let presentate-config(
  handout: false,
  drafted: false,
  cover: hide,
  freeze-counter: false,
  frozen-counters: (),
  theme: it => (:),
) = {
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
