


function get_ajaxifier (doc, latest, earliest, board, user, min_interval, max_interval) {
    var stream = doc.getElementById('stream');
    var stream_post_list = doc.getElementById('stream_post_list');
    var pinned_post_list = doc.getElementById('pinned_post_list');
    var update_error = doc.getElementById('update_error');
    var backlog_area = doc.getElementById('backlog_area');
    var backlog_error = doc.getElementById('backlog_error');
    var new_post_form = doc.getElementById('new_post_form');
    var new_post_content = doc.getElementById('new_post_content');
    var showing_post = null;
    var update_delay = min_interval;
    var timer = null;

    function scroll_stream () {
        stream.scrollTop = stream.scrollHeight;
    }

    function unshow_post () {
        if (showing_post) {
            showing_post.className = showing_post.className.replace(/(\s|^)showing(\s|$)/, ' ');
        }
        showing_post = null;
    }
    function show_post (ref) {
        var pinned = doc.getElementById("pinned_" + parseInt(ref));
        if (pinned) {
            if (pinned == showing_post) {
                unshow_post();
            }
            else {
                pinned.scrollIntoView(true);
                pinned.className += " showing";
                if (showing_post) unshow_post();
                showing_post = pinned;
            }
        }
        else {
            var post = doc.getElementById("post_" + parseInt(ref));
            if (post) {
                if (post == showing_post) {
                    unshow_post();
                }
                else {
                    post.scrollIntoView(true);
                    post.className += " showing";
                    if (showing_post) unshow_post();
                    showing_post = post;
                }
            }
            else {
                unshow_post();
            }
        }
    }
    function get_post_id (post) {
        return post.id.match(/_(\d+)$/)[1];
    }
    function reply_to_post (ref) {
        new_post_content.value += ">>" + parseInt(ref) + " ";
        new_post_content.focus();
    }

    function handle_update () {
        if (this.readyState == this.DONE) {
            clear_error(update_error);
            if (this.status == 200) {
                if (this.responseXML != null) {
                    html = this.responseXML;
                    var new_posts = html.getElementById("new_posts");
                    var new_pinned = html.getElementById("new_pinned");
                    if (new_posts == null) {
                        make_error(update_error, "Update error: The server didn't include new_posts");
                        return;
                    }
                    var wants_scroll = (stream.scrollTop > stream.scrollHeight - stream.offsetHeight - 120);
                     // Update posts
                    var added_posts = false;
                    while (new_posts.firstChild != null) {
                        post = new_posts.firstChild;
                        if (post.nodeType == post.ELEMENT_NODE) {
                            added_posts = true;
                             // Add onclick handler for reply button, because I guess events on html
                             // elements loaded through AJAX don't get registered.  XSS safety?
                            var pid_match = post.id.match(/post_(\d+)/);
                            if (pid_match != null) {
                                var buttons = post.getElementsByTagName("button");
                                for (var i = 0; i < buttons.length; i++) {
                                    if (buttons[i].className == "reply_button")
                                        buttons[i].onclick = function(){reply_to_post(parseInt(pid_match[1]));return false;};
                                }
                            }
                             // Check if we need to pin/unpin/yell/unyell
                            var event_match = post.className.match(/(\s|^)this_(.*)_(.*)(\s|$)/);
                            if (event_match) {
                                if (event_match[2] == "pins") {
                                     // Don't do anything; Server should send new pinned posts.
                                }
                                else if (event_match[2] == "unpins") {
                                    var pinned_unpinned = doc.getElementById("pinned_" + event_match[3]);
                                    if (pinned_unpinned) {
                                        pinned_post_list.removeChild(pinned_unpinned);
                                    }
                                    var unpinned = doc.getElementById("post_" + event_match[3]);
                                    if (unpinned) {
                                        unpinned.className = unpinned.className.replace(/(\s|^)pinned(\s|$)/, ' ');
                                    }
                                }
                                else if (event_match[2] == "yells") {
                                    var yelled = doc.getElementById("post_" + event_match[3]);
                                    if (yelled) yelled.className += " yelled";
                                    var pinned_yelled = doc.getElementById("pinned_" + event_match[3]);
                                    if (pinned_yelled) pinned_yelled.className += " yelled";
                                }
                                else if (event_match[2] == "unyells") {
                                    var unyelled = doc.getElementById("post_" + event_match[3]);
                                    if (unyelled)
                                        unyelled.className = unyelled.className.replace(/(\s|^)yelled(\s|$)/, ' ');
                                    var pinned_unyelled = doc.getElementById("pinned_" + event_match[3]);
                                    if (pinned_unyelled)
                                        pinned_unyelled.className = pinned_unyelled.className.replace(/(\s|^)yelled(\s|$)/, ' ');
                                }
                            }
                             // Clear post content box if a post comes in that you posted.
                             // Quite hacky I know.  We're waiting till we can overhaul the entire AJAX system.
                            var by_match = post.className.match(/(\s|^)by_(.*)(\s|$)/);
                            if (by_match) {
                                if (parseInt(by_match[2]) == user) {
                                    new_post_content.value = '';
                                }
                            }
                        }
                         // Actually add the post
                        stream_post_list.appendChild(post);
                    }
                     // Update pinned posts
                    if (new_pinned != null) {
                        while (new_pinned.firstChild != null) {
                            post = new_pinned_posts.firstChild;
                            if (post.nodeType = post.ELEMENT_NODE) {
                                var found_slot = false;
                                for (var i = 0; i < pinned_post_list.children.length; i++) {
                                    p = pinned_post_list.children[i];
                                    if (p.nodeType == p.ELEMENT_NODE)
                                    if (get_post_id(p) > get_post_id(post)) {
                                        found_slot = true;
                                        pinned_post_list.insertBefore(post, p);
                                    }
                                }
                                if (!found_slot) {
                                    pinned_post_list.appendChild(post);
                                }
                                var pid_match = post.id.match(/pinned_(\d+)/);
                                if (pid_match != null) {
                                    var buttons = post.getElementsByTagName("button");
                                    for (var i = 0; i < buttons.length; i++) {
                                        if (buttons[i].className == "reply_button")
                                            buttons[i].onclick = function(){reply_to_post(parseInt(pid_match[1]));return false;};
                                        if (buttons[i].className == "edit_button")
                                            buttons[i].onclick = function(){start_edit(parseInt(pid_match[1]));return false;};
                                    }
                                }
                            }
                            else {
                                new_pinned.removeChild(post);
                            }
                        }
                    }
                     // Update latest post id
                    new_latest = html.getElementById("new_latest");
                    if (new_latest != null) latest = parseInt(new_latest.textContent);
                     // Update indicators
                    var new_indicators = html.getElementById("new_indicators");
                    if (new_indicators) {
                        var inds = new_indicators.getElementsByTagName("span");
                        if (inds.length == 0) make_error(update_error, "Warning: Server sent an empty new_indicators");
                        for (var i = 0; i < inds.length; i++) {
                            var ind = inds[i];
                            var old_ind = doc.getElementById(ind.id);
                            if (old_ind) {
                                old_ind.className = ind.className;
                            }
                            else {
                                make_error(update_error, "Warning: Server sent a new " + ind.id + " but we don't have one of those.");
                            }
                        }
                    }
                     // Set new timeout
                    if (added_posts) update_delay = min_interval;
                    else if (update_delay < max_interval) update_delay += min_interval;
                    else update_delay = max_interval;
                    timer = setTimeout( request_update, update_delay*1000 );
                     // Scroll to bottom
                    if (wants_scroll && added_posts) scroll_stream();
                }
                else {
                    make_error(update_error, "Update error: The server didn't response with valid XML");
                    return;
                }
            }
            else if (this.status == 0) {
                make_error(update_error, "No connectivity.  Please check your network connection.");
                timer = setTimeout( request_update, max_interval );
                return;
            }
            else {
                make_error(update_error, "Update error: The server returned " + this.status);
                return;
            }
        }
    }

    function handle_backlog () {
        if (this.readyState == this.DONE) {
            if (this.status == 200) {
                if (this.responseXML != null) {
                    var html = this.responseXML;
                    var old_posts = html.getElementById("old_posts");
                    if (old_posts == null) {
                        make_error(backlog_error, "Backlog error: The server didn't include old_posts");
                        return;
                    }
                    while (old_posts.lastChild != null) {
                        post = old_posts.lastChild;
                        stream_post_list.insertBefore(post, stream_post_list.firstChild);
                    }
                    var new_earliest = html.getElementById("new_earliest");
                    if (new_earliest != null)
                        earliest = parseInt(new_earliest.textContent);
                    else
                        backlog_area.textContent = "";

                }
                else {
                    make_error(backlog_error, "Backlog error: The server didn't response with valid XML");
                    return;
                }
            }
            else if (this.status == 0) {
                make_error(backlog_error, "No connectivity.  Please check your network connection.");
                return;
            }
            else {
                make_error(backlog_error, "Backlog error: The server returned " + this.status);
                return;
            }
        }
    }
    function handle_edit_form (id) {
        return function () {
            if (this.readyState == this.DONE) {
                if (this.status == 200) {
                    if (this.responseXML != null) {
                        var html = this.responseXML;
                        var form_post = html.getElementById('editing_' + id);
                        var old_post = doc.getElementById('pinned_' + id);
                        if (old_post != null) {
                            old_post.className += " really_hidden";
                        }
                        old_post.parentNode.insertBefore(form_post, old_post);
                        var buttons = form_post.getElementsByTagName("button");
                        for (var i = 0; i < buttons.length; i++) {
                            if (buttons[i].className == "edit_cancel_button")
                                buttons[i].onclick = function(){cancel_edit(id);return false;};
                        }
                    }
                }
            }
        }
    }

    function make_error (loc, mess) {
        loc.textContent = mess;
    }
    function append_error (loc, mess) {
        loc.textContent += mess;
    }
    function clear_error (loc) {
        loc.textContent = "";
    }
    function request_update () {
        var client = new XMLHttpRequest();
        client.onreadystatechange = handle_update;
        if (board != null)
            client.open("GET", "/main/update.xml?board=" + board + "&since=" + latest);
        else
            client.open("GET", "/main/update.xml?since=" + latest);
        client.send();
    }
    function request_backlog () {
        clear_error(backlog_error);
        var client = new XMLHttpRequest();
        client.onreadystatechange = handle_backlog;
        if (board != null)
            client.open("GET", "/main/backlog.xml?board=" + board + "&before=" + earliest);
        else
            client.open("GET", "/main/backlog.xml?before=" + earliest);
        client.send();
    }
    function start_edit (id) {
        var client = new XMLHttpRequest();
        client.onreadystatechange = handle_edit_form(id);
        client.open("GET", "/main/start_edit.xml?id=" + id);
        client.send();
    }
    function cancel_edit (id) {
        var form_post = doc.getElementById('editing_' + id);
        if (form_post != null)
            form_post.parentNode.removeChild(form_post);
        var old_post = doc.getElementById('pined_' + id);
        if (old_post != null)
            old_post.className = old_post.className.replace(/(\s|^)really_hidden(\s|$)/, ' ');
    }
    function start_updating () {
        timer = setTimeout( request_update, update_delay*1000 );
    }
    function when_submitting () {
        if (timer != null) clearTimeout(timer);
        update_delay = min_interval;
        request_update();
    }
    return {
        scroll_stream: scroll_stream,
        unshow_post: unshow_post,
    	show_post: show_post,
    	reply_to_post: reply_to_post,
    	handle_update: handle_update,
    	handle_backlog: handle_backlog,
    	make_error: make_error,
    	clear_error: clear_error,
    	request_update: request_update,
    	request_backlog: request_backlog,
    	start_updating: start_updating,
        when_submitting: when_submitting,
        start_edit: start_edit,
        cancel_edit: cancel_edit,
    }
}
