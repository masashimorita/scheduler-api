class Api::V1::MonthlyReportsController < Api::V1::ApiController
  def index
    reports = current_user.monthly_reports
    json_response({reports: reports})
  end

  def show
    report = current_user.monthly_reports.find(report_params[:id])
    json_response({report: report})
  end

  private
  def report_params
    params.permit(:id)
  end
end