class HomeController < ApplicationController
  def index
    @downloads_count = GemDownload.total_count
    # クラスメソッドを呼び出している
    respond_to do |format|
      format.html
    end
  end
end

# total_count
# model/geem_download.rbに記載