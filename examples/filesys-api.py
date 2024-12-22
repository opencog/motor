#! /usr/bin/env python3
#
# filesys-api.py
#
# Most Atomese work is done in scheme. This particular demo ensures that
# concepts expressed in scheme also work in python. This is needed,
# because many programmers are more comfortable with python.
#
# This file is a port of the first part of the `filesys.scm` demo from
# the `Sensory` project examples.

from opencog.atomspace import AtomSpace
from opencog.type_constructors import *
from opencog.sensory import *
from opencog.exec import execute_atom

space = AtomSpace()
push_default_atomspace(space)

print("Created an AtomSpace")

# Stub to cut down on typing. Not sure why the AtomSpace does not
# provide this by default.
def execute(atm) :
	return execute_atom(get_default_atomspace(), atm)

# Open the filesystem node, thus creating a stream, and anchor the
# stream somewhere where we can find it.
execute(
	SetValueLink(
		AnchorNode("xplor"),
		PredicateNode("fsys"),
		OpenLink(
			TypeNode("FileSysStream"),
			SensoryNode("file:///tmp"))))

print("Opened a filesystem stream")

pwd = execute(
	WriteLink(
		ValueOfLink(
			AnchorNode("xplor"),
			PredicateNode("fsys")),
		ItemNode("pwd")))
