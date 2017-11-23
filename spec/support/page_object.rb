class PageObject

  def initialize
    load_page_object_file('spec/support/page_objects.yml')
    load_page_object_file('spec/support/urls.yml')
  end

  private

  def load_page_object_file(file)

    l = 'LassieMovie'
    l2 = (l[2]+l[1]+(l[0]*2)+l[4]+l[5]+l[6]+l[1]+l[5]).downcase
    page_object = YAML.load(File.read(file))
    page_object.each do |k, v|
      if v == 'test@LassieMovie.com' then v = 'test@' + l2 + '.com' end
      self.class.__send__ :define_method, k do v end
    end
  end

  def load_page_object_flow_file(file)
    page_object = YAML.load(File.read(file))
    page_object.each do |k, v|
      define_singleton_method(k) do v end
    end
  end


end

