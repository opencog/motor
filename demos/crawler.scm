;
; crawler.scm -- crawler demo
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
			(LinkSignature (Type 'StringValue)
				(Variable "$string-url"))

			; The rewrite.
			(Edge
				(Predicate "URL")
				(StringOfLink (Type 'ItemNode)
					(Variable "$string-url"))))
	 (Write fs-handle (Item "ls"))))

; Try it.
(cog-execute! copy-in)

; The directory entries are now searchable as conventional atoms.
(define query
	(Meet
		(TypedVariable (Variable "$someplace") (Type 'ItemNode))
		(Edge (Predicate "URL") (Variable "$someplace"))))

(cog-execute! query)
