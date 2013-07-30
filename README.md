README
======

This is a Rails4-Starter-Application.

**It integrates:**

  * Rails4
  * Twitter-Bootstrap (sass) 
  * rspec
  * Jasmine Javascript Testing
  * HAML
  * SimpleCov
  * YARD

**It DOESN'T:**

  * use ActiveRecord or any other database

HOW TO START
============

  * [Clone from github](https://github.com/iboard/yarb)
  * Make sure you use ruby1.9.3 or (better) ruby2.0.0 (`ruby -v`)
  * bundle with `bundle`
  * sart Guard with `guard`
  * start your development and stay clean ;-)

What You Can do
===============

  * Run `rake` to run all specs and then `open coverage/index.html` to see your test-coverage.
  * Run `yard` to generate the current documentation and `open doc/index.html`

The Starter App
===============

  * The root-path goes to LandingsController#index
  * The main menu is defined in `app/views/layouts/_navigation.haml` add your menu-items there.
  * Define your Bootstrap-variables in `app/assets/stylesheets/_variables.scss`

License
=======

MIT
---

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


