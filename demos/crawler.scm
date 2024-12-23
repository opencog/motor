;
; crawler.scm -- crawler demo
;
; Pre-requisites: study the AtomSpace examples
; `examples/pattern-matcher/filter-value.scm`
; `examples/pattern-matcher/filter-strings.scm`
;
(use-modules (srfi srfi-1))
(use-modules (opencog) (opencog exec) (opencog sensory))

; Open stream
(cog-execute!
   (SetValue
      (Anchor "xplor") (Predicate "fsys")
      (Open (Type 'FileSysStream) (Sensory "file:///tmp"))))

(define fs-handle (ValueOf (Anchor "xplor") (Predicate "fsys")))

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
		(Write fs-handle (Item "special"))))

; Try it.
(cog-execute! get-regular-files)


; The directory entries are now searchable as conventional atoms.
(define query
	(Meet
		(TypedVariable (Variable "$someplace") (Type 'ItemNode))
		(Edge (Predicate "URL") (Variable "$someplace"))))

(cog-execute! query)
