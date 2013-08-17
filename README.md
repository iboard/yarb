README
======

This is a Rails4-Starter-Application.
(See in [Action](http://yarb.iboard.cc/pages/welcome))

<div style='float: right; padding: 1em; margin-right: 1em; border: 1px solid #ddd; border-radius: 0.25em; '>
<strong>Travis-CI</strong><br/>
<a href='https://travis-ci.org/iboard/yarb'><img src='https://travis-ci.org/iboard/yarb.png' alt='Travis-Test-Status'/></a>
</div>

Ready to be used with

  * rvm 1.9.3
  * rvm 2.0.0
  * rbx-19mode
  * rbx-19mode
  * jruby-19mode

**It integrates:**

  * Rails4
  * Twitter-Bootstrap (sass) 
  * rspec
  * Jasmine Javascript Testing
  * HAML
  * SimpleCov
  * YARD
  * _Code-Highlighting with
    [Highlight.js](https://github.com/isagalaev/highlight.js)_

**It DOESN'T:**

  * use ActiveRecord or any other database
  * See file STORE.md for a short description

HOW TO START
============

**Requirements**

  * `brew install phantomjs`

**Start**

  * [Clone from github](https://github.com/iboard/yarb)
  * Make sure you use ruby1.9.3 or (better) ruby2.0.0 (`ruby -v`)
  * bundle with `bundle`
  * sart Guard with `guard`
  * start your development and stay clean ;-)

**Configuration**

  * Edit files `config/locales/site.*.yml` to setup your copyright and URL

What You Can do
===============

  * Run `rake` to run all specs and then `open coverage/index.html` to see your test-coverage.
  * Run `yard` to generate the current documentation and `open doc/index.html`

TDD
===

The project follows 100% TDD. Run `rake` to run all test.
To get more response as green dots run `rspec -f d`. The readable list
of specs will give you an idea what the app is doing so far.

Continuous Testing
------------------

The app uses [Travis-CI](https://travis-ci.org) to continuous testing
the integration with different Ruby-environments. _See the list above,
and the the bdage representing the current state on Travis-CI.

The Starter App
===============

  * The root-path goes to LandingsController#index
  * The main menu is defined in `app/views/layouts/_navigation.haml` add your menu-items there.
  * Define your Bootstrap-variables in `app/assets/stylesheets/_variables.scss`
  * Overwrite Bootstrap-css in `app/assets/stylesheets/_bootstrap_overwrite.scss`
  
APP-Features
------------

  * Reads all *md-files from project's root and stores them as Pages.
  * `/pages` lists all pages with Edit- and Delete- Buttons.
  * At `/pages/new` you can create new pages.

Contribution
============
  
  * Pull-requests are appreciated if full test-covered, clean, and in
    their own branch.
  * Story tracking is maintained at:
    [PivotalTracker](https://www.pivotaltracker.com/projects/891652/overview)
    Please pick from currently defined stories before you start your
    own.
  * Issues and Bug-reports are tracked at 
    [Github](https://github.com/iboard/yarb/issues)


License: MIT
============

Copyright (C) 2013 Andreas Altendorfer

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the 
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


