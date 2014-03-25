require 'test_helper'

describe 'Coordinator::Base' do
  before do
    @coordinator = Coordinator::Base.new([
      Coordinator::Queue.new("high"),
      Coordinator::Queue.new("medium"),
      Coordinator::Queue.new("low")
    ])
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
end
