# Mobil Sorgular
Proje detayları için : [Proje Raporu](https://github.com/sevkikaragol/Flutter-mobilSorgular/blob/main/rapor.pdf)

## Kurulum
Öncelikle ```pubspec.yaml``` dosyasında ```flutter pub get``` komutunu çalıştırmanız gerekmektedir. Aksi taktirde çalışmayacaktır.
Daha sonra ```"lib\main.dart"``` yolunu izleyerek ```flutter emulators --launch "Your Emulator Name"``` (örn: flutter emulators --launch Pixel_2 API 26) ile sanal cihazınızı çalıştırıp ardından ```flutter run``` komutuyla uygulamayı çalıştırabilirsiniz.
## Giriş
Bu projede Firebase Firestore üzerinden 
çeşitli sorgular yapılarak filtrelenmiş veriler alınmış, ardından bu veriler ile proje isterleri üç aşama halinde gerçeklenmiştir.
İlk aşamada veritabanı üzerinde bulunan 
verilerden istere uygun olan veriler getirilmiştir. İkinci aşamada ise kullanıcı uygulamaya daha çok dahil edilmiş ve kullanıcı 
tarafından seçilen başlangıç-bitiş tarihine, 
bölge adına göre istere cevap niteliğinde 
olan veriler ekranda saydırılarak sıralanmıştır. Üçüncü ve son aşamada ise projeye 
Google Maps ürünleri dahil olmuş ve kullanıcıdan alınan sınırlamalara göre üretilen 
sonuç harita üzerinde çizdirilerek kullanıcıya görsel bir sonuç sunulmuştur. Kullanıcıların tüm bu işlemleri yapabilmesi için 
bir mobil uygulama tasarlanmıştır.
### Proje İsterleri
Gezinge verileri hareket halindeki nesnelerin konumlarını ve hareketle ilgili diğer bilgileri içerir.
The New York City Taxi and Limousine Commission (TLC) sarı taksi, yeşil taksi, kiralık
araçlarla ilgilenmektedir. TLC düzenli olarak tamamlanan her taksi yolculuğu bilgilerini
kaydetmektedir. Bu proje kapsamında Aralık 2020’de yayınlanan sarı taksi verisi kullanılacaktır. <br>

Uygulamada bulut ortamından veriler çekilerek bir sonraki başlıkta belirtilen her bir sorgu
tipinden birer sorguyu gerçekleştirmeniz beklenmektedir.
Harita ile ilgili sorgularda Google Map API kullanılmalıdır.
#### Tip 1
Aşağıdaki sorgulardan birine mutlaka çözüm bulunmalıdır.
- En fazla yolcu taşınan 5 günü ve toplam yolcu sayılarını listeleyiniz.
- Belirli mesafenin altında en çok seyahat yapılan günü ve seyahat uzunluğunu bulunuz (mesafe seçilebilmeli).
- :ok_hand: En uzun mesafeli 5 yolculuktaki gün ve mesafeleri listeleyiniz.
#### Tip 2
Aşağıdaki sorgulardan birine mutlaka çözüm bulunmalıdır.
- :ok_hand: İki tarih arasında belirli bir lokasyondan hareket eden araç sayısı kaçtır (tarihler ve lokasyon seçilebilmeli)?
- Günlük seyahat başına düşen ortalama alınan ücretlere göre; en az ücret alınan iki tarih arasındaki günlük alınan ortalama ücretleri listeleyiniz.
- İki tarih arasında seyahat edilen en az mesafeli 5 yolculuk hangisidir (tarihler seçilebilmeli)?
#### Tip 3
Aşağıdaki sorgulardan birine mutlaka çözüm bulunmalıdır.
- :ok_hand: Belirli bir günde en uzun seyahatin harita üstünde yolunu çiziniz (gün seçilebilmeli). <br>
Başlangıç ve varış konumları lokasyonun merkezi kabul edip mesafeye görre bir yol bulunmalıdır.
- Belirli bir günde aynı konumdan hareket eden araçların rastgele 5’inin yolunu çiziniz (gün ve konum seçilebilmeli). <br>
Başlangıç ve varış konumları lokasyonun merkezi kabul edip mesafeye göre bir yol bulunmalıdır.
- En az 3 yolcunun bulunduğu seyahatlerden en kısa mesafeli ve en uzun mesafeli yolu çiziniz. <br>
Başlangıç ve varış konumları lokasyonun merkezi kabul edip mesafeye göre bir yol bulunmalıdır.


## Yöntem
Bu projede izlenilen yol aşağıda anlatılmıştır: <br>
Proje isterlerine geçmeden önce projede 
kullanılacak verilerin sayısının azaltılması 
ve bulut ortamına yüklenmesi işlemleri 
Python dili kullanılarak yapılmıştır. Daha 
sonra ise proje isterlerine geçilmiştir. Proje 
üç tip sorgu için üç aşama şeklinde 
tasarlanmıştır. <br>
Veriler https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page sitesinden alınıp birkaç düzenleme ile Firebase Firestore'a aktarılmıştır.
Dosya isimleri: <br><br>
- ```yellow tripdata 2020-12.csv``` <br>
- ``` taxi+ zone lookup.csv``` <br><br>
olup indirildikten sonraki düzenlemeler ile Firestore'da şu şekilde görülmektedir: <br><br>
![trips](https://user-images.githubusercontent.com/65903573/117537692-57da8680-b00b-11eb-9005-bd2d86916325.png)
![zones](https://user-images.githubusercontent.com/65903573/117537654-1944cc00-b00b-11eb-8704-9213d2e70b1c.png) <br>
Belge (collection) isimleri sırasıyla "trips" ve "zones" olmalıdır. <br> <br>
Belgede değişiklik yapılmasının sebebi, Google Maps'te yol çizdirme işleminin yapılabilmesi için enlem (latitude) ve boylam (longitude) bilgilerine ihtiyaç duyulmasıdır. <br><br>
Uygulama çalıştırıldığında şu şekilde görülecektir: <br><br>
![anasayfa](https://user-images.githubusercontent.com/65903573/117537902-6d03e500-b00c-11eb-91f0-80252be08b8c.png) <br><br>
### Aşama 1 (Tip 1 Sorgu):
Kullanıcı ana menü ekranında “TİP 1 SORGU” butonuna tıkladığında Firebase Firestore üzerinden “en uzun mesafeli beş yolculuktaki gün ve mesafeler” isterini sağlayacak veriler çekilmektedir. Verilerin çekilmesini sağlayan sorgu, uygulamanın içerisinden Firebase’e gönderilmektedir. Sorgu ile elde edilen veriler cihaz ekranında art arda sıralanarak gösterilmektedir. <br><br> 
![sorgu1](https://user-images.githubusercontent.com/65903573/117537968-ba805200-b00c-11eb-9f69-9a6bd31fb923.png) <br><br>
![sorgu1_sayfa](https://user-images.githubusercontent.com/65903573/117538004-d5eb5d00-b00c-11eb-98d8-898f9c2ffc4d.png) <br><br>
### Aşama 2 (Tip 2 Sorgu):
Kullanıcı ana menü ekranında “TİP 2 
SORGU” butonuna tıkladığında başlangıçbitiş tarihleri ve mekan adı seçerek Firebase Firestore üzerinden “iki tarih arasında 
belirli bir lokasyondan hareket eden araç 
sayısı” isterini sağlayacak veriler çekilmektedir. Verilerin çekilmesini sağlayan 
sorgu, uygulamanın içerisinden Firebase’e 
gönderilmektedir. Sorgu ile elde edilen veriler cihaz ekranında detaylarıyla birlikte 
sıralanarak gösterilmiştir. Sadece araç sayısını göstermek yerine her yolculuğun detayları ile birlikte gösterilmesi ile ister daha da geliştirilmiştir. <br><br>
![sorgu2](https://user-images.githubusercontent.com/65903573/117538061-177c0800-b00d-11eb-8754-2172128ea4f0.png) <br><br>
![sorgu2_sayfa](https://user-images.githubusercontent.com/65903573/117538078-26fb5100-b00d-11eb-9740-d87e325749d5.png) <br><br>
### Aşama 3 (Tip 3 Sorgu):
Kullanıcı ana menü ekranında “TİP 3 
SORGU” butonuna tıkladığında bir tarih
seçerek ve hemen ardından “Haritada Göster” butonuna tıklayarak Firebase Firestore 
üzerinden “belirli bir günde en uzun seyahatin harita üzerinde yolunu çizdirme” isterini sağlayacak veriler çekilmektedir. Verilerin çekilmesini sağlayan sorgu, uygulamanın içerisinden Firebase’e gönderilmektedir. Sorgu ile elde edilen veriler (enlem-boylam bilgileri) doğrultusunda Google 
Maps üzerinde çizdirilerek cihaz ekranında 
gösterilmiştir. <br><br>
![sorgu3](https://user-images.githubusercontent.com/65903573/117538124-5b6f0d00-b00d-11eb-87f6-a0ba644f6f7a.png) <br><br>
![sorgu3_sayfa1](https://user-images.githubusercontent.com/65903573/117538133-6aee5600-b00d-11eb-8412-26a070ba1233.png) <br><br>
![sorgu3_sayfa2](https://user-images.githubusercontent.com/65903573/117538143-7b063580-b00d-11eb-9829-8a52ca30bf9d.png) <br><br>
## Akış Şeması
![sema](https://user-images.githubusercontent.com/65903573/117538164-96714080-b00d-11eb-947f-8f9f98fa37cf.png) <br><br>
