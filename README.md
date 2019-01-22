# Localization

This project contains translation files for Netdata. 

Under the root directory, we add a subdirectories with names taken from the abbreviations at https://gist.github.com/DavidWells/0881c21414e81431ed42.

Underneath each directory, the precise structure of the netdata/netdata project directory tree is used to override an existing markdown file. Of course the names of the files need to match as well. 

For example, to provide a Chinese translation on how to update Netdata, the file should be `zh_CN/packaging/installer/UPDATE.md`.

If any such directory is found, the HTML documentation at https://docs.netdata.cloud will also be available at `https://docs.netdata.cloud/[abbreviation]`, with only the translated files replaced. For the previous example, the translated page would be available at `https://docs.netdata.cloud/zh_CN/packaging/installer/UPDATE.md`.

Note that until travis CI is enabled for this project, users won't be able to see the produced HTML site until a build is triggered on the netdata/netdata project. 
