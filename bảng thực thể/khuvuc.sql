USE [QLPhongGym];
GO

--========================================--
-- 1. XÓA BẢNG AN TOÀN (TỪ CON LÊN CHA)   --
--========================================--
-- Nếu sau này có bảng nào tham chiếu đến THIETBI, bạn cần DROP bảng đó trước
IF OBJECT_ID('THIETBI', 'U') IS NOT NULL DROP TABLE THIETBI;
IF OBJECT_ID('KHUVUC', 'U') IS NOT NULL DROP TABLE KHUVUC;
GO




--========================================--
--========== 2. TẠO BẢNG KHUVUC ==========--
--========================================--
CREATE TABLE KHUVUC (
    MaKV INT IDENTITY(1,1) PRIMARY KEY,
    TenKV NVARCHAR(50) NOT NULL,
    Tang INT DEFAULT 1,
    GhiChu NVARCHAR(100),
    NgaySua DATETIME DEFAULT GETDATE(),
    DaXoa BIT DEFAULT 0 -- 0: Hoạt động, 1: Đã xóa (Thùng rác)
);
GO




--========================================--
--========== 3. THÊM DỮ LIỆU MẪU =========--
--========================================--
-- Xóa dữ liệu cũ theo thứ tự liên kết (Con -> Cha)
IF OBJECT_ID('THIETBI', 'U') IS NOT NULL DELETE FROM THIETBI;
IF OBJECT_ID('KHUVUC', 'U') IS NOT NULL DELETE FROM KHUVUC;

-- Reset ID tự tăng về 0 để bản ghi đầu tiên bắt đầu từ 1
IF OBJECT_ID('KHUVUC', 'U') IS NOT NULL DBCC CHECKIDENT ('KHUVUC', RESEED, 1);
IF OBJECT_ID('THIETBI', 'U') IS NOT NULL DBCC CHECKIDENT ('THIETBI', RESEED, 1);
GO


INSERT INTO KHUVUC (TenKV, Tang, GhiChu)
VALUES 
(N'Khu Cardio', 1, N'Máy chạy bộ, xe đạp, trượt tuyết'),
(N'Khu Tạ Nặng', 1, N'Free weights, sàn cao su chống rung'),
(N'Khu Cơ Ngực', 1, N'Dãy máy khối Selectorized'),
(N'Phòng Yoga 1', 2, N'Yên tĩnh, có gương toàn thân'),
(N'Phòng Pilates', 2, N'Khu vực máy Reformer/Cadillac'),
(N'Khu Đối Kháng', 2, N'Sàn thảm xốp, bao cát'),
(N'Khu Stretching', 2, N'Khu vực giãn cơ, bóng tập'),
(N'Khu Thư Giãn', 2, N'Ghế massage và khu chờ'),
(N'Khu Sảnh/Check-in', 1, N'Quầy lễ tân và kiểm soát ra vào');
GO


-- 1. Xem danh sách các khu vực ĐANG HOẠT ĐỘNG
SELECT 
    'KV' + FORMAT(MaKV, '00') AS [Mã KV], 
    TenKV AS [Tên Khu Vực],
    N'Tầng ' + CAST(Tang AS NVARCHAR) AS [Vị Trí],
    GhiChu AS [Ghi Chú],
    FORMAT(NgaySua, 'dd/MM/yyyy  HH:mm') AS [Lần Cập Nhật Cuối]
FROM KHUVUC
WHERE DaXoa = 0
ORDER BY Tang ASC;
GO




--========================================--
--========== 4. CẬP NHẬT DỮ LIỆU =========--
--========================================--
UPDATE KHUVUC
SET 
    TenKV = N'Khu Cardio & HIIT',
    GhiChu = N'Khu vực tập trung các dòng máy đốt calo cao',
    NgaySua = GETDATE()
WHERE MaKV = 1;
GO


-- Xem lại sau khi cập nhật
SELECT 
    'KV' + FORMAT(MaKV, '00') AS [Mã KV], 
    TenKV AS [Tên Khu Vực],
    N'Tầng ' + CAST(Tang AS NVARCHAR) AS [Vị Trí],
    GhiChu AS [Ghi Chú],
    FORMAT(NgaySua, 'dd/MM/yyyy  HH:mm') AS [Lần Cập Nhật Cuối]
FROM KHUVUC
WHERE DaXoa = 0
ORDER BY Tang ASC;
GO




--========================================--
--========== 5. XÓA VÀ XEM DỮ LIỆU =======--
--========================================--
-- Thực hiện xóa mềm khu vực số 9
UPDATE KHUVUC
SET DaXoa = 1,
    NgaySua = GETDATE(),
    GhiChu = GhiChu + N' (Khu vực hiện đang sửa chữa)'
WHERE MaKV = 9 AND DaXoa = 0;
GO


-- Thùng rác (Các khu vực đã ẩn)
SELECT 
    'KV' + FORMAT(MaKV, '00') AS [Mã KV], 
    TenKV AS [Tên Khu Vực],
    CASE WHEN DaXoa = 1 THEN N'❌ Tạm ngưng' END AS [Trạng Thái],
    GhiChu AS [Lý Do/Mô Tả],
    FORMAT(NgaySua, 'dd/MM/yyyy HH:mm') AS [Thời Điểm Xóa]
FROM KHUVUC
WHERE DaXoa = 1;
GO




--========================================--
--========== 6. TÌM KIẾM ĐA NĂNG =========--
--========================================--
DECLARE @fSearch NVARCHAR(100) = N'KV09'; 
DECLARE @fTrangThai BIT        = 1;     

SELECT 
    'KV' + FORMAT(MaKV, '00') AS [Mã KV], 
    TenKV AS [Tên Khu Vực],
    N'Tầng ' + CAST(Tang AS NVARCHAR) AS [Vị Trí],
    CASE 
        WHEN DaXoa = 0 THEN N'✅ Hoạt động'
        ELSE N'❌ Tạm ngưng'
    END AS [Trạng Thái],
    GhiChu AS [Mô Tả Chi Tiết]
FROM KHUVUC
WHERE 
    (@fTrangThai IS NULL OR DaXoa = @fTrangThai)
    AND (
        @fSearch IS NULL 
        OR TenKV LIKE N'%' + @fSearch + N'%'              
        OR GhiChu LIKE N'%' + @fSearch + N'%'             
        OR ('KV' + FORMAT(MaKV, '00')) LIKE @fSearch      
        OR CAST(Tang AS NVARCHAR) = @fSearch              
        OR (N'Tầng ' + CAST(Tang AS NVARCHAR)) LIKE N'%' + @fSearch + N'%' 
    )
ORDER BY DaXoa ASC, Tang ASC, MaKV ASC;
GO