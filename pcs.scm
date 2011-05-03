(defprotocol two-party-ocs basic

	; ### init role
	; (send (enc m a b t (privk "pcs" a)))  ; init-pcs-send
	; (recv (enc m b a t (privk "pcs" b)))  ; init-pcs-rcv
	; (send (enc m a b t (privk "sign" a))) ; init-sig-send
	; (recv (enc m b a t (privk "sign" b))) ; init-sig-recv
	; (send (enc (enc m a b "abort" (privk a)) (pubk  t)))                             ; abort-request
	; (recv (enc (enc m a b "abort" (privk a)) (privk "sign" t)))                      ; abort-response-success
	; (recv (enc (enc m b a t (privk "sign" b)) (pubk "enc" a)))                       ; abort-response-fail-resolved
	; (send (enc (cat (enc m b a t (privk "pcs" b)) (enc m a b t (privk "sign" a))) (privk "ttp-sig" a))) ; resolve-request
	; (recv (enc (enc m b a t (privk "sign" b)) (pubk "enc" a)))                                          ; resolve-response-success
	; (recv (enc (enc (enc m a b "abort" (privk a)) (privk "sign" t)) (pubk "enc" a)))                    ; resolve-response-aborted

	; ### resp role
	; (recv (enc m a b t (privk "pcs" a)))  ; resp-pcs-recv
	; (send (enc m b a t (privk "pcs" b)))  ; resp-pcs-send
	; (recv (enc m a b t (privk "sign" a))) ; resp-sig-recv
	; (send (enc m b a t (privk "sign" b))) ; resp-sig-send
	; (send (enc (cat (enc m a b t (privk "pcs" a)) (enc m b a t (privk "sign" b))) (privk "ttp-sig" b))) ; resolve-request
	; (recv (enc (enc m a b t (privk "sign" a)) (pubk "enc" b)))                                          ; resolve-response-success
	; (recv (enc (enc (enc m b a "abort" (privk b)) (privk "sign" t)) (pubk "enc" b)))                    ; resolve-response-aborted

	; ### resolver role

	; ### ttp role
	; (recv (enc (enc m x y "abort" (privk x)) (pubk  t)))                                                ; ttp-abort-request
	; (send (enc (enc (enc m x y "abort" (privk x)) (privk "sign" t)) (pubk "enc" x)))                    ; ttp-abort-response-success
	; (send (enc (enc m y x t (privk "sign" y)) (pubk "enc" x)))                                          ; ttp-abort-response-fail-resolved
	; (recv (enc (cat (enc m y x t (privk "pcs" y)) (enc m x y t (privk "sign" x))) (privk "ttp-sig" x))) ; ttp-resolve-request
	; (send (enc (enc m y x t (privk "sign" y)) (pubk "enc" x)))                                          ; ttp-resolve-response-success
	; (send (enc (enc (enc m x y "abort" (privk x)) (privk "sign" t)) (pubk "enc" x)))                    ; ttp-resolve-response-aborted


	; ### init

	; init-main
	(defrole init-main
		(vars (a b t name) (m text))
		(trace
			(send (enc m a b t (privk "pcs" a)))  ; init-pcs-send
			(recv (enc m b a t (privk "pcs" b)))  ; init-pcs-rcv
			(send (enc m a b t (privk "sign" a))) ; init-sig-send
			(recv (enc m b a t (privk "sign" b))) ; init-sig-recv
		)
	)
	; init-01
	(defrole init-01-abort
		(vars (a b t name) (m text))
		(trace
			(send (enc m a b t (privk "pcs" a)))  ; init-pcs-send
			(send (enc (enc m a b "abort" (privk a)) (pubk  t)))        ; abort-request
			(recv (enc (enc m a b "abort" (privk a)) (privk "sign" t))) ; abort-response-success
		)
	)
	; init-02
	(defrole init-02-abort-fail
		(vars (a b t name) (m text))
		(trace
			(send (enc m a b t (privk "pcs" a)))  ; init-pcs-send
			(send (enc (enc m a b "abort" (privk a)) (pubk  t)))        ; abort-request
			(recv (enc (enc m b a t (privk "sign" b)) (pubk "enc" a)))  ; abort-response-fail-resolved
		)
	)
	; init-03
	(defrole init-03-abort
		(vars (a b t name) (m text))
		(trace
			(send (enc m a b t (privk "pcs" a)))  ; init-pcs-send
			(recv (enc m b a t (privk "pcs" b)))  ; init-pcs-rcv
			(send (enc (enc m a b "abort" (privk a)) (pubk  t)))        ; abort-request
			(recv (enc (enc m a b "abort" (privk a)) (privk "sign" t))) ; abort-response-success
		)
	)
	; init-04
	(defrole init-04-abort-fail
		(vars (a b t name) (m text))
		(trace
			(send (enc m a b t (privk "pcs" a)))  ; init-pcs-send
			(recv (enc m b a t (privk "pcs" b)))  ; init-pcs-rcv
			(send (enc (enc m a b "abort" (privk a)) (pubk  t)))        ; abort-request
			(recv (enc (enc m b a t (privk "sign" b)) (pubk "enc" a)))  ; abort-response-fail-resolved
		)
	)
	; init-05
	(defrole init-05-resolve
		(vars (a b t name) (m text))
		(trace
			(send (enc m a b t (privk "pcs" a)))  ; init-pcs-send
			(recv (enc m b a t (privk "pcs" b)))  ; init-pcs-rcv
			(send (enc (cat (enc m b a t (privk "pcs" b)) (enc m a b t (privk "sign" a))) (privk "ttp-sig" a))) ; resolve-request
			(recv (enc (enc m b a t (privk "sign" b)) (pubk "enc" a)))                                          ; resolve-response-success
		)
	)
	; init-06
	(defrole init-06-resolve-fail
		(vars (a b t name) (m text))
		(trace
			(send (enc m a b t (privk "pcs" a)))  ; init-pcs-send
			(recv (enc m b a t (privk "pcs" b)))  ; init-pcs-rcv
			(send (enc (cat (enc m b a t (privk "pcs" b)) (enc m a b t (privk "sign" a))) (privk "ttp-sig" a))) ; resolve-request
			(recv (enc (enc (enc m a b "abort" (privk a)) (privk "sign" t)) (pubk "enc" a)))                    ; resolve-response-aborted
		)
	)
	; init-07
	(defrole init-07-abort
		(vars (a b t name) (m text))
		(trace
			(send (enc m a b t (privk "pcs" a)))  ; init-pcs-send
			(recv (enc m b a t (privk "pcs" b)))  ; init-pcs-rcv
			(send (enc m a b t (privk "sign" a))) ; init-sig-send
			(send (enc (enc m a b "abort" (privk a)) (pubk  t)))        ; abort-request
			(recv (enc (enc m a b "abort" (privk a)) (privk "sign" t))) ; abort-response-success
		)
	)
	; init-08
	(defrole init-08-abort-fail
		(vars (a b t name) (m text))
		(trace
			(send (enc m a b t (privk "pcs" a)))  ; init-pcs-send
			(recv (enc m b a t (privk "pcs" b)))  ; init-pcs-rcv
			(send (enc m a b t (privk "sign" a))) ; init-sig-send
			(send (enc (enc m a b "abort" (privk a)) (pubk  t)))        ; abort-request
			(recv (enc (enc m b a t (privk "sign" b)) (pubk "enc" a)))  ; abort-response-fail-resolved
		)
	)
	; init-09
	(defrole init-09-resolve
		(vars (a b t name) (m text))
		(trace
			(send (enc m a b t (privk "pcs" a)))  ; init-pcs-send
			(recv (enc m b a t (privk "pcs" b)))  ; init-pcs-rcv
			(send (enc m a b t (privk "sign" a))) ; init-sig-send
			(send (enc (cat (enc m b a t (privk "pcs" b)) (enc m a b t (privk "sign" a))) (privk "ttp-sig" a))) ; resolve-request
			(recv (enc (enc m b a t (privk "sign" b)) (pubk "enc" a)))                                          ; resolve-response-success
		)
	)
	; init-10
	(defrole init-10-resolve-fail
		(vars (a b t name) (m text))
		(trace
			(send (enc m a b t (privk "pcs" a)))  ; init-pcs-send
			(recv (enc m b a t (privk "pcs" b)))  ; init-pcs-rcv
			(send (enc m a b t (privk "sign" a))) ; init-sig-send
			(send (enc (cat (enc m b a t (privk "pcs" b)) (enc m a b t (privk "sign" a))) (privk "ttp-sig" a))) ; resolve-request
			(recv (enc (enc (enc m a b "abort" (privk a)) (privk "sign" t)) (pubk "enc" a)))                    ; resolve-response-aborted
		)
	)


	; ### resp

	; resp-main
	(defrole resp-main
		(vars (a b t name) (m text))
		(trace
			(recv (enc m a b t (privk "pcs" a)))  ; resp-pcs-recv
			(send (enc m b a t (privk "pcs" b)))  ; resp-pcs-send
			(recv (enc m a b t (privk "sign" a))) ; resp-sig-recv
			(send (enc m b a t (privk "sign" b))) ; resp-sig-send
		)
	)
	; resp-01
	(defrole resp-01-resolve
		(vars (a b t name) (m text))
		(trace
			(recv (enc m a b t (privk "pcs" a)))  ; resp-pcs-recv
			(send (enc (cat (enc m a b t (privk "pcs" a)) (enc m b a t (privk "sign" b))) (privk "ttp-sig" b))) ; resolve-request
			(recv (enc (enc m a b t (privk "sign" a)) (pubk "enc" b)))                                          ; resolve-response-success
		)
	)
	; resp-02
	(defrole resp-02-resolve-fail
		(vars (a b t name) (m text))
		(trace
			(recv (enc m a b t (privk "pcs" a)))  ; resp-pcs-recv
			(send (enc (cat (enc m a b t (privk "pcs" a)) (enc m b a t (privk "sign" b))) (privk "ttp-sig" b))) ; resolve-request
			(recv (enc (enc (enc m b a "abort" (privk b)) (privk "sign" t)) (pubk "enc" b)))                    ; resolve-response-aborted
		)
	)
	; resp-03
	(defrole resp-03-resolve
		(vars (a b t name) (m text))
		(trace
			(recv (enc m a b t (privk "pcs" a)))  ; resp-pcs-recv
			(send (enc m b a t (privk "pcs" b)))  ; resp-pcs-send
			(send (enc (cat (enc m a b t (privk "pcs" a)) (enc m b a t (privk "sign" b))) (privk "ttp-sig" b))) ; resolve-request
			(recv (enc (enc m a b t (privk "sign" a)) (pubk "enc" b)))                                          ; resolve-response-success
		)
	)
	; resp-04
	(defrole resp-04-resolve-fail
		(vars (a b t name) (m text))
		(trace
			(recv (enc m a b t (privk "pcs" a)))  ; resp-pcs-recv
			(send (enc m b a t (privk "pcs" b)))  ; resp-pcs-send
			(send (enc (cat (enc m a b t (privk "pcs" a)) (enc m b a t (privk "sign" b))) (privk "ttp-sig" b))) ; resolve-request
			(recv (enc (enc (enc m b a "abort" (privk b)) (privk "sign" t)) (pubk "enc" b)))                    ; resolve-response-aborted
		)
	)
	; resp-05
	(defrole resp-05-resolve
		(vars (a b t name) (m text))
		(trace
			(recv (enc m a b t (privk "pcs" a)))  ; resp-pcs-recv
			(send (enc m b a t (privk "pcs" b)))  ; resp-pcs-send
			(recv (enc m a b t (privk "sign" a))) ; resp-sig-recv
			(send (enc (cat (enc m a b t (privk "pcs" a)) (enc m b a t (privk "sign" b))) (privk "ttp-sig" b))) ; resolve-request
			(recv (enc (enc m a b t (privk "sign" a)) (pubk "enc" b)))                                          ; resolve-response-success
		)
	)
	; resp-06
	(defrole resp-06-resolve-fail
		(vars (a b t name) (m text))
		(trace
			(recv (enc m a b t (privk "pcs" a)))  ; resp-pcs-recv
			(send (enc m b a t (privk "pcs" b)))  ; resp-pcs-send
			(recv (enc m a b t (privk "sign" a))) ; resp-sig-recv
			(send (enc (cat (enc m a b t (privk "pcs" a)) (enc m b a t (privk "sign" b))) (privk "ttp-sig" b))) ; resolve-request
			(recv (enc (enc (enc m b a "abort" (privk b)) (privk "sign" t)) (pubk "enc" b)))                    ; resolve-response-aborted
		)
	)


	; ### ttp

	; successful abort
	(defrole ttp-01-abort-success
		(vars (x y t name) (m text))
		(trace
			(recv (enc (enc m x y "abort" (privk x)) (pubk  t)))                             ; ttp-abort-request
			(send (enc (enc m x y "abort" (privk x)) (privk "sign" t))) ; ttp-abort-response-success
		)
	)
	; unsuccessful abort: respond with signature from previous resolution
	(defrole ttp-02-abort-fail-resolved
		(vars (x y t name) (m text))
		(trace
			(recv (enc (enc m x y "abort" (privk x)) (pubk  t)))       ; ttp-abort-request
			(send (enc m y x t (privk "sign" y))) ; ttp-abort-response-fail-resolved
		)
	)
	; successful resolution
	(defrole ttp-03-resolve-success
		(vars (x y t name) (m text))
		(trace
			(recv (enc (cat (enc m y x t (privk "pcs" y)) (enc m x y t (privk "sign" x))) (privk "ttp-sig" x))) ; ttp-resolve-request
			(send (enc m y x t (privk "sign" y)))                                          ; ttp-resolve-response-success
		)
	)
	; unsuccessful resolution: previously aborted, respond with abort confirmation
	(defrole ttp-04-resolve-aborted
		(vars (x y t name) (m text))
		(trace
			(recv (enc (cat (enc m y x t (privk "pcs" y)) (enc m x y t (privk "sign" x))) (privk "ttp-sig" x))) ; ttp-resolve-request
			(send (enc (enc m x y "abort" (privk x)) (privk "sign" t)))                    ; ttp-resolve-response-aborted
		)
	)

)



; ### uncompromised preskeletons

; ### init

; # main
(defpreskeleton two-party-ocs
	(vars (a b t name) (m text))
	(defstrand init-main 4 (a a) (b b) (t t) (m m))
	(non-orig
		(privk "ttp-sig" a) (privk "sign" a) (privk "pcs" a)
		(privk "ttp-sig" b) (privk "sign" b) (privk "pcs" b)
		(privk "sign" t)
	)
	(uniq-orig m)
)

; # aborts
;(defpreskeleton two-party-ocs
;	(vars (a b t name) (m text))
;	(defstrand init-01-abort 3 (a a) (b b) (t t) (m m))
;	(non-orig
;		(privk "ttp-sig" a) (privk "sign" a) (privk "pcs" a)
;		(privk "ttp-sig" b) (privk "sign" b) (privk "pcs" b)
;		(privk "sign" t)
;	)
;	(uniq-orig m)
;)
;(defpreskeleton two-party-ocs
;	(vars (a b t name) (m text))
;	(defstrand init-02-abort-fail 3 (a a) (b b) (t t) (m m))
;	(non-orig
;		(privk "ttp-sig" a) (privk "sign" a) (privk "pcs" a)
;		(privk "ttp-sig" b) (privk "sign" b) (privk "pcs" b)
;		(privk "sign" t)
;	)
;	(uniq-orig m)
;)
;(defpreskeleton two-party-ocs
;	(vars (a b t name) (m text))
;	(defstrand init-03-abort 4 (a a) (b b) (t t) (m m))
;	(non-orig
;		(privk "ttp-sig" a) (privk "sign" a) (privk "pcs" a)
;		(privk "ttp-sig" b) (privk "sign" b) (privk "pcs" b)
;		(privk "sign" t)
;	)
;	(uniq-orig m)
;)
;(defpreskeleton two-party-ocs
;	(vars (a b t name) (m text))
;	(defstrand init-04-abort-fail 4 (a a) (b b) (t t) (m m))
;	(non-orig
;		(privk "ttp-sig" a) (privk "sign" a) (privk "pcs" a)
;		(privk "ttp-sig" b) (privk "sign" b) (privk "pcs" b)
;		(privk "sign" t)
;	)
;	(uniq-orig m)
;)
;(defpreskeleton two-party-ocs
;	(vars (a b t name) (m text))
;	(defstrand init-07-abort 5 (a a) (b b) (t t) (m m))
;	(non-orig
;		(privk "ttp-sig" a) (privk "sign" a) (privk "pcs" a)
;		(privk "ttp-sig" b) (privk "sign" b) (privk "pcs" b)
;		(privk "sign" t)
;	)
;	(uniq-orig m)
;)
;(defpreskeleton two-party-ocs
;	(vars (a b t name) (m text))
;	(defstrand init-08-abort-fail 5 (a a) (b b) (t t) (m m))
;	(non-orig
;		(privk "ttp-sig" a) (privk "sign" a) (privk "pcs" a)
;		(privk "ttp-sig" b) (privk "sign" b) (privk "pcs" b)
;		(privk "sign" t)
;	)
;	(uniq-orig m)
;)

; # resolves
;(defpreskeleton two-party-ocs
;	(vars (a b t name) (m text))
;	(defstrand init-05-resolve 4 (a a) (b b) (t t) (m m))
;	(non-orig
;		(privk "ttp-sig" a) (privk "sign" a) (privk "pcs" a)
;		(privk "ttp-sig" b) (privk "sign" b) (privk "pcs" b)
;		(privk "sign" t)
;	)
;	(uniq-orig m)
;)
;(defpreskeleton two-party-ocs
;	(vars (a b t name) (m text))
;	(defstrand init-06-resolve-fail 4 (a a) (b b) (t t) (m m))
;	(non-orig
;		(privk "ttp-sig" a) (privk "sign" a) (privk "pcs" a)
;		(privk "ttp-sig" b) (privk "sign" b) (privk "pcs" b)
;		(privk "sign" t)
;	)
;	(uniq-orig m)
;)
;(defpreskeleton two-party-ocs
;	(vars (a b t name) (m text))
;	(defstrand init-09-resolve 5 (a a) (b b) (t t) (m m))
;	(non-orig
;		(privk "ttp-sig" a) (privk "sign" a) (privk "pcs" a)
;		(privk "ttp-sig" b) (privk "sign" b) (privk "pcs" b)
;		(privk "sign" t)
;	)
;	(uniq-orig m)
;)
;(defpreskeleton two-party-ocs
;	(vars (a b t name) (m text))
;	(defstrand init-10-resolve-fail 5 (a a) (b b) (t t) (m m))
;	(non-orig
;		(privk "ttp-sig" a) (privk "sign" a) (privk "pcs" a)
;		(privk "ttp-sig" b) (privk "sign" b) (privk "pcs" b)
;		(privk "sign" t)
;	)
;	(uniq-orig m)
;)


; ### resp

; # main
;(defpreskeleton two-party-ocs
;	(vars (a b t name) (m text))
;	(defstrand resp-main 4 (a a) (b b) (t t) (m m))
;	(non-orig
;		(privk "ttp-sig" a) (privk "sign" a) (privk "pcs" a)
;		(privk "ttp-sig" b) (privk "sign" b) (privk "pcs" b)
;		(privk "sign" t)
;	)
;	(uniq-orig m)
;)

; # resolves

;(defpreskeleton two-party-ocs
;	(vars (a b t name) (m text))
;	(defstrand resp-01-resolve 3 (a a) (b b) (t t) (m m))
;	(non-orig
;		(privk "ttp-sig" a) (privk "sign" a) (privk "pcs" a)
;		(privk "ttp-sig" b) (privk "sign" b) (privk "pcs" b)
;		(privk "sign" t)
;	)
;	(uniq-orig m)
;)


; ### ttp
