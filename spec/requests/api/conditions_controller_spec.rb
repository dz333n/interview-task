require "rails_helper"

describe "/api/conditions", type: :request do
  describe "#create" do
    let(:formula) { "User.id == 3" }
    let(:params) { { formula: formula } }

    subject { post "/api/conditions", params: params }

    it "creates a new condition" do
      subject
      response_json = JSON.parse(response.body)
      expect(Condition.find(response_json["id"]).foruma).to eq(formula)
    end
  end

  describe "#entities" do
    let(:test_data) do
      [
        { contract: "contract", supplier_spend: 10_000 },
        { contract: "new contract", supplier_spend: 15_000 },
        { contract: "old contract", supplier_spend: 20_000 }
      ]
    end
    let(:contracts) do
      test_data.map do |data|
        Contract.create!(
          name: data[:contract],
          supplier: Supplier.create(spend: data[:supplier_spend]),
          user: User.create!(email: Faker::Internet.email)
        )
      end
    end
    let(:example_contract) { contracts.sample }
    let(:formula) { "User.contract.name == '#{example_contract.name}'" }
    let(:condition) { Condition.create!(formula: formula) }

    subject do
      contracts
      get "/api/conditions/#{condition.id}/entities"
    end

    it "returns sample contract user dto" do
      subject
      user_dto = JSON.parse(response.body).with_indifferent_access
      expect(user_dto[:id]).to eq(example_contract.user.id)
      expect(user_dto[:email]).to eq(example_contract.user.email)
    end

    context "when formula base object is contract" do
      let(:formula) { "Contract.name == '#{example_contract.name}'" }

      it "returns sample contract dto" do
        subject
        contract_dto = JSON.parse(response.body).with_indifferent_access
        expect(contract_dto[:id]).to eq(example_contract.id)
        expect(contract_dto[:name]).to eq(example_contract.name)
      end
    end

    context "when formula base object is supplier" do
      let(:formula) { "Supplier.spend == #{example_contract.supplier.spend}" }

      it "returns sample contract supplier dto" do
        subject
        supplier_dto = JSON.parse(response.body).with_indifferent_access
        expect(contract_dto[:id]).to eq(example_contract.supplier.id)
        expect(contract_dto[:spend]).to eq(example_contract.supplier.spend)
      end
    end
  end
end
