require 'rubygems'
require 'cocoapods'
require 'find'

BUILD_PHASE_NAME = "Label Optimizely Views"
SHELL_SCRIPT = "python \"$PODS_ROOT/Optimizely-iOS-SDK/scripts/OptimizelyPrepareNibs.py\""

# Find main project file by looking in the Podfile declaration
xcodeproj_path = begin
  Pod::Command::IPC::Podfile::Pod::Podfile.from_file('../../Podfile').to_hash["target_definitions"].first["user_project_path"]
rescue
  begin Pod::Command::IPC::Podfile::Pod::Podfile.from_file('../../podfile').to_hash["target_definitions"].first["user_project_path"] rescue nil end
end

if xcodeproj_path
  xcodeproj_path = "../../" + xcodeproj_path
else
  xcodeproj_path = Dir['../../*'].detect do |fname|
      fname =~ /.*\.xcodeproj$/
  end
end

unless xcodeproj_path
  print "Could not locate project, please add the OptimizelyPrepareNibs.py build phase manually"
  abort
end

# Open project
project = Xcodeproj::Project.open(xcodeproj_path)
main_target = project.targets.first

# What to install
install_build_phase = true

# Check if build phase already exists
phases = main_target.shell_script_build_phases
phases.each do |phase|
  if phase.shell_script == SHELL_SCRIPT 
    install_build_phase = false
  end
end

# Install shell script build phase if necessary
if install_build_phase
  phase = main_target.new_shell_script_build_phase(BUILD_PHASE_NAME)
  phase.shell_script = SHELL_SCRIPT
  # Move new script phase to the beginning
  phases = main_target.build_phases
  popped_phase = phases.pop
  phases.unshift popped_phase
  project.save()
end