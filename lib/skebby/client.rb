require 'httparty'
require 'json'
require 'date'

module Skebby
  class Client
    include HTTParty

    BASE_URI = 'https://gateway.skebby.it/api/send/smseasy/advanced'
    REQUIRED_OPTIONS = [:username, :password]

    base_uri BASE_URI

    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    def get_credit(request_options = {})
      response = get('get_credit')

      {
        credit_left: response['credit_left'].to_f,
        classic_sms: response['classic_sms'].to_i,
        basic_sms:   response['basic_sms'].to_i
      }
    end

    %w(classic classic_report basic).each do |sms_type|
      define_method("send_sms_#{sms_type}") do |request_options = {}|
        perform_sms_request(sms_type, request_options)
      end
    end

    protected

    def perform_sms_request(sms_type, request_options = {})
      type = "send_sms_#{sms_type}"
      type = "test_#{type}" if options[:test_mode]

      request_options[:recipients] = JSON.generate(request_options[:recipients])

      if request_options[:delivery_start]
        unless request_options[:delivery_start].is_a?(Date)
          request_options[:delivery_start] = Date.parse(request_options[:delivery_start])
        end

        request_options[:delivery_start] = request_options[:delivery_start].rfc2822
      end

      response = post(type, request_options)

      parsed_response = { remaining_sms: response['remaining_sms'].to_i }
      parsed_response[:dispatch_id] = response['id'].to_i if response['id']

      parsed_response
    end

    def get(type, request_options = {})
      perform('get', type, request_options)
    end

    def post(type, request_options)
      perform('post', type, request_options)
    end

    def perform(method, type, request_options = {})
      request_options = request_options.merge({
        method:   type,
        username: options[:username],
        password: options[:password]
      })

      response = self.class.send(method, '/rest.php', query: request_options)

      if response['SkebbyApi_Public_Send_SmsEasy_Advanced']
        response = response['SkebbyApi_Public_Send_SmsEasy_Advanced'][type]
      else
        response = response[type]
      end

      raise "#{type} request failed! (#{response['response']['message']})" if response['status'] == 'failed'

      response.delete('status') and response
    end
  end
end
