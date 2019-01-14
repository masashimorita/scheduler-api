namespace :report do
  task delete_previous: :environment do
    last_year = Time.current.prev_year
    last_month = Time.current.prev_month.end_of_month.end_of_day
    MonthlyReport.where("period_year <= ?",last_year.year).where("period_month <= ?", last_year.month).destroy_all
    Record.where("record_date <= ?", last_month).destroy_all
  end
end