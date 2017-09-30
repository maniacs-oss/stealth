# coding: utf-8
# frozen_string_literal: true

module Stealth
  module Services
    module Facebook

      class MessageEvent

        attr_reader :service_response

        def initialize(service_response:, params:)
          @service_response = service_response
        end

        def process
          fetch_message
          fetch_location
          fetch_attachments
        end

        private

          def fetch_message
            if params['message']['quick_reply'].present?
              service_response.message = params['message']['quick_reply']['payload']
            elsif params['message']['text'].present?
              service_response.message = params['message']['text']
            end
          end

          def fetch_location
            if params['location'].present?
              lat = params['location']['coordinates']['lat']
              lng = params['location']['coordinates']['long']
              service_response.location = {
                lat: lat,
                lng: lng
              }
            end
          end

          def fetch_attachments
            if params['attachments'].present? && params['attachments'].is_a?(Array)
              params['attachments'].each do |attachment|
                service_response.attachments << {
                  type: attachment['type'],
                  url: attachment['payload']['url']
                }
              end
            end
          end

      end

    end
  end
end
