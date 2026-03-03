#import "../../src/export.typ": * 
#import "../../src/render.typ": reveal-item
#import themes.classic: template, slide

#show: template 

== Test `#step-item` 
#slide[
  *The Current Hack*
  #reveal-item[
    - First 
      #reveal-item[
        - First 
          #reveal-item[
            - First 
          ]
      ]
    - Second 
    - Third 
    - Fourth
  ]
]

#slide[
  #display-item(
    (from: auto), 
    (from: auto), 
    (from: auto), 
    (from: none),
  )[
    - First 
    - Second 
    - Third 
    - Third
  ]
]

== Test `auto` and `none`

#slide[
  #display-item(
    (from: auto),
    (from: auto), 
    (from: auto),
    (from: none),
  )[
    - First 
      #display-item((from: auto), (from: none))[
        + First Item 
        + Second Item 
      ]
    - Second 
    - Third 
    - Third
  ]
]

#slide[
  #reveal-item[
    - Show on first
      #reveal-item[
        - First Subitem 
        - Second Subitem
      ]
    - Show on first
  ][
    - Show on second
    - Show on second
  ][
    - Show on third
    - Show on third
  ]
]