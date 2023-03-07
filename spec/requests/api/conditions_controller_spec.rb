require "rails_helper"

describe "/api/conditions", type: :request do
  describe "#create" do
    let(:formula) { "User.id == 3" }
    let(:params) { { formula: formula } }

    subject { post "/api/conditions", params: params }

    it "creates a new condition with the expected params" do
      subject
      response_json = JSON.parse(response.body)
      expect(Condition.find(response_json["id"]).formula).to eq(formula)
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

    it "returns sample contract user dtos" do
      subject
      results = JSON.parse(response.body).map(&:with_indifferent_access)
      results.each do |result|
        expect(result[:id]).to eq(example_contract.user.id)
        expect(result[:email]).to eq(example_contract.user.email)
      end
    end

    context "when there were samples samples met the same condition" do
      let(:same_condition_contract) do
        Contract.create!(
          user: User.create!(email: Faker::Internet.email),
          supplier: Supplier.create!(spend: example_contract.supplier.spend),
          name: example_contract.name
        )
      end

      before(:each) { same_condition_contract }

      it "returns these users too" do
        subject
        results = JSON.parse(response.body).map(&:with_indifferent_access)
        expected_contracts = [example_contract, same_condition_contract]
        expected_user_ids = expected_contracts.map(&:user_id)
        expected_emails = expected_contracts.map(&:user).map(&:email)

        results.each do |result|
          expect(expected_user_ids.include?(result[:id])).to be_truthy
          expect(expected_emails.include?(result[:email])).to be_truthy
        end
      end
    end

    context "when formula base object is contract" do
      let(:formula) { "Contract.name == '#{example_contract.name}'" }

      it "returns sample contract dto" do
        subject

        results = JSON.parse(response.body).map(&:with_indifferent_access)
        results.each do |result|
          expect(contract_dto[:id]).to eq(example_contract.id)
          expect(contract_dto[:name]).to eq(example_contract.name)
        end
      end
    end

    context "when formula base object is supplier" do
      let(:formula) { "Supplier.spend == #{example_contract.supplier.spend}" }

      it "returns sample contract supplier dto" do
        subject

        results = JSON.parse(response.body).map(&:with_indifferent_access)
        results.each do |result|
          expect(result[:id]).to eq(example_contract.supplier.id)
          expect(result[:spend]).to eq(example_contract.supplier.spend)
        end
      end
    end
  end
end
