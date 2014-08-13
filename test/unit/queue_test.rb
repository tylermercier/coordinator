require "test_helper"

describe "Coordinator::Queue" do
  before do
    @queue = Coordinator::Queue.new("high")
    Redis.current.flushall
  end

  describe 'initialize' do
    it 'can capacity when option argument is passed in' do
      @queue = Coordinator::Queue.new("high", 500)
      assert_equal 500, @queue.capacity
    end
  end

  describe 'next_task' do
    it 'returns task when eligible' do
      @queue.push(1)
      assert 1, @queue.next_task(["high"])
    end

    it 'returns nil when not eligible' do
      assert_equal nil, @queue.next_task(["high"])
    end
  end

  describe "eligible?" do
    it "returns true when skill present" do
      assert @queue.eligible?(nil, ["high"])
    end

    it "returns false when skill not present" do
      refute @queue.eligible?(nil, ["low", "normal"])
    end

    it "can override default behaviour" do
      queue = Coordinator::Queue.new("normal") do |task, skills|
        return true if skills.include?(skill) && skills.include?("online")
        return true if skills.include?("low")
        return true if task == 4
        task == 3 && skills.include?("special")
      end
      refute queue.eligible?(nil, ["normal"]), "default behaviour"
      assert queue.eligible?(2, ["normal", "online"]), "access queue variables"
      assert queue.eligible?(2, ["low"]), "override through skill"
      assert queue.eligible?(4, []), "override through task"
      assert queue.eligible?(3, ["special"]), "override through both"
    end
  end
end
