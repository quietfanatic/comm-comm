

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
    if (post != null && 'id' in post)
        return parseInt(post.id.match(/_(\d+)$/)[1]);
    else
        return null;
}

 // Abstract out XMLHttpRequest and error message reporting and such.
function get_xml (params) {
    var client = new XMLHttpRequest();
    client.onreadystatechange = function () {
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
         // 503 means service temporarily unavailable
        if (this.status == 503) {
            if ('errloc' in params)
                make_error(params.errloc, "The server is temporarily unavailable.  Please wait.");
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
    client.open("GET", params.url);
    client.send();
    return client;
}

 // Using add_events to see if we have new content is pretty spaghettilicious.  We'll find a better way later.
var have_new_content = false;
 // Add all appropriate event handlers to new content
function add_events (elem) {
    var pid = get_post_id(elem);
    if (pid != null) {
        have_new_content = true;
        $(elem).find('.reply_button').click(function(){reply_to_post(pid);return false});
        $(elem).find('.edit_cancel_button').click(function(){cancel_edit(pid);return false});
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
//     <set t="latest" v="455" />
// </update>

 // These are the variables that the update format is allowed to set.
var vars = {
    earliest: null,
    latest: null,
    board: null,
};

 // The tag name of each element in the update determines what it does.
 // The actions are all very abstract.  The concrete decision making will be done by the server.
var actions = {
     // Append to children of target
    append: function (up) {
        var elem = up.children[0];
        var tid = up.getAttribute('t');
        $('#' + tid).append(elem);
        add_events(elem);
    },
     // Prepend to children of target
    prepend: function (up) {
        var elem = up.children[0];
        var tid = up.getAttribute('t');
        $('#' + tid).prepend(elem);
        add_events(elem);
    },
     // Put after target
    after: function (up) {
        var elem = up.children[0];
        var tid = up.getAttribute('t');
        $('#' + tid).after(elem);
        add_events(elem);
    },
     // Put before target
    before: function (up) {
        var elem = up.children[0];
        var tid = up.getAttribute('t');
        $('#' + tid).before(elem);
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
                add_events(elem);
                return;
            }
        }
        list.appendChild(elem);
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
    set: function (up) {
        var tname = up.getAttribute('t');
        var val = up.getAttribute('v');
        if (tname in vars) {
            vars[tname] = parseInt(val);
        }
    }
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
function Updater (min_interval, max_interval) {
    var this_Updater = this;

    this.timer = null;
    this.delay = min_interval;
    this.job = null;

    var errloc = document.getElementById('update_error');

    this.increase_delay = function () {
        this_Updater.delay += min_interval;
        if (this_Updater.delay > max_interval)
            this_Updater.delay = max_interval;
    }
    this.reset_delay = function () {
        this_Updater.delay = min_interval;
    }

    function handle_update (xml) {
         // scrolling control
        var stream = $('#stream')[0];
        var old_scrollHeight = stream.scrollHeight;
         // do the update
        var update = xml.documentElement;
        have_new_content = false;
        execute_actions(update);
        if (have_new_content) {
            this_Updater.reset_delay();
        }
        else {
            this_Updater.increase_delay();
        }
         // fix scroll
        stream.scrollTop += stream.scrollHeight - old_scrollHeight;
         // reset timeout
        this_Updater.job = null;
        this_Updater.timer = setTimeout( request_update, this_Updater.delay * 1000 );        
    }

    function request_update () {
        this_Updater.job = get_xml({
            url: "/update/update.xml?board=" + vars.board + "&since=" + vars.latest,
            handler: handle_update,
            errloc: errloc,
            on_network_error: function(){
                this_Updater.job = null;
                this_Updater.timer = setTimeout( request_update, max_interval * 1000 );
            }
        });
    }
    this.stop = function () {
        if (this.job != null)
            this.job.abort();
        if (this.timer != null) {
            clearTimeout(this.timer);
            this.timer = null;
        }
    }
    this.start = function () {
        this.timer = setTimeout( request_update, this.delay * 1000 );
    }
    this.update_now = function () {
        this.stop();
        this.reset_delay();
        request_update();
    }
    this.start();
}

 // This happens when you press the 'backlog' button to view old posts
var backlog_job = null;
function backlog () {
    if (backlog_job != null) return;
    backlog_job = get_xml({
        url: "/update/backlog.xml?board=" + vars.board + "&before=" + vars.earliest,
        handler: function (xml) {
            var update = xml.documentElement;
            execute_actions(update);
            backlog_job = null;
        },
        errloc: $('#backlog_error')[0],
    });
}

 // This happens when you click the 'edit' button on a pinned post
var start_edit_job = null;
function start_edit (pid) {
    if (start_edit_job != null) return;
    start_edit_job = get_xml({
        url: "/update/start_edit.xml?post=" + pid,
        handler: function (xml) {
            var update = xml.documentElement;
            execute_actions(update);
            start_edit_job = null;
        },
    });
}
 // If you click the cancel button on a post you're editing
function cancel_edit (pid) {
    $('#editing_' + pid).detach();
    $('#pinned_' + pid).removeClass('really_hidden');
}

 // scrolling control
function scroll_to_bottom(elem) {
    elem.scrollTop = elem.scrollHeight;
}
function near_bottom(elem) {
    return elem.scrollTop > elem.scrollHeight - elem.offsetHeight - 240;
}

 // There appears to be no other way to prevent images from pushing the stream down
 // when loaded besides periodically checking the element's height.
function Scroll_Protector () {
    this_SP = this;
    this.elems = [];
    this.timer = null;
    this.start = function (elem) {
        this.elems.push([elem, elem.scrollHeight]);
        if (this.elems.length == 1) {
            this.timer = setInterval( protect, 100 );
        }
    };
    this.stop = function (elem) {
        this.elems.splice(this.elems.indexOf(elem), 1);
        if (this.elems.length == 0) {
            clearInterval(this.timer);
        }
    };
    function protect () {
        for (var i = 0; i < this_SP.elems.length; i++) {
            var e = this_SP.elems[i];
            if (e[0].scrollHeight != e[1]) {
                e[0].scrollTop += e[0].scrollHeight - e[1];
                e[1] = e[0].scrollHeight;
            }
        }
    }
}

 // When you click a reply button.
function reply_to_post (pid) {
    var npc = $('#new_post_content')[0];
    npc.value += ">>" + parseInt(pid) + " ";
    npc.focus();
}

