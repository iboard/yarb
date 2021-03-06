<div id='page-index'></div>

# YARB TODO

Bugs, Features, and Milestones are tracked at
[Github](https://github.com/iboard/yarb/issues)
This TODO.md-file is used for quick-notes and brainstorming only.

## Big Steps

1. Extract Store to a Gem (Problem – ActiveModel dependency in Gem?)
2. Extract User, SignUp, EMailConfirmation, and SignUpInvitation to an Account-Gem
3. Split Page/PageController thus Page is in a RAILS-independent applicaton
   and the Rails-App is accessing Page through a clean structure using
   interactors and boundaries.


Current work is tracked by [Pivotal Tracker](https://www.pivotaltracker.com/s/projects/891652)

### Packages to be extracted

![YARB Packages Draft](http://dav.iboard.cc/container/yarb/doc/assets/packages.png)


## Smells

1. Since the key-method prepares the key to be useable in URLs and as
   params, it is always a string. So, when the origin key-field is used
   as an Integer, .find(1) will not find the entry. Types for
   key-fields?!

2. model/identity: implements noop (virtual attributes) `old_password`
   This is to handle updating the password through the controller.
   So I wonder if this really belongs to the entity _Itentity_?
   Class `SignUp` could be a better place for this.

# Todos and Questions to answer

1. TODO: Draw a dependency-diagram for the application.
1. TODO: See if `Store::update_attributes` can be implemented more 'rails-like'
1. TODO: Should landing-page display the 'Welcome-page' if one with this
         title exists? (Default `Page` for landings-controller should be
         configurable in `Settings`)
1. TODO: Investigate in 'invalid hash error' with "rbx-19mode", and
         "jruby-19mode" on Travis-CI (disabled at the moment)
1. TODO: Localize Error Messages in exceptions?
         Yes, if exeption-messages are displayed to the users. No, if
         they are for devops and logs only.
1. TODO: Redirect to the page where 'Sign In' was clicked.
1. TODO: There is a dependency we should get rid of. Store depends on
         Rails ActiveModel::**.

## Done

1. _TODO: Create a `COLLABORATION.md` with instructions for
         collaborators. (done as a static page on yarb.iboard.cc now)_

### Needs refactoring

Last global review done 9/14/2013

#### User ID

Currently the parameterized email is used as the unique-id for the user
model. _Bad_. People may change their email-addresses and when we start
to implement a 'Page-Owner' it will no longer be allowed to change the
id of a user unless we goin' to implement some kinda ugly migration-task
which changes the key in all objects the User is connected to.

_Better_, we change the behavior of User by implementing a real, never
changing :id. Using the parameterized email in URLs should still be
supported but connecting objects to the user (foreign key) should be
done using the :id field instead of the email-key.

