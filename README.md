Sensori-Motor Research
======================
Conventional machine-learning systems are force-fed data by a collection
of scripts and control panels; they "data process" and "machine learn"
for a while, using up CPU time, and eventually producing some answer
that some customer, client or user wanted. This kind of forced
processing is the modern variant of what used to be called "batch
processing". The obvious industrial alternative is continuous-flow
processing. A canonical example might be the self-driving car: it gets
continuous data from a variety of sensors, synthesizes that data, and
arrives at "real-time", millisecond-by-millisecond motor-control
decisions.

Smart engineers have no problem creating both batch and continuous-flow
systems. Its a standard engineering task pervasive in industry, from
baking bread to creating plastics. It's, well, "obvious". Like all good
things that are obvious, it can be made the topic of research, and so
here we are.

This is part of a research program that includes the following
[Opencog](https://github.com/opencog/) projects:
* [Sensory](https://github.com/opencog/sensory)
* [Agents](https://github.com/opencog/agents)

Caution
-------
What you will read below will seem, at first blush, so painfully obvious
that it must surely be moronic and deranged. Or perhaps some sophomoric
high-school project. You can stop reading right now, if you wish.

The reality is that this has never been done before (as best as I know)
and I've got a PhD in theoretical physics and decades of computer
industry experience. And I've bee doing AI some large chunk of that.
And I'm not crazy. Trust me: it seems simplistic and obvious because
I'm trying to understand how certain simplistic and obvious things
actually work. So that they can be deployed in a generic AGI framework.
Alas.  Here we go.

Proof of Concept
----------------

Status
------
* '''Version 0.0.0''' - Basic design is being developed.
