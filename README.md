comm-comm
=========

Community Communicator: An easy communication tool for small communities

Currently in the works.  The information below is for development purposes.




### Stage 1: minimum viable product

#### CONTROLLERS/VIEWS
    1. login: Login screen
    2. content: Content page
    3. settings: Admin panel for now

#### DATABASE
    1. users: id, admin, username, visible name, email, hashed & salted password
    2. posts: owner, content, date posted
        * Should be editable by original poster

### Stage 2: Pinning and 'topics'

#### CONTROLLERS/VIEWS
    1. login: Login screen
        * Require member confirmation to join
    2. content: Content page(s)
        * One user-visible page per topic; I think this can be done in routes.rb
        * Tabs for topics on left, live feed in first column, pinned posts in second column
    3. settings: Settings tab, contains administrative options for admins

#### DATABASE
    1. users: same, but add admin-changeable permissions to create and edit topics
    2. posts: owner, content, date, topic, pinned
        * I think pinned posts can be edited by all
        * If so, how do we resolve edit conflicts?
    3. topics: name, subtitle, perhaps some admin-changeable appearance settings?

### Stage 3: Email integration

#### CONTROLLERS/VIEWS
    * Should stay more or less the same

#### DATABASE
    1. users: same, but with one boolean per topic to recieve email notifications
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

