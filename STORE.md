How the Store-Module works
==========================

This project doesn't use
[ActiveRecord](http://guides.rubyonrails.org/active_record_querying.html), 
[Mongoid](http://mongoid.org/), neither any other ORM.
Instead it implements a simple wrapper-module to store your objects
in simple
[PStore](http://ruby-doc.org/stdlib-1.9.3/libdoc/pstore/rdoc/PStore.html)-files.

Example
=======

Define The Class
----------------
  
```ruby

class MyClass
  include Store
  key_method :uid
  attribute  :city

  def uid
    #return a unique key for your objects
  end
end
#....
object = MyClass.new
object.save
```

 This will save objects of class MyClass in
 `Rails.root/Rails.env/my_class/my_class.pstore`
 
Retrieve Objects from Store
----------------------------

Later you can retrieve this objects with

```ruby

object = MyClass.find( 'my_key' )
object = MyClass.find_by( city: 'London' )
```

Read the specs `spec/model/store_spec.rb` to find out more about the
Store-class.


How You Can Use It In Rails
---------------------------

See class `app/models/page.rb` and `app/controllers/pages_controller.rb`
how you can use it as an `ActiveModel` within Rails.



