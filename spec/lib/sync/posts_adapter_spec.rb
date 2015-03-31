require 'spec_helper'

describe Sync::PostsAdapter do
  let(:posts_adapter) {Sync::PostsAdapter.new}

  it "fetches first page" do
    VCR.use_cassette("posts_first_page") do
      result = posts_adapter.fetch_posts(1)
      expect(result.count).to eq(10)
      first_page = result.first
      expect(first_page.fetch("node_id")).to be_present
      expect(first_page.fetch("legacy_link")).to be_present
      expect(first_page.fetch("title")).to be_present
      expect(first_page.fetch("author")).to be_present
      expect(first_page.fetch("category")).to be_present
      expect(first_page.fetch("photo_author")).to be_present
      expect(first_page.fetch("created_at")).to be_present
      expect(first_page.fetch("description")).to be_present
      expect(first_page.fetch("body")).to be_present
      expect(first_page.fetch("images")).to be_present
    end
  end

end
