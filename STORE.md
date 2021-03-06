How the Store-Module works
==========================

[API-Documentation](http://dav.iboard.cc/container/yarb/doc/Store.html)

This project doesn't use
[ActiveRecord](http://guides.rubyonrails.org/active_record_querying.html),
[Mongoid](http://mongoid.org/), neither any other ORM.
Instead it implements a simple wrapper-module to store your objects
in simple
[PStore](http://ruby-doc.org/stdlib-1.9.3/libdoc/pstore/rdoc/PStore.html)-files.


<div class='row'>
  <div class='span6'>
    <h3>ActiveModel</h3>

    <p>Although, it depends on ActiveModel. There are ideas to get rid of this
    dependency, in order to support not only Rails but also Sinatra and any
    other ruby-web or non-web applications. Anyhow, this task is
    posponed to a not defined time-frame.</p>

    <p>On the 'persistent-layer' this application depends on <em>PStore</em> only –which is a
    ruby-standard-lib-model–. So, we are in the green here. Only validations
    and naming uses ActiveModel. The idea is to implement the
    necessary methods within <em>Store</em>, thus we can use <em>Store</em> in any other
    ruby-environment.</p>

    <p>
      See <a href='https://groups.google.com/forum/#!topic/iboard-collaboration/Jfo2HuQG_yA'>Discussion</a>
    </p>
  </div>
  <div class='span6'>
    <img src='http://dav.iboard.cc/container/yarb/PStore-Model.png'/>
  </div>
</div>

Example
=======

Define The Class
----------------

```ruby

class Page

  include Store
  key_method :title
  attribute  :title
  attribute  :body

  def initialize _attributes={}
    set_attributes ensure_defaults(_attributes)
  end

end
```

This will save objects of class Page in `Rails.root/db/Rails.env/page/page.pstore`

You can create and use the objects just as you know from Rails

```ruby
# PagesController ...

  # GET /pages/new
  def new
    @page = Page.new
  end

  # POST /pages/create
  def create
    @page = Page.create( params[:page] )
    if @page.valid?
      redirect_to page_path( @page )
    else
      flash.now[:alert]= t(:could_not_be_saved, what: t(:page))
      render :new
    end
  end

```

Retrieve Objects from Store
----------------------------

You can retrieve this objects with

```ruby

page = Page.create title: 'My First Page', body: 'Hello World'
page = Page.find( 'my-first-page' )
page = Page.find_by( body: 'Hello World' )
pages = Page.where( some_flag: true, and_other_flag: false, ... )

```

Read the specs `spec/model/store_spec.rb` to find out more about the
Store-class.


How You Can Use It In Rails
---------------------------

See class `app/models/page.rb` and `app/controllers/pages_controller.rb`
how you can use it as an `ActiveModel` within Rails.


Validations
-----------

Most of the validators are used from _ActiveModel_.
E.g. _validate_presence_of_ is used from _ActiveModel_ where uniqueness
must be implemented by Store itself (it's a method of ActiveRecord).

```ruby

class User

  include Store
  include BCrypt
  include Roles

  key_method :id
  attribute  :email, unique: true
  validates_presence_of :email

  attribute  :name
  validates_presence_of :name

  attribute :password_digest

  # [...]
end

```



