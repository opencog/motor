#! /usr/bin/env python3
#
# filesys-api.py
#
# Most Atomese work is done in scheme. This particular demo ensures that
# concepts expressed in scheme also work in python. This is needed,
# because many programmers are more comfortable with python.

from opencog.atomspace import AtomSpace
from opencog.type_constructors import *
from opencog.sensory import *


space = AtomSpace()
push_default_atomspace(space)



