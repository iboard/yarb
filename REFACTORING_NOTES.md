YARB Refactoring Notes
======================

<!-- Place this tag where you want the +1 button to render. -->
<div class="g-plusone" data-annotation="inline" data-width="300"></div>

----

## Null-Objects are much better than if !nil? ;-)

#### Commit: [Refactored current_user <=> NilUser](https://github.com/iboard/yarb/commit/0017ba577bcc004d51be3b1cccaa733a04aa1119)

> I can't stand this `if current_user then current_user.something` all
> over the views and controllers anymore.

This refactoring defines a class `NilUser` which offers all the public
methods of a regular User-object but returns some 'defaults' only, but
whitout any logic behind. `authorized?` always returns `false` and so.

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

<!-- Place this tag after the last +1 button tag. -->
<script type="text/javascript">
  (function() {
var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
  po.src = 'https://apis.google.com/js/plusone.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
})();
</script>