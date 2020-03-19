# vim:fileencoding=utf-8:noet
#/usr/bin/env python3
import time, enum

def time_format(time, format='%H:%M:%S.%u'):
	return time.strftime(format, time.localtime(time))

class UPower_Properties:
	'''https://upower.freedesktop.org/docs/Device.html'''
	class Types(enum.Enum):
		Unknown    = 0
		Line_Power = 1
		Battery    = 2
		Ups        = 3
		Monitor    = 4
		Mouse      = 5
		Keyboard   = 6
		Pda        = 7
		Phone      = 8

	class States(enum.Enum):
		Unknown          = 0
		Charging         = 1
		Discharging      = 2
		Empty            = 3
		Fully_charged    = 4
		Pending_charge   = 5
		Pending_discharge= 6

	class Technology(enum.Enum):
		Unknown                = 0
		Lithium_ion            = 1
		Lithium_polymer        = 2
		Lithium_iron_phosphate = 3
		Lead_acid              = 4
		Nickel_cadmium         = 5
		Nickel_metal_hydride   = 6

	class WarningLevel(enum.Enum):
		Unknown                    = 0
		None_                      = 1
		Discharging_only_for_UPSes = 2
		Low                        = 3
		Critical                   = 4
		Action                     = 5

	class BatteryLevel(enum.Enum):
		Unknown                         = 0
		No_coarse_reporting_level_None  = 1
		Low                             = 3
		Critical                        = 4
		Normal                          = 6
		High                            = 7
		Full                            = 8

	def __init__(self, devget):
		self.NativePath       = str(devget('NativePath'))                                    #s
		self.Vendor           = str(devget('Vendor'))                                        #s
		self.Model            = str(devget('Model'))                                         #s
		self.Serial           = str(devget('Serial'))                                        #s
		self.UpdateTime       = time.localtime(int(devget('UpdateTime')))                    #t
		self.Type             = UPower_Properties.Types(int(devget('Type')))                 #u
		self.PowerSupply      = bool(devget('PowerSupply'))                                  #b
		self.HasHistory       = bool(devget('HasHistory'))                                   #b
		self.HasStatistics    = bool(devget('HasStatistics'))                                #b
		self.Online           = bool(devget('Online'))                                       #b
		self.Energy           = float(devget('Energy'))                                      #d
		self.EnergyEmpty      = float(devget('EnergyEmpty'))                                 #d
		self.EnergyFull       = float(devget('EnergyFull'))                                  #d
		self.EnergyFullDesign = float(devget('EnergyFullDesign'))                            #d
		self.EnergyRate       = float(devget('EnergyRate'))                                  #d
		self.Voltage          = float(devget('Voltage'))                                     #d
		self.Luminosity       = float(devget('Luminosity'))                                  #d
		self.TimeToEmpty      = int(devget('TimeToEmpty'))                                   #x
		self.TimeToFull       = int(devget('TimeToFull'))                                    #x
		self.Percentage       = float(devget('Percentage'))                                  #d
		self.Temperature      = float(devget('Temperature'))                                 #d
		self.IsPresent        = bool(devget('IsPresent'))                                    #b
		self.State            = UPower_Properties.States(int(devget('State')))               #u
		self.IsRechargeable   = bool(devget('IsRechargeable'))                               #b
		self.Capacity         = float(devget('Capacity'))                                    #d
		self.Technology       = UPower_Properties.Technology(int(devget('Technology')))      #u
		self.WarningLevel     = UPower_Properties.WarningLevel(int(devget('WarningLevel')))  #u
		self.BatteryLevel     = UPower_Properties.BatteryLevel(int(devget('BatteryLevel')))  #u
		self.IconName         = str(devget('IconName'))                                      #s

	def __str__(self):
		attrs = vars(self)
		return('\n'.join('%s: %s' % item for item in attrs.items()))

	def flatten_battery(self):
		if self.EnergyFull > 0 and self.Energy > 0:
			return (self.Energy * 100.0 / self.EnergyFull)
		elif self.Percentage > 0:
			return self.Percentage
		else:
			return 0.0

def get_battery_status():
	import dbus
	bus = dbus.SystemBus()
	interface = 'org.freedesktop.UPower'
	up = bus.get_object(interface, '/'+interface.replace('.', '/'))
	devinterface = 'org.freedesktop.DBus.Properties'
	devtype_name = interface + '.Device'
	#devices = []
	for devpath in up.EnumerateDevices(dbus_interface=interface):
		dev = bus.get_object(interface, devpath)
		devget = lambda what: dev.Get(devtype_name, what, dbus_interface=devinterface)
		#Type = int(devget('Type'))
		up = UPower_Properties(devget)
		if up.Type != UPower_Properties.Types.Mouse: continue
		return up
		#print(up)
		#devices.append(devpath)
		#print('Using DBUS+UPower with {0}'.format(devpath))

def battery(format='{ac_state} {capacity:3.0%}', steps=5, use_array=False, gamify=False, full_heart='O', empty_heart='O', online='C', offline=' '):
	'''Return battery charge status.

	:param str format:
		Percent format in case gamify is False. Format arguments: ``ac_state``
		which is equal to either ``online`` or ``offline`` string arguments and
		``capacity`` which is equal to current battery capacity in interval [0,
		100].
	:param int steps:
		Number of discrete steps to show between 0% and 100% capacity if gamify
		is True.
	:param bool gamify:
		Measure in hearts (♥) instead of percentages. For full hearts
		``battery_full`` highlighting group is preferred, for empty hearts there
		is ``battery_empty``. ``battery_online`` or ``battery_offline`` group
		will be used for leading segment containing ``online`` or ``offline``
		argument contents.
	:param str full_heart:
		Heart displayed for “full” part of battery.
	:param str empty_heart:
		Heart displayed for “used” part of battery. It is also displayed using
		another gradient level and highlighting group, so it is OK for it to be
		the same as full_heart as long as necessary highlighting groups are
		defined.
	:param str online:
		Symbol used if computer is connected to a power supply.
	:param str offline:
		Symbol used if computer is not connected to a power supply.

	``battery_gradient`` and ``battery`` groups are used in any case, first is
	preferred.

	Highlight groups used: ``battery_full`` or ``battery_gradient`` (gradient) or ``battery``, ``battery_empty`` or ``battery_gradient`` (gradient) or ``battery``, ``battery_online`` or ``battery_ac_state`` or ``battery_gradient`` (gradient) or ``battery``, ``battery_offline`` or ``battery_ac_state`` or ``battery_gradient`` (gradient) or ``battery``.
	'''
	if use_array and not (steps == 5 or steps == 3):
		print('Use array requires steps to be 3, or 5.')
		return None
	try:
		up = get_battery_status()
		#print(up)
		capacity = up.flatten_battery()
		ac_powered = (up.State != UPower_Properties.States.Discharging)
	except NotImplementedError:
		print('Unable to get mouse battery status.')
		return None

	unicode_1_5 = ['📴', '⅕', '⅖', '⅗', '⅘', '🔋']
	unicode_1_3 = ['📴', '⅓', '⅔', '🔋']
	ret = []
	if gamify:
		denom = int(steps)
		numer = int(denom * capacity / 100)
		enumer = -(numer-denom)
		ret.append({
			'contents': online if ac_powered else offline,
			'draw_inner_divider': False,
			'highlight_groups': ['battery_online' if ac_powered else 'battery_offline', 'battery_ac_state', 'battery_gradient', 'battery'],
			'gradient_level': 0,
		})
		# Default
		full = full_heart * numer
		empty = empty_heart * (denom - numer)

		# 1/5
		if use_array:
			if steps == 5:
				full = unicode_1_5[numer]
				empty = unicode_1_5[enumer]
			if steps == 3:
				full = unicode_1_3[numer]
				empty = unicode_1_3[enumer]

		ret.append({
			'contents': full,
			'draw_inner_divider': False,
			'highlight_groups': ['battery_full', 'battery_gradient', 'battery'],
			# Using zero as “nothing to worry about”: it is least alert color.
			'gradient_level': 0,
		})
		ret.append({
			'contents': empty,
			'draw_inner_divider': False,
			'highlight_groups': ['battery_empty', 'battery_gradient', 'battery'],
			# Using a hundred as it is most alert color.
			'gradient_level': 100,
		})
	else:
		ret.append({
			'contents': format.format(ac_state=(online if ac_powered else offline), capacity=(capacity / 100.0)),
			'highlight_groups': ['battery_gradient', 'battery'],
			# Gradients are “least alert – most alert” by default, capacity has
			# the opposite semantics.
			'gradient_level': 100 - capacity,
		})
	return ret

if __name__ == '__main__':
    up = get_battery_status()
    print(up)
    value = battery('{ac_state} {capacity:3.0%}', 5, False, True, '💡', '⚡', '🔌', '📴')
    print(value)
