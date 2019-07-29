$(document).ready(function() {
  //
  // Mobile menu icon in navbar
  //
  $(".mobile-navigation").on("click", ".mobile-navigation__menu-icon", function(e) {
    e.preventDefault();
    toggleMobileDropdown();
  });

  //
  // Close menu button in mobile dropdown menu footer
  //
  $(".mobile-navigation").on("click", ".mobile-navigation__footer", function(e) {
    e.preventDefault();
    toggleMobileDropdown();
  });

  //
  // Overlay
  //
  $("body").on("click", ".mobile-navigation__overlay", function(e) {
    e.preventDefault();
    toggleMobileDropdown();
  });

  function toggleMobileDropdown() {
    const mobileDropdownEl = $(".mobile-navigation__links-container");
    const overlayEl = $(".mobile-navigation__overlay");

    if ($(mobileDropdownEl).hasClass("active")) {
      // Disable menu
      $(mobileDropdownEl).removeClass("active");
      $(mobileDropdownEl).addClass("inactive");
      $(overlayEl).removeClass("active");
      $(overlayEl).addClass("inactive");
    } else {
      // Enable menu
      $(mobileDropdownEl).removeClass("inactive");
      $(mobileDropdownEl).addClass("active");
      $(overlayEl).removeClass("inactive");
      $(overlayEl).addClass("active");
    }
  }
});
