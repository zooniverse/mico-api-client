require 'httparty'
require 'netrc'
require "mico/api/client/version"

module Mico
  module Api
    class Client
      include HTTParty
      base_uri 'demo1.mico-project.eu:8080'

      def initialize
        netrc = Netrc.read
        @username, @password = netrc[self.class.base_uri]
      end

      def submit(id, url)
        self.class.put("/broker/zooniverse/#{id}", query: {url: url}, basic_auth: auth)
      end

      def check(id)
        self.class.get("/broker/zooniverse/#{id}", basic_auth: auth)
      end

      private

      def auth
        {username: @username, password: @password}
      end
      # Your code goes here...
    end
  end
end
