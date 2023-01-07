module MyPage
  class TagGroupsController < ApplicationController
    before_action :set_tag_group, only: %i[show edit update destroy edit_tags add_tag destroy_tag]

    def index
      @tag_groups = TagGroup.by_user(current_user.id).page(params[:page])
    end

    def new
      @tag_group = TagGroup.new(user: current_user)
    end

    def show; end

    def edit; end

    def edit_tags
      set_used_tags
    end

    def update
      @tag_group.attributes = tag_group_params
      if @tag_group.save
        redirect_to my_page_tag_group_url(@tag_group), notice: "tag_group was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def create
      @tag_group = TagGroup.new(tag_group_params.merge(user: current_user))
      if @tag_group.save
        redirect_to my_page_tag_group_url(@tag_group), notice: "tag_group was successfully updated."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def add_tag
      ActiveRecord::Base.transaction do
        @tag_group.add_tag(params[:tag_id])
      end
      set_used_tags
    end

    def destroy_tag
      @tag_group.tag_group_tags.where(tag_id: params[:tag_id]).destroy_all
      set_used_tags

      render :add_tag
    end

    private
      def set_tag_group
        @tag_group = TagGroup.by_user(current_user.id).find(params[:id])
      end

      def tag_group_params
        params.require(:tag_group).permit(:name, :sort_order)
      end

      def set_used_tags
        @unused_tags = Tag.unused_tags(current_user.id)
        @other_tags = Tag.used_tags(current_user.id).where.not(id: @tag_group.tag_group_tags.select(:tag_id))
      end
  end
end
