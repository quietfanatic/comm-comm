comm-comm
=========

Community Communicator: An easy communication tool for small communities

Currently in the works.  The information below is for development purposes.




# Stage 1: minimum viable product

## SITE MAP
    1. Login screen
    2. Content page
    3. Admin panel?

## DATABASE
    1. users: id, username, email, hashed & salted password
    2. posts: owner, content
        * Should be editable by original poster

# Stage 2: Pinning and categories

## SITE MAP
    1. Login screen
        * Require member confirmation to join
    2. Content page(s)
        * One user-visible page per category, but only one controller+view total
        * Tabs for categories on left, live feed in first column, pinned posts in second column
    3. Settings tab, contains administrative options for admins

## DATABASE
    1. users: same
    2. posts: owner, content, category, pinned
        * I think pinned posts can be edited by all
        * If so, how do we resolve edit conflicts?
    3. categories: name

# Stage 3: Email integration

## SITE MAP
    * Should stay more or less the same

## DATABASE
    1. users: same, but with one boolean per category to recieve email notifications
    3. posts: same
    3. categories: name, whether to send notifications by default

## EMAIL
    * The user should receive an email digest of all the activity for each category
      that they've signed up for.
    * Each category uses its name for the email subject, plus "re: " if appropriate
    * Each category has its own email address.  Messages sent to that address from
      addresses owned by members are posted to the board.
        * Is it possible to authenticate that messages are actually sent from the
          address they say they're sent from?

