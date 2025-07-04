#!/usr/bin/env python3

import sys
import json
from lark import Lark, Tree, Token


def tree_to_dict(tree):
    if isinstance(tree, Tree):
        return {
            "type": tree.data,
            "children": [tree_to_dict(child) for child in tree.children],
        }
    elif isinstance(tree, Token):
        return {"type": "token", "value": str(tree), "token_type": tree.type}


if len(sys.argv) != 2:
    print(f"Usage: {sys.argv[0]} <input_file>")
    sys.exit(1)

input_filename = sys.argv[1]

# Load grammar from file
with open("grammar.lark") as grammar_file:
    grammar = grammar_file.read()

# Create parser
parser = Lark(
    grammar,
    start="program",
)

# Load input text
with open(input_filename) as input_file:
    text = input_file.read()

# Parse text
parse_tree = parser.parse(text)


# Convert and print tree as JSON
tree_json = tree_to_dict(parse_tree)
print(json.dumps(tree_json, indent=2))
