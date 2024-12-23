;
; crawler.scm -- crawler demo
;
; Pre-requisites: study the AtomSpace example
; `examples/pattern-matcher/filter-value.scm`
;
(use-modules (srfi srfi-1))
(use-modules (opencog) (opencog exec) (opencog sensory))

; Open stream
(cog-execute!
   (SetValue
      (Anchor "xplor") (Predicate "fsys")
      (Open (Type 'FileSysStream) (Sensory "file:///tmp"))))

(define fs-handle (ValueOf (Anchor "xplor") (Predicate "fsys")))

(define copy-in
	(Filter
		(Rule
			(Variable "$string-url")
			(LinkSignature (Type 'LinkValue)
				(Variable "$string-url")
				(LinkSignature (Type 'StringValue)
					(Node "reg")))

			; The rewrite.
			(Edge
				(Predicate "fURL")
				(StringOfLink (Type 'ItemNode)
					(Variable "$string-url"))))
	 (Write fs-handle (Item "special"))))

; Try it.
(cog-execute! copy-in)

; The directory entries are now searchable as conventional atoms.
(define query
	(Meet
		(TypedVariable (Variable "$someplace") (Type 'ItemNode))
		(Edge (Predicate "URL") (Variable "$someplace"))))

(cog-execute! query)
