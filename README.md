# Flowsheet

A flowchart/spreadsheet hybrid, where connections are front-and-centre, rather than tabular cells.

There are **Nodes**, and **Links**. Links have a formula associated to them, that manipulates the incoming and destination data. Nodes can be a few different types - currently just `bool`, `int`, `float`, `string`.

Currently, you can create nodes, move them around, link them with other, edit links' formulae, and see the results of the inputs and functions. You can save and load flowsheet files.

## Roadmap

Still to come are several large project-breaking features. I'm not sure when they'll happen, if they'll happen. Some of these include:

  - Re-ordering incoming links to a node
  - A new language for link formulae (one that's sandboxed and made for flowsheet)
  - Styling for flowsheets, allowing for changing the size and appearance of nodes and links
  - Undo/Redo of actions
  - Exporting flowsheets to html/css/js (Maybe?)
  - UI for adding nodes
  - Keyboard shortcuts for all/most actions
  - Documentation for this project
  - Documentation for link formulae
  - Resizing the sheet
  - Importing a sheet into another sheet
  - Grouping nodes and moving them together
  - A scripting language (lua/python/ruby/something custom) for manipulating sheets automatically
  - In-sheet buttons to execute scripts? (Allowing for dynamic sheets!)
