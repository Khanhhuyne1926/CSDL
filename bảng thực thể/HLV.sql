USE [QLPhongGym];
GO

--========================================--
-- 1. XÓA BẢNG AN TOÀN (TỪ CON LÊN CHA)   --
--========================================--
-- Bảng HLV được tham chiếu bởi LICHTAP, DIEMDANH và DANGKY. 
-- (THANHTOAN phải xóa trước DANGKY)
IF OBJECT_ID('THANHTOAN', 'U') IS NOT NULL DROP TABLE THANHTOAN;
IF OBJECT_ID('DANGKY', 'U')    IS NOT NULL DROP TABLE DANGKY;
IF OBJECT_ID('DIEMDANH', 'U')  IS NOT NULL DROP TABLE DIEMDANH;
IF OBJECT_ID('LICHTAP', 'U')   IS NOT NULL DROP TABLE LICHTAP;

-- Sau đó mới xóa bảng chính HLV
IF OBJECT_ID('HLV', 'U') IS NOT NULL DROP TABLE HLV;
GO




--========================================--
--========== 2. TẠO BẢNG HLV =============--
--========================================--
CREATE TABLE HLV (
    MaHLV INT IDENTITY(1,1) NOT NULL,
    TenHLV NVARCHAR(100) NOT NULL,       
    ChuyenMon NVARCHAR(100) CONSTRAINT DF_ChuyenMon DEFAULT N'Fitness Trainer' NULL,
    SDT NVARCHAR(15) NOT NULL,
    GioiTinh NVARCHAR(10) NULL,

    NgaySua DATETIME DEFAULT GETDATE(),
    DaXoa BIT DEFAULT 0,
    
    CONSTRAINT PK_HLV PRIMARY KEY (MaHLV),
    CONSTRAINT UQ_SDT_HLV UNIQUE (SDT)
);

ALTER TABLE HLV ADD CONSTRAINT CK_GioiTinh_HLV CHECK (GioiTinh IN (N'Nam', N'Nữ', N'Khác'));
GO




--========================================--
--========== 3. THÊM DỮ LIỆU MẪU =========--
--========================================--
-- Xóa dữ liệu cũ theo thứ tự (Tránh lỗi FK)
IF OBJECT_ID('THANHTOAN', 'U') IS NOT NULL DELETE FROM THANHTOAN;
IF OBJECT_ID('DANGKY', 'U')    IS NOT NULL DELETE FROM DANGKY;
IF OBJECT_ID('DIEMDANH', 'U')  IS NOT NULL DELETE FROM DIEMDANH;
IF OBJECT_ID('LICHTAP', 'U')   IS NOT NULL DELETE FROM LICHTAP;
IF OBJECT_ID('HLV', 'U')       IS NOT NULL DELETE FROM HLV;

-- Reset ID để HLV bắt đầu từ 1
IF OBJECT_ID('HLV', 'U') IS NOT NULL DBCC CHECKIDENT ('HLV', RESEED, 1);
GO


--- Thêm dữ liệu ---
INSERT INTO HLV (TenHLV, GioiTinh, SDT, ChuyenMon)
VALUES
(N'Nguyễn Văn Hùng', N'Nam', '0912345670', N'Gym'),
(N'Trần Thị Mai', N'Nữ', '0987654320', N'Zumba'),
(N'Lê Minh Hoàng', N'Nam', '0909123450', N'Gym'),
(N'Phạm Thị Hương', N'Nữ', '0911988770', N'Pilates'),
(N'Hồ Văn An', N'Nam', '0977554430', N'Crossfit'),
(N'Vũ Thị Lan', N'Nữ', '0933221140', N'Yoga'),
(N'Phan Văn Duy', N'Nam', '0944556670', N'Gym'),
(N'Ngô Thị Nhung', N'Nữ', '0922334450', N'Zumba'),
(N'Bùi Minh Quân', N'Nam', '0911223340', N'Crossfit'),
(N'Đặng Thị Phương', N'Nữ', '0988776650', N'Pilates'),
(N'Vương Khánh Ngọc', N'Nữ', '0988776651', N'Aerobics'),
(N'Trần Văn Nam', N'Nam', '0901223344', N'Gym'),
(N'Lý Thu Thủy', N'Nữ', '0905667788', N'Yoga'),
(N'Hoàng Minh Đức', N'Nam', '0934112233', N'Boxing'),
(N'Nguyễn Mỹ Linh', N'Nữ', '0978990011', N'Aerobics'),
(N'Đỗ Hùng Dũng', N'Nam', '0912554433', N'Gym'),
(N'Tạ Thanh Huyền', N'Nữ', '0981223344', N'Zumba'),
(N'Võ Văn Quyết', N'Nam', '0903887766', N'Crossfit'),
(N'Lương Bích Hữu', N'Nữ', '0966554433', N'Pilates'),
(N'Trần Anh Khoa', N'Nam', '0902112233', N'Boxing'),
(N'Mai Thu Huyền', N'Nữ', '0945667788', N'Yoga'),
(N'Đinh Tiến Đạt', N'Nam', '0919223344', N'Gym'),
(N'Quách Tuấn Du', N'Nam', '0908112233', N'Zumba'),
(N'Phạm Quỳnh Anh', N'Nữ', '0937445566', N'Aerobics'),
(N'Cao Xuân Thắng', N'Nam', '0909556677', N'Gym'),
(N'Nguyễn Hồng Nhung', N'Nữ', '0982334455', N'Yoga'),
(N'Trần Bảo Sơn', N'Nam', '0917667788', N'Crossfit'),
(N'Lê Khánh Chi', N'Nữ', '0933889900', N'Pilates'),
(N'Dương Triệu Vũ', N'Nam', '0904112233', N'Boxing'),
(N'Nguyễn Phi Hùng', N'Nam', '0918556677', N'Gym');
GO


-- Xem dữ liệu
SELECT 
   'HLV' + FORMAT(MaHLV, '00') AS [ID], 
    TenHLV AS [Họ Tên HLV],
    GioiTinh AS [Giới Tính],
    SDT AS [Số Điện Thoại],
    ChuyenMon AS [Chuyên Môn],
    FORMAT(NgaySua, 'dd/MM/yyyy    HH:mm') AS [Lần Cập Nhật Cuối]
FROM HLV
WHERE DaXoa = 0
ORDER BY MaHLV;
GO




--========================================--
--========== 4. CẬP NHẬT VÀ XEM DỮ LIỆU ==--
--========================================--
UPDATE HLV
SET TenHLV = N'Hoàng Minh Tuấn',
    GioiTinh = N'Nam',
    SDT = '0911002233',
    ChuyenMon = N'Zumba',
    NgaySua = GETDATE()
WHERE MaHLV = 3;  
GO


-- Xem dữ liệu sau cập nhật
SELECT 
   'HLV' + FORMAT(MaHLV, '00') AS [ID], 
    TenHLV AS [Họ Tên HLV],
    GioiTinh AS [Giới Tính],
    SDT AS [Số Điện Thoại],
    ChuyenMon AS [Chuyên Môn],
    FORMAT(NgaySua, 'dd/MM/yyyy    HH:mm') AS [Lần Cập Nhật Cuối]
FROM HLV
WHERE DaXoa = 0
ORDER BY MaHLV;
GO




--========================================--
--========== 5. XÓA VÀ XEM DỮ LIỆU =======--
--========================================--
-- 1. XÓA DỮ LIỆU (Xóa mềm - Soft Delete)
UPDATE HLV
SET 
    DaXoa = 1,
    NgaySua = GETDATE()
WHERE MaHLV = 2 AND DaXoa = 0; 
GO


-- 2. XEM DANH SÁCH ĐANG HOẠT ĐỘNG
SELECT 
   'HLV' + FORMAT(MaHLV, '00') AS [ID], 
    TenHLV AS [Họ Tên HLV],
    GioiTinh AS [Giới Tính],
    SDT AS [Số Điện Thoại],
    ChuyenMon AS [Chuyên Môn],
    FORMAT(NgaySua, 'dd/MM/yyyy    HH:mm') AS [Lần Cập Nhật Cuối]
FROM HLV
WHERE DaXoa = 0 
ORDER BY MaHLV ASC; 
GO


-- 3. XEM THÙNG RÁC
SELECT 
    'HLV' + FORMAT(MaHLV, '00') AS [ID], 
    TenHLV AS [Họ Tên HLV],
    N'❌ Đã xóa' AS [Trạng Thái],
    FORMAT(NgaySua, 'dd/MM/yyyy HH:mm') AS [Thời Điểm Xóa]
FROM HLV
WHERE DaXoa = 1;
GO




--========================================--
--========== 6. TÌM KIẾM DỮ LIỆU =========--
--========================================--
DECLARE @SearchKey NVARCHAR(100) = N'Huyền'; 

SELECT 
    'HLV' + FORMAT(MaHLV, '00') AS [ID],
    TenHLV AS [Họ Tên],
    GioiTinh AS [Giới Tính],
    SDT AS [Số Điện Thoại],
    ChuyenMon AS [Chuyên Môn],
    CASE 
        WHEN DaXoa = 1 THEN N'Đã nghỉ'
        ELSE N'Đang làm việc'
    END AS [Trạng Thái]
FROM HLV
WHERE (
    TenHLV LIKE N'%' + @SearchKey + N'%'
    OR ChuyenMon LIKE N'%' + @SearchKey + N'%'
    OR GioiTinh LIKE N'%' + @SearchKey + N'%'
    OR FORMAT(MaHLV, '00') LIKE '%' + @SearchKey + '%'
)
AND DaXoa = 0 
ORDER BY TenHLV ASC;
GO