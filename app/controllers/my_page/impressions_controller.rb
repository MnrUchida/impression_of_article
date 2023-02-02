module MyPage
  class ImpressionsController < ApplicationController
    before_action :set_impressions, except: %i[new create]
    before_action :set_impression, only: %i[show edit update update_temporary destroy publish post_mastodon]

    def index
      @impressions = @impressions.where(status: params[:status])
      @impressions = @impressions.page(params[:page]).per(5)
    end

    def new
      @impression = Impression.new
    end

    def show
      @decorated_impression = ImpressionDecorator.decorate(@impression)
      @impression_tags = @decorated_impression.impression_tags.preload(:tag)
    end

    def edit; end

    def update
      @impression.attributes = impression_params
      @impression.user = current_user
      if @impression.save
        message = @impression.pending? ? "下書きを保存しました" : "更新しました"
        redirect_to my_page_impressions_url(status: @impression.status), notice: message
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def create
      @impression = Impression.new(impression_params)
      @impression.user = current_user
      if @impression.save
        message = @impression.pending? ? "下書きを保存しました" : "登録しました"
        redirect_to my_page_impressions_url(status: @impression.status), notice: message
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update_article
      @article = Article.find_or_initialize_by_url(params[:url])
      @article.save if @article.present? && @article.valid?
    end

    def publish
      @impression.published!
      redirect_to my_page_impressions_url(status: :published)
    end

    def destroy
      @impression.destroy!
      redirect_to my_page_impressions_url, notice: "削除しました"
    end

    def post_mastodon
      @decorated_impression = ImpressionDecorator.decorate(@impression)
      Faraday.post("#{current_user.mastodon_data_linkage.site}/api/v1/statuses",
                   {
                     "status": @decorated_impression.for_mastodon,
                     "visibility": "unlisted"
                   },
                   {
                     'Content-type': 'application/x-www-form-urlencoded; charset=UTF-8',
                     'Authorization': "Bearer #{current_user.mastodon_data_linkage.token}"
                   })
    end

    private

      def set_impression
        @impression = @impressions.find(params[:id])
      end

      def set_impressions
        @impressions = Impression.preload(:article, :tags).where(user: current_user).order(created_at: :desc, id: :asc)
      end

      def impression_params
        params.require(:impression).permit(:detail, :summary, :article_id, :entry_type)
      end
  end
end
