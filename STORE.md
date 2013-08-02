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

    class MyClass
      include Store
      key_method :uid

      def uid
        #return a unique key for your objects
      end
    end
    
    ....
    object = MyClass.new
    object.save

 This will save objects of class MyClass in
 `Rails.root/Rails.env/my_class/my_class.pstore`
 
 Later you can retrieve this objects with

     objecet = MyClass.find( 'my_key' )




