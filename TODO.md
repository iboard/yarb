<div id='page-index'></div>

# YARB TODO

Bugs, Features, and Milestones are tracked at
[Github](https://github.com/iboard/yarb/issues)
This TODO.md-file is used for quick-notes and brainstorming only.

Current work is tracked by [Pivotal Tracker](https://www.pivotaltracker.com/s/projects/891652)

## Smells

1. Since the key-method prepares the key to be useable in URLs and as
   params, it is always a string. So, when the origin key-field is used
   as an Integer, .find(1) will not find the entry. Types for
   key-fields?!


# Todos

1. TODO: Rewrite STORE.md ;-)
1. TODO: See if `Store::update_attributes` can be implemented more 'rails-like'
1. TODO: Should landing-page display the 'Welcome-page' if one with this
         title exists?
1. TODO: Investigate in 'invalid hash error' with "rbx-19mode", and
         "jruby-19mode" on Travis-CI (disabled at the moment)
1. TODO: Localize Error Messages in exceptions
1. TODO: Redirect to the page where 'Sign In' was clicked.
1. TODO: There is a dependency we should get rid of. Store depends on
         Rails ActiveModel::**.

## Done
1. _TODO: Create a `COLLABORATION.md` with instructions for
         collaborators. (done as a static page on yarb.iboard.cc now)_

### Needs refactoring

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

