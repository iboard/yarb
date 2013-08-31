YARB TODO
=========

Bugs, Features, and Milestones are tracked officially at
[Github](https://github.com/iboard/yarb/issues)
This TODO.md-file is used for quick-notes and brainstorming only.

Smells
------

1. Since the key-method prepares the key to be useable in URLs and as
   params, it is always a string. So, when the origin key-field is used
   as an Integer, .find(1) will not find the entry. Types for
   key-fields?!


1. TODO: See if `Store::update_attributes` can be implemented more 'rails-like'
1. TODO: Should landing-page display the 'Welcome-page' if one with this
         title exists?
1. TODO: Create a `COLLABORATION.md` with instructions for
         collaborators.         
1. TODO: Investigate in 'invalid hash error' with "rbx-19mode", and
         "jruby-19mode" on Travis-CI (disabled at the moment)
1. TODO: Localize Error Messages in exceptions         
1. TODO: Redirect to the page where 'Sign In' was clicked.         
1. TODO: There is a dependency we should get rid of. Store depends on
         Rails ActiveModel::**.
