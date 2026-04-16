USE [QLPhongGym];
GO

--========================================--
-- 1. XÓA BẢNG AN TOÀN (TỪ CON LÊN CHA)   --
--========================================--
-- Xóa bảng chi tiết hóa đơn (Bảng con sắp tạo ở giai đoạn giao dịch)
IF OBJECT_ID('CHITIET_HOADON', 'U') IS NOT NULL DROP TABLE CHITIET_HOADON;
IF OBJECT_ID('HOADON', 'U') IS NOT NULL DROP TABLE HOADON;

-- Xóa bảng chính
IF OBJECT_ID('SANPHAM', 'U') IS NOT NULL DROP TABLE SANPHAM;
GO


--========================================--
--========== 2. TẠO BẢNG SẢN PHẨM ========--
--========================================--
CREATE TABLE SANPHAM (
    MaSP INT IDENTITY(1,1) PRIMARY KEY,
    TenSP NVARCHAR(100) NOT NULL,
    LoaiSP NVARCHAR(50),      
    GiaNhap MONEY DEFAULT 0,  -- Thêm Giá nhập để tính vốn tồn kho
    GiaBan MONEY DEFAULT 0,
    SoLuongTon INT DEFAULT 0,

    NgaySua DATETIME DEFAULT GETDATE(), 
    DaXoa BIT DEFAULT 0,
    
    -- Ràng buộc kiểm tra dữ liệu
    CONSTRAINT CK_GiaNhap CHECK (GiaNhap >= 0),
    CONSTRAINT CK_GiaBan CHECK (GiaBan >= GiaNhap), -- Bán phải lời hoặc hòa vốn
    CONSTRAINT CK_SoLuong CHECK (SoLuongTon >= 0)
);
GO


--========================================--
--========== 3. THÊM VÀ XEM DỮ LIỆU ======--
--========================================--
IF OBJECT_ID('CHITIET_HOADON', 'U') IS NOT NULL DELETE FROM CHITIET_HOADON;
IF OBJECT_ID('HOADON', 'U') IS NOT NULL DELETE FROM HOADON;
IF OBJECT_ID('SANPHAM', 'U') IS NOT NULL DELETE FROM SANPHAM;

-- Reset ID tự tăng về 0
IF OBJECT_ID('SANPHAM', 'U') IS NOT NULL DBCC CHECKIDENT ('SANPHAM', RESEED, 1);
GO

-- Thêm giá nhập giả định vào dữ liệu mẫu
INSERT INTO SANPHAM (TenSP, LoaiSP, GiaNhap, GiaBan, SoLuongTon)
VALUES 
(N'Nước khoáng Lavie 500ml', N'Nước uống', 5000, 10000, 0),
(N'Nước điện giải Revive', N'Nước uống', 8000, 15000, 50),
(N'Sữa Whey Protein Gold Standard', N'Thực phẩm chức năng', 1200000, 1550000, 10),
(N'Bình lắc Shaker 700ml', N'Phụ kiện', 60000, 120000, 20),
(N'Găng tập gym nam', N'Phụ kiện', 100000, 180000, 15),
(N'Mass Tech Extreme 2000', N'Thực phẩm chức năng', 1400000, 1850000, 5),
(N'Pre-Workout Outlift', N'Thực phẩm chức năng', 700000, 950000, 8),
(N'Dây kháng lực (Set 5 dây)', N'Phụ kiện', 150000, 250000, 12),
(N'Áo thun tập gym co giãn', N'Phụ kiện', 120000, 220000, 30),
(N'Bánh Protein Bar', N'Nước uống', 25000, 45000, 40),
(N'Thắt lưng tập Gym (Lever Belt)', N'Phụ kiện', 500000, 850000, 10),
(N'Dây kéo lưng Lifting Straps', N'Phụ kiện', 80000, 150000, 25),
(N'Nước tăng lực Monster Energy', N'Nước uống', 20000, 35000, 60),
(N'Vitamin tổng hợp Daily One', N'Thực phẩm chức năng', 300000, 450000, 15),
(N'Băng quấn cổ tay (Wrist Wraps)', N'Phụ kiện', 100000, 190000, 20),
(N'Creatine Monohydrate (300g)', N'Thực phẩm chức năng', 400000, 550000, 12),
(N'Quần short tập gym 2 lớp', N'Phụ kiện', 150000, 280000, 25),
(N'Túi tập gym đa năng 20L', N'Phụ kiện', 250000, 450000, 8),
(N'BCAAs Amino Energy', N'Thực phẩm chức năng', 450000, 650000, 10),
(N'Ốp bảo vệ đầu gối (Knee Sleeves)', N'Phụ kiện', 200000, 350000, 15),
(N'Giày nâng tạ chuyên dụng', N'Phụ kiện', 1800000, 2450000, 5),
(N'Giày chạy bộ siêu nhẹ', N'Phụ kiện', 1300000, 1850000, 10),
(N'Giày tập đa năng Cross-Training', N'Phụ kiện', 900000, 1250000, 15),
(N'Giày tập Boxing cổ cao', N'Phụ kiện', 1100000, 1550000, 8),
(N'Dép quai ngang sau tập', N'Phụ kiện', 250000, 450000, 20),
(N'Tất cổ ngắn chống trượt', N'Phụ kiện', 50000, 120000, 50),
(N'Tất dài nén cơ bắp chân', N'Phụ kiện', 150000, 280000, 30),
(N'Tất cổ cao thể thao Retro', N'Phụ kiện', 40000, 85000, 100),
(N'Tất chuyên dụng cho cử tạ', N'Phụ kiện', 120000, 220000, 25),
(N'Tất xỏ ngón tập Yoga/Pilates', N'Phụ kiện', 45000, 95000, 40);
GO

-- Xem dữ liệu
SELECT 
    'SP' + FORMAT(MaSP, '00') AS [Mã SP],
    TenSP AS [Tên Sản Phẩm],
    LoaiSP AS [Loại],
    FORMAT(GiaNhap, '#,###') + ' VND' AS [Giá Nhập],
    FORMAT(GiaBan, '#,###') + ' VND' AS [Giá Bán],
    
    CASE 
        WHEN SoLuongTon = 0 THEN N'0 (Hết hàng)'
        ELSE CAST(SoLuongTon AS NVARCHAR) 
    END AS [Số Lượng Tồn],

    CASE 
        WHEN DaXoa = 1 THEN N'❌ NGỪNG BÁN'
        WHEN SoLuongTon = 0 THEN N'⚠️ HẾT HÀNG'
        ELSE N'✅ ĐANG KINH DOANH'
    END AS [Trạng Thái],

    FORMAT(NgaySua, 'dd/MM/yyyy   HH:mm') AS [Lần Cập Nhật Cuối]
FROM SANPHAM;
GO


--========================================--
--========== 4. CẬP NHẬT SẢN PHẨM ========--
--========================================--
-- Giảm giá 10% cho tất cả các loại 'Nước uống'
UPDATE SANPHAM
SET 
    GiaBan = GiaBan * 0.9,
    NgaySua = GETDATE()
WHERE LoaiSP = N'Nước uống' AND GiaBan > GiaNhap; -- Đảm bảo không giảm dưới giá vốn
GO

-- Cập nhật số lượng
UPDATE SANPHAM
SET 
    SoLuongTon = SoLuongTon + 20,
    NgaySua = GETDATE()
WHERE TenSP LIKE N'%Găng tập gym%';
GO

-- Cảnh báo sắp hết hàng
UPDATE SANPHAM
SET 
    TenSP = TenSP + N' (Sắp hết hàng)',
    NgaySua = GETDATE()
WHERE SoLuongTon < 5 
  AND TenSP NOT LIKE N'%(Sắp hết hàng)%';
GO


--========================================--
--========== 5. XÓA VÀ XEM DỮ LIỆU =======--
--========================================--
UPDATE SANPHAM SET DaXoa = 1, NgaySua = GETDATE() WHERE LoaiSP = N'Phụ kiện' AND SoLuongTon = 0;
UPDATE SANPHAM SET DaXoa = 1, NgaySua = GETDATE() WHERE TenSP LIKE N'%Monster Energy%';
GO

-- Thùng rác
SELECT 
    'SP' + FORMAT(MaSP, '00') AS [Mã SP],
    TenSP AS [Tên Sản Phẩm],
    LoaiSP AS [Loại],
    FORMAT(GiaBan, '#,###') + ' VND' AS [Giá Cuối],
    SoLuongTon AS [Tồn Kho],
    FORMAT(NgaySua, 'dd/MM/yyyy HH:mm') AS [Ngày Xóa],
    N'🗑️ Đã vào thùng rác' AS [Trạng Thái]
FROM SANPHAM
WHERE DaXoa = 1; 
GO

-- Khôi phục
UPDATE SANPHAM SET DaXoa = 0, NgaySua = GETDATE() WHERE MaSP = 1; 
GO


--========================================--
--========== 6. TÌM KIẾM DỮ LIỆU =========--
--========================================--
DECLARE @SearchKey NVARCHAR(100) = N'Phụ kiện'; 

SELECT 
    'SP' + FORMAT(MaSP, '00') AS [Mã SP],
    TenSP AS [Tên Sản Phẩm],
    LoaiSP AS [Phân Loại],
    FORMAT(GiaBan, '#,###') + ' VND' AS [Giá Bán],
    
    CASE 
        WHEN SoLuongTon = 0 THEN N'❌ HẾT HÀNG'
        WHEN SoLuongTon <= 5 THEN N'⚠️ Sắp hết (' + CAST(SoLuongTon AS NVARCHAR) + ')'
        ELSE CAST(SoLuongTon AS NVARCHAR) + N' cái'
    END AS [Tồn Kho],

    CASE 
        WHEN DaXoa = 1 THEN N'🗑️ Trong thùng rác'
        WHEN SoLuongTon = 0 THEN N'⚠️ Tạm hết hàng'
        ELSE N'✅ Đang bán'
    END AS [Trạng Thái]
FROM SANPHAM
WHERE (TenSP LIKE N'%' + @SearchKey + N'%' OR LoaiSP LIKE N'%' + @SearchKey + N'%');
GO


--========================================--
--========== 7. THỐNG KÊ =================--
--========================================--
-- 1. Thống kê theo nhóm sản phẩm (Dùng Giá Nhập để tính Giá trị vốn)
SELECT 
    LoaiSP AS [Nhóm Sản Phẩm],
    COUNT(MaSP) AS [Số Lượng SP],
    SUM(SoLuongTon) AS [Tổng Tồn Kho],
    FORMAT(MIN(GiaBan), '#,###') + ' VND' AS [Giá Rẻ Nhất],
    FORMAT(MAX(GiaBan), '#,###') + ' VND' AS [Giá Cao Nhất],
    FORMAT(AVG(CAST(GiaBan AS DECIMAL(18,2))), '#,###') + ' VND' AS [Giá Trung Bình],
    
    -- Đã sửa thành GiaNhap thay vì GiaBan
    FORMAT(SUM(GiaNhap * SoLuongTon), '#,###') + ' VND' AS [Tổng Giá Trị Vốn Tồn]
FROM SANPHAM
WHERE DaXoa = 0 
GROUP BY LoaiSP
ORDER BY SUM(GiaNhap * SoLuongTon) DESC; 
GO

-- 2. Thống kê theo tình trạng
SELECT 
    CASE 
        WHEN DaXoa = 1 THEN N'❌ NGỪNG KINH DOANH'
        WHEN SoLuongTon = 0 THEN N'⚠️ HẾT HÀNG (CẦN NHẬP)'
        WHEN SoLuongTon <= 5 THEN N'⚡ SẮP HẾT (DƯỚI 5 CÁI)'
        ELSE N'✅ CÒN HÀNG (ỔN ĐỊNH)'
    END AS [Tình Trạng],
    COUNT(MaSP) AS [Số Lượng Mặt Hàng],
    SUM(SoLuongTon) AS [Tổng Số Lượng Tồn]
FROM SANPHAM
GROUP BY 
    CASE 
        WHEN DaXoa = 1 THEN N'❌ NGỪNG KINH DOANH'
        WHEN SoLuongTon = 0 THEN N'⚠️ HẾT HÀNG (CẦN NHẬP)'
        WHEN SoLuongTon <= 5 THEN N'⚡ SẮP HẾT (DƯỚI 5 CÁI)'
        ELSE N'✅ CÒN HÀNG (ỔN ĐỊNH)'
    END;
GO