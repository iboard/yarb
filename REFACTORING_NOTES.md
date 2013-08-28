# YARB Refactoring Notes on [Commits](https://github.com/iboard/yarb/commits/master)

<!-- Place this tag where you want the +1 button to render. -->
<div style='height: 35px; min-height: 35px;' class="g-plusone" data-annotation="inline" data-width="300"></div>

## Implemented a Selector class

### Commit: [Fully implemented Selector](https://github.com/iboard/yarb/commit/4a958a7ceab029566eb9dd03d483887697abd11d) 

> A Selector wraps the objects in a Store-class.

```ruby
  admins = User.where admin: true
  local_admins = admins.where zip: 4053
  local_admins.each do |admin|
    admin.class #=> User
  end
  admins.class #=> Selector
  loacaladmins.class #=> Selector
```

**Changes to the Store-module**

  1. roots() initialize a Selector with all objects/records.
  2. where() and other methods moved to the Selector-class.

This means, if you `.where(...)` on a _StoreClass_ you no longer get an
Array of objects but a _Selector-object_, you can use for further restricting with
an `.where()` on this selector.

## There is no Boolean class in Ruby

#### Commit: [Added Boolean Attribute for Store](https://github.com/iboard/yarb/commit/c9d261606955a15d8464470a7adf1ab91dda5276)

> The problem occurs first when Form submits "0"/"1" instead of
> false/true for checkboxes. 

I implemented a Boolean-class which handles "0"/0 as false and "1"/1 as true. 
Therefore it was necessary to change the behavior of the class
`AttributeDefinition`.

[Short summary of boolean implementation ...](https://gist.github.com/iboard/6321356)

#### Commit: [Removed Workaround in PagesController](https://github.com/iboard/yarb/commit/e2329ebf1417e05f37d77ae26b2629dd4e8e172c)

> With the Boolean-Class working, it's possible to remove the Workaround
> from the Controller.

----


## Don't waste time on unimportant stuff

#### Commit: [Disabled Turbolinks](https://github.com/iboard/yarb/commit/e8afa42805baca0115870724efed3b405d6036eb)

> HTML5 video-tags works on the first load of the site. But then,
> when clicking around _–with turbolinks active–_ and return to the
> same page containing a video already shown before, this videos will not
> work anymore unless you press the browser's reload-button.

I spent to much time on figuring out how to solve this problem. 
But, at the moment _turbolinks_ are not important. 
At least at this point of the project.  So, I disabled it completely.

----

## With a little help from StackOverflow

#### Commit: [Refactored safe_compare workaround](https://github.com/iboard/yarb/commit/5f00305d8599bebb6d4a806741c12d896ccd5055)

> First I didn't understand why the exception wasn't caught. But
> thankfully, [@7stud][7stud] posted a good explanation at
> [Stackoverflow][so_spaceship]


----

## 101 Commits

#### Commit: [Refactored all files](https://github.com/iboard/yarb/commit/c86a4ac7b062a825339f13584ed51ffa07aaabb7)

> 101 Commits, it's just a good time to make it perfect ;-)

* Added TODO-entries to TODO.md about things I recognized and couldn't
  solve ad-hoc.
* Made coffeescript-class-functions 'private' where
  possible.
* Added some documentation-remarks to CSS.
* _Controllers_ – Made public methods more readable. Added caching for
  instance-variables.
* _ApplicationHelper_ – defined more helpers, in order to get rid of 
  Twitter-Bootstrap-stuff in views.
* _Views_ – remove all hardcoded _Bootstrap_-code
* _General_ – removed `to_s` where not necessary.

----

## Null-Objects are much better than if !nil? ;-)

#### Commit: [Refactored current_user <=> NilUser](https://github.com/iboard/yarb/commit/0017ba577bcc004d51be3b1cccaa733a04aa1119)

> I can't stand this `if current_user then current_user.something` all
> over the views and controllers anymore.

This refactoring defines a class `NilUser` which offers all the public
methods of a regular User-object but returns some 'defaults' only, but
whitout any logic behind. `authorized?` always returns `false` and so on.

Instead of

```haml

- if current_user
  = current_user.name
- else
  = "Anonymous"
```

we now can write just

```haml

= current_user.name
```

----

##Extract parameter-pairs into a class

#### commit: [Extracted Attribute-definition-pairs into a class](https://github.com/iboard/yarb/commit/b5a4829ca6176385f7f31173466d0bb2193de758)

> Attribute-definitions exists as a pair of :key, :default, and :key, :value 
> and it became a mess to type this Array-braces everywhere.
> _AttributeDefinition_ should really be a class on it's own, thus we
> can pass a single parameter instead of the array.

```ruby

(@attribute_definitions||=[]) << [name, default]
```

will become

```ruby

attribute_definitions << AttributeDefinition.new( name, default )
```

This is not only better to read, it also offers a clean way to extend
the parameters of an AttributeDefinition later.

Where `AttributeDefinition` represents a single attribute of a
Store-object, the pluralized form `AttributeDefinitions` is used to hold
and act on all attributes of a Store-object.

With this two new classes you'll see a lot of improvement in the sense
of *_Tell, don't Ask_* within the Store-module.


----

##A Bugfix for production and a redesign

#### commit: [Move Store from modules to lib](https://github.com/iboard/yarb/commit/d28802d33388da1fcfdfd45e32a113f408b8bcba)

> When I defined the classes `AttributeDefinitions` and
`AttributeDefinition` I thought it would be good to wrap them into the
Store-Module and extract their code to their own files.
> Sure, that's still a good idea, but WTF, when I deployed the app to my
Linux-box, it doesn't start in production-mode.
> I figured out that Rails' eager-loading and caching didn't load the
'extra-module' when the files are in path `app/module`.

First I tried to force Rails to eager-load my module and classes. But
this was a terrible hack and ended in doing a `git reset` when I got stuck.

A much better approach is to move the entire Store-module into the path
`lib/store`. Why? It worked ad-hoc even in :production and sure(!) this is not
business-logic and should not reside in `app/...` anyhow.

It'll be even easier to extract `Store` as a Gem and use it in other
Rails-projects when we want to.

Also I got rid of two unused constants. Unfortunately, `SimpleCov` will
not report them as untested even if they're not used. They are assigned
and that's why they are 'covered' when the app runs.

----

## Standard Cleaning

#### commit: [Cleaned up all the code](https://github.com/iboard/yarb/commit/630b6a093fa31c4aced6556bc1c12ae1d7bb722f)

> I looked through all files and views and did some standard stuff as,
> extracting partials, define helpers, make one-liners, wherever it's
> possible.

----

## Syntactic Sugar and Beauty

#### commit: [In a perfect clean mood](https://github.com/iboard/yarb/commit/eb4eab2fffa01318fb3947d76d6974b414b17807)

> I renamed `load_md_files` to `refresh_md_files` to make clear the
> files are readed –loaded from the md-file into a Page-object– every
> time. So this pages will refresh not only be created once.

This change seams to be ridiculous at the moment, tho. Little changes like this 
maybe a real time-safer when the project grows.

----

## Prevent from duplication

#### commit: [Found one more](https://github.com/iboard/yarb/commit/9189087a35ab2e122dc29c3084c12a49dc73730b)

> Often you want the user to be redirected where they come from after
> an action. `redirect_to :back` may fail so you have to check for the
> existence of HTTP_REFERRER every time.
  
I moved this `if` into a helper named `redirect_back_or_to`. And I use
this helper where it make sense but no :back-redirection was done yet.

> `signed_in?` a private method?

No, it definitely belongs to the public API of `ApplicationController`,
thus a user –_when I talk about a user here, I mean a programmer using
this code, not a consumer_– can benefit from and use it instead of
defining a duple. 


[7stud]:  http://stackoverflow.com/users/926143/7stud 
[so_spaceship]:  http://stackoverflow.com/questions/18346352/how-does-the-spaceship-operator-in-ruby-throw-exceptions  


<!-- Place this tag after the last +1 button tag. -->
<script type="text/javascript">
  (function() {
var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
  po.src = 'https://apis.google.com/js/plusone.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
})();
</script>
