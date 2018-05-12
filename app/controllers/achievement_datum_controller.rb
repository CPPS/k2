class AchievementDatumController < ApplicationController

	def show 	
  	file = File.read('achievements.json')
  	data = JSON.parse file  


  	@ach = data['achievements'].find { |h| h['id'] == params[:id]}
  	@ach = AchievementDatum.find(params[:id])
  	if @ach.nil?
  		raise "id wrong/unknown"
  	end  	
  end

  def update()
  	file = File.read('achievements.json')
  	data = JSON.parse file  

  	@ach = AchievementDatum.find(params[:id])
  	
  	@ach.title = params[:title]
  	@ach.description = params[:description]
  	@ach.level_entries.destroy_all
  	params[:problems].split(",").each do |p|
  		@ach.level_entries.create(value: test)
  	end
  	debugger
		@ach.save!

  	redirect_to action: :show, id: params[:id]
  end
end
