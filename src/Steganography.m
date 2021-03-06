classdef Steganography < handle
    %% Variables
    properties %aca van las variables
        handles;
        
        %mail
        mail
        
        % Webcam 
        video;
        cam = webcam(1);
        img;
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
        %% M�todos
        function self=Steganography(~)
            hfig=hgload('StegGUI');
            self.handles = guihandles(hfig);
            movegui(hfig,'center');
            
            %%Seteos:
            %Pushbuttons
            set(self.handles.pushbutton_run, 'String', 'Encode');
            set(self.handles.pushbutton_start_stop,'String','Start Camera');
            set(self.handles.pushbutton_capture,'Enable','off');
            %Pop up menus
            set(self.handles.popupmenu_quality,'String',{'100','95','90','85','80','75','70','60','50'})
            set(self.handles.popupmenu_quality,'Value',5); 
            self.popupmenu_quality_callback()
            %%------Set callbacks-------------------        
            %botones
            set(self.handles.pushbutton_run, 'callback', @self.pushbutton_run_callback);
            set(self.handles.pushbutton_start_stop, 'callback', @self.pushbutton_start_stop_callback);
            set(self.handles.pushbutton_capture, 'callback', @self.pushbutton_capture_callback);
            set(self.handles.pushbutton_upload, 'callback', @self.pushbutton_upload_callback);
            set(self.handles.pushbutton_mail_demo, 'callback', @self.pushbutton_mail_demo_callback);
            %popupmenu
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
        function pushbutton_start_stop_callback(self, varargin)
            % Start/Stop Camera
            if strcmp(get(self.handles.pushbutton_start_stop,'String'),'Start Camera')
                % Camera is off. Change button string and start camera.
                set(self.handles.pushbutton_start_stop,'String','Stop Camera');
                set(self.handles.pushbutton_capture,'Enable','on');
                self.video = image(zeros(720,1280,3),'Parent',self.handles.axes_original_image);
                preview(self.cam, self.video);
            else
                % Camera is on. Stop camera and change button string.
                set(self.handles.pushbutton_start_stop,'String','Start Camera');
                set(self.handles.pushbutton_capture,'Enable','off');
                closePreview(self.cam);
                clear self.cam
            end
        end
        function pushbutton_capture_callback(self, varargin)
            set(self.handles.pushbutton_start_stop,'String','Start Camera');
            set(self.handles.pushbutton_capture,'Enable','off');
            self.img = snapshot(self.cam);
            closePreview(self.cam);
            imshow(self.img, 'Parent', self.handles.axes_encoded_image);
            imwrite(self.img,'images\snapshot.jpg')
            clear self.cam
            % Encode and send images
            self.photo='snapshot.jpg';
            set(self.handles.text_photo, 'String', 'USB cam');
            self.decoFile='mailDemo';
            self.mail = inputdlg('Please enter yout email', 'email', [1 50], {'example@gmail.com'});
            self.prepare_image('Primera Foto')
            self.send_image('Primera Foto')
            self.prepare_image('Segunda Foto')
            self.send_image('Segunda Foto')
        end
        function pushbutton_upload_callback(self, varargin)
            [name, path] = uigetfile({'*.jpg';'*.bmp';'*.png';'*.*'},'File Selector');
            self.photo = strcat(path, name);
            set(self.handles.text_photo, 'String', name);
        end
        function pushbutton_mail_demo_callback(self, varargin)
            self.mail = inputdlg('Please enter yout email', 'email', [1 50], {'example@gmail.com'});
            self.decoFile='mailDemo';
            self.prepare_image('Primera Foto')
            self.send_image('Primera Foto')
            self.prepare_image('Segunda Foto')
            self.send_image('Segunda Foto')
        end
        function send_image(self, asunto, varargin)
            % Mensaje
            messageBody = sprintf('Gracias por visitar nuestro stand.');
            messageBody = sprintf('%s\nPara descargar el c�digo visitar https://github.com/NEGU93/Steganography', messageBody);
            messageBody = sprintf('%s\n   ', messageBody);
            messageBody = sprintf('%s\n\nAlumnos:', messageBody);
            messageBody = sprintf('%s\n   Nahuel Aguilar, Agustin Barrachina, Gonzalo Castelli, Augusto Viotti Bozzini', messageBody);
            % Mail
            setpref('Internet','SMTP_Server','smtp.gmail.com');
            % TODO: poner el mail a usar para enviar las im�genes.
            setpref('Internet','E_mail','ejemplo@gmail.com');
            setpref('Internet','SMTP_Username','steganografia.itba@gmail.com');
            setpref('Internet','SMTP_Password','contrasenia');
            props = java.lang.System.getProperties;
            props.setProperty('mail.smtp.auth','true');
            props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
            props.setProperty('mail.smtp.socketFactory.port','465');
            
            sendmail(self.mail, asunto, messageBody, strcat('encoded/', self.decoFile, '.jpg'));
        end
        function prepare_image(self, msg, varargin)
            self.hiddenmessage = msg;
            set(self.handles.edit_hidemsg,'String', self.hiddenmessage);
            self.makesteg();
        end
        function makesteg(self, varargin)
          if isempty(self.hiddenmessage)
               msgbox('No message to hide was entered, please insert one');
               return
          end
          while strcmp(self.photo, '') || isempty(self.photo)
              self.pushbutton_upload_callback();
          end
            h = msgbox('encoding, please wait...', 'Loading');
           child = get(h, 'Children');
           delete(child(1));
           drawnow;
           set(self.handles.text_hidden_msg, 'String', self.hiddenmessage);
           %%para medir la psnr y ssim
           original=imread(self.photo);
           retocada=encoderStegFinal(self.hiddenmessage,self.photo, strcat('encoded\', self.decoFile, '.jpg'),self.quality,self.Spread,self.DCTSize,self.Repetition);
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
           % title('Mapa de Structural Similarity (An�lisis cualitativo)')
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
                msgbox('No valid file entered, verify the file is in the correct folder (../endoded/) and the file name is correcly written');
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
            set(self.handles.pushbutton_upload, 'Enable', 'on');
        end
        function radiobutton_decode_callback (self, varargin)
            self.Encode = false;
            set(self.handles.edit_hidemsg, 'Enable', 'off');
            set(self.handles.text_output_file, 'String', 'Encoded File:')
            set(self.handles.pushbutton_run, 'String', 'Decode');
            set(self.handles.pushbutton_upload, 'Enable', 'off');
        end
    end
end

