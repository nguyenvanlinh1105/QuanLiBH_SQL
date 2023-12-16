﻿CREATE DATABASE baitapNhom4
go
use baitapNhom4;
CREATE TABLE KHACHHANG(
	MAKHACHHANG char(10) PRIMARY KEY,
	TENCONGTY nvarchar(50) NOT NULL,
	TENGIAODICH nvarchar(50),
	DIACHI nvarchar(50) NOT NULL,
	EMAIL char(255) UNIQUE,
	DIENTHOAI char(10) UNIQUE,
	FAX char(12)
);

-- Thêm ràng buộc cho cột Email của khách hàng
ALTER TABLE KHACHHANG
	ADD CONSTRAINT CheckEmailFormat
	CHECK (
		Email LIKE '[a-zA-Z]%@gmail.com' OR
		Email LIKE '[a-zA-Z]%@yahoo.com' OR
		Email LIKE '[a-zA-Z]%@ute.udn.vn'
),
	CONSTRAINT CheckSDTFormat CHECK(
		DIENTHOAI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT CheckFaxFormat CHECK(
		FAX LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');


--ALTER TABLE KHACHHANG
--	DROP CONSTRAINT CheckEmailFormat;
CREATE TABLE LOAIHANG(
	MALOAIHANG char(10) PRIMARY KEY,
	TENLOAIHANG nvarchar(50),
);
--SELECT * FROM dbo.LOAIHANG

CREATE TABLE NHACUNGCAP(
	MACONGTY char(10) PRIMARY KEY,
	TENCONGTY nvarchar(50) ,
	TENGIAODICH nvarchar(255) ,
	DIACHI nvarchar(50) NOT NULL,
	DIENTHOAI char(10) UNIQUE ,
	FAX char(14) ,
	EMAIL varchar(255)UNIQUE ,
);

--Thêm ràng buộc côt cột Email của nhà cung cấp
ALTER TABLE NHACUNGCAP
ADD CONSTRAINT CheckEmailFormat1
	CHECK (
		Email LIKE '[a-zA-Z]%@gmail.com' OR
		Email LIKE '[a-zA-Z]%@yahoo.com' OR
		Email LIKE '[a-zA-Z]%@ute.udn.vn'
),
	CONSTRAINT CheckSDTFormat_NCC CHECK(
		DIENTHOAI LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
	CONSTRAINT CheckFaxFormat_NCC CHECK(
		FAX LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]');

CREATE TABLE NHANVIEN(
	MANHANVIEN char(10) PRIMARY KEY ,
	HO nvarchar(20) NOT NULL,
	TEN nvarchar(15) NOT NULL,
	NGAYSINH Datetime NOT NULL,
	NGAYLAMVIEC Datetime NOT NULL,
	DIACHI nvarchar(50),
	DIENTHOAI char(10)NOT NULL,
	LUONGCOBAN money,
	PHUCAP money,
);

ALTER TABLE NHANVIEN
ADD CONSTRAINT CheckAge
		CHECK (
			DATEDIFF(YEAR,'0:0',NGAYLAMVIEC-NGAYSINH) between 18 and 60
		),
	CONSTRAINT CheckPhone_NV
		CHECK(
			DIENTHOAI like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
		);

CREATE TABLE MATHANG(
	MAHANG char(10)  PRIMARY KEY ,
	TENHANG nvarchar(50)NOT NULL,
	MACONGTY char(10),
	MALOAIHANG char(10),
	SOLUONG float,
	DONVITINH nvarchar(20),
	GIAHANG money,
);

ALTER TABLE MATHANG
ADD  CONSTRAINT FK_MATHANG_LOAIHANG 
 	FOREIGN KEY (MALOAIHANG) REFERENCES LOAIHANG(MALOAIHANG) 
 		ON DELETE CASCADE ON UPDATE CASCADE , 
 	CONSTRAINT FK_MATHANG_NHACUNGCAP  
 	FOREIGN KEY (MACONGTY) REFERENCES NHACUNGCAP(MACONGTY)  
 		ON DELETE CASCADE  ON UPDATE CASCADE,
	CONSTRAINT soLuong_Mathang_format
		CHECK(SOLUONG>=0),
	CONSTRAINT DF_MATHANG_SOLUONG
		DEFAULT 1 FOR SOLUONG,
	CONSTRAINT GIAHANG_Mathang_format
		CHECK(GIAHANG>=0);
ALTER TABLE MATHANG
DROP CONSTRAINT soLuong_Mathang_format
CREATE TABLE DONDATHANG(
	SOHOADON char(10) PRIMARY KEY ,
	MAKHACHHANG char(10),
	MANHANVIEN char(10),
	NGAYDATHANG Date NOT NULL,
	NGAYGIAOHANG Date,
	NGAYCHUYENHANG Date,
	NOIGIAOHANG nvarchar(255),
);
ALTER TABLE DONDATHANG
ADD  CONSTRAINT FK_DONDATHANG_KHACHHANG 
 		FOREIGN KEY (MAKHACHHANG) REFERENCES KHACHHANG(MAKHACHHANG)
 			ON DELETE CASCADE  ON UPDATE CASCADE , 
 	CONSTRAINT FK_DONDATHANG_NHANVIEN
		FOREIGN KEY (MANHANVIEN) REFERENCES NHANVIEN(MANHANVIEN) 
 			ON DELETE CASCADE  ON UPDATE CASCADE,
	CONSTRAINT CheckDates
		CHECK(NGAYGIAOHANG>=NGAYDATHANG AND NGAYCHUYENHANG >=NGAYDATHANG);

CREATE TABLE CHITIETDATHANG(
	SOHOADON char (10),
	MAHANG char(10),
	GIABAN money,
	SOLUONG int,
	MUCGIAMGIA float ,
	PRIMARY KEY(SOHOADON,MAHANG)
);

ALTER TABLE CHITIETDATHANG  
ADD  CONSTRAINT FK_CHITIETDATHANG_MATHANG 
 	FOREIGN KEY (MAHANG) REFERENCES MATHANG(MAHANG)
 	ON DELETE CASCADE  ON UPDATE CASCADE , 
 	CONSTRAINT   FK_CHITIETDATHANG_DONDATHANG
 	FOREIGN KEY (SOHOADON) REFERENCES DONDATHANG(SOHOADON) 
 	ON DELETE CASCADE  ON UPDATE CASCADE,
	CONSTRAINT DefaultSoLuong
		DEFAULT  1 FOR SOLUONG ,
	CONSTRAINT DefaultMucGiamGia
		DEFAULT 0 FOR MUCGIAMGIA,
	CONSTRAINT giaBanFormat
		CHECK(GIABAN >= 0),
	CONSTRAINT soLuongFormat
		CHECK(SOLUONG >= 0);

set dateformat dmy;
-- INSERT DATA dbo.KHACHHANG
INSERT INTO dbo.KHACHHANG(MAKHACHHANG,TENCONGTY,TENGIAODICH,DIACHI,EMAIL,DIENTHOAI,FAX)
VALUES	
		('KH01',N'Công ty TNHH Vina','GD01',N'Hải Châu','a@gmail.com','0123456781','123456789012'),
		('KH02',  N'Công ty TNHH Viettel','GD02',N'Hải Châu','t@gmail.com','0123456782','123456789012'),
		('KH03',N'Công ty TNHH FPT','GD03',N'Hải Châu','b@gmail.com','0123456783','123456789012'),
		('KH04',N'Công ty TNHH SUN','GD04',N'Hải Châu','c@gmail.com','0123456784','123456789012'),
		('KH05',N'Công ty TNHH MOON','GD05',N'Hải Châu','d@gmail.com','0123456785','123456789012'),
		('KH06',N'Công ty TNHH Masan','GD06',N'Hải Châu','e@gmail.com','0123456786','123456789012'),
		('KH07',N'Công ty TNHH Vinamilk','GD07'	,N'Hải Châu','f@gmail.com','0123456787','123456789012'),
		('KH08',N'Công ty TNHH Techcom','GD08',	N'Hải Châu','g@gmail.com','0123456788','123456789012'),
		('KH09',N'Công ty TNHH Mobifone','GD09',N'Hải Châu','h@gmail.com','0123456789','123456789012'),
		('KH10',N'Công ty TNHH Petro',	'GD10',	N'Hải Châu','i@gmail.com','0123456780','123456789012');
INSERT INTO dbo.KHACHHANG(MAKHACHHANG,TENCONGTY,TENGIAODICH,DIACHI,EMAIL,DIENTHOAI)
VALUES('KH065',N'Công ty TNHH Vina','GD01',N'Hải Châu','a1@gmail.com','0123456581'),
		('KH052',  N'Công ty TNHH Viettel','GD02',N'Hải Châu','t1@gmail.com','0123456982'),
		('KH032',N'Công ty TNHH FPT','GD03',N'Hải Châu','b1@gmail.com','0123436783');
--SELECT * FROM KHACHHANG
-- INSERT DATA dbo.LOAIHANG
INSERT INTO dbo.LOAIHANG(MALOAIHANG,TENLOAIHANG)
VALUES	('MH01',N'Điện thoại di động'),
		('MH02',N'Sách'),
		('MH03',N'Máy tính xách tay'),
		('MH04',N'Điện thoại di động'),
		('MH05',N'Máy tính bảng'),
		('MH06',N'Đồ gia dụng'),
		('MH07',N'Thực phẩm'),
		('MH08',N'Quần áo'),
		('MH09',N'Giày dép'),
		('MH010',N'Đồ chơi');

-- INSERT DATA dbo.NHACUNGCAP
INSERT INTO dbo.NHACUNGCAP
VALUES	
		('CT01',N'Công ty TNHH MTV Vina',N'Giao dịch mua hàng',N'Đà Nẵng','0987654321','123456789012','a@yahoo.com'),
		('CT02',N'Công ty TNHH MTV Vina',N'Giao dịch mua hàng',N'Đà Nẵng','0987654320','123456789013','t@yahoo.com'),
		('CT03',N'Công ty TNHH MTV Fpt',N'Giao dịch mua hàng',N'Đà Nẵng','0987654322','123456789014','b@yahoo.com'),
		('CT04',N'Công ty TNHH MTV Moon',N' Giao dịch mua hàng',N'Đà Nẵng','0987654323','123456789015','c@yahoo.com'),
		('CT05',N'Công ty TNHH MTV Sun',N'Giao dịch mua hàng',N'Đà Nẵng','0987654324','123456789016','d@yahoo.com'),
		('CT06',N'Công ty TNHH MTV Vin',N'Giao dịch mua hàng',N'Đà Nẵng','0987654325','123456789017','e@yahoo.com');
INSERT INTO dbo.NHACUNGCAP(MACONGTY,TENCONGTY,TENGIAODICH,DIACHI,DIENTHOAI,EMAIL)
VALUES		
		('CT07',N'Công ty TNHH MTV Mobifone',N'Giao dịch mua hàng',N'Đà Nẵng','0987654326','f@yahoo.com'),
		('CT08',N'Công ty TNHH MTV Vinaphone',N'Giao dịch mua hàng',N'Đà Nẵng','0987654327','h@yahoo.com');
INSERT INTO dbo.NHACUNGCAP(MACONGTY,TENCONGTY,TENGIAODICH,DIACHI,DIENTHOAI)
VALUES
		('CT09',N'Công ty TNHH MTV Viettel',N'Giao dịch mua hàng',N'Đà Nẵng','0987654329');

-- INSERT DATA dbo.NhanVien

INSERT INTO dbo.NHANVIEN (MANHANVIEN,HO, TEN,NGAYSINH,NGAYLAMVIEC,DIACHI,DIENTHOAI,LUONGCOBAN,PHUCAP)
VALUES 
	('NV01',N'Nguyễn',N'Linh','11/05/2004','12/12/2023',N'Hải Châu','0987654321',2400000,300000),
	('NV02',N'Nguyễn',N'Hải','16/03/2004','12/11/2023',N'Thanh Khê','0987654322',2500000,300000),
	('NV03',N'Phạm',N'Toản','17/05/2004','17/12/2022',N'Liên Chiểu','0987654323',2600000,300000),
	('NV04',N'Lê',N'Hòa','11/12/2002','12/12/2023',N'Hòa Vang','0987654324',2700000,300000),
	('NV05',N'Lê',N'Chí Thiện','21/06/2003','14/11/2023',N'Lương Nhữ Học','0987654325',2800000,300000),
	('NV06',N'Nguyễn',N'Linh','23/05/2000','22/1/2023',N'Cẩm Lệ','0987654326',2900000,300000);
INSERT INTO dbo.NHANVIEN (MANHANVIEN,HO, TEN,NGAYSINH,NGAYLAMVIEC,DIENTHOAI,LUONGCOBAN,PHUCAP)
VALUES 
	('NV07',N'Hồ ',N'Trọng Ân','17/11/2003','12/12/2023','0987654327',2000000,300000),
	('NV08',N'Nguyễn',N'Hữu Xuân','19/04/2002','12/12/2023','0987654328',3000000,300000);
INSERT INTO dbo.NHANVIEN (MANHANVIEN,HO, TEN,NGAYSINH,NGAYLAMVIEC,DIACHI,DIENTHOAI,LUONGCOBAN)
VALUES
	('NV09',N'Tạ',N'Tiến Đạt','17/11/2003','12/12/2023','Quang Trung','0987654327',2400000),
	('NV10',N'Nguyễn',N'Linh','19/04/2002','12/12/2023','Nguyễn Văn Linh','0987654328',2400000);

-- INSERT DATA dbo.MATHANG
INSERT INTO dbo.MATHANG(MAHANG,TENHANG,MACONGTY,MALOAIHANG,SOLUONG,DONVITINH,GIAHANG)
VALUES 
	('MH2001',N'Dầu gội đầu ','CT01','MH01',30,'Hộp',300000),
	('MH2002',N'Sữa ông thọ ','CT02','MH02',24,'Hộp',400000),
	('MH2003',N'Bánh kẹo Hải Hà ','CT03','MH03',30,'Gói',500000),
	('MH2004',N'Bếp ga ','CT04','MH04',10,'Cái',600000),
	('MH2005',N'Bếp từ ','CT05','MH05',45,'Cái',700000);
INSERT INTO dbo.MATHANG(MAHANG,TENHANG,MALOAIHANG,SOLUONG,DONVITINH,GIAHANG)
VALUES 
	('MH2006',N'Quạt Cây ','MH06',30,'Cái',800000),
	('MH2007',N'Xe đạp ','MH07',24,'Chiêch',900000);
INSERT INTO dbo.MATHANG(MAHANG,TENHANG,MACONGTY,DONVITINH,GIAHANG)
VALUES 
	('MH2008',N'Ô tô','CT08','Chiếc',100000),
	('MH2009',N'Sữa ông thọ ','CT09','Hộp',200000);

-- INSERT DATA dbo.DONDATHANG
INSERT INTO dbo.DONDATHANG(SOHOADON,MAKHACHHANG, MANHANVIEN, NGAYDATHANG, NGAYGIAOHANG, NGAYCHUYENHANG, NOIGIAOHANG)
VALUES
		('HD3001','KH01', 'NV01', '2023-01-15', '2023-01-20', '2023-01-21', N'Hải Châu'),
       ('HD3002','KH02',  'NV02', '2023-02-05', '2023-02-10', '2023-02-11', N'Hải Châu'),
       ('HD3003','KH03',  'NV06', '2023-03-20', '2023-03-25', '2023-03-26', N'Hải Châu'),
       ('HD3004','KH04',  'NV05', '2023-04-10', '2023-04-15', '2023-04-16', N'Hải Châu'),
       ('HD3005','KH05',  'NV01', '2023-05-01', '2023-05-05', '2023-05-06', N'Hải Châu'),
       ('HD3006','KH06',  'NV03', '2023-06-12', '2023-06-17', '2023-06-18', N'Hải Châu');
set dateformat dmy;
INSERT INTO dbo.DONDATHANG(SOHOADON,MANHANVIEN,NGAYDATHANG,NGAYGIAOHANG,NOIGIAOHANG)
VALUES 
	('HD3007', 'NV08','12/03/2022','13/03/2023',N'Hải Châu'),
	( 'HD3008','NV09','12/03/2022','13/03/2023',N'Hải Châu');
INSERT INTO dbo.DONDATHANG(SOHOADON,MAKHACHHANG,NGAYDATHANG,NGAYGIAOHANG,NGAYCHUYENHANG,NOIGIAOHANG)
VALUES 
	('HD3009','KH07','12/03/2023','13/03/2023','14/03/2023',N'Hải Châu'),
	('HD3010','KH08','12/03/2023','13/03/2023','14/03/2023',N'Hải Châu');
--INSERT DATA dbo.CHITIETDATHANG;
INSERT INTO dbo.CHITIETDATHANG
VALUES 
	('HD3006','MH2006',310000,30,default),
	('HD3001','MH2001',410000,30,default),
	('HD3002','MH2002',510000,30,default),
	('HD3003','MH2003',610000,30,default),
	('HD3004','MH2004',710000,30,default),
	('HD3005','MH2005',810000,30,default);
INSERT INTO dbo.CHITIETDATHANG(SOHOADON,MAHANG,GIABAN,MUCGIAMGIA)
VALUES 
	('HD3007','MH2005',110000,default),
	('HD3006','MH2008',210000,default);
INSERT INTO dbo.CHITIETDATHANG(SOHOADON,MAHANG,SOLUONG,MUCGIAMGIA)
VALUES 
	('HD3009','MH2005',0, default),
	('HD3010','MH2007',0, default);
-- TUẦN 6: SỬ DỤNG CÂU LỆNH UPDATE
-- câu 1;
UPDATE DONDATHANG
	SET NGAYCHUYENHANG=NGAYDATHANG
	WHERE NGAYCHUYENHANG is NULL;
-- Câu 2
UPDATE MATHANG
SET SOLUONG= 2*SOLUONG
WHERE MACONGTY IN (SELECT MACONGTY
				FROM NHACUNGCAP WHERE TENCONGTY = 'Công ty TNHH MTV Vina' );
--Câu 3:
UPDATE DONDATHANG
SET NOIGIAOHANG = KHACHHANG.DIACHI
FROM DONDATHANG
INNER JOIN KHACHHANG ON DONDATHANG.MAKHACHHANG = KHACHHANG.MAKHACHHANG
WHERE DONDATHANG.NOIGIAOHANG IS NULL;
-- Câu 4:
UPDATE KHACHHANG
SET KHACHHANG.DIACHI = NHACUNGCAP.DIACHI,
    KHACHHANG.DIENTHOAI = NHACUNGCAP.DIENTHOAI,
    KHACHHANG.FAX = NHACUNGCAP.FAX,
    KHACHHANG.EMAIL = NHACUNGCAP.EMAIL
FROM KHACHHANG
INNER JOIN NHACUNGCAP ON 
    (KHACHHANG.TENCONGTY = NHACUNGCAP.TENCONGTY OR KHACHHANG.TENGIAODICH = NHACUNGCAP.TENGIAODICH)
    AND KHACHHANG.MAKHACHHANG <> NHACUNGCAP.MACONGTY;

SELECT * FROM KHACHHANG
-- Cập nhật lương cho nhân viên bán được số lượng hàng nhiều hơn 100 trong năm 2022
UPDATE NHANVIEN
SET LUONGCOBAN = LUONGCOBAN * 2
WHERE MANHANVIEN IN (
    SELECT DISTINCT DDH.MANHANVIEN
    FROM DONDATHANG DDH, CHITIETDATHANG CTDH
    WHERE DDH.SOHOADON = CTDH.SOHOADON
    AND YEAR(DDH.NGAYDATHANG) = 2022
    GROUP BY DDH.MANHANVIEN
    HAVING SUM(CTDH.SOLUONG) > 100
);
-- cau f
UPDATE NHANVIEN
SET PHUCAP = LUONGCOBAN * 0.5
WHERE MANHANVIEN = (
    SELECT TOP 1 MANHANVIEN
    FROM (
        SELECT MANHANVIEN, SUM(SOLUONG) AS TONGSOLUONG
        FROM DONDATHANG DDH, CHITIETDATHANG CTDH
        WHERE DDH.SOHOADON = CTDH.SOHOADON
        GROUP BY MANHANVIEN
    ) AS T
    ORDER BY TONGSOLUONG DESC
);
Select * from dbo.NHANVIEN


-- cau g
UPDATE NHANVIEN
SET LUONGCOBAN = LUONGCOBAN * 0.75
WHERE MANHANVIEN NOT IN (
    SELECT MANHANVIEN
    FROM DONDATHANG
    WHERE YEAR(NGAYDATHANG) = 2023
);

--câu h
UPDATE DONDATHANG
SET SOTIEN = (
    SELECT SUM(CHITIETDATHANG.SOLUONG * CHITIETDATHANG.GIABAN * (1 - CHITIETDATHANG.MUCGIAMGIA / 100))
    FROM CHITIETDATHANG
    WHERE CHITIETDATHANG.SOHOADON = DONDATHANG.SOHOADON
    GROUP BY CHITIETDATHANG.SOHOADON
);

---- DELETE 
--câu a
DELETE FROM NHANVIEN
WHERE DATEDIFF(YEAR, NGAYLAMVIEC, GETDATE()) > 40;
--câu b
DELETE FROM DONDATHANG
WHERE YEAR(NGAYDATHANG) < 2010;
--câu c
DELETE FROM LOAIHANG
WHERE MALOAIHANG NOT IN (SELECT DISTINCT MALOAIHANG FROM MATHANG);
-- câu d
DELETE FROM KHACHHANG
WHERE MAKHACHHANG NOT IN (SELECT DISTINCT MAKHACHHANG FROM DONDATHANG);
-- câu e
DELETE FROM MATHANG
WHERE SOLUONG = 0
AND MAHANG NOT IN (SELECT DISTINCT MAHANG FROM CHITIETDATHANG);
--tuan7 8 SELECT

--a
select TENCONGTY,MACONGTY
from NHACUNGCAP
where MACONGTY IN (select MACONGTY from MATHANG);
-- load. 
SELECT *
FROM NHACUNGCAP
--b
SELECT MAHANG,TENHANG,SOLUONG
FROM MATHANG
--C
SELECT MANHANVIEN,HO+' '+TEN AS HOTEN,DIACHI,YEAR(NGAYLAMVIEC) AS NAMLAMVIEC
FROM NHANVIEN
--load
 SELECT HO+' '+TEN AS [HỌ VÀ TÊN],DIACHI, YEAR(NGAYLAMVIEC) AS[NĂM LÀM VIỆC]
FROM NHANVIEN
--D
UPDATE NHACUNGCAP
SET TENGIAODICH = 'VINAMILK' 
WHERE MACONGTY = 'CT02';

SELECT DIACHI,DIENTHOAI,TENGIAODICH
FROM NHACUNGCAP
WHERE TENGIAODICH='VINAMILK';

--e
SELECT MAHANG,TENHANG,SOLUONG
FROM MATHANG
WHERE GIAHANG>100000 AND SOLUONG<50
--F
SELECT MAHANG,TENHANG,MATHANG.MACONGTY,NHACUNGCAP.TENCONGTY
FROM MATHANG
INNER JOIN  NHACUNGCAP ON NHACUNGCAP.MACONGTY=MATHANG.MACONGTY
select * from dbo.MATHANG
--g
update  NHACUNGCAP
set TENCONGTY='Việt Tiến'
where MACONGTY='CT08'
select MAHANG,TENHANG
from MATHANG
where MACONGTY in(select MACONGTY
					from NHACUNGCAP
					where TENCONGTY=N'Việt Tiến')
--h
SELECT DISTINCT NHACUNGCAP.DIACHI,MATHANG.MALOAIHANG,NHACUNGCAP.TENCONGTY
FROM  NHACUNGCAP JOIN MATHANG ON  NHACUNGCAP.MACONGTY=MATHANG.MACONGTY
JOIN LOAIHANG ON LOAIHANG.MALOAIHANG = MATHANG.MALOAIHANG
WHERE LOAIHANG.TENLOAIHANG =N'Thực phẩm'
	
SELECT * FROM dbo.NHACUNGCAP
UPDATE dbo.LOAIHANG
SET TENLOAIHANG = N'Thực phẩm'
--i
SELECT DISTINCT
   KH.MAKHACHHANG,KH.TENCONGTY,KH.DIENTHOAI, KH.TENGIAODICH AS TenGiaoDichKhachHang
FROM KHACHHANG KH
JOIN DONDATHANG DDH ON KH.MAKHACHHANG = DDH.MAKHACHHANG
JOIN CHITIETDATHANG CTDH ON DDH.SOHOADON = CTDH.SOHOADON
JOIN MATHANG MH ON CTDH.MAHANG = MH.MAHANG
WHERE MH.TENHANG = N'Sữa ông thọ'
--j
SELECT SOHOADON, DONDATHANG.MANHANVIEN,NHANVIEN.HO,NHANVIEN.TEN, NGAYGIAOHANG, NOIGIAOHANG, KHACHHANG.TENCONGTY
FROM DONDATHANG INNER JOIN KHACHHANG ON DONDATHANG.MAKHACHHANG = KHACHHANG.MAKHACHHANG
INNER JOIN NHANVIEN on DONDATHANG.MANHANVIEN=NHANVIEN.MANHANVIEN
WHERE SOHOADON = (SELECT TOP 1 SOHOADON FROM dbo.DONDATHANG)
--k
SELECT  HO,TEN,MANHANVIEN,ISNULL((LUONGCOBAN+PHUCAP),0) AS LUONG
FROM NHANVIEN

--lTrong đơn đặt hàng số 3 đặt mua những mặt hàng nào và số tiền mà khách hàng phải trả cho mỗi mặt hàng là bao nhiêu (số tiền phải trả được tính theo công thức :
--SOLUONG×GIABAN – SOLUONG×GIABAN×MUCGIAMGIA/100)

select TOP 1 CTDH.SOHOADON, CTDH.MAHANG,(CTDH.SOLUONG*GIABAN-CTDH.SOLUONG*GIABAN*MUCGIAMGIA/100) as TIENPHAITRA	
from  CHITIETDATHANG CTDH, MATHANG 
where MATHANG.MAHANG=CTDH.MAHANG and SOHOADON IN (SELECT SOHOADON FROM (SELECT TOP 3 SOHOADON FROM dbo.DONDATHANG) as c ORDER BY SOHOADON DESc)

SELECT soHoaDon,m.maHang, tenHang, (c.soLuong*giaBan-mucGiamGia) AS soTienPhaiTra
FROM MATHANG AS m, CHITIETDATHANG AS c
WHERE m.maHang = c.maHang and c.soHoaDon in (select TOP 1 soHoaDon
											from DONDATHANG
											where soHoaDon not in (select TOP 2 soHoaDon
																	from DONDATHANG)
											)
-- m)	Hãy cho biết có những khách hàng nào lại chính là đối tác cung cấp hàng của công ty (tức là có cùng tên giao dịch).
 update KHACHHANG
 set TENGIAODICH=N'VINAMILK'
 where MAKHACHHANG='KH01'


SELECT MAKHACHHANG,
    KH.TENCONGTY AS TenDoiTacCungCap
FROM KHACHHANG KH
JOIN NHACUNGCAP NCC ON KH.TENGIAODICH = NCC.TENGIAODICH;


 --lTrong công ty có những nhân viên nào có cùng ngày sinh?
 SELECT
    MH.TENHANG AS TenMatHang,
    CTDH.SOLUONG,
    CTDH.GIABAN,
    CTDH.MUCGIAMGIA,
    CTDH.SOLUONG * CTDH.GIABAN - CTDH.SOLUONG * CTDH.GIABAN * CTDH.MUCGIAMGIA / 100 AS SoTienPhaiTra
FROM CHITIETDATHANG CTDH
JOIN MATHANG MH ON CTDH.MAHANG = MH.MAHANG
WHERE CTDH.SOHOADON = 'HD3003';




 -- n)	Trong công ty có những nhân viên nào có cùng ngày sinh?
SELECT *
FROM NHANVIEN
WHERE NGAYSINH IN (
    SELECT NGAYSINH
    FROM NHANVIEN
    GROUP BY NGAYSINH
    HAVING COUNT(*) > 1
);

--o)	Những đơn đặt hàng nào yêu cầu giao hàng ngay tại công ty đặt hàng và những đơn đó là của công ty nào?
update NHACUNGCAP
set DIACHI=N'Hải Châu'
where MACONGTY='CT01'


SELECT DONDATHANG.SOHOADON, DONDATHANG.NOIGIAOHANG, KHACHHANG.TENCONGTY AS CONGTYDATHANG
FROM DONDATHANG
JOIN KHACHHANG ON DONDATHANG.MAKHACHHANG = KHACHHANG.MAKHACHHANG
WHERE DONDATHANG.NOIGIAOHANG = KHACHHANG.DIACHI


--p)	Cho biết tên công ty,  tên giao dịch, địa chỉ và điện thoại của các khách hàng và các nhà cung cấp hàng cho công ty.
SELECT KHACHHANG.TENCONGTY,KHACHHANG.TENGIAODICH,KHACHHANG.DIACHI,
		KHACHHANG.DIACHI,NHACUNGCAP.TENCONGTY AS 'TENNHACUNGCAP',
		NHACUNGCAP.TENGIAODICH,NHACUNGCAP.DIACHI,NHACUNGCAP.DIACHI
FROM DONDATHANG,NHACUNGCAP,CHITIETDATHANG,MATHANG,KHACHHANG
WHERE	KHACHHANG.MAKHACHHANG=DONDATHANG.MAKHACHHANG and DONDATHANG.SOHOADON=CHITIETDATHANG.SOHOADON
		and CHITIETDATHANG.MAHANG=MATHANG.MAHANG and MATHANG.MACONGTY=NHACUNGCAP.MACONGTY 


		-- cách 2: 
SELECT tenCongTy, tenGiaoDich, diaCHi, dienThoai
FROM KHACHHANG
UNION ALL
SELECT tenCongTy, tenGiaoDich, diaCHi, dienThoai
FROM NHACUNGCAP
--q)	Những mặt hàng nào chưa từng được khách hàng đặt mua?
SELECT TENHANG,MAHANG
FROM MATHANG
WHERE MAHANG  not in (SELECT MAHANG FROM CHITIETDATHANG)

SELECT M.*
FROM MATHANG as M
LEFT JOIN CHITIETDATHANG  AS C ON M.MAHANG = C.MAHANG
WHERE C.MAHANG IS NULL;

--r)	Những nhân viên nào của công ty chưa từng lập bất kỳ một hoá đơn đặt hàng nào?
SELECT NV.MaNhanVien, NV.Ho, NV.Ten
FROM NHANVIEN NV
LEFT JOIN DONDATHANG DDH ON NV.MANHANVIEN = DDH.MANHANVIEN
WHERE DDH.MANHANVIEN IS NULL

--s)	Những nhân viên nào của công ty có lương cơ bản cao nhất?
SELECT TOP 1  MANHANVIEN,HO,TEN,LUONGCOBAN
FROM NHANVIEN
ORDER BY LUONGCOBAN DESC

SELECT *
FROM NHANVIEN
WHERE luongCoBan IN (SELECT TOP(1) luongCoBan FROM NHANVIEN ORDER BY luongCoBan DESC)
--t)	
SELECT DDH.SOHOADON, KHACHHANG.TENGIAODICH AS TENKHACHHANG,
SUM(CTDH.GIABAN * CTDH.SOLUONG - (CTDH.GIABAN * CTDH.SOLUONG * CTDH.MUCGIAMGIA / 100)) AS TONGTIEN
FROM DONDATHANG DDH
JOIN CHITIETDATHANG CTDH ON DDH.SOHOADON = CTDH.SOHOADON
JOIN KHACHHANG ON DDH.MAKHACHHANG = KHACHHANG.MAKHACHHANG
GROUP BY DDH.SOHOADON, KHACHHANG.TENGIAODICH;
select * from dbo.CHITIETDATHANG
--u)	Trong năm 2022, những mặt hàng nào chỉ được đặt mua đúng một lần


SELECT MATHANG.MAHANG, MATHANG.TENHANG
FROM MATHANG
JOIN CHITIETDATHANG ON MATHANG.MAHANG = CHITIETDATHANG.MAHANG
JOIN DONDATHANG ON CHITIETDATHANG.SOHOADON = DONDATHANG.SOHOADON
WHERE YEAR(DONDATHANG.NGAYDATHANG) = 2022
GROUP BY MATHANG.MAHANG, MATHANG.TENHANG
HAVING COUNT(DONDATHANG.SOHOADON) = 1;


SELECT *
FROM MatHang mh
WHERE 1 = (
    SELECT COUNT(ct.soHoaDon)
    FROM ChiTietDatHang ct
    JOIN DonDatHang ddh ON ct.soHoaDon = ddh.soHoaDon
    WHERE ct.maHang = mh.maHang AND YEAR(ddh.ngayDatHang) = 2022
);
--v
SELECT KH.MAKHACHHANG, KH.TENGIAODICH,
SUM(CHITIETDATHANG.SOLUONG * CHITIETDATHANG.GIABAN) AS TONGTIEN
FROM KHACHHANG KH
JOIN DONDATHANG ON KH.MAKHACHHANG = DONDATHANG.MAKHACHHANG
JOIN CHITIETDATHANG ON DONDATHANG.SOHOADON = CHITIETDATHANG.SOHOADON
GROUP BY KH.MAKHACHHANG, KH.TENGIAODICH;
--w
SELECT NHANVIEN.MANHANVIEN, NHANVIEN.HO, NHANVIEN.TEN,
    COUNT(DONDATHANG.SOHOADON) AS SOLUONGDONDATHANG
FROM NHANVIEN
LEFT JOIN DONDATHANG ON NHANVIEN.MANHANVIEN = DONDATHANG.MANHANVIEN
GROUP BY NHANVIEN.MANHANVIEN, NHANVIEN.HO, NHANVIEN.TEN;

--x
SELECT MONTH(NGAYDATHANG) AS THANG, YEAR(NGAYDATHANG) AS NAM,
SUM(CTDH.SOLUONG * CTDH.GIABAN - CTDH.SOLUONG * CTDH.GIABAN * CTDH.MUCGIAMGIA / 100) AS TONGTIEN
FROM DONDATHANG
JOIN CHITIETDATHANG CTDH ON DONDATHANG.SOHOADON = CTDH.SOHOADON
WHERE YEAR(NGAYDATHANG) = 2023
GROUP BY MONTH(NGAYDATHANG), YEAR(NGAYDATHANG);

--y
SELECT MATHANG.TENHANG,
       SUM(CTDH.SOLUONG * (CTDH.GIABAN - MATHANG.GIAHANG)) AS TONGLAITUATHEOMATHANG
FROM CHITIETDATHANG CTDH
JOIN MATHANG ON CTDH.MAHANG = MATHANG.MAHANG
JOIN DONDATHANG ON CTDH.SOHOADON = DONDATHANG.SOHOADON
WHERE YEAR(DONDATHANG.NGAYDATHANG) = 2023
GROUP BY MATHANG.TENHANG;

--z
SELECT MH.MAHANG, MH.TENHANG, 
       SUM(MH.SOLUONG) - SUM(CTDH.SOLUONG)AS TONG_SOLUONG_HIENCON, 
       SUM(CTDH.SOLUONG) AS TONG_SOLUONG_DABAN
FROM MATHANG MH
LEFT JOIN CHITIETDATHANG CTDH ON MH.MAHANG = CTDH.MAHANG
GROUP BY MH.MAHANG, MH.TENHANG;






-- Hàm thủ tục trigger 

-- Câu 1: 
CREATE PROCEDURE ThemMatHang
    @MaHang char(10),
    @TenHang nvarchar(50),
    @MaCongTy char(10),
    @MaLoaiHang char(10),
    @SoLuong float,
    @DonViTinh nvarchar(20),
    @GiaHang money
AS
BEGIN
    IF @MaHang IS NULL OR @TenHang IS NULL OR @SoLuong IS NULL OR @DonViTinh IS NULL OR @GiaHang IS NULL
    BEGIN
        PRINT N'Thông tin không được để trống.';
        RETURN;
    END

    IF EXISTS (SELECT 1 FROM MATHANG WHERE MAHANG = @MaHang)
    BEGIN
        PRINT N'Mã hàng đã tồn tại.';
        RETURN;
    END

    IF @MaLoaiHang IS NOT NULL AND NOT EXISTS (SELECT 1 FROM LOAIHANG WHERE MALOAIHANG = @MaLoaiHang)
    BEGIN
        PRINT 'Mã loại hàng không hợp lệ.';
        RETURN;
    END

    IF @MaCongTy IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHACUNGCAP WHERE MACONGTY = @MaCongTy)
    BEGIN
        PRINT N'Mã công ty không hợp lệ.';
        RETURN;
    END

    INSERT INTO MATHANG (MAHANG, TENHANG, MACONGTY, MALOAIHANG, SOLUONG, DONVITINH, GIAHANG)
    VALUES (@MaHang, @TenHang, @MaCongTy, @MaLoaiHang, @SoLuong, @DonViTinh, @GiaHang);
    
    PRINT N'Đã thêm một bản ghi mới cho bảng MATHANG.';
END


EXECUTE ThemMatHang 'MH025', N'Tên hàng mới', 'CT01', 'MH01', 100, N'Cái', 500000;

select * from dbo.NHACUNGCAP

--câu 2: 
CREATE PROCEDURE dbo.pro_ThongKeHang
    @MaHang CHAR(10)
AS
BEGIN
    SELECT
        MATHANG.MAHANG,
        MATHANG.TENHANG,
        MATHANG.SOLUONG - SUM(CHITIETDATHANG.SOLUONG) AS SoLuongHienCo,
        SUM(CHITIETDATHANG.SOLUONG) AS SoLuongDaBan
    FROM
        MATHANG
    LEFT JOIN CHITIETDATHANG ON MATHANG.MAHANG = CHITIETDATHANG.MAHANG
    WHERE
        MATHANG.MAHANG = @MaHang
    GROUP BY
        MATHANG.MAHANG, MATHANG.TENHANG, MATHANG.SOLUONG;
END;
select * from dbo.CHITIETDATHANG
-- check 
EXEC dbo.pro_ThongKeHang @MaHang = 'MH025';




--câu 3: Viết hàm trả về một bảng trong đó cho biết tổng số lượng hàng bán được của măt hàng có mã mặt hàng truyền vào làm tham số  
--Sử dụng hàm này để thống kê xem tổng số lượng hàng (hiện có và đã bán ) của mặt hàng là bao nhiêu 
CREATE FUNCTION dbo.ThongKeHang(@MaHang CHAR(10))
RETURNS TABLE
AS
RETURN
(
    SELECT
        MATHANG.MAHANG,
        MATHANG.TENHANG,
        MATHANG.SOLUONG - ISNULL(SUM(CHITIETDATHANG.SOLUONG), 0) AS SoLuongHienCo,
        ISNULL(SUM(CHITIETDATHANG.SOLUONG), 0) AS SoLuongDaBan
    FROM
        MATHANG
    LEFT JOIN CHITIETDATHANG ON MATHANG.MAHANG = CHITIETDATHANG.MAHANG
    WHERE
        MATHANG.MAHANG = @MaHang
    GROUP BY
        MATHANG.MAHANG, MATHANG.TENHANG, MATHANG.SOLUONG
);

-- Thống kê số lượng hàng hiện có và đã bán của mặt hàng có mã 'MH2001'
SELECT * FROM dbo.ThongKeHang('MH2001');



-- Truy vấn để thống kê số lượng hàng của từng mặt hàng trong bảng MATHANG
SELECT m.*, th.* 
FROM dbo.MATHANG m
CROSS APPLY dbo.ThongKeHang(m.MAHANG) th;
-- Câu 3b:Viết hàm trả về một bảng trong đó cho biết tổng số lượng hàng bán được của mỗi mặt hàng.
--Sử dụng hàm này để thống kê xem tổng số lượng hàng (hiện có và đã bán ) của mỗi mặt hàng là bao nhiêu 

CREATE FUNCTION dbo.fn_ThongKeHang()
RETURNS TABLE
AS
RETURN
(
    SELECT
        MATHANG.MAHANG,
        MATHANG.TENHANG,
        MATHANG.SOLUONG - SUM(CHITIETDATHANG.SOLUONG) AS SoLuongHienCo,
        SUM(CHITIETDATHANG.SOLUONG)AS SoLuongDaBan
    FROM
        MATHANG
    LEFT JOIN CHITIETDATHANG ON MATHANG.MAHANG = CHITIETDATHANG.MAHANG
    GROUP BY
        MATHANG.MAHANG, MATHANG.TENHANG, MATHANG.SOLUONG
);
select * from dbo.fn_ThongKeHang();
/*
4. Viết trigger cho bảng CHITIETDATHANG theo yêu cầu sau :
			- Khi một bản ghi mới được bổ sung vào bảng ghi này thì giảm số lượng hàng hiện 
			có nếu số lượng hàng hiện có lớn hơn hoặc bằng số lượng hàng được bán ra. Ngược lại hãy hủy bỏ thao tác bổ sung . 
			-Khi cập nhật lại số lượng hàng được bán, 
			kiểm tra số lượng hàng được cập nhật lại có phù hợp hay không 
			(số lượng hàng bán ra không được vượt quá ố lượng hàng hiện có và không được nhỏ hơn 1 ) 
			. Nêu dữ liệu hợp lệ thì giảm(hoặc tăng) số lượng hàng hiện có trong công ty, ngược lại thì hủy bỏ thao tác cập nhật. 
*/

CREATE TRIGGER trig_CTDH
ON dbo.CHITIETDATHANG
AFTER INSERT , UPDATE , DELETE
AS 
BEGIN 
	if exists (select * from MATHANG AS MH, inserted AS i where MH.MAHANG = i.MAHANG and MH.SOLUONG <i.SOLUONG)
	BEGIN
        PRINT N'Số lượng đặt vượt quá số lượng hàng hiện còn';
        ROLLBACK;
    END
	If not exists(select * from deleted) 
	--➔ đã INSERT data
		UPDATE dbo.MATHANG 
		SET MATHANG.SOLUONG = MATHANG.SOLUONG - i.SOLUONG 
		FROM inserted AS i
		WHERE MATHANG.MAHANG = i.MAHANG

	If not exists(select * from inserted) 
	--➔ đã DELETE data
	-- Khi xoa 1 san pham
		UPDATE dbo.MATHANG 
		SET MATHANG.SOLUONG = MATHANG.SOLUONG + d.SOLUONG 
		FROM deleted AS d
		WHERE MATHANG.MAHANG = d.MAHANG
	
	Else
	--➔ có Update data
		BEGIN
		if exists (select * from MATHANG AS MH, inserted AS i, deleted AS d where MH.MAHANG = i.MAHANG
		and i.MAHANG = d.MAHANG and i.SOHOADON = d.SOHOADON
		and MH.SOLUONG+d.SOLUONG <i.SOLUONG 
		and MH.SOLUONG +d.SOLUONG-i.SOLUONG>=1)
			BEGIN
				PRINT N'Số lượng đặt vượt quá số lượng hàng hiện còn';
				ROLLBACK;
			END
		UPDATE MATHANG
        SET MATHANG.SOLUONG = MATHANG.SOLUONG + d.SOLUONG - i.SOLUONG
        FROM inserted AS i, deleted AS d 
		WHERE i.MAHANG = d.MAHANG and i.SOHOADON = d.SOHOADON
	END;
	UPDATE dbo.CHITIETDATHANG 
	SET GIABAN =  MH.GIAHANG
	FROM dbo.MATHANG AS MH
	WHERE MH.MAHANG = CHITIETDATHANG.MAHANG
END;


INSERT INTO dbo.DONDATHANG(SOHOADON,MAKHACHHANG, MANHANVIEN, NGAYDATHANG, NGAYGIAOHANG, NGAYCHUYENHANG, NOIGIAOHANG)
VALUES
		('HD3012','KH01', 'NV01', '2023-01-15', '2023-01-20', '2023-01-21', N'Hải Châu')
INSERT INTO dbo.CHITIETDATHANG
VALUES 
	('HD3011','MH025',NULL,10,default),
	('HD3001','MH2001',410000,30,default),
	('HD3002','MH2002',510000,30,default),
select * from dbo.MATHANG
select * from dbo.CHITIETDATHANG

delete from dbo.CHITIETDATHANG
WHERE SOHOADON ='HD3011';

update dbo.CHITIETDATHANG 
SET SOLUONG = 30 
WHERE SOHOADON ='HD3011' and MAHANG ='MH025'