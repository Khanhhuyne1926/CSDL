USE [QLPhongGym];
GO

--========================================--
-- 1. XÓA BẢNG AN TOÀN (TỪ CON LÊN CHA)   --
--========================================--
-- Xóa các bảng giao dịch liên quan đến Gói tập
IF OBJECT_ID('THANHTOAN', 'U') IS NOT NULL DROP TABLE THANHTOAN;
IF OBJECT_ID('DANGKY', 'U')   IS NOT NULL DROP TABLE DANGKY;

-- SAU ĐÓ XÓA BẢNG CHA (Bảng chính của file này)
IF OBJECT_ID('GOITAP', 'U') IS NOT NULL DROP TABLE GOITAP;
GO




--========================================--
--========== 2. TẠO BẢNG GÓI TẬP =========--
--========================================--
CREATE TABLE GOITAP (
    MaGoi INT IDENTITY(1,1) PRIMARY KEY,
    TenGoi NVARCHAR(100) NOT NULL,
    ThoiHan INT NOT NULL,
    Gia DECIMAL(10,2) NOT NULL,
    MoTa NVARCHAR(255) NULL,
    NgaySua DATETIME DEFAULT GETDATE(),
    DaXoa BIT DEFAULT 0
);


-- Ràng buộc dữ liệu
ALTER TABLE GOITAP ADD CONSTRAINT CK_GOITAP_ThoiHan CHECK (ThoiHan > 0);
ALTER TABLE GOITAP ADD CONSTRAINT CK_GOITAP_Gia CHECK (Gia > 0);
GO




--========================================--
--========== 3. THÊM DỮ LIỆU MẪU =========--
--========================================--
-- Xóa dữ liệu cũ theo thứ tự liên kết
IF OBJECT_ID('THANHTOAN', 'U') IS NOT NULL DELETE FROM THANHTOAN;
IF OBJECT_ID('DANGKY', 'U')   IS NOT NULL DELETE FROM DANGKY;
IF OBJECT_ID('GOITAP', 'U')   IS NOT NULL DELETE FROM GOITAP;

-- Reset ID tự tăng về 0 để Gói đầu tiên là 1
IF OBJECT_ID('GOITAP', 'U')   IS NOT NULL DBCC CHECKIDENT ('GOITAP', RESEED, 1);
GO


INSERT INTO GOITAP (TenGoi, ThoiHan, Gia, MoTa)
VALUES
(N'Gói 1 tháng', 30, 500000, N'Tập cơ bản, không giới hạn thời gian trong ngày'),
(N'Gói 3 tháng', 90, 1200000, N'Tiết kiệm chi phí, phù hợp người tập lâu dài'),
(N'Gói 6 tháng', 180, 2200000, N'Tặng kèm 5 buổi hướng dẫn với HLV'),
(N'Gói 12 tháng', 365, 4000000, N'Không giới hạn + ưu đãi đặc biệt'),
(N'Gói VIP', 30, 1500000, N'Có huấn luyện viên cá nhân (PT riêng)'),
(N'Gói Sinh Viên', 30, 350000, N'Giá ưu đãi dành riêng cho sinh viên (tập trước 16h)'),
(N'Gói Offline 7 Ngày', 7, 150000, N'Dành cho khách du lịch hoặc trải nghiệm ngắn hạn'),
(N'Gói Yoga Chuyên Sâu', 30, 800000, N'Chỉ bao gồm các lớp Yoga với Master nước ngoài'),
(N'Gói Zumba & Aerobics', 30, 700000, N'Tập trung vào các lớp nhảy và nhạc sôi động'),
(N'Gói VIP 12 Tháng', 365, 15000000, N'Full dịch vụ: PT riêng, khăn tắm, nước uống, xông hơi'),
(N'Gói Tập Sáng', 30, 400000, N'Khung giờ từ 5:00 - 10:00 sáng hàng ngày'),
(N'Gói Tập Đêm', 30, 400000, N'Khung giờ từ 20:00 - 23:00 đêm hàng ngày'),
(N'Gói Cặp Đôi (2 người)', 30, 900000, N'Ưu đãi khi đăng ký 2 người cùng lúc'),
(N'Gói Gia Đình (4 người)', 30, 1600000, N'Phù hợp cho cả gia đình cùng rèn luyện sức khỏe'),
(N'Gói Giảm Cân Cấp Tốc', 60, 5000000, N'Liệu trình 2 tháng kèm thực đơn và PT theo sát');
GO


-- Xem dữ liệu
SELECT 
    'GT' + FORMAT(MaGoi, '00') AS [Mã Gói], 
    TenGoi AS [Tên Gói Tập],
    CAST(ThoiHan AS VARCHAR) + N' Ngày' AS [Thời Hạn],
    FORMAT(Gia, '##,#') + ' VNĐ' AS [Giá Gói], 
    MoTa AS [Mô tả dịch vụ],
    FORMAT(NgaySua, 'dd/MM/yyyy     HH:mm') AS [Lần Cập Nhật Cuối]
FROM GOITAP;
GO




--========================================--
--========== 4. CẬP NHẬT VÀ XEM DỮ LIỆU ==--
--========================================--
UPDATE GOITAP
SET 
    ThoiHan = CASE 
        WHEN MaGoi = 1 THEN 60
        WHEN MaGoi = 2 THEN 125
    END,
    Gia = CASE 
        WHEN MaGoi = 1 THEN 800000
        WHEN MaGoi = 2 THEN 1600000
    END,
    NgaySua = GETDATE()
WHERE MaGoi IN (1,2);
GO


-- Xem dữ liệu sau cập nhật
SELECT 
    'GT' + FORMAT(MaGoi, '00') AS [Mã Gói], 
    TenGoi AS [Tên Gói Tập],
    CAST(ThoiHan AS VARCHAR) + N' Ngày' AS [Thời Hạn],
    FORMAT(Gia, '##,#') + ' VNĐ' AS [Giá Gói], 
    MoTa AS [Mô tả dịch vụ],
    FORMAT(NgaySua, 'dd/MM/yyyy     HH:mm') AS [Lần Cập Nhật Cuối]
FROM GOITAP;
GO




--========================================--
--========== 5. XÓA VÀ XEM DỮ LIỆU =======--
--========================================--
-- Xóa dữ liệu (Xóa mềm)
UPDATE GOITAP
SET DaXoa = 1,
    NgaySua = GETDATE(),
    MoTa = MoTa + N' (Đã ngừng kinh doanh)'
WHERE MaGoi = 3 AND DaXoa = 0;
GO


-- Xem dữ liệu các gói còn hoạt động
SELECT 
    'GT' + FORMAT(MaGoi, '00') AS [Mã Gói], 
    TenGoi AS [Tên Gói Tập],
    CAST(ThoiHan AS VARCHAR) + N' Ngày' AS [Thời Hạn],
    FORMAT(Gia, '##,#') + ' VNĐ' AS [Giá Gói], 
    MoTa AS [Ghi Chú Dịch Vụ],
    FORMAT(NgaySua, 'dd/MM/yyyy HH:mm') AS [Cập Nhật Cuối]
FROM GOITAP
WHERE DaXoa = 0 
ORDER BY Gia DESC; 
GO


-- Xem thùng rác
SELECT 
    'GT' + FORMAT(MaGoi, '00') AS [Mã Gói], 
    TenGoi AS [Tên Gói Tập],
    CAST(ThoiHan AS VARCHAR) + N' Ngày' AS [Thời Hạn],
    FORMAT(Gia, '##,#') + ' VNĐ' AS [Giá Gói], 
    CASE 
        WHEN DaXoa = 1 THEN N'❌ Đã ngừng kinh doanh'
        ELSE N'✅ Đang kinh doanh'
    END AS [Trạng Thái],
    MoTa AS [Lý do/Mô tả],
    FORMAT(NgaySua, 'dd/MM/yyyy HH:mm') AS [Thời Điểm Xóa]
FROM GOITAP
WHERE DaXoa = 1 
ORDER BY NgaySua DESC;
GO


--========================================--
--========== 6. TÌM KIẾM DỮ LIỆU =========--
--========================================--
DECLARE @fTuKhoa    NVARCHAR(100) = NULL;         
DECLARE @fGiaTu     INT           = 500000;       
DECLARE @fGiaDen    INT           = 2000000;     
DECLARE @fTrangThai BIT           = NULL;         

SELECT 
    'GT' + FORMAT(MaGoi, '00') AS [Mã Gói], 
    TenGoi AS [Tên Gói Tập],
    CAST(ThoiHan AS VARCHAR) + N' Ngày' AS [Thời Hạn],
    FORMAT(Gia, '##,#') + ' VNĐ' AS [Giá Gói], 
    CASE 
        WHEN DaXoa = 0 THEN N'✅ Đang kinh doanh'
        ELSE N'❌ Ngừng kinh doanh'
    END AS [Trạng Thái],
    MoTa AS [Mô tả chi tiết]
FROM GOITAP
WHERE 
    (@fTuKhoa IS NULL OR (TenGoi LIKE N'%' + @fTuKhoa + N'%' OR MoTa LIKE N'%' + @fTuKhoa + N'%'))
    AND (@fGiaTu IS NULL OR Gia >= @fGiaTu)
    AND (@fGiaDen IS NULL OR Gia <= @fGiaDen)
    AND (@fTrangThai IS NULL OR DaXoa = @fTrangThai)
ORDER BY 
    DaXoa ASC, 
    Gia DESC;  
GO