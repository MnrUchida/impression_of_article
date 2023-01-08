module MyPage
  class ImpressionTagsController < ApplicationController
    before_action :set_impression
    before_action :set_impression_tags, only: %i[index new destroy add_tag show_all_tags]
    before_action :set_impression_tag, only: %i[destroy]

    def index; end

    def new; end

    def create
      ActiveRecord::Base.transaction do
        @impression.create_tags!(params[:new_tags][:new_tags])
      end
      set_impression_tags
    end

    def destroy
      @impression_tag.destroy!
      set_impression_tags

      render :create
    end

    def add_tag
      ActiveRecord::Base.transaction do
        tag = Tag.find(params[:tag_id])
        @impression.add_tag!(tag)
      end
      set_impression_tags

      render :create
    end

    def show_all_tags
      @tags = @tags.content_like(params[:keyword]) if params[:keyword].present?
      set_tag_group
    end

    private def set_impression
      @impression = Impression.where(user: current_user).find(params[:impression_id])
    end

    private def set_impression_tag
      @impression_tag = @impression_tags.find(params[:id])
    end

    private def set_impression_tags
      @impression_tags = @impression.impression_tags.preload(:tag)
      @tags = Tag.where.not(id: @impression_tags.select(:tag_id)).order_by_count(current_user.id)
      set_tag_group
    end

    private def set_tag_group
      tag_id_by_group = TagGroupTag.where(user: current_user, tag_id: @tags.select(:id)).group(:tag_group_id).pluck(:tag_group_id, Arel.sql("ARRAY_AGG(tag_id)"))
      @tag_id_by_group = @tags.group_by { |tag| (tag_id_by_group.find { |_, tag_ids| tag_ids.include?(tag.id) } || [])[0] }
      @tag_groups = TagGroup.joins(:tag_group_tags).merge(TagGroupTag.where(tag_id: @tags.select(:id))).where(user: current_user).index_by(&:id)
    end
  end
end
