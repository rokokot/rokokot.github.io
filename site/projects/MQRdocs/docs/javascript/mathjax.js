window.MathJax = {
  tex: {
    inlineMath: [["\\(", "\\)"]],
    displayMath: [["\\[", "\\]"]],
    processEscapes: true,
    processEnvironments: true
  },
  options: {
    ignoreHtmlClass: ".*|",
    processHtmlClass: "arithmatex"
  }
};

document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll('.md-content__inner').forEach(function(element) {
    element.innerHTML = element.innerHTML
      .replace(/\\\)\\\(/g, '\\)\\(')
      .replace(/\\\]\\\[/g, '\\]\\[');
  });
});