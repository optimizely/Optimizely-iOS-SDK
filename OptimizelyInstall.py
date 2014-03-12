#!/usr/bin/env python

""" This script installs the Optimizely Framework into the given project. """

import io
import json
import os
import random
import re
import shutil
import subprocess
import sys

FRAMEWORK_PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), 'Optimizely.framework/'))
SCRIPTS_DIR = os.path.abspath(os.path.dirname(__file__))

class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'

    RED = '\033[91m'
    GREEN = '\033[92m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    WHITE = '\033[97m'
    YELLOW = '\033[93m'
    MAGENTA = '\033[95m'
    GREY = '\033[90m'
    BLACK = '\033[90m'
    DEFAULT = '\033[99m'

def print_warning(string):
  print bcolors.WARNING + string + bcolors.ENDC

def print_ok(string):
  print bcolors.OKGREEN + string + bcolors.ENDC

def print_fail(string):
  print bcolors.FAIL + string + bcolors.ENDC

def print_question(string):
  print bcolors.GREY + string + bcolors.ENDC

def print_cyan(string):
  print bcolors.CYAN + string + bcolors.ENDC

def print_magenta(string):
  print bcolors.MAGENTA + string + bcolors.ENDC

def print_grey(string):
  print bcolors.GREY + string + bcolors.ENDC

def print_blue(string):
  print bcolors.BLUE + string + bcolors.ENDC

def die(message):
  print_fail('Error: %s' % message)
  sys.exit(1)

def v(pattern):
  """ Given a regex pattern, returns a validator method for that pattern """
  return lambda x: re.match(pattern, x)

def valid_input(prompt, default='', validator=(lambda x: x)):
  while True:
    try:
      inp = raw_input(prompt) or default
      if validator(inp):
        return inp.strip()
      print_warning('Invalid input, try again.')
    except Exception:
      print_warning('Invalid input, try again.')
      pass

def replace_variables(path, project_dir):
  path = path.replace('$(SRCROOT)', project_dir)
  path = path.replace('$(SOURCE_ROOT)', project_dir)
  return path

class PListFile(object):

  def __init__(self, path):
    self.path = path

    # Convert the pbxproj file to JSON
    pl_json_string = subprocess.check_output(
        ['plutil', '-convert', 'json', '-r', '-o', '-', path])
    self.pl_dict = json.loads(pl_json_string)

  def save(self):
    with io.open(self.path, 'w', encoding='utf-8') as f:
      f.write(unicode(json.dumps(self.pl_dict, ensure_ascii=False)))

    subprocess.check_call(['plutil', '-convert', 'xml1', self.path])

  def add_bundle_url_scheme(self, project_id):
    url_scheme_array = [ u'optly{0}'.format(project_id) ]

    optimizely_url_scheme_dict = {
      u'CFBundleURLName' : u'com.optimizely',
      u'CFBundleURLSchemes' : url_scheme_array
    }

    all_url_schemes = []
    if u'CFBundleURLTypes' in self.pl_dict:
      all_url_schemes = self.pl_dict[u'CFBundleURLTypes']

      for idx, val in enumerate(all_url_schemes):
        if u'CFBundleURLName' in val:
          if val[u'CFBundleURLName'] == u'com.optimizely':
            del all_url_schemes[idx]

    all_url_schemes.append( optimizely_url_scheme_dict )

    self.pl_dict[u'CFBundleURLTypes'] = all_url_schemes

class PBXFile(object):
  def __init__(self, path):
    self.path = path

    # Convert the pbxproj file to JSON
    pbx_json_string = subprocess.check_output(
        ['plutil', '-convert', 'json', '-r', '-o', '-', path])
    self.pbx_dict = json.loads(pbx_json_string)

    self.key_set = set()
    self._load_keys()

  def _load_keys(self):
    objects = self.pbx_dict['objects']
    for key in objects.keys():
      self.key_set.add(key)

  def _generate_key(self):
    """
    Generate a random 24-character HEX string that's not already in key_set,
    add it to key_set, and return it.
    """
    def random_key():
      return ''.join([hex(random.randrange(0, 16))[2:] for _ in range(24)]).upper()

    key = random_key()
    while key in self.key_set:
      key = random_key()

    self.key_set.add(key)
    return key

  def save(self):
    with io.open(self.path, 'w', encoding='utf-8') as f:
      f.write(unicode(json.dumps(self.pbx_dict, ensure_ascii=False)))

    subprocess.check_call(['plutil', '-convert', 'xml1', self.path])

  def get_all(self, isa, **kwargs):
    """ Returns all objects with matching isa and the kwargs """
    ret = {}
    objects = self.pbx_dict['objects']
    for k, v in objects.items():
      if v['isa'] == isa:
        match = True
        if len(kwargs):
          for match_key, match_val in kwargs.items():
            if v.get(match_key) != match_val:
              match = False

        if match:
          ret[k] = v

    return ret

  def get_by_key(self, key):
    """ Returns the object with the specified key """
    return self.pbx_dict['objects'][key]

  def add_framework(self, path, target, sourceTree, **kwargs):
    """
    Add the SDK framework with the specified path to the target if
    it's not already there.
    """

    # 1. Create or get the PBXFileReference
    file_refs = self.get_all('PBXFileReference', path=path).items()
    build_file_key, build_file_val = None, None

    if len(file_refs):
      file_ref_key, file_ref_val = file_refs[0]

      # Get the associated PBXBuildFile
      build_files = self.get_all('PBXBuildFile', fileRef=file_ref_key).items()
      if len(build_files):
        build_file_key, build_file_val = build_files[0]
    else:
      # Create a new PBXFileReference
      file_ref_key = self._generate_key()
      file_ref_val = {
        'isa': 'PBXFileReference',
        'path': path,
        'sourceTree': sourceTree,
        'name': os.path.basename(path),
        'lastKnownFileType': kwargs.get('lastKnownFileType', 'wrapper.framework'),
      }
      self.pbx_dict['objects'][file_ref_key] = file_ref_val

    if not build_file_key:
      # Create a new PBXBuildFile
      build_file_key = self._generate_key()
      build_file_val = {
          'isa': 'PBXBuildFile',
          'fileRef': file_ref_key,
      }
      self.pbx_dict['objects'][build_file_key] = build_file_val

    # 2. Add it to the Frameworks PBXGroup
    groups = self.get_all('PBXGroup', name='Frameworks').items()

    if len(groups):
      group_key, group_val = groups[0]
      group_children = group_val['children']
      if file_ref_key not in group_children:
        group_children.append(file_ref_key)

    # 3. Add it to the target
    for phase_key in target['buildPhases']:
      phase = self.get_by_key(phase_key)
      if phase['isa'] == 'PBXFrameworksBuildPhase':
        frameworks_build_phase = phase
        break
    else:
      die('Frameworks build phase not found in target {}'.format(target['name']))

    frameworks_build_phase_files = frameworks_build_phase['files']
    if build_file_key not in frameworks_build_phase_files:
      print_ok('Added {} to {}.'.format(file_ref_val['name'], target['name']))
      frameworks_build_phase_files.append(build_file_key)

  def get_build_configurations_for_target(self, target):
    """ Returns a dictionary of XCBuildConfigurations for the target. """
    ret = {}
    configuration_list = self.get_by_key(target['buildConfigurationList']) # XCConfigurationList
    build_configs = configuration_list['buildConfigurations'] # list
    for build_config_key in build_configs:
      ret[build_config_key] = self.get_by_key(build_config_key) # XCBuildConfiguration

    return ret

  def add_group_framework(self, path, target, **kwargs):
    self.add_framework(path, target, '<group>', **kwargs)

    # Update FRAMEWORK_SEARCH_PATHS
    for build_config in self.get_build_configurations_for_target(target).values():
      build_settings = build_config['buildSettings']
      if 'FRAMEWORK_SEARCH_PATHS' in build_settings:
        search_paths = build_settings['FRAMEWORK_SEARCH_PATHS']
      else:
        build_settings['FRAMEWORK_SEARCH_PATHS'] = search_paths = ['$(inherited)']

      search_path = '"$(SRCROOT)/{}"'.format(os.path.dirname(path))
      if search_path not in search_paths:
        search_paths.append(search_path)

  def add_sdk_framework(self, path, target, **kwargs):
    self.add_framework(path, target, 'SDKROOT', **kwargs)

  def add_script_build_phase(self, target, shellScript, **kwargs):
    build_phases = target['buildPhases']

    # Check if it already exists
    for build_phase_key in build_phases:
      phase = self.get_by_key(build_phase_key)
      if 'shellScript' in phase and phase['shellScript'] == shellScript:
        return

    phase_key = self._generate_key()
    phase_val = {
        'isa': 'PBXShellScriptBuildPhase',
        'buildActionMask': kwargs.get('buildActionMask', 2147483647),
        'files': kwargs.get('files', []),
        'inputPaths': kwargs.get('inputPaths', []),
        'outputPaths': kwargs.get('outputPaths', []),
        'runOnlyForDeploymentPostprocessing': kwargs.get('runOnlyForDeploymentPostprocessing', 0),
        'shellPath': kwargs.get('shellPath', '/bin/sh'),
        'shellScript': shellScript,
    }
    self.pbx_dict['objects'][phase_key] = phase_val

    build_phases.insert(0, phase_key)
    print_ok('Added script build phase to {}.'.format(target['name']))

  def add_linker_flag(self, target, flag):
    for build_config in self.get_build_configurations_for_target(target).values():
      build_settings = build_config['buildSettings']
      if 'OTHER_LDFLAGS' in build_settings:
        flags = build_settings['OTHER_LDFLAGS']
        if type(flags) == list:
          if not flag in flags:
            flags.append(flag)
        elif flags != flag:
          build_settings['OTHER_LDFLAGS'] = [flags, flag]
      else:
        build_settings['OTHER_LDFLAGS'] = [flag]

  def plist_file_path(self, target, project_dir):
    for build_config in self.get_build_configurations_for_target(target).values():
      build_settings = build_config['buildSettings']
      infoplist_file_path = build_settings['INFOPLIST_FILE']
      infoplist_file_path = replace_variables(infoplist_file_path, project_dir)
      if not os.path.isabs(infoplist_file_path):
        infoplist_file_path = os.path.join(project_dir, infoplist_file_path)

      if not os.path.exists(infoplist_file_path):
        print_fail('failed to find info plist file path')
        basefilename = os.path.basename(infoplist_file_path)
        infoplist_file_path = valid_input('What\'s your path info plist path, it starts with ' + basefilename)
      return infoplist_file_path

  def prefix_header_file_path(self, target, project_dir):
    for build_config in self.get_build_configurations_for_target(target).values():
      build_settings = build_config['buildSettings']
      prefix_header_path = build_settings.get('GCC_PREFIX_HEADER',None)
      if prefix_header_path is not None:
        prefix_header_path = replace_variables(prefix_header_path, project_dir)
        if not os.path.isabs(prefix_header_path):
          prefix_header_path = os.path.join(project_dir, prefix_header_path)

      return prefix_header_path

def main(project_path,project_id):
  print_cyan('\n=========================================')
  print_cyan('==== Optimizely iOS SDK Installation ====')
  print_cyan('=========================================\n')
  print_magenta('Please click on "Project Code" in your Optimizely project dashboard to find your Project ID.')
  project_id = project_id or valid_input('What is your Project ID?\n', '', v('^\d+$'))

  print_ok('Installing Optimizely Framework...')

  if not os.path.exists(FRAMEWORK_PATH):
    die('Framework not found at %s.' % FRAMEWORK_PATH)

  if not os.path.exists(SCRIPTS_DIR):
    die('Scripts directory not found at %s.' % SCRIPTS_DIR)

  project_path = project_path or valid_input('Path of .xcodeproj file: ')

  project_path = os.path.abspath(os.path.expanduser(project_path))
  if not os.path.exists(project_path):
    die('Project not found at %s.' % project_path)

  project_dir = os.path.dirname(project_path)

  pbx_path = os.path.join(project_path, 'project.pbxproj')
  if not os.path.exists(pbx_path):
    die('project.pbxproj not found in %s' % project_path)

  pbx = PBXFile(pbx_path)

  # Choose target
  targets = pbx.get_all('PBXNativeTarget')

  if len(targets) == 0:
    die('Project has no targets.')

  target_list = targets.values()
  if len(targets) == 1:
    target = target_list[0]
    print_ok('Adding Optimizely to target {}'.format(target['name']))
  else:
    print_question('Which target would you like to add Optimizely to?')
    for idx, target in enumerate(target_list):
      print_magenta('[{}] {}'.format(idx + 1, target['name']))

    target_idx = int(valid_input('Target number: ', '',
      lambda x: int(x) > 0 and int(x) <= len(target_list)))

    target = target_list[target_idx - 1]

  if not os.path.exists(pbx.plist_file_path(target, project_dir)):
    die('plist file not found in target')

  print_ok('Adding URL Scheme to Plist File')
  plist_file = PListFile(pbx.plist_file_path(target, project_dir))
  plist_file.add_bundle_url_scheme(project_id)
  plist_file.save()

  optimizely_dest = os.path.abspath(os.path.join(project_path, '..', os.path.splitext(os.path.basename(project_path))[0]))
  if not os.path.exists(optimizely_dest):
    optimizely_dest = os.path.abspath(os.path.join(project_path, '..'))

  user_dest = valid_input('Where should the Optimizely files be placed? [Default: {}]\n'.format(optimizely_dest),
                          optimizely_dest)
  optimizely_dest = os.path.abspath(os.path.expanduser(user_dest))

  if not os.path.isdir(optimizely_dest):
    die('Destination directory doesn\'t exist.')

  # Copy the Optimizely framework into the project directory
  optimizely_dest = os.path.join(optimizely_dest, 'Optimizely')
  rel_optimizely_dest = optimizely_dest[len(os.path.commonprefix([os.path.dirname(project_path), optimizely_dest])) + 1:]
  optimizely_framework_path = os.path.join(optimizely_dest, 'Optimizely.framework')
  rel_framework_path = os.path.join(rel_optimizely_dest, 'Optimizely.framework')

  try:
    os.mkdir(optimizely_dest)
  except OSError:
    pass

  if os.path.exists(optimizely_framework_path):
    shutil.rmtree(optimizely_framework_path)

  shutil.copytree(FRAMEWORK_PATH, optimizely_framework_path, symlinks=True)

  pbx.add_group_framework(rel_framework_path, target)

  pbx.add_linker_flag(target, '-ObjC')

  # Add the required frameworks to the target
  pbx.add_sdk_framework('System/Library/Frameworks/CFNetwork.framework', target)
  pbx.add_sdk_framework('System/Library/Frameworks/Foundation.framework', target)
  pbx.add_sdk_framework('System/Library/Frameworks/Foundation.framework', target)
  pbx.add_sdk_framework('System/Library/Frameworks/Security.framework', target)
  pbx.add_sdk_framework('System/Library/Frameworks/SystemConfiguration.framework', target)
  pbx.add_sdk_framework('System/Library/Frameworks/UIKit.framework', target)
  pbx.add_sdk_framework('usr/lib/libicucore.dylib', target, lastKnownFileType='compiled.mach-o.dylib')
  pbx.add_sdk_framework('usr/lib/libsqlite3.dylib', target, lastKnownFileType='compiled.mach-o.dylib')

  # Copy OptimizelyPrepareNibs.py script into the project
  shutil.copy(os.path.join(SCRIPTS_DIR, 'OptimizelyPrepareNibs.py'), optimizely_dest)

  # Add the prepare nibs script as a run phase
  pbx.add_script_build_phase(target, 'python "$SRCROOT/{}/OptimizelyPrepareNibs.py"'.format(rel_optimizely_dest))

  # Save the new pbxproj file
  pbx.save()

  print_ok('Almost done! Open your app delegate\'s implementation file and do the following:')

  prefix_header_path = pbx.prefix_header_file_path(target, project_dir)
  if prefix_header_path is None:
    print_magenta('1. Import Optimizely. \nAt the top of all files where you want to use Optimizely, add this line:')
  else:
    print_magenta('1. Import Optimizely. \nAdd this line to ' + prefix_header_path)

  print_blue('#import <Optimizely/Optimizely.h>\n')
  print_magenta('2. Add the following code to the beginning of application:didFinishLaunchingWithOptions:')
  print_blue('    #ifdef DEBUG')
  print_blue('    [Optimizely enableEditor];')
  print_blue('    #endif')
  print_blue('    [Optimizely startOptimizelyWithAPIToken:@"YOUR-API-TOKEN" launchOptions:launchOptions];')

  # TODO: Import Optimizely in the project's pch file.
  # TODO: Add the snippet to the App Delegate

  # TODO: save the old version of the pbxfile and allow reverting if we mess it up

  # TODO: if the project is under git, require a clean stage before starting,
  # and add the new files when done.

if __name__ == '__main__':
  project_path = None

  if len(sys.argv) == 2:
    project_path = sys.argv[1]

  main(project_path,None)
