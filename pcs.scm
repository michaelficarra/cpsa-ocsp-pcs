(defprotocol two-party-ocs basic

	; everyone obeys the main protocol
	(defrole optimistic-init
		(vars (a b t name) (m text))
		(trace
			; initial pcs exchange
			(send (enc m a b t (privk "pcs" a)))
			(recv (enc m b a t (privk "pcs" b)))
			; exchange publicly verifiable signatures
			(send (enc m a b t (privk "sign" a)))
			(recv (enc m b a t (privk "sign" b)))
		)
	)
	(defrole optimistic-resp
		(vars (a b t name) (m text))
		(trace
			; initial pcs exchange
			(recv (enc m a b t (privk "pcs" a)))
			(send (enc m b a t (privk "pcs" b)))
			; exchange publicly verifiable signatures
			(recv (enc m a b t (privk "sign" a)))
			(send (enc m b a t (privk "sign" b)))
		)
	)


	; after A sends an initial pcs, B stops communicating
	(defrole resp-quits-a
		(vars (a b t name) (m text))
		(trace
			(send (enc m a b t (privk "pcs" a)))
			; B quits
		)
	)
	(defrole resp-quits-b
		(vars (a b t name) (m text))
		(trace
			(recv (enc m a b t (privk "pcs" a)))
			; quit
		)
	)


	; after PCS exchange, A aborts and then B quits
	(defrole init-aborts-resp-quits-a
		(vars (a b t name) (m text))
		(trace
			; initial pcs exchange
			(send (enc m a b t (privk "pcs" a)))
			(recv (enc m b a t (privk "pcs" b)))
			; perform an abort with T
			(send (enc (enc m a b "abort" (privk a)) (pubk t)))
			(recv (enc (enc m a b "abort" (privk a)) (privk t)))
		)
	)
	(defrole init-aborts-resp-quits-b
		(vars (a b t name) (m text))
		(trace
			; initial pcs exchange
			(recv (enc m a b t (privk "pcs" a)))
			(send (enc m b a t (privk "pcs" b)))
			; not shown: A performs an abort with T
			; quit
		)
	)
	(defrole init-aborts-resp-quits-t
		(vars (a b t name) (m text))
		(trace
			; A sent an abort request
			(recv (enc (enc m a b "abort" (privk a)) (pubk t)))
			(send (enc (enc m a b "abort" (privk a)) (privk t)))
		)
	)


	; after pcs exchange, A aborts and B attempts to resolve, but T responds with an aborted message
	(defrole init-aborts-resp-resolves-a
		(vars (a b t name) (m text))
		(trace
			; initial pcs exchange
			(send (enc m a b t (privk "pcs" a)))
			(recv (enc m b a t (privk "pcs" b)))
			; perform an abort with T
			(send (enc (enc m a b "abort" (privk a)) (pubk t)))
			(recv (enc (enc m a b "abort" (privk a)) (privk t)))
		)
	)
	(defrole init-aborts-resp-resolves-b
		(vars (a b t name) (m text))
		(trace
			; initial pcs exchange
			(recv (enc m a b t (privk "pcs" a)))
			(send (enc m b a t (privk "pcs" b)))
			; not shown: A performs an abort with T
			; attempt resolution with T
			(send (enc m a b t (privk "pcs" a)) (enc m b a t (privk "sign" b)))
			; failed resolution, session already aborted
			(recv (enc (enc m a b "abort" (privk a)) (privk t)))
		)
	)
	(defrole init-aborts-resp-resolves-t
		(vars (a b t name) (m text))
		(trace
			; A sent an abort request
			(recv (enc (enc m a b "abort" (privk a)) (pubk t)))
			(send (enc (enc m a b "abort" (privk a)) (privk t)))
			; B tries to resolve
			(recv (enc m a b t (privk "pcs" a)) (enc m b a t (privk "sign" b)))
			; but we send him an aborted message
			(send (enc (enc m a b "abort" (privk a)) (privk t)))
		)
	)


	; after pcs exchange, A aborts but continues the main protocol properly
	(defrole init-aborts-init-continues-a
		(vars (a b t name) (m text))
		(trace
			; initial pcs exchange
			(send (enc m a b t (privk "pcs" a)))
			(recv (enc m b a t (privk "pcs" b)))
			; perform an abort with T
			(send (enc (enc m a b "abort" (privk a)) (pubk t)))
			(recv (enc (enc m a b "abort" (privk a)) (privk t)))
			; continue main protocol
			(send (enc m a b t (privk "sign" a)))
			(recv (enc m b a t (privk "sign" b)))
		)
	)
	(defrole init-aborts-init-continues-b
		(vars (a b t name) (m text))
		(trace
			; initial pcs exchange
			(recv (enc m a b t (privk "pcs" a)))
			(send (enc m b a t (privk "pcs" b)))
			; not shown: A performs an abort with T
			; main protocol continues
			(recv (enc m a b t (privk "sign" a)))
			(send (enc m b a t (privk "sign" b)))
		)
	)
	(defrole init-aborts-init-continues-t
		(vars (a b t name) (m text))
		(trace
			; A sent an abort request
			(recv (enc (enc m a b "abort" (privk a)) (pubk t)))
			(send (enc (enc m a b "abort" (privk a)) (privk t)))
		)
	)


	; after pcs exchange, A aborts and sends a publicly-verifiably signature to B
	; B attempts a resolution with T, but recevies an aborted message
	(defrole init-aborts-init-continues-resp-resolves-a )
	(defrole init-aborts-init-continues-resp-resolves-b )
	(defrole init-aborts-init-continues-resp-resolves-t )


	; after pcs exchange, A aborts and A sends a publicly-verifiably signature to B
	; B attempts to abort with T, but finds that the session has already been aborted
	(defrole init-aborts-init-continues-resp-aborts-a )
	(defrole init-aborts-init-continues-resp-aborts-b )
	(defrole init-aborts-init-continues-resp-aborts-t )


	; after receiving a pcs from A, B immediately contacts T for resolution
	; when A does not receive a pcs from B, A attempts to abort, but receives B's signature from T instead
	(defrole resp-resolves-init-aborts-a )
	(defrole resp-resolves-init-aborts-b )
	(defrole resp-resolves-init-aborts-t )


	; after receiving a pcs from A, B immediately contacts T for resolution
	; when A does not receive a pcs from B, A contacts T for resolution
	(defrole resp-resolves-init-resolves-a )
	(defrole resp-resolves-init-resolves-b )
	(defrole resp-resolves-init-resolves-t )


	; after proper pcs exchange, A sends publicly-verifiable signature to B
	; B does not respond (ignored: or sends a bad signature) and A contacts T for resolution
	(defrole init-resolves-a
		(vars (a b t name) (m text))
		(trace

		)
	)
	(defrole init-resolves-b )
	(defrole init-resolves-t )

)
