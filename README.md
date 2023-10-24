#  Rsyncer

<p align="center">
  <img src="https://github.com/depsypher/Rsyncer/blob/main/RsyncerDock.png" width="150" height="150" />
</p>

This simple app just does an rsync copy of any file you drop on it to the directory you've chosen.

## Motivation 
Sometime after I updated to MacOS Ventura I started noticing that videos I moved to my NAS were glitching, 
some of them completely unplayable.

After a while I realized anything I dragged and dropped via the Finder was getting corrupted. I looked online and found some complaints in obscure forums here and there but nothing conclusively determining the cause. I waited and waited for Apple to fix what seemed like a heinous bug, but update after update the bug continued to plague me. So now that we're on Sonoma and it's still an issue, I decided to build an app to work around the problem.

I noticed that drag and drop via the Finder using samba under the hood caused the problem somewhat reliably (for large files), but copying via rsync in the terminal never did any file corruption. So seems like a bug in samba. I tried downgrading the samba version and fiddling with it's settings, but nothing helped. So, since all I want is to be able to drag a file to my NAS and have it not be silently corrupted, that's what this app does. 

<img src="https://github.com/depsypher/Rsyncer/raw/main/RsyncerApp.png" />
