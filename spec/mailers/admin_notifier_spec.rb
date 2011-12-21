require "spec_helper"

describe AdminNotifier do
  describe "partner_registered" do
    let(:mail) { AdminNotifier.partner_registered }

    it "renders the headers" do
      mail.subject.should eq("Partner registered")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
