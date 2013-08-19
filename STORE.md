How the Store-Module works
==========================

This project doesn't use
[ActiveRecord](http://guides.rubyonrails.org/active_record_querying.html), 
[Mongoid](http://mongoid.org/), neither any other ORM.
Instead it implements a simple wrapper-module to store your objects
in simple
[PStore](http://ruby-doc.org/stdlib-1.9.3/libdoc/pstore/rdoc/PStore.html)-files.

Although, it depends on ActiveModel! There are ideas to get rid of this
dependency, in order to support not only Rails but also Sinatra and any
other ruby-web or non-web applications.

On the 'persistent-layer' this application depends on _PStore_ only –which is a
ruby-standard-lib-model–. So, we are in the green here. But validations
and naming used by including ActiveModel. The idea is to implement the
necessary methods within Store, thus we can use _Store_ in any other
ruby-environment, not only for Rails. (Sinatra, command-line, whatever)

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
    if @page.valid_without_errors?   # <=== (1)
      redirect_to page_path( @page )
    else
      flash.now[:alert]= t(:could_not_be_saved, what: t(:page))
      render :new
    end
  end
   
```
 
*(1)* You may use `.valid?` though, `valid_without_error?` not only
 checks on attribute-validations but also on other aspects of the
 Store-object.
 
Retrieve Objects from Store
----------------------------

You can retrieve this objects with

```ruby

page = Page.create title: 'My First Page', body: 'Hello World'
page = Page.find( 'my-first-page' )
page = Page.find_by( body: 'Hello World' )

```

Read the specs `spec/model/store_spec.rb` to find out more about the
Store-class.


How You Can Use It In Rails
---------------------------

See class `app/models/page.rb` and `app/controllers/pages_controller.rb`
how you can use it as an `ActiveModel` within Rails.


```ruby

class User

  include Store
  include BCrypt
  include Roles

  key_method :id
  attribute  :email
  validates_presence_of :email

  attribute  :name
  validates_presence_of :name

  attribute :password_digest
  
  # [...]
end

```



