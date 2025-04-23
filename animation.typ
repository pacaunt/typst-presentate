#let pause(self, body, hider: none) = {
  let info = self.remove(0)
  let pauses = self.filter(it => type(it) == int).sum(default: 0)
  let shown-idx = pauses + 1

  if hider == none {
    hider = info.cover
  }
  // show only when the current number of pauses are less than current subslide.
  if shown-idx < info.subslide {
    body
  } else {
    hider(body)
  }
}


#let uncover(self, from: none, ..when, body, hider: none) = {
  let self = self.at(0)
  hider = if hider == none { self.cover } else { hider }
  assert(type(hider) == function, message: "hider must be a function")

  let present_index = when.pos()

  if self.subslide in present_index or { type(from) == int and self.subslide >= from } {
    body
  } else {
    hider(body)
  }
}

// show the body progressively
#let gradual(self, from: none, ..bodies, hider: none) = {
  if hider == none { hider = self.at(0).cover }
  bodies = bodies.pos()

  if type(from) != int {
    for body in bodies {
      pause(self, body, hider: hider)
      self.push(1)
    }
  } else {
    let i = 0
    for body in bodies {
      uncover(self, from: from + i, hider: hider, body)
      i += 1
    }
  }
}


#let only(self, from: none, ..when, body, hider: it => none) = {
  uncover(self, from: from, hider: hider, ..when, body)
}

// alternates the content
#let alter(self, from: none, ..when, before, after) = {
  let change_index = when.pos()

  if type(after) == function { after = after(before) }

  uncover(self, from: from, ..change_index, after, hider: it => before)
}

// alternates the content based on `pause` progress
#let change(self, before, after) = {
  after = if type(after) == function { after(before) } else { after }
  pause(self, after, hider: it => before)
}

#let progress(self, init: auto, hider: it => none, ..frames, left-on-slide: true) = {
  let info = self.at(0)
  let frames = frames.pos()
  let shown-idx
  if init == auto {
    let pauses = self.filter(it => type(it) == int).sum(default: 0)
    shown-idx = pauses + 1
  } else {
    assert(type(init) == int, message: "init must be a subslide index")
    shown-idx = init
  }

  for i in range(frames.len()) {
    uncover(
      self,
      ..{
        if left-on-slide and i == frames.len() - 1 { (from: i + shown-idx) } else { (shown-idx + i,) }
      },
      frames.at(i), 
      hider: hider
    )
  }
}

#let transform(self, init: auto, hider: none, body, ..funcs, left-on-slide: true) = {
  let info = self.at(0)
  let funcs = funcs.pos()
  let shown-idx
  if init == auto {
    let pauses = self.filter(it => type(it) == int).sum(default: 0)
    shown-idx = pauses + 1
  } else {
    assert(type(init) == int, message: "init must be a subslide index")
    shown-idx = init
  }
  let reveal-content
  for i in range(funcs.len()) {
    reveal-content = (funcs.at(i))(body)
    uncover(self, ..{
        if left-on-slide and i == funcs.len() - 1 { (from: i + shown-idx) } else { (shown-idx + i,) }
      }, reveal-content, hider: hider)
  }
}
