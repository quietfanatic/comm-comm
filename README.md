comm-comm
=========

Community Communicator: An easy communication tool for small communities

Currently in the works.  The information below is for development purposes.




### Stage 1: minimum viable product

#### CONTROLLERS/VIEWS
    1. login: Login screen
        * Require member confirmation to join
    2. content: Content page
    3. settings: Nothing

#### DATABASE
    1. users: id, visible name, email, hashed & salted password, is confirmed
    2. posts: owner, content, date posted

### Stage 2: Pinning and 'topics'

#### CONTROLLERS/VIEWS
    - login
        - entrance
        - login (post and redirect)
        - signup
        - journey
    - main
        - topic
            * Actually have multiple topics.  They'll be in tabs on the left.
            * Allow posts to be pinned.
            * Show only the N most recent non-pinned posts, but load more on request
    - settings
        - site
            * Create, edit, and delete topics
            * Global site settings (colorscheme perhaps?)
        - users
            * Allow confirming members and setting permissions
        - preferences
            * User-specific settings (notifications, display settings, etc.)
            * Change your visible name
        
#### DATABASE
    1. users: Implement system of permissions (prefixed with can)
    2. posts: owner, content, date, topic, pinned
        * Posts should be reply-toable and derivable by others
    3. topics: name, subtitle, perhaps some admin-changeable appearance settings?

### Stage 3: Email integration

#### CONTROLLERS/VIEWS
    * Should stay more or less the same

#### DATABASE
    1. users: same, but with one boolean per topic to recieve email notifications?
    3. posts: same
    3. topics: name, whether to send notifications by default

#### EMAIL STUFF
    * The user should receive an email digest of all the activity for each topic
      that they've signed up for.  Heavy activity will be condensed to have multiple
    * Each topic uses its name for the email subject, plus "re: " if appropriate
    * Each topic has its own email address.  Messages sent to that address from
      addresses owned by members are posted to the board.
        * Is it possible to authenticate that messages are actually sent from the
          address they say they're sent from?

