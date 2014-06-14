require 'test_helper'
require 'time'

describe 'ParallelismTest' do
  before do
    @coordinator = Coordinator::Base.new(Coordinator::ArrayFinder.new([
      Coordinator::Queue.new("tasks"),
      Coordinator::Queue.new("completed_tasks")
    ]))
    @tasks = ('a'..'z').to_a
    @tasks.each { |t| @coordinator.add_task("tasks", t) }
  end

  it 'works syncronously' do
    125.times { perform_work }
    assert_equal [], @coordinator.info("tasks")["items"]
    array_equal(@tasks, @coordinator.info("completed_tasks")["items"])
  end

  it 'works in parallel' do
    workers = []

    start = Time.now + 1

    200.times do |i|
      workers << Thread.new(i) do
        sleep(start - Time.now)
        perform_work(i)
      end
    end
    workers.each { |w| w.join }

    assert_equal [], @coordinator.info("tasks")["items"]
    array_equal(@tasks, @coordinator.info("completed_tasks")["items"])
  end

  def perform_work(i=nil)
    task = @coordinator.next_task(["tasks"])
    @coordinator.add_task("completed_tasks", task) if task
  end

  def array_equal(left, right)
     assert_equal left.uniq.sort, right.uniq.sort
  end
end
