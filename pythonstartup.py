def history():
  import readline
  for i in range(1, readline.get_current_history_length()+1):
    print("%3d %s" % (i, readline.get_history_item(i)))
