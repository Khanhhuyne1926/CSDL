USE [QLPhongGym];
GO

--========================================--
-- 1. XÓA BẢNG AN TOÀN (TỪ CON LÊN CHA)   --
--========================================--
-- Xóa bảng thanh toán trước vì nó tham chiếu đến đăng ký
IF OBJECT_ID('THANHTOAN', 'U') IS NOT NULL DROP TABLE THANHTOAN;
IF OBJECT_ID('DANGKY', 'U') IS NOT NULL DROP TABLE DANGKY;
GO




--========================================--
--========== 2. TẠO BẢNG ĐĂNG KÝ =========--
--========================================--
CREATE TABLE DANGKY (
    MaDK INT IDENTITY(1,1) PRIMARY KEY,
    MaKH INT NOT NULL,
    MaGoi INT NOT NULL,
    MaHLV INT,   
    
    NgayDangKy DATE DEFAULT GETDATE(),
    NgayBatDau DATE NOT NULL,
    NgayKetThuc DATE NOT NULL,
    
    -- Các cột đồng bộ hệ thống
    NgaySua DATETIME DEFAULT GETDATE(),
    DaXoa BIT DEFAULT 0,

    -- Thiết lập các khóa ngoại
    CONSTRAINT FK_DANGKY_KHACHHANG FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
    CONSTRAINT FK_DANGKY_GOITAP FOREIGN KEY (MaGoi) REFERENCES GOITAP(MaGoi),
    CONSTRAINT FK_DANGKY_HLV FOREIGN KEY (MaHLV) REFERENCES HLV(MaHLV)
);
GO

ALTER TABLE DANGKY ADD CONSTRAINT CK_ThoiHan_DK CHECK (NgayKetThuc >= NgayBatDau);
GO




--========================================--
-- 3. TRIGGER TỰ ĐỘNG TÍNH NGÀY KẾT THÚC  --
--========================================--
-- Trigger này sẽ tự động tính NgayKetThuc chuẩn xác 100% dựa vào ThoiHan của Gói Tập
CREATE TRIGGER TRG_DangKy_TinhNgayKetThuc
ON DANGKY
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Chỉ chạy nếu có sự thay đổi ở cột Ngày Bắt Đầu hoặc Gói Tập
    IF UPDATE(NgayBatDau) OR UPDATE(MaGoi)
    BEGIN
        UPDATE d
        SET NgayKetThuc = DATEADD(DAY, g.ThoiHan, d.NgayBatDau)
        FROM DANGKY d
        JOIN inserted i ON d.MaDK = i.MaDK
        JOIN GOITAP g ON i.MaGoi = g.MaGoi;
    END
END;
GO




--========================================--
--========== 4. THÊM VÀ XEM DỮ LIỆU ======--
--========================================--
-- Dọn dẹp dữ liệu cũ an toàn
IF OBJECT_ID('THANHTOAN', 'U') IS NOT NULL DELETE FROM THANHTOAN;
DELETE FROM DANGKY;

-- Reset ID về 0
DBCC CHECKIDENT ('DANGKY', RESEED, 1);
GO

-- Dù bạn nhập NgayKetThuc bằng tay ở đây, Trigger bên trên sẽ tự động 
-- ghi đè lại bằng kết quả tính toán chính xác nhất để tránh rủi ro sai sót con người.
INSERT INTO DANGKY (MaKH, MaGoi, MaHLV, NgayBatDau, NgayKetThuc)
VALUES 
    (15, 2, NULL, '2026-04-10', '2026-05-10'),
    (3, 1, 2, '2026-04-01', '2026-07-01'),
    (28, 4, NULL, '2026-04-25', '2026-05-25'),
    (7, 3, 5, '2026-04-05', '2027-04-05'),
    (12, 10, NULL, '2026-04-12', '2026-05-12'),
    (1, 1, 1, '2026-04-01', '2026-07-01'),
    (22, 5, 8, '2026-04-20', '2026-05-20'),
    (9, 9, 6, '2026-04-08', '2027-04-08'),
    (30, 2, 15, '2026-04-26', '2026-10-26'),
    (5, 2, 4, '2026-04-03', '2026-10-03'),
    (18, 14, 11, '2026-04-15', '2026-06-15'),
    (11, 6, NULL, '2026-04-11', '2026-04-18'),
    (2, 1, 1, '2026-04-02', '2026-05-02'),
    (25, 2, 13, '2026-04-22', '2026-10-22'),
    (13, 8, 9, '2026-04-13', '2026-05-13'),
    (6, 5, NULL, '2026-04-05', '2026-05-05'),
    (20, 1, 10, '2026-04-18', '2026-07-18'),
    (4, 3, NULL, '2026-04-04', '2027-04-04'),
    (17, 13, 12, '2026-04-14', '2026-05-14'),
    (24, 11, NULL, '2026-04-21', '2026-05-21'),
    (8, 2, 7, '2026-04-07', '2026-10-07'),
    (14, 12, NULL, '2026-04-14', '2026-05-14'),
    (21, 3, 4, '2026-04-19', '2026-05-19'),
    (10, 4, NULL, '2026-04-09', '2026-05-09'),
    (27, 7, 14, '2026-04-24', '2026-05-24'),
    (16, 1, 3, '2026-04-15', '2026-07-15'),
    (29, 5, NULL, '2026-04-25', '2026-05-25'),
    (15, 9, 2, '2026-04-17', '2027-04-17'),
    (23, 10, NULL, '2026-04-20', '2026-05-20'),
    (26, 3, 1, '2026-04-23', '2027-04-23');
GO


-- Xem dữ liệu
SELECT 
    'DK' + FORMAT(DK.MaDK, '00') AS [ID],
    KH.TenKH AS [Khách Hàng],
    GT.TenGoi AS [Gói Tập],
    ISNULL(HLV.TenHLV, N'--- Tự do ---') AS [HLV Phụ Trách],
    FORMAT(DK.NgayBatDau, 'dd/MM/yyyy') AS [Bắt Đầu],
    FORMAT(DK.NgayKetThuc, 'dd/MM/yyyy') AS [Kết Thúc],
    
    CASE 
        WHEN DATEDIFF(day, GETDATE(), DK.NgayKetThuc) < 0 THEN 0 
        ELSE DATEDIFF(day, GETDATE(), DK.NgayKetThuc) 
    END AS [Số Ngày Còn Lại],

    CASE 
        WHEN DATEDIFF(day, GETDATE(), DK.NgayKetThuc) < 0 THEN N'❌ Hết hạn'
        WHEN DATEDIFF(day, GETDATE(), DK.NgayKetThuc) <= 7 THEN N'⚠️ Sắp hết hạn'
        ELSE N'✅ Còn hạn'
    END AS [Trạng Thái],

    FORMAT(DK.NgaySua, 'dd/MM/yyyy    HH:mm') AS [Cập Nhật]
FROM DANGKY DK
JOIN KHACHHANG KH ON DK.MaKH = KH.MaKH
JOIN GOITAP GT ON DK.MaGoi = GT.MaGoi
LEFT JOIN HLV ON DK.MaHLV = HLV.MaHLV;
GO




--========================================--
--========== 5. CẬP NHẬT VÀ XEM DỮ LIỆU ==--
--========================================--
-- Cập nhật gói tập cho Mã Đăng Ký số 1
-- Bạn không cần truyền NgayKetThuc nữa, Trigger sẽ tự cập nhật theo Gói 2
UPDATE DANGKY 
SET 
    MaGoi = 2, 
    MaHLV = 2,
    NgaySua = GETDATE()             
WHERE MaDK = 1;   
GO


-- Xem dữ liệu sau cập nhật
SELECT 
    'DK' + FORMAT(DK.MaDK, '00') AS [ID],
    KH.TenKH AS [Khách Hàng],
    GT.TenGoi AS [Gói Tập],
    ISNULL(HLV.TenHLV, N'--- Tự do ---') AS [HLV Phụ Trách],
    FORMAT(DK.NgayBatDau, 'dd/MM/yyyy') AS [Bắt Đầu],
    FORMAT(DK.NgayKetThuc, 'dd/MM/yyyy') AS [Kết Thúc],
    
    CASE 
        WHEN DATEDIFF(day, GETDATE(), DK.NgayKetThuc) < 0 THEN 0 
        ELSE DATEDIFF(day, GETDATE(), DK.NgayKetThuc) 
    END AS [Số Ngày Còn Lại],

    CASE 
        WHEN DATEDIFF(day, GETDATE(), DK.NgayKetThuc) < 0 THEN N'❌ Hết hạn'
        WHEN DATEDIFF(day, GETDATE(), DK.NgayKetThuc) <= 7 THEN N'⚠️ Sắp hết hạn'
        ELSE N'✅ Còn hạn'
    END AS [Trạng Thái],

    FORMAT(DK.NgaySua, 'dd/MM/yyyy    HH:mm') AS [Cập Nhật]
FROM DANGKY DK
JOIN KHACHHANG KH ON DK.MaKH = KH.MaKH
JOIN GOITAP GT ON DK.MaGoi = GT.MaGoi
LEFT JOIN HLV ON DK.MaHLV = HLV.MaHLV;
GO




--========================================--
--========== 6. XÓA VÀ XEM DỮ LIỆU =======--
--========================================--
-- Xóa lượt đăng ký số 3
UPDATE DANGKY
SET 
    DaXoa = 1, 
    NgaySua = GETDATE()
WHERE MaDK = 3; 
GO

-- Thùng rác
SELECT 
    'DK' + FORMAT(DK.MaDK, '00') AS [ID],
    KH.TenKH AS [Khách Hàng],
    GT.TenGoi AS [Gói Tập],
    N'🗑️ Đã xóa' AS [Trạng Thái],
    FORMAT(DK.NgaySua, 'dd/MM/yyyy    HH:mm') AS [Ngày Xóa]
FROM DANGKY DK
JOIN KHACHHANG KH ON DK.MaKH = KH.MaKH
JOIN GOITAP GT ON DK.MaGoi = GT.MaGoi
WHERE DK.DaXoa = 1 
ORDER BY DK.NgaySua DESC;
GO




--========================================--
--========== 7. TÌM KIẾM DỮ LIỆU =========--
--========================================--
DECLARE @fTenKH NVARCHAR(100) = N'An';     
DECLARE @fMaDK  INT           = NULL;       
DECLARE @fTuNgay DATE         = '2026-04-05'; 
DECLARE @fDenNgay DATE        = '2026-04-30'; 
DECLARE @fSapHetHan INT       = NULL;       

SELECT 
    'DK' + FORMAT(DK.MaDK, '00') AS [Mã Đăng Ký],
    KH.TenKH AS [Khách Hàng],
    GT.TenGoi AS [Gói Tập],
    ISNULL(HLV.TenHLV, N'--- Tự tập ---') AS [HLV Phụ Trách],
    FORMAT(DK.NgayBatDau, 'dd/MM/yyyy') AS [Bắt Đầu],
    FORMAT(DK.NgayKetThuc, 'dd/MM/yyyy') AS [Kết Thúc],
    
    CASE 
        WHEN DATEDIFF(day, GETDATE(), DK.NgayKetThuc) < 0 THEN 0 
        ELSE DATEDIFF(day, GETDATE(), DK.NgayKetThuc) 
    END AS [Số Ngày Còn Lại],

    CASE 
        WHEN DATEDIFF(day, GETDATE(), DK.NgayKetThuc) < 0 THEN N'❌ Hết hạn'
        WHEN DATEDIFF(day, GETDATE(), DK.NgayKetThuc) <= 7 THEN N'⚠️ Sắp hết hạn'
        ELSE N'✅ Còn hạn'
    END AS [Trạng Thái]
FROM DANGKY DK
JOIN KHACHHANG KH ON DK.MaKH = KH.MaKH
JOIN GOITAP GT ON DK.MaGoi = GT.MaGoi
LEFT JOIN HLV ON DK.MaHLV = HLV.MaHLV
WHERE 
    DK.DaXoa = 0 
    AND (@fTenKH IS NULL OR KH.TenKH LIKE N'%' + @fTenKH + N'%')
    AND (@fMaDK IS NULL OR DK.MaDK = @fMaDK)
    AND (@fTuNgay IS NULL OR DK.NgayBatDau >= @fTuNgay)
    AND (@fDenNgay IS NULL OR DK.NgayBatDau <= @fDenNgay)
    AND (@fSapHetHan IS NULL OR (DATEDIFF(day, GETDATE(), DK.NgayKetThuc) BETWEEN 0 AND @fSapHetHan))
ORDER BY [Số Ngày Còn Lại] ASC;
GO


-- Tìm khách hàng đã đăng ký tập trên 2 lần
SELECT KH.TenKH, COUNT(DK.MaDK) AS [Số Lần Đăng Ký]
FROM DANGKY DK
JOIN KHACHHANG KH ON DK.MaKH = KH.MaKH
WHERE DK.DaXoa = 0
GROUP BY KH.TenKH
HAVING COUNT(DK.MaDK) >= 2
ORDER BY KH.TenKH ASC;
GO