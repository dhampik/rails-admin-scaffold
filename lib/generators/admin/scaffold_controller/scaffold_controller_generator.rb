require 'rubygems/specification'
require 'rails/generators/named_base'
require 'rails/generators/resource_helpers'

module Admin
  module Generators
    class ScaffoldControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      source_root File.expand_path('../templates', __FILE__)

      class_option :template_engine, desc: 'Template engine to be invoked (erb or haml).'

      check_class_collision suffix: "Controller"

      check_class_collision suffix: "ControllerTest"

      check_class_collision suffix: "Helper"

      class_option :orm, banner: "NAME", type: :string, required: true,
                   desc: "ORM to generate the controller for"

      class_option :html, type: :boolean, default: true,
                   desc: "Generate a scaffold with HTML output"

      class_option :prefix_name, banner: "admin", type: :string, default: "admin",
                   desc: "Define the prefix of controller"

      class_option :parent_controller, banner: "admin", type: :string, default: "application",
                   desc: "Define the parent controller"

      class_option :bootstrap,  required: false, default: nil, aliases: '-b',
                   desc: "Use bootstrap for templates"

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def initialize(args, *options) #:nodoc:
        super
      end

      hook_for :resource_route, in: :rails do |resource_route|
        invoke resource_route, [prefixed_class_name]
      end

      def create_controller_files
        # I think there should be a better way to detect if jbuilder is in use
        # If you know it, please let me know
        if Gem::Specification.find_all_by_name('jbuilder').length >= 1
          template "controllers/jbuilder/controller.rb.erb", File.join('app/controllers', prefix, class_path, "#{controller_file_name}_controller.rb")
        else
          template "controllers/railties/controller.rb.erb", File.join('app/controllers', prefix, class_path, "#{controller_file_name}_controller.rb")
        end
      end

      def create_test_files
        template "tests/test_unit/functional_test.rb.erb", File.join("test/controllers", prefix, controller_class_path, "#{controller_file_name}_controller_test.rb")
      end

      hook_for :helper, in: :rails do |helper|
        invoke helper, [prefixed_controller_class_name]
      end

      def create_root_folder
        empty_directory File.join("app/views", prefix, controller_file_path)
      end

      def copy_view_files
        available_views.each do |view|
          filename = filename_with_extensions(view)
          if bootstrap
            template_path = "views/#{handler}_bootstrap/#{filename}.erb"
          else
            template_path = "views/#{handler}/#{filename}.erb"
          end
          template template_path, File.join("app/views", prefix, controller_file_path, filename)
        end

        # I think there should be a better way to detect if jbuilder is in use
        if Gem::Specification.find_all_by_name('jbuilder').length >= 1
          %w(index show).each do |view|
            template "views/jbuilder/#{view}.json.jbuilder.erb", File.join("app/views", prefix, controller_file_path, "#{view}.json.jbuilder")
          end
        end
      end

      hook_for :assets, in: :rails do |assets|
        invoke assets, [prefixed_class_name]
      end

      protected

      def bootstrap
        options[:bootstrap]
      end

      def prefix
        options[:prefix_name]
      end

      def prefixed_class_name
        "#{prefix.capitalize}::#{class_name}"
      end

      def prefixed_controller_class_name
        "#{prefix.capitalize}::#{controller_class_name}"
      end

      def parent_controller_class_name
        options[:parent_controller].capitalize
      end

      def prefixed_route_url
        "/#{prefix}#{route_url}"
      end

      def prefixed_plain_model_url
        "#{prefix}_#{singular_table_name}"
      end

      def prefixed_index_helper
        "#{prefix}_#{index_helper}"
      end

      def available_views
        %w(index edit show new _form)
      end

      def format
        :html
      end

      def handler
        options[:template_engine]
      end

      def filename_with_extensions(name)
        [name, format, handler].compact.join(".")
      end

      # Add a class collisions name to be checked on class initialization. You
      # can supply a hash with a :prefix or :suffix to be tested.
      #
      # ==== Examples
      #
      #   check_class_collision suffix: "Decorator"
      #
      # If the generator is invoked with class name Admin, it will check for
      # the presence of "AdminDecorator".
      #
      def self.check_class_collision(options={})
        define_method :check_class_collision do
          name = if self.respond_to?(:prefixed_controller_class_name) # for ScaffoldBase
            prefixed_controller_class_name
          elsif self.respond_to?(:prefixed_controller_class_name) # for ScaffoldBase
            controller_class_name
          else
            class_name
          end

          class_collisions "#{options[:prefix]}#{name}#{options[:suffix]}"
        end
      end

      def attributes_hash
        return if attributes_names.empty?

        attributes_names.map do |name|
          if %w(password password_confirmation).include?(name) && attributes.any?(&:password_digest?)
            "#{name}: 'secret'"
          else
            "#{name}: @#{singular_table_name}.#{name}"
          end
        end.sort.join(', ')
      end

      def attributes_list_with_timestamps
        attributes_list(attributes_names + %w(created_at updated_at))
      end

      def attributes_list(attributes = attributes_names)
        if self.attributes.any? {|attr| attr.name == 'password' && attr.type == :digest}
          attributes = attributes.reject {|name| %w(password password_confirmation).include? name}
        end

        attributes.map { |a| ":#{a}"} * ', '
      end

    end
  end
end
