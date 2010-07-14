module ::RdfModel::Vocabularies
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      class << self
        alias :inherited_without_vocabularies :inherited
        alias :inherited :inherited_with_vocabularies
        alias :method_missing_without_vocabularies :method_missing
        alias :method_missing :method_missing_with_vocabularies
        alias :respond_to_without_vocabularies? :respond_to?
        alias :respond_to? :respond_to_with_vocabularies?
      end
    end
  end

  module ClassMethods
    attr_accessor :vocabularies

    def inherited_with_vocabularies(subclass)
      subclass.instance_eval do
        self.vocabularies = {}
      end
      inherited_without_vocabularies(subclass)
    end

    def vocabulary(name, uri)
      make_string_vocabulary(uri)
      self.vocabularies[name] = uri
    end

    def method_missing_with_vocabularies(sym, *args, &block)
      return self.vocabularies[$1.to_sym] if sym.to_s =~ /^vocab_(.+)$/ && self.vocabularies[$1.to_sym]
      method_missing_without_vocabularies(sym, *args, &block)
    end

    def respond_to_with_vocabularies?(sym)
      return !!(sym.to_s =~ /^vocab_(.+)$/ && self.vocabularies[$1.to_sym]) || respond_to_without_vocabularies?(sym)
    end

    private

    def make_string_vocabulary(str)
      class << str
        def method_missing(sym, *args, &block)
          self + sym.to_s
        end
      end
    end
  end
end