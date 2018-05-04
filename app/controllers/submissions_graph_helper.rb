module SubmissionsGraphHelper
  def create_graph(user)
  		account = Account.find_by(user_id: user.id) # Assume user has only 1 domjudge acc
  		submissions = account.submissions.group('yearweek(created_at)').count 
  		achievements = user.achievements

  		data_subs = []  	
  		submissions.each do |s, k|
  			year = s.to_s[0..3].to_i
  			week =  [1, s.to_s[4..5].to_i, 52].sort[1]
			data_subs.push([Date.commercial(year,week).to_time.to_i*1000, k])

		end
		
		data_achiev = []
		achievements.each do |a|
			year = a.date_of_completion.year
			week = a.date_of_completion.to_date.cweek
			data_achiev.push({x: Date.commercial(year,week).to_time.to_i*1000, text: "#{a.descr}", 
				title: "<img src='#{a.filename}' width='20' height='20'>" })
		end

		@chart = LazyHighCharts::HighChart.new('graph') do |f|
		  f.title(text: "Submissions over the years")
		  f.xAxis(type: 'datetime')
		  f.series(id: 'test', data: data_subs, name: 'Submissions')
		  f.series(type:'flags', onSeries: 'test', data: data_achiev, useHTML: true, y: -45)
		  f.legend(enabled: false)
		  f.plotOptions({
		  		
		  	})
		  f.yAxis(title: {text: "Number of submissions"})
		  f.chart( {
		  	defaultSeriesType: "column",	
		  	height: 450	  		
		   })		 
		  f.plotOptions({
			  		column: {
			  			pointPadding: 0,
            			groupPadding: 0,
            			borderWidth: 0,
            			shadow: false
			  		},
			  		flags: {
            			stackDistance: 26
			  		}
			  	}
		  	)
		  
		end		

		@chart_globals = LazyHighCharts::HighChartGlobals.new do |f|
  			f.global(useUTC: true)  			
		end

		return { chart: @chart, chart_globals: @chart_globals }
  end
end

