module Admin
  class MusicsController < ApplicationController
    before_action :set_music, only: %i[show edit update destroy]

    def index
      @musics = Music.all
      @musics = @musics.title_like(search_params[:keyword]) if search_params[:keyword].present?
      @musics = @musics.page(params[:page])
    end

    def new
      @music = Music.new
    end

    def show
    end

    def edit; end

    def update
      @music.attributes = music_params
      if @music.save
        redirect_to admin_music_url(@music), notice: "Music was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def create
      @music = Music.new(music_params)
      if @music.save
        redirect_to admin_music_url(@music), notice: "Music was successfully updated."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private
      def set_music
        @music = Music.find(params[:id])
      end

      def music_params
        params.require(:music).permit(:note, :title, :url)
      end

      def search_params
        params.fetch(:search, {}).permit(:keyword)
      end
  end
end
