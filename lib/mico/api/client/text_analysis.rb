require 'httparty'
require 'netrc'
require "mico/api/client/version"

module Mico
  module Api
    module Client
      class TextAnalysis
        def self.submit(comment)
          response = Client.post("/broker/zooniverse/textanalysis", body: {comment: comment})
          response["mico_url"] = "http://abowyer:T5KjcYFt7@demo1.mico-project.eu:8080/broker/zooniverse/textanalysis/#{response['id']}"
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
          @attributes = Client.get("/broker/zooniverse/textanalysis/#{id}")
          self
        end
      end
    end
  end
end
