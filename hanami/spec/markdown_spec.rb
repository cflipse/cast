RSpec.describe Cast::Markdown do
  subject(:markdown) { described_class.new }

  describe "#to_html" do
    it "sanitizes input" do
      md = markdown.to_html("<script>alert()</script>")

      expect(md).not_to include("<script>")
    end

    it "converts input to markdown" do
      md = markdown.to_html <<~MD
        * this is a test
        * of two list items
      MD

      expect(md).to include("<li>this is a test</li>")
    end
  end
end
