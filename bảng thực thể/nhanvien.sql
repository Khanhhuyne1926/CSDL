USE [QLPhongGym];
GO

--========================================--
-- 1. XÓA BẢNG AN TOÀN (TỪ CON LÊN CHA)   --
--========================================--
-- Xóa các bảng giao dịch liên quan đến Nhân viên trước
IF OBJECT_ID('CHITIET_HOADON', 'U') IS NOT NULL DROP TABLE CHITIET_HOADON;
IF OBJECT_ID('HOADON', 'U') IS NOT NULL DROP TABLE HOADON;
IF OBJECT_ID('DIEMDANH', 'U') IS NOT NULL DROP TABLE DIEMDANH;

-- SAU CÙNG MỚI XÓA BẢNG NHANVIEN
IF OBJECT_ID('NHANVIEN', 'U') IS NOT NULL DROP TABLE NHANVIEN;
GO


--========================================--
--========== 2. TẠO BẢNG NHÂN VIÊN =======--
--========================================--
CREATE TABLE NHANVIEN (
    MaNV INT IDENTITY(1,1) PRIMARY KEY,     
    TenNV NVARCHAR(100) NOT NULL,      
    ChucVu NVARCHAR(50) NOT NULL, -- Lễ tân, Quản lý, Bảo vệ, Tạp vụ
    GioiTinh NVARCHAR(10) NULL,
    NgaySinh DATE NULL,
    SDT NVARCHAR(15) NOT NULL,
    LuongCoBan DECIMAL(18,2) CHECK (LuongCoBan >= 0),
    NgayVaoLam DATE DEFAULT GETDATE(),

    -- Các cột đồng bộ hệ thống
    NgaySua DATETIME DEFAULT GETDATE(),
    DaXoa BIT DEFAULT 0,

    CONSTRAINT UQ_SDT_NV UNIQUE (SDT)
);

ALTER TABLE NHANVIEN ADD CONSTRAINT CK_GioiTinh_NV CHECK (GioiTinh IN (N'Nam', N'Nữ', N'Khác'));
ALTER TABLE NHANVIEN ADD CONSTRAINT CK_SDT_Format CHECK (LEN(SDT) BETWEEN 10 AND 11 AND SDT NOT LIKE '%[^0-9]%');
GO


--========================================--
--========== 3. THÊM DỮ LIỆU MẪU =========--
--========================================--
-- Xóa dữ liệu theo thứ tự con -> cha
IF OBJECT_ID('CHITIET_HOADON', 'U') IS NOT NULL DELETE FROM CHITIET_HOADON;
IF OBJECT_ID('HOADON', 'U') IS NOT NULL DELETE FROM HOADON;
IF OBJECT_ID('DIEMDANH', 'U') IS NOT NULL DELETE FROM DIEMDANH;
IF OBJECT_ID('NHANVIEN', 'U') IS NOT NULL DELETE FROM NHANVIEN;

-- Reset ID tự tăng về 0 để nhân viên đầu tiên bắt đầu từ 1
IF OBJECT_ID('NHANVIEN', 'U') IS NOT NULL DBCC CHECKIDENT ('NHANVIEN', RESEED, 1);
GO

INSERT INTO NHANVIEN (TenNV, ChucVu, GioiTinh, NgaySinh, SDT, LuongCoBan, NgayVaoLam)
VALUES 
(N'Lê Thị Hồng', N'Lễ tân', N'Nữ', '2002-05-20', '0912001122', 7000000, '2025-01-10'),
(N'Nguyễn Thành Nam', N'Quản lý', N'Nam', '1995-11-15', '0988112233', 15000000, '2024-06-01'),
(N'Phạm Văn Bình', N'Bảo vệ', N'Nam', '1988-03-12', '0905334455', 6500000, '2025-02-15'),
(N'Trần Thị Thắm', N'Tạp vụ', N'Nữ', '1990-08-25', '0977445566', 6000000, '2025-03-01'),
(N'Hoàng Mỹ Linh', N'Lễ tân', N'Nữ', '2001-12-30', '0944667788', 7000000, '2025-01-15'),
(N'Đặng Minh Quân', N'Kỹ thuật', N'Nam', '1997-04-05', '0911223344', 9500000, '2024-08-20'),
(N'Vũ Hải Yến', N'Kế toán', N'Nữ', '1999-09-18', '0922334455', 11000000, '2024-12-05'),
(N'Lý Văn Thắng', N'Bán hàng', N'Nam', '1992-01-22', '0933445566', 13000000, '2024-05-15'),
(N'Bùi Tuyết Mai', N'Tạp vụ', N'Nữ', '2003-11-11', '0955667788', 5500000, '2025-03-10'),
(N'Ngô Quốc Anh', N'Kỹ thuật', N'Nam', '1996-07-28', '0966778899', 9500000, '2024-10-01');
GO


--========================================--
--========== 4. TRUY VẤN DỮ LIỆU =========--
--========================================--
SELECT 
    'NV' + FORMAT(MaNV, '00') AS [ID],
    TenNV AS [Họ Tên NV],
    ChucVu AS [Chức Vụ],
    GioiTinh AS [Giới Tính],
    FORMAT(NgaySinh, 'dd/MM/yyyy') AS [Ngày Sinh],
    SDT AS [Số Điện Thoại],
    FORMAT(LuongCoBan, '#,###') + ' VND' AS [Lương Cơ Bản],
    FORMAT(NgayVaoLam, 'dd/MM/yyyy') AS [Ngày Vào Làm],
    FORMAT(NgaySua, 'dd/MM/yyyy     HH:mm') AS [Lần Cập Nhật Cuối]
FROM NHANVIEN
WHERE DaXoa = 0;
GO


--========================================--
--========== 5. CẬP NHẬT THÔNG TIN =======--
--========================================--
-- Tăng lương cho nhân viên quản lý
UPDATE NHANVIEN
SET LuongCoBan = 16000000, NgaySua = GETDATE()
WHERE MaNV = 2;
GO

-- Xem lại thông tin
SELECT 
    'NV' + FORMAT(MaNV, '00') AS [ID],
    TenNV AS [Họ Tên NV],
    ChucVu AS [Chức Vụ],
    GioiTinh AS [Giới Tính],
    FORMAT(NgaySinh, 'dd/MM/yyyy') AS [Ngày Sinh],
    SDT AS [Số Điện Thoại],
    FORMAT(LuongCoBan, '#,###') + ' VND' AS [Lương Cơ Bản],
    FORMAT(NgayVaoLam, 'dd/MM/yyyy') AS [Ngày Vào Làm],
    FORMAT(NgaySua, 'dd/MM/yyyy     HH:mm') AS [Lần Cập Nhật Cuối]
FROM NHANVIEN
WHERE DaXoa = 0;
GO


--========================================--
--========== 6. XEM THÙNG RÁC (ĐÃ NGHỈ) ==--
--========================================--
-- Xóa mềm nhân viên nghỉ việc
UPDATE NHANVIEN SET DaXoa = 1, NgaySua = GETDATE() WHERE MaNV = 4;

SELECT 
    'NV' + FORMAT(MaNV, '00') AS [ID],
    TenNV AS [Nhân Viên Đã Nghỉ],
    ChucVu AS [Chức Vụ Cũ],
    FORMAT(NgaySua, 'dd/MM/yyyy HH:mm') AS [Ngày Nghỉ Việc]
FROM NHANVIEN
WHERE DaXoa = 1;
GO


--========================================--
--========== 7. BÁO CÁO NHÂN SỰ ==========--
--========================================--
SELECT 
    COUNT(MaNV) AS [Tổng Nhân Viên],
    FORMAT(SUM(LuongCoBan), '#,### VNĐ') AS [Tổng Quỹ Lương],
    FORMAT(AVG(LuongCoBan), '#,### VNĐ') AS [Lương Trung Bình]
FROM NHANVIEN
WHERE DaXoa = 0;

-- Thống kê số lượng theo chức vụ
SELECT 
    ChucVu AS [Bộ Phận],
    COUNT(MaNV) AS [Số Nhân Sự],
    FORMAT(SUM(LuongCoBan), '#,### VNĐ') AS [Tổng Lương Bộ Phận]
FROM NHANVIEN
WHERE DaXoa = 0
GROUP BY ChucVu;
GO

SELECT 
    ChucVu, 
    FORMAT(SUM(LuongCoBan), '#,### VNĐ') AS [Quỹ Lương]
FROM NHANVIEN
WHERE DaXoa = 0
GROUP BY ChucVu
HAVING SUM(LuongCoBan) > 15000000
ORDER BY SUM(LuongCoBan) DESC;
GO


--========================================--
--========== 8. TÌM KIẾM DỮ LIỆU =========--
--========================================--
-- 1. Tìm kiếm bằng từ khóa
DECLARE @fKeySearch NVARCHAR(100) = N'Lễ tân';

SELECT 
    'NV' + FORMAT(MaNV, '00') AS [ID],
    TenNV AS [Họ Tên],
    ChucVu AS [Chức Vụ],
    GioiTinh AS [Giới Tính],
    SDT AS [Số Điện Thoại],
    FORMAT(LuongCoBan, '#,###') + ' VND' AS [Lương Cơ Bản],
    
    CASE 
        WHEN DaXoa = 1 THEN N'❌ Đã nghỉ việc'
        ELSE N'✅ Đang làm việc'
    END AS [Trạng Thái],
    
    FORMAT(NgaySua, 'dd/MM/yyyy HH:mm') AS [Cập Nhật Cuối]
FROM NHANVIEN
WHERE (
    TenNV LIKE N'%' + @fKeySearch + N'%'      
    OR ChucVu LIKE N'%' + @fKeySearch + N'%'  
    OR SDT LIKE '%' + @fKeySearch + '%'       
    OR 'NV' + FORMAT(MaNV, '00') LIKE '%' + @fKeySearch + '%' 
)
ORDER BY TenNV ASC;
GO

-- 2. Tìm kiếm nhân viên theo khoảng lương
DECLARE @MinLuong DECIMAL = 6000000;
DECLARE @MaxLuong DECIMAL = 10000000;

SELECT * FROM NHANVIEN
WHERE LuongCoBan BETWEEN @MinLuong AND @MaxLuong
AND DaXoa = 0;
GO

-- 3. Tìm nhân viên có lương cao hơn lương trung bình của bộ phận 'Lễ tân'
SELECT TenNV, LuongCoBan
FROM NHANVIEN
WHERE DaXoa = 0
GROUP BY TenNV, LuongCoBan
HAVING LuongCoBan > (SELECT AVG(LuongCoBan) FROM NHANVIEN WHERE ChucVu = N'Lễ tân');
GO


--========================================--
--========== 9. NHÂN VIÊN GẮN BÓ LÂU DÀI==--
--========================================--
SELECT TOP 3
    TenNV AS [Nhân Viên Ưu Tú],
    ChucVu,
    DATEDIFF(DAY, NgayVaoLam, GETDATE()) AS [Số Ngày Gắn Bó],
    N'⭐ Cần khen thưởng' AS [Đề xuất]
FROM NHANVIEN
WHERE DaXoa = 0
ORDER BY NgayVaoLam ASC;
GO