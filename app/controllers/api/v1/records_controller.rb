class Api::V1::RecordsController < Api::V1::ApiController
  before_action :set_record, only: [:show, :update, :destroy, :end]

  def index
    records = current_user.records
    json_response({records: records})
  end

  def show
    json_response({record: @record})
  end

  def start
    check_in_time = Record.calculate_time(check_in: true, period: current_user.check_in_period)
    @record = current_user.records.create!(start_at: check_in_time, record_date: Time.current)
    json_response({record: @record}, :created)
  end

  def end
    return json_response({message: Message.not_found('Record')}, :not_found) if @record.nil?
    check_out_time = Record.calculate_time(check_in: false, period: current_user.check_in_period)
    break_hour = params[:break_hour].present? ? params[:break_hour].to_f : current_user.break_hour.to_f
    @record.end_at = check_out_time
    @record.worked_hour = @record.calculate_work_hour(break_hour: break_hour, had_break: params[:didnt_had_break].blank?)
    @record.save!

    get_monthly_report.add_daily_report(@record)
    json_response({record: @record})
  end

  def update
    update_params
    previous_date = @record.record_date.to_date
    if update_params[:start_at].present? && valid_time_string?(update_params[:start_at])
      @record.start_at = Record.calculate_time(check_in: true, current: update_params[:start_at].to_time, period: current_user.check_in_period)
      @record.record_date = update_params[:start_at].to_date
    end
    if update_params[:end_at].present? && valid_time_string?(update_params[:end_at])
      @record.end_at = Record.calculate_time(check_in: false, current: update_params[:end_at].to_time, period: current_user.check_in_period)
    end
    break_hour = params[:break_hour].present? ? params[:break_hour].to_f : current_user.break_hour.to_f
    @record.worked_hour = @record.calculate_work_hour(break_hour: break_hour, had_break: update_params[:didnt_had_break].blank?) if @record.end_at.present?
    @record.save!
    if @record.end_at.present?
      time = update_params[:start_at].present? ? update_params[:start_at].to_time : Time.current
      monthly_report = get_monthly_report(time: time)
      monthly_report.recalculate_report(@record, previous_date)
    end
    json_response({record: @record})
  end

  def destroy
    @record.destroy!
    json_response({message: Message.deleted("Working record")})
  end

  private
  def set_record
    @record = current_user.records.find(params[:id])
  end

  def update_params
    params.permit(:id, :start_at, :end_at, :break_hour, :didnt_had_break)
  end

  def get_monthly_report(time: Time.current)
    month, year = time.month, time.year
    monthly_report = current_user.monthly_reports.where(period_month: month).where(period_year: year).first
    if monthly_report.blank?
      monthly_report = current_user.monthly_reports.create!(period_month: month, period_year: year, total_hour: 0, total_days: 0, average_hour: 0, data: [].to_json)
    end
    monthly_report
  end
end