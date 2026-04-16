USE [QLPhongGym];
GO

--========================================--
-- 1. XÓA BẢNG AN TOÀN (TỪ CON LÊN CHA)   --
--========================================--
-- XÓA TÀN DƯ CŨ NẾU CÓ
IF OBJECT_ID('CHITIET_HOADON_BANLE', 'U') IS NOT NULL DROP TABLE CHITIET_HOADON_BANLE;
IF OBJECT_ID('HOADON_BANLE', 'U') IS NOT NULL DROP TABLE HOADON_BANLE;

-- Xóa các bảng giao dịch liên quan đến Khách hàng
IF OBJECT_ID('CHITIET_HOADON', 'U') IS NOT NULL DROP TABLE CHITIET_HOADON; 
IF OBJECT_ID('HOADON', 'U') IS NOT NULL DROP TABLE HOADON;                 
IF OBJECT_ID('THANHTOAN', 'U') IS NOT NULL DROP TABLE THANHTOAN;
IF OBJECT_ID('DIEMDANH', 'U') IS NOT NULL DROP TABLE DIEMDANH;
IF OBJECT_ID('LICHTAP', 'U') IS NOT NULL DROP TABLE LICHTAP;
IF OBJECT_ID('DANGKY', 'U') IS NOT NULL DROP TABLE DANGKY;

-- Cuối cùng mới xóa bảng Khách hàng
IF OBJECT_ID('KHACHHANG', 'U') IS NOT NULL DROP TABLE KHACHHANG;
GO


--========================================--
--========== 2. TẠO BẢNG KHÁCH HÀNG ======--
--========================================--
CREATE TABLE KHACHHANG (
    MaKH INT IDENTITY(1,1) PRIMARY KEY,
    TenKH NVARCHAR(100) NOT NULL,
    GioiTinh NVARCHAR(10) NULL,
    NgaySinh DATE NULL,
    SDT NVARCHAR(15) NOT NULL,
    Email NVARCHAR(100) NULL,
    NgaySua DATETIME DEFAULT GETDATE(),
    DaXoa BIT DEFAULT 0
);
GO

-- Kiểm tra trùng lặp SDT và Email
ALTER TABLE KHACHHANG ADD CONSTRAINT UQ_SDT_KH UNIQUE (SDT);
ALTER TABLE KHACHHANG ADD CONSTRAINT UQ_Email_KH UNIQUE (Email);

-- Kiểm tra tuổi >= 15
ALTER TABLE KHACHHANG ADD CONSTRAINT CK_Tuoi_KH CHECK (DATEDIFF(YEAR, NgaySinh, GETDATE()) >= 15);
GO


--========================================--
--========== 3. THÊM DỮ LIỆU MẪU =========--
--========================================--
--========================================--
--========== 3. THÊM DỮ LIỆU MẪU =========--
--========================================--
-- Xóa dữ liệu cũ theo thứ tự liên kết
IF OBJECT_ID('CHITIET_HOADON_BANLE', 'U') IS NOT NULL DELETE FROM CHITIET_HOADON_BANLE;
IF OBJECT_ID('HOADON_BANLE', 'U') IS NOT NULL DELETE FROM HOADON_BANLE;

IF OBJECT_ID('CHITIET_HOADON', 'U') IS NOT NULL DELETE FROM CHITIET_HOADON;
IF OBJECT_ID('HOADON', 'U') IS NOT NULL DELETE FROM HOADON;
IF OBJECT_ID('THANHTOAN', 'U') IS NOT NULL DELETE FROM THANHTOAN;
IF OBJECT_ID('DIEMDANH', 'U') IS NOT NULL DELETE FROM DIEMDANH;
IF OBJECT_ID('LICHTAP', 'U') IS NOT NULL DELETE FROM LICHTAP;
IF OBJECT_ID('DANGKY', 'U') IS NOT NULL DELETE FROM DANGKY;
IF OBJECT_ID('KHACHHANG', 'U') IS NOT NULL DELETE FROM KHACHHANG;

-- Reset ID để khách hàng mới bắt đầu từ 1
IF OBJECT_ID('KHACHHANG', 'U') IS NOT NULL DBCC CHECKIDENT ('KHACHHANG', RESEED, 1);
GO

-- Thêm dữ liệu
INSERT INTO KHACHHANG (TenKH, GioiTinh, NgaySinh, SDT, Email)
VALUES 
(N'Nguyễn Văn Tuấn', N'Nam', '2000-05-10', '0912345678', 'tuan.nguyen@gmail.com'),
(N'Trần Thị Lan', N'Nữ', '2002-08-15', '0987654321', 'lan.tran@gmail.com'),
(N'Lê Minh Hoàng', N'Nam', '2001-01-01', '0909123456', 'hoang.le@gmail.com'),
(N'Phạm Thị Hương', N'Nữ', '1999-12-20', '0911988776', 'huong.pham@gmail.com'),
(N'Hồ Văn An', N'Nam', '2003-03-05', '0977554433', 'an.ho@gmail.com'),
(N'Vũ Thị Mai', N'Nữ', '2000-07-22', '0933221144', 'mai.vu@gmail.com'),
(N'Phan Văn Duy', N'Nam', '1998-11-11', '0944556677', 'duy.phan@gmail.com'),
(N'Ngô Thị Nhung', N'Nữ', '2002-02-28', '0922334455', 'nhung.ngo@gmail.com'),
(N'Bùi Minh Quân', N'Nam', '2001-09-09', '0911223344', 'quan.bui@gmail.com'),
(N'Đặng Thị Phương', N'Nữ', '1999-06-06', '0988776655', 'phuong.dang@gmail.com'),
(N'Lý Gia Bảo', N'Nam', '2004-12-12', '0901234455', 'bao.ly@gmail.com'),
(N'Trương Mỹ Linh', N'Nữ', '2001-05-30', '0905667788', 'linh.truong@gmail.com'),
(N'Hoàng Văn Nam', N'Nam', '1997-03-15', '0934112233', 'nam.hoang@gmail.com'),
(N'Nguyễn Bích Diệp', N'Nữ', '2002-10-10', '0978990011', 'diep.nguyen@gmail.com'),
(N'Đỗ Minh Triết', N'Nam', '2000-11-25', '0912554433', 'triet.do@gmail.com'),
(N'Tạ Minh Anh', N'Nữ', '2003-06-18', '0981223344', 'anh.ta@gmail.com'),
(N'Võ Thành Công', N'Nam', '1996-08-08', '0903887766', 'cong.vo@gmail.com'),
(N'Lương Thu Thảo', N'Nữ', '2002-04-12', '0966554433', 'thao.luong@gmail.com'),
(N'Trần Quốc Việt', N'Nam', '1999-01-20', '0902112233', 'viet.tran@gmail.com'),
(N'Mai Phương Thúy', N'Nữ', '2001-12-05', '0945667788', 'thuy.mai@gmail.com'),
(N'Đinh Công Thành', N'Nam', '2003-09-14', '0919223344', 'thanh.dinh@gmail.com'),
(N'Quách Ngọc Ngoan', N'Nam', '1995-02-10', '0908112233', 'ngoan.quach@gmail.com'),
(N'Phạm Hồng Nhung', N'Nữ', '2000-03-25', '0937445566', 'nhung.pham@gmail.com'),
(N'Cao Thái Sơn', N'Nam', '1998-07-30', '0909556677', 'son.cao@gmail.com'),
(N'Nguyễn Khánh Ngọc', N'Nữ', '2004-01-15', '0982334455', 'ngoc.nguyen@gmail.com'),
(N'Trần Thanh Hải', N'Nam', '2002-06-20', '0917667788', 'hai.tran@gmail.com'),
(N'Lê Thị Kim Chi', N'Nữ', '1997-11-05', '0933889900', 'chi.le@gmail.com'),
(N'Dương Gia Huy', N'Nam', '2001-02-28', '0904112233', 'huy.duong@gmail.com'),
(N'Nguyễn Minh Tuyết', N'Nữ', '2003-08-12', '0962334455', 'tuyet.nguyen@gmail.com'),
(N'Vương Anh Tú', N'Nam', '2000-04-04', '0918556677', 'tu.vuong@gmail.com');
GO

-- Xem dữ liệu
SELECT 
    'KH' + FORMAT(MaKH, '00') AS [ID], 
    TenKH AS [Họ Tên KH],
    GioiTinh AS [Giới Tính],
    CONVERT(VARCHAR, NgaySinh, 103) AS [Ngày Sinh], 
    SDT AS [Số Điện Thoại],
    Email,
    FORMAT(NgaySua, 'dd/MM/yyyy    HH:mm') AS [Lần Cập Nhật Cuối]
FROM KHACHHANG
WHERE DaXoa = 0;
GO


--========================================--
--========== 4. CẬP NHẬT DỮ LIỆU =========--
--========================================--
-- Sửa dữ liệu khách hàng số 3
UPDATE KHACHHANG
SET SDT = '0911002233',
    Email = 'hoang.le@newmail.com',
    NgaySua = GETDATE()
WHERE MaKH = 3;
GO

-- Xem dữ liệu sau khi sửa
SELECT 
    'KH' + FORMAT(MaKH, '00') AS [ID], 
    TenKH AS [Họ Tên KH],
    GioiTinh AS [Giới Tính],
    CONVERT(VARCHAR, NgaySinh, 103) AS [Ngày Sinh], 
    SDT AS [Số Điện Thoại],
    Email,
    FORMAT(NgaySua, 'dd/MM/yyyy    HH:mm') AS [Lần Cập Nhật Cuối]
FROM KHACHHANG
WHERE DaXoa = 0;
GO


--========================================--
--========== 5. XÓA VÀ XEM DỮ LIỆU =======--
--========================================--
-- XÓA DỮ LIỆU (Xóa mềm - Soft Delete)
UPDATE KHACHHANG
SET 
    DaXoa = 1,
    NgaySua = GETDATE()
WHERE MaKH = 3 AND DaXoa = 0; 
GO

-- XEM DANH SÁCH KHÁCH HÀNG ĐANG HOẠT ĐỘNG
SELECT 
    'KH' + FORMAT(MaKH, '00') AS [ID], 
    TenKH AS [Họ Tên KH],
    GioiTinh AS [Giới Tính],
    CONVERT(VARCHAR, NgaySinh, 103) AS [Ngày Sinh], 
    SDT AS [Số Điện Thoại],
    Email,
    FORMAT(NgaySua, 'dd/MM/yyyy HH:mm') AS [Cập Nhật Cuối]
FROM KHACHHANG
WHERE DaXoa = 0 
ORDER BY MaKH ASC; 
GO

-- XEM THÙNG RÁC (Các khách hàng đã bị xóa)
SELECT 
    'KH' + FORMAT(MaKH, '00') AS [ID], 
    TenKH AS [Họ Tên KH],
    N'❌ Đã xóa' AS [Trạng Thái],
    FORMAT(NgaySua, 'dd/MM/yyyy HH:mm') AS [Thời Điểm Xóa]
FROM KHACHHANG
WHERE DaXoa = 1;
GO


--========================================--
--========== 6. TÌM KIẾM DỮ LIỆU =========--
--========================================--
-- 1. Tìm kiếm theo Tên
DECLARE @SearchName NVARCHAR(100) = N'Nhung';
SELECT 
    'KH' + FORMAT(MaKH, '00') AS [ID],
    TenKH AS [Họ Tên KH],
    GioiTinh AS [Giới Tính],
    CONVERT(VARCHAR, NgaySinh, 103) AS [Ngày Sinh], 
    SDT AS [Số Điện Thoại],
    Email,
    CASE 
        WHEN DaXoa = 1 THEN N'Đã xóa'
        ELSE N'Đang hoạt động'
    END AS [Trạng Thái]
FROM KHACHHANG
WHERE TenKH LIKE N'%' + @SearchName + N'%'
AND DaXoa = 0 
ORDER BY TenKH ASC;
GO

-- 2. Tìm kiếm theo Số Điện Thoại
DECLARE @SearchSDT NVARCHAR(15) = '0912345678';
SELECT 
    'KH' + FORMAT(MaKH, '00') AS [ID], 
    TenKH AS [Họ Tên KH],
    GioiTinh AS [Giới Tính],
    CONVERT(VARCHAR, NgaySinh, 103) AS [Ngày Sinh], 
    SDT AS [Số Điện Thoại],
    Email,
    FORMAT(NgaySua, 'dd/MM/yyyy    HH:mm') AS [Lần Cập Nhật Cuối]
FROM KHACHHANG
WHERE (SDT = @SearchSDT OR SDT LIKE '%' + @SearchSDT)
AND DaXoa = 0;
GO

-- 3. TÌM KIẾM ĐA NĂNG
DECLARE @Keyword NVARCHAR(100) = N'2002'; 
SELECT 
    'KH' + FORMAT(MaKH, '00') AS [ID], 
    TenKH AS [Họ Tên KH],
    GioiTinh AS [Giới Tính],
    CONVERT(VARCHAR, NgaySinh, 103) AS [Ngày Sinh], 
    SDT AS [Số Điện Thoại],
    Email,
    FORMAT(NgaySua, 'dd/MM/yyyy    HH:mm') AS [Lần Cập Nhật Cuối]
FROM KHACHHANG
WHERE (
    FORMAT(MaKH, '00') LIKE '%' + @Keyword + '%'
    OR TenKH LIKE N'%' + @Keyword + N'%' 
    OR GioiTinh LIKE N'%' + @Keyword + N'%'
    OR CONVERT(VARCHAR, NgaySinh, 103) LIKE '%' + @Keyword + '%'
    OR SDT LIKE N'%' + @Keyword + '%'
)
AND DaXoa = 0;
GO