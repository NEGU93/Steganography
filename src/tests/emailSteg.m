%%Script para sacar foto y mandar mail
%%Feria 2017
%%Esteganografía en imágenes

%Esto funciona bien
%Recordar activar el permiso para apps menos seguras en la configuracion de
%google
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','E_mail','myAccount@gmail.com');
setpref('Internet','SMTP_Username','myAccount@gmail.com');
setpref('Internet','SMTP_Password','Contrasenia');
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

sendmail('gonzalo.castelli@hotmail.com','texttobesent') ;
%Para fotos
%sendmail('recipient@someserver.com','Hello from MATLAB!','Thanks for using sendmail.','C:\yourFileSystem\message.txt');

%%usar camara
webcamlist;
cam = webcam(1);
preview(cam);
img = snapshot(cam);
imwrite(img,'testing.jpg')
clear cam

%%poner letras.
%Posicion: [x y] arrancando desde la esquina superior izquierda
RGB = insertText(thegreengrass,[0 0],'Aguilar, Barrachina, Castelli, Viotti Bozzini','FontSize',30);
RGB1 = insertText(RGB,[0 700],'Gracias por visitar nuestro stand','FontSize',40,'BoxColor','red');
RGB = insertText(RGB1,[800 0],'ITBA - Esteganografia','FontSize',50,'BoxColor','blue');
imwrite(RGB,'testing.jpg')