function rgbImage = my_ycbcr2rgb(ycbcrImage)
    %digits(15);
    %ycbcrImage = cast(ycbcrImage, 'double');
    [oImgRows, oImgCols, oImgComponents] = size(ycbcrImage);
    rgbImage = zeros(oImgRows, oImgCols, oImgComponents);
    for i=1:oImgRows
        for j=1:oImgCols
            %RED
            rgbImage(i, j, 1) = (ycbcrImage(i, j, 1) + 1.402 * (ycbcrImage(i, j, 3) - 128));
            %Green
            rgbImage(i, j, 2) = (ycbcrImage(i, j, 1) - (0.114 * 1.772 * (ycbcrImage(i, j, 2) - 128) / 0.587) - 0.299 * 1.402 * (ycbcrImage(i, j, 3) - 128) / 0.587);
            %Blue
            rgbImage(i, j, 3) = (ycbcrImage(i, j, 1) + 1.772 * (ycbcrImage(i, j, 2) - 128));
        end
    end
    rgbImage(:,:,:) = min(255, max(0, rgbImage(:,:,:)));
    %rgbImage = cast(rgbImage,'uint8');
end