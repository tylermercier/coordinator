require "test_helper"

describe "Coordinator::Queue" do
  before do
    @queue = Coordinator::Queue.new("pos")
    Redis.current.flushall
  end

  describe "add_task" do
    it "returns true when skill present" do
      @queue.add_task(5)
      @queue.add_task(4)

      assert_equal 5, @queue.next_task(["pos"])
    end
  end

  describe "add_priority_task" do
    it "returns true when skill present" do
      @queue.add_task(5)
      @queue.add_priority_task(4)

      assert_equal 4, @queue.next_task(["pos"])
    end
  end

  describe "can_work?" do
    it "returns true when skill present" do
      assert @queue.can_work? ["pos"]
    end

    it "returns false when skill not present" do
      refute @queue.can_work? ["general", "rogers"]
    end
  end
end
