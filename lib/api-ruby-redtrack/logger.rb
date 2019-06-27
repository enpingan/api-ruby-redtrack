module RubyRedtrack
  class Logger
    class << self
      attr_accessor :log_file_path
      attr_accessor :write_to_console

      def log(response, request, result)
        request_date = DateTime.now.strftime('%d-%m-%Y %H:%M')
        request_info = "#{request.method.upcase} #{request.url}"
        response_info = result.code.to_s

        unless ('200'..'299').include?(result.code)
          response_message = result.message
          description = error_description(response)
          response_message << ": #{description}" if description
          response_info = "#{response_info} `#{response_message}`"
        end

        message = "[#{request_date}] -- \"#{request_info}\" | #{response_info}"

        File.open(log_file_path, 'a') { |f| f.write "#{message}\n" } if log_file_path

        return unless write_to_console == true

        message = "  RedtrackClient: #{message}"
        if message.respond_to?(:green)
          message = ('200'..'299').cover?(result.code) ? message.green : message.red
        end
        puts message
      end

      private

      def error_description(response)
        JSON.parse(response.body)['error']['description']
      rescue
        nil
      end
    end
  end
end
