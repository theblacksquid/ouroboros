
(define render-view
  (lambda (view container)
    (begin
      (-> ($ container) 'html view))))

(define (make-model alist container tmpl)
  (lambda (cmd arg)
    (let ((table alist)
          (elem container)
          (tmpl tmpl))
      (case cmd
        ('delete! (set! table (remove-alist-elem arg table))
                  callback)
        ('get (a-ref arg table) callback)
        ('set! (set! table (remove-alist-elem arg table))
               (set! table (cons arg table))
               callback)
        ('render (render-view (tmpl table) elem))
        ('view table)
        ))))

(define make-controller
  (lambda (alist)
    (let loop ((ls alist))
      (if (null? ls)
          '()
          (begin
            (let ((elem (key (car ls)))
                  (action (a-ref "action-type" 
                                 (value (car ls))))
                  (controller (a-ref "controller"
                                     (value (car ls)))))
              (-> ($ elem) 'on action
                (js-closure (eval controller))))
            (loop (cdr ls))
          )))))
  
(define btn-callback
  (lambda ()
    (begin
      (console-log (some-model 'view))
      (some-model 'set! `("state" ,(+ (some-model 'get "state") 1)))
      (console-log (some-model 'view))
    )))

(define some-tmpl
  (lambda (model)
    (element-new
      `(div
        ,(string-append "Times clicked:"
                        (number->string (a-ref "state" model)))
        (button
          id "btn1"
          "Click Me")))))  

(define some-table '(("state" 1)))
  
(define some-model
  (make-model some-table 
              "#app" 
              some-tmpl))

(define some-disp
  `(("#btn1" ("action-type" "click") 
              ("controller" btn-callback))))

(some-model 'render)
(make-controller some-disp)


