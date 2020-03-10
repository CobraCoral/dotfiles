# vim:fileencoding=utf-8:noet
from __future__ import (unicode_literals, division, absolute_import, print_function)
from powerline.segments import Segment, with_docstring
from powerline.theme import requires_segment_info, requires_filesystem_watcher
import json, time, datetime, calendar, functools

def getStudyValue(*args, **kwargs):
    #print(args, kwargs)
    with open('/home/fcavalcanti/work/dotfiles/powerline/mysegments/studyschedule.json') as f:
        data = json.load(f)
    
    for weekday, times in data['days'].items():
        #print(weekday, times)
        if weekday != kwargs['weekday']:
            continue
        #print(weekday, times)
        for hour, action in times.items():
            #print(hour, kwargs['hour'])
            if int(hour) == int(kwargs['hour']):
                return(hour, action)
    return (kwargs['hour'], 'Free')

@requires_filesystem_watcher
@requires_segment_info
class CustomSegment(Segment):
  divider_highlight_group = None

  def __call__(self, pl, segment_info, create_watcher):
    now = datetime.datetime.now()
    #print(getStudyValue(weekday=calendar.day_name[now.weekday()], hour=now.strftime('%H')))
    value = '%s: %s'%(getStudyValue(weekday=calendar.day_name[now.weekday()], hour=now.strftime('%H')))
    return [{
      'contents': value,
      #'highlight_groups': ['information:regular'],
	'highlight_groups': ['information:highlighted'],
      #'highlight_groups': ['player'],
      'draw_soft_divider': True,
      'draw_hard_dividier': True,
      'draw_inner_dividier': False,
      #'divider_highlight_group': 'cwd:divider', 
      }]

study_schedule = with_docstring(CustomSegment(), '''Return a custom segment.''')

#now = datetime.datetime.now()
#print(getStudyValue(weekday=calendar.day_name[now.weekday()], hour=now.strftime('%H')))

