Community Communicator
======================

An easy communication tool for small communities

Currently in the works.  The information below is for development purposes.

## Current features

 * Having users posting to multiple boards
 * Simple and intuitive interface
 * Invitation-only (new member accounts must be confirmed by someone who has the permission to do so)
 * Live AJAX updating of new posts and events
 * The ability to pin posts to make them more permanent (and unpin them)
 * The ability to hide posts that are yours or that contain images
 * The ability to mail posts to selected registered users
 * bbcode markup in posts
 * Posts are scanned for references to other posts in >>1234 format
 * Activity indicators on each tab, colored differently for different types of activity, including replies to posts you've made
 * Button to reply to a post (automaticaly insert a reference into the post form textarea
 * Editing of boards: their names, order, posts-per-page
 * Merging one board into another, and undoing the last merge done
 * Editing of users, exiling bad users, reinstating previously exiled users
 * Per-feature permissions to do various things.
 * Detailed smtp configuration through UI
 * Viewing and managing all your logged in sessions

## Features on the radar, short term

 * Editing posts that have been pinned (actually creates a new derived post)
 * Checkboxes when you submit a post to automatically pin it or send through mail dialog page
 * Having up to three nicknames in your profile.  Posts will be scanned for those nicknames and your username and treated accordingly as mentions
 * Allow some boards to be publicly viewable
 * Let users who have permission change aspects of the site's appearance

## Long term plans

 * Tagging of posts to differentiate between multiple topics during heavy usage, and filtering posts by their topic
 * Allow some boards to be publicly postable (with some anti-spam protections)
 * True live update, pushed from server to client, through a webSocket or comet or something



