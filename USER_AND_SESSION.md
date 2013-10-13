<div id='page-index'></div>

# User And Session Handling In YARB

Also   | available| at
-------|----------|---------
[YARB] | [GITHUB] | [IBOARD]

_see on [yard.iboard.cc](http://yard.iboard.cc/pages/user_and_session)

In YARB a _[User]_ has one or more _[Authentication]s_. Where an
_[Authentication]_ can refer to an external _OmniAuth Provider_ (Twitter,
Google, LinkedIn, ...) or can have a local _[Identity]_

## Invitations

In file `config/environments/application_:env_settings.rb` you can
configure either an _[Invitation]_ is needed to sign up or the sign up is
public for everyone.

## Sign Up Controller

Through the _[SignUpController]_ you can create a new user with a local
_[Identity]_. If the user clicks to sign up using an OmniAuth-provider,
the callback from the provider will go to the _[SessionController]_ which
will implicitly create the _[User]_ and _[Authentication]_ for the used
provider.

## Session Controller

The _[SessionController]_ signs in existing users using a local _[Identity]_
or, when called from a provider-callback, it implicitly creates _[User]_
and/or signs them in.

### Using an OmniAuth-provider

If the user uses an external provider for authentication, the callback
from the provider returns to _[SessionController]_, regardless it's a
_[SignUp]_ or a _SignIn_. The _[SessionController]_ will `find_or_create`
the _[User]_ and the _[Authentication]_.

### Using Identity

When using a local _[Identity]_ the _[SessionController]_ will obviously
not create a new _[User]_ but will respond with "Invalidate Credentials"

# Dependencies Diagram

![YARB User/Session/Authenticaton Dependency Map](http://dav.iboard.cc/container/yarb/doc/assets/user-and-session.png)


[YARB]: http://yarb.iboard.cc/pages/user_and_session
[GITHUB]: https://github.com/iboard/yarb/blob/master/USER_AND_SESSION.md
[IBOARD]: http://dav.iboard.cc/container/yarb/doc/file.USER_AND_SESSION.html
[User]: http://dav.iboard.cc/container/yarb/doc/User.html
[SignUp]: http://dav.iboard.cc/container/yarb/doc/SignUp.html
[Invitation]: http://dav.iboard.cc/container/yarb/doc/SignUpInvitation.html
[SessionController]: http://dav.iboard.cc/container/yarb/doc/SessionController.html
[SignUpController]: http://dav.iboard.cc/container/yarb/doc/SignUpController.html
[Authentication]: http://dav.iboard.cc/container/yarb/doc/Authentication.html
[Identity]: http://dav.iboard.cc/container/yarb/doc/Identity.html
