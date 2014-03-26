require 'test_helper'

describe 'ParallelismTest' do
  before do
    @coordinator = Coordinator::Base.new([
      Coordinator::Queue.new("tasks"),
      Coordinator::Queue.new("completed_tasks")
    ])
    @tasks = ('a'..'z').to_a
    @tasks.each { |t| @coordinator.add_task("tasks", t) }
  end

  it 'works syncronously' do
    1.upto(200) { perform_work }
    assert_equal [], @coordinator.view("tasks")
    assert_equal @tasks, @coordinator.view("completed_tasks")
  end

  it 'works in parallel' do
    workers = []
    1.upto(200) do
      workers << Thread.new { perform_work }
    end
    workers.each { |w| w.join }

    assert_equal [], @coordinator.view("tasks")
    assert_equal @tasks, @coordinator.view("completed_tasks")
  end

  def perform_work
    task = @coordinator.next_task(["tasks"])
    @coordinator.add_task("completed_tasks", task) if task
  end
end
