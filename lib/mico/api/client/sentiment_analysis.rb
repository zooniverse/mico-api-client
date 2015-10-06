require 'httparty'
require 'netrc'
require "mico/api/client/version"

module Mico
  module Api
    module Client
      class SentimentAnalysis
        def self.submit(url)
          response = Client.put("/broker/zooniverse/sentimentanalysis", query: {url: url})
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
          @attributes = Client.get("/broker/zooniverse/sentimentanalysis/#{id}")
          self
        end
      end
    end
  end
end
