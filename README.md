# xmlauthor An XHTML Authoring System for Academic and Technical Writers

Andrew A. Cashner, `andrew@andrewcashner.com`

April 2024

## Features

### Basically XHTML
- If you can write a web page you can use this system
- Does not reinvent the wheel
- Semantic but not too fussy: You can think about what you mean without having
  to look everything up in a complex schema like in TEI

### Flexible and convertible
- Avoids the format lock-in of LaTeX or word processors
- Converts to LaTeX, PDF, and HTML by default 

### Automatic citation and bibliography creation: 
- Using a single BibLaTeX database, just type `<citation key="author:year" />`
  and have properly formatted author-date parenthetic citations and
  automatically generated bibliography in all output formats

### Automatic handling of "floats" like figures, tables, examples, diagrams
- Automatic numbering of tables, etc.
- Automatic cross-references for floats:
    - Just type `<ref type="table" href="#tab:demo" />`

### Simple, minimal-computing setup:
- You only need Make and the Saxon XSLT processor
- For PDF output you need a LaTeX installation

## License

Copyright © 2024 Andrew A. Cashner.

This software is made available under the MIT License.
