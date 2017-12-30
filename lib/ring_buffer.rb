require_relative "static_array"

class RingBuffer
  attr_reader :length

  def initialize
    @capacity = 8
    @store = StaticArray.new(@capacity)
    @length = 0
    @start_idx = 0
  end

  # O(1)
  def [](index)
    idx = (index + @start_idx) % @capacity
    if @length <= 0 || index >= @length
      raise ArgumentError.new("index out of bounds")
    else
      @store[idx]
    end
  end

  # O(1)
  def []=(index, value)
    idx = (index + @start_idx) % @capacity
    if idx >= @capacity
      raise ArgumentError.new("index out of bounds")
    else
      if @store[idx] == nil
        @length += 1
      end
      @store[idx] = value
    end
  end

  # O(1)
  def pop
    if @length <= 0
      raise ArgumentError.new("index out of bounds")
    else
      idx = (@start_idx + @length - 1) % @capacity
      popped = @store[idx]
      @store[idx] = nil
      @length -= 1
    end
    popped
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    if @length >= @capacity
      resize!
    end
    idx = (@start_idx + @length) % @capacity
    @store[idx] = val
    @length += 1
  end

  # O(1)
  def shift
    if @length <= 0
      raise ArgumentError.new("index out of bounds")
    else
      shifted = @store[@start_idx]
      @store[@start_idx] = nil
      @length -= 1
      @start_idx = (@start_idx + 1) % @capacity
    end
    shifted
  end

  # O(1) ammortized
  def unshift(val)
    if @length >= @capacity
      resize!
    end
    if @store[@start_idx] == nil
      @store[@start_idx] = val
      @length += 1
    else
      idx = (@start_idx - 1) % @capacity
      @store[idx] = val
      @length += 1
      @start_idx = idx
    end
  end


  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    @capacity *= 2
    new_store = StaticArray.new(@capacity)
    (0...@length).each do |idx|
      if idx < @start_idx
        new_store[idx] = @store[idx]
      else
        new_store[idx + @length] = @store[idx]
      end
    end
    @store = new_store
    @start_idx += @length
  end
end

arr = RingBuffer.new
# 5.times { |i| arr.unshift(i) }
# p arr
# arr.shift
# p arr
# arr.pop
# p arr
# arr.push(22)
# p arr
5.times { |i| arr.unshift(i) }
p arr
p arr[0]
p arr.shift
p arr
