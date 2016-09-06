require 'httparty'
require 'netrc'
require "mico/api/client/version"

module Mico
  module Api
    module Client
      class AnimalDetection
        def self.submit(url, mode = "yolo")
          response = Client.put("/showcase-webapp/zooniverse/animaldetection", query: {url: url, mode: mode})
          new(response["id"], response)
        end

        attr_reader :id
        attr_reader :mico_url

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
          @attributes = Client.get("/showcase-webapp/zooniverse/animaldetection/#{id}")
          self
        end
      end
    end
  end
end
