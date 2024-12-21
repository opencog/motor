Crawler Design Notes
--------------------
This README ponders different design ideas for the crawler, and sketches
out the pros and cons of for various design decisions.

Crawl Representation
--------------------
Before looking at the crawler deign itself, its worth taking a quick
glance at the artifacts that will be produced. This will be a
representation of the file system in Atomese, along with properties
associated with those files.

A design goal here is to be relatively agnostic with regard to that
representation. Atomese allows for both deeply nested and very flat
representations of data. The nested representations correspond naturally
to hierarchical tree structures. However, flattened representations seem
to work better for high-performance algorithmic processing. A flattened
representation corresponds roughly to the idea of an
"[inode](https://en.wikipedia.org/wiki/inode)" in a unix file system.
The inode number itself need not be an integer. The desirable proerties
of an inode number are provided by a URL: It uniquely represents the
indicated object, and it can be computed without access to a central
URL-dispensing authority (its "decentralized").

Data-transformation Applets
---------------------------
As a general rule, the data available is not in the format that some
given algorithm wants it in. This is true not just in "real life" but in
Atomese as well. Thus, the successful deployment of algorithms requires
the use of data-transforming applets ("transformers") that can accept
data in one format, and convert it to another format.

In "real life", 

Such converters have an input, and an output. The format of the input
and the output need to be deescribed in machine-readable terms. There
also needs to be an algorithm that can connect an input to an output, to
build a functoing machine.
