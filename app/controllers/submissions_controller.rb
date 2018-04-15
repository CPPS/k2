class SubmissionsController < ApplicationController
  def show
  		account = Account.find_by(user_id: current_user.id)
  		submissions = Submission.where(account_id: account.account_id).group('yearweek(created_at)').count 

  		a = []
  		submissions.each do |s, k|
  			year = s.to_s[0..3].to_i
  			week =  [1, s.to_s[4..5].to_i, 52].sort[1]
			a.push([Date.commercial(year,week).to_time.to_i*1000, k])
		end

		@user_attempts = Submission.joins(:account)
				.where( accounts: {user_id: current_user })
				.order(created_at: :desc)
				.limit(10)

		@chart = LazyHighCharts::HighChart.new('graph') do |f|
		  f.title(text: "Submissions over the years")
		  f.xAxis(type: 'datetime')
		  f.series(id: 'test', data: a, name: 'Submissions')
		  #f.series(type:'flags', onSeries: 'test', data: [{x: Date.commercial(2017,30).to_time.to_i*1000, text: 'Completed all BAPC16 problems!', title: 'T'}])
		  f.legend(enabled: false)
		  
		  f.yAxis(title: {text: "Number of submissions"})
		  f.chart({defaultSeriesType: "line"})
		end		

		@chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
  			f.global(useUTC: true)
		end
  end

  def test
  	return "abc"
  end

  def process_submit
  		SubmissionUpdateJob.set(wait: 5.seconds).perform_later
  end

end

