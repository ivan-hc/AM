
       ___      .______   .______   .___  ___.      ___      .__   __. 
      /   \     |   _  \  |   _  \  |   \/   |     /   \     |  \ |  | 
     /  ^  \    |  |_)  | |  |_)  | |  \  /  |    /  ^  \    |   \|  | 
    /  /_\  \   |   ___/  |   ___/  |  |\/|  |   /  /_\  \   |  . `  | 
   /  _____  \  |  |      |  |      |  |  |  |  /  _____  \  |  |\   | 
  /__/     \__\ | _|      | _|      |__|  |__| /__/     \__\ |__| \__| 

 "AppMan" (ie Application Manager) is a copy of "AM" aimed to install all the
 applications managed locally, so without root privileges:
 
 - all the apps are installed in ~/.opt (you can change this path only once by
   using the "--apps-path" option, available since the 3.0.6.1 release);
 - all the launchers are created in ~/.local/share/applications;
 - all the apps are linked in ~/.local/bin
 
 NOTE, to made all the apps work, you have to enable the ~/.local/bin $PATH,
 you can do that by adding the following line to your ~/.bashrc file:
 
      export PATH=$PATH:$(xdg-user-dir USER)/.local/bin
            
 All AppMan does is to convert all the installation scripts for "AM" (that 
 normally must be executed with ROOT privileges) in normal scripts that can 
 manage apps in the local folder of the current user.
 This allows more users to customize their own desktop's configuration, 
 being each application available only for that user ("AM" instead made them
 all available for everybody, being them installed in /opt and linked to an 
 existing system's $PATH).
 
 SITE: https://github.com/ivan-hc/AppMan
