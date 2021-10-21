class SearchesController < ApplicationController
  before_action -> { set_page Gemcutter::SEARCH_MAX_PAGES }, only: :show
  # ApplicationControllerの69行目
  # application.rbのGemcutterモジュールを参照

  def show
    return unless params[:query].is_a?(String)
    # 途中で処理を抜け出したい場合は、returnを使用
    # is_a レシーバが引数で指定した型に一致していればtrue, 異なればfalseを返す。
    @error_msg, @gems = ElasticSearcher.new(params[:query], page: @page).search

    set_total_pages if @gems.total_count > Gemcutter::SEARCH_MAX_PAGES * Rubygem.default_per_page #rubygem.rb 61
    exact_match = Rubygem.name_is(params[:query]).first #rubygem.rb 49
    @yanked_gem = exact_match unless exact_match&.indexed_versions? # rubygem.rb143
    @yanked_filter = true if params[:yanked] == "true"
  end

  def advanced
  end

  private

  def set_total_pages
    class << @gems  # 特異クラス
      def total_pages
        Gemcutter::SEARCH_MAX_PAGES
      end
    end
  end
end

# default_per_page = kaminari

# 　「&.」とは（概要）
# ぼっち演算子と呼ばれる
# Rubyでは通常、レシーバーに対してメソッドが実行された時、レシーバー（オブジェクト）がnilだった場合にエラーを返します。
# しかしプログラムによっては、エラーを返したくない時があります。そんな時に使うのが「&.」（ぼっち演算子）です。
# * ぼっち演算子はオブジェクトがnilだった場合にエラーではなく、nilを返してくれます。*
# オブジェクト&.メソッド
# @nickname = current_user&.nickname

# 特異クラス
# class << obj
# クラスメソッドを定義するイディオムのひとつ
# それ故に特異クラスに対応した特定のオブジェクト以外はそのメソッドを実行できないということになります。
# オブジェクトが持っている特異クラスはObject#singleton_classメソッドによって確認する事ができます。
