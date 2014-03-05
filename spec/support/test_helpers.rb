require 'sequel/extensions/inflector'

module TestHelpers
  @@models = []

  def define_model(model_name, &block)
    class_name = model_name.to_s.camelize.to_sym
    table_name = model_name.to_s.tableize.to_sym

    if @@models.include?(model_name)
      Object.send(:remove_const, class_name)
    else
      @@models << model_name
    end

    klass = Object.const_set class_name, Sequel::Model(table_name)
    klass.class_eval &block if block_given?
  end
end
