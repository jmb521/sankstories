class ApplicationController < ActionController::Base
    require 'square'


    def initialize_square
        client = Square::Client.new(
        access_token: ENV['SQUARE_ACCESS_TOKEN'],
        environment: 'sandbox'
        #change to production when ready
        )
    end

end
