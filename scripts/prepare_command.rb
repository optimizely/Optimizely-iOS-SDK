require 'xcodeproj'
require 'find'

BUILD_PHASE_NAME = "Label Optimizely Views"

# Find main project file
project_path = []
Find.find('../../') do |path|
  if(path == ".") 
    Find.prune
  end
  project_path << path if path =~ /.*\.xcodeproj$/
end
puts project_path

# Open project
project = Xcodeproj::Project.open(project_path[0])

# Check if build phase already exists
phases = main_target.shell_script_build_phases
phases.each do |phase|
  if phase.name == BUILD_PHASE_NAME
    puts "SHORTCUT"
    return
  end
end

# If not, add it
main_target = project.targets.first
phase = main_target.new_shell_script_build_phase(BUILD_PHASE_NAME)
phase.shell_script = "python \"$SRCROOT/Pods/Optimizely-iOS-SDK/scripts/OptimizelyPrepareNibs.py\""

# Move new script phase to the beginning
phases = main_target.build_phases
popped_phase = phases.pop
phases.unshift popped_phase

# Save project
project.save()