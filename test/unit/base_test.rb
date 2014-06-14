require 'test_helper'

describe 'Coordinator::Base' do
  before do
    @coordinator = Coordinator::Base.new(Coordinator::ArrayFinder.new([
      Coordinator::Queue.new("high"),
      Coordinator::Queue.new("medium"),
      Coordinator::Queue.new("low")
    ]))
    Redis.current.flushall
  end

  describe 'adding work' do
    it 'adds task to appropriate queue with priority' do
      @coordinator.add_task("high", 1)
      @coordinator.add_task("medium", 2)
      @coordinator.add_priority_task("high", 3)
      assert_equal 3, @coordinator.next_task(["high"])
      assert_equal 1, @coordinator.next_task(["high"])
      assert_equal 2, @coordinator.next_task(["medium"])
      assert_equal false, @coordinator.next_task(["medium"])
    end

    it 'raises exception when no queue exists' do
      err = -> {
        @coordinator.add_task("forgotten", 1)
      }.must_raise Coordinator::Error
      err.message.must_match /No matching queue for forgotten/
    end
  end

  describe 'removing work' do
    it 'remove task from appropriate queue' do
      @coordinator.add_task("medium", 2)
      @coordinator.add_priority_task("medium", 3)
      @coordinator.remove_task("medium", 3)
      assert_equal 2, @coordinator.next_task(["medium"])
    end
  end

  describe 'length_all' do
    it 'returns the total amount of tasks across all queues' do
      @coordinator.add_task("medium", 1)
      @coordinator.add_priority_task("medium", 2)
      @coordinator.add_task("low", 3)
      @coordinator.add_task("high", 4)
      assert_equal 4, @coordinator.length_all
    end

    it 'returns 0 for no tasks enqueued' do
      assert_equal 0, @coordinator.length_all
    end
  end

  describe 'peek_all' do
    it 'returns the top item from each queue' do
      @coordinator.add_task("medium", 1)
      @coordinator.add_priority_task("medium", 2)
      @coordinator.add_task("low", 3)
      @coordinator.add_task("high", 4)

      assert_equal [2,3,4].sort, @coordinator.peek_all.sort
    end

    it 'returns empty array if all queues are empty' do
      assert_equal [], @coordinator.peek_all
    end
  end
end
