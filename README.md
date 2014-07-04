Samsung Chromebook XE303C12 with Arch Linux
==========

Steg 1 ”Förberedelse”


1.	Stäng av datorn  

2.	Håll inne ESC och REFRESH(3 steg från ESC) och tryck på power-knappen.  

3.	När  du ser en vit skärm med ett stort utropstecken, tryck CTRL-D.  

4.	Tryck på Enter för att bekräfta att du vill stänga av ”OS verification”. Datorn kommer starta om och påbörja återställning av systemet. Detta tar ungefär 10-15 minuter.  


5.	När du är inloggad på datorn, tryck CTRL+ALT+T för att komma åt terminalen.


6.	Skriv shell i terminalen och sedan enter 


7.	Skriv sudo su, och sedan enter för att bli administratör.


8.	Skrev sedan crossystem dev_boot_usb=1 dev_boot_signed_only=0 och sedan enter för att tillåta datorn att boota från USB.


OBS! All fet text är kommandon som måste avslutas med ENTER-knappen
           Alla kommandon måste skrivas exakt som de står. 

Steg 2 "Installera linux" 
1.	Sätt in USB-minnet(Inte i den blåa porten).  

2.	Starta om datorn och tryck CTRL-U för att boota USB-minnet.  

3.	Ange root som användarnamn och tryck enter  

4.	Skriv sh setup och tryck enter.  

5.	Under installationens gång kommer den be dig att ange ett lösenord för kontot ”studerande”. 
