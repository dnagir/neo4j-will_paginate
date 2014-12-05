Integration for Neo4j.rb and will_paginate
============================================

This gem is just a simple integration of will_paginate and neo4j. It was formerly known as [neo4j-will_paginate](https://github.com/dnagir/neo4j-will_paginate) but is being maintained here.

Which version do I use?
==================

If you're using Neo4jrb 3, use this; otherwise, use the legacy version linked above.

Installation
==================

1. Add `neo4j-will_paginate_redux` to your `Gemfile`.
2. `require 'neo4j-will_paginate_redux'` somewhere from your code.

Using
==================

Please see the [will_paginate](https://github.com/mislav/will_paginate)
and [neo4j.rb](https://github.com/neo4jrb/neo4j) for details.

But here is a simple example:

```ruby
# Probably in the Rails controller:

def index
  # :per_page is optional
  # :return is also optional. To return multiple objects, use an array of symbols
  # :order is -- you guessed it -- optional, too. It accepts the same arguments as Neo4j::ActiveNode::QueryProxy's `order` method
  @people = Person.as(:p).where(age: 30).paginate(:page => 2, :per_page => 20, return: :p, order: :name) 
end

# Then in the view:
will_paginate @people

```

License
=====================

MIT by Dmytrii Nagirniak, Andreas Ronge, and Chris Grigg
