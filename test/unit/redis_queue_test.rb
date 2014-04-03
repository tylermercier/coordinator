require 'test_helper'

describe 'Coordinator::RedisQueue' do
  before do
    @queue = Coordinator::RedisQueue.new('test')
    Redis.current.flushall
  end

  describe '.push' do
    it 'adds element to queue, returns length' do
      @queue.push("a")
      @queue.push("b")
      assert_equal 2, @queue.length
    end

    it 'adds the same item only once' do
      @queue.push("a")
      @queue.push("a")
      assert_equal 1, @queue.length
    end

    it 'adds the same item only once' do
      @queue.capacity = 1
      @queue.push("a")
      assert_equal false, @queue.push("b")
    end
  end

  describe '.left_push' do
    it 'adds element to front of queue' do
      @queue.push("b")
      @queue.push("c")
      @queue.left_push("a")
      assert_equal "a", @queue.pop
      assert_equal 2, @queue.length
    end
  end

  describe '.pop' do
    it 'returns top item from queue' do
      @queue.push("a")
      @queue.push("b")
      @queue.push("c")
      assert_equal "a", @queue.pop
    end

    it 'returns nil when empty' do
      assert_equal nil, @queue.pop
    end
  end

  describe '.remove' do
    it 'returns true when element found and removes' do
      @queue.push(1)
      assert_equal true, @queue.remove(1)
      assert_equal 0, @queue.length
    end

    it 'returns false when element not found' do
      @queue.push(1)
      assert_equal false, @queue.remove(4)
      assert_equal 1, @queue.length
    end

    it 'returns false when queue empty' do
      assert_equal false, @queue.remove(4)
    end
  end

  describe '.peek' do
    it 'gets the top item and does not remove' do
      @queue.push(1)
      @queue.push(2)
      assert_equal 1, @queue.peek
      assert_equal 2, @queue.length
    end

    it 'return nil if no items' do
      assert_equal nil, @queue.peek
    end
  end

  describe '.capacity' do
    it 'gets the top item and does not remove' do
      assert_equal nil, @queue.capacity
      @queue.capacity = 2
      assert_equal 2, @queue.capacity
    end
  end

  it 'allows for objects' do
    [1000, "taco", {"a" => 1}, [1,2,3]].each do |o|
      @queue.push(o)
      assert_equal o, @queue.pop
    end
  end
end
