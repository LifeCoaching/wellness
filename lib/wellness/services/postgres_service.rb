require 'pg'
require 'wellness/services/base'

module Wellness
  module Services
    # @author Matthew A. Johnston
    class PostgresService < Wellness::Services::Base
      def check
        case ping
          when PG::Constants::PQPING_NO_ATTEMPT
            ping_failed('no attempt made to ping')
          when PG::Constants::PQPING_NO_RESPONSE
            ping_failed('no response from ping')
          when PG::Constants::PQPING_REJECT
            ping_failed('ping was rejected')
          else
            ping_successful
        end
      end

      private

      def ping
        PG::Connection.ping(connection_options)
      end

      # @return [Hash]
      def connection_options
        {
          host: self.params[:host],
          port: self.params[:port],
          dbname: self.params[:database],
          user: self.params[:user],
          password: self.params[:password]
        }
      end

      # @param message [String] the reason it failed
      # @return [Hash]
      def ping_failed(message)
        failed_check
        {
          status: 'UNHEALTHY',
          details: {
            error: message
          }
        }
      end

      # @return [Hash]
      def ping_successful
        passed_check
        {
          status: 'HEALTHY',
          details: {
          }
        }
      end
    end
  end
end
