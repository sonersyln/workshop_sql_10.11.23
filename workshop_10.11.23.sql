--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
SELECT p.product_id, p.product_name, s.company_name, s.phone
FROM products p
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE p.units_in_stock = 0;

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
SELECT o.ship_address, e.first_name || ' ' || e.last_name AS "Çalışan Ad Soyad", o.order_date
FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
WHERE order_date >= '1998-03-01' AND order_date < '1998-04-01';

--28. 1997 yılı şubat ayında kaç siparişim var?
SELECT COUNT(*) AS "Şubat Ayı Sipariş Sayısı"
FROM orders
WHERE order_date >= '1997-02-01' AND order_date < '1997-03-01';

--29. London şehrinden 1998 yılında kaç siparişim var?
SELECT COUNT(*) AS "Sipariş Sayısı" 
FROM orders 
WHERE order_date >= '1998-01-01' AND order_date < '1999-01-01' AND ship_city = 'London';

--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
SELECT c.contact_name, c.phone, o.order_date 
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997;

--31. Taşıma ücreti 40 üzeri olan siparişlerim
SELECT *
FROM orders
WHERE freight > 40;

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
SELECT o.ship_city, c.contact_name
FROM orders o
INNER JOIN customers c ON o.customer_id = o.customer_id
WHERE freight >= 40;

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
SELECT o.order_date, o.ship_city, UPPER(e.first_name) || ' ' || UPPER(e.last_name) AS AdSoyad
FROM orders o
INNER JOIN employees e ON o.employee_id = e.employee_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997;

--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
SELECT c.contact_name, RIGHT(REPLACE(REPLACE(REPLACE(REPLACE(c.phone, ' ', ''), '(', ''), ')', ''),'-',''), 7) AS TelefonNumarasi						 
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997;

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
SELECT o.order_date, c.contact_name, e.first_name || ' ' || e.last_name AS "Çalışan Ad-Soyad"
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
INNER JOIN employees e ON o.employee_id = e.employee_id;

--36. Geciken siparişlerim?
SELECT *
FROM orders
WHERE shipped_date > required_date;

--37. Geciken siparişlerimin tarihi, müşterisinin adı
SELECT o.order_date, c.contact_name
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
WHERE o.shipped_date > o.required_date;

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT p.product_name, c.category_name, od.quantity
FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE od.order_id = 10248;

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT p.product_name, s.company_name
FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE od.order_id = 10248;

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT p.product_name, od.quantity 
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN products p ON od.product_id = p.product_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997 AND o.employee_id = 3;

--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS ad_soyad, SUM(od.quantity * p.unit_price) AS siparis_tutari
FROM employees e
INNER JOIN orders o ON e.employee_id = o.employee_id
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN products p ON od.product_id = p.product_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997
GROUP BY e.employee_id, ad_soyad, o.order_id
ORDER BY siparis_tutari DESC
LIMIT 1;

--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS ad_soyad, SUM(od.quantity) AS toplam_satis
FROM employees e
INNER JOIN orders o ON e.employee_id = o.employee_id
INNER JOIN order_details od ON o.order_id = od.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997
GROUP BY e.employee_id, ad_soyad
ORDER BY toplam_satis DESC
LIMIT 1;

--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name,p.unit_price,c.category_name
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
ORDER BY p.unit_price DESC
LIMIT 1;

--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT e.first_name || ' ' || e.last_name AS ad_soyad, o.order_date, o.order_id
FROM orders o
JOIN employees e ON o.employee_id = e.employee_id
ORDER BY o.order_date;

--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT AVG(od.unit_price * od.quantity) AS ortalama_fiyat, o.order_id
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
GROUP BY o.order_id
ORDER BY o.order_date DESC
LIMIT 5;

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name, c.category_name, SUM(od.quantity) AS toplam_satis_miktari
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE EXTRACT(MONTH FROM o.order_date) = 1
GROUP BY p.product_name, c.category_name;

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT od.order_id, SUM(od.quantity) AS toplam_satis
FROM order_details od
GROUP BY od.order_id
HAVING SUM(od.quantity) > (
    SELECT AVG(quantity)
    FROM order_details
)
ORDER BY toplam_satis DESC;

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT p.product_name, c.category_name, s.company_name
FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
GROUP BY p.product_name, c.category_name, s.company_name
ORDER BY SUM(od.quantity) DESC
LIMIT 1;

--49. Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT country) AS "Farklı Ülke Sayısı"
FROM customers;

--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT SUM(od.quantity * od.unit_price) AS "Toplam Satılan Ürün Miktarı"
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
WHERE EXTRACT(MONTH FROM o.order_date) = 1
AND o.employee_id = 3
AND o.order_date >= DATE '1998-01-01' AND o.order_date <= DATE '2023-11-10';

--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
SELECT p.product_name, c.category_name, od.quantity
FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE od.order_id = 10248;

--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
SELECT p.product_name, s.company_name
FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
WHERE od.order_id =10248;

--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
SELECT p.product_name, od.quantity
FROM employees e
INNER JOIN orders o ON e.employee_id = o.employee_id
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN products p ON od.product_id = p.product_id
WHERE e.employee_id = 3
AND EXTRACT(YEAR FROM o.order_date) = 1997;

--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS ad_soyad, SUM(od.quantity * p.unit_price) AS siparis_tutari
FROM employees e
INNER JOIN orders o ON e.employee_id = o.employee_id
INNER JOIN order_details od ON o.order_id = od.order_id
INNER JOIN products p ON od.product_id = p.product_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997
GROUP BY e.employee_id, ad_soyad, o.order_id
ORDER BY siparis_tutari DESC
LIMIT 1;

--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
SELECT e.employee_id, e.first_name || ' ' || e.last_name AS ad_soyad, SUM(od.quantity) AS toplam_satis
FROM employees e
INNER JOIN orders o ON e.employee_id = o.employee_id
INNER JOIN order_details od ON o.order_id = od.order_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1997
GROUP BY e.employee_id, ad_soyad
ORDER BY toplam_satis DESC
LIMIT 1;

--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name,p.unit_price,c.category_name
FROM products p
INNER JOIN categories c ON p.category_id = c.category_id
ORDER BY p.unit_price DESC
LIMIT 1;

--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
SELECT e.first_name || ' ' || e.last_name AS ad_soyad, o.order_date, o.order_id
FROM orders o
JOIN employees e ON o.employee_id = e.employee_id
ORDER BY o.order_date;

--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
SELECT AVG(od.unit_price * od.quantity) AS ortalama_fiyat, o.order_id
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
GROUP BY o.order_id
ORDER BY o.order_date DESC
LIMIT 5;

--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
SELECT p.product_name, c.category_name, SUM(od.quantity) AS toplam_satis_miktari
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
WHERE EXTRACT(MONTH FROM o.order_date) = 1
GROUP BY p.product_name, c.category_name;

--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
SELECT od.order_id, SUM(od.quantity) AS toplam_satis
FROM order_details od
GROUP BY od.order_id
HAVING SUM(od.quantity) > (
    SELECT AVG(quantity)
    FROM order_details
)
ORDER BY toplam_satis DESC;

--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
SELECT p.product_name, c.category_name, s.company_name
FROM order_details od
INNER JOIN products p ON od.product_id = p.product_id
INNER JOIN categories c ON p.category_id = c.category_id
INNER JOIN suppliers s ON p.supplier_id = s.supplier_id
GROUP BY p.product_name, c.category_name, s.company_name
ORDER BY SUM(od.quantity) DESC
LIMIT 1;

--62. Kaç ülkeden müşterim var
SELECT COUNT(DISTINCT country) AS "Farklı Ülke Sayısı"
FROM customers;

--63. Hangi ülkeden kaç müşterimiz var
SELECT country, COUNT(DISTINCT customer_id) AS müsteri_sayisi
FROM customers
GROUP BY country;

--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
SELECT SUM(od.quantity * od.unit_price) AS "Toplam Satılan Ürün Miktarı"
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
WHERE EXTRACT(MONTH FROM o.order_date) = 1
AND o.employee_id = 3
AND o.order_date >= DATE '1998-01-01' AND o.order_date <= DATE '2023-11-10';

--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
SELECT SUM(od.quantity * p.unit_price) AS total_revenue
FROM order_details od
INNER JOIN orders o ON od.order_id = o.order_id
INNER JOIN products p ON od.product_id = p.product_id
WHERE od.product_id = 10
  AND o.order_date >= CURRENT_DATE - INTERVAL '3 months';

--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
SELECT e.employee_id, e.first_name || ' ' || e.last_name, COUNT(o.order_id) AS "Toplam Sipariş Adedi"
FROM employees e
LEFT JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, e.first_name, e.last_name
ORDER BY COUNT(o.order_id) DESC;

--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun

SELECT o.order_id, c.contact_name,c.country 
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
SELECT company_name AS "Şirket Adı", contact_name AS "Temsilci Adı", address AS "Adres", city AS "Şehir", country AS "Ülke"
FROM customers
WHERE country = 'Brazil';

--69. Brezilya’da olmayan müşteriler

SELECT *
FROM customers
WHERE country != 'Brazil';

--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT *
FROM customers
WHERE country IN ('Spain', 'France', 'Germany');

--71. Faks numarasını bilmediğim müşteriler
SELECT *
FROM customers
WHERE fax IS NULL;

--72. Londra’da ya da Paris’de bulunan müşterilerim
SELECT *
FROM customers
WHERE city IN ('London', 'Paris');

--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
SELECT *
FROM customers
WHERE city = 'México D.F.' AND contact_title = 'Owner';

--74. C ile başlayan ürünlerimin isimleri ve fiyatları
SELECT product_name, unit_price
FROM products
WHERE product_name LIKE 'C%';

--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
SELECT first_name || ' ' || last_name AS "Ad Soyad", birth_date AS "Doğum Tarihi"
FROM employees
WHERE first_name LIKE 'A%';

--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
SELECT company_name
FROM customers
WHERE company_name LIKE '%Restaurant%' OR company_name LIKE '%Restaurante%';

--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
SELECT product_name, unit_price
FROM products
WHERE unit_price BETWEEN 50 AND 100;

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
SELECT order_id AS "Sipariş ID",  order_date AS "Sipariş Tarihi"
FROM orders
WHERE order_date BETWEEN DATE '1996-07-01' AND DATE '1996-12-31';

--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
SELECT *
FROM customers
WHERE country IN ('Spain', 'France', 'Germany');

--80. Faks numarasını bilmediğim müşteriler
SELECT *
FROM customers
WHERE fax IS NULL;

--81. Müşterilerimi ülkeye göre sıralıyorum:
SELECT *
FROM customers
ORDER BY country;

--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC;

--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını 
SELECT product_name,unit_price
FROM products
ORDER BY unit_price DESC, units_in_stock ASC;

--84. 1 Numaralı kategoride kaç ürün vardır..?
SELECT COUNT(*) AS "Ürün Sayısı"
FROM products
WHERE category_id = 1;

--85. Kaç farklı ülkeye ihracat yapıyorum..?
SELECT COUNT(DISTINCT country) AS "Farklı Ülke Sayısı"
FROM customers;