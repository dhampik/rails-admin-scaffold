rails-admin-scaffold
====================

Rails generator which allows to scaffold admin controllers, views with proper (non-namespaced) models, helpers, tests and routes

How to use:
-----------
* Add ```gem 'rails-admin-scaffold', 'x.x.x'``` to your Gemfile
* Run ```bundle install```
* Create admin scaffold with e. g. ```bin/rails g admin:scaffold_controller Post title:string content:text published:boolean```

Plans:
------
* add haml suppurt
* add jbuilder support
* improve tests
* use travis for ci
