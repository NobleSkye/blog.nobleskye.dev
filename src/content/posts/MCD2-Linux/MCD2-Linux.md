---
title: MCD2-Linux
published: 2026-09-30
description: ''
image: ''
tags: [yapping]
category: ''
draft: false 
lang: ''
---


Minecraft dungeons 2 release at the time of writing this 24 hours ago, (1am pst 09.30.26)
I run fedora Linux on my main PC and it does not work even with proton and so just over an hour later people have made guides to get around the required spyware to launch the game (microsoft gaming services & microsoft store & microsoft 2015 c++ dotnet)

To keep things short as the guides are in the repos themselves:
https://gist.github.com/moxvallix/9f46c1341e196f797e838b885fe84b0c
https://github.com/Alextibtab/Dungeons2_linux_fix

These are the amazing repos that are for installing the correct xcurl.dll files for linux, as this is a tutorial for steamdeck i thought id make a script to then just run in terminal (if everything is default paths*) (works on my deck) to then just install everything without the need of a whole keyboard and mouse

![Spend 10 minutes doing the task manually vs spend 10 hours writing code to automate it](./image.png)

the script can be found at: [blog.nobleskye.dev/scripts/mcd2-steamdeck.sh](https://blog.nobleskye.dev/scripts/mcd2-steamdeck.sh) or can be ran by opening Konsole in desktop mode and running:

```sh
curl -fsSL https://blog.nobleskye.dev/scripts/mcd2-steamdeck.sh | bash
```

after running make sure to restart steam and then change the proton verson to be GE-proton