require 'test_helper'

describe 'Coordinator::Base' do
  before do
    @coordinator = Coordinator::Base.new([
      Coordinator::Queue.new("pos"),
      Coordinator::Queue.new("rogers"),
      Coordinator::Queue.new("general")
    ])
  end

  describe 'adding work' do
    it 'adds task to appropriate queue with priority' do
      @coordinator.add_task("pos", 1)
      @coordinator.add_task("rogers", 2)
      @coordinator.add_priority_task("pos", 3)
      assert_equal 3, @coordinator.next_task(["pos"])
      assert_equal 1, @coordinator.next_task(["pos"])
      assert_equal 2, @coordinator.next_task(["rogers"])
      assert_equal false, @coordinator.next_task(["rogers"])
    end
  end
end
