RSpec.describe Cast::Slugger do
  subject(:slugger) { described_class.new }

  describe "#call" do
    it "downcases the string" do
      expect(slugger.call("FOOO")).to eq "fooo"
    end

    it "strips out non-alphanumeric characters" do
      expect(slugger.call("testing (one)")).to eq "testing-one"
    end

    it "removes leading/trailing separators" do
      expect(slugger.call("(it's a mystery)")).to eq "it-s-a-mystery"
    end

    it "removes repeated separators" do
      expect(slugger.call("((something) in the air (tonight))")).to eq "something-in-the-air-tonight"
    end

    it "transliterates unicode characters" do
      expect(slugger.call("Françoise Sagan".encode("UTF-8"))).to eq "francoise-sagan"
    end
  end
end
