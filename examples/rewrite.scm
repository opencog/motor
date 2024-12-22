;
; rewrite.scm
;
(use-modules (ice-9 threads))
(use-modules (srfi srfi-1))
(use-modules (opencog) (opencog exec) (opencog sensory))

(cog-execute!
   (SetValue
      (Anchor "xplor") (Predicate "fsys")
      (Open (Type 'FileSysStream) (Sensory "file:///tmp"))))

(define fs-handle (ValueOf (Anchor "xplor") (Predicate "fsys")))

(cog-execute! (Write fs-handle (Item "ls")))

(define copy-in
	(Filter
		(Rule
			(Variable "$string-url")
			(LinkSignature (Type 'StringValue)
				(Variable "$string-url"))
			(Variable "$string-url"))
	 (Write fs-handle (Item "ls"))))

(define copy-in
	(Filter
		(Rule
			(Variable "$string-url")
			(LinkSignature (Type 'StringValue)
				(Variable "$string-url"))
			(LinkSignature (Type 'LinkValue)
				(Variable "$string-url")))
	 (Write fs-handle (Item "ls"))))



