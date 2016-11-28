desc 'Runs rubocop and brakeman rake task'

task :static_analysis, :output_files do |_t, args|
  sh 'rubocop'

  require 'brakeman'
  files = args[:output_files].split(' ') if args[:output_files]
  Brakeman.run app_path: '.', output_files: files, print_report: true
end
