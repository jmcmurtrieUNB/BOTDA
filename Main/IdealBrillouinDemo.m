%% Build ideal Lozentzian
f=10.8e9:0.1e6:11.2e9;
fb=10.9778e9;
fbL=10.9578e9;
fbH=10.9978e9;
delf=35e6;


bgL=(1+4*((f-fbL)./delf).^2).^-1;
bg=(1+4*((f-fb)./delf).^2).^-1;
bgH=(1+4*((f-fbH)./delf).^2).^-1;

figure
plot(f,bg,'g')
grid on
hold on
plot(f,bgL,'b')
plot(f,bgH,'r')
axis([10.85e9 11.15e9 0 1.25])

xline(fb);
xline(fbL);
xline(fbH);