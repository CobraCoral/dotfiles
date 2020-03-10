# vim:fileencoding=utf-8:noet
from __future__ import (unicode_literals, division, absolute_import, print_function)
from powerline.segments import Segment, with_docstring
from powerline.theme import requires_segment_info, requires_filesystem_watcher
import subprocess, os

def callgitcheck(*args, **kwargs):
    os.chdir('/home/fcavalcanti/work')
    args=['/home/fcavalcanti/work/sbin/gitcheck.sh']
    with subprocess.Popen(args, stdout=subprocess.PIPE) as proc:
        changes = proc.stdout.read()
    retVal = "🚧"
    if not len(changes):
        retVal = None
    return (retVal)

@requires_filesystem_watcher
@requires_segment_info
class CustomSegment(Segment):
  divider_highlight_group = None

  def __call__(self, pl, segment_info, create_watcher):
    value = callgitcheck()
    if not value: # do not display if everything is committed in git
        return None

    return [{
      #highlight_groups can be found in ~/.config/powerline/colorschemes/default.json
      'highlight_groups': ['critical:failure'],
      'draw_soft_divider': False,
      'draw_hard_divider': False,
      'draw_inner_divider': False,
      'divider_highlight_group': 'cwd:divider',
      'contents':value,
      }]

gitcheck = with_docstring(CustomSegment(), '''Return a custom segment.''')

