window.addEventListener("message", function(event) {
    var data = event.data;
    switch(data.action) {
        case "showui":
            $(".outline").fadeIn();
            $("body").fadeIn();
        break;
        case "hideui":
            $(".outline").fadeOut();
            $("body").fadeOut();
        break;
    }
});