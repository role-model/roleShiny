$(document).ready(function() {
    $('.cond-panel').on('show', function() {
        $(this).css('opacity', 0).animate({opacity: 1}, {duration: 750});
    });
});
