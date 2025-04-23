#let dynamics = state("presentate_dynamics", (1, 0))

#let subslides = state("presentate_subslides", 1)

#let _config = state("presentate_states", (handout: false, drafted: false))

#let paused-content(n, body, hider: hide) = context {
  let loc = if body.has("location") { body.location() } else { here() }
  if _config.at(loc).handout { return body }
  if n >= dynamics.at(loc).at(0) {
    body
  } else {
    hider(body)
  }
}

#let pause(..args) = {
  args = args.pos() 
  if args.len() == 0 {
    dynamics.update(((x, y)) => (x + 1, calc.max(x + 1, y)))
  } else if args.len() == 1 and type(args.at(0)) == int {
    dynamics.update(((x, y)) => (args.at(0), calc.max(args.at(0), x, y)))
  } else if args.len() == 1 and type(args.at(0)) == content {
    dynamics.update(((x, y)) => (x + 1, calc.max(x + 1, y)))
    context paused-content(subslides.get(), args.at(0))
  } else if args.len() == 2 {
    dynamics.update(((x, y)) => (args.at(0), calc.max(args.at(0), x , y)))
    context paused-content(subslides.get(), args.at(1))
  } else {
    panic("Unsupported arguments in pause function.")
  }
}

#let meanwhile(..args) = {
  args = args.pos() 
  if args.len() == 0 {
    dynamics.update(((x, y)) => (1, calc.max(x, y)))
  } else if args.len() == 1 and type(args.at(0)) == int {
    dynamics.update(((x, y)) => (args.at(0), calc.max(args.at(0), x, y)))
  } else if args.len() == 1 and type(args.at(0)) == content {
    dynamics.update(((x, y)) => (1, calc.max(x + 1, y)))
    context paused-content(subslides.get(), args.at(0))
  } else if args.len() == 2 {
    dynamics.update(((x, y)) => (args.at(0), calc.max(args.at(0), x , y)))
    context paused-content(subslides.get(), args.at(1))
  } else {
    panic("Unsupported arguments in pause function.")
  }
}


#let uncover(..args, from: auto, hider: hide, marker: it => it) = {
  args = args.pos()
  let body = args.pop()
  if type(body) == content {
    marker(dynamics.update(((x, y)) => (x, calc.max(y, ..args, {
      if type(from) == int { from } else { 0 }
    }))))
    context {
      if _config.get().handout { return body } else {
        if subslides.get() in args or { 
          type(from) == int and subslides.get() >= from 
        } { 
          body
        } else {
          hider(body)
        }
      } 
    }
  } else {
    marker(dynamics.update(((x, y)) => (x, calc.max(y, ..args, {
      if type(from) == int { from } else { 0 }
    }))))
    if _config.get().handout { return body } else {
        if subslides.get() in args or { 
          type(from) == int and subslides.get() >= from 
        } { 
          body
        } else {
          none
        }
      } 
  }
}

#let set_state(handout: false, drafted: false) = _config.update((handout: handout, drafted: drafted))

#let only(..args, from: auto, hider: it => none, marker: it => it) = {
  uncover(..args, from: from, hider: hider, marker: marker)
}

#let alter(..args, from: auto, after, marker: it => it) = {
  args = args.pos()
  let before = args.pop()
  if type(after) == function {
    args.push(after(before))
  } else { args.push(after) }
  uncover(..args, from: from, hider: it => before, marker: marker)
}

#let _subslide(n, body, preamble: it => it) = {
  subslides.update(n)
  dynamics.update((1, 0))

  let paused-content = paused-content.with(n)
  // let saved-content(x) = [#metadata((kind: "presentate_saved_content", value: x))<presentate>]
  
  {
    show: preamble
    
    //show math.equation: paused-content
    // show par: saved-content
    // show box: saved-content
    // show block: saved-content
    // show path: saved-content
    // show rect: saved-content
    // show square: saved-content
    // show circle: saved-content
    // show ellipse: saved-content
    // show line: saved-content
    // show polygon: saved-content
    // show image: saved-content
    show par: paused-content
    show box: paused-content
    show block: paused-content
    // show path: paused-content
    // show rect: paused-content
    // show square: paused-content
    // show circle: paused-content
    // show ellipse: paused-content
    // show line: paused-content
    // show polygon: paused-content
    // show image: paused-content
    set heading(outlined: n == 1)
  
    body

  }

  context if _config.get().drafted {
    place(center + horizon, text(size: 3in, fill: rgb(10, 10, 10, 30), str(n)))
  }

  
  v(0pt)
  
  if n > 1 {
    counter(page).update(x => x - 1)
    pagebreak(weak: true)
  }
}

#let presentate_slide(body, wrapper: it => it, preamble: it => it, steps: auto) = {
  // show <presentate>: it => context {
  //   paused-content(subslides.at(it.location()), it.value.value)
  // }
  show: wrapper
  _subslide(1, body, preamble: preamble)
  context {
    let steps = steps
    if _config.get().handout { steps = 1 } else if type(steps) != int { steps = dynamics.get().at(1) }
    pagebreak(weak: true)
    for i in range(2, steps + 1) {
      _subslide(i, body, preamble: preamble)
    }
  }
  subslides.update(1)
}
