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

In "real life", you ask a programmer, admin or DBA to do this for you.
This clearly is the wrong answer in the present case.

Such converters have an input, and an output. The format of the input
and the output need to be described in machine-readable terms. There
also needs to be an algorithm that can connect an input to an output, to
build a functioning machine. The design of such a system is the topic
of the [Sensory project](https://github.com/opencog/sensory). At any
rate, it is challenging, and presents both conceptual issues, and
practical problems w.r.t. performance.

Directory Listing
-----------------
To obtain a directory listing, one must `cd` to the directory, open it,
and then iterate over contents. Lets assume the `cd` step is completed,
and that we have a handle to the location. Lets assume the handle is of
the form
```
   (ItemNode "/some/location/some/where")
```
The string in the above node acts as an inode: it's opaque to the user,
but meaningful to the directory lister. Instead of slashes, it might
have dots (as in python modules locations) or blank spaces (as in many
command-line tools, where subcommands are separated by spaces). There
may be dashes (single dashes or double-dashes, used to pass flags,
options, parameters to some command-line tool.) Thus:
```
   (ItemNode "ceph --cluster enfield config set mgr.fanny debug_mgr 0/5")
   (ItemNode "from sys import foo.bar.baz")
	(ItemNode "47e2d7bd-e3ea-4338-bb47-78ffe9efec65")
```
are all interpretable as locations within some hierarchihcal tree, and
the proper semantics & decoding of "what it means" is left to the module
that knows how to walk the system.

The attitude being taken here is similar to that of Plan9, where
"everything is a file", except here, "everything is a filepath" and
"we dont know what that filepath string means".

Step one: open the location. How?
```
   (cog-execute! (Open (ItemNode "/whatever")))
```


