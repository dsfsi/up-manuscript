-- Every value in this config file can be plain TeX
-- (naturally, this exclude the "includes" list which is a listing
-- of files to include in final the document)

-- Author of the work
author = "Joseph Thomas Bloggs"

-- Author email address
email = "jtbloggs@somewhere.co.za"

-- Basic document title
title = "A Very Long Title that is a Long Title"

-- The large title is for display on the cover page of the document
-- This should match the content of `title`, however, it may be required
-- to add some newline breaks to make sure the cover page title looks
-- appealing. This is a multi-line string between the square bracket pair
large_title = [[
  A Very Long Title\\
  With a Long Title
]]

-- Name of the institution
institution = "Institution / University / or Similar"

-- Name of the faculty
faculty = "Faculty of Doing Things"

-- Name of the department
department = "Department of department"

-- Location of the institution
location = "Place of things"

-- The list of files to include for the abstract. This is usually a
-- single file, but more can be specified, if needed.
-- NOTE: The order of the list matters.
abstract_includes =
   { "content/abstract.tex"
   }

-- The list of file to include in the document creation. This list
-- will be included verbatim. That is, the order of the list items
-- does matter.
main_includes =
   {
   }

appendix_includes =
   { "content/appendix.tex"
   }

glossary_includes =
   { "content/glossary.tex"
   , "content/acronyms.tex"
   }

-- These are the package options passed to biblatex.
-- Any bibliography related options should be defined here. It should
-- also be noted that the backend option has already been set to
-- the package "biber".
--
-- biblatex is strictly the replacement for the normal bibtex process
-- and you are encouraged to familiarize yourself with the way biblatex
-- operates. It is largely unchanged from a usage perspective, but any
-- customization will be done in a different way
--
-- The old classic bibtex styles (like 'plain') are still available using
-- the biblatex-trad package. For example, the old plain is now 'trad-plain'
bibliography_options = "style=numeric"

-- List of bibliography files
bibliography_includes =
   { "content/bibliography.bib"
   }

degree = {
   msc = {
      degree_name = "Master of Science (Computer Science)",
      document = "Master's dissertation"
   },

   phd = {
      degree_name = "Philosophiae Doctor (Computer Science)",
      document = "Philosophiae Doctor thesis"
   }
}

article = {
   ieee = {
      mode = "conference",
      paper = "letterpaper",
      column = "twocolumn",
      keywords = ""
   },

   llncs = {
   }
}

document = article.ieee --degree.msc
