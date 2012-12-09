

 // Utility functions for error messages
function make_error (loc, mess) {
    loc.textContent = mess;
}
function append_error (loc, mess) {
    loc.textContent += mess;
}
function clear_error (loc) {
    loc.textContent = '';
}

 // Get the database id of a post (which is embedded in its html id)
function get_post_id (post) {
    return parseInt(post.getAttribute('id').match(/_(\d+)$/)[1]);
}

 // Abstract out error message reporting and such.
function wrap_xml_request (params) {
    return function () {
         // Wait until request is finished
        if (this.readyState != this.DONE)
            return;
         // 0 means a network error of some sort.
        if (this.status == 0) {
            if ('errloc' in params)
                make_error(params.errloc, "No connectivity.  Please check your network connection.");
            if ('on_network_error' in params)
                params.on_network_error();
            return;
        }
         // Stop at an HTTP error.
        if (this.status != 200) {
            if ('errloc' in params)
                make_error(params.errloc, "Update error: The server returned " + this.status);
            if ('on_http_error' in params)
                params.on_http_error();
            return;
        }
        xml = this.responseXML;
         // Gotta be strictly-formed XML.
        if (xml == null) {
            if ('errloc' in params)
                make_error(params.errloc, "Update error: The server didn't provide valid XML.");
            if ('on_xml_error' in params)
                params.on_xml_error();
            return;
        }
         // Everything's normal.
        if ('errloc' in params)
            clear_error(params.errloc);
        if ('handler' in params)
            params.handler(xml);
        return;
    }
}


 // Add all appropriate event handlers to new content
function add_events (elem) {
    var pid = get_post_id(elem);
    if (pid != null) {
        $(elem).find('.reply_button').click(function(){reply_to_post(pid);return false});
    }
}


 // The XML format recieved by all AJAX request performed by the C² client is in a format like:

// <update>
//     <append t="stream">
//         <post ...>...</post>
//     </append>
//     <replace t="post_123>
//         <post ...>...</post>
//     </replace>
//     <remove t="old_stuff" />
// </update>

 // The tag name of each element in the update determines what it does.
 // The actions are all very abstract.  The concrete decision making will be done by the server.
var actions = {
     // Append to children of target
    append: function (up) {
        var elem = up.children[0];
        var tid = up.getAttribute('t');
        $('#' + tid)[0].appendChild(elem);
        add_events(elem);
    },
     // Prepend to children of target
    prepend: function (up) {
        var elem = up.children[0];
        var tid = up.getAttribute('t');
        $('#' + tid).prepend(elem);
        add_events(elem);
    },
     // Insert into children of target sorted by id
    insert: function (up) {
        var elem = up.children[0];
        var tid = up.getAttribute('t');
        var list = $('#' + tid)[0];
        for (var i = 0; i < list.children.length; i++) {
            if (elem.id < list.children[i].id) {
                list.insertBefore(elem, list.children[i]);
            }
        }
        add_events(elem);
    },
     // Replace target with new content
    replace: function (up) {
        var elem = up.children[0];
        var tid = up.getAttribute('t');
        $('#' + tid)[0].replaceChild(post);
        add_events(elem);
    },
     // Delete target
    remove: function (up) {
        var tid = up.getAttribute('t');
        $('#' + tid).detach();
    },
     // Just appearance manipulation
    add_class: function (up) {
        var tid = up.getAttribute('t');
        var cl = up.getAttribute('c');
        $('#' + tid).addClass(cl);
    },
    remove_class: function (up) {
        var tid = up.getAttribute('t');
        var cl = up.getAttribute('c');
        $('#' + tid).removeClass(cl);
    },
};

 // Take an xml update object and execute it.
function execute_actions (update) {
    var did_something = update.children.length > 0;
    for (var i = 0; i < update.children.length; i++) {
        var up = update.children[i];
         // Dispatch action based on tag name
        var action = up.tagName;
        if (action in actions) {
            actions[action](up);
        }
        else {
         // No error reporting here right now.
        }
    }
    return did_something;
}

 // This class represents the thing that gets automatic updates.
function Updater (earliest, latest, board, min_interval, max_interval) {
    var this_Updater = this;

    this.timer = null;
    this.delay = min_interval;
    this.job = null;

    var errloc = document.getElementById('update_error');

    this.increase_delay = function () {
        this.delay += min_interval;
        if (this.delay > max_interval)
            this.delay = max_interval;
    }
    this.reset_delay = function () {
        this.delay = min_interval;
    }

    function handle_update (xml) {
        if (execute_actions(xml.documentElement)) {
            this_Updater.reset_delay();
        }
        else {
            this_Updater.increase_delay();
        }
        this_Updater.job = null;
        this_Updater.timer = setTimeout( request_update, this_Updater.delay * 1000 );        
    }

    function request_update () {
        var url = board == null
            ? "/update/update.xml?since=" + latest
            : "/update/update.xml?board=" + board + "&since=" + latest;
        var client = new XMLHttpRequest();
        client.onreadystatechange = wrap_xml_request({
            handler: handle_update,
            errloc: errloc,
            on_network_error: function(){
                this.job = null;
                this.timer = setTimeout( request_update, max_interval * 1000 );
            }
        })
        client.open("GET", url);
        client.send();
        this.job = client;
    }
    this.update_now = function () {
        if (this.job)
            this.job.abort();
        this.reset_delay();
        request_update();
    }
    this.timer = setTimeout( request_update, this.delay * 1000 );
}

 // scrolling control
function scroll_to_bottom(elem) {
    elem.scrollTop = elem.scrollHeight;
}
 // When you click a reply button.
function reply_to_post (pid) {
    var npc = $('#new_post_content')[0];
    npc.value += ">>" + parseInt(pid) + " ";
    npc.focus();
}

