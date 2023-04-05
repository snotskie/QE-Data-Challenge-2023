var SLIDE = parseInt(location.hash.substr(2)) || 1;
window.addEventListener("keydown", function(e){
  const nextCodes = ["ArrowRight", "ArrowDown", "PageDown"];
  const prevCodes = ["ArrowLeft", "ArrowUp", "PageUp"];
  let s = null;
  if (nextCodes.includes(e.code) && (s = document.querySelector(`section[id="${SLIDE+1}"]`))){
    ++SLIDE;
  } else if (prevCodes.includes(e.code) && (s = document.querySelector(`section[id="${SLIDE-1}"]`))){
    --SLIDE;
  }

  if (s){
    location.hash = "#!" + SLIDE;
    window.scrollBy({
      left: 0,
      top: s.getBoundingClientRect().top,
      behavior: "smooth"
    });

    e.preventDefault(); // bugfix: chrome won't scroll without this and with behavior: "smooth"
    e.stopPropagation();
  }
});