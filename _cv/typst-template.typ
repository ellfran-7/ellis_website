#import "@preview/fontawesome:0.6.0": *

// ----------------------------------------------------------------
  // Colors
// ----------------------------------------------------------------
  #let color-teal = rgb("#38605d")
  #let color-light-teal = rgb("#5F7F7D")
  #let color-lightest-teal = rgb("#C7D2D1")
  #let color-purple = rgb("#a148d1")
  #let color-dark = rgb("#1a1a1a")
  #let color-gray = rgb("#5d5d5d")
  #let color-lightgray = rgb("#999999")
  
// ----------------------------------------------------------------
  // Utilities
// ----------------------------------------------------------------
  
  // Parse icon strings: "fa envelope", "fa brands github"
#let parse-icon(icon-string) = {
if icon-string.starts-with("fa ") {
  let parts = icon-string.split(" ")
  if parts.len() == 2 {
    fa-icon(parts.at(1), fill: color-light-teal)
  } else if parts.len() == 3 and parts.at(1) == "brands" {
    fa-icon(parts.at(2), font: "Font Awesome 6 Brands", fill: color-light-teal)
  }
} else if icon-string.ends-with(".svg") {
  box(image(icon-string, height: 0.9em))
}
}

// Improved Left-Right justify using grid for better alignment stability
#let justify-align(left-body, right-body) = {
grid(
  columns: (1fr, auto),
  column-gutter: 1em,
  align(left)[#left-body],
    align(right)[#right-body]
)
}

// ----------------------------------------------------------------
  // Header components
// ----------------------------------------------------------------
  
  #let make-header(author, profile-photo: "") = {
  let name-block = pad(bottom: 4pt)[
    #text(size: 26pt, weight: "thin", fill: color-light-teal)[#author.firstname]
    #text(size: 26pt, weight: "bold", fill: color-teal)[ #author.lastname]
  ]
  
  let position-block = block(below: 0.8em)[
    #text(size: 10pt, fill: color-teal, weight: "medium")[#smallcaps[#author.position]]
  ]
  
  let address-block = block(below: 1em)[
    #text(size: 9pt, fill: color-light-teal, style: "italic")[#author.address]
  ]
  
  let contacts-block = {
    let sep = h(8pt)
    set text(size: 9pt)
    author.contacts.map(c => {
      box(height: 9pt)[
        #parse-icon(c.icon)
        #h(3pt)
        #link(c.url)[#text(fill: color-purple)[#c.text]]
      ]
    }).join(sep)
  }
  
  if profile-photo.len() > 0 {
    grid(
      columns: (4fr, 1fr),
      align(left)[
        #name-block
        #position-block
        #address-block
        #contacts-block
      ],
      align(right)[
        #block(
        stroke: none,
        radius: 50%,
        clip: true,
        width: 80pt,
        height: 80pt,
        image(profile-photo, fit: "cover"),
    )
      ]
    )
  } else {
    align(center)[
      #name-block
      #position-block
      #address-block
      #contacts-block
    ]
  }
  }

// ----------------------------------------------------------------
  // Entry components
// ----------------------------------------------------------------
  
// Main entry: Handles the floating date and title layout
#let cv-entry(
title: none,
location: [],
date: [],
description: none,
indent: 0em,
) = {
  pad(left: indent)[
    #block(width: 100%, breakable: false, above: 0.8em, below: 0.8em)[
      // Top Row: Bold Title and Italic Location
      #justify-align(
        text(size: 11pt, weight: "bold", fill: color-teal)[#title],
        text(size: 9pt, style: "italic", fill: color-teal)[#location]
      )

      // Bottom Row: Description and Light Teal Date
      #if description != none or date != [] {
        v(-0.4em) // Tighten vertical space between title and subtitle
        pad(left: 0.5em)[
          #justify-align(
            text(size: 10pt, weight: "regular", fill: color-light-teal)[#description],
            text(size: 9pt, style: "italic", fill: color-light-teal)[#date]
          )
        ]
      }
    ]
  ]
}

#let cv-item(body) = {
set text(size: 20pt, fill: color-teal)
list(indent: 1em, marker: text(fill: color-light-teal)[•])[#body]
  }

// ----------------------------------------------------------------
  // Main template
// ----------------------------------------------------------------
  
  #let conf(
  title: none,
author: (
  firstname: "",
  lastname: "",
  position: "",
  address: "",
  contacts: (),
),
profile-photo: "",
content,
) = {
  
  set document(
    title: title,
    author: author.firstname + " " + author.lastname,
  )
  
  set page(
    paper: "a4",
    margin: (top: 15mm, bottom: 15mm, left: 15mm, right: 15mm),
    footer: context [
      #set text(size: 8pt, fill: color-lightgray)
      #line(length: 100%, stroke: 0.5pt + color-lightgray)
      #v(0.2em)
      #justify-align(
      smallcaps[#author.firstname #author.lastname · CV],
        counter(page).display()
  )
      ],
  )
  
  set text(
    font: "Lato",
    size: 10pt,
    fill: color-teal,
    fallback: true,
  )
  
  set par(leading: 0.6em, justify: true)
  
  // Section Headings (Quarto H2 -> Typst Level 1)
  show heading.where(level: 1): it => {
    set block(breakable: false, above: 0.5em, below: 0.7em)
    stack(spacing: 1em)[
      #text(size: 13pt, weight: "bold", fill: color-teal)[#upper[#it.body]]
      #line(length: 100%, stroke: 1pt + color-lightest-teal)
      #v(0.4em)
    ]
  }
  
  // Style Subsection Titles (H3 in Quarto -> Level 2 in Typst)
  show heading.where(level: 2): it => {
    set block(above: 1.2em, below: 0.5em)
    set text(size: 11pt, weight: "bold", fill: color-teal)
    it.body // This "unwraps" the heading so our h(1fr) works properly
  }
  
  // Sub-subsections (Quarto H4 -> Typst Level 3)
  show heading.where(level: 3): it => {
    set block(above: 5em, below: 0.6em)
    text(size: 10pt, weight: "regular", fill: color-lightgray)[#it.body]
  }
  
  // Links
  show link: it => {
    text(fill: color-purple)[#it]
  }
  
  // Main Render
  make-header(author, profile-photo: profile-photo)
  v(1em)
  
  content
}