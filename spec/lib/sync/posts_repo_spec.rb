require 'spec_helper'

describe Sync::PostsRepo do
  let!(:category) {Category.create(name: "Baznīcas")}
  let(:posts_repo) {Sync::PostsRepo.new}
  let(:post) {Post.where(node_id: 5331).last}
  let(:example_post) {
    OpenStruct.new(
      node_id: 5331,
      legacy_link: "/node/5331",
      category: ["Category 1"],
      author: "Author",
      photo_author: "Post Author",
      title: "Title of a post",
      body: "This is a body of post",
      created_at: DateTime.parse("Fri, 13 Feb 2015 17:36:05 GMT"),
      description: "Post intro",
      images: ["http://www.kurzemnieks.lv/sites/default/files/styles/zinas/public/field/image/inta-galda-teniss.jpg"]
    )
  }

  before(:all) do
    VCR.use_cassette('record_image_download') do
      posts_repo.persist(example_post)
    end
  end

  context "Test single article presistance" do
    it "has legacy link" do
      expect(post.legacy_link).to eq("/node/5331")
    end

    it "has author" do
      expect(post.author).to eq("Author")
    end

    it "has photo by" do
      expect(post.photo_by).to eq("Post Author")
    end

    it "has title" do
      expect(post.title).to eq("Title of a post")
    end

    it "has body" do
      expect(post.body).to eq("This is a body of post")
    end

    it "has intro" do
      expect(post.intro).to eq("Post intro")
    end

    it "has published at" do
      expect(post.published_at).to eq(DateTime.parse("Fri, 13 Feb 2015 17:36:05 GMT"))
    end

    it "has single category" do
      expect(post.categories.pluck(:name)).to eq(["Category 1"])
    end

    it "persists article" do
      expect(post.images.pluck(:file)).to eq(["inta-galda-teniss.jpg"])
    end
  end

  context "Test overwrite of existing article" do
    it "does not create a duplicate record in database on another sync" do
      VCR.use_cassette('record_image_download') do
        posts_repo.persist(example_post)
      end
      expect(Post.count).to eq(1)
    end
  end
end
