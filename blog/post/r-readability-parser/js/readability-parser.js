function readabilityParser(html, url, candidates, threshold) {
  // Parse jsdom with readability.js
  let doc = new jsdom.JSDOM(
    html,
    { url: url }
  );
  let reader = new Readability.Readability(
    doc.window.document,
    { nbTopCandidates: candidates, charThreshold: threshold }
  );
  let res = reader.parse();

  // Sanitize results to avoid script injection
  const purifyWindow = new jsdom.JSDOM('').window;
  const DOMPurify = dompurify(purifyWindow);

  let clean = DOMPurify.sanitize(res.content);
  res.content = clean;

  return res;
}

function isReadable(html, min_content_length, min_score) {
  let doc = new jsdom.JSDOM(html);
  return Readability.isProbablyReaderable(
    doc.window.document,
    { minContentLength: min_content_length, minScore: min_score }
  );
}
