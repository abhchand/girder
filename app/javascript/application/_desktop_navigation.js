$(document).ready(function() {
  $(".desktop-navigation").on("click", ".desktop-navigation__toggle", function(e) {
    e.preventDefault();

    const nav = $(".desktop-navigation");
    $(nav).toggleClass("desktop-navigation--collapsed");
  });
});
