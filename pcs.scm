(defprotocol two-party-ocs basic

	; ### init role
	; (send (enc m a b t (privk "pcs" a)))  ; init-pcs-send
	; (recv (enc m b a t (privk "pcs" b)))  ; init-pcs-rcv
	; (send (enc m a b t (privk "sign" a))) ; init-sig-send
	; (recv (enc m b a t (privk "sign" b))) ; init-sig-recv

	; ### resp role
	; (recv (enc m a b t (privk "pcs" a)))  ; resp-pcs-recv
	; (send (enc m b a t (privk "pcs" b)))  ; resp-pcs-send
	; (recv (enc m a b t (privk "sign" a))) ; resp-sig-recv
	; (send (enc m b a t (privk "sign" b))) ; resp-sig-send

	; ### aborter role
	; (send (enc (enc m x y "abort" (privk x)) (pubk  t)))                                                ; abort-request
	; (recv (enc (enc m x y "abort" (privk x)) (privk "sign" t)))                                         ; abort-response-success
	; (recv (enc (enc (enc m y x "abort" (privk y)) (privk "sign" t)) (pubk "enc" x)))                    ; abort-response-fail-aborted
	; (recv (enc (enc m y x t (privk "sign" y)) (pubk "enc" x)))                                          ; abort-response-fail-resolved

	; ### resolver role
	; (send (enc (cat (enc m y x t (privk "pcs" y)) (enc m x y t (privk "sign" x))) (privk "ttp-sig" x))) ; resolve-request
	; (recv (enc (enc m y x t (privk "sign" y)) (pubk "enc" x)))                                          ; resolve-response-success
	; (recv (enc (enc (enc m x y "abort" (privk x)) (privk "sign" t)) (pubk "enc" x)))                    ; resolve-response-aborted

	; ### ttp role
	; (recv (enc (enc m x y "abort" (privk x)) (pubk  t)))                                                ; ttp-abort-request
	; (send (enc (enc (enc m x y "abort" (privk x)) (privk "sign" t)) (pubk "enc" x)))                    ; ttp-abort-response-success
	; (send (enc (enc (enc m y x "abort" (privk y)) (privk "sign" t)) (pubk "enc" x)))                    ; ttp-abort-response-fail-aborted
	; (send (enc (enc m y x t (privk "sign" y)) (pubk "enc" x)))                                          ; ttp-abort-response-fail-resolved
	; (recv (enc (cat (enc m y x t (privk "pcs" y)) (enc m x y t (privk "sign" x))) (privk "ttp-sig" x))) ; ttp-resolve-request
	; (send (enc (enc m y x t (privk "sign" y)) (pubk "enc" x)))                                          ; ttp-resolve-response-success
	; (send (enc (enc (enc m x y "abort" (privk x)) (privk "sign" t)) (pubk "enc" x)))                    ; ttp-resolve-response-aborted


	; ### init

	; init in main protocol
	(defrole init-main
		(vars (a b t name) (m text))
		(trace
			(send (enc m a b t (privk "pcs" a)))  ; init-pcs-send
			(recv (enc m b a t (privk "pcs" b)))  ; init-pcs-rcv
			(send (enc m a b t (privk "sign" a))) ; init-sig-send
			(recv (enc m b a t (privk "sign" b))) ; init-sig-recv
		)
	)


	; ### resp

	; resp in main protocol
	(defrole resp-main
		(vars (a b t name) (m text))
		(trace
			(recv (enc m a b t (privk "pcs" a)))  ; resp-pcs-recv
			(send (enc m b a t (privk "pcs" b)))  ; resp-pcs-send
			(recv (enc m a b t (privk "sign" a))) ; resp-sig-recv
			(send (enc m b a t (privk "sign" b))) ; resp-sig-send
		)
	)


	; ### aborter

	; successful abort
	(defrole abort-success
		(vars (x y t name) (m text))
		(trace
			(send (enc (enc m x y "abort" (privk x)) (pubk  t)))        ; abort-request
			(recv (enc (enc m x y "abort" (privk x)) (privk "sign" t))) ; abort-response-success
		)
	)
	; unsuccessful abort because of previous abort
	(defrole abort-fail-aborted
		(vars (x y t name) (m text))
		(trace
			(send (enc (enc m x y "abort" (privk x)) (pubk  t)))                             ; abort-request
			(recv (enc (enc (enc m y x "abort" (privk y)) (privk "sign" t)) (pubk "enc" x))) ; abort-response-fail-aborted
		)
	)
	; unsuccessful abort because of previous resolution
	(defrole abort-fail-resolved
		(vars (x y t name) (m text))
		(trace
			(send (enc (enc m x y "abort" (privk x)) (pubk  t)))       ; abort-request
			(recv (enc (enc m y x t (privk "sign" y)) (pubk "enc" x))) ; abort-response-fail-resolved
		)
	)


	; ### resolver

	; successful resolution
	(defrole resolve-success
		(vars (x y t name) (m text))
		(trace
			(send (enc (cat (enc m y x t (privk "pcs" y)) (enc m x y t (privk "sign" x))) (privk "ttp-sig" x))) ; resolve-request
			(recv (enc (enc m y x t (privk "sign" y)) (pubk "enc" x)))                                          ; resolve-response-success
		)
	)
	; unsuccessful resolution because of previous abort
	(defrole resolve-fail
		(vars (x y t name) (m text))
		(trace
			(send (enc (cat (enc m y x t (privk "pcs" y)) (enc m x y t (privk "sign" x))) (privk "ttp-sig" x))) ; resolve-request
			(recv (enc (enc (enc m x y "abort" (privk x)) (privk "sign" t)) (pubk "enc" x)))                    ; resolve-response-aborted
		)
	)


	; ### ttp

	; successful abort
	(defrole ttp-abort-success
		(vars (x y t name) (m text))
		(trace
			(recv (enc (enc m x y "abort" (privk x)) (pubk  t)))                             ; ttp-abort-request
			(send (enc (enc (enc m x y "abort" (privk x)) (privk "sign" t)) (pubk "enc" x))) ; ttp-abort-response-success
		)
	)
	; other party previously aborted; respond with cached response
	(defrole ttp-abort-fail-aborted
		(vars (x y t name) (m text))
		(trace
			(recv (enc (enc m x y "abort" (privk x)) (pubk  t)))                             ; ttp-abort-request
			(send (enc (enc (enc m y x "abort" (privk y)) (privk "sign" t)) (pubk "enc" x))) ; ttp-abort-response-fail-aborted
		)
	)
	; respond with signature from previous resolution
	(defrole ttp-abort-fail-resolved
		(vars (x y t name) (m text))
		(trace
			(recv (enc (enc m x y "abort" (privk x)) (pubk  t)))       ; ttp-abort-request
			(send (enc (enc m y x t (privk "sign" y)) (pubk "enc" x))) ; ttp-abort-response-fail-resolved
		)
	)


	; successful resolution
	(defrole ttp-resolve-success
		(vars (x y t name) (m text))
		(trace
			(recv (enc (cat (enc m y x t (privk "pcs" y)) (enc m x y t (privk "sign" x))) (privk "ttp-sig" x))) ; ttp-resolve-request
			(send (enc (enc m y x t (privk "sign" y)) (pubk "enc" x)))                                          ; ttp-resolve-response-success
		)
	)
	; unsuccessful resolution due to previous abortion
	(defrole ttp-resolve-aborted
		(vars (x y t name) (m text))
		(trace
			(recv (enc (cat (enc m y x t (privk "pcs" y)) (enc m x y t (privk "sign" x))) (privk "ttp-sig" x))) ; ttp-resolve-request
			(send (enc (enc (enc m x y "abort" (privk x)) (privk "sign" t)) (pubk "enc" x)))                    ; ttp-resolve-response-aborted
		)
	)

)



; ### preskeletons

(defpreskeleton two-party-ocs
	(vars (a b t name) (m text))
	(defstrand init-main 4 (a a) (b b) (t t) (m m))
	(non-orig
		(privk "ttp-sig" a) (privk "enc" a) (privk "sign" a) (privk "pcs" a)
		(privk "ttp-sig" b) (privk "enc" b) (privk "sign" b) (privk "pcs" b)
		(privk "sign" t)
	)
	(uniq-orig m)
)
