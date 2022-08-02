readability <- function(html, url, candidates = 5L, threshold = 500L) {
  ct <- V8::v8(global = "window")

  ct$eval("function setTimeout(){}")
  ct$eval("function clearInterval(){}")
  ct$source("js/encoding.min.js")
  ct$source("js/jsdom.js")
  ct$source("js/dompurify.js")
  ct$source("js/readability.js")
  ct$eval(readLines("js/readability-parser.js"))

  # ct$get(V8::JS("Object.keys(window)"))
  ct$call("readabilityParser", html, url, candidates, threshold)
}

is_readable <- function(html, min_content_length = 140, min_score = 20) {
  ct <- V8::v8(global = "window")
  
  ct$eval("function setTimeout(){}")
  ct$eval("function clearInterval(){}")
  ct$source("js/encoding.min.js")
  ct$source("js/jsdom.js")
  ct$source("js/readability.js")
  ct$eval(readLines("js/readability-parser.js"))
  
  # ct$get(V8::JS("Object.keys(window)"))
  ct$call("isReadable", html, min_content_length, min_score)
}
