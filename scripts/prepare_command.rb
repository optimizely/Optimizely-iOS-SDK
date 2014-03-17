require 'rubygems'
require 'xcodeproj'
require 'find'

BUILD_PHASE_NAME = "Label Optimizely Views"
SHELL_SCRIPT = "python \"$SRCROOT/Pods/Optimizely-iOS-SDK/scripts/OptimizelyPrepareNibs.py\""

# Find main project file
project_path = []
Find.find('../../') do |path|
  if(path == "../../Pods")
    Find.prune
  end
  project_path << path if path =~ /.*\.xcodeproj$/
end

# Open project
project = Xcodeproj::Project.open(project_path[0])
main_target = project.targets.first

# What to install
install_build_phase = true
install_linker_flag = true

# Check if build phase already exists
phases = main_target.shell_script_build_phases
phases.each do |phase|
  if phase.shell_script == SHELL_SCRIPT 
    install_build_phase = false
  end
end

# Check if build setting already exists
settings = main_target.build_settings("OTHER_LDFLAGS")
puts settings

# Install shell script build phase
if install_build_phase
  phase = main_target.new_shell_script_build_phase(BUILD_PHASE_NAME)
  phase.shell_script = SHELL_SCRIPT
  # Move new script phase to the beginning
  phases = main_target.build_phases
  popped_phase = phases.pop
  phases.unshift popped_phase
end

# Install linker flag
if install_linker_flag

end

# Save project
if install_linker_flag || install_build_phase
  project.save()
end