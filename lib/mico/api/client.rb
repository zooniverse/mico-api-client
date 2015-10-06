require 'httparty'
require 'netrc'
require "mico/api/client/version"
require 'mico/api/client/animal_detection'
require 'mico/api/client/text_analysis'

module Mico
  module Api
    module Client
      include HTTParty
      base_uri 'demo1.mico-project.eu:8080'
      debug_output

      def self.get(path, options = {})
        super(path, options.merge(basic_auth: auth))
      end

      def self.post(path, options = {})
        super(path, options.merge(basic_auth: auth, headers: {"Content-Type" => "application/json"}, body: JSON.dump(options[:body])))
      end

      def self.put(path, options = {})
        super(path, options.merge(basic_auth: auth, headers: {"Content-Type" => "application/json"}, body: JSON.dump(options[:body])))
      end

      def self.patch(path, options = {})
        super(path, options.merge(basic_auth: auth, headers: {"Content-Type" => "application/json"}, body: JSON.dump(options[:body])))
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
