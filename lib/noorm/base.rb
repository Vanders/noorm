require 'oj'
require 'sequel'

module Noorm
  # Methods for serializable objects.
  class Base
    class << self
      def all
        _dataset.all
      end

      def each(&block)
        _dataset.each(&block)
      end

      private

      def _dataset
        table = name.downcase.to_sym
        DB.from(table)
      end
    end

    attr_reader :id

    def initialize(args = {})
      args = Oj.load(args) if args.is_a? String

      table = self.class.name.downcase.to_sym
      @dataset = DB.from(table)
      @id = nil

      args = @dataset[id: args['id']] if args.key? 'id'
      fail NameError if args.nil?

      args = @dataset[id: args[:id]] if args.key? :id
      fail NameError if args.nil?

      instance_variables.each do |var|
        key = var.to_s.delete('@')
        instance_variable_set(var, args[key]) if args.key? key
        instance_variable_set(var, args[key.to_sym]) if args.key? key.to_sym
      end
    end

    def save
      if @dataset[id: @id]
        @dataset.where(id: @id).update(to_hash)
      else
        @id = @dataset.insert(to_hash)
      end
      return @id
    end

    def sanitize
      nil
    end

    def to_hash
      hash = {}
      obj = dup
      obj._sanitize
      obj.instance_variables.each do |var|
        hash[var.to_s.delete('@')] = obj.instance_variable_get(var)
      end
      return hash
    end

    def to_json
      Oj.dump(to_hash)
    end

    protected

    def _sanitize
      %w( @dataset ).each do |var|
        remove_instance_variable(var.to_sym)
      end
      remove_instance_variable(:@id) if @id.nil?
      sanitize
    end
  end
end
