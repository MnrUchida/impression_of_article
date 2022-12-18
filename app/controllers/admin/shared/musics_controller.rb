module Admin
  module Shared
    class MusicsController < ApplicationController
      def index
        @musics = Music.all
        @musics = @musics.where("title LIKE :title", title: "%#{search_params[:title]}%")
        @musics = @musics.page(params[:page])
      end

      def new
        @music = Music.new
      end

      def show
        @music = Music.find(params[:id])
      end

      def create
        @music = Music.new(music_params)
        render :new, status: :unprocessable_entity unless @music.save
      end

      private def music_params
        params.require(:music).permit(:title, :url)
      end

      private def search_params
        params.fetch(:search, {}).permit(:title)
      end
    end
  end
end
