Integration for Neo4j.rb and will_paginate
============================================

This gem is just a simple integration of will_paginate and neo4j.

Which version do I use?
==================

Neo4j.rb 2.x: 0.2.1<br />
Neo4j.rb 3.0 < alpha 8: 0.2.2<br />
Neo4j.rb 3.0 > alpha 7: Latest

Installation
==================

1. Add `neo4j-will_paginate` to your `Gemfile`.
2. `require 'neo4j-will_paginate'` somewhere from your code.

Using
==================

Please see the [will_paginate](https://github.com/mislav/will_paginate)
and [neo4j.rb](https://github.com/andreasronge/neo4j) for details.

But here is simple example:


```ruby
# Probably in the Rails controller:

def index
  # :per_page is optional
  # :return is also optional. To return multiple objects, use an array of symbols
  # :order is -- you guessed it -- optional, too. It accepts the same arguments as Neo4j::ActiveNode::QueryProxy's `order` method
  @people = Person.(as: :p).where(age: 30).paginate(:page => 2, :per_page => 20, return: :p, order: :name) 
end

# Then in the view:
paginate @people

```

License
=====================

MIT by Dmytrii Nagirniak, Andreas Ronge, and Chris Grigg
