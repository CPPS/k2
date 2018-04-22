class SubmissionsController < ApplicationController
  def show
  		account = Account.find_by(user_id: current_user.id)
  		submissions = account.submissions.group('yearweek(created_at)').count 
  		achievements = current_user.achievements

  		data_subs = []  	
  		submissions.each do |s, k|
  			year = s.to_s[0..3].to_i
  			week =  [1, s.to_s[4..5].to_i, 52].sort[1]
			data_subs.push([Date.commercial(year,week).to_time.to_i*1000, k])

		end
		
		data_achiev = []
		achievements.each do |a|
			data_achiev.push({x: a.date_of_completion.to_time.to_i*1000, text: "#{a.descr}", 
				title: "<img src='https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIpKt_ZyFy7nRmZuKKFam6JkMwNX0vZgffBvBRHgXclVbbvLgz' width='20' height='20'>" })
		end

		@chart = LazyHighCharts::HighChart.new('graph') do |f|
		  f.title(text: "Submissions over the years")
		  f.xAxis(type: 'datetime')
		  f.series(id: 'test', data: data_subs, name: 'Submissions')
		  f.series(type:'flags', onSeries: 'test', data: data_achiev, useHTML: true, y: -45)
		  f.legend(enabled: false)
		  
		  f.yAxis(title: {text: "Number of submissions"})
		  f.chart({defaultSeriesType: "line"})
		end		

		@chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
  			f.global(useUTC: true)  			
		end

		@user_attempts = Submission.joins(:account)
				.where( accounts: {user_id: current_user })
				.order(created_at: :desc)
				.limit(10)
  end

  def test
  	return "abc"
  end

  def process_submit
  		SubmissionUpdateJob.set(wait: 5.seconds).perform_later
  end

end

