Integration for Neo4j.rb and will_paginate
============================================

This gem is just a simple integration of will_paginate and neo4j.
[![Build Status](https://secure.travis-ci.org/neo4j-will_paginate/its.png)](http://travis-ci.org/dnagir/neo4j-will_paginate)

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
  @people = Person.all.paginate(:page => 2, :per_page => 20) # :per_page is optional
end

# Then in the view:
paginate @people

```

License
=====================

MIT by Dmytrii Nagirniak and Andreas Ronge
