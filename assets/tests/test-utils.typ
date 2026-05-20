#import "../../src/utils.typ": *

#pipe(rect, move.with(dx: 2cm))([G])
#pipe(move.with(dx: 2cm), rect)([G])

#{
  let is-shown = false
  let is-command(command) = {
    (
      type(command) == str
        or {
          (
            type(command) == array
              and command.len() == 2
              and type(command.first()) == str
              and type(command.last()) == function
          )
        }
    )
  }


  // `active` means ability to change the showing status of an element,
  // `inherited` means ability to receive the previous modifiers
  // `leftover` means ability to send the modifiers to next steps
  let command-info = (
    "start": (active: true, inherited: true, leftover: true),
    "stop": (active: false, inherited: false, leftover: false),
    "revert": (active: auto, inherited: false, leftover: true),
    "apply": (active: auto, inherited: true, leftover: true),
    "clear": (active: true, inherited: false, leftover: true),
    "once": (active: true, inherited: true, leftover: false),
  )

  let default-command-info = (
    target: str,
    name: str,
    func: auto,
    hider: auto,
    active: bool,
    inherited: bool,
    leftover: bool,
  )

  let parse-str-command(string, default: default-command-info) = {
    let command = default
    command.target = string
    if not string.contains(".") {
      command.name = "once"
    } else {
      (command.target, command.name) = string.split(".")
      assert(
        command.name in command-info.keys(),
        message: "Unknown command `"
          + command.name
          + "`, the available statuses are "
          + command-info.keys().map(k => "`" + k + "`").join(", "),
      )
    }
    return command + command-info.at(command.name)
  }
  // TEST -- step 1
  [
    #parse-str-command("good")
    #parse-str-command("good.apply")
  ]

  // controls: (..rules)
  // rule = (..commands)
  // command -> info
  let generate-command(raw-command, default: default-command-info) = {
    assert(
      is-command(raw-command),
      message: "The command should be either a `name`, a `name.command`, or an array. The array command must be in the form `(command-name, function)`.",
    )
    let command = default
    if type(raw-command) == str {
      command = parse-str-command(raw-command, default: default)
    } else {
      command = parse-str-command(raw-command.first(), default: default)
      // handle the function from `stop` command
      if command.name == "stop" {
        command.hider = raw-command.last()
      } else {
        command.func = raw-command.last()
      }
    }

    return command
  }

  // TEST 2 -- command
  [
    = COMMAND
    #generate-command(("good", it => it))
    #generate-command(("good.start", text))
    // error
    // #generate-command("good.what")
  ]

  let parse-a-rule(commands, default: default-command-info) = {
    if is-command(commands) {
      commands = (commands,)
    }
    commands.map(generate-command.with(default: default))
  }

  // TEST 3 -- rule
  [
    = RULE
    #parse-a-rule("good")
    #parse-a-rule(("good.apply", text))
    #parse-a-rule(("good.stop", hide))
    #parse-a-rule("good.revert")
    #parse-a-rule((
      ("good.apply", hide), 
      ("bad.apply", figure)
    ))
  ]

  let status(
    // whether to show the element
    visible: is-shown,
    // keep track of previous modifiers
    history: (),
    // current modifier to use
    func: auto,
    // current hider to use
    hider: auto,
  ) = (
    visible: visible,
    history: history,
    func: func,
    hider: hider,
  )

  // Expected result:
  // (
  //  (:),
  //  ("element-1": (..properties)),
  //  ("element-1": (..properties), "element-2": (..properties)),
  // )
  let resolve(rules) = {
    let rules = rules.map(parse-a-rule)
    let result = ()
    let element-status = (:)

    for rule in rules {
      let current-status = element-status
      for command in rule {
        // initialize the status
        if command.target not in element-status {
          element-status.insert(command.target, status())
        }
        // resolve visibility
        if command.active != auto {
          element-status.at(command.target).visible = command.active
        }
        // clear the history
        if command.name == "clear" {
          element-status.at(command.target).history = ()
        }
        // inherit the modifier
        if command.inherited {
          element-status.at(command.target).func = element-status.at(command.target).history + (command.func,)
        }
        // send the animation to other steps
        if command.leftover {
          element-status.at(command.target).history += (command.func,)
        }
        // process the current animation
        current-status = element-status
        // reset the visibility if there is nothing to show when `once` is called
        if command.name == "once" and element-status.at(command.target).history == () {
          element-status.at(command.target).visible = false
        }
      }

      result.push(current-status)
    }


    return result
  }

  // TEST 4 -- process
  [
    = RESOLVE
    // #resolve((
    //   "good",
    //   (),
    //   ("good.apply", text),
    //   (),
    // ))
  
    #resolve((
      ("c.start", "d.start"),
      (
        (
          "c.apply",
          figure
        ),
        ("d.apply", text),
      ),
    ))
  ]
}
