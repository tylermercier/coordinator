module Coordinator
  class Base
    def initialize(queues)
      @queues = queues
    end

    def add_task(skill, task)
      queue_for_skill(skill).push(task)
    end

    def add_priority_task(skill, task)
      queue_for_skill(skill).left_push(task)
    end

    def remove_task(skill, task)
      queue_for_skill(skill).remove(task)
    end

    def next_task(skills)
      @queues.each do |q|
        task = q.next_task(skills)
        return task if task
      end
      false
    end

    def set_capacity(skill, capacity)
      queue_for_skill(skill).capacity = capacity
    end

    def full?(skill)
      queue_for_skill(skill).full?
    end

    def info(skill)
      queue_for_skill(skill).details
    end

    def position(skill, task)
      index = queue_for_skill(skill).items.index(task)
      index ? index + 1 : -1
    end

    def length_all
      @queues.inject(0) { |sum, queue| sum + queue.length }
    end

    def length(skill)
      queue_for_skill(skill).length
    end

    def peek_all
      @queues.map(&:peek).compact
    end

    private

    def queue_for_skill(skill)
      queue = @queues.find {|q| q.skill == skill}
      raise Coordinator::Error, "No matching queue for #{skill}" unless queue
      queue
    end
  end
end
