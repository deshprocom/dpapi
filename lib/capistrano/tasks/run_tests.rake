namespace :deploy do
  desc "Runs test before deploying, can't deploy unless they pass"
  task :run_rspec do
    set :rails_env, 'development'
    invoke :'deploy:migrating'
    current_time = Time.current.strftime('%Y%m%d_%T')
    rspec_file = "#{current_time}_rspec.html"

    on fetch(:migration_servers) do
      within release_path do
        execute :rspec, "-f html -o ./public/files/#{rspec_file}"
      end
    end
    project_url = fetch(:project_url)
    file_url = "#{project_url}/files/#{rspec_file}"
    puts "report rspec: #{file_url}"
    puts "report rspec link: <a href='#{file_url}'>#{file_url}</a>"
  end
end