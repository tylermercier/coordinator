module Coordinator
  class Base
    def initialize(queues)
      @queues = queues
    end

    def add_task(skill, task)
      queue = queue_for_skill(skill)
      queue.add_task(task)
    end

    def add_priority_task(skill, task)
      queue = queue_for_skill(skill)
      queue.add_priority_task(task)
    end

    def next_task(skills)
      @queues.each do |q|
        task = q.next_task(skills)
        return task if task
      end
      false
    end

    def set_capacity(skill, capacity)
      queue = queue_for_skill(skill)
      queue.set_capacity(capacity)
    end

    private

    def queue_for_skill(skill)
      queue = @queues.find {|q| q.skill == skill}
      raise Coordinator::Error.new("No matching queue for #{skill}") unless queue
      queue
    end
  end
end
