require 'rails_helper'

describe GetBsaleDocuments do
  def perform(*_args)
    described_class.for(*_args)
  end

  describe "#perform" do
    context "with all documents new" do
      let(:sale_documents) do
        [{ "id": 369, "info": "aditional info" },
         { "id": 370, "info": "aditional info" },
         { "id": 371, "info": "aditional info" }]
      end
      let(:buy_documents) do
        [{ "id": 469, "info": "aditional info" },
         { "id": 470, "info": "aditional info" },
         { "id": 471, "info": "aditional info" }]
      end
      before do
        allow_any_instance_of(BsaleClient).to receive(:get_sale_documents)
          .and_return(sale_documents)
        allow_any_instance_of(BsaleClient).to receive(:get_buy_documents)
          .and_return(buy_documents)
        perform
      end

      it { expect(Document.all.count).to eq(6) }
      it { expect(Document.first.bsale_id).to eq(369) }
      it { expect(Document.last.bsale_id).to eq(471) }
      it { expect(Document.first.document_type).to eq("sale") }
      it { expect(Document.last.document_type).to eq("buy") }
    end

    context "with one sale and buy documents created previously" do
      let!(:sale_document) do
        create(:document, bsale_id: 369,
                          document_type: "sale",
                          created_at: Time.now - 5.days,
                          bsale_info: "old info")
      end
      let!(:buy_document) do
        create(:document, bsale_id: 471,
                          document_type: "buy",
                          created_at: Time.now - 5.days,
                          bsale_info: "old info")
      end

      let(:sale_documents) do
        [{ "id": 369, "info": "aditional info" },
         { "id": 370, "info": "aditional info" },
         { "id": 371, "info": "aditional info" }]
      end
      let(:buy_documents) do
        [{ "id": 469, "info": "aditional info" },
         { "id": 470, "info": "aditional info" },
         { "id": 471, "info": "aditional info" }]
      end
      before do
        allow_any_instance_of(BsaleClient).to receive(:get_sale_documents)
          .and_return(sale_documents)
        allow_any_instance_of(BsaleClient).to receive(:get_buy_documents)
          .and_return(buy_documents)
        perform
      end

      it { expect(Document.all.count).to eq(6) }
      it { expect(Document.first.bsale_id).to eq(369) }
      it { expect(Document.second.bsale_id).to eq(471) }
      it { expect(Document.first.bsale_info).to eq("old info") }
      it { expect(Document.second.bsale_info).to eq("old info") }
    end
  end
end
