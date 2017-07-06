classdef Steganography < handle

    
    properties %aca van las variables
        handles;
        %%ambas
        
        DCTSize=8;
        Repetition=4;
        Spread=false;
        
        %%De compresion
        photo='';
        hiddenmessage='Escribe tu mensaje aqui';
        quality=0;
        
        %%De decodificacion
        decoFile='Pruebas';
        decodeQuality=0;
        decodedMessage='';
    end
    
    methods %especie de funciones a utilizar
        function self=Steganography(~)
            hfig=hgload('StegGUI');
            self.handles = guihandles(hfig);
            movegui(hfig,'center');
            
            %%Seteos:
            %Pushbuttons
            set(self.handles.pushbutton_makesteg,'String','Make Steganography'); %la clase madre.a que tag, a que propiedad, y que valor le quiero poner
            set(self.handles.pushbutton_decode,'String','Obtain Message');
            %Pop up menus
            set(self.handles.popupmenu_chooseimage,'String',{'Rey Alfonso','Papa Noel','pepper','militar','IMG0550','DSC_0001','Astronauta','Alumnos'}); % cambia el nombre del popup menu
            set(self.handles.popupmenu_chooseimage,'Value',2); self.photo='PapaNoel';
            set(self.handles.popupmenu_quality,'String',{'100','95','90','85','80','75','70','60','50'})
            set(self.handles.popupmenu_quality,'Value',1); self.quality=100;
            set(self.handles.popupmenu_quality_2,'String',{'100','95','90','85','80','75','70','60','50'})
            set(self.handles.popupmenu_quality_2,'Value',1); self.decodeQuality=100;
            %%------Set callbacks-------------------        
            %botones
            set(self.handles.pushbutton_makesteg,'callback',@self.pushbutton_makesteg_callback);
            set(self.handles.pushbutton_decode,'callback',@self.pushbutton_decode_callback);
            %popupmenu
            set(self.handles.popupmenu_chooseimage,'callback',@self.popupmenu_chooseimage_callback); % cambia el nombre del popup menu
            set(self.handles.popupmenu_quality,'callback',@self.popupmenu_quality_callback);
            set(self.handles.popupmenu_quality_2,'callback',@self.popupmenu_quality_2_callback);
            
            %edit texts:
            set(self.handles.edit_hidemsg,'callback',@self.edit_hidemsg_callback);
            set(self.handles.edit_hidemsg,'String', self.hiddenmessage);
            set(self.handles.edit_decofile,'callback',@self.edit_decofile_callback);
            set(self.handles.edit_decofile,'String',self.decoFile);
            set(self.handles.edit_dct,'callback',@self.edit_dct_callback);
            set(self.handles.edit_dct,'String',self.DCTSize);
            set(self.handles.edit_repetition,'callback',@self.edit_repetition_callback);
            set(self.handles.edit_repetition,'String',self.Repetition);
            
            %Radio Button
            set(self.handles.radiobutton_spread,'callback',@self.radiobutton_spread_callback);
        end
        
        %%----Hago los callbacks es decir las funciones-----
        %pushbutton
        function pushbutton_makesteg_callback (self, varargin)
            if isempty(self.hiddenmessage)
                msgbox('No message to hide was entered, please insert one');
                return
            end

           %%para medir la psnr y ssim
           original=imread(strcat(self.photo, '.jpg'));
           retocada=encoderStegFinal(self.hiddenmessage,strcat('images\', self.photo, '.jpg'),strcat('encoded\', self.decoFile, '.jpg'),self.quality,self.Spread,self.DCTSize,self.Repetition);
           [psnr,ssim,map]=evaluateDeterioration(retocada,original);
           figure('Name','Comparison','NumberTitle','off');
           subplot(1,2,1); image(original); title('Original'); subplot(1,2,2); image(retocada); 
           title(sprintf('Retocada. Q=%d PSNR=%.1f [dB] SSIM=%.4f',self.quality,psnr,ssim));
           figure('Name','SSIM map','NumberTitle','off');
           image(map);
           title('Mapa de Structural Similarity (An�lisis cualitativo)')
           msgbox('Steganography Succesfull')
        end
        
        function pushbutton_decode_callback (self, varargin)
            if isempty(self.decoFile)
                msgbox('No file name entered, please insert name of file to recover message');
                return
            end
            
            %analisis de existencia de archivo + funcion de decodificacion
            
            if exist(self.decoFile,'file')==2
                [string, porcentaje]=decoderStegFinal(strcat('encoded\', self.decoFile, '.jpg'),self.decodeQuality,self.Spread,self.DCTSize,self.Repetition);
               
                set(msgbox(string,sprintf('Mensaje decodificado (HR=%.2f porciento )',porcentaje)), 'position', [100 440 400 50]);
            else
                 msgbox('No valid file entered, verify it is in the correct folder and try again');
                return
            end
            
            
            
            
        end
    
        %edit texts
        function edit_hidemsg_callback (self,varargin)
            self.hiddenmessage = get(self.handles.edit_hidemsg,'String'); %%de donde quiero gettear y que quiero getear
        end
        function edit_decofile_callback (self,varargin)
            self.decoFile = get(self.handles.edit_decofile,'String'); %%de donde quiero gettear y que quiero getear
        end
        
        function edit_dct_callback (self,varargin)
            self.DCTSize = str2int(get(self.handles.edit_dct,'String'));  %%de donde quiero gettear y que quiero getear
        end
        function edit_repetition_callback (self,varargin)
            self.Repetition = str2int(get(self.handles.edit_repetition,'String')); %%de donde quiero gettear y que quiero getear
        end
        
       
        %popupmenu
        function popupmenu_chooseimage_callback(self,varargin)
            switch get(self.handles.popupmenu_chooseimage,'Value') %%es el valor de la posici�n del string que elegi
                case 1
                    self.photo='Rey_Alfonso';
                case 2
                    self.photo='PapaNoel';
                case 3
                    self.photo='pepper';    % TODO: this image is a bmp
                case 4
                    self.photo='militar';
                case 5
                    self.photo='IMG_0550';
                case 6
                    self.photo='DSC_0001';
                case 7
                    self.photo='Astronauta';
                case 8
                    self.photo='Alumnos';
            end
        end
        function popupmenu_quality_callback(self,varargin)
            switch get(self.handles.popupmenu_quality,'Value') %%es el valor de la posici�n del string que elegi
                case 1
                    self.quality=100;
                case 2
                    self.quality=95;
                case 3
                    self.quality=90;
                case 4
                    self.quality=85;
                case 5
                    self.quality=80;
                case 6
                    self.quality=75;
                case 7
                    self.quality=70;
                case 8
                    self.quality=60;
                case 9
                    self.quality=50;
            end
        end
        function popupmenu_quality_2_callback(self,varargin)
            switch get(self.handles.popupmenu_quality_2,'Value') %%es el valor de la posici�n del string que elegi
                case 1
                    self.decodeQuality=100;
                case 2
                    self.decodeQuality=95;
                case 3
                    self.decodeQuality=90;
                case 4
                    self.decodeQuality=85;
                case 5
                    self.decodeQuality=80;
                case 6
                    self.decodeQuality=75;
                case 7
                    self.decodeQuality=70;
                case 8
                    self.decodeQuality=60;
                case 9
                    self.decodeQuality=50;
            end
        end
       
        %RadioButton
        function radiobutton_spread_callback (self, varargin)
           if get(self.handles.radiobutton_spread,'Value')
              self.Spread=true;
           else 
              self.Spread=false; 
           end
        end
        
    end
    
end

