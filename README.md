rails-admin-scaffold [![Build Status](https://travis-ci.org/dhampik/rails-admin-scaffold.png?branch=develop)](https://travis-ci.org/dhampik/rails-admin-scaffold)
====================

Rails 4 generator which allows to scaffold admin controllers, views with proper (non-namespaced) models, helpers, tests and routes

How to use:
-----------
* Add ```gem 'rails-admin-scaffold', 'x.x.x'``` to your Gemfile
* Run ```bundle install```
* Create admin scaffold with e. g. ```bin/rails g admin:scaffold_controller Post title:string content:text published:boolean```

Plans:
------
* <del>add haml suppurt</del>
* <del>add jbuilder support</del>
* <del>improve tests</del>
* <del>use travis for ci</del>
* add minitest support
* add rspec support
* split controller_scaffold into several separate generators
