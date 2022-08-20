$(function() {
    window.addEventListener("message", function(event) {
        var data = event.data;
        switch(data.action) {
            case "displayUI":
                $(".outline").css("left", data.position.width + "px");
                $(".outline").css("bottom", data.position.height + "px");
                $(".btn-group").css("left", data.position.width + "px");
                $(".btn-group").css("bottom", (data.position.height * 0.55) + "px");
                // $(".outline").css("top", data.position.height + "px");
                $(".outline").fadeIn();
                $(".btn-group").fadeIn();
                break;
            case "hideUI":
                $(".outline").fadeOut();
                $(".btn-group").fadeOut();
                break;
        }
    });
});
