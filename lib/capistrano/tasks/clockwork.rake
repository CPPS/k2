namespace "clockwork" do
	%w[start stop].each do |command|
		task command do
			on roles(:app) do
				execute "cd #{current_path};RAILS_ENV='production' bundle exec clockworkd -c clock.rb #{command}"
			end
		end
	end
	task :restart do
		invoke "clockwork:stop"
		invoke "clockwork:start"
	end
end

