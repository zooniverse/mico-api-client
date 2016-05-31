require 'httparty'
require 'netrc'
require "mico/api/client/version"

module Mico
  module Api
    module Client
      class TextAnalysis
        def self.submit(comment)
          response = Client.post("/showcase-webapp/zooniverse/textanalysis", body: {comment: comment})
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
          @attributes = Client.get("/showcase-webapp/zooniverse/textanalysis/#{id}")
          self
        end
      end
    end
  end
end
