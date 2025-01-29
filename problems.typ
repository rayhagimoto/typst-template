// This file defines a custom environment for problems and solutions
// Includes functionality for linking problems and solutions
// Provides a state-based system to track questions and solutions
// Renders solutions with references to associated problems

// Import external libraries
#import "@preview/ctheorems:1.1.3": *
#import "utils.typ" : cyan, border-color 

// Question and answer function
#let question(..args, long:true, fill: cyan, stroke-paint: border-color, label: none) = {
  // This function expects either one or two args
  // First arg is always interpreted as question
  // Second arg is interpreted as the solution to that question
  // both args should be content types
  
  let qbox = thmbox(
  "problem",
  "Problem",
  fill: fill,
  bodyfmt: body => [#body],
  stroke: (left: stroke(
      paint: stroke-paint,
      thickness: 2.5pt
    )),
  padding: (top: 0.0em, bottom: 0.0em),
  spacing: 0.0em,
)

  // Format the question
  let q = args.at(0)
  // let result = []
  let box-env = content => box[#content]
  if long {box-env = content => qbox[#content]}
  
  let result = box-env[#q <question>]
  result = result + context {
    let nb = thmcounters.get().at("latest")
    let meta = [#metadata((none, nb)) <answer>]
    if args.pos().len() > 1 {meta = [#metadata((args.at(1), nb)) <answer>]}
    meta
    // result = result + meta
    // return result
  }

  // result = result + context {

  // }

  // // Store the answer as metadata, if the solution is supplied.
  // if args.pos().len() > 1 {
  //   let a = args.at(1)
  //   result = result + context {
  //   let nb = thmcounters.get().at("latest")
  //   [
  //     #metadata((a, nb)) <answer>
  //   ]
  // }
  // } else {
  //   result = result + context {
  //   let nb = thmcounters.get().at("latest")
  //   [
  //     #metadata((none, nb)) <answer>
  //   ]
  // }
  // }
  return figure(
      result,
      kind: "thmenv",
      outlined: false,
      supplement: [],
      numbering: "1.1",
    )
};

// Render the solutions
#let solutions() = context {

    // Get the current chapter
    let section-start = query(selector(heading.where(level:1)).before(here())).last().location()

    // Get the headings that are defined after
    let sections-after = query(selector(heading.where(level:1)).after(here()))

    // Find all the questions which are defined after current chapter
    //  Note: this includes subsequent chapters too, if this isn't the
    //  final chapter
    let sel = selector(<question>).after(section-start)
    if sections-after.len() > 0 {
        sel = sel.before(sections-after.first().location())
    }

    let result = for question in query(sel) {
        let aq = query(selector(<answer>).after(question.location()))
        if aq.len() > 0 {
          let answer = aq.first()
          let nb = numbering("1.1", ..answer.value.at(1))
          if answer.value.at(0) != none {
            let prompt_link = link(question.location(), [(_Prompt on page #question.location().page()_)])
            let answer_block = block(inset:5pt)[
              #answer.value.at(0)
            ]
            block[ 
              *Solution #nb:* #prompt_link \
              #answer_block
              #line(start:(0pt + 2%, 0pt + 0%), end:(0pt + 98%, 0pt + 0%), stroke: 0.4pt + black)
            ]
          } else {[]}
        }
    }
  result
}

// Function for referencing problems
#let pref(lab) = context {
  // Problems can be referenced in the following way:
  // #question[content] <q:label> 
  // #pref(<q:label>)
  let sel = query(selector(<question>).after(lab)).first().location()
  let nb = thmcounters.at(sel).at("latest")

  // Output formatting
  link(lab, "problem " + numbering("1.1", ..nb))
}

// Capitalised verison of pref
#let Pref(lab) = context {

  // Selector for some reason needs to find the first match after the label.
  let sel = query(selector(<question>).after(lab)).first().location()
  let nb = thmcounters.at(sel).at("latest")

  // Format output
  link(lab, "Problem " + numbering("1.1", ..nb))
}

