require 'rails_helper'

describe GetBsaleSaleDocuments do
  def perform(*_args)
    described_class.for(*_args)
  end

  describe "#perform" do
    context "with all documents new" do
      let(:documents) do
        [{ "id": 369, "info": "aditional info" },
         { "id": 370, "info": "aditional info" },
         { "id": 371, "info": "aditional info" }]
      end
      before do
        allow_any_instance_of(BsaleClient).to receive(:get_documents)
          .and_return(documents)
        perform
      end

      it { expect(Document.all.count).to eq(3) }
      it { expect(Document.first.bsale_id).to eq(369) }
      it { expect(Document.first.document_type).to eq("sale") }
    end

    context "with one document created previously" do
      let!(:document) do
        create(:document, bsale_id: 369,
                          document_type: "sale",
                          created_at: DateTime.now - 5.days,
                          bsale_info: "old info")
      end

      let(:documents) do
        [{ "id": 369, "info": "aditional info" },
         { "id": 370, "info": "aditional info" },
         { "id": 371, "info": "aditional info" }]
      end
      before do
        allow_any_instance_of(BsaleClient).to receive(:get_documents)
          .and_return(documents)
        perform
      end

      it { expect(Document.all.count).to eq(3) }
      it { expect(Document.first.bsale_id).to eq(369) }
      it { expect(Document.first.bsale_info).to eq("old info") }
    end
  end
end
