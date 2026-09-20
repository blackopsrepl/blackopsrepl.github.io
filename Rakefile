require "bridgetown"
require "fileutils"

Bridgetown.load_tasks

task default: :deploy

task :clean do
  FileUtils.rm_rf("output")
end

desc "Build the Bridgetown site for deployment"
task deploy: [:clean, "frontend:build"] do
  Bridgetown::Commands::Build.start
end

desc "Build the site in a test environment"
task :test do
  ENV["BRIDGETOWN_ENV"] = "test"
  Bridgetown::Commands::Build.start
end

desc "Build frontend assets with esbuild"
namespace :frontend do
  task :build do
    sh "npm run esbuild"
  end
end
