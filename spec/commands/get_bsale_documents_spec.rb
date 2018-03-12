require 'rails_helper'

describe GetBsaleDocuments do
  def perform(*_args)
    described_class.for(*_args)
  end

  let(:sale_documents) do
    [{ "id" => 369, "client" => { "href" => "http://client_url" } },
     { "id" => 370, "client" => { "href" => "http://client_url" } },
     { "id" => 371, "client" => { "href" => "http://client_url" } }]
  end

  let(:buy_documents) do
    [{ "id" => 469, "clientCode" => "76191257-7" },
     { "id" => 470, "clientCode" => "76191257-7" },
     { "id" => 471, "clientCode" => "76191257-7" }]
  end

  before do
    allow_any_instance_of(BsaleClient).to receive(:get_sale_documents)
      .and_return(sale_documents)
    allow_any_instance_of(BsaleClient).to receive(:get_buy_documents)
      .and_return(buy_documents)
    allow_any_instance_of(BsaleClient).to receive(:get_bsale_object)
      .and_return("code" => "76191257-7")
  end

  describe "#perform" do
    context "with all documents new" do
      before do
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
                          bsale_info: { "id" => 369,
                                        "client" => { "href" => "http://client_url" },
                                        "info" => "old info" })
      end
      let!(:buy_document) do
        create(:document, bsale_id: 471,
                          document_type: "buy",
                          created_at: Time.now - 5.days,
                          bsale_info: { "id" => 471,
                                        "clientCode" => "76191257-7",
                                        "info" => "old info" })
      end

      before do
        perform
      end

      it { expect(Document.all.count).to eq(6) }
      it { expect(Document.first.bsale_id).to eq(369) }
      it { expect(Document.second.bsale_id).to eq(471) }
      it { expect(Document.first.bsale_info["info"]).to eq("old info") }
      it { expect(Document.second.bsale_info["info"]).to eq("old info") }
    end
  end
end
