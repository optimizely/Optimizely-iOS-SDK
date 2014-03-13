puts Dir.pwd 
require 'xcodeproj'
require 'find'

project_path = []
Find.find('../../') do |path|
  project_path << path if path =~ /.*\.xcodeproj$/
end
project_path.delete_if { |x| x.include?("Pods") }
puts project_path
project = Xcodeproj::Project.open(project_path[0])
main_target = project.targets.first
phase = main_target.new_shell_script_build_phase("Label Optimizely Views")
phase.shell_script = "python \"$SRCROOT/Pods/Optimizely-iOS-SDK/OptimizelyPrepareNibs.py\""
phases = main_target.build_phases
popped_phase = phases.pop
phases.unshift popped_phase
puts phases
project.save()