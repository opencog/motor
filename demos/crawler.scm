;
; crawler.scm -- crawler demo
;
; Pre-requisites: study the AtomSpace examples
; `examples/pattern-matcher/filter-value.scm`
; `examples/pattern-matcher/filter-strings.scm`
;
(use-modules (srfi srfi-1))
(use-modules (opencog) (opencog exec) (opencog sensory))

; A file-system observer. Executing this will open the stream.
(define fstream-observer
	(Open (Type 'FileSysStream) (Sensory "file:///tmp")))

; Location where we will put the bottom-level observer.
; Optional, we don't really need this, but perhaps its
; convenient for ... ??? something ???
(define fstream-loc (ValueOf (Anchor "crawler") (Predicate "filestream")))

; Associate the observer with the above location.
; Optional, we don't really need this, but perhaps its
; convenient for ... ??? something ???
; Executing this will cause the stream to be opened,
; and placed at the given location.
(define fstream-trigger
	(SetValue
		(Anchor "crawler") (Predicate "filestream")
		fstream-observer))

; Open the stream, and actuall place it at the location.
; Optional We don't need to do this yet (or at all).
(cog-execute! fstream-trigger)

; The (Item "special") on the FileSys stream marks the files in the
; stream with the file-type. This is "reg" for regular files, "dir"
; for directories, and yet other types for fifos, sockets, char and
; block devs. The rule below accepts only regular files, and records
; the corresponding URL in the AtomSpace.
;
; I think that this rule is strict enough that it does nothing if it
; is fed garbage of the wrong type. But it also does not do anything
; special to avoid garbage: it it is attached incorrectly, it will do
; the usual "garbage in, garbage out" dance.
(define record-regular-file-url
	(Rule
		(Variable "$string-url")

		; Accept only regular files
		(LinkSignature (Type 'LinkValue)
			(Variable "$string-url")
			(StringOf (Type 'StringValue) (Node "reg")))

		; Just tag the path as being a URL
		(Edge
			(Predicate "URL")
			(StringOfLink (Type 'ItemNode)
				(Variable "$string-url")))))

; Wire in the rule defined above to the crawler source.
(define get-regular-files
	(Filter
		record-regular-file-url
		(Write fstream-observer (Item "special"))))

; Copy the names of the regular files into the AtomSpace
; executing this runs the chain of sensory nodes and filters
; defined above. We don't need to run this yet, but why not?
(cog-execute! get-regular-files)

(cog-execute!
   (SetValue
      (Anchor "crawler") (Predicate "reg-files")
		get-regular-files))

; Try it.
(cog-execute! get-regular-files)


; The directory entries are now searchable as conventional atoms.
(define query
	(Meet
		(TypedVariable (Variable "$someplace") (Type 'ItemNode))
		(Edge (Predicate "URL") (Variable "$someplace"))))

(cog-execute! query)
