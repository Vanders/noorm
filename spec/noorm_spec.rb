require 'spec_helper'
require 'sequel'

DB = Sequel.sqlite

DB.create_table :testserializable do
  primary_key :id
  String :foo
  Integer :bar
end

describe Noorm::Base do
  before :each do
    @dbobj = Noorm::Base.new
  end

  describe '#new' do
    it 'creates a new Serializable' do
      expect(@dbobj).to be_an_instance_of Noorm::Base
    end
  end

  describe '#to_hash' do
    it 'should return an empty Hash' do
      h = @dbobj.to_hash
      expect(h).to be_kind_of Hash
      expect(h).to eq({})
    end
  end

  describe '#to_json' do
    it 'should return an empty JSON string' do
      j = @dbobj.to_json
      expect(j).to be_kind_of String
      expect(j).to eq('{}')
    end
  end
end

describe Noorm::Base do

  # Simple test class
  class TestSerializable < Noorm::Base
    attr_writer :foo, :bar
    def initialize(args = {})
      @foo = nil
      @bar = nil
      super
    end
  end

  before :each do
    @testobj = TestSerializable.new('foo' => 'test', 'bar' => 42)
  end

  describe '#to_hash' do
    it 'should serialize the object to a Hash' do
      h = @testobj.to_hash
      expect(h).to be_kind_of Hash
      expect(h).to eq('foo' => 'test', 'bar' => 42)
    end
  end

  describe '#to_json' do
    it 'should serialize the object to a JSON string' do
      j = @testobj.to_json
      expect(j).to be_kind_of String
      expect(j).to eq('{"foo":"test","bar":42}')
    end
  end

  describe '#initialize' do
    it 'should unserialize an object from a Hash' do
      h = { 'foo' => 'qux', 'bar' => 999 }
      o = TestSerializable.new(h)
      expect(o).to be_an_instance_of TestSerializable
      j = o.to_json
      expect(j).to be_kind_of String
      expect(j).to eq('{"foo":"qux","bar":999}')
    end

    it 'should unserialize an object from a JSON string' do
      j = '{"foo":"fuzz","bar":9001}'
      o = TestSerializable.new(j)
      expect(o).to be_an_instance_of TestSerializable
      h = o.to_hash
      expect(h).to be_kind_of Hash
      expect(h).to eq('foo' => 'fuzz', 'bar' => 9001)
    end

    it 'should ignore additional keys when unserializing' do
      h = { 'foo' => 'wibble', 'bar' => 4000, 'sodium' => 'chloride' }
      o = TestSerializable.new(h)
      expect(o).to be_an_instance_of TestSerializable
      j = o.to_json
      expect(j).to be_a_kind_of String
      expect(j).to eq('{"foo":"wibble","bar":4000}')
    end
  end

  describe '#save' do
    it 'should store a new object in the database' do
      h = { 'foo' => 'wibble', 'bar' => 4000 }
      o = TestSerializable.new(h)
      expect(o.save).to eq(1)
      expect(o.to_hash).to eq('foo' => 'wibble', 'bar' => 4000, 'id' => 1)
    end

    it 'should update an existing object' do
      o = TestSerializable.new('{"id":1}')
      o.foo = 'wobble'
      o.bar = 3000
      expect(o.save).to eq(1)
      expect(o.to_hash).to eq('foo' => 'wobble', 'bar' => 3000, 'id' => 1)
    end
  end

  # These tests have to go after #save so that there's something in the
  # dataabase
  describe '#initialize' do
    it 'should retrieve an existing object from the database' do
      o = TestSerializable.new('{"id": 1}')
      expect(o).to be_an_instance_of TestSerializable
      expect(o.to_hash).to eq('foo' => 'wobble', 'bar' => 3000, 'id' => 1)
    end

    it 'should fail to retrieve a non-existent object from the database' do
      expect { TestSerializable.new('{"id": 2}') }.to raise_error(NameError)
    end
  end

  describe '#all' do
    it 'should return all of the objects in the database' do
      a = TestSerializable.all
      expect(a).to be_an_instance_of Array
      expect(a.length).to eq(1)
    end
  end

  describe '#each' do
    it 'should enumerate the objects in the database' do
      expect { |b| TestSerializable.each(&b) }.to yield_control
    end
  end
end
