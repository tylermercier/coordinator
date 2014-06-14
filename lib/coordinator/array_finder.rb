module Coordinator
  class ArrayFinder

    def initialize(queues)
      @queues = queues
    end

    def queue_for_skill(skill)
      queue = @queues.find {|q| q.name == skill}
      raise Coordinator::Error, "No matching queue for #{skill}" unless queue
      queue
    end

    def all
      @queues
    end
  end
end
