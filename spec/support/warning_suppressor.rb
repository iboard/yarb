class WarningSuppressor

  SUPPRESS_THESE_WARNINGS = [
    'QFont::setPixelSize: Pixel size <= 0 (0)',
    'content-type missing in HTTP POST, defaulting to'
  ]

  class << self
    def write(message)
      if suppress_warning? message
        0
      else
        @warnings ||= []
        @warnings << message
        message.length
      end
    end

    def dump_warnings
      if @warnings
        puts
        puts "Warnings from QT while running specs:"

        @warnings.each do |warning|
          puts warning
        end
      end
    end

    private

    def suppress_warning? message
      SUPPRESS_THESE_WARNINGS.any? { |suppressable_warning| message.try(:strip).try(:include?, suppressable_warning) }
    end

  end
end

Capybara.register_driver :webkit do |app|
  Capybara::Webkit::Driver.new(app, stderr: WarningSuppressor)
end

