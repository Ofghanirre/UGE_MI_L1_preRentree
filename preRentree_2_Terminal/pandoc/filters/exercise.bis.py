#!/usr/bin/env python3

"""
Pandoc filter to convert headers with class "exo" to LaTeX
exercise environments in LaTeX output, and to numbered exercises
in HTML output.
"""

from pandocfilters import walk, RawBlock, Header, stringify, Null
import sys
import json
import io

exercisecount = 0
showcorr = None
ignore = False

exo_level = 0
corr_level = 0


def latex(x):
    return RawBlock('latex', x)


def html(x):
    return RawBlock('html', x)


def exercises(key, value, format, meta):
    global exo_level, showcorr, corr_level, ignore
    if showcorr is None:
        showcorr = ("correction" in meta 
                          and meta["correction"]["c"])
    res = []
    if key == "Null":
        if corr_level:
            corr_level = 0
            if showcorr:
                res.append(latex('\\end{mdframed}'))
            else:
                ignore = False
        if exo_level:
            exo_level = 0
            res.append(latex('\\end{exercice}'))
        return res
    if key == "Header":
        level, attr, contents = value
        ident, classes, kws = attr
        res = []
        if level <= corr_level:
            if showcorr:
                res.append(latex('\\end{mdframed}'))
            else:
                ignore = False
            corr_level = 0
        if level <= exo_level:
            res.append(latex('\\end{exercice}'))
            exo_level = 0
        if 'exo' in classes:
            exo_level = level
            res.append(latex('\\begin{exercice}['
                + stringify(contents[:])
                + ']\\label{exo:' + ident + '}'))
        elif 'corr' in classes and level >= exo_level:
            corr_level = level
            if showcorr:
                res.append(latex('\\begin{mdframed}[backgroundcolor=black!5,frametitle={\small Correction}]\small'))
            else:
                ignore = True
        else:
            res.append(Header(level, attr, contents))
        return res
    if ignore:
        return []


def applyJSONFilters(actions, source, format=""):
    """Walk through JSON structure and apply filters
    This:
    * reads a JSON-formatted pandoc document from a source string
    * transforms it by walking the tree and performing the actions
    * returns a new JSON-formatted pandoc document as a string
    The `actions` argument is a list of functions (see `walk`
    for a full description).
    The argument `source` is a string encoded JSON object.
    The argument `format` is a string describing the output format.
    Returns a the new JSON-formatted pandoc document.
    """

    doc = json.loads(source)

    if 'meta' in doc:
        meta = doc['meta']
        doc['blocks'].append(Null())  # mark the end
    elif doc[0]:  # old API
        meta = doc[0]['unMeta']
        doc[1].append(Null())  # mark the end
    else:
        meta = {}
    altered = doc
    for action in actions:
        altered = walk(altered, action, format, meta)

    return json.dumps(altered)


if __name__ == "__main__":

    actions = [exercises]

    input_stream = io.TextIOWrapper(sys.stdin.buffer, encoding='utf-8')
    source = input_stream.read()

    if len(sys.argv) > 1:
        format = sys.argv[1]
    else:
        format = ""

    doc = json.loads(source)

    sys.stdout.write(applyJSONFilters(actions, source, format))

    #toJSONFilter(exercises)
