original=imread('Mario512.png','png');


verga=rgb2ycbcr(original);
nueva=ycbcr2rgb(verga);

for i=1:100000
    verga=rgb2ycbcr(nueva);
    nueva=ycbcr2rgb(verga);
end

figure('Name','Original');
image(original);
figure('Name','Super Retocada');
image(nueva);

psnr(original,nueva)