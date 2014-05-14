module Coordinator
  class Base
    def initialize(queues)
      @queues = queues
    end

    def add_task(skill, task)
      queue_for_skill(skill).add_task(task)
    end

    def add_priority_task(skill, task)
      queue_for_skill(skill).add_priority_task(task)
    end

    def remove_task(skill, task)
      queue_for_skill(skill).remove_task(task)
    end

    def next_task(skills)
      @queues.each do |q|
        task = q.next_task(skills)
        return task if task
      end
      false
    end

    def set_capacity(skill, capacity)
      queue_for_skill(skill).set_capacity(capacity)
    end

    def info(skill)
      queue = queue_for_skill(skill)
      {
        "name" => queue.name,
        "capacity" => queue.capacity,
        "count" => queue.length,
        "items" => queue.items
      }
    end

    def length_all
      @queues.inject(0) { |sum, queue| sum + queue.length }
    end

    def peek_all
      @queues.map(&:peek).compact
    end

    private

    def queue_for_skill(skill)
      queue = @queues.find {|q| q.name == skill}
      raise Coordinator::Error, "No matching queue for #{skill}" unless queue
      queue
    end
  end
end
