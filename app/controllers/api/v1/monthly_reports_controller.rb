class Api::V1::MonthlyReportsController < Api::V1::ApiController
  def index
    reports = MonthlyReport.find_by(user_id: current_user.id)
    json_response({reports: reports})
  end

  def show
    report = MonthlyReport.find(report_params[:id])
    json_response({report: report})
  end

  private
  def report_params
    params.permit(:id)
  end
end