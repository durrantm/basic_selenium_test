class FormDataObject

  def initialize
    load_form_data_object_file('spec/support/form_data_objects.yml')
  end

  private

  def load_form_data_object_file(file)
    form_data_object = YAML.load(File.read(file))
    form_data_object.each do |k, v|
      self.class.__send__ :define_method, k do v end
    end
  end

end
