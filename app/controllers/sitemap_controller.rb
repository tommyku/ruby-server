class SitemapController < ApplicationController
  layout nil

  def index
    headers['Content-Type'] = 'application/xml'
    last_post = Presentation.last
    if stale?(:etag => last_post, :last_modified => last_post.updated_at.utc)
      respond_to do |format|
        format.xml { @presentations = Presentation.where(:enabled => true) }
      end
    end
  end
end
