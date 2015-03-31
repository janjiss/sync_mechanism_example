require "spec_helper"

describe Sync::PostsParser do
  let(:posts_parser) { Sync::PostsParser.new() }
  let(:parsed_posts) {posts_parser.parse(data)}

  context "With multiple images" do
    let(:post) {parsed_posts.first}

    it "has node id" do
      expect(post.node_id).to eq(5331)
    end

    it "parses legacy link" do
      expect(post.legacy_link).to eq("/node/5331")
    end

    it "has parses category list" do
      expect(post.category).to eq(["Category 1"])
    end

    it "has empty photo_author" do
      expect(post.photo_author).to eq("Photo Author")
    end

    it "has photo_author" do
      expect(post.author).to eq("Post Author")
    end

    it "strips title of a link" do
      expect(post.title).to eq("Link to title")
    end

    it "parses unix timestamp" do
      expect(post.created_at).to eq(DateTime.parse("Fri, 13 Feb 2015 17:36:05 GMT"))
    end

    it "has description" do
      expect(post.description).to eq("Some random description of a post")
    end

    it "has body stripped off from all attributes" do
      expect(post.body).to eq("<p>Hello World from body</p>'")
    end

    it "has no style attribute" do
      expect(post.body).not_to include("style=")
    end

    it "has multiple images" do
      expect(post.images).to include(
        "http://www.google.com/image1.jpg",
        "http://www.google.com/image2.jpg"
      )
    end
  end

  context "With single image" do
    let(:post) {parsed_posts.last}
    it "parses data for post with single image" do
      expect(post.images).to eq(["http://www.google.com/image1.jpg"])
    end

    it "has multiple categories" do
      expect(post.category).to eq(["Category 1", "Category 2"])
    end
  end
end

def data
  [
    {
      "node_id": "5331",
      "legacy_link": "<a href='/node/5331'>Link to node</a>",
      "title": "<a href='/node/5331'>Link to title<a>",
      "author": "Post Author",
      "category": "<a href='/link/to/category'>Category 1</a>",
      "photo_author": "Photo Author",
      "created_at": "1423848965",
      "description": "Some random description of a post",
      "body": "<p style='font-size: 20px'>Hello World from body</p>'",
      "images": [
        {
          "src": "http://www.google.com/image1.jpg",
          "alt": ""
        },
        {
          "src": "http://www.google.com/image2.jpg",
          "alt": ""
        }
      ]
    },
    {
      "node_id": "5330",
      "legacy_link": "<a href='/legacy_link'>Legacy link</a>",
      "title": "<a href='/node/5331'>Link to title<a>",
      "author": "Post Author",
      "category": "<a href='/link/to/category'>Category 1</a>,<a href='/link/to/category'>Category 2</a> ",
      "photo_author": "Photo Author",
      "created_at": "1423842114",
      "description": "This is a description of post",
      "body": "<p><span style='font-size: 20px;'>Hello world from body</span></p>",
      "images": {
        "src": "http://www.google.com/image1.jpg",
        "alt": ""
      }
    }
  ]
end
