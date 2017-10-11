namespace 'drone-ver' do
	task :version do
		ask(:mood)
		on roles(:app) do
			execute "#{current_path}/generate_version.rb #{fetch(:mood)}"
		end
	end
end
