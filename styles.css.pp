#lang pollen

◊(define page-border-color "#e5e5e5")

◊(define (shrinking-margin-css base-width margin-width increment)
  (define (media-property prop n)
    (string-append "(" prop ": " (number->string n) "px)"))
  (define (border-css n)
    (string-append "html { border-left: solid " (number->string n) "px " page-border-color "; }"))
  (define (max-to-mins high)
    (define low (- high increment))
    (if (< low base-width) ""
        (string-append
            "@media only screen and " (media-property "max-width" high)
                              " and " (media-property "min-width" low)
            "{" (border-css (- high base-width)) "}\n"
            (max-to-mins low))))
  (string-append
    "@media only screen and " (media-property "min-width" (- (+ base-width margin-width) increment))
    " { " (border-css margin-width) " }\n"
    (max-to-mins (- (+ base-width margin-width) increment))
    "@media only screen and " (media-property "max-width" base-width)
    "{ html { border: none } }\n"))

◊(define bg-color "#f5f5f5")
◊(define top-border-color "#333")
◊(define top-border-size 10) ◊;pixels
◊(define text-color "#444")
◊(define font-family "'Avenir Next', 'Nunito', sans-serif")
◊(define font-family-alt "'Avenir', 'Nunito', sans-serif")

◊(define page-width 800)
◊(define margin-width 50)
◊(define font-size 1.1)
◊(define small-font-size 0.8)
◊(define intro-bg-color "rgba(180, 220, 240, 0.5)")
◊(define line-height 1.4)
◊(define link-mark-color "#933")
◊(define blog-left-inset "10px")
◊(define dashed-border-color "#aaa")

◊(define (make-media-query min-width max-width)
  (define (stringify thing)
    (cond
      [(number? thing) (number->string thing)]
      [else thing]))
  (define query-string
    (string-append
      "@media only screen"
      (if min-width (string-append " and (min-width: " (number->string min-width) "px)") "")
      (if max-width (string-append " and (max-width: " (number->string max-width) "px)") "")
      " {"
      ))
    (lambda elems (apply string-append
      `(,query-string
        ,@(map stringify elems)
        "}\n"))))

◊(define when-small-margin (make-media-query #f (+ page-width (* margin-width 3))))
◊(define when-big-margin (make-media-query (+ page-width (* margin-width 3)) #f))
◊(define on-landscape-phones (make-media-query #f 700))
◊(define on-phones (make-media-query #f 500))

◊; Set some basic defaults.
html {
    -webkit-text-size-adjust: 100%; /* Prevent font scaling in landscape while allowing user zoom */
    margin: 0px;
    background: ◊|bg-color|;
    color: ◊|text-color|;
    font-family: ◊|font-family|;
    min-height: 100%;
}

◊shrinking-margin-css[page-width margin-width 2]

body {
  max-width: ◊|page-width|px;
  margin: 0 auto 2em auto;
  font-size: ◊|font-size|em;
  text-rendering: optimizeLegibility;
  font-feature-settings: 'kern' 1;
}

◊on-landscape-phones{
  body {
    font-size: 0.95em;
  }
}

◊on-phones{
  body {
    font-size: 0.8em;
  }
}


p, #blogpost {
  line-height: ◊|line-height|;
}

li p {
  margin-bottom: 0.3em;
  margin-top: 0.3em;
}

.keep-with-next {
  margin-bottom: 0.2em;
}
.keep-with-next + p, .keep-with-next + ul, .keep-with-next + ol {
  margin-top: 0;
}
.keep-with-next + ul li:first-child p, .keep-with-next + ol li:first-child p {
  margin-top: 0.4em;
}
.keep-with-next + .highlight {
  margin-top: 0.5em;
}
.keep-with-next + .highlight + p {
  margin-top: 0.5em;
}

◊; ----- BLOG PAGES / ASSIGNMENTS -----
#breadcrumbs {
  margin: 6em 0 .4em ◊|blog-left-inset|;
  font-size: 1.2em;
}

◊when-small-margin{
  #breadcrumbs {
    margin-top: 0;
  }
}

#breadcrumbs a::after {
  content: ""
}

#breadcrumbs .breadcrumb-divider::after {
  content: "/";
  font-size: 1em;
  font-weight: bold;
  display: inline-block;
  margin-left: 0.5em;
  margin-right: 0.5em;
}

#blogtitle {
  padding: 0.3em 0 0 ◊|blog-left-inset|;
  border-top: dashed 1px ◊|dashed-border-color|;
  margin-top: 0;
}

#blogcontent {
  padding-left: 10px;
  font-size: 1.3em;
  margin-right: 10px;
}

◊; ----- ASSIGNMENTS -----
.assignment-heading {
  font-family: ◊|font-family-alt|;
  text-transform: lowercase;
  font-variant: small-caps;
  font-weight: 700;
  letter-spacing: 0.1ch;
}

.extra-challenge {
  color: #BF8F00;
}

.extra-challenge::before {
  content: "★";
  position: relative;
  font-size: 0.9em;
  margin-right: 1em;
  top: -.1em;
}

.assignment-problem {
  color: #2E74B5;
}

.assignment-problem span.problem-number {
  position: relative;
  font-size: 0.9em;
  margin-right: 1em;
}

.assignment-problem span.problem-number::after {
  content: ".";
}

◊when-big-margin{
  .extra-challenge {
    margin-left: -1em;
  }

  .assignment-problem {
    margin-left: -0.9em;
  }

  .extra-challenge::before, .assignment-problem span.problem-number {
    left: -1.5em;
    margin-right: 0px;
  }
}

.highlight .linenos {
    display: none;
}
.highlight pre {
    margin: 8px;
    font-family: "Source Code Pro";
    font-size: 0.8em;
}
.highlight {
    overflow-x: scroll;
      -webkit-overflow-scrolling: touch;
}
code {
    background: #ddd;
    padding: 2px;
    font-family: "Source Code Pro";
    font-size: 0.8em;
}

ol li {
  padding-left: 1em;
}

pre.terminal {
   background: #272822;
   color: #f8f8f2;
   font-family: "Source Code Pro";
   font-size: 0.8em;
   white-space: pre-wrap;
   padding: 0.7em;
}

pre.terminal span.user-input {
  color: #e6db74;
}

span.inline-heading {
  text-transform: lowercase;
  font-family:  ◊|font-family-alt|;
  font-variant: small-caps;
  font-weight: bold;
  color: #000;
  letter-spacing: 0.05ch;
}

◊; ----- FOR PRINTING -----

@page
{
    size: auto;   /* auto is the initial value */

    /* this affects the margin in the printer settings, but not in Safari :( */
    margin: 25mm 0mm 35mm 0mm;
}


@media print {
  body {
    font-size: 0.7em;
    margin-left: 35mm;
    margin-right: 33mm;
    margin-top: 30px;
  }
  .assignment-heading {
    font-size: 1.5em;
  }
  #breadcrumbs {
    margin: 0;
    display: none;
  }
  #blogtitle {
    border: none;
  }
  .highlight pre {
    padding: 0;
    margin: 0;
    white-space: pre-wrap;
  }
  .highlight {
    padding: 0;
    page-break-inside: avoid;
    margin: 0;
  }
  a::after {
    content: "";
  }
  .extra-challenge {
    margin-left: -1em;
  }

  .assignment-problem {
    margin-left: -0.9em;
  }

  .extra-challenge::before, .assignment-problem span.problem-number {
    left: -1.5em;
    margin-right: 0px;
  }

  .nobreak {
    page-break-inside: avoid;
  }

  pre.terminal {
     background-color: #ffffcc;
     page-break-inside: avoid;
     color: #000000;
  }

  pre.terminal span.user-input {
    color: #4e9a06;
  }
}
