// Theorem environments, used for definition environment
#import "@preview/ctheorems:1.1.3": *
#import "@preview/equate:0.2.1" : equate
#import "utils.typ" : eq-number


// Custom equation numbering
// Example: heading is 1.3, then single-line equation is 1.3.1
// Example: heading is 1.3, then multi-line equation is 1.3.1a, 1.3.1b
#let eq-number(..nums) = {
  let nums = nums.pos()
  let sub-eqs = nums.len() > 1
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

// #let eq-number(..nums) = {[#nums.pos().map(str).join(".")]}

// Template formatting options
#let template(doc) = [

  // Multi-line equation is default
  #show: thmrules
  #show: equate.with(breakable: true, sub-numbering: true)
  #set math.equation(numbering: eq-number)
  #set page(margin: 1in)
  #set par(justify: true)
  #set text(font: "Latin Modern Roman", size:11pt)
  #set heading(numbering: "1.1")

  // Disable default ref supplements because they're not context-dependent (e.g. Eq is always capitalised.)
  #set ref(supplement: none)

  // Customise heading format
  // Reset equation counter to 1 each time you create a heading or subheading
  #show heading.where(level:1): it => [
    #let indent = {h((counter(heading).get().len() - 1) * 0.5em)}
    #indent
    #set block(above: 1.4em, below: 1.4em)
    #set text(font: "Arial")
    #counter(heading).display() #h(0.5em)
    #it.body
    #counter(math.equation).update(0)
  ]
  #show heading.where(level:2): it => [
    #let indent = {h((counter(heading).get().len() - 1) * 0.5em)}
    #indent
    // #set block(above: 1.4em, below: 1em)
    #set text(font: "Arial", size:12pt)
    #counter(heading).display() #h(0.5em)
    #it.body
    #counter(math.equation).update(0)
  ]
  #show heading: set block(sticky: true)
  #doc
]
