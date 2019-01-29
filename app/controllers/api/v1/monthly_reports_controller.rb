class Api::V1::MonthlyReportsController < Api::V1::ApiController
  def index
    reports = current_user.monthly_reports
    json_response({reports: reports})
  end

  def show
    report = current_user.monthly_reports.find(report_params[:id])
    json_response({report: report})
  end

  def recalculate
    report = current_user.monthly_reports.find(report_params[:id])
    beginning_of_month = Time.current.beginning_of_month.to_date
    end_of_month = Time.current.end_of_month.to_date
    records = current_user.records.where("record_date >= ?", beginning_of_month).where("record_date <= ?", end_of_month).order(record_date: :asc)
    report.recalculate_all(records)
    json_response({report: report})
  end

  private
  def report_params
    params.permit(:id)
  end
end