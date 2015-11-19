require 'httparty'
require 'netrc'
require "mico/api/client/version"

module Mico
  module Api
    module Client
      class AnimalDetection
        def self.submit(url)
          response = Client.put("/broker/zooniverse/animaldetection", query: {url: url})
          response["mico_url"] = "http://abowyer:T5KjcYFt7@demo1.mico-project.eu:8080/broker/zooniverse/animaldetection/#{id}"
          new(response["id"], response)
        end

        attr_reader :id

        def initialize(id, attributes = {})
          @id = id
          @attributes = attributes
        end

        def attributes
          @attributes.merge("id" => @id)
        end

        def [](key)
          @attributes[key]
        end

        def reload
          @attributes = Client.get("/broker/zooniverse/animaldetection/#{id}")
          self
        end
      end
    end
  end
end
