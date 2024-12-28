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

		; Pass through the raw StringValues
		; (don't do any rewrites)
		(Variable "$string-url")))

; Wire in the rule defined above to the crawler source.
(define dir-filter
	(Filter
		dir-only-filter-rule
		(Write fstream-observer (Item "special"))))

; Try it
(cog-execute! dir-filter)

;------------------------------------------------------------------
; Explore two levels deep

; Accept any list of StringValue; assume that they hold the names of
; directory entries. Apply a rewrite that opens a corresponding file
; stream.
(define open-rule
	(Rule
		(VariableNode "$dirent")
		(VariableNode "$dirent")

		; Rewrite the directory into a SensoryNode,
		; then open it. Then get the directories in it.
		(Write
			(Open (Type 'FileSysStream)
				(StringOfLink (Type 'SensoryNode)
					(Variable "$dirent")))
			(Item "special"))))

(define dir-filter2
	(Filter open-rule dir-filter))

;------------------------------------------------------------------
; Get all directories in a directory.
; The above two stanzas split out directory processing into
; several steps, chaining together several filters. These can also be
; combined into one creating a more compact rewrite.

(define explore-dirs
	(Rule
		(Variable "$string-url")

		; Accept only directories
		(LinkSignature (Type 'LinkValue)
			(Variable "$string-url")
			(StringOf (Type 'StringValue) (Node "dir")))

		; Rewrite the directory into a SensoryNode,
		; then open it. The get the special-file tags on it.
		(Write
			(Open (Type 'FileSysStream)
				(StringOfLink (Type 'SensoryNode)
					(Variable "$string-url")))
			(Item "special"))))

(define dir-filter3
	(Filter explore-dirs
		(Write fstream-observer (Item "special"))))

; Up to this point, the demo has been relatively straight-forward. At
; this point, though, the confusion begins. In the above, how does one
; know that the `explore-dirs` rule is getting arguments of the correct
; kind? This takes a bit of mental effort and double-checking. Playing
; with the guile REPL, run `(cog-execute! (Write fstream-observer ...))`
; and verify that what is printed can be pattern-matched by the input
; (acceptance) pattern to `explore-dirs`. But this takes some focus and
; concentration.
;
; This is a problem. Atomese was never meant to be a human-friendly
; programming environment; it was meant to be algorithm-friendly.
; But debuggability is an issue. This is why Sensory has a focus on
; connections and connection types: the connection types help verify
; valid connections. But even then, this shifts the issue to a
; different location. The difficulty of understanding what the above
; does is a real problem, even though what it does is nearly trivial
; in any conventional programing language: its just a directory listing,
; two levels down. Dealing with this is an open, unsolved problem.
;
;------------------------------------------------------------------
; loop-de-loop.
; The `explore-dirs` rule above was written to accept a directory
; listing as input, and then enter each subdir, and create a directory
; listing for that. Since it outputs the same format of data as it
; accepts as input, it is ready-made to be used in a recursive fashion.
; This part of the demo shows this.
;
; To wire the output of the rule back to the input, the most direct
; solution is to place initial data at a fixed memory location, and then
; run the rule, uptating the location with each iteration. The
; "location" here is just some Atom and some Key indicating a Value
; stored there. The first part of the demo is simply to seed an
; initial value at that location.

; Designate the directory to be crawled
(define sense-root (Sensory "file:///tmp"))

; Set starting location. The crawler expects a directory name, tagged
; with a file-type. The easiest way to get this is to just ask for it.
; The alternative is to hand-jigger an appropriate form, which is OK,
; but defeats the idea of only using pure Atomese and the sensory API.
(define (set-initial-root fsys-root)
	(SetValue (Anchor "crawler") (Predicate "looper")
		(Write
			(Open (Type 'FileSysStream) fsys-root)
			(List (Item "special") fsys-root))))

; Actually set it.
(cog-execute! (set-initial-root (Sensory "file:///tmp")))

; The looper location. Executing this will reveal what the focus is.
(define looper-loc (ValueOf (Anchor "crawler") (Predicate "looper")))

; Wrap the `explore-dirs` such that it reads a listing at `looper-loc`,
; descends into the subdirs, and then updates the list at `looper-loc`.
(define looper
	(SetValue
		(Anchor "crawler") (Predicate "looper")
		(Concatenate
			(Filter explore-dirs looper-loc))))

; Run the step once, and only once.
(cog-execute! looper)

; Run it again. Repeat till satsified that directories are being
; explored.
(cog-execute! looper)

; Reset the root, as desired.
(cog-execute! (set-initial-root (Sensory "file:///tmp")))

;------------------------------------------------------------------
; To be truly recursive, the single-step execution needs to be placed in
; a loop. Atomese does not define any kind of "loop until done" Atom.
; Perhaps it should? However, a tail recursive loop can be written in
; stock Atomese. This is shown here.

; First, define a predicate that will halt the tail-recursion.
; Recall looper-loc is defined above: its where the current directory
; listing is held. The `SizeOf` atom merely looks at its current size.
(Define (DefinedPredicate "keep going?")
	(GreaterThan (SizeOf looper-loc) (Number 0)))

; Try it. Recall (stv 0 1) is false, and (stv 1 1) is true.
(cog-evaluate! (DefinedPredicate "keep going?"))

; Define a tail-recursive loop.
; The only "tricky part" is the `(True looper)` clause. This executes
; the looper step, and then returns true, so that the SequentialAnd
; sequences to the next step.
(Define
   (DefinedPredicate "My tail-recursive loop")
   (SequentialAnd
      (DefinedPredicate "keep going?")
		(True looper)
      (DefinedPredicate "My tail-recursive loop")
   ))

; Run it. This is unexciting: it sits there a while, and then stops.
; to prove that something happened, we can either insert a print
; statement into the loop, or create some side effects, such as dumping
; the directory listing into AtomSpace. This is done next.
(cog-evaluate! (DefinedPredicate "My tail-recursive loop"))

; BTW: if you plan to change the DefinedPredicate, you have to delete it
; first. This is because `DefineLink` does not allow multiple
; definitions. Deleting means extracting from the AtomSpace, like so:
(cog-extract-recursive! (DefinedPredicate "My tail-recursive loop"))

;------------------------------------------------------------------
;------------------------------------------------------------------

; The files are now searchable as conventional atoms.
(define query
	(Meet
		(TypedVariable (Variable "$someplace") (Type 'ItemNode))
		(Edge (Predicate "URL") (Variable "$someplace"))))

(cog-execute! query)
