classdef Steganography < handle
    %% Variables
    properties %aca van las variables
        handles;
        %%ambas
        
        DCTSize=8;
        Repetition=4;
        Spread=false;
        Encode=true;    % This should be true because it will start with the edit_hidmsg as enable. 
        
        %%De compresion
        photo='';
        hiddenmessage='Escribe tu mensaje aqui';
        quality=0;
        
        %%De decodificacion
        decoFile='Pruebas';
        decodedMessage='';
    end

    methods %especie de funciones a utilizar
        %% Métodos
        function self=Steganography(~)
            hfig=hgload('StegGUI');
            self.handles = guihandles(hfig);
            movegui(hfig,'center');
            
            %%Seteos:
            %Pushbuttons
            set(self.handles.pushbutton_run, 'String', 'Encode');
            %Pop up menus
            set(self.handles.popupmenu_chooseimage,'String',{'Rey Alfonso','Papa Noel','pepper','militar','IMG0550','DSC_0001','Astronauta','Alumnos'}); % cambia el nombre del popup menu
            set(self.handles.popupmenu_chooseimage,'Value',1);
            self.popupmenu_chooseimage_callback()
            set(self.handles.popupmenu_quality,'String',{'100','95','90','85','80','75','70','60','50'})
            set(self.handles.popupmenu_quality,'Value',5); 
            self.popupmenu_quality_callback()
            %%------Set callbacks-------------------        
            %botones
            set(self.handles.pushbutton_run, 'callback', @self.pushbutton_run_callback);
            %popupmenu
            set(self.handles.popupmenu_chooseimage,'callback',@self.popupmenu_chooseimage_callback); % cambia el nombre del popup menu
            set(self.handles.popupmenu_quality,'callback',@self.popupmenu_quality_callback);
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
            set(self.handles.radiobutton_encode, 'callback', @self.radiobutton_encode_callback);
            set(self.handles.radiobutton_decode, 'callback', @self.radiobutton_decode_callback);
            set(self.handles.radiobutton_spread,'callback',@self.radiobutton_spread_callback);
        end
        
        %% ----Hago los callbacks es decir las funciones-----
        %pushbutton
        function pushbutton_run_callback(self, varargin)
            if self.Encode
                self.makesteg()
            else
                self.decode()
            end
        end
        function makesteg(self, varargin)
            if isempty(self.hiddenmessage)
                msgbox('No message to hide was entered, please insert one');
                return
            end
           h = msgbox('encoding, please wait...', 'Loading');
           child = get(h, 'Children');
           delete(child(1));
           drawnow;
           set(self.handles.text_hidden_msg, 'String', self.hiddenmessage);
           %%para medir la psnr y ssim
           original=imread(strcat(self.photo, '.jpg'));
           retocada=encoderStegFinal(self.hiddenmessage,strcat('images\', self.photo, '.jpg'),strcat('encoded\', self.decoFile, '.jpg'),self.quality,self.Spread,self.DCTSize,self.Repetition);
           [psnr,ssim,map] = evaluateDeterioration(retocada,original);
           % figure('Name','Comparison','NumberTitle','off');
           % image(self.handles.axes_original_image, original)
           imshow(original, 'Parent', self.handles.axes_original_image)
           imshow(retocada, 'Parent', self.handles.axes_encoded_image)
           % title(sprintf('Retocada. Q=%d PSNR=%.1f [dB] SSIM=%.4f',self.quality,psnr,ssim));
           % figure('Name','SSIM map','NumberTitle','off');
           imshow(map, 'Parent', self.handles.axes_SSIM_map)
           set(self.handles.text_psnr, 'String', strcat('PSNR = ', num2str(psnr)));
           set(self.handles.text_ssim, 'String', strcat('SSIM = ', num2str(ssim)));
           % title('Mapa de Structural Similarity (Análisis cualitativo)')
           delete(h)
           msgbox('Steganography Succesfull')
        end
        function decode(self, varargin)
            if isempty(self.decoFile)
                msgbox('No file name entered, please insert name of file to recover message');
                return
            end
            
            %analisis de existencia de archivo + funcion de decodificacion
            
            if exist(strcat(self.decoFile, '.jpg'),'file')==2
                h = msgbox('decoding, please wait...', 'Loading');
                child = get(h, 'Children');
                delete(child(1));
                drawnow;
                [string, porcentaje]=decoderStegFinal(strcat('encoded\', self.decoFile, '.jpg'),self.quality,self.Spread,self.DCTSize,self.Repetition);
                imshow(imread(strcat(self.decoFile, '.jpg')), 'Parent', self.handles.axes_encoded_image) 
                set(self.handles.text_hidden_msg, 'String', string);
                set(self.handles.text_hr, 'String', strcat('HR = ', num2str(porcentaje)));
                delete(h)
                % set(msgbox(string,sprintf('Mensaje decodificado (HR=%.2f porciento )',porcentaje)), 'position', [100 440 400 50]);
            else
                 msgbox('No valid file entered, verify it is in the correct folder (endoded) and the file is correcly written');
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
            str = get(self.handles.edit_dct,'String');
            if isempty(str2num(str))
                set(self.handles.edit_dct,'String', 8);
                self.DCTSize = 8;
                warndlg('Input must be numerical');
            else
                num = str2num(str);
                if num ~= abs(num)
                    warndlg('Input must be positive. Making it positive by default');
                    num = abs(num);
                end
                self.DCTSize = num;  %%de donde quiero gettear y que quiero getear
            end
        end
        function edit_repetition_callback (self,varargin)
            str = get(self.handles.edit_repetition,'String');
            if isempty(str2num(str))
                set(self.handles.edit_repetition,'String', 4);
                self.Repetition = 4;
                warndlg('Input must be numerical');
            else
                num = str2num(str);
                if num ~= abs(num)
                    warndlg('Input must be positive. Making it positive by default');
                    num = abs(num);
                end
                self.Repetition = num; %%de donde quiero gettear y que quiero getear
            end
        end
        %popupmenu
        function popupmenu_chooseimage_callback(self,varargin)
            switch get(self.handles.popupmenu_chooseimage,'Value') %%es el valor de la posición del string que elegi
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
            switch get(self.handles.popupmenu_quality,'Value') %%es el valor de la posición del string que elegi
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
        %RadioButton
        function radiobutton_spread_callback (self, varargin)
           if get(self.handles.radiobutton_spread,'Value')
              self.Spread=true;
           else 
              self.Spread=false; 
           end
        end      
        function radiobutton_encode_callback (self, varargin)
            self.Encode = true;
            set(self.handles.edit_hidemsg, 'Enable', 'on');
            set(self.handles.text_output_file, 'String', 'Output File:')
            set(self.handles.pushbutton_run, 'String', 'Encode');
            set(self.handles.popupmenu_chooseimage, 'Enable', 'on');
        end
        function radiobutton_decode_callback (self, varargin)
            self.Encode = false;
            set(self.handles.edit_hidemsg, 'Enable', 'off');
            set(self.handles.text_output_file, 'String', 'Encoded File:')
            set(self.handles.pushbutton_run, 'String', 'Decode');
            set(self.handles.popupmenu_chooseimage, 'Enable', 'off');
        end
    end
end

