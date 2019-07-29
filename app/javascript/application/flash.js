$(document).ready(function() {
  //
  // Close flash message
  //
  $("body").on("click", ".flash", function(e) {
    e.preventDefault();

    const flash = $(".flash");
    $(flash).removeClass("active");
    $(flash).addClass("inactive");
  });
});
