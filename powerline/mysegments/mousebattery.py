# vim:fileencoding=utf-8:noet
from __future__ import (unicode_literals, division, absolute_import, print_function)
from powerline.segments import Segment, with_docstring
from powerline.theme import requires_segment_info, requires_filesystem_watcher
import mysegments.upower as UP

@requires_filesystem_watcher
@requires_segment_info
class CustomSegment(Segment):
  divider_highlight_group = None

  def __call__(self, pl, segment_info, format, create_watcher):
    #def battery(format='{ac_state} {capacity:3.0%}', steps=5, use_array=False, gamify=False, full_heart='O', empty_heart='O', online='C', offline=' '):
    return UP.battery(format)

mousebatterycheck = with_docstring(CustomSegment(), '''Return a custom segment.''')
