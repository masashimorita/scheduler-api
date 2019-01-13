require 'rails_helper'

RSpec.describe 'Api::V1::RecordsController', type: :request do
  let!(:user) { create(:user, default_email: 'test@test.com', default_password: 'test') }
  let!(:access_token) { AuthenticateUser.new(user.email, 'test').call }
  let!(:records) { create_list(:record, 2, default_user: user) }
  describe 'GET /api/v1/records' do
    let(:path) { "/api/v1/records" }
    it 'get all records' do
      get path, headers: {Authorization: "Bearer #{access_token}"}
      expect(JSON.parse(response.body)['records'].length).to eq 2
    end
  end

  describe 'GET /api/v1/records/:id' do
    let(:path) { "/api/v1/records/" }
    it 'get specific record' do
      get path + records.first.id.to_s, headers: {Authorization: "Bearer #{access_token}"}
      record = JSON.parse(response.body)['record']
      expect(record['worked_hour']).to eq records.first[:worked_hour]
      expect(record['start_at'].to_time).to eq records.first[:start_at].to_time
      expect(record['end_at'].to_time).to eq records.first[:end_at].to_time
      expect(record['record_date'].to_date).to eq records.first[:record_date].to_date
    end

    it 'get no record with invalid id' do
      get path + 0.to_s, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 404
      expect(JSON.parse(response.body)['message']).to include("Couldn't find Record with")
    end
  end

  describe 'POST /api/v1/records/start' do
    let(:path) { "/api/v1/records/start" }
    let(:request) { post path, headers: {Authorization: "Bearer #{access_token}"} }
    it  'create record successfully' do
      request
      expect(response.status).to eq 201
    end

    it 'change record count' do
      expect{ request }.to change{ Record.all.count }.by(1)
    end
  end

  describe 'POST /api/v1/records/end' do
    let(:path) { "/api/v1/records/end" }
    let!(:record) { create(:record, default_user: user) }
    it 'assign end_at & worked hour' do
      post path, params: {id: record.id}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 200
      record = JSON.parse(response.body)['record']
      expect(record['worked_hour']).not_to be nil
      expect(record['end_at']).not_to be nil
    end
  end

  describe 'PUT /api/v1/records/:id' do
    let!(:record) { create(:record, default_user: user, default_end_at: nil, default_worked_hour: nil) }
    let(:path) { "/api/v1/records/#{record.id}" }
    it 'update start_at' do
      start_at = record[:start_at]
      put path, params: {start_at: Time.current - 2.hours}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['record']['start_at']).not_to eq start_at
    end

    it 'update end_at' do
      put path, params: {end_at: Time.current + 2.hours}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['record']['end_at']).not_to be nil
      expect(JSON.parse(response.body)['record']['worked_hour']).not_to be nil
    end
  end

  describe 'DELETE /api/v1/records/:id' do
    let!(:record) { create(:record, default_user: user) }
    let(:path) { "/api/v1/records/#{record.id}" }
    it 'delete specific record' do
      delete path, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['message']).to eq 'Working record has successfully deleted'
    end
  end
end