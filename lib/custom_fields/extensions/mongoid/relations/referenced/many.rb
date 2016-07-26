module Mongoid #:nodoc:
  module Relations #:nodoc:
    module Referenced #:nodoc:
      module CustomFieldsBuilding
        def build_with_custom_fields(attributes = {}, type = nil)
          if base.respond_to?(:custom_fields_for?) && base.custom_fields_for?(relation_metadata.name)
            # all the information about how to build the custom class are stored here
            recipe = base.custom_fields_recipe_for(relation_metadata.name)
            attributes ||= {}
            attributes.merge!(custom_fields_recipe: recipe)
            # build the class with custom_fields for the first time
            type = relation_metadata.klass.klass_with_custom_fields(recipe)
          end
          build_without_custom_fields(attributes, type)
        end
      end
      # This class defines the behaviour for all relations that are a
      # one-to-many between documents in different collections.
      class Many < Relations::Many
        prepend CustomFieldsBuilding

        # new should point to the new build method
        alias :new :build_with_custom_fields
      end

    end
  end
end
