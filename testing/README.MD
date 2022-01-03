This section stores the installation scripts of programs (divided by architectures) that do not work as expected.
These are minor bugs and can be fixed in a short time.
Once ready, these programs will be moved to the main section of this repository.

### How to test them
Replace "SAMPLE" at the line 2 with the name of the program you want to install:
	
    ARCH=$(uname -m)
    PROGRAM=SAMPLE
    wget https://raw.githubusercontent.com/ivan-hc/AM-application-manager/main/testing/$ARCH/$PROGRAM
    chmod a+x ./$PROGRAM
    sudo ./$PROGRAM
    
### How to remove them

    sudo /opt/$PROGRAM/remove
