ORG 00H
	; 8 bitli hesap makinesi
	; R0 LCD�de komutlar ve veriler i�in kullanilir
	; R1 ilk sayiyi saklar
	; R2 islemi saklar
	; R3 ikinci sayiyi saklar
	; Port P3 - klavyeden giris
	; Port P2 - sifirlama + LCD�nin 2 pini (E VE RS))
	; Port P1 - LCD i�in �ikis
	YENISAYI EQU P2.7 ; P2.7, ikinci sayiyi yazarken y�ksek
	YENIRAKAM EQU P2.6 ; P2.6, bir sayinin ilk rakamini yazarken d�s�kt�r
	RS EQU P2.1 ; LCD'de RS
	RW EQU P2.2 ; LCD'de RW
; LCD'yi baslatmak ve belirli komutlari g�ndermek i�in hazirlik yapilir
MOV R0, #38H    	 	; LCD'yi baslatmak ve 5x7 matris kullanmak i�in komut
ACALL KOMUT       	; LCD�de komutu y�r�tmek i�in alt programi �agir
MOV R0, #0EH   		; Ekrani a�mak i�in komut
ACALL KOMUT
MOV R0, #80H   		; Ilk satira imle� koymak i�in komut
ACALL KOMUT
MOV R0, #01H    	 	; Ekrani temizlemek i�in komut
ACALL KOMUT
; LCD kontrol ve veri portlarini hazirlar
MOV R4, #00H   		; R4'� sifirla
MOV P2, #00H		; P2'yi sifirla (muhtemelen LCD kontrol portu)
MOV P3, #0FEH		; L1 yerinde LCD�yi baslat (1. satir aktif) (muhtemelen LCD veri portu)
MOV R3, #00H		; R3'� sifirla
MOV R1, #00H		; R1'i sifirla
MOV R2, #'+'		; Belirli bir karakter (muhtemelen arti isareti) i�in bir deger atanir

L1:	
	JNB P3.0, C1		; 0 ise C1'e atlar (her zaman 0'da baslar)
	JNB P3.1, C2		; 0 ise C2'e atlar
	JNB P3.2, C3		; 0 ise C3'e atlar
	JNB P3.3, C4		; 0 ise C4'e atlar
	SJMP L1			; satir kontrollerine d�nmek i�in
	
C1:	JNB P3.4, ATLA_DUGME_ON		; ON d�gmesine basilirsa atlar
	JNB P3.5, ATLA_DUGME_SIFIR	; '0' d�gmesine basilirsa atlar
	JNB P3.6, ATLA_DUGME_ESIT	; '=' d�gmesine basilirsa atlar
	JNB P3.7, ATLA_DUGME_ARTI	; '+' d�gmesine basilirsa atlar
	SETB P3.0			; 1. satiri deaktif et
	CLR P3.1			; 2. satiri aktif et
	SJMP L1				; satir kontrollerine d�nmek i�in	

C2:	JNB P3.4, ATLA_DUGME_1		; '1' d�gmesine basilirsa atlar
	JNB P3.5, ATLA_DUGME_2		; '2' d�gmesine basilirsa atlar
	JNB P3.6, ATLA_DUGME_3		; '3' d�gmesine basilirsa atlar
	JNB P3.7, ATLA_DUGME_EKSI	; '-' d�gmesine basilirsa atlar
	SETB P3.1			; 2. satiri deaktif et
	CLR P3.2			; 3. satiri aktif et
	SJMP L1				; satir kontrollerine d�nmek i�in	

C3:	JNB P3.4, ATLA_DUGME_4		; '4' d�gmesine basilirsa atlar
	JNB P3.5, ATLA_DUGME_5		; '5' d�gmesine basilirsa atlar
	JNB P3.6, ATLA_DUGME_6		; '6' d�gmesine basilirsa atlar
	JNB P3.7, ATLA_DUGME_CARPI	; 'x' d�gmesine basilirsa atlar
	SETB P3.2			; 3. satiri deaktif et
	CLR P3.3			; 4. satiri aktif et
	SJMP L1				; satir kontrollerine d�nmek i�in
	
C4:	JNB P3.4, ATLA_DUGME_7	; '7' d�gmesine basilirsa atlar
	JNB P3.5, ATLA_DUGME_8	; '8' d�gmesine basilirsa atlar	
	JNB P3.6, ATLA_DUGME_9		; '9' d�gmesine basilirsa atlar
	JNB P3.7, ATLA_DUGME_BOLME	; '/' d�gmesine basilirsa atlar
	SETB P3.3			
	CLR P3.0			
	LJMP L1

ATLA_DUGME_ON: LJMP DUGME_ON       ;DUGME_ON etiketine atla
ATLA_DUGME_SIFIR: LJMP DUGME_SIFIR ;DUGME_ZERO etiketine atla
ATLA_DUGME_1: LJMP DUGME_1         ;DUGME_1 etiketine atla
ATLA_DUGME_2: LJMP DUGME_2         ;DUGME_2 etiketine atla
ATLA_DUGME_3: LJMP DUGME_3         ;DUGME_3 etiketine atla
ATLA_DUGME_4: LJMP DUGME_4         ;DUGME_4 etiketine atla
ATLA_DUGME_5: LJMP DUGME_5         ;DUGME_5 etiketine atla
ATLA_DUGME_6: LJMP DUGME_6         ;DUGME_6 etiketine atla
ATLA_DUGME_7: LJMP DUGME_7         ;DUGME_7 etiketine atla
ATLA_DUGME_8: LJMP DUGME_8         ;DUGME_8 etiketine atla
ATLA_DUGME_9: LJMP DUGME_9         ;DUGME_9 etiketine atla
ATLA_DUGME_ARTI: LJMP DUGME_ARTI   ;DUGME_ARTI etiketine atla
ATLA_DUGME_EKSI: LJMP DUGME_EKSI   ;DUGME_EKSI etiketine atla
ATLA_DUGME_CARPI: LJMP DUGME_CARPI ;DUGME_CARPI etiketine atla
ATLA_DUGME_BOLME: LJMP DUGME_BOLME ;DUGME_BOLME etiketine atla
ATLA_DUGME_ESIT: LJMP DUGME_ESIT   ;DUGME_ESIT etiketine atla	

DUGME_ON: 	SETB P2.0	; reset'i aktiflestir
		LJMP L1
		
DUGME_SIFIR: 	MOV R0, #'0'	; '0' karakterini R0'a tasi	
		ACALL SAYI	; numarayi sakla
		ACALL YAZDIR	; karakteri LCD�de yazdir
		LJMP L1 		
;-----------
DUGME_ESIT:     MOV R0, #'='       ; '=' KARAKTERINI R0'E TASI
                ACALL YAZDIR       ; EKRANA YAZDIR
                ACALL TOPLAMA_SONUC    ; ISLEMI GER�EKLESTIR
                LJMP L1            

DUGME_ARTI:       MOV R0, #'+'       ; '+' KARAKTERINI R0'E TASI   
                ACALL ISLEM     ; ISLEMI R2'DE SAKLA
                ACALL YAZDIR      ; EKRANA YAZDIR
                LJMP L1           

DUGME_1:          MOV R0, #'1'       ; '1' KARAKTERINI R0'E TASI   
                ACALL SAYI      ; SAYIYI SAKLA
                ACALL YAZDIR      ; EKRANA YAZDIR
                LJMP L1            

DUGME_2:          MOV R0, #'2'       ; '2' KARAKTERINI R0'E TASI   
                ACALL SAYI       ; SAYIYI SAKLA
                ACALL YAZDIR      ; EKRANA YAZDIR
                LJMP L1               
                          
DUGME_3:          MOV R0, #'3'       ; '3' KARAKTERINI R0'E TASI   
                ACALL SAYI       ; SAYIYI SAKLA
                ACALL YAZDIR      ; EKRANA YAZDIR
                LJMP L1            

DUGME_EKSI:      MOV R0, #'-'       ; '-' KARAKTERINI R0'E TASI   
                ACALL ISLEM     ; ISLEMI R2'DE SAKLA
                ACALL YAZDIR      ; EKRANA YAZDIR
                LJMP L1

DUGME_4:          MOV R0, #'4'       ; '4' KARAKTERINI R0'E TASI   
                ACALL SAYI       ; SAYIYI SAKLA
                ACALL YAZDIR      ; EKRANA YAZDIR
                LJMP L1            

DUGME_5:          MOV R0, #'5'       ; '5' KARAKTERINI R0'E TASI   
                ACALL SAYI       ; SAYIYI SAKLA
                ACALL YAZDIR      ; EKRANA YAZDIR
                LJMP L1            

DUGME_6:          MOV R0, #'6'       ; '6' KARAKTERINI R0'E TASI   
                ACALL SAYI       ; SAYIYI SAKLA
                ACALL YAZDIR      ; EKRANA YAZDIR
                LJMP L1            

DUGME_CARPI:      MOV R0, #'*'        ; '*' KARAKTERINI R0'E TASI   
                ACALL ISLEM     ; ISLEMI R2'DE SAKLA
                ACALL YAZDIR      ; EKRANA YAZDIR
                LJMP L1            
DUGME_7:          MOV R0, #'7'       ; '7' KARAKTERINI R0'E TASI   
                ACALL SAYI       ; SAYIYI SAKLA
                ACALL YAZDIR      ; EKRANA YAZDIR
                LJMP L1            
DUGME_8:          MOV R0, #'8'       ; '8' KARAKTERINI R0'E TASI   
                ACALL SAYI       ; SAYIYI SAKLA
                ACALL YAZDIR      ; EKRANA YAZDIR
                LJMP L1            
DUGME_9:          MOV R0, #'9'       ; '9' KARAKTERINI R0'E TASI   
                ACALL SAYI       ; SAYIYI SAKLA
                ACALL YAZDIR      ; EKRANA YAZDIR
               LJMP L1      
DUGME_BOLME:    MOV R0, #'/'       ; '/' KARAKTERINI R0'E TASI   
                ACALL ISLEM    ; ISLEMI R2'DE SAKLA
                ACALL YAZDIR      ; EKRANA YAZDIR
                LJMP L1

YAZDIR:   
    MOV P1, R0  ; KARAKTERI �IKISA (P1) TASI 
    SETB RS     ; RS'YI (REGISTER SELECT) VERI MODUNA AYARLA
    SETB RW     ; LCD'DE OKUMA/YAZMA IZININI SERBEST BIRAK (Y�KSEK SEVIYE)
    CLR RW      
	ACALL DELAY ; 0.25s GE�IKME �AGIR (BIRDEN FAZLA KEZ YAZDIRMAYI �NLEMEK I�IN)
    RET         ; Alt programdan d�n
;!!	
KOMUT:   
    MOV P1, R0  ; KOMUTU �IKISA TASI - LCD GIRISI
    CLR RS      ; RS'YI (REGISTER SELECT) KOMUT MODUNA AYARLA
    SETB RW     ; LCD'DE OKUMA/YAZMA IZININI SERBEST BIRAK (Y�KSEK SEVIYE)
    CLR RW      
    ACALL DELAY ; 0.25s GE�IKME �AGIR
    RET  

SAYI: 
    JB YENISAYI, IKINCI_NUMARA    ; EGER IKINCI SAYIYSA ATLAR
    JB YENIRAKAM, YENI_RAKAM_ISLEM    ; EGER ILK SAYININ ILK HANESI DEGILSE ATLAR
    MOV A, R0                  ; KARAKTERI AK�M�LAT�RE TASIR
    SUBB A, #30H               ; BU KARAKTERI SAYIYA D�N�ST�R�R
    MOV R1, A                  ; BU SAYIYI R1'E KAYDEDER
    SETB YENIRAKAM               ; ILK_HANE_KAYDEDILDI PININI AYARLA => ILK SAYININ ILK HANESI KAYDEDILDI
    RET                        

;-------

YENI_RAKAM_ISLEM:         ; Alt program baslangici
    MOV A, R0      ; R0'daki degeri A'ya kopyala
    MOV B, #10D     ; B'ye 10 sayisini y�kle (�arpmak i�in)
    SUBB A, #30H    ; '0' karakterinin ASCII degerini �ikararak rakamin degerini elde  et
    MOV R7, A       ; Rakamin degerini R7'ye kopyala
    MOV A, R1       ; R1'deki degeri A'ya kopyala
    MUL AB          ; A ve B'yi �arpar, sonucu A ve B'ye yazar (�arpim sonucunu elde et)
    MOV R6, B       ; �arpim sonucunu R6'ya kopyala
    CJNE R6, #00H, ATLA_TASMA   ; Eger �arpim sonucu sifirdan farkli ise ATLA_ TASMA 'ya atla
    ADD A, R7       ; �arpim sonucu sifirsa, rakamin degerini toplama ekle
    JC ATLA_TASMA    ; Eger tasma olduysa, ATLA_ TASMA ya atla
    MOV R1, A       ; Sonucu R1'e kopyala
    SETB YENIRAKAM    ; ILK_HANE_KAYDEDILDI bayragini ayarla
    RET             ; Alt programdan d�n

IKINCI_NUMARA:                 ; Ikinci rakamin alinmasi i�in alt program baslangici
    JB YENIRAKAM, YENI_RAKAM_ISLEM2 ; Eger ILK_HANE_KAYDEDILDI bayragi set edilmisse (yani ilk rakamin islenmesi tamamlandiysa),YENI_RAKAM_ISLEM2 etiketine atla
    MOV A, R0               ; A'ya R0 kaydindaki degeri kopyala (ikinci rakamin ASCII degeri)
    SUBB A, #30H            ; '0' karakterinin ASCII degerini �ikararak, rakamin degerini elde et
    MOV R3, A               ; Rakamin degerini R3 kaydinda sakla
    SETB YENIRAKAM            ; ILK_HANE_KAYDEDILDI bayragini set et (ilk rakam islendi)
    RET                     ; Alt programdan d�n


YENI_RAKAM_ISLEM2:                ; Ikinci rakamin islenmesi i�in alt program baslangici
    MOV A, R0               ; A'ya R0 kaydindaki degeri kopyala (yeni rakamin ASCII degeri)
    MOV B, #10D             ; B'ye 10 sayisini y�kle (�arpmak i�in)
    SUBB A, #30H            ; '0' karakterinin ASCII degerini �ikararak rakamin degerini elde et
    MOV R7, A               ; Rakamin degerini R7 kaydina kopyala
    MOV A, R3               ; A'ya R3 kaydindaki degeri kopyala (ikinci sayinin degeri)
    MUL AB                  ; A ve B'yi �arpar, sonucu A ve B'ye yazar (ikinci sayiyi 10 ile �arpar)
    MOV R6, B               ; �arpimin sonucunun daha anlamli kismini R6'ya kopyala
    CJNE R6, #00H, ATLA_TASMA ; Eger R6'da bir deger varsa, 8 biti asmis demektir (tasma kontrol�)
    ADD A, R7               ; Eger tasma olmamissa, ikinci sayiyi 10 ile �arparak elde edilen degeri ekler
    JC ATLA_TASMA        ; Eger tasma olursa, ATLA_ TASMA etiketine atla
    MOV R3, A               ; Sonucu R3 kaydina kopyala (ikinci sayinin yeni degeri)
    SETB YENIRAKAM           ; ILK_HANE_KAYDEDILDI bayragini ayarla (yeni rakam islendi)
	RET                     ; Alt programdan d�n

ISLEM:                   ; Islem belirleme alt programi baslangici
    SETB YENISAYI            ; YENI_SAYI bayragini set et, bir sonraki rakamin ikinci sayiya ait oldugunu belirtir
    CLR YENIRAKAM             ; ILK_HANE_KAYDEDILDI bayragini sifirla, bir sonraki rakamin ilk sayiya ait oldugunu belirtir
    MOV A, R0               ; A'ya R0 kaydindaki degeri kopyala (islem operat�r�)
    MOV R2, A               ; R2'ye A'daki degeri kopyala (islem operat�r�n� sakla)
    RET                     ; Alt programdan d�n
	


TOPLAMA_SONUC: ; Sonucu hesapla alt programi baslangici
    CJNE R2, #'+', CIKARMA    ; Eger islem operat�r� '+' ise CIKARMA etiketine atla (toplama islemi)
    MOV A, R1                   ; A'ya R1 kaydindaki degeri kopyala (ilk sayiyi al)
    CLR C                       ; Carry'yi temizle
    ADD A, R3                   ; Ilk sayiya ikinci sayiyi ekle
    JC ATLA_TASMA           ; Eger tasma olduysa, ATLA_ TASMA etiketine atla
    MOV R5, #0H                 ; R5 kaydina 0 degerini koy (b�lme islemi i�in gereken ayar)
    MOV R4, A                   ; Sonucu R4 kaydina kopyala
    LJMP EKRANA_YAZDIRMA               ; EKRANA_YAZDIRMA etiketine atla (sonucu yazdir)
;!!!!!!

CIKARMA:                      ; �ikarma islemi
    CJNE R2, #'-', CARPMA    ; Eger islem operat�r� '-' ise CARPMA etiketine atla (�ikarma islemi)
    MOV A, R1                   ; A'ya R1 kaydindaki degeri kopyala (ilk sayiyi al)
    CLR C                       ; Carry'yi temizle
    SUBB A, R3                  ; Ilk sayidan ikinci sayiyi �ikar
    JC ATLA_TASMA            ; Eger tasma olduysa, ATLA_ TASMA etiketine atla
    MOV R5, #0H                 ; R5 kaydina 0 degerini koy (b�lme islemi i�in gereken ayar)
    MOV R4, A                   ; Sonucu R4 kaydina kopyala
    LJMP EKRANA_YAZDIRMA               ; EKRANA_YAZDIRMA etiketine atla (sonucu yazdir)

CARPMA:                  ; �arpma islemi
    CJNE R2, #'*', BOLME     ; Eger islem operat�r� '*' ise BOLME etiketine atla (�arpma islemi)
    MOV A, R1                  ; A'ya R1 kaydindaki degeri kopyala (ilk sayiyi al)
    MOV B, R3                  ; B'ye R3 kaydindaki degeri kopyala (ikinci sayiyi al)
    MUL AB                     ; A ve B'yi �arpar, sonucu A ve B'ye yazar (�arpma islemi)
    MOV R7, B                  ; �arpimin sonucunun daha anlamli kismini R7'ye kopyala
    CJNE R7, #0H, TASMA      ; Eger R7'de bir deger varsa, 8 biti asmis demektir (tasma kontrol�)
    MOV R5, #0H                ; R5 kaydina 0 degerini koy (b�lme islemi i�in gereken ayar)
    MOV R4, A                  ; Sonucu R4 kaydina kopyala
    LJMP EKRANA_YAZDIRMA             ; EKRANA_YAZDIRMA etiketine atla (sonucu yazdir)

BOLME:                    ; B�lme islemi
    MOV A, R1               ; A'ya R1 kaydindaki degeri kopyala (b�l�neni al)
    MOV B, R3               ; B'ye R3 kaydindaki degeri kopyala (b�leni al)
    DIV AB                  ; A'yi B'ye b�l, sonucu A'ya, kalani B'ye yaz
    MOV R4, A               ; Sonucu R4 kaydina kopyala
    MOV R5, B               ; Kalani R5 kaydina kopyala
    LJMP EKRANA_YAZDIRMA           ; EKRANA_YAZDIRMA etiketine atla (sonucu yazdir)

ATLA_TASMA:              ; Tasma durumunda atlanacak yer
    LJMP TASMA            ; TASMA etiketine atla (tasma durumunu islemek i�in)

EKRANA_YAZDIRMA:                        ; Sonucu yazdirma islemi baslangici
    CJNE R3, #0D, NORMAL        ; Eger ikinci sayi 0 degilse, NORMAL etiketine atla
    CJNE R2, #'/', NORMAL       ; Eger islem operat�r� b�lme isareti degilse, NORMAL etiketine atla
    MOV R0, #0C0H               ; Eger b�lme islemi sirasinda ikinci sayi 0 ise, imleci ikinci satira tasi
    ACALL KOMUT               ; LCD ekraninda belirtilen komutu �alistir
    MOV DPTR, #HATA         ; Hata mesajinin bulundugu bellek adresini DPTR kaydina y�kle
    CLR C                       ; Tasma (carry) bayragini temizle
    MOV R7, #0D                 ; R7 kaydina 0 degerini koy

PROX:                    ; Sonraki karakteri almak i�in islem baslangici
    MOV A, R7            ; R7 kaydindaki i�erigi A kaydina kopyala
    MOVC A, @A+DPTR      ; A+DPTR adresindeki i�erigi A'ya kopyala
    MOV R0, A            ; Sonucu R0 kaydina kopyala
    ACALL YAZDIR        ; LCD'ye yazdir
    INC R7               ; Eger R7 sifir degilse, R7'yi bir artir
    JNZ PROX             ; Eger R7 sifir degilse, SIRAYLA_KARAKTER_ALMA etiketine atla
    RET                  ; Alt programdan d�n

;-----

NORMAL:
	MOV R7, #100D ; R7'ye 100 degerini y�kle
	CLR C ; Tasima bayragini temizle
 	SUBB A, R7 ; A'dan R7'deki degeri �ikar-
	JC KUCUK100; Eger tasima bayragi tasinirsa, MENOR100 etiketine atla
	MOV A, R4; A'yi R4'e y�kle (100'den b�y�k oldugu i�in 3 basamakli sayi
	MOV B, R7 ; B'ye R7'yi y�kle (100)
	DIV AB; A'yi B'ye b�l, sonu� A'da, kalan B'de olur
	ADD A, #30H ; A'daki sayiyi ASCII karakterine d�n�st�r
	MOV R0, A; Karakteri ekrana g�stermek i�in R0'a y�kle
	ACALL YAZDIR; Karakteri ekrana g�stermek i�in alt programi �agir
	MOV R4, B; B'deki kalani (y�zler basamagi) R4'e y�kle
 	MOV A, B; B'deki kalani (y�zler basamagi) R4'e y�kle
	MOV R7, #10D ; R7'ye 10 degerini y�kle
	MOV B, R7 ; B'ye R7'yi y�kle (10)
	DIV AB ; A'yi B'ye b�l, sonu� A'da, kalan B'de olur
	ADD A, #30H; A'daki sayiyi ASCII karakterine d�n�st�r
	MOV R0, A 	; Karakteri ekrana g�stermek i�in R0'a y�kle
	ACALL YAZDIR; Karakteri ekrana g�stermek i�in alt programi �agir
	MOV A, B; B'deki kalani (onlar basamagi) A'ya y�kl              	
	ADD A, #30H ; ASCII karakterine d�n�st�r
	MOV R0, A ; Karakteri ekrana g�stermek i�in R0'a y�kle
	ACALL YAZDIR; Karakteri ekrana g�stermek i�in alt programi �agir
	CJNE R5, #00H, DECIMAL ; Eger R5 0 degilse, DECIMAL etiketine atla
	;!!! DECIMAL DEGISMIS I BAK
	RET; Alt programdan (subroutine) d�n
	
KUCUK100:
	MOV R7, #10D; 10 sayisini R7 kaydediciye y�kle
 	CLR C; Tasima (carry) bayragini temizle
 	MOV A, R4; R4'teki degeri A'ya y�kle
 	SUBB A, R7; R7'den A'daki degeri �ikar
 	JC KUCUK10; Eger tasima bayragi tasinmissa (1 ise), MENOR10 etiketine atla
 	MOV A, R4; A'daki degeri R4'ten tekrar A'ya y�kle (R4 degismedi)
 	MOV B, R7; B'deki degeri R7'ye (10) y�kle
 	DIV AB; A'yi B'ye b�l, sonu� A'da, kalan B'de olur
	ADD A, #30H; A'daki sayiyi ASCII karakterine d�n�st�r
	MOV R0, A; Karakteri ekrana g�stermek i�in R0'a y�kle
	ACALL YAZDIR; Ekrana karakteri g�stermek i�in alt programi �agir
	MOV A, B; Kalani (B) ekrana g�stermek i�in A'ya y�kle
	ADD A, #30H; Kalani (B) ASCII karakterine d�n�st�r
	MOV R0, A; Karakteri ekrana g�stermek i�in R0'a y�kle
	ACALL YAZDIR; Ekrana karakteri g�stermek i�in alt programi �agir
	CJNE R5, #00H, DECIMAL; Eger R5 0 degilse, DECIMAL etiketine atla
	RET; Alt programdan (subroutine) d�n

KUCUK10:
	MOV A, R4; R4'teki degeri A'ya y�kle
	ADD A, #30H; ASCII karakterine d�n�st�rmek i�in 30H (sayilarin ASCII degeri) ekleyi 
	MOV R0, A; Karakteri ekrana g�stermek i�in R0'a y�kle
	ACALL YAZDIR; Ekrana karakteri g�stermek i�in alt programi �agir
  	CJNE R5, #00H, DECIMAL; Eger R5 0 degilse, DECIMAL etiketine atla
	RET; Alt programdan (subroutine) d�n

TASMA:
 	MOV R0, #0C0H; Ekranda mesaji ikinci satira yazmak i�in R0'a 0C0H adresini y�kler
	ACALL KOMUT; LCD ekraninda belirli bir komutu y�r�tmek i�in alt programi �agirir
 	MOV DPTR, #HATA2; Hata mesajini g�stermek i�in DPTR'yi MSGERRO2 adresine ayarlar
 	CLR C; Tasima bayragini temizler
	MOV R7, #0D; D�ng� i�in saya� olarak R7'ye 0D degerini y�kler
	
PROX2:
	MOV A, R7; R7'deki degeri A'ya y�kle	
	MOVC A, @A+DPTR; DPTR'nin g�sterdigi bellek adresindeki veriyi A'ya y�kle (MOVC ile)
 	MOV R0, A; A'daki degeri R0'a y�kle	
 	ACALL YAZDIR; Karakteri ekrana g�stermek i�in alt programi �agir
 	JZ FIM; Eger A (R7'nin degeri) 0 ise, FIM etiketine atla
 	INC R7; R7'yi bir arttir
	SJMP PROX2; PROX2 etiketine atla (d�ng�y� tekrar t)
FIM:
	RET; Alt programdan (subroutine) d�n
	
DECIMAL:
	MOV R0, #'.'; Nokta karakterini R0'a y�kle
	ACALL YAZDIR; Karakteri ekrana g�stermek i�in alt programi �agir
	MOV A, R5; R5'teki degeri A'ya y�kle
	MOV B, #10D; 10 sayisini B'ye y�kle
	MUL AB; A ve B'yi �arp ve sonucu A'ya y�kle
	MOV B, R3; R3'teki degeri B'ye y�kle
 	DIV AB; A'yi B'ye b�l, sonu� A'da, kalan B'de olur
 	ADD A, #30H; A'daki sayiyi ASCII karakterine d�n�st�r
 	MOV R0, A; Karakteri ekrana g�stermek i�in R0'a y�kle
 	ACALL YAZDIR; Karakteri ekrana g�stermek i�in alt programi �agir
 	RET; Alt programdan (subroutine) d�n
	
DELAY:
 	MOV 62, #2; 62 numarali register'e 2 degerini y�kle
DELAY1:
 	MOV 61, #250; 61 numarali register'e 250 degerini y�kle
DELAY2:
 	MOV 60, #250	; 60 numarali register'e 250 degerini y�kle
 	DJNZ 60, $; 60 numarali register'deki deger sifir olana kadar d�ng�y� devam ettir
 	DJNZ 61, DELAY2; 61 numarali register'deki deger sifir olana kadar d�ng�y� devam ettir
 	DJNZ 62, DELAY1; 62 numarali register'deki deger sifir olana kadar d�ng�y� devam ettir
	RET; Alt programdan (subroutine) d�n	
;DB - DEFINE BYTE
	
HATA: DB 'HATA:0 A BOLME',0 ;

HATA2: DB 'TASMA HATASI!',0 ;Hata mesaji 2: Tasma hatasi


END










