rails-admin-scaffold [![Build Status](https://travis-ci.org/dhampik/rails-admin-scaffold.png?branch=master)](https://travis-ci.org/dhampik/rails-admin-scaffold)
====================

Rails 4 generator which allows to scaffold admin controllers, views with proper (non-namespaced) models, helpers, tests and routes

How to use
-----------
* Add ```gem 'rails-admin-scaffold', 'x.x.x'``` to your Gemfile
* Run ```bundle install```
* Create admin scaffold with e. g. ```bin/rails g admin:scaffold_controller Post title:string content:text published:boolean```
* And don't forget to generate model itself ```bin/rails g model Post title:string content:text published:boolean``` and apply migrations ```bin/rake db:migrate```

#### How to customize your generator templates

Put the '_form.html.erb.erb', 'edit.html.erb.erb', 'index.html.erb.erb', 'new.html.erb.erb', 'show.html.erb.erb' into '/lib/templates/admin/scaffold_controller/views/erb/'

Then the generator will use those templates to generate scaffold.

#### How to customize your prefix name

Type your command with option --prefix_name=xxxx.

If you want change the prefix name 'admin' to 'manager' for example you can do something like this:

```bin/rails g admin:scaffold_controller Post title:string content:text published:boolean --prefix_name=manager```

This will generate `class Manager::PostsController < ApplicationController`

#### How to customize your parent controller

If you want all your Admin controllers to inherit from another
controller like `AdminController` you can specify the
--parent_controller option:

```bin/rails g admin:scaffold_controller Post title:string content:text published:boolean --parent_controller=admin```

This will generate `class Admin::PostsController < AdminController`

#### How to generate bootstrap-friendly views

If you want to generate bootstrap friendly views, use the `--bootstrap` option (`-b` for short)

```bin/rails g admin:scaffold_controller Post title:string content:text published:boolean --bootstrap```

Supports
--------
* Rails 4+
* Rails default generators (erb, test::unit)
* Haml (if haml is used for views generation)
* Twitter bootstrap support
* Jbuilder (if jbuilder is installed for the project)

Plans
------
* <del>add haml suppurt</del>
* <del>add jbuilder support</del>
* <del>improve tests</del>
* <del>use travis for ci</del>
* <del>ability to specify parent controller name (e.g. AdminController instead of ApplicationController)</del>
* add minitest support
* add rspec support
* split controller_scaffold into several separate generators
