#import "@preview/ctheorems:1.1.3" : *
#import "@preview/quick-maths:0.2.0" : shorthands 



// ----- Rebindings -----

// Swap default phi and varphi (LaTeX convention)
#let (varphi, phi) = ($phi$, $phi.alt$)

// center dots
#let cdots = $dots.h.c$

// a small horizontal space of 0.05cm
#let smol = $#h(0.05cm)$

// alias for partial derivative symbol ∂
#let pd = $diff$

// Probability shorthands
#let Cov = $"Cov"$
#let Var = $"Var"$

// Colors
#let cyan = rgb("#66ccff50")
#let border-color = rgb("#316eb090")

// Function for displaying a title with me as the author
#let title(content, author: "Ray Hagimoto") = [
  #align(center,text(20pt)[#content])
  #align(center, [#author])
]


// ----------------- References ----------------

#let eref(label) = [eq. #ref(label)]
#let Eref(label) = [Eq. #ref(label)]

// ----------------- Title ----------------------

#let date = datetime.today()

#let make-title(title) = {
  align(
    center, 
    [
      #text(size:17pt, font:"Arial")[*#title*]\ #v(0.05em)
      #date.display("[day] [month repr:short] [year]")
    ]
  )
}

// ----- Definitions and box environments ------

// Definition environment
#let defenv = thmbox(
  "definition",
  "Definition",
  fill:cyan,
  stroke:(left:stroke(
      paint:border-color, 
      thickness:2.5pt
    )),
  padding:()
)

#let definition(def, term: none) = {
  if term == none {
    defenv[
      #def
    ]
  } else {
    let term = upper(term.at(0)) + term.slice(1,)
    defenv[
      *#term* -- #def
    ]
  }
}

// Colored box
#let colored-box(color: cyan, side_color: border-color, content) = box(
  fill:color,
  stroke:(left:stroke(
      paint:side_color, 
      thickness:2.5pt
    )),
    radius:2pt,
    inset:10pt,
    width:100%,
    content,
)


// Plain blue box
#let bluebox(content) = colored-box(content)

#let deflink(term) = [
  #let lab = label("def:" + term.replace(" ", "-"))
  #link(lab)[*#term*]
]

// Custom checkmark
#let checkmark = highlight(fill:green, top-edge: 0.12in, extent: 0.015in, text(fill: white, size:10pt, [✓]))

// Custom red text
#let red(content) = text(fill: color.red, [#content])

// ---- Custom figure environments ----
// arch for neural network architectures
#let arch(content) = figure(
    content,
    kind:"Architecture",
    supplement:"Architecture",
    numbering:"1",
    caption: []
)

// ---- Custom equation numbering stuff ----
// -  The following functions are intended to be used with the
//    typst `equate` package

// An equation environment with no numbers
#let no-num = <equate:revoke>

// 
#let eq-number(..nums) = {
  let nums = nums.pos() // convert nums argument to array
  let sub-eqs = nums.len() > 1 // if there are multiple layers of numbers, there must be sub-equations (this is figured out by the equate package)
  let head-counter = counter(heading).get() 
  let result = {
    (head-counter + (nums.at(0),)).map(str).join(".")
  }
  if sub-eqs {
    let sub-eq = numbering("a", nums.at(1))
    [(#result#sub-eq)]
  } else {
    [(#result)]
  }
}
