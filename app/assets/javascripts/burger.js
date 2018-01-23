$(document).ready(function () {
    var trigger = $('.hamburger'),
        overlay = $('.overlay'),
       isClosed = false;

      trigger.click(function () {
        hamburger_cross();      
      });

      function hamburger_cross() {

        if ($('.hamburger').hasClass('is-closed')){
          $('.hamburger').removeClass('is-closed');
          $('.hamburger').addClass('is-open');
        }else{
          $('.hamburger').removeClass('is-open');
          $('.hamburger').addClass('is-closed');
          
        }
        // if (isClosed == true) {          
        //   overlay.hide();
        //   trigger.removeClass('is-open');
        //   trigger.addClass('is-closed');
        //   isClosed = false;
        // } else {   
        //   overlay.show();
        //   trigger.removeClass('is-closed');
        //   trigger.addClass('is-open');
        //   isClosed = true;
        // }
    }
    
    // $('#hamburger').bind('click',function () {
    //   if ($('#wrapper').hasClass('toggled')){
    //     $('#wrapper').removeClass('toggled');
    //   }else{
    //      $('#wrapper').addClass('toggled');
    //   }
          
    // });  
  });

  function toggle_sidebar(){
    if ($('.hamburger').hasClass('is-closed')){
      $('.hamburger').removeClass('is-closed');
      $('.hamburger').addClass('is-open');
    }else{
      $('.hamburger').removeClass('is-open');
      $('.hamburger').addClass('is-closed');
      
    }
    if ($('#wrapper').hasClass('toggled')){
      $('#wrapper').removeClass('toggled');
    }else{
       $('#wrapper').addClass('toggled');
    }
  }