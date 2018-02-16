# LinuxConfigureFiles

1、don't run as root

2、dont't run by `sh install.sh`
`./install.sh`

https://stackoverflow.com/questions/670191/getting-a-source-not-found-error-when-using-source-in-a-bash-script

*install_bash.sh: 3: install_bash.sh: source: not found*
In Ubuntu if you execute the script with sh scriptname.sh you get this problem.
Try executing the script with ./scriptname.sh instead.
