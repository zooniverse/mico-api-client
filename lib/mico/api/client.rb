require 'httparty'
require 'netrc'
require "mico/api/client/version"
require 'mico/api/client/animal_detection'

module Mico
  module Api
    module Client
      include HTTParty
      base_uri 'demo1.mico-project.eu:8080'

      def self.get(path, options = {})
        super(path, options.merge(basic_auth: auth))
      end

      def self.put(path, options = {})
        super(path, options.merge(basic_auth: auth))
      end

      private

      def self.auth
        return @auth if @auth

        netrc = Netrc.read
        username, password = netrc[self.base_uri]
        @auth = {username: username, password: password}
      end
    end
  end
end
