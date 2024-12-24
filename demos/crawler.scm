;
; crawler.scm -- crawler demo
;
; Pre-requisites: study the AtomSpace examples
; `examples/pattern-matcher/filter-value.scm`
; `examples/pattern-matcher/filter-strings.scm`
;
(use-modules (srfi srfi-1))
(use-modules (opencog) (opencog exec) (opencog sensory))

;------------------------------------------------------------------
; The crawler attentional focus is a location (in the file system)
; to which the cralwer will be paying attention to.
(define crawler-focus
	(SetValue
		(Anchor "crawler") (Predicate "focus")
		(Sensory "file:///tmp")))

; Executing it "makes it so": it places the focus-point at a
; "well-known place" where everyone can find it.
(cog-execute! crawler-focus)

; The focus location. Executing this will reveal what the focus is.
(define focus-loc (ValueOf (Anchor "crawler") (Predicate "focus")))

; Try it.
(cog-execute! focus-loc)

; A file-system observer. Executing this will open the stream.
(define fstream-observer
	(Open (Type 'FileSysStream) focus-loc))

;------------------------------------------------------------------
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

; Wire in the rule defined above to the stream source.
(define get-regular-files
	(Filter
		record-regular-file-url
		(Write fstream-observer (Item "special"))))

; Copy the names of the regular files into the AtomSpace
; executing this runs the chain of sensory nodes and filters
; defined above. We don't need to run this yet, but why not?
(cog-execute! get-regular-files)

;------------------------------------------------------------------
; The above pipleline is independent of the focus location.
; Lets change focus, and verify.

(cog-execute!
	(SetValue
		(Anchor "crawler") (Predicate "focus")
		(Sensory "file:///etc")))

; Try it.
(cog-execute! get-regular-files)

;------------------------------------------------------------------
; Like above, but this time, look only for directories.
(define dir-only-filter-rule
	(Rule
		(Variable "$string-url")

		; Accept only directories
		(LinkSignature (Type 'LinkValue)
			(Variable "$string-url")
			(StringOf (Type 'StringValue) (Node "dir")))

		; Rewrite the directory into a SensoryNode
		(StringOfLink (Type 'SensoryNode)
			(Variable "$string-url"))))

; Wire in the rule defined above to the crawler source.
(define dir-filter
	(Filter
		dir-only-filter-rule
		(Write fstream-observer (Item "special"))))

; Try it
(cog-execute! dir-filter)

;------------------------------------------------------------------
; Two deep

(define dir-observer
	(Open (Type 'FileSysStream) dir-filter))

(define dir-filter2
	(Filter
		dir-only-filter-rule
		(Write dir-observer (Item "special"))))


;------------------------------------------------------------------

; The files are now searchable as conventional atoms.
(define query
	(Meet
		(TypedVariable (Variable "$someplace") (Type 'ItemNode))
		(Edge (Predicate "URL") (Variable "$someplace"))))

(cog-execute! query)
