module V10
  class AppVersionsController < ApplicationController
    def index
      @ios_version = AppVersion.find_by(platform: :ios)
      @android_version = AppVersion.find_by(platform: :android)
    end
  end
end
