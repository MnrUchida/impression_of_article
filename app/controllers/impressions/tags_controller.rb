module Impressions
  class TagsController < ApplicationController
    def index
      @tags = Tag.content_like(params[:keyword]).order_by_count(nil)
    end

    def update
      tag_ids = params[:tag_ids].presence || []
      tag_ids << params[:id]
      tags = Tag.where(id: tag_ids)
      @tag = Tag.find(params[:id])
      render partial: "impressions/tags/selected_tags", locals: { tags: tags }
    end

    def destroy
      tag_ids = (params[:tag_ids].presence || []).reject { |tag_id| tag_id.to_i == params[:id].to_i }
      tags = Tag.where(id: tag_ids)
      @tag = Tag.find(params[:id])
      render partial: "impressions/tags/selected_tags", locals: { tags: tags }
    end
  end
end
