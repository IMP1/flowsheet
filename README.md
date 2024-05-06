# Flowsheet

## Quick Links

  - [Installation](https://github.com/IMP1/flowsheet/wiki/Installation)
  - [Flowsheet Usage](https://github.com/IMP1/flowsheet/wiki/Basic-Usage)
  - [Flowsheet Link Formula Language](https://github.com/IMP1/flowsheet/wiki/Links#formulae)
  - [Flowsheet Scripting Language](https://github.com/IMP1/flowsheet/wiki/Scripting)

## About

[[https://github.com/IMP1/flowsheet/wiki/images/simple_project_edit_view.png|Flowsheet project example, showing several expense nodes and a node showing their sum]]

A flowchart/spreadsheet hybrid, where connections are front-and-centre, rather than tabular cells.

Coming from Spreadsheets, instead of **Cells**, we have both **Nodes**, and **Links**. 
Links have a formula associated to them, that can manipulate the incoming and destination data. 

Nodes primarily hold data, and can be a few different types. Currently these include:

  - Switch (Boolean / On-Off)
  - Integers (Whole Numbers)
  - Decimals (Floats, Real numbers)
  - Percentages (Same as Decimals, but controlled with a slider between 0% and 100%)
  - Text (Strings)
  - Button (Same as Switch, but needs to be held down by the user to be on/true)

There is an EDIT mode, where you can add nodes and links, and set the initial values of nodes, and the formulae of links.
There is a STYLE mode, where you can set how the nodes and links look.
And there is a TEST mode, where you can try out your flowsheet without accidentally changing anything.

There is a scripting language you can use in the console.

## Roadmap

There are still some pretty fundamental features that are not yet implemented. These include:

  - Re-ordering incoming links to a node
  - Undo/Redo of actions
  - Resizing the sheet
  - Grouping nodes and moving them together
  - Exporting flowsheets to html/css/js (Maybe?)
  - Datetime Node types
  - Enum Node types
  - Some Collection Node types (Arrays?) - Not sure yet what this would look like

## Credits

  - [Material Icons](https://fonts.google.com/icons)
  - [Godot Lua API](https://luaapi.weaselgames.info/v2.1/)
  - [Lua](https://www.lua.org)
  - [Godot](https://godotengine.org)
