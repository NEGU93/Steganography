function [ psnrValue,ssimValue,ssimMap ] = evaluateDeterioration( modified, original )
    %Esta funcion se dedica a evaluar el deterioramiento producido por
    %agregar informacion a la original



    psnrValue=psnr(modified,original);
    [ssimValue,ssimMap]=ssim(modified,original);

end

