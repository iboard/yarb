# Execute higlight.js on code-blocks

jQuery ->

  $(document).ready ->
    $('pre code').each (i, e) -> 
      hljs.highlightBlock(e)
