module SubmissionGraphHelper
  def create_graph(user)
  		account = Account.find_by(user_id: user.id) # Assume user has only 1 domjudge acc
  		achievements = user.achievements

  		data_subs = []  	
  		account.submissions.order(:judged_at).each do |s|
  			year = s.judged_at.year
			week = [52, s.judged_at.to_date.cweek].min
			t = Date.commercial(year,week).to_time.to_i*1000
			if data_subs.length > 0 and data_subs[-1][0] == t
				data_subs[-1][1] += 1
			else
				data_subs.push([t, 1])
			end
		end
		
		data_achiev = []
		achievements.each do |a|
			year = a.date_of_completion.year
			week = [52, a.date_of_completion.to_date.cweek].min
			t = Date.commercial(year,week).to_time.to_i*1000 
			data_achiev.push({x: t, text: "#{a.achievement_datum.description}", 
				title: "<img src='/assets/trophies/gold.png' width='20' height='20'>" })
		end

		@chart = LazyHighCharts::HighChart.new('graph') do |f|
		  f.title(text: "Submissions over the years")
		  f.xAxis(type: 'datetime')
		  f.series(id: 'test', data: data_subs, name: 'Submissions')
		  f.series(type:'flags', onSeries: 'test', data: data_achiev, useHTML: true, y: -50)
		  f.legend(enabled: false)
		  
		  f.yAxis(title: {text: "Number of submissions"})
		  f.chart({defaultSeriesType: "column"})
		end		

		@chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
  			f.global(useUTC: true)  			
		end

		return { chart: @chart, chart_globals: @chart_globals }
  end
end

