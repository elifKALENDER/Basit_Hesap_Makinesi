ORG 00H
	; 8 bitli hesap makinesi
	; R0 LCD’de komutlar ve veriler için kullanilir
	; R1 ilk sayiyi saklar
	; R2 islemi saklar
	; R3 ikinci sayiyi saklar
	; Port P3 - klavyeden giris
	; Port P2 - sifirlama + LCD’nin 2 pini (E VE RS))
	; Port P1 - LCD için çikis
	YENISAYI EQU P2.7 ; P2.7, ikinci sayiyi yazarken yüksek
	YENIRAKAM EQU P2.6 ; P2.6, bir sayinin ilk rakamini yazarken düsüktür
	RS EQU P2.1 ; LCD'de RS
	RW EQU P2.2 ; LCD'de RW
; LCD'yi baslatmak ve belirli komutlari göndermek için hazirlik yapilir
MOV R0, #38H    	 	; LCD'yi baslatmak ve 5x7 matris kullanmak için komut
ACALL KOMUT       	; LCD’de komutu yürütmek için alt programi çagir
MOV R0, #0EH   		; Ekrani açmak için komut
ACALL KOMUT
MOV R0, #80H   		; Ilk satira imleç koymak için komut
ACALL KOMUT
MOV R0, #01H    	 	; Ekrani temizlemek için komut
ACALL KOMUT
; LCD kontrol ve veri portlarini hazirlar
MOV R4, #00H   		; R4'ü sifirla
MOV P2, #00H		; P2'yi sifirla (muhtemelen LCD kontrol portu)
MOV P3, #0FEH		; L1 yerinde LCD’yi baslat (1. satir aktif) (muhtemelen LCD veri portu)
MOV R3, #00H		; R3'ü sifirla
MOV R1, #00H		; R1'i sifirla
MOV R2, #'+'		; Belirli bir karakter (muhtemelen arti isareti) için bir deger atanir

L1:	
	JNB P3.0, C1		; 0 ise C1'e atlar (her zaman 0'da baslar)
	JNB P3.1, C2		; 0 ise C2'e atlar
	JNB P3.2, C3		; 0 ise C3'e atlar
	JNB P3.3, C4		; 0 ise C4'e atlar
	SJMP L1			; satir kontrollerine dönmek için
	
C1:	JNB P3.4, ATLA_DUGME_ON		; ON dügmesine basilirsa atlar
	JNB P3.5, ATLA_DUGME_SIFIR	; '0' dügmesine basilirsa atlar
	JNB P3.6, ATLA_DUGME_ESIT	; '=' dügmesine basilirsa atlar
	JNB P3.7, ATLA_DUGME_ARTI	; '+' dügmesine basilirsa atlar
	SETB P3.0			; 1. satiri deaktif et
	CLR P3.1			; 2. satiri aktif et
	SJMP L1				; satir kontrollerine dönmek için	

C2:	JNB P3.4, ATLA_DUGME_1		; '1' dügmesine basilirsa atlar
	JNB P3.5, ATLA_DUGME_2		; '2' dügmesine basilirsa atlar
	JNB P3.6, ATLA_DUGME_3		; '3' dügmesine basilirsa atlar
	JNB P3.7, ATLA_DUGME_EKSI	; '-' dügmesine basilirsa atlar
	SETB P3.1			; 2. satiri deaktif et
	CLR P3.2			; 3. satiri aktif et
	SJMP L1				; satir kontrollerine dönmek için	

C3:	JNB P3.4, ATLA_DUGME_4		; '4' dügmesine basilirsa atlar
	JNB P3.5, ATLA_DUGME_5		; '5' dügmesine basilirsa atlar
	JNB P3.6, ATLA_DUGME_6		; '6' dügmesine basilirsa atlar
	JNB P3.7, ATLA_DUGME_CARPI	; 'x' dügmesine basilirsa atlar
	SETB P3.2			; 3. satiri deaktif et
	CLR P3.3			; 4. satiri aktif et
	SJMP L1				; satir kontrollerine dönmek için
	
C4:	JNB P3.4, ATLA_DUGME_7	; '7' dügmesine basilirsa atlar
	JNB P3.5, ATLA_DUGME_8	; '8' dügmesine basilirsa atlar	
	JNB P3.6, ATLA_DUGME_9		; '9' dügmesine basilirsa atlar
	JNB P3.7, ATLA_DUGME_BOLME	; '/' dügmesine basilirsa atlar
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
		ACALL YAZDIR	; karakteri LCD’de yazdir
		LJMP L1 		
;-----------
DUGME_ESIT:     MOV R0, #'='       ; '=' KARAKTERINI R0'E TASI
                ACALL YAZDIR       ; EKRANA YAZDIR
                ACALL TOPLAMA_SONUC    ; ISLEMI GERÇEKLESTIR
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
    MOV P1, R0  ; KARAKTERI ÇIKISA (P1) TASI 
    SETB RS     ; RS'YI (REGISTER SELECT) VERI MODUNA AYARLA
    SETB RW     ; LCD'DE OKUMA/YAZMA IZININI SERBEST BIRAK (YÜKSEK SEVIYE)
    CLR RW      
	ACALL DELAY ; 0.25s GEÇIKME ÇAGIR (BIRDEN FAZLA KEZ YAZDIRMAYI ÖNLEMEK IÇIN)
    RET         ; Alt programdan dön
;!!	
KOMUT:   
    MOV P1, R0  ; KOMUTU ÇIKISA TASI - LCD GIRISI
    CLR RS      ; RS'YI (REGISTER SELECT) KOMUT MODUNA AYARLA
    SETB RW     ; LCD'DE OKUMA/YAZMA IZININI SERBEST BIRAK (YÜKSEK SEVIYE)
    CLR RW      
    ACALL DELAY ; 0.25s GEÇIKME ÇAGIR
    RET  

SAYI: 
    JB YENISAYI, IKINCI_NUMARA    ; EGER IKINCI SAYIYSA ATLAR
    JB YENIRAKAM, YENI_RAKAM_ISLEM    ; EGER ILK SAYININ ILK HANESI DEGILSE ATLAR
    MOV A, R0                  ; KARAKTERI AKÜMÜLATÖRE TASIR
    SUBB A, #30H               ; BU KARAKTERI SAYIYA DÖNÜSTÜRÜR
    MOV R1, A                  ; BU SAYIYI R1'E KAYDEDER
    SETB YENIRAKAM               ; ILK_HANE_KAYDEDILDI PININI AYARLA => ILK SAYININ ILK HANESI KAYDEDILDI
    RET                        

;-------

YENI_RAKAM_ISLEM:         ; Alt program baslangici
    MOV A, R0      ; R0'daki degeri A'ya kopyala
    MOV B, #10D     ; B'ye 10 sayisini yükle (çarpmak için)
    SUBB A, #30H    ; '0' karakterinin ASCII degerini çikararak rakamin degerini elde  et
    MOV R7, A       ; Rakamin degerini R7'ye kopyala
    MOV A, R1       ; R1'deki degeri A'ya kopyala
    MUL AB          ; A ve B'yi çarpar, sonucu A ve B'ye yazar (çarpim sonucunu elde et)
    MOV R6, B       ; Çarpim sonucunu R6'ya kopyala
    CJNE R6, #00H, ATLA_TASMA   ; Eger çarpim sonucu sifirdan farkli ise ATLA_ TASMA 'ya atla
    ADD A, R7       ; Çarpim sonucu sifirsa, rakamin degerini toplama ekle
    JC ATLA_TASMA    ; Eger tasma olduysa, ATLA_ TASMA ya atla
    MOV R1, A       ; Sonucu R1'e kopyala
    SETB YENIRAKAM    ; ILK_HANE_KAYDEDILDI bayragini ayarla
    RET             ; Alt programdan dön

IKINCI_NUMARA:                 ; Ikinci rakamin alinmasi için alt program baslangici
    JB YENIRAKAM, YENI_RAKAM_ISLEM2 ; Eger ILK_HANE_KAYDEDILDI bayragi set edilmisse (yani ilk rakamin islenmesi tamamlandiysa),YENI_RAKAM_ISLEM2 etiketine atla
    MOV A, R0               ; A'ya R0 kaydindaki degeri kopyala (ikinci rakamin ASCII degeri)
    SUBB A, #30H            ; '0' karakterinin ASCII degerini çikararak, rakamin degerini elde et
    MOV R3, A               ; Rakamin degerini R3 kaydinda sakla
    SETB YENIRAKAM            ; ILK_HANE_KAYDEDILDI bayragini set et (ilk rakam islendi)
    RET                     ; Alt programdan dön


YENI_RAKAM_ISLEM2:                ; Ikinci rakamin islenmesi için alt program baslangici
    MOV A, R0               ; A'ya R0 kaydindaki degeri kopyala (yeni rakamin ASCII degeri)
    MOV B, #10D             ; B'ye 10 sayisini yükle (çarpmak için)
    SUBB A, #30H            ; '0' karakterinin ASCII degerini çikararak rakamin degerini elde et
    MOV R7, A               ; Rakamin degerini R7 kaydina kopyala
    MOV A, R3               ; A'ya R3 kaydindaki degeri kopyala (ikinci sayinin degeri)
    MUL AB                  ; A ve B'yi çarpar, sonucu A ve B'ye yazar (ikinci sayiyi 10 ile çarpar)
    MOV R6, B               ; Çarpimin sonucunun daha anlamli kismini R6'ya kopyala
    CJNE R6, #00H, ATLA_TASMA ; Eger R6'da bir deger varsa, 8 biti asmis demektir (tasma kontrolü)
    ADD A, R7               ; Eger tasma olmamissa, ikinci sayiyi 10 ile çarparak elde edilen degeri ekler
    JC ATLA_TASMA        ; Eger tasma olursa, ATLA_ TASMA etiketine atla
    MOV R3, A               ; Sonucu R3 kaydina kopyala (ikinci sayinin yeni degeri)
    SETB YENIRAKAM           ; ILK_HANE_KAYDEDILDI bayragini ayarla (yeni rakam islendi)
	RET                     ; Alt programdan dön

ISLEM:                   ; Islem belirleme alt programi baslangici
    SETB YENISAYI            ; YENI_SAYI bayragini set et, bir sonraki rakamin ikinci sayiya ait oldugunu belirtir
    CLR YENIRAKAM             ; ILK_HANE_KAYDEDILDI bayragini sifirla, bir sonraki rakamin ilk sayiya ait oldugunu belirtir
    MOV A, R0               ; A'ya R0 kaydindaki degeri kopyala (islem operatörü)
    MOV R2, A               ; R2'ye A'daki degeri kopyala (islem operatörünü sakla)
    RET                     ; Alt programdan dön
	


TOPLAMA_SONUC: ; Sonucu hesapla alt programi baslangici
    CJNE R2, #'+', CIKARMA    ; Eger islem operatörü '+' ise CIKARMA etiketine atla (toplama islemi)
    MOV A, R1                   ; A'ya R1 kaydindaki degeri kopyala (ilk sayiyi al)
    CLR C                       ; Carry'yi temizle
    ADD A, R3                   ; Ilk sayiya ikinci sayiyi ekle
    JC ATLA_TASMA           ; Eger tasma olduysa, ATLA_ TASMA etiketine atla
    MOV R5, #0H                 ; R5 kaydina 0 degerini koy (bölme islemi için gereken ayar)
    MOV R4, A                   ; Sonucu R4 kaydina kopyala
    LJMP EKRANA_YAZDIRMA               ; EKRANA_YAZDIRMA etiketine atla (sonucu yazdir)
;!!!!!!

CIKARMA:                      ; Çikarma islemi
    CJNE R2, #'-', CARPMA    ; Eger islem operatörü '-' ise CARPMA etiketine atla (çikarma islemi)
    MOV A, R1                   ; A'ya R1 kaydindaki degeri kopyala (ilk sayiyi al)
    CLR C                       ; Carry'yi temizle
    SUBB A, R3                  ; Ilk sayidan ikinci sayiyi çikar
    JC ATLA_TASMA            ; Eger tasma olduysa, ATLA_ TASMA etiketine atla
    MOV R5, #0H                 ; R5 kaydina 0 degerini koy (bölme islemi için gereken ayar)
    MOV R4, A                   ; Sonucu R4 kaydina kopyala
    LJMP EKRANA_YAZDIRMA               ; EKRANA_YAZDIRMA etiketine atla (sonucu yazdir)

CARPMA:                  ; Çarpma islemi
    CJNE R2, #'*', BOLME     ; Eger islem operatörü '*' ise BOLME etiketine atla (çarpma islemi)
    MOV A, R1                  ; A'ya R1 kaydindaki degeri kopyala (ilk sayiyi al)
    MOV B, R3                  ; B'ye R3 kaydindaki degeri kopyala (ikinci sayiyi al)
    MUL AB                     ; A ve B'yi çarpar, sonucu A ve B'ye yazar (çarpma islemi)
    MOV R7, B                  ; Çarpimin sonucunun daha anlamli kismini R7'ye kopyala
    CJNE R7, #0H, TASMA      ; Eger R7'de bir deger varsa, 8 biti asmis demektir (tasma kontrolü)
    MOV R5, #0H                ; R5 kaydina 0 degerini koy (bölme islemi için gereken ayar)
    MOV R4, A                  ; Sonucu R4 kaydina kopyala
    LJMP EKRANA_YAZDIRMA             ; EKRANA_YAZDIRMA etiketine atla (sonucu yazdir)

BOLME:                    ; Bölme islemi
    MOV A, R1               ; A'ya R1 kaydindaki degeri kopyala (bölüneni al)
    MOV B, R3               ; B'ye R3 kaydindaki degeri kopyala (böleni al)
    DIV AB                  ; A'yi B'ye böl, sonucu A'ya, kalani B'ye yaz
    MOV R4, A               ; Sonucu R4 kaydina kopyala
    MOV R5, B               ; Kalani R5 kaydina kopyala
    LJMP EKRANA_YAZDIRMA           ; EKRANA_YAZDIRMA etiketine atla (sonucu yazdir)

ATLA_TASMA:              ; Tasma durumunda atlanacak yer
    LJMP TASMA            ; TASMA etiketine atla (tasma durumunu islemek için)

EKRANA_YAZDIRMA:                        ; Sonucu yazdirma islemi baslangici
    CJNE R3, #0D, NORMAL        ; Eger ikinci sayi 0 degilse, NORMAL etiketine atla
    CJNE R2, #'/', NORMAL       ; Eger islem operatörü bölme isareti degilse, NORMAL etiketine atla
    MOV R0, #0C0H               ; Eger bölme islemi sirasinda ikinci sayi 0 ise, imleci ikinci satira tasi
    ACALL KOMUT               ; LCD ekraninda belirtilen komutu çalistir
    MOV DPTR, #HATA         ; Hata mesajinin bulundugu bellek adresini DPTR kaydina yükle
    CLR C                       ; Tasma (carry) bayragini temizle
    MOV R7, #0D                 ; R7 kaydina 0 degerini koy

PROX:                    ; Sonraki karakteri almak için islem baslangici
    MOV A, R7            ; R7 kaydindaki içerigi A kaydina kopyala
    MOVC A, @A+DPTR      ; A+DPTR adresindeki içerigi A'ya kopyala
    MOV R0, A            ; Sonucu R0 kaydina kopyala
    ACALL YAZDIR        ; LCD'ye yazdir
    INC R7               ; Eger R7 sifir degilse, R7'yi bir artir
    JNZ PROX             ; Eger R7 sifir degilse, SIRAYLA_KARAKTER_ALMA etiketine atla
    RET                  ; Alt programdan dön

;-----

NORMAL:
	MOV R7, #100D ; R7'ye 100 degerini yükle
	CLR C ; Tasima bayragini temizle
 	SUBB A, R7 ; A'dan R7'deki degeri çikar-
	JC KUCUK100; Eger tasima bayragi tasinirsa, MENOR100 etiketine atla
	MOV A, R4; A'yi R4'e yükle (100'den büyük oldugu için 3 basamakli sayi
	MOV B, R7 ; B'ye R7'yi yükle (100)
	DIV AB; A'yi B'ye böl, sonuç A'da, kalan B'de olur
	ADD A, #30H ; A'daki sayiyi ASCII karakterine dönüstür
	MOV R0, A; Karakteri ekrana göstermek için R0'a yükle
	ACALL YAZDIR; Karakteri ekrana göstermek için alt programi çagir
	MOV R4, B; B'deki kalani (yüzler basamagi) R4'e yükle
 	MOV A, B; B'deki kalani (yüzler basamagi) R4'e yükle
	MOV R7, #10D ; R7'ye 10 degerini yükle
	MOV B, R7 ; B'ye R7'yi yükle (10)
	DIV AB ; A'yi B'ye böl, sonuç A'da, kalan B'de olur
	ADD A, #30H; A'daki sayiyi ASCII karakterine dönüstür
	MOV R0, A 	; Karakteri ekrana göstermek için R0'a yükle
	ACALL YAZDIR; Karakteri ekrana göstermek için alt programi çagir
	MOV A, B; B'deki kalani (onlar basamagi) A'ya yükl              	
	ADD A, #30H ; ASCII karakterine dönüstür
	MOV R0, A ; Karakteri ekrana göstermek için R0'a yükle
	ACALL YAZDIR; Karakteri ekrana göstermek için alt programi çagir
	CJNE R5, #00H, DECIMAL ; Eger R5 0 degilse, DECIMAL etiketine atla
	;!!! DECIMAL DEGISMIS I BAK
	RET; Alt programdan (subroutine) dön
	
KUCUK100:
	MOV R7, #10D; 10 sayisini R7 kaydediciye yükle
 	CLR C; Tasima (carry) bayragini temizle
 	MOV A, R4; R4'teki degeri A'ya yükle
 	SUBB A, R7; R7'den A'daki degeri çikar
 	JC KUCUK10; Eger tasima bayragi tasinmissa (1 ise), MENOR10 etiketine atla
 	MOV A, R4; A'daki degeri R4'ten tekrar A'ya yükle (R4 degismedi)
 	MOV B, R7; B'deki degeri R7'ye (10) yükle
 	DIV AB; A'yi B'ye böl, sonuç A'da, kalan B'de olur
	ADD A, #30H; A'daki sayiyi ASCII karakterine dönüstür
	MOV R0, A; Karakteri ekrana göstermek için R0'a yükle
	ACALL YAZDIR; Ekrana karakteri göstermek için alt programi çagir
	MOV A, B; Kalani (B) ekrana göstermek için A'ya yükle
	ADD A, #30H; Kalani (B) ASCII karakterine dönüstür
	MOV R0, A; Karakteri ekrana göstermek için R0'a yükle
	ACALL YAZDIR; Ekrana karakteri göstermek için alt programi çagir
	CJNE R5, #00H, DECIMAL; Eger R5 0 degilse, DECIMAL etiketine atla
	RET; Alt programdan (subroutine) dön

KUCUK10:
	MOV A, R4; R4'teki degeri A'ya yükle
	ADD A, #30H; ASCII karakterine dönüstürmek için 30H (sayilarin ASCII degeri) ekleyi 
	MOV R0, A; Karakteri ekrana göstermek için R0'a yükle
	ACALL YAZDIR; Ekrana karakteri göstermek için alt programi çagir
  	CJNE R5, #00H, DECIMAL; Eger R5 0 degilse, DECIMAL etiketine atla
	RET; Alt programdan (subroutine) dön

TASMA:
 	MOV R0, #0C0H; Ekranda mesaji ikinci satira yazmak için R0'a 0C0H adresini yükler
	ACALL KOMUT; LCD ekraninda belirli bir komutu yürütmek için alt programi çagirir
 	MOV DPTR, #HATA2; Hata mesajini göstermek için DPTR'yi MSGERRO2 adresine ayarlar
 	CLR C; Tasima bayragini temizler
	MOV R7, #0D; Döngü için sayaç olarak R7'ye 0D degerini yükler
	
PROX2:
	MOV A, R7; R7'deki degeri A'ya yükle	
	MOVC A, @A+DPTR; DPTR'nin gösterdigi bellek adresindeki veriyi A'ya yükle (MOVC ile)
 	MOV R0, A; A'daki degeri R0'a yükle	
 	ACALL YAZDIR; Karakteri ekrana göstermek için alt programi çagir
 	JZ FIM; Eger A (R7'nin degeri) 0 ise, FIM etiketine atla
 	INC R7; R7'yi bir arttir
	SJMP PROX2; PROX2 etiketine atla (döngüyü tekrar t)
FIM:
	RET; Alt programdan (subroutine) dön
	
DECIMAL:
	MOV R0, #'.'; Nokta karakterini R0'a yükle
	ACALL YAZDIR; Karakteri ekrana göstermek için alt programi çagir
	MOV A, R5; R5'teki degeri A'ya yükle
	MOV B, #10D; 10 sayisini B'ye yükle
	MUL AB; A ve B'yi çarp ve sonucu A'ya yükle
	MOV B, R3; R3'teki degeri B'ye yükle
 	DIV AB; A'yi B'ye böl, sonuç A'da, kalan B'de olur
 	ADD A, #30H; A'daki sayiyi ASCII karakterine dönüstür
 	MOV R0, A; Karakteri ekrana göstermek için R0'a yükle
 	ACALL YAZDIR; Karakteri ekrana göstermek için alt programi çagir
 	RET; Alt programdan (subroutine) dön
	
DELAY:
 	MOV 62, #2; 62 numarali register'e 2 degerini yükle
DELAY1:
 	MOV 61, #250; 61 numarali register'e 250 degerini yükle
DELAY2:
 	MOV 60, #250	; 60 numarali register'e 250 degerini yükle
 	DJNZ 60, $; 60 numarali register'deki deger sifir olana kadar döngüyü devam ettir
 	DJNZ 61, DELAY2; 61 numarali register'deki deger sifir olana kadar döngüyü devam ettir
 	DJNZ 62, DELAY1; 62 numarali register'deki deger sifir olana kadar döngüyü devam ettir
	RET; Alt programdan (subroutine) dön	
;DB - DEFINE BYTE
	
HATA: DB 'HATA:0 A BOLME',0 ;

HATA2: DB 'TASMA HATASI!',0 ;Hata mesaji 2: Tasma hatasi


END










