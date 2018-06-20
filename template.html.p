<!DOCTYPE html>

◊(local-require pollen/unstable/typography)
◊(define title (select-from-metas 'title metas))
◊(define content (->html (or (select-from-doc 'body doc) (smart-quotes "Well, this is embarrassing... I haven't written the content for this page yet!"))))

<html>
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>◊title</title>
  <link rel="stylesheet" type="text/css" href="/styles.css">
  <link href="https://fonts.googleapis.com/css?family=Nunito:400,700|Source+Code+Pro" rel="stylesheet">
  <link rel="stylesheet" href="/monokai.css">
  <link rel="stylesheet" href="/tango.css" media="print">
</head>
<body>
  	<section id="post">
      ◊breadcrumbs[here]
  		<h1 id="blogtitle">◊(select-from-metas 'title metas)</h1>
  		<div id="blogcontent">◊|content|</div>
  	</section>
</body>
