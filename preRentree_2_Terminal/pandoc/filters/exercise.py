#!/usr/bin/env python3

"""
Pandoc filter to convert divs with class="exercise" to LaTeX
exercise environments in LaTeX output, and to numbered exercises
in HTML output.
"""

from pandocfilters import toJSONFilter, RawBlock, Div
import sys

exercisecount = 0
showcorrection = None


def latex(x):
    return RawBlock('latex', x)


def html(x):
    return RawBlock('html', x)


def exercises(key, value, format, meta):
    global showcorrection
    if showcorrection is None:
        showcorrection = ("correction" in meta 
                          and meta["correction"]["c"])
    if key == 'Div':
        [[ident, classes, kvs], contents] = value
        if "exercise" in classes:
            if format == "latex":
                if ident == "":
                    label = ""
                else:
                    label = '\\label{' + ident + '}'
                d = dict(kvs)
                if "title" in d:
                    title = '[' + d["title"] + ']'
                else:
                    title=''
                return([latex('\\begin{exercice}' + title + label)]
                       + contents
                       + [latex('\\end{exercice}')])
            elif format == "html" or format == "html5":
                global exercisecount
                exercisecount = exercisecount + 1
                heading = '<p><strong>Exercice ' + str(exercisecount) + ' :</strong>'
                d = dict(kvs)
                if "title" in d:
                    heading += " " + d["title"]
                heading += '</p>'
                newcontents = [html(heading)] + contents
                return Div([ident, classes, kvs], newcontents)
        if "correction" in classes:
            if not showcorrection:
                return []
            if format == "latex":
                return([latex('\\begin{correction}')] + contents +
                       [latex('\\end{correction}')])
            elif format == "html" or format == "html5":
                newcontents = [html('<p><em>Correction :</em></p>')] + contents
                return Div([ident, classes, kvs], newcontents)

if __name__ == "__main__":
    toJSONFilter(exercises)
