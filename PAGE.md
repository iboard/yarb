<div id='page-index'></div>

# YARB Page

[Page] is a simple entity with a title and a body.
The body will be rendered as _Markdown_.

A [Page]  marked as a _draft_, is not listed in _PagesController::index_
unless the _current_user_ has a [Role] include
in `PagesController::PAGE_EDITOR_ROLES`.

## PagesController

[PagesController] is a standard _CRUD_ controller.
In addition to CRUD it loads/updates all *.md-files from the
project's root path. (eg.  README., TODO.).
Each file will is stored as a [Page].

### Access

 Action              | Roles needed
 ------------------- | ------------------------
 index               | public
 show                | public
 show (with drafts)  | PAGE_EDITOR_ROLES
 edit                | PAGE_EDITOR_ROLES
 create              | PAGE_CREATOR_ROLES
 delete              | PAGE_TERMINATOR_ROLES

Constants for roles are defined in [PagesController]

## Page Views

### Index

The index-view renders a list of [Page]s.

With a role in `PAGE_EDITOR_ROLES` you can sort the pages (using
drag-n-drop from coffeescript `SortableList`.

Editors can edit any [Page].

_Terminators_ can delete any [Page]

**Note**: If you delete or edit a [Page] imported from local md-files it
 will be reloaded/reset immediately.

# Dependencies Diagram

![YARB Page Dependency Map](http://dav.iboard.cc/container/yarb/doc/assets/page.png)


[User]: http://dav.iboard.cc/container/yarb/doc/User.html
[Page]: http://dav.iboard.cc/container/yarb/doc/Page.html
[PagesController]: http://dav.iboard.cc/container/yarb/doc/PagesController.html
[StaticPageUpdateService]: http://dav.iboard.cc/container/yarb/doc/StaticPageUpdateService.html
