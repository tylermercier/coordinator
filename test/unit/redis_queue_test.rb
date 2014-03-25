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
      assert_equal 3, @queue.push("c")
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
    it 'returns 1 when element found and removes' do
      @queue.push(1)
      assert_equal 1, @queue.remove(1)
      assert_equal 0, @queue.length
    end

    it 'returns 0 when element not found' do
      @queue.push(1)
      assert_equal 0, @queue.remove(4)
      assert_equal 1, @queue.length
    end

    it 'returns nil when queue empty' do
      assert_equal nil, @queue.remove(4)
    end
  end

  describe '.peek' do
    it 'gets the top item and does not remove' do
      @queue.push(1)
      @queue.push(2)
      assert_equal "1", @queue.peek
      assert_equal 2, @queue.length
    end
  end

  it 'allows for objects' do
    [1000, "taco", {"a" => 1}, [1,2,3]].each do |o|
      @queue.push(o)
      assert_equal o, @queue.pop
    end
  end
end
