
csml=getenv('CsMlDir');
pp=strcat(csml,pathsep);
pp=strcat(pp,csml);
pp=strcat(pp,'Main');
pp=strcat(pp,pathsep);
pp=strcat(pp,csml);
pp=strcat(pp,'CsMl');
pp=strcat(pp,pathsep);
pp=strcat(pp,csml);
pp=strcat(pp,'Adv');
pp=strcat(pp,pathsep);
path(pp,path);
clear csml;
clear pp;