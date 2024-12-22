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

# Create a handle by which we can reference the stream.
anchor = ValueOfLink(
	AnchorNode("xplor"),
	PredicateNode("fsys"))

# Perform some operations on the stream.
pwd = execute(WriteLink(anchor,  ItemNode("pwd")))
print("The current directory is", pwd)

dentries = execute(WriteLink(anchor,  ItemNode("ls")))
print("The directory entries are", dentries)
