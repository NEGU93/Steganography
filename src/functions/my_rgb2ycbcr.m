function ycbcrImage = my_rgb2ycbcr(rgbImage)  %# A sample RGB image
    %digits(15);
    rgbImage = cast(rgbImage, 'double');
    % JPEG conversion matrix 4 decimal position accuracy
    A = [0.299      0.587       0.114;
        -0.299     -0.587      0.886;
         0.701      -0.587      -0.114
         ];
    [oImgRows, oImgCols, oImgComponents] = size(rgbImage);
    ycbcrImage = zeros(oImgRows, oImgCols, oImgComponents);
    %Y
    ycbcrImage(:,:,1) = ((rgbImage(:,:,1)*A(1, 1) + rgbImage(:,:,2)*A(1, 2) + rgbImage(:,:,3)*A(1, 3)));
    ycbcrImage(:,:,2) = ((rgbImage(:,:,1)*A(2, 1) + rgbImage(:,:,2)*A(2, 2) + rgbImage(:,:,3)*A(2, 3)) / 1.772 + 128);
    ycbcrImage(:,:,3) = ((rgbImage(:,:,1)*A(3, 1) + rgbImage(:,:,2)*A(3, 2) + rgbImage(:,:,3)*A(3, 3)) / 1.402 + 128);
    
    ycbcrImage(:,:,:) = min(255, max(0, ycbcrImage(:,:,:)));
    %ycbcrImage = cast(ycbcrImage,'uint8');
end