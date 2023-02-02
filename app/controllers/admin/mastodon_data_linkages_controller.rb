module Admin
  class MastodonDataLinkagesController < ApplicationController
    before_action :check_exists, only: %i[show edit update]

    def new
      @mastodon_data_linkage = current_user.build_mastodon_data_linkage
    end

    def create
      @mastodon_data_linkage = current_user.build_mastodon_data_linkage(mastodon_data_linkage_params)
      if @mastodon_data_linkage.save
        redirect_to admin_mastodon_data_linkage_url
      else
        render action: :new
      end
    end

    def show; end

    def edit
      @mastodon_data_linkage = current_user.mastodon_data_linkage
    end

    def update
      @mastodon_data_linkage = current_user.mastodon_data_linkage
      @mastodon_data_linkage.attributes = mastodon_data_linkage_params
      if @mastodon_data_linkage.save
        redirect_to admin_mastodon_data_linkage_url
      else
        render action: :edit
      end
    end

    def callback
      redirect_to root_path
    end

    private def check_exists
      redirect_to action: :new if current_user.mastodon_data_linkage.blank?
    end

    private def mastodon_data_linkage_params
      params.require(:mastodon_data_linkage).permit(:site, :token)
    end
  end
end
