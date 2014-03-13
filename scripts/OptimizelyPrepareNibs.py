import codecs
import fnmatch
import os
import sys
import xml.dom.minidom
from xml.dom import Node

global_optimizely_ids = set()

OPTIMIZELY_ID_KEY_PATH = "optimizelyId"

def full_paths(root_dir, matches):
  return map(lambda item: os.path.join(root_dir, item), matches)

def get_storyboard_paths(project_dir):
  storyboards = []
  for root, dirs, files in os.walk(project_dir):
    matches = fnmatch.filter(files, "*.storyboard")
    storyboards.extend(full_paths(root, matches))

  return storyboards

def get_xib_paths(project_dir):
  xibs = []
  for root, dirs, files in os.walk(project_dir):
    matches = fnmatch.filter(files, "*.xib")
    xibs.extend(full_paths(root, matches))

  return xibs

def generate_optimizely_id(path, cls, view_id):
  new_oid = "_%s-%s-%s" % (os.path.splitext(os.path.basename(path))[0], cls, view_id)

  if new_oid in global_optimizely_ids:
    suffix = 2
    while ("%s-%d" % (new_oid, suffix)) in global_optimizely_ids:
      suffix += 1
    return "%s-%d" % (new_oid, suffix)
  else:
    return new_oid

class Storyboard(object):
  RUNTIME_ATTR_TAG_NAME = "userDefinedRuntimeAttribute"
  RUNTIME_ATTRS_TAG_NAME = "userDefinedRuntimeAttributes"
  view_tags = ["activityIndicatorView",
               "button",
               "datePicker",
               "label",
               "imageView",
               "pickerView",
               "progressView",
               "textField",
               "textView",
               "segmentedControl",
               "slider",
               "stepper",
               "switch",
               "tableView",
               "tableViewCell",
               "tableViewCellContentView",
               "view"]

  def __init__(self, path):
    print "Processing %s..." % path
    self.views = [] # all views
    self.new_views = [] # views without an Optimizely ID set
    self.dom = xml.dom.minidom.parse(path)
    for tag in Storyboard.view_tags:
      self.views.extend(self.dom.getElementsByTagName(tag))

    for view in self.views:
      oid = self.get_optimizely_id(view)
      if oid is not None:
        # View already has an Optimizely ID. Make sure it's unique:
        if oid in global_optimizely_ids:
          # TODO: when views are copy&pasted in Interface Builder, they'll have the same optimizelyID
          # but different Object IDs. Figure out which one is the original and which one is the duplicate
          # by comparing the suffix of the optimizelyID and Object ID. *Don't* change the optimizelyID
          # of the original, *do* change the optimizelyID of the duplicate. Right now, it's arbitrary
          # which one gets renamed.
          self.new_views.append(view)
        else:
          global_optimizely_ids.add(oid)
      else:
        # View needs an Optimizely ID
        self.new_views.append(view)

    for view in self.new_views:
      new_oid = generate_optimizely_id(path, view.tagName, view.getAttribute('id'))
      self.set_optimizely_id(view, new_oid)
    
    if self.new_views: # don't save if nothing changed
      # TODO preserve as much of the original file as possible to minimize diffs (i.e. attr ordering)
      tmp_file = path + ".tmp"
      try:
        f = codecs.open(tmp_file, "w", "utf-8")
        self.dom.writexml(f, encoding="utf-8")
      except Exception as e:
        os.remove(tmp_file)
        raise e
      else:
        # replace storyboard with tmp_file
        os.rename(tmp_file, path)
      finally:
        f.close()

  def get_runtime_attrs_element(self, view):
    ''' Returns the runtime attributes element for view, or None if none exists. '''
    for element in view.childNodes:
      if element.nodeType == Node.ELEMENT_NODE and element.tagName == Storyboard.RUNTIME_ATTRS_TAG_NAME:
        return element

  def get_optimizely_id_element(self, view):
    ''' Returns the runtime attribute element specifying the Optimizely ID, or None. '''
    runtime_attrs_element = self.get_runtime_attrs_element(view)
    if runtime_attrs_element is None:
      return

    for runtime_attr in runtime_attrs_element.getElementsByTagName(Storyboard.RUNTIME_ATTR_TAG_NAME):
      if runtime_attr.getAttribute("keyPath") == OPTIMIZELY_ID_KEY_PATH:
        return runtime_attr

  def get_optimizely_id(self, view):
    ''' Returns the Optimizely ID for the view, or None if one isn't set. '''
    runtime_attr_element = self.get_optimizely_id_element(view)
    if runtime_attr_element:
      return runtime_attr_element.getAttribute("value")

  def set_optimizely_id(self, view, oid):
    ''' Sets a unique Optimizely ID on the view. '''
    runtime_attrs = self.get_runtime_attrs_element(view)
    if runtime_attrs is None:
      runtime_attrs = self.dom.createElement(Storyboard.RUNTIME_ATTRS_TAG_NAME)
      view.appendChild(runtime_attrs)

    oid_tag = self.get_optimizely_id_element(view)
    if oid_tag is None:
      oid_tag = self.dom.createElement(Storyboard.RUNTIME_ATTR_TAG_NAME)
      oid_tag.setAttribute("keyPath", OPTIMIZELY_ID_KEY_PATH)
      oid_tag.setAttribute("value", oid)
      oid_tag.setAttribute("type", "string")
      runtime_attrs.appendChild(oid_tag)
    else:
      print 'setting oid on existing tag:   new: %s,   old: %s' % (oid, oid_tag.getAttribute("value"))
      oid_tag.setAttribute("value", oid)

class Xib(object):
  view_classes = [
      'IBUIActivityIndicatorView',
      'IBUIButton',
      'IBUICollectionView',
      'IBUIImageView',
      'IBUILabel',
      'IBUIProgressView',
      'IBUIScrollView',
      'IBUISegmentedControl',
      'IBUISlider',
      'IBUIStepper',
      'IBUISwitch',
      'IBUITableView',
      'IBUITableViewCell',
      'IBUITextField',
      'IBUITextView',
      'IBUIView',
      ]

  def get_elements(self, tag='object', root=None, **attrs):
    if root is None:
      root = self.dom

    results = []
    for element in root.getElementsByTagName(tag):
      match = True

      for attr_key, attr_val in attrs.items():
        if element.getAttribute(attr_key) != attr_val:
          match = False
          break

      if match:
        results.append(element)

    return results

  def get_element(self, *args, **attrs):
    try:
      return self.get_elements(*args, **attrs)[0]
    except IndexError:
      return None

  def __init__(self, path):
    print 'Processing %s...' % path

    self.views = [] # all views
    self.optimizely_ids = {} # xib view id -> optimizely id
    self.object_ids = {} # xib view id -> IBObjectRecord's objectID
    self.new_views = [] # views without an Optimizely ID set
    self.dom = xml.dom.minidom.parse(path)

    objects = self.dom.getElementsByTagName('object')

    els = self.get_elements
    el = self.get_element

    # Get all views
    self.views = filter(
        lambda obj: obj.getAttribute('class') in Xib.view_classes,
        objects)

    # Get all object ids
    for record in els(**{ 'class': 'IBObjectRecord' }):
      ref = el('reference', root=record, key='object')
      if ref:
        self.object_ids[ref.getAttribute('ref')] = el('int', root=record, key='objectID').firstChild.nodeValue

    # Get all currently defined Optimizely IDs
    for placeholder in els(**{ 'class': 'IBUIUserDefinedRuntimeAttributesPlaceholder' }):
      view_id = el('reference', root=placeholder, key='object').getAttribute('ref')
      array = el('array', root=placeholder, key='userDefinedRuntimeAttributes')
      view_attrs = els(root=array, **{ 'class': 'IBUserDefinedRuntimeAttribute' })

      try:
        optimizely_id_attr = filter(
            lambda attr: el('string', root=attr, key='keyPath').firstChild.nodeValue == OPTIMIZELY_ID_KEY_PATH,
            view_attrs)[0]
      except IndexError:
        continue

      optimizely_id = el('string', root=optimizely_id_attr, key='value').firstChild.nodeValue

      if optimizely_id in global_optimizely_ids:
        self.new_views.append(view_id)
      else:
        global_optimizely_ids.add(optimizely_id)
        self.optimizely_ids[view_id] = optimizely_id

    for view in self.views:
      if not self.get_optimizely_id(view):
        self.new_views.append(view.getAttribute('id'))

    if len(self.new_views) == 0:
      return # bail if there are no views to add an ID to.

    for view_id in self.new_views:
      self.set_optimizely_id(view_id, generate_optimizely_id(path, 'view', view_id))

    # TODO preserve as much of the original file as possible to minimize diffs (i.e. attr ordering)
    tmp_file = path + ".tmp"
    try:
      print 'Saving %s...' % tmp_file
      f = codecs.open(tmp_file, "w", "utf-8")
      self.dom.writexml(f, encoding="utf-8")
    except Exception as e:
      os.remove(tmp_file)
      raise e
    else:
      # replace storyboard with tmp_file
      os.rename(tmp_file, path)
    finally:
      f.close()

  def get_optimizely_id(self, view):
    ''' Returns the Optimizely ID for the view, or None if one isn't set. '''
    view_id = view.getAttribute('id')
    return self.optimizely_ids.get(view_id)

  def set_optimizely_id(self, view_id, oid):
    self.optimizely_ids[view_id] = oid

    try:
      object_id = self.object_ids[view_id]
    except KeyError:
      return

    placeholder_key = '{}.IBAttributePlaceholdersKey'.format(object_id)

    ib_doc_objects = self.get_element(** { 'class': 'IBObjectContainer', 'key': 'IBDocument.Objects' })
    flattened_props = self.get_element(
        'dictionary',
        root=ib_doc_objects,
        **{ 'class': 'NSMutableDictionary', 'key': 'flattenedProperties' })

    if not flattened_props:
      flattened_props = self.get_element(
          root=ib_doc_objects,
          ** { 'class': 'NSMutableDictionary', 'key': 'flattenedProperties' })

    placeholder_dict = self.get_element('object', root=flattened_props,
        **{ 'class': 'NSMutableDictionary', 'key': placeholder_key })

    if not placeholder_dict:
      print 'Creating placeholder %s' % object_id
      placeholder_dict = self.dom.createElement('object')
      placeholder_dict.setAttribute('class', 'NSMutableDictionary')
      placeholder_dict.setAttribute('key', placeholder_key)
      flattened_props.appendChild(placeholder_dict)

    runtime_attrs_placeholder = self.get_element(root=placeholder_dict, 
        **{ 'class': 'IBUIUserDefinedRuntimeAttributesPlaceholder' })
    if not runtime_attrs_placeholder:
      runtime_attrs_string = self.dom.createElement('string')
      runtime_attrs_string.setAttribute('key', 'NS.key.0')
      runtime_attrs_string.appendChild(self.dom.createTextNode('IBUserDefinedRuntimeAttributesPlaceholderName'))
      placeholder_dict.appendChild(runtime_attrs_string)

      runtime_attrs_placeholder = self.dom.createElement('object')
      runtime_attrs_placeholder.setAttribute('class', 'IBUIUserDefinedRuntimeAttributesPlaceholder')
      runtime_attrs_placeholder.setAttribute('key', 'NS.object.0')
      placeholder_dict.appendChild(runtime_attrs_placeholder)

    if not self.get_element('string', root=runtime_attrs_placeholder, key='name'):
      name_string = self.dom.createElement('string')
      name_string.setAttribute('key', 'name')
      name_string.appendChild(self.dom.createTextNode('IBUserDefinedRuntimeAttributesPlaceholderName'))
      runtime_attrs_placeholder.appendChild(name_string)

    if not self.get_element('reference', root=runtime_attrs_placeholder, key='object', ref=view_id):
      reference = self.dom.createElement('reference')
      reference.setAttribute('key', 'object')
      reference.setAttribute('ref', view_id)
      runtime_attrs_placeholder.appendChild(reference)

    attrs_array = self.get_element('array', root=runtime_attrs_placeholder, key='userDefinedRuntimeAttributes')
    if not attrs_array:
      attrs_array = self.dom.createElement('array')
      attrs_array.setAttribute('key', 'userDefinedRuntimeAttributes')
      runtime_attrs_placeholder.appendChild(attrs_array)

    oid_elements = filter(
        lambda el: self.get_element('string', root=el, key='keyPath').firstChild.nodeValue == OPTIMIZELY_ID_KEY_PATH,
        self.get_elements(root=attrs_array, **{ 'class': 'IBUserDefinedRuntimeAttribute' }))

    if oid_elements:
      oid_element = oid_elements[0]
      oid_value = self.get_element('string', root=oid_element, key='value')
      oid_value.firstChild.nodeValue = oid
    else:
      oid_element = self.dom.createElement('object')
      oid_element.setAttribute('class', 'IBUserDefinedRuntimeAttribute')

      type_id = self.dom.createElement('string')
      type_id.setAttribute('key', 'typeIdentifier')
      type_id.appendChild(self.dom.createTextNode('com.apple.InterfaceBuilder.userDefinedRuntimeAttributeType.string'))
      oid_element.appendChild(type_id)

      key_path = self.dom.createElement('string')
      key_path.setAttribute('key', 'keyPath')
      key_path.appendChild(self.dom.createTextNode(OPTIMIZELY_ID_KEY_PATH))
      oid_element.appendChild(key_path)

      oid_value = self.dom.createElement('string')
      oid_value.setAttribute('key', 'value')
      oid_value.appendChild(self.dom.createTextNode(oid))
      oid_element.appendChild(oid_value)

      attrs_array.appendChild(oid_element)

    #import pdb; pdb.set_trace()

if __name__ == "__main__":
  try:
    project_dir = os.environ["SRCROOT"]
  except KeyError:
    sys.exit("No SRCROOT defined in environment, can't continue.")

  # TODO - the storyboard/xib file's versioning must be set
  # with deployment iOS5.0+ and Xcode 4.3+ to support user defined
  # runtime attributes.

  print "Looking for all storyboard files in %s..." % project_dir
  storyboards = get_storyboard_paths(project_dir)
  for path in storyboards:
    storyboard = Storyboard(path)

  print "Looking for all xib files in %s..." % project_dir
  xibs = get_xib_paths(project_dir)
  for path in xibs:
    xib = Xib(path)
