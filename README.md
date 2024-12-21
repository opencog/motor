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

The Task
--------
The task is to crawl some file system, collect some data about it,
perform some measurements on that data, including structural similarity,
use those results to look a second time, and gather and process what
was missed the first time.

A file system is chosen because it is one of the simplest data
structures that is not trivial. File systems can be thought of as trees,
and quite a a lot of human-generated societal data is organized in a
hierarchical fashion. So, the first task of writing a file-system
crawler now becomes non-trivial: it should be able to crawl any kind of
hierarchical structure.

There are several design choices. One is to pre-process this "input
hierarchical data" into a tree format that is machine-readable, and
deploy the analysis program on it. This design choice is rejected out of
hand, for multiple reasons:
* It requires a batch-processing step, whereas this line of research
  is interested in continuous-process systems.
* There is a risk of data loss in the conversion from this other format
  into some pre-defined input format. Data conversion is a pain in the
  neck; ask anyone with business software experience. Something is
  always lost in the process. There are multi-billion dollar
  corporations specializing in data conversion. There is no desire to
  enter that competitive landscape.
* It requires knowing, in advance, what aspects of the data are
  "important". This is counter-productive to the task of AGI learning,
  where the importance of some data element is not known, a priori.
  Note the last sentence says "AGI learning" and not "machine learning";
  in machine learning, the engineers usually already have a pretty
  good grasp of what they are looking for, and what they expect to get.
  In AGI, we don't know. For AGI, the task is "here's a blob of stuff,
  look at it, and figure it out."

Thus, one aim of this project is to build a proof-of-concept crawler
that can walk a collection of hierarchical structures, in the abstract,
using a low-level API, perhaps similar to the unix commands `cd` and
`ls`, and perhaps with some `open` and `close` as the walk is being
performed.


Status
------
* '''Version 0.0.0''' - Basic design is being developed.
