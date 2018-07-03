class ApplicationController < ActionController::Base

    def hello
        render html: "hello word!"
    end
end
