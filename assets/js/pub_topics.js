
$(document).ready(function() {
    $("#paperTags li").click(function() {
        // change the state of this button
        $(this).toggleClass("down");

        // go over all the buttons and collect the tags that are down
        var down = $("#paperTags li.down").map(function() { return $(this).text();});

        // if this is empty, then make sure that everything is visible
        if(down.length == 0) {
            $(".papers li").each(function() { $(this).show(); });
        } else {
            // we have to show only those papers that have at least
            // one tag that is down
            $(".papers li").filter(function() {
                $(this).hide();
                var tags = $(this).data("tags");
                if (typeof tags === "undefined"){
                  return true;
                }
                var out = false;
                for(i = 0; i< down.length; i++) {
                    if(tags.indexOf(down[i]) > -1) {
                        out = true;
                        break;
                    }
                }
                
                return out; 
            }).each( function() {
                $(this).show();
            });
        }
        
    });
});
