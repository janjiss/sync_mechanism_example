require "spec_helper"

describe Sync::PostsMapper do

  it "synchronizes" do
    VCR.use_cassette("posts_sync") do
      posts_mapper = Sync::PostsMapper.new(page: 1)
      posts_mapper.start_sync
    end
  end
end
