# vim:fileencoding=utf-8:noet
from __future__ import (unicode_literals, division, absolute_import, print_function)

import json

from powerline.lib.url import urllib_read, urllib_urlencode
from powerline.lib.threaded import KwThreadedSegment
from powerline.segments import with_docstring


# XXX Warning: module name must not be equal to the segment name as long as this
# segment is imported into powerline.segments.common module.


# Weather condition code descriptions available at
# http://developer.yahoo.com/weather/#codes
weather_conditions_codes = {
	'tornado':                 'stormy',
	'tropical_storm':          'stormy',
	'hurricane':               'stormy',
	'severe_thunderstorms':    'stormy',
	'thunderstorms':           'stormy',
	'thunderstorm':            'stormy',
	'rain':                    'rainy' ,
	'mixed_rain_and_snow':     'rainy' ,
	'mixed_rain_and_sleet':    'rainy' ,
	'mixed_snow_and_sleet':    'snowy' ,
	'freezing_drizzle':        'rainy' ,
	'drizzle':                 'rainy' ,
	'freezing_rain':           'rainy' ,
	'showers':                 'rainy' ,
	'showers':                 'rainy' ,
	'snow_flurries':           'snowy' ,
	'light_snow_showers':      'snowy' ,
	'blowing_snow':            'snowy' ,
	'snow':                    'snowy' ,
	'hail':                    'snowy' ,
	'sleet':                   'snowy' ,
	'dust':                    'foggy' ,
	'fog':                     'foggy' ,
	'haze':                    'foggy' ,
	'smoky':                   'foggy' ,
	'blustery':                'windy' ,
	'windy':                   'windy' ,
	'cold':                    'day'   ,
	'clouds':                  'cloudy',
	'mostly_cloudy_night':     'cloudy',
	'mostly_cloudy_day':       'cloudy',
	'partly_cloudy_night':     'cloudy',
	'partly_cloudy_day':       'cloudy',
	'clear_night':             'night' ,
	'sun':                     'sunny' ,
	'fair_night':              'night' ,
	'fair_day':                'day'   ,
	'mixed_rain_and_hail':     'rainy' ,
	'hot':                     'sunny' ,
	'isolated_thunderstorms':  'stormy',
	'scattered_thunderstorms': 'stormy',
	'scattered_thunderstorms': 'stormy',
	'scattered_showers':       'rainy' ,
	'heavy_snow':              'snowy' ,
	'scattered_snow_showers':  'snowy' ,
	'heavy_snow':              'snowy' ,
	'partly_cloudy':           'cloudy',
	'thundershowers':          'rainy' ,
	'snow_showers':            'snowy' ,
	'isolated_thundershowers': 'rainy' ,
}
# ('day',    (25, 34)),
# ('rainy',  (5, 6, 8, 9, 10, 11, 12, 35, 40, 45, 47)),
# ('cloudy', (26, 27, 28, 29, 30, 44)),
# ('snowy',  (7, 13, 14, 15, 16, 17, 18, 41, 42, 43, 46)),
# ('stormy', (0, 1, 2, 3, 4, 37, 38, 39)),
# ('foggy',  (19, 20, 21, 22, 23)),
# ('sunny',  (32, 36)),
# ('night',  (31, 33))):
weather_conditions_icons = {
	'day':           'DAY',
	'blustery':      'WIND',
	'rainy':         'RAIN',
	'cloudy':        'CLOUDS',
	'snowy':         'SNOW',
	'stormy':        'STORM',
	'foggy':         'FOG',
	'sunny':         'SUN',
	'night':         'NIGHT',
	'windy':         'WINDY',
	'not_available': 'NA',
	'unknown':       'UKN',
}

temp_conversions = {
	'C': lambda temp: temp,
	'F': lambda temp: (temp * 9 / 5) + 32,
	'K': lambda temp: temp + 273.15,
}

# Note: there are also unicode characters for units: ℃, ℉ and  K
temp_units = {
	'C': '°C',
	'F': '°F',
	'K': 'K',
}


class WeatherSegment(KwThreadedSegment):
	interval = 600
	default_location = None
	location_urls = {}

	@staticmethod
	def key(location_query=None, **kwargs):
		return location_query

	def get_request_url(self, location_query):
		try:
		  return self.location_urls[location_query]
		except KeyError:
                        """
                           ld = json.loads(urllib_read('http://ipinfo.io'))
                           wthr = json.loads(urllib_read('http://api.openweathermap.org/data/2.5/weather?q={city},{country}&APPID=fdb4fd817c68a23bee0c9a015d73704f'.format(**ld)))
                           ld2 = json.loads(urllib_read('http://api.ipapi.com/70.126.90.220?access_key=7e6e7ae0d7e7b79d05bf3a002eb327cc'))
                           wthr = json.loads(urllib_read('http://api.openweathermap.org/data/2.5/weather?q={city},{region_code},{country_code}&APPID=fdb4fd817c68a23bee0c9a015d73704f'.format(**ld2)))
                           print(json.dumps(response, indent=2))
                        """
			if location_query is None:
                                location_data = json.loads(urllib_read('http://api.ipapi.com/70.126.90.220?access_key=7e6e7ae0d7e7b79d05bf3a002eb327cc'))
				location = ','.join((
					location_data['city'],
					location_data['country_code']
				))
				self.info('Location returned is {0}', location)
			else:
				location = location_query
			self.location_urls[location_query] = url = (
				'http://api.openweathermap.org/data/2.5/weather?q={city},{region_code},{country_code}&units=imperial&APPID=fdb4fd817c68a23bee0c9a015d73704f'.format(**location_data)
                        )
			return url

	def compute_state(self, location_query):
		url = self.get_request_url(location_query)
                print("+"*80, url)
		raw_response = urllib_read(url)
		if not raw_response:
			self.error('Failed to get response')
			return None
		response = json.loads(raw_response)
		try:
                        condition = response['main']
			condition_code = str(response['weather'][0]['main']).lower()
			temp = float(str(condition['temp']))
                        sunrise = int(str(response['sys']['sunrise']))
                        sunset = int(str(response['sys']['sunset']))
		except (KeyError, ValueError):
			self.exception('Weather query returned malformed or unexpected response: {0}', repr(raw_response))
			return None

		try:
                        condition_from_code = weather_conditions_codes[condition_code].lower()
                        if condition_from_code == 'clear':
                            if (time.time() > sunrise and time.time() < sunset):
                                icon_names = (weather_condition_codes['fair_day'],)
                            else:
                                icon_names = (weather_condition_codes['fair_night'],)
                        else:
			    icon_names = (condition_from_code,)
		except IndexError:
			if condition_code == 3200:
				icon_names = ('not_available',)
				self.warn('Weather is not available for location {0}', self.location)
			else:
				icon_names = ('unknown',)
				self.error('Unknown condition code: {0}', condition_code)

		return (temp, icon_names)

	def render_one(self, weather, icons=None, unit='C', temp_format=None, temp_coldest=-30, temp_hottest=40, **kwargs):
		if not weather:
			return None

		temp, icon_names = weather

		for icon_name in icon_names:
			if icons:
				if icon_name in icons:
					icon = icons[icon_name]
					break
		else:
			icon = weather_conditions_icons[icon_names[-1]]

		temp_format = temp_format or ('{temp:.0f}' + temp_units[unit])
		converted_temp = temp_conversions[unit](temp)
		if temp <= temp_coldest:
			gradient_level = 0
		elif temp >= temp_hottest:
			gradient_level = 100
		else:
			gradient_level = (temp - temp_coldest) * 100.0 / (temp_hottest - temp_coldest)
		groups = ['weather_condition_' + icon_name for icon_name in icon_names] + ['weather_conditions', 'weather']
		return [
			{
				'contents': icon + ' ',
				'highlight_groups': groups,
				'divider_highlight_group': 'background:divider',
			},
			{
				'contents': temp_format.format(temp=converted_temp),
				'highlight_groups': ['weather_temp_gradient', 'weather_temp', 'weather'],
				'divider_highlight_group': 'background:divider',
				'gradient_level': gradient_level,
			},
		]


weather = with_docstring(WeatherSegment(),
'''Return weather from Yahoo! Weather.

Uses GeoIP lookup from http://geoip.nekudo.com to automatically determine
your current location. This should be changed if you’re in a VPN or if your
IP address is registered at another location.

Returns a list of colorized icon and temperature segments depending on
weather conditions.

:param str unit:
	temperature unit, can be one of ``F``, ``C`` or ``K``
:param str location_query:
	location query for your current location, e.g. ``oslo, norway``
:param dict icons:
	dict for overriding default icons, e.g. ``{'heavy_snow' : u'❆'}``
:param str temp_format:
	format string, receives ``temp`` as an argument. Should also hold unit.
:param float temp_coldest:
	coldest temperature. Any temperature below it will have gradient level equal
	to zero.
:param float temp_hottest:
	hottest temperature. Any temperature above it will have gradient level equal
	to 100. Temperatures between ``temp_coldest`` and ``temp_hottest`` receive
	gradient level that indicates relative position in this interval
	(``100 * (cur-coldest) / (hottest-coldest)``).

Divider highlight group used: ``background:divider``.

Highlight groups used: ``weather_conditions`` or ``weather``, ``weather_temp_gradient`` (gradient) or ``weather``.
Also uses ``weather_conditions_{condition}`` for all weather conditions supported by Yahoo.
''')
