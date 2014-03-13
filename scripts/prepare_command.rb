require 'xcodeproj'
require 'find'

# Find main project file
project_path = []
Find.find('../../') do |path|
  if(path == ".") 
    Find.prune
  end
  project_path << path if path =~ /.*\.xcodeproj$/
end
project_path.delete_if { |x| x.include?("Pods") }
puts project_path

# Open project
project = Xcodeproj::Project.open(project_path[0])
main_target = project.targets.first
phase = main_target.new_shell_script_build_phase("Label Optimizely Views")
phase.shell_script = "python \"$SRCROOT/Pods/Optimizely-iOS-SDK/scripts/OptimizelyPrepareNibs.py\""

# Move new script phase to the beginning
phases = main_target.build_phases
popped_phase = phases.pop
phases.unshift popped_phase

# Save project
project.save()