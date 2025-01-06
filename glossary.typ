
// ----------------------------------------------
// Functions for Glossary Book-keeping
// ----------------------------------------------

// Converts "Case-sensitive text with spaces" to "case-sensitive-text-with-spaces"
// - Replaces spaces with hyphens.
// - Converts all characters to lowercase.
// This ensures that glossary keys follow the format: "name-of-term".
#let convert-to-key(term) = {
  lower(term.replace(" ", "-"))
}

// Generates a unique label for glossary terms using the converted key.
#let glossary-label(term) = {
  label(convert-to-key(term))
}

// Creates a reference link to a glossary term.
// - The link uses bold and italic formatting for the term.
#let ref-glossary(term) = {
  link(glossary-label(term))[*#term*]
}

// ----------------------------------------------
// Glossary Entries
// ----------------------------------------------
// Define the glossary as a mapping of terms to their descriptions.
// Use `#ref-glossary` to link referenced terms in definitions.
#let glossary = (
    "Deep learning": [
        A branch of 
        #ref-glossary("machine learning")
        that uses neural networks as function approximators.
    ],
    "Machine learning": [
        A programming paradigm where instructions for solving a problem 
        are not explicitly fed to a computer. Instead, the computer is 
        trained using available data to find a function which successfully 
        completes the task.
    ],
)


// ----------------------------------------------
// Formatting and Rendering the Glossary
// ----------------------------------------------

// Generates the glossary section with proper headings and spacing.
// - Each glossary term is bolded and linked for reference.
// - Definitions are formatted with a small vertical space between entries.
#let render-glossary() = {
  [
    // Glossary title
    #heading("Glossary", level: 1) #label("glossary")

    // Render each glossary entry
    #for (item, desc) in glossary.pairs() [
      *#item* #glossary-label(item)
      :
      #desc
      #v(0.5em)
    ]
  ]
}



