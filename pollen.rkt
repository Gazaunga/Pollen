#lang racket
(require
  pollen/core
  pollen/decode
  pollen/file
  pollen/template
  pollen/tag
  sugar
  txexpr
  pollen/unstable/pygments
  pollen/unstable/typography
  pollen/pagetree)


(provide root link bullet-list numbered-list highlight assignment-body extra-challenge assignment-heading stdout user-input inline-heading breadcrumbs)

; Theoretically, CSS allows you to specify that a page break should not occur
; _after_ a given element, but some browsers do not respect this. All modern
; browsers seem to support avoiding breaks _within_ an element, though. Therefore,
; if an element has the "keep-with-next" class, we wrap it and the sibling that
; immediately follows it inside a div with class "nobreak". If multiple "keep-with-next"
; elements are encountered in a row, this is handled gracefully, producing a tree of divs:
;  - nowrap div
;    - first keep-with-next element
;    - nowrap div
;      - second keep-with-next element
;      - first non-keep-with-next sibling
;  - second non-keep-with-next sibling
(define (no-break-wrap elems)
  (cond
    [(null? elems) '()]
    [(null? (cdr elems)) elems]
    [(and (txexpr? (car elems))
          (string-contains? (attr-ref (car elems) 'class "") "keep-with-next"))
     (let
         ((rest-processed (no-break-wrap (cdr elems))))
       `((div ((class "nobreak"))
             ,(car elems) ,(car rest-processed))
         ,@(cdr rest-processed)))]
    [else
     (cons (car elems) (no-break-wrap (cdr elems)))]))

; Stolen from Matthew Butterick
(define (link url #:class [class-name #f] . tx-elements)
  (let* ([tx-elements (if (empty? tx-elements)
                          (list url)
                          tx-elements)]
                [link-tx (attr-set (txexpr 'a empty tx-elements) 'href url)])
           (if class-name
               (attr-set link-tx 'class class-name)
               link-tx)))

; These three functions for making lists stolen from Matthew Butterick
(define (detect-list-items elems)
         (define elems-merged (merge-newlines elems))
         (define (list-item-break? elem)
           (define list-item-separator-pattern (regexp "\n\n\n+"))
           (and (string? elem) (regexp-match list-item-separator-pattern elem)))
         (define list-of-li-elems (filter-split elems-merged list-item-break?))
         (define list-of-li-paragraphs
           (map (λ(li) (decode-paragraphs li #:force? #t)) list-of-li-elems))
         (define li-tag (default-tag-function 'li))
         (map (λ(lip) (apply li-tag lip)) list-of-li-paragraphs))

(define (make-list-function tag [attrs empty])
         (λ args (list* tag attrs (detect-list-items args))))

(define bullet-list (make-list-function 'ul))
(define numbered-list (make-list-function 'ol))

; Some tags for headings in assignments
(define assignment-heading (default-tag-function 'h3 #:class "assignment-heading keep-with-next"))
(define (extra-challenge . elems)
  `(h4 ((class "extra-challenge keep-with-next")) "Extra Challenge: " ,@elems))
(define inline-heading (default-tag-function 'span #:class "inline-heading"))

; All assignments have an all-encompassing assignment-body tag. It handles
; problem numbering across the entire document.
(define-tag-function (assignment-body attrs elems)
   (define (number-problems elems next-problem-num)
     (cond
       [(null? elems) '()]
       [(and
         (list? (car elems))
         (eq? (car (car elems)) 'problem))
        (cons
          `(h4 ((class "assignment-problem keep-with-next"))
            (span ((class "problem-number")) ,(number->string next-problem-num))
            (span ((class "problem-name")) ,@(cdr (car elems))))
            (number-problems (cdr elems) (+ 1 next-problem-num)))]
       [else (cons (car elems) (number-problems (cdr elems) next-problem-num))]))
  `(body ,attrs ,@(number-problems elems 1)))


; Some simple tags for creating nice-looking transcripts of shell sessions.
(define stdout (default-tag-function 'pre #:class "terminal"))
(define user-input (default-tag-function 'span #:class "user-input"))


; Creates a breadcrumb: alex lew / ... / ..., ending in the parent (according to
; our current pagetree) of the current page. Displays the shortname of a page, or,
; if that doesn't exist, its title. Typically, I use CSS to hide these breadcrumbs 
; for the printed version of a page.
(define (breadcrumbs node)
  (define divider
    `(span ((class "breadcrumb-divider"))))
  (define (breadcrumb-children cur)
    (define my-parent (parent cur))
    (cond
      [(false? my-parent) (list (link "/home.html" "alex lew"))]
      [else
        (append
          (breadcrumb-children my-parent)
          (list divider
            (link
              (string-append "/" (->string my-parent))
              (or (select-from-metas 'shortname my-parent) (select-from-metas 'title my-parent)))))]))
  (->html `(div ((id "breadcrumbs")) ,@(breadcrumb-children node))))

; Essentially Matthew Butterick's root method, but with no-break-wrap added in
; and some additional tags excluded for processing. (No fancy quotes in the code!)
(define (root . elements)
   (txexpr 'root empty (decode-elements elements
     #:txexpr-elements-proc (compose1 no-break-wrap decode-paragraphs)
     #:string-proc (compose1 smart-quotes smart-dashes)
     #:exclude-tags '(style script pre code))))
