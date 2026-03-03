#import "../../../src/export.typ": * 
#set page(paper: "presentation-16-9")
#set text(size: 40pt)
// start-example 
#slide[
  #let yes = text.with(fill: eastern)
  #let no = text.with(fill: gray.transparentize(50%))
  Let's have some quizzes.
  - #transform([What is $1 + 1$?], yes, no)
  - #transform([What is $3 times 3$?], yes, no, start: none)
  - #transform([What is $3!$?], yes, no, start: none)
]