class AchievementDatumController < ApplicationController

	def show 	
  	@ach = AchievementDatum.find_by(id: params[:id])
  	if @ach.nil?
  		@ach = AchievementDatum.new
  	end  	
  end

  def update()
    if params[:id].empty?
      @ach = AchievementDatum.new
      @ach.save!
    else
    	@ach = AchievementDatum.find(params[:id])
    end
  	
  	@ach.title = params[:title]
  	@ach.description = params[:description]

  	@ach.problem_entries.destroy_all
  	params[:problems].split(",").each do |p|
      @ach.problem_entries.create(value: p.strip)
  	end

    @ach.level_entries.destroy_all
    params[:levels].split(",").each do |p|
      @ach.level_entries.create(value: p.strip)
    end

    @ach.variable = nil
    if params[:variable_enabled] == "yes"
      @ach.variable = params[:variable]
      @ach.comparison = params[:comparison]
      @ach.value = params[:variable_value]
    end
    
    if not params[:levels].empty?
      @ach.category!
    else
      @ach.general!        
    end

		@ach.save!

  	redirect_to action: :show, id: @ach.id
  end

  def reprocess()
    AchievementReprocess.perform_now(params[:all] == "true")
  end

  def delete()
    AchievementDatum.find(params[:id]).destroy

    redirect_to action: :show, id: AchievementDatum.first.id
  end
end
