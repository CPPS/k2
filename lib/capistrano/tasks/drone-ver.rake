namespace 'drone-ver' do
	task :version do
		ask(:mood)
		on roles(:app) do
			execute "cd #{release_path}; ./generate-version.rb #{fetch(:mood)}"
		end
	end
end
