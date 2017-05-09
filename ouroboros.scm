(define key car)

(define value cdr)

(define a-ref 
  (lambda (val ls)
    (cdr (assoc val ls))))

(define make-view
  (lambda (template, model-init, dispatch)
    (let loop ((view-init (template model-init))
               (ls dispatch))
      (if (null? ls)
          view-init
          (begin
            (let ((elem (key (car ls)))
                  (action-type (a-ref "action-type" 
                                      (value (car ls))))
                  (controller (a-ref "controller" 
                                     (value (car ls)))))
              (js-invoke ($ elem) action-type
                (js-closure controller)))
            (loop view-init (cdr ls))
          )))))




