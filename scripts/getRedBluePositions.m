function [Xred,Yred,Xblue,Yblue] = getRedBluePositions(I)

%celda deteccion
[BWred,maskedRGBImageRed] = createMaskRed(I);
[BWblue,maskedRGBImageBlue] = createMaskBlue(I);
[BWskin,maskedRGBImageSkin] = createMaskSkin(I);

%elimina objetos pequeños
BWskinclean=bwareaopen(BWskin, 1000);
%completa tuneles en la piel
BWskincleanfilled=imfill(BWskinclean, 'holes');

%solo mantemos marcadores "dentro" de la piel
BWred =BWred  & BWskincleanfilled;
BWblue=BWblue & BWskincleanfilled;

%visualizacion de limpieza
%imshow(BWskincleanfilled)

%visualizaremos las 3 mascaras
Ideteccion=zeros([size(BWred,1) size(BWred,2)], 'uint8');
%la piel es blanca (255 en todos los canales)
Ideteccion(:,:,1)=255*BWskincleanfilled;
Ideteccion(:,:,2)=255*BWskincleanfilled;
Ideteccion(:,:,3)=255*BWskincleanfilled;

Ir=Ideteccion(:,:,1);
Ig=Ideteccion(:,:,2);
Ib=Ideteccion(:,:,3);

%el punto rojo sera rojo (255,0,0)
Ir(BWred)=255;
Ig(BWred)=0;
Ib(BWred)=0;

%el punto azul sera azul (0,0,255)
Ir(BWblue)=0;
Ig(BWblue)=0;
Ib(BWblue)=255;

%agrupamos todo en una imagen rgb
Ideteccion(:,:,1)=Ir;
Ideteccion(:,:,2)=Ig;
Ideteccion(:,:,3)=Ib;

%imshow(Ideteccion);

%calculo del vector de orientacion
statsred = regionprops(BWred,'centroid');
Xred=statsred(1).Centroid(1);
Yred=statsred(1).Centroid(2);

%origen lo tomamos como el azul
statsblue = regionprops(BWblue,'centroid');
Xblue=statsblue(1).Centroid(1);
Yblue=statsblue(1).Centroid(2);

end