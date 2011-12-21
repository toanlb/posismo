require "spec_helper"

describe PartnerNotifier do
  describe "test" do
    let(:mail) { PartnerNotifier.test }

    it "renders the headers" do
      mail.subject.should eq("Test")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
