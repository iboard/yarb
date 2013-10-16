<div id='page-index'></div>

![](http://dav.iboard.cc/container/yarb/yarb_Pulp-O-Mizer_Cover_Image.jpg)

# README

Also   | available| at
-------|----------|---------
[YARB] | [GITHUB] | [IBOARD]


## This is a Rails4-Starter-Application.

* [See in Action](http://yarb.iboard.cc/)
* [API-Documentation](http://dav.iboard.cc/container/yarb/doc/index.html)
* [Test-Coverage](http://dav.iboard.cc/container/yarb/coverage/index.html)

<div style='float: right; padding: 1em; margin-right: 1em; border: 1px solid #ddd; border-radius: 0.25em; '>
<strong>Travis-CI</strong><br/>
<a href='https://travis-ci.org/iboard/yarb'><img src='https://travis-ci.org/iboard/yarb.png' alt='Travis-Test-Status'/></a>
</div>

Ready to be used with

  * Should be green – see badge on the right
    * rvm 1.9.3
    * rvm 2.0.0
  * _Temporarily disabled_
    * rbx-19mode – _Errors with BCrypt and Marshal_ –
    * jruby-19mode – _Errors with BCrypt and Marshal_ –

**It integrates:**

  * Rails4
  * Twitter-Bootstrap (sass)
  * rspec
  * Jasmine Javascript Testing
  * HAML
  * SimpleCov
  * YARD
  * OmniAuth2
  * _Code-Highlighting with
    [Highlight.js](https://github.com/isagalaev/highlight.js)_

**It DOESN'T:**

  * use ActiveRecord or any other database
  * See file STORE.md for a short description

# HOW TO START

**Requirements**

  * `brew install phantomjs`

## Start

  * [Clone from github](https://github.com/iboard/yarb)
  * Make sure you use ruby1.9.3 or (better) ruby2.0.0 (`ruby -v`)
  * bundle with `bundle`
  * do the configuration as mentioned below
  * sart Guard with `guard`
  * start your development and stay clean ;-)

## Configuration

### For development

    cp config/environments/application_development_settings.rb_sample \
       config/environments/application_development_settings.rb
    cp config/secrets.rb_sample config/secrets.rb

  * Edit the file `application_development_settings.rb` to fit your
  needs. In production-mode you'll need a file
  `application_production_settings.rb` as well. DONT'T MODIFY
  `application_test_settings.rb` otherwise you'll break the tests.
  * Edit files `config/locales/site.*.yml` to setup your copyright and URL
  * Edit `config/secrets.rb` to configure your smtp-host and other settings.

### For production

    cp config/environments/application_development_settings.rb_sample \
       config/environments/application_production_settings.rb

  * Edit settings listed above for your production environment
  * Edit [PRIVACY].md and explain how you will treat user-data on your
    system.
  * Modify lib/task/deploy to fit your needs.

## For testing

No setup is neccessary for testing. Just run

    $ rake
    $ rake -T


# What You Can do

## With the source

  * Run `rake` to run all specs and then `open coverage/index.html` to see your test-coverage.
  * Run `rake full` will also run Jasmine-tests.
  * Run `rake fast` will skip specs invoking javascript (they are slow)
  * Run `rake long` will display not only dots but spec-descriptions.
  * Run `yard` to generate the current documentation and `open doc/index.html`

## With the Application

Start `rails server` and visit `http://0.0.0.0:3000`. You'll see a list
of "[Page]s" which are the html-representation of all markdown-files found
in the root-path of the application.

If you create a User with admin-role on the console (see below) you'll
be able to add, edit, and delete [Page]s.

When `needs_invitation` in `config/environments/application_developemnt_settings.rb` is enabled, you can invite other users (by sending email).

# TDD

The project follows 100% TDD. Run `rake` to run all test.
To get more response as green dots run `rspec -f d`. The readable list
of specs will give you an idea what the app is doing so far.

## Using Solid State Disks

Running the tests will write files in `db/test` and `./tmp` over and over
again. This will harm your SSD. I recommend to use a RAM-Disk for your
`/tmp` path of the maschine and sym-link the directories `db/test` and
`./tmp` to this RAM-disk.

See [this blog](http://blog.alutam.com/2012/04/01/optimizing-macos-x-lion-for-ssd/)

## Continuous Testing

The app uses [Travis-CI](https://travis-ci.org/iboard/yarb) for continuous testing
the integration with different Ruby-environments. – _See the list of
tested rubies and the current Travis-state on top of this page._

# The Starter App

  * The root-path goes to `LandingsController#index`
  * The main menu is defined in `app/views/layouts/_navigation.haml` add your menu-items there.
  * Define your Bootstrap-variables in `app/assets/stylesheets/_variables.scss`
  * Overwrite Bootstrap-css in `app/assets/stylesheets/_bootstrap_overwrite.scss`

## APP-Features

  * Reads all *md-files from project's root and stores them as [Page]s.
  * `/pages` lists all pages with Edit- and Delete- Buttons.
  * At `/pages/new` you can create new pages.
  * It implements a responsive design using Twitter-bootstrap and sass.
  * It implements omniauth-identity and omniauth-* (several providers.
    see `config/secrets.rb_sample` and `Gemfile`
  * You can configure if sign-up is public or with invitation only.
    see `config/environments/application_:env_settings.rb`

## Users

Though, you can create a new user at `/sign_up`. There is no way
to make the first user an admin. You have to do this through the console.

```ruby

rails console development

user = User.create name: "Your name", email: "your@email.cc"
user.password = "your secret word"
user.roles = [ :admin ]
user.save

```

Once this is done for the first user, you can sign-in with email and
password. As an admin you can invite other users and modify their roles
in _Edit User_.

For more information read [USER_AND_SESSION]

# Deploy

There are two rake-tasks in `lib/tasks/deploy.rake` which alows to
rsync doc/* to a web-server and the application itself to a
production-server, running 'thin'.

It's planed to implement a full capistano-deploy-script when the project
grows up. By now you have to change the user and hostnames for your
needs.


# Contribution

  * Read [Collaboration](http://yarb.iboard.cc/pages/collaboration)
  * Pull-requests are appreciated if full test-covered, clean, and in
    their own branch.
  * Story tracking is maintained at:
    [PivotalTracker](https://www.pivotaltracker.com/projects/891652/overview)
    Please pick from currently defined stories before you start your
    own.
  * Issues and Bug-reports are tracked at
    [Github](https://github.com/iboard/yarb/issues)

If you collaborate or just be interested in this project, I recommend to
follow [Refactoring Notes](http://yarb.iboard.cc/pages/refactoring_notes). It
gives you an idea what 'Clean' means in this project. Any notice,
comment, hint, and arguing is welcome!

# Why use Pstore instead of ActiveRecord, MongoId, ...

> If you start your application-development after you decide to use
> ActiveRecord, MongoId, whathever, you may find yourself developing
> an AR, Mongo, Whatever application.
> Postpone this decision as long as possible and start developing
> *Your-Application*.

*[PStore](http://ruby-doc.org/stdlib-1.9.3/libdoc/pstore/rdoc/PStore.html)* is a class from ruby's standard-library.

_YARB_ implements as less as possible on the
'ORM-side' to give you a Layer/Interface to persist your data.
Moving from this to a 'real' ORM should not be that challenge and
should be doable by changing a few lines.

Sure, this is just a demonstration and it still depends on ActiveModel,
you may argument. Anyway, if you take a look at, what is used from
ActiveModel, you will see… not much.

When I decide to use ActiveModel, it was not about, “I’m using
ActiveModel, so, how I have to implement validations?”. The question
was, “Ok, every Store-model will have a need of validations; let’s see
how easy it is to do this with ActiveModel::Validations.”


# License: MIT

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

[Page]: http://dav.iboard.cc/container/yarb/doc/file.PAGE.html
[USER_AND_SESSION]: http://dav.iboard.cc/container/yarb/doc/file.USER_AND_SESSION.html
[PRIVACY]: http://dav.iboard.cc/container/yarb/doc/file.PRIVACY.html
[YARB]: http://yarb.iboard.cc/pages/readme
[GITHUB]: https://github.com/iboard/yarb/blob/master/README.md
[IBOARD]: http://dav.iboard.cc/container/yarb/doc/file.README.html
