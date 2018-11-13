Yet Another Forensic Tool (YAFORTO)
Welcome the starting part of the Yet another Forensic tool script (YAFORTO). This repository is the ‘in development’ new home of the Script .It will also be where the finished script will be published and referenced.  Having earned the Giac Certified Forensic Engineer certification, I saw an opportunity to combine some initial steps taken, and fulfill a need to remotely capture information. This is part of my paper that is being developed for SANS.org which will reference this location also.  
The script is being written in PowerShell. I must acknowledge the goal of the script is to use other Forensic engineer’s windows executables to:

-Gather a remote forensic triage image
-Gather a remote Memory dump
-Ask the Forensic examiner about what type of investigation this is
-Use that information to comb through the forensic image and memory dump to give the examiner some starting information. 

This script is not meant to replace any tools. Rather, it’s more designed for the growing avenue of Forensic response inside a Incident response framework. 
Ideally the forensic analyst would take a full disk image, a full memory image, and bring both into a Forensic Platform for investigation using multiple tools. So the use of this tool is to help the forensic examiner determine if the effort and time needed matches the initial information found. 
