require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    @capacity = 8
    @store = StaticArray.new(@capacity)
    @length = 0
  end

  # O(1)
  def [](index)
    if @length <= 0 || index >= @length
      raise ArgumentError.new("index out of bounds")
    else
      @store[index]
    end
  end

  # O(1)
  def []=(index, value)
    if index >= @capacity
      raise ArgumentError.new("index out of bounds")
    else
      if @store[index] == nil
        @length += 1
      end
      @store[index] = value
    end
  end

  # O(1)
  def pop
    if @length <= 0
      raise ArgumentError.new("index out of bounds")
    else
      @store[@length - 1] = nil
      @length -= 1
    end
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    if @length >= @capacity
      resize!
    end
    @store[@length] = val
    @length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    if @length <= 0
      raise ArgumentError.new("index out of bounds")
    else
      new_store = StaticArray.new(@capacity)
      (0..@length).each do |idx|
        new_store[idx] = @store[idx + 1]
      end
      @store = new_store
      @length -= 1
    end
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    if @length >= @capacity
      resize!
    end
    new_store = StaticArray.new(@capacity)
    (1..@length).each do |idx|
      new_store[idx] = @store[idx - 1]
    end
    @store = new_store
    @store[0] = val
    @length += 1
  end


  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    @capacity *= 2
    new_store = StaticArray.new(@capacity)
    (0...@length).each do |idx|
      new_store[idx] = @store[idx]
    end
    @store = new_store
  end

end

arr = DynamicArray.new
9.times { |i| arr.unshift(i) }
p arr
