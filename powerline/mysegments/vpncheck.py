# vim:fileencoding=utf-8:noet
from __future__ import (unicode_literals, division, absolute_import, print_function)
from powerline.segments import Segment, with_docstring
from powerline.theme import requires_segment_info, requires_filesystem_watcher
import subprocess, os

def callvpncheck(*args, **kwargs):
    os.chdir('/home/fcavalcanti/work/sbin/cyberghost')
    args=['cyberghostvpn', '--status']
    with subprocess.Popen(args, stdout=subprocess.PIPE) as proc:
        changes = proc.stdout.read()
    retVal = "👻"
    if 'No VPN connections found' in changes.decode():
        retVal = None
    return (retVal)

@requires_filesystem_watcher
@requires_segment_info
class CustomSegment(Segment):
  divider_highlight_group = None

  def __call__(self, pl, segment_info, create_watcher):
    value = callvpncheck()
    if not value: # do not display if cyberghost is not running
        return None

    return [{
      #highlight_groups can be found in ~/.config/powerline/colorschemes/default.json
      #'highlight_groups': ['information:priority'],
      'highlight_groups': ['player'],
      'draw_soft_divider': True,
      'draw_hard_divider': True,
      'draw_inner_divider': False,
      #'divider_highlight_group': 'cwd:divider',
      'contents':value,
      }]

vpncheck = with_docstring(CustomSegment(), '''Return a custom segment.''')

