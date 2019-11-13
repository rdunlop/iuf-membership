// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("@rails/activestorage").start()
require("channels")

// from https://gist.github.com/yalab/cad361056bae02a5f45d1ace7f1d86ef#gistcomment-2587601
import 'bootstrap'
import './src/application.scss'
import 'whatwg-fetch'

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// Toggle the 'is--hidden' class on the `js--altname_target` div when the js--altname link
// is clicked
document.addEventListener("DOMContentLoaded", function() {
  // Toggle the display of the altNames block
  function toggleAltNames(event) {
    [].forEach.call(document.querySelectorAll(".js--altname_target"), function(el) {
      el.classList.toggle('is--hidden')
    })
    event.preventDefault();
  };
  [].forEach.call(document.querySelectorAll(".js--altname"), function(el) {
    el.addEventListener("click", toggleAltNames)
  })
});
