@echo off
wmic /output: enum.html computersystem list brief /format:mof
wmic /append: enum.html useraccount list brief /Format:mof
wmic /append: enum.html group list brief /format:mof
wmic /append: enum.html process list brief /Format:mof
wmic /append: enum.html service list brief /Format:mof
wmic /append: enum.html nicconfig list /format:mof
wmic /append: enum.html volume list /format:mof
