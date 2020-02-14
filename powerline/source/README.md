These are all the changes I have made so wthr.py works properly given that yahoo API, and other APIs used by the original code were not working anymore.

Being that I was already changing it, I proceeded on making some modifications to my own taste.

This file needs to replace the proper file in the proper python package:

- /usr/local/lib/python2.7/dist-packages/powerline_status-2.7.dev9999+git.b0ea99430c00713279f7e3c37aa6c63a85b68ad5-py2.7.egg/powerline/segments/common/wthr.py
    Or
- /usr/local/lib/python3.6/dist-packages/powerline_status-2.7.dev9999_git.b_b0ea99430c00713279f7e3c37aa6c63a85b68ad5_-py3.6.egg/powerline/segments/common/wthr.py

I have also changed net.py so I can add my own icons to HOST...
