require 'rails_helper'

RSpec.describe 'Api::V1::MonthlyReportsController', type: :request do
  let!(:user) { create(:user, default_email: 'test@test.com', default_password: 'test') }
  let!(:access_token) { AuthenticateUser.new(user.email, "test").call }

  describe 'GET /api/v1/monthly_reports' do
    let(:path) { "/api/v1/monthly_reports" }
    before do
      10.times do
        create(:monthly_report, default_user: user)
      end
    end

    it 'get all the reports' do
      get path, params: {}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['reports'].length).to eq 10
    end

    it 'give unauthorized error without auth header' do
      get path, params: {}
      expect(response.status).to eq 422
      expect(JSON.parse(response.body)['message']).to eq 'Missing token'
    end
  end

  describe 'GET /api/v1/monthly_reports/:id' do
    let(:path) { "/api/v1/monthly_reports/" }
    let!(:report) { create(:monthly_report, default_user: user) }

    it "get specific report" do
      get path + report.id.to_s, params: {}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['report']).not_to be nil
    end

    it 'give not found error' do
      get path + 0.to_s, params: {}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 404
      expect(JSON.parse(response.body)['message']).to include("Couldn't find MonthlyReport")
    end

    it 'give unauthorized error without auth header' do
      get path + report.id.to_s, params: {}
      expect(response.status).to eq 422
      expect(JSON.parse(response.body)['message']).to eq 'Missing token'
    end
  end
end