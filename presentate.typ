#import "utils.typ": *

/// Defines the initial state for a presentation.
///
/// This dictionary contains various properties that control the behavior and appearance of slides:
/// - pauses: The current number of pauses in the slide.
/// - subslide: The current subslide number.
/// - slide: The current slide number.
/// - body: An array to store the content of the slide.
/// - handout: A boolean indicating whether it's in handout mode.
/// - drafted: A boolean indicating whether it's in draft mode.
/// - pause: A dictionary containing pause-related settings.
/// - uncover: A dictionary containing uncover-related settings.
/// - style: A dictionary containing style-related settings.
#let states = (
  pauses: 1,
  subslide: 1,
  body: [],
  handout: false,
  drafted: false,
  pause: (
    hider: hide,
  ),
  uncover: (
    hider: hide,
  ),
  style: (
    slide-title: heading.with(level: 2),
  ),
)

/// Reveals content based on the current subslide number.
///
/// - self: The current state of the presentation.
/// - from: The subslide number from which to start showing the content.
/// - when-and-content: A variadic parameter containing subslide numbers and content to reveal.
/// - hider: A function to hide content when not revealed (default: none).
///
/// Returns: The revealed or hidden content based on the current subslide number.
#let uncover(self, from: none, ..when-and-content, hider: none) = {
  hider = if hider == none { self.uncover.hider } else { hider }
  assert(type(hider) == function, message: "hider must be a function")

  let present_index = when-and-content.pos()
  let func = present_index.pop()
  if type(func) != function {
    func = it => func
  }

  let body = func(self)

  // to escape when handout
  if self.handout { return body }

  if self.subslide in present_index or { type(from) == int and self.subslide >= from } {
    body
  } else {
    hider(body)
  }
}

/// Pauses the presentation and reveals content based on the current subslide number.
///
/// - self: The current state of the presentation.
/// - when-body: A variadic parameter containing the subslide number and content to reveal.
/// - hider: A function to hide content when not revealed (default: none).
///
/// Returns: The revealed or hidden content based on the current subslide number.
#let pause(self, ..when-body, hider: none) = {
  hider = if hider == none { self.pause.hider } else { hider }
  assert(type(hider) == function, message: "hider must be a function")
  self.insert("pauses", self.pauses + 1)

  let when = when-body.pos()
  let body = when.pop()

  let func = if type(body) != function { it => body } else { body }

  if self.handout { return func(self) }

  if when.len() == 0 {
    if self.subslide >= self.pauses { func(self) } else { hider(func(self)) }
  } else {
    self.pauses = when.at(0)
    if self.subslide >= when.at(0) { func(self) } else { hider(func(self)) }
  }
}

/// Shows content only on specific subslides.
///
/// - self: The current state of the presentation.
/// - from: The subslide number from which to start showing the content.
/// - when-and-content: A variadic parameter containing subslide numbers and content to show.
/// - hider: A function to hide content when not shown (default: it => none) to not preserve the space.
///
#let only(self, from: none, ..when-and-content, hider: it => none) = uncover(
  self,
  from: from,
  ..when-and-content,
  hider: hider,
)

/// Reveals content one by one in successive subslides.
///
/// - self: The current state of the presentation.
/// - funcs: A variadic parameter containing functions or content to reveal.
/// - hider: A function to hide content when not revealed (default: none).
///
#let one-by-one(self, ..funcs, hider: none) = {
  funcs = funcs.pos()
  if type(funcs.at(0)) == int {
    self.pauses = funcs.remove(0) - 1
  }
  let clean_funcs = ()
  let result = ()
  for func in funcs {
    if type(func) == function {
      clean_funcs += (func,)
    } else {
      clean_funcs += (it => func,)
    }
  }
  for i in range(funcs.len()) {
    pause(self, clean_funcs.at(i), hider: hider)
    self.pauses += 1
  }
}

/// Alters content at a specific subslide number.
///
/// - self: The current state of the presentation.
/// - from: The subslide number from which to start altering the content.
/// - when-and-before: A variadic parameter containing the subslide number and content to show before altering.
/// - after: The content to show after altering.
///
#let alter(self, from: none, ..when-and-before, after) = {
  let change_index = when-and-before.pos()
  let before = change_index.pop()
  if type(after) == function { after = after(before) }
  change_index += (after,)
  uncover(self, from: from, ..change_index, hider: it => before)
}

/// Changes content at a specific pause point.
///
/// - self: The current state of the presentation.
/// - before: The content to show before the change.
/// - after: The content to show after the change.
/// The change will applied on the next subslide.
///
#let change(self, before, after) = {
  if type(before) != function { before = it => before }
  after = if type(after) == function { it => after(before(it)) } else { it => after }
  pause(self, after, hider: before)
}



/// Creates a subslide with the specified content and title.
///
/// - n: The subslide number.
/// - func: A function that generates the content of the subslide.
/// - title: The title of the subslide (default: auto).
///
/// Returns: A function that updates the presentation state with the new subslide.
#let subslide(n, func) = {
  self => {
    self.insert("subslide", n)
    self.insert(
      "body",
      {
        self.body

        set heading(outlined: n == 1)
        // to make the dynamic functions be able to access the subslide number.
        func(self)
        // Draft mode
        if self.drafted {
          place(center + horizon, text(size: 3in, str(n), fill: black.transparentize(90%)))
        }
        if n > 1 and not self.handout { counter(page).update(x => x - 1) }
        pagebreak(weak: true)
      },
    )
    self.pauses = 1
    return self
  }
}

/// Creates a slide with multiple steps.
///
/// - steps: The number of steps in the slide (default: 1).
/// - self: The current state of the presentation (default: states).
/// - func: A function that generates the content of the slide.
/// - title: The title of the slide (default: auto).
///
/// Returns: The body of the slide, either as a single subslide (in handout mode) or as a composition of multiple subslides.
#let presentate-slide(steps: 1, self: states, frozen-states: (), func) = context {
  let default-frozen-states = (
    counter(math.equation),
    counter(heading),
    counter(figure.where(kind: "image")),
    counter(figure.where(kind: "table")),
    counter(quote),
  )
  let frozen-states = if type(frozen-states) == function {
    frozen-states(default-frozen-states)
  } else {
    default-frozen-states + frozen-states
  }
  let getValueState = ()
  for i in frozen-states {
    getValueState.push(i.get())
  }

  let frozen-func = it => {
    for (key, val) in frozen-states.zip(getValueState) {
      key.update(val)
    }
    it
  }

  let func = it => frozen-func(func(it))

  if self.handout { return (subslide(steps, func))(self).body }

  let result = ()
  for i in range(1, steps + 1) {
    result += (subslide(i, func),)
  }
  compose_func_from_array(init: self, result).body
}


#let presentate-config(
  default-steps: 1,
  handout: false,
  drafted: false,
  pause-cover: hide,
  uncover-cover: hide,
  theme: it => (:),
  frozen-states: (),
  ..args,
) = {
  let init = (
    pauses: 1,
    subslide: 1,
    body: [],
    handout: handout,
    drafted: drafted,
    pause: (
      hider: pause-cover,
    ),
    uncover: (
      hider: uncover-cover,
    ),
    default-steps: default-steps,
    current-title: [],
  )
  return (
    states: init,
    presentate-slide: presentate-slide.with(
      self: init,
      steps: default-steps,
      frozen-states: frozen-states,
    ),
    ..theme(init, ..args),
  )
}
