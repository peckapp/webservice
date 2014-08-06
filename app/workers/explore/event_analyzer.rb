# nests all explore workers within their own module
module Explore
  # sub worker that analyses a specific
  class EventAnalyzer
    include Sidekiq::Worker

    def perform(id, model_str)
      model = Util.class_from_string(model_str)

      model.find(id)
    end
  end
end
