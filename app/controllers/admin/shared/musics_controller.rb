module Admin
  module Shared
    class MusicsController < ApplicationController
      before_action :set_music, only: %i[update destroy]

      def index
        @musics = Music.all
        @musics = @musics.where("title LIKE :title", title: "%#{search_params[:title]}%")
        @musics = @musics.page(params[:page])
      end

      def new
        @music = Music.new
      end

      def create
        @music = Music.new(music_params)
        render :new, status: :unprocessable_entity unless @music.save
      end

      def show; end

      def destroy; end

      def show_music
        @music = Music.find_or_initialize_by_url(params[:url])
      end

      private def music_params
        params.require(:music).permit(:title, :url)
      end

      private def search_params
        params.fetch(:search, {}).permit(:title)
      end

      private def set_music
        @music = Music.find(params[:id])
      end
    end
  end
end
