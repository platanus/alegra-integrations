require 'rails_helper'

describe SendDocumentToAlegra do
  def perform(*_args)
    described_class.for(*_args)
  end

  describe "#perform" do
    before do
      allow_any_instance_of(AlegraClient).to receive(:get_contact_by_rut)
        .and_return("id" => 4)
      allow_any_instance_of(described_class).to receive(:bsale_contact)
        .and_return("id" => 4)
      allow_any_instance_of(Document).to receive(:legal_id)
        .and_return(2)
    end

    context "create sale document" do
      let!(:sale_document) do
        create(:document, bsale_id: 888,
                          document_type: "sale",
                          created_at: Time.now,
                          bsale_info: {
                            "emissionDate" => Time.now.to_i,
                            "expirationDate" => Time.now.to_i,
                            "totalAmount" => "4000"
                            })
      end

      before do
        allow_any_instance_of(AlegraClient).to receive(:post)
          .and_return('{ "id": "4" }')
      end

      it { expect(Document.all.count).to eq(1) }
      it { expect(perform(document: sale_document)["id"]).to eq("4") }
    end

    context "create buy document" do
      let!(:buy_document) do
        create(:document, bsale_id: 888,
                          document_type: "buy",
                          created_at: Time.now,
                          bsale_info: {
                            "emissionDate" => Time.now.to_i,
                            "expirationDate" => Time.now.to_i,
                            "totalAmount" => 4000
                            })
      end

      before do
        allow_any_instance_of(AlegraClient).to receive(:create_third_party_document)
          .and_return("id" => "4")
      end

      it { expect(Document.all.count).to eq(1) }
      it { expect(perform(document: buy_document)["id"]).to eq("4") }
    end
  end
end
