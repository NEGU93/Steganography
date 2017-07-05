%stegImgEncoder
%Esteganografía en imágenes. TP Final ASSD.
%   Codifica el mensaje indicado "stegString" en una imagen que se
%   encuentra en el path "imgPath"
% La funcion devuelve "myFinalEncodedImg", la imagen con "stegString"
% esteganografiado en ella.

    %--COSAS QUE SE PROBARON
        %Se probaron diferentes tamaños de foto: cuadrados, potencias de dos y completamente random
    %--COSAS QUE NO SE PROBARON
        %Que pasa si la imagen original es mas chica que un cuadrado de 8x8
        %Si el mensaje se codifica bien

    clc
    clear all
    close all
    
    fotoAUsar='PapaNoel.jpg';
    imgPath = 'EncodedPapaNoel.jpg';
    agregoOffset = true;
    REPETITION=4;
    BLOCK_SIZE = 8;                 %(Es en cuantos de la DCT)
    quality = 80;
    
    spreadSpectrum=false;
    
    CODIFICAR=true;
    
    DECODIFICAR=true;
    
    
    if spreadSpectrum
        load('SpectrumCodification.mat');
    end
    
    if CODIFICAR
    
    %---Mensaje a esteganografiar---
    stegString='Me gusta el helado';
    stegStringBits = zeros(1, length(stegString)*8*REPETITION);
    asciiString = unicode2native(stegString);
    %smartIndex
    stegStringIndex = 1;      %inicializado en el comienzo
    STEG_BIT=1;     %bit en el cual se aplica la esteganografía

    %Paso el string a un arreglo de bits
    for n=0:length(asciiString) - 1
       individualCharacter = asciiString(n+1);
       for bit=8:-1:1
          myBit = bitget(cast(individualCharacter,'uint8'),bit);
          for rep=1:REPETITION
              stegStringBits(n*8*REPETITION+(8-bit)*REPETITION+rep)=myBit;
          end
        end
    end

    BLOCK_ROWS = 8;
    BLOCK_COLS = 8;
    
    end

    %------Tablas de cuantización-------

    Q_50_C = [
        17,  18,  24,  47,  99,  99,  99,  99
        18,  21,  26,  66,  99,  99,  99,  99
        24,  26,  56,  99,  99,  99,  99,  99
        47,  66,  99,  99,  99,  99,  99,  99
        99,  99,  99,  99,  99,  99,  99,  99
        99,  99,  99,  99,  99,  99,  99,  99
        99,  99,  99,  99,  99,  99,  99,  99
        99,  99,  99,  99,  99,  99,  99,  99 ];
    Q_50_Y = [
        16,  11,  10,  16,  24,  40,  51,  61
        12,  12,  14,  19,  26,  58,  60,  55
        14,  13,  16,  24,  40,  57,  69,  56
        14,  17,  22,  29,  51,  87,  80,  62
        18,  22,  37,  56,  68, 109, 103,  77
        24,  35,  55,  64,  81, 104, 113,  92
        49,  64,  78,  87, 103, 121, 120, 101
        72,  92,  95,  98, 112, 100, 103,  99 ];	%50

    Q_60_C = [
        14,  14,  19,  38,  79,  79,  79,  79
        14,  17,  21,  53,  79,  79,  79,  79
        19,  21,  45,  79,  79,  79,  79,  79
        38,  53,  79,  79,  79,  79,  79,  79
        79,  79,  79,  79,  79,  79,  79,  79
        79,  79,  79,  79,  79,  79,  79,  79
        79,  79,  79,  79,  79,  79,  79,  79
        79,  79,  79,  79,  79,  79,  79,  79 ];
    Q_60_Y = [
        13,   9,   8,  13,  19,  32,  41,  49
        10,  10,  11,  15,  21,  46,  48,  44
        11,  10,  13,  19,  32,  46,  55,  45
        11,  14,  18,  23,  41,  70,  64,  50
        14,  18,  30,  45,  54,  87,  82,  62
        19,  28,  44,  51,  65,  83,  90,  74
        39,  51,  62,  70,  82,  97,  96,  81
        58,  74,  76,  78,  90,  80,  82,  79 ];	%60

    Q_70_C = [
        10,  11,  14,  28,  59,  59,  59,  59
        11,  13,  16,  40,  59,  59,  59,  59
        14,  16,  34,  59,  59,  59,  59,  59
        28,  40,  59,  59,  59,  59,  59,  59
        59,  59,  59,  59,  59,  59,  59,  59
        59,  59,  59,  59,  59,  59,  59,  59
        59,  59,  59,  59,  59,  59,  59,  59
        59,  59,  59,  59,  59,  59,  59,  59 ];
    Q_70_Y = [
        10,   7,   6,  10,  14,  24,  31,  37
         7,   7,   8,  11,  16,  35,  36,  33
         8,   8,  10,  14,  24,  34,  41,  34
         8,  10,  13,  17,  31,  52,  48,  37
        11,  13,  22,  34,  41,  65,  62,  46
        14,  21,  33,  38,  49,  62,  68,  55
        29,  38,  47,  52,  62,  73,  72,  61
        43,  55,  57,  59,  67,  60,  62,  59 ];  %70

    Q_75_C = [
         9,   9,  12,  24,  50,  50,  50,  50
         9,  11,  13,  33,  50,  50,  50,  50
        12,  13,  28,  50,  50,  50,  50,  50
        24,  33,  50,  50,  50,  50,  50,  50
        50,  50,  50,  50,  50,  50,  50,  50
        50,  50,  50,  50,  50,  50,  50,  50
        50,  50,  50,  50,  50,  50,  50,  50
        50,  50,  50,  50,  50,  50,  50,  50 ];
    Q_75_Y = [
         8,   6,   5,   8,  12,  20,  26,  31
         6,   6,   7,  10,  13,  29,  30,  28
         7,   7,   8,  12,  20,  29,  35,  28
         7,   9,  11,  15,  26,  44,  40,  31
         9,  11,  19,  28,  34,  55,  52,  39
        12,  18,  28,  32,  41,  52,  57,  46
        25,  32,  39,  44,  52,  61,  60,  51
        36,  46,  48,  49,  56,  50,  52,  50 ];  %75

    Q_80_C = [
         7,   7,  10,  19,  40,  40,  40,  40
         7,   8,  10,  26,  40,  40,  40,  40
        10,  10,  22,  40,  40,  40,  40,  40
        19,  26,  40,  40,  40,  40,  40,  40
        40,  40,  40,  40,  40,  40,  40,  40
        40,  40,  40,  40,  40,  40,  40,  40
        40,  40,  40,  40,  40,  40,  40,  40
        40,  40,  40,  40,  40,  40,  40,  40 ];
    Q_80_Y = [
         6,   4,   4,   6,  10,  16,  20,  24
         5,   5,   6,   8,  10,  23,  24,  22
         6,   5,   6,  10,  16,  23,  28,  22
         6,   7,   9,  12,  20,  35,  32,  25
         7,   9,  15,  22,  27,  44,  41,  31
        10,  14,  22,  26,  32,  42,  45,  37
        20,  26,  31,  35,  41,  48,  48,  40
        29,  37,  38,  39,  45,  40,  41,  40 ];  %80

    Q_85_C = [
         5,   5,   7,  14,  30,  30,  30,  30
         5,   6,   8,  20,  30,  30,  30,  30
         7,   8,  17,  30,  30,  30,  30,  30
        14,  20,  30,  30,  30,  30,  30,  30
        30,  30,  30,  30,  30,  30,  30,  30
        30,  30,  30,  30,  30,  30,  30,  30
        30,  30,  30,  30,  30,  30,  30,  30
        30,  30,  30,  30,  30,  30,  30,  30 ];
    Q_85_Y = [
         5,   3,   3,   5,   7,  12,  15,  18
         4,   4,   4,   6,   8,  17,  18,  17
         4,   4,   5,   7,  12,  17,  21,  17
         4,   5,   7,   9,  15,  26,  24,  19
         5,   7,  11,  17,  20,  33,  31,  23
         7,  11,  17,  19,  24,  31,  34,  28
        15,  19,  23,  26,  31,  36,  36,  30
        22,  28,  29,  29,  34,  30,  31,  30 ];  %85

    Q_90_C = [
         3,   4,   5,   9,  20,  20,  20,  20
         4,   4,   5,  13,  20,  20,  20,  20
         5,   5,  11,  20,  20,  20,  20,  20
         9,  13,  20,  20,  20,  20,  20,  20
        20,  20,  20,  20,  20,  20,  20,  20
        20,  20,  20,  20,  20,  20,  20,  20
        20,  20,  20,  20,  20,  20,  20,  20
        20,  20,  20,  20,  20,  20,  20,  20 ];
    Q_90_Y = [
         3,   2,   2,   3,   5,   8,  10,  12
         2,   2,   3,   4,   5,  12,  12,  11
         3,   3,   3,   5,   8,  11,  14,  11
         3,   3,   4,   6,  10,  17,  16,  12
         4,   4,   7,  11,  14,  22,  21,  15
         5,   7,  11,  13,  16,  21,  23,  18
        10,  13,  16,  17,  21,  24,  24,  20
        14,  18,  19,  20,  22,  20,  21,  20 ];  %90

    Q_95_C = [
         2,   2,   2,   5,  10,  10,  10,  10
         2,   2,   3,   7,  10,  10,  10,  10
         2,   3,   6,  10,  10,  10,  10,  10
         5,   7,  10,  10,  10,  10,  10,  10
        10,  10,  10,  10,  10,  10,  10,  10
        10,  10,  10,  10,  10,  10,  10,  10
        10,  10,  10,  10,  10,  10,  10,  10
        10,  10,  10,  10,  10,  10,  10,  10 ];
    Q_95_Y = [
        2,   1,   1,   2,   2,   4,   5,   6
        1,   1,   1,   2,   3,   6,   6,   6
        1,   1,   2,   2,   4,   6,   7,   6
        1,   2,   2,   3,   5,   9,   8,   6
        2,   2,   4,   6,   7,  11,  10,   8
        2,   4,   6,   6,   8,  10,  11,   9
        5,   6,   8,   9,  10,  12,  12,  10
        7,   9,  10,  10,  11,  10,  10,  10 ];   %95

    Q_100_C = [
        1,   1,   1,   1,   1,   1,   1,   1
        1,   1,   1,   1,   1,   1,   1,   1
        1,   1,   1,   1,   1,   1,   1,   1
        1,   1,   1,   1,   1,   1,   1,   1
        1,   1,   1,   1,   1,   1,   1,   1
        1,   1,   1,   1,   1,   1,   1,   1
        1,   1,   1,   1,   1,   1,   1,   1
        1,   1,   1,   1,   1,   1,   1,   1 ];
    Q_100_Y = [
        1,   1,   1,   1,   1,   1,   1,   1
        1,   1,   1,   1,   1,   1,   1,   1
        1,   1,   1,   1,   1,   1,   1,   1
        1,   1,   1,   1,   1,   1,   1,   1
        1,   1,   1,   1,   1,   1,   1,   1
        1,   1,   1,   1,   1,   1,   1,   1
        1,   1,   1,   1,   1,   1,   1,   1
        1,   1,   1,   1,   1,   1,   1,   1 ];  %100
    
   
 % usar la tabla según la calidad requerida
    %if nargin < 3
        %quality = 70; %default quality
    %end
    if quality==50
       cuantifTableUsedLuminance=Q_50_Y;
       cuantifTableUsedChrominance=Q_50_C; 
    elseif quality==60
       cuantifTableUsedLuminance=Q_60_Y;
       cuantifTableUsedChrominance=Q_60_C; 
    elseif quality==70
       cuantifTableUsedLuminance=Q_70_Y;
       cuantifTableUsedChrominance=Q_70_C; 
    elseif quality==75
       cuantifTableUsedLuminance=Q_75_Y;
       cuantifTableUsedChrominance=Q_75_C; 
    elseif quality==80
       cuantifTableUsedLuminance=Q_80_Y;
       cuantifTableUsedChrominance=Q_80_C; 
    elseif quality==85
       cuantifTableUsedLuminance=Q_85_Y;
       cuantifTableUsedChrominance=Q_85_C; 
    elseif quality==90
       cuantifTableUsedLuminance=Q_90_Y;
       cuantifTableUsedChrominance=Q_90_C; 
    elseif quality==95
       cuantifTableUsedLuminance=Q_95_Y;
       cuantifTableUsedChrominance=Q_95_C; 
    elseif quality==100
       cuantifTableUsedLuminance=Q_100_Y;
       cuantifTableUsedChrominance=Q_100_C; 
    else
       disp('Warning, quality not compatible. Using default (75)');
       cuantifTableUsedLuminance=Q_75_Y;
       cuantifTableUsedChrominance=Q_75_C;
    end

    if CODIFICAR
    
    %----------Abrir BMP, pasar a YCbCr--------------
    [myOriginalImg, colorMap] = imread(fotoAUsar);
    
    %figure();
    %image(myOriginalImg);
    %title('La imagen sin estaganografiar')
    [oImgRows, oImgCols, oImgComponents] = size(myOriginalImg);
    %image(myOriginalImg);
    
    %---Ajuste para que entren todos los bloques de 8x8
    rowsEdgeConflict = mod(oImgRows, BLOCK_ROWS);  %ajuste para que entren los bloques de 8x8
    colsEdgeConflict = mod(oImgCols, BLOCK_COLS);
    if rowsEdgeConflict || colsEdgeConflict
        if rowsEdgeConflict
            addedRows = BLOCK_ROWS - rowsEdgeConflict; %me dice cuantas filas debo agregar abajo.
        else
            addedRows=0; 
        end
        if colsEdgeConflict
            addedCols = BLOCK_COLS - colsEdgeConflict; %me dice cuantas columnas debo agregar a la derecha
        else
            addedCols=0;
        end
            myAdjustedImg = [myOriginalImg zeros(oImgRows, addedCols, oImgComponents)];   %agrego las columnas que faltan 
        myAdjustedImg = [myAdjustedImg ; zeros(addedRows, oImgCols + addedCols, oImgComponents)]; %agrego las filas que faltan
    else
        myAdjustedImg = myOriginalImg;
    end
    [adjustedRows, adjustedCols, adjustedZ]=size(myAdjustedImg);
    
    
    %---Conversión a YCbCr
    YCbCrMap = my_rgb2ycbcr(myAdjustedImg);
    LuminanceOffset = ones(adjustedRows,adjustedCols);
    LuminanceOffset = LuminanceOffset*128;
     
   if agregoOffset
     YCbCrMap(:,:,1) = YCbCrMap(:,:,1) - LuminanceOffset;
   end 
   
    %------Dividir la imagen en bloques de 8x8 y aplicarles DCT a cada uno de ellos-----
    %--El recorrido de bloques es de izquierda a derecha, de arriba a abajo.
    %--Esto está hecho para un arreglo genérico y no YCbCr---
    dctRowBlocks=ceil(oImgRows / BLOCK_ROWS);
    dctColBlocks=ceil(oImgCols / BLOCK_COLS);
    DCTCoefficients=zeros(dctRowBlocks*BLOCK_ROWS,dctColBlocks*BLOCK_COLS,oImgComponents); %esta linea, agrega a lo sumo 7 pixeles en los bordes, para que entren perfectamente los bloques de 8x8
    spreadIndex=1;
    %Recorro las tres componentes de color: Y, Cb y Cr. Aplico la misma transformación para las tres componentes de color, cambiando las tablas de cuantización--
    for myColorComponent = 1:oImgComponents
        %recorro los bloques, transformo, cuantizo y guardo en arreglo 1D
        for i=0:dctRowBlocks-1
           for j=0:dctColBlocks-1
            %B = dct2(A,m,n) %DCT de matriz A, completando con ceros m*n
            startPos=(1:BLOCK_ROWS)+i*BLOCK_ROWS;
            endPos = (1:BLOCK_COLS)+j*BLOCK_COLS;
            DCTCoefficients( startPos, endPos, myColorComponent) = dct2(YCbCrMap(startPos, endPos, myColorComponent), BLOCK_ROWS, BLOCK_COLS);
            %---Cuantizar---
            if myColorComponent == 1 % Si es la componente de luminancia
                DCTCoefficients( startPos,endPos,myColorComponent) = DCTCoefficients(startPos,endPos,myColorComponent)./cuantifTableUsedLuminance;
            else    %si es la componente de crominancia
                DCTCoefficients( startPos,endPos,myColorComponent) = DCTCoefficients(startPos,endPos,myColorComponent)./cuantifTableUsedChrominance;
            end
            
            %---Poner todo el bloque en un arreglo 1D, haciendo el recorrido zig-zag
            DCTCoefficients1DArray = zigzag(DCTCoefficients(startPos, endPos, myColorComponent)); 
            %Esteganografiar aquí, por LSB en todos los coeficientes DCT salvo DC----------
            %No se guarda información en los bloques de los bordes---
            %DCTCoefficients1DArray = cast(DCTCoefficients1DArray,'int8'); % pasar a int signed
            if not(((i==(dctRowBlocks-1))&&rowsEdgeConflict)||((j==(dctColBlocks-1))&&colsEdgeConflict)) % mientras que no sea en los utlimos (son peligrosos), salvo que entren 8x8 exacto
                if spreadSpectrum
                    if stegStringBits(stegStringIndex) % si tengo que poner un 1
                        %DCTCoefficients1DArray(iterator) = bitset(DCTCoefficients1DArray(iterator),STEG_BIT);
                        if mod(floor(DCTCoefficients1DArray(EncodeInSpectrum((spreadIndex)))),2)
                            %es impar
                            %Como es imppar, el uno en el ultimo bit ya
                            %esta guardado
                        else
                            DCTCoefficients1DArray(EncodeInSpectrum((spreadIndex)))=DCTCoefficients1DArray(EncodeInSpectrum(spreadIndex)) + 1.0;
                        end
                    else % si no, pongo un cero
                        if mod(floor(DCTCoefficients1DArray(EncodeInSpectrum((spreadIndex)))),2)
                            %es impar
                            %le tengo que poner un 0 en realidad, por ende:
                            DCTCoefficients1DArray(EncodeInSpectrum((spreadIndex)))=DCTCoefficients1DArray(EncodeInSpectrum(spreadIndex)) - 1.0; % estoy tocando varios bits
                        else
                            %es par, no toco nada
                        end
                    end
                    spreadIndex=spreadIndex+1;
                    if spreadIndex>length(EncodeInSpectrum)
                        spreadIndex=1;
                    end
                    
                else
                    for iterator = 2:BLOCK_SIZE % iterar pero no en la continua
                        if stegStringBits(stegStringIndex) % si tengo que poner un 1
                            %DCTCoefficients1DArray(iterator) = bitset(DCTCoefficients1DArray(iterator),STEG_BIT);
                            if mod(floor(DCTCoefficients1DArray(iterator)),2)
                                %es impar
                                %Como es imppar, el uno en el ultimo bit ya
                                %esta guardado
                            else
                                DCTCoefficients1DArray(iterator)=DCTCoefficients1DArray(iterator) + 1.0;
                            end
                        else % si no, pongo un cero
                            if mod(floor(DCTCoefficients1DArray(iterator)),2)
                                %es impar
                                %le tengo que poner un 0 en realidad, por ende:
                                DCTCoefficients1DArray(iterator)=DCTCoefficients1DArray(iterator) + 1.0; % estoy tocando varios bits
                            else
                                %es par, no toco nada
                            end
                        end
                        stegStringIndex = stegStringIndex + 1; % proximo bit del mensaje
                        if stegStringIndex > length(stegStringBits) % o el primero para repetir el mensaje
                            stegStringIndex = 1;
                        end
                    end
                end
            end   
            %Convertir el arreglo 1D de nuevo a 2D
            DCTCoefficients(startPos, endPos, myColorComponent) = invzigzag(DCTCoefficients1DArray,BLOCK_ROWS,BLOCK_COLS);
           end
        end
    end


    %------------------------------------INVERSE--------------------------%
    %------------------------------De nuevo a mapa RGB--------------------------%
    myEncodedImage = zeros(oImgRows,oImgCols,oImgComponents); 
    %Agrepar coefs en 8x8. Multiplicar por tabla de cuantización. Invertir DCT,
    %volver a RGB
    for myColorComponent = 1:oImgComponents
        for i=0:dctRowBlocks-1
           for j=0:dctColBlocks-1
            startPos = i*BLOCK_ROWS + 1:i*BLOCK_ROWS + BLOCK_ROWS;
            endPos = j*BLOCK_COLS + 1:j*BLOCK_COLS + BLOCK_COLS;
            if myColorComponent == 1
                myEncodedImage(startPos,endPos,myColorComponent) = idct2(DCTCoefficients(startPos,endPos,myColorComponent).*cuantifTableUsedLuminance,BLOCK_ROWS,BLOCK_COLS);
            else
                myEncodedImage(startPos,endPos,myColorComponent) = idct2(DCTCoefficients(startPos,endPos,myColorComponent).*cuantifTableUsedChrominance,BLOCK_ROWS,BLOCK_COLS); 
            end
           end
        end
    end

    %---Recortar las filas y columnas que se habían agregado para que entren los bloques de 8x8
    if agregoOffset
       myEncodedImage(:,:,1) = myEncodedImage(:,:,1) + cast(LuminanceOffset, 'double');    %Fix OFFSET 
    end
    ret = myEncodedImage;
    myEncodedImage = myEncodedImage(1:oImgRows, 1:oImgCols, 1:oImgComponents);
    
   
    %Convertir mapa YCbCr a RGB
    myFinalEncodedImage = my_ycbcr2rgb(myEncodedImage);
    %myFinalEncodedImage=myEncodedImage;
%     ret=myEncodedImage;
    %figure()
    %image(cast(myFinalEncodedImage,'uint8'))
    %title('La imagen esteganografiada')
    myFinalEncodedImage = cast(myFinalEncodedImage,'uint8');
    %myFinalEncodedImage = cast(myFinalEncodedImage, 'uint8');
    
    
    imwrite(myFinalEncodedImage, imgPath,'bmp');
    
    myFinalEncodedImage=imread(imgPath,'bmp');
    image(myFinalEncodedImage);
    end
    
    if DECODIFICAR
    
    %stegImgDecoder
%   la función de DECODIFICACIÓN recibe:
%       1-Un string "imgPath" que tiene el PATH relativo a la dirección del archivo con la imagen a decodificar.
%   la función de DECODIFICACIÓN devuelve:
%       1-Un string "myDecodedString muy largo con el mensaje que se decodificó
%           Si es null es porque no funcionó 

%OJO QUE AGREGUE UN ARGUMENTO NUEVO QUE SE LLAMA QUALITY

%Convertir RGB a YCbCr
%Dividir cada componente de la imagen en 8x8
%Aplicar DCT
%Cuantizar
%Leer el mensaje


     %---Bits que componen el mensaje---
     if spreadSpectrum
         DecodedStegStringBits=zeros(1,oImgRows*oImgCols*oImgComponents);
         myDecodedString=zeros(1,ceil(oImgRows*oImgCols*oImgComponents/8));
     else
         DecodedStegStringBits=zeros(1,oImgRows*oImgCols*oImgComponents*8);
         %---Arreglo de Mensaje decodificado
         myDecodedString=zeros(1,oImgRows*oImgCols*oImgComponents);
     end
    
    
    globalBitStringIndex=1;  %indice para ir llenando los bits. Inicia al comienzo del arreglo
    
   %---Ajuste para que entren todos los bloques de 8x8
    rowsEdgeConflict=mod(oImgRows,BLOCK_ROWS);  %ajuste para que entren los bloques de 8x8
    colsEdgeConflict=mod(oImgCols,BLOCK_COLS);
    if rowsEdgeConflict || colsEdgeConflict
        if rowsEdgeConflict
            addedRows = BLOCK_ROWS - rowsEdgeConflict; %me dice cuantas filas debo agregar abajo.
        else
            addedRows=0; 
        end
        if colsEdgeConflict
            addedCols = BLOCK_COLS - colsEdgeConflict; %me dice cuantas columnas debo agregar a la derecha
        else
            addedCols=0;
        end

        
        myAdjustedImg= [myFinalEncodedImage zeros(oImgRows,addedCols,oImgComponents)];   %agrego las columnas que faltan 
        myAdjustedImg= [myAdjustedImg ; zeros(addedRows,oImgCols+addedCols,oImgComponents)]; %agrego las filas que faltan
    else
        myAdjustedImg=myFinalEncodedImage;        
    end
    
    %---Conversión a YCbCr
    %YCbCrMap=myAdjustedImg;
    YCbCrMap = my_rgb2ycbcr(myAdjustedImg);
    if agregoOffset
        YCbCrMap(:,:,1) = YCbCrMap(:,:,1) - LuminanceOffset;
    end
   
    test = YCbCrMap - ret;
    %El RGB obtenido es en realidad la componente Y, con Cb y Cr=0
    %myOrgiginalImgYCBCR = rgb2ycbcr(myOrgiginalImg);


    %------Dividir la imagen en bloques de 8x8 y aplicarles DCT a cada uno de ellos-----
    %--El recorrido de bloques es de izquierda a derecha, de arriba a abajo.
    %--Esto está hecho para un arreglo genérico y no YCbCr---
    dctRowBlocks=ceil(oImgRows/BLOCK_ROWS);
    dctColBlocks=ceil(oImgCols/BLOCK_COLS);
    DCTCoefficients=zeros(dctRowBlocks*BLOCK_ROWS,dctColBlocks*BLOCK_COLS,oImgComponents); %esta linea, agrega a lo sumo 7 pixeles en los bordes, para que entren perfectamente los bloques de 8x8
    spreadIndex=1;
    %Recorro las tres componentes de color: Y, Cb y Cr. Aplico la misma transformación para las tres componentes de color--
    for myColorComponent=1:oImgComponents
        %recorro los bloques, transformo, cuantizo y guardo en arreglo 1D
        for i=0:dctRowBlocks-1
           for j=0:dctColBlocks-1
            %B = dct2(A,m,n) %DCT de matriz A, completando con ceros m*n
            startPos=(1:BLOCK_ROWS)+i*BLOCK_ROWS;
            endPos=(1:BLOCK_COLS)+j*BLOCK_COLS;
            DCTCoefficients(startPos,endPos,myColorComponent)=dct2(YCbCrMap(startPos,endPos,myColorComponent),BLOCK_ROWS,BLOCK_COLS);
            %---Cuantizar---
            if myColorComponent==1
                DCTCoefficients(startPos,endPos,myColorComponent)=DCTCoefficients(startPos,endPos,myColorComponent)./cuantifTableUsedLuminance;
            else
                DCTCoefficients(startPos,endPos,myColorComponent)=DCTCoefficients(startPos,endPos,myColorComponent)./cuantifTableUsedChrominance;
            end
           
            %---Poner todo el bloque en un arreglo 1D, haciendo el recorrido zig-zag
            DCTCoefficients1DArray=zigzag(DCTCoefficients(startPos,endPos,myColorComponent)); 
            %---DECODIFICACIÓN, por LSB en todos los coeficientes DCT salvo DC y en bloques de los bordes----------
            if not(((i==(dctRowBlocks-1))&&rowsEdgeConflict)||((j==(dctColBlocks-1))&&colsEdgeConflict)) 
                if spreadSpectrum
                    %%DecodedStegStringBits(globalBitStringIndex)=bitget(DCTCoefficients1DArray(iterator),STEG_BIT);
                     if mod(floor(DCTCoefficients1DArray(EncodeInSpectrum((spreadIndex)))),2)
                         %es impar
                         DecodedStegStringBits(globalBitStringIndex)=1;
                     else
                         DecodedStegStringBits(globalBitStringIndex)=0;
                         %es par
                     end
                     globalBitStringIndex=globalBitStringIndex+1;
                     spreadIndex=spreadIndex+1;
                     if spreadIndex>length(EncodeInSpectrum)
                        spreadIndex=1;
                     end
                else
                    for iterator=2:BLOCK_SIZE
                        %%DecodedStegStringBits(globalBitStringIndex)=bitget(DCTCoefficients1DArray(iterator),STEG_BIT);
                        if mod(floor(DCTCoefficients1DArray(iterator)),2)
                            %es impar
                            DecodedStegStringBits(globalBitStringIndex)=1;
                        else
                            DecodedStegStringBits(globalBitStringIndex)=0;
                            %es par
                        end
                        globalBitStringIndex=globalBitStringIndex+1;
                    end   
                end
                
             end
           end
        end
    end

    %Debo pasar los bits a bytes de caracteres de string
    numberOfCharacters=ceil((globalBitStringIndex-1)/(8*REPETITION));
    auxiliar=zeros(1,8*REPETITION);
    aTransformar=zeros(1,8);
    newBits=0;
    for i=0:numberOfCharacters-1
        auxiliar=fliplr(DecodedStegStringBits(i*8*REPETITION+1:i*8*REPETITION+8*REPETITION));
        aTransformar=DecideRepetition(auxiliar , REPETITION);
        if length(newBits)<2
           newBits=fliplr(aTransformar); 
        else
           newBits=[newBits fliplr(aTransformar)];
        end
        myDecodedString(i+1)=bi2de(aTransformar);
    end
    myDecodedString=char(myDecodedString);
    
    goodString = zeros(1, length(stegString));
    characterRecovered = zeros(1, 8);
%     for i=1:length(stegString);
%         for k=0:7
%             j = i + k;
%             add = 0;
%             total = 0;
%             while j < (length(newBits)-1)
%                 total = total + 1;
%                 add = add + newBits(j);
%                 j = j + length(stegString) * 8;
%             end
%             characterRecovered(k + 1) = round(add / total);
%         end
%         goodString(i) = bi2de(fliplr(characterRecovered));
%     end
%     disp(cast(goodString, 'char'))
%     myDecodedString = char(myDecodedString);
%     disp(myDecodedString);
    

disp('Probable Messages:')

for length=1:20

    goodString = zeros(1, length);
    stego = zeros(1, ceil(numberOfCharacters/length));
    Frequency = zeros(1, ceil(numberOfCharacters/length));
    for i=1:length
        j = i;
        n = 1;
        while n <= ceil(numberOfCharacters/length)
            stego(n) = myDecodedString(j);
            j = j + length;
            n = n + 1;
        end
        [goodString(i), Frequency(i)] = mode(stego);
    end
    
    disp(cast(goodString, 'char'));
     Hit = sum(Frequency) / ( length * ceil(numberOfCharacters/length));
     disp(Hit * 100);
    
    
end

    end

clear auxiliar bit BLOCK_COLS BLOCK_ROES BLOCK_SIZE characterRecovered colorMap colsEdgeConflict
clear cuantifTableUsedChrominance cuantifTableUsedLuminance DCTCoefficients DCTCoefficients1DArray
clear dctColBlocks dctRowBlocks endPos fotoAUsar Frequency GlobalBitStringIndex i individualCharacter iterator j length
clear LuminanceOffset myBit myColorComponent n newBits numberOfCharacters oImgCols oImgComponents oImgRows
clear Q_100_C Q_100_Y Q_50_C Q_50_Y Q_60_C Q_60_Y Q_70_C Q_70_Y Q_75_C Q_75_Y Q_80_C Q_80_Y Q_85_C Q_85_Y
clear Q_90_C Q_90_Y Q_95_C Q_95_Y quality rep REPETITION rowsEdgeConflict spreadIndex spreadSpectrum startPost
clear STEG_BIT stegStringBits stegStringIndex test YCbCrMap
clear asciiString agregoOffset addedCols addedRows adjustedCols adjustedRows adjustedZ aTransformar BLOCK_ROWS
clear globalBitStringIndex DecodedStringBits startPos