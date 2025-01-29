// This file defines a custom environment for problems and solutions
// Includes functionality for linking problems and solutions
// Provides a state-based system to track questions and solutions
// Renders solutions with references to associated problems

// Import external libraries
#import "@preview/ctheorems:1.1.3": *
#import "utils.typ" : cyan, border-color 

// Initialize state for solutions and questions
#let solutions = state("solutions", ())
#let questions = state("questions", (:))

// Question box environment definition
#let question = thmbox(
  "problem",
  "Problem",
  fill: cyan,
  bodyfmt: body => context {
    let loc = here() // Save the location of the current question
    let solution_link = [] // Placeholder for a link to the solution
    let tc = thmcounters.get().at("latest") // short for thmcounter
    let number = numbering("1.1", ..tc)

    // Update the questions state with the new question
    questions.update(existing => existing + ("problem" + number: loc,))

    // Check if there is a solution linked to this question
    let solution_label = label("solution" + number)
    let q = query(selector(solution_label))
    if q.len() > 0 {
      let loc = q.first().location() // Retrieve solution location
      solution_link = align(center)[#link(loc)[_Solution on page #loc.page() _]]
    }
    [ 
      #body
      #solution_link
    ]
  },
  stroke: (left: stroke(
      paint: border-color,
      thickness: 2.5pt
    )),
  padding: (top: 0.0em, bottom: 0.0em),
  spacing: 0.0em,
)

// Solution box environment definition
#let solution(
  ..args,
  body,
  title: auto,
  numbering_format: "1.1",
  namefmt: x => [(#x)],
  titlefmt: strong,
  bodyfmt: x => x,
  separator: [#h(0.1em): #h(0.2em)],
  padding: (top: 0.5em, bottom: 0.5em),
) = context {
  let problem_counter = thmcounters.get().at("counters").at("problem")
  let problem_number = numbering(numbering_format, ..problem_counter)
  let solution_title = titlefmt([Solution #problem_number])
  let solution_label = label("solution" + problem_number)
  let problem_label = label("problem" + problem_number)

  // Update the solutions state with the new solution
  solutions.update(existing => {
    existing + (
      (
        problem_counter: problem_counter,
        label: solution_label,
        prob_label: problem_label,
        body: body,
      ),
    )
  })
}

// Function to render all solutions
#let make-solutions() = context {
  let all_solutions = solutions.get() // Retrieve all stored solutions
  let hc = counter(heading).get().at(0)
  if all_solutions.len() == 0 {
    "No solutions available."
  } else {
    let block_args = arguments(
      width: 100%, inset: 0.0em, radius: 0.0em,
      breakable: false, fill: none
    )
    let pad_args = arguments(top: 0.0em, bottom: 0.0em)
    let solution_env = content => {
      pad(..pad_args, block(..block_args, content))
    }
      // Iterate over each solution and generate its contents.
      all_solutions.map(sol => {

        // Format solution number array as a string
        let number = numbering("1.1", ..sol.problem_counter) 
        let prob_label = "problem" + number // Associated problem label
        let prob_link = [] // Placeholder for a link to the problem
        
        let q = prob_label in questions.get().keys()
        if q {
          let loc = questions.get().at(prob_label) // Retrieve problem location
          prob_link = link(loc)[_see page #loc.page() for prompt_]
        }
        let result = []
        let pass = false
        if sol.problem_counter.at(0) == hc {
          result = solution_env[
            *Solution #number* (#prob_link)\
            #sol.body\
            #sol.label
          ]
          pass = true
        }
        result
  }).join()
  }
}
