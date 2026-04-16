USE [QLPhongGym];
GO

--========================================--
-- 1. XÓA BẢNG AN TOÀN                    --
--========================================--
-- Hiện tại bảng THIETBI là bảng nhánh con cuối cùng, không có bảng nào tham chiếu đến nó
IF OBJECT_ID('THIETBI', 'U') IS NOT NULL DROP TABLE THIETBI;
GO




--========================================--
--========== 2. TẠO BẢNG THIẾT BỊ ========--
--========================================--
CREATE TABLE THIETBI (
    MaTB INT IDENTITY(1,1) PRIMARY KEY,     
    TenTB NVARCHAR(100) NOT NULL,      
    LoaiTB NVARCHAR(50),     

    MaKV INT NOT NULL,  -- Sửa thành Mã Khu Vực để liên kết với bảng KHUVUC             
    NgayMua DATE DEFAULT GETDATE(),   
    GiaTri DECIMAL(18,2) CHECK (GiaTri >= 0),              
    TinhTrang NVARCHAR(50) DEFAULT N'Sẵn sàng', 

    NgaySua DATETIME DEFAULT GETDATE(),
    DaXoa BIT DEFAULT 0,  
    
    -- Ràng buộc khóa ngoại
    CONSTRAINT FK_THIETBI_KHUVUC FOREIGN KEY (MaKV) REFERENCES KHUVUC(MaKV)
);
GO




--========================================--
--========== 3. THÊM DỮ LIỆU MẪU =========--
--========================================--
IF OBJECT_ID('THIETBI', 'U') IS NOT NULL DELETE FROM THIETBI;

-- Reset ID tự tăng về 0 (Sửa lỗi sai tên bảng của bản cũ)
IF OBJECT_ID('THIETBI', 'U') IS NOT NULL DBCC CHECKIDENT ('THIETBI', RESEED, 1);
GO

-- Thêm dữ liệu (Đã map KhuVuc text cũ sang MaKV tương ứng từ bảng KHUVUC)
INSERT INTO THIETBI (TenTB, LoaiTB, MaKV, GiaTri, TinhTrang, NgayMua)
VALUES 
(N'Máy tập đùi ngoài (Outer Thigh)', N'Strength', 2, 24000000, N'Sẵn sàng', '2026-01-15'),
(N'Máy tập đùi trong (Inner Thigh)', N'Strength', 2, 24000000, N'Sẵn sàng', '2025-01-15'),
(N'Giàn tạ kéo cáp đôi (Dual Adjustable Pulley)', N'Strength', 2, 55000000, N'Sẵn sàng', '2025-12-20'),
(N'Máy chạy bộ Matrix T70 (01)', N'Cardio', 1, 45000000, N'Sẵn sàng', '2026-02-10'),
(N'Máy chạy bộ Matrix T70 (02)', N'Cardio', 1, 45000000, N'Sẵn sàng', '2026-02-10'),
(N'Xe đạp tập chuyên sâu (Spin Bike)', N'Cardio', 1, 18000000, N'Sẵn sàng', '2024-03-05'),
(N'Ghế đẩy ngực ngang (Bench Press)', N'Free Weight', 2, 12000000, N'Sẵn sàng', '2025-11-10'),
(N'Ghế đẩy ngực trên (Incline Bench)', N'Free Weight', 2, 12500000, N'Sẵn sàng', '2025-11-10'),
(N'Bàn tập tay trước (Preacher Curl)', N'Free Weight', 2, 8000000, N'Sẵn sàng', '2026-01-05'),
(N'Máy ép ngực & vai đa năng', N'Strength', 3, 35000000, N'Bảo trì', '2025-10-15'),
(N'Giường tập Pilates Reformer', N'Pilates', 5, 65000000, N'Sẵn sàng', '2024-03-20'),
(N'Tháp tập Pilates (Cadillac)', N'Pilates', 5, 85000000, N'Sẵn sàng', '2023-03-20'),
(N'Thảm tập Yoga lululemon (Cái 01)', N'Yoga', 4, 1200000, N'Sẵn sàng', '2025-04-01'),
(N'Thảm tập Yoga lululemon (Cái 02)', N'Yoga', 4, 1200000, N'Sẵn sàng', '2026-04-01'),
(N'Găng tay Boxing chuyên nghiệp (Cặp)', N'Boxing', 6, 1500000, N'Sẵn sàng', '2025-02-15'),
(N'Đích đấm cầm tay (Focus Mitts)', N'Boxing', 6, 900000, N'Sẵn sàng', '2025-02-15'),
(N'Máy leo thang (StairMaster)', N'Cardio', 1, 75000000, N'Sẵn sàng', '2024-01-20'),
(N'Bóng tập Gym (Swiss Ball) cỡ trung', N'Phụ kiện', 7, 400000, N'Sẵn sàng', '2023-03-10'),
(N'Máy rung massage (Cái 01)', N'Massage', 8, 12000000, N'Sẵn sàng', '2024-01-10'),
(N'Máy phân tích chỉ số cơ thể InBody', N'Y tế', 9, 120000000, N'Sẵn sàng', '2026-04-05');
GO




--========================================--
--========== 4. XEM DỮ LIỆU ==============--
--========================================--
SELECT 
    'TB' + FORMAT(TB.MaTB, '00') AS [ID],
    TB.TenTB AS [Tên Thiết Bị],
    TB.LoaiTB AS [Phân Loại],
    KV.TenKV AS [Vị Trí Đặt Máy], -- Lấy tên khu vực từ bảng KHUVUC
    FORMAT(TB.NgayMua, 'dd/MM/yyyy') AS [Ngày Mua],
    FORMAT(TB.GiaTri, '#,###') + ' VND' AS [Giá Trị],
    
    CASE 
        WHEN TB.TinhTrang = N'Sẵn sàng' THEN N'✅ ' + TB.TinhTrang
        WHEN TB.TinhTrang = N'Đang hỏng' THEN N'❌ ' + TB.TinhTrang
        WHEN TB.TinhTrang = N'Bảo trì' THEN N'🛠️ ' + TB.TinhTrang
        ELSE TB.TinhTrang
    END AS [Trạng Thái],

    FORMAT(TB.NgaySua, 'dd/MM/yyyy HH:mm') AS [Lần Cập Nhật]
FROM THIETBI TB
JOIN KHUVUC KV ON TB.MaKV = KV.MaKV -- Kết nối bảng
WHERE TB.DaXoa = 0;
GO




--========================================--
--========== 5. CẬP NHẬT DỮ LIỆU =========--
--========================================--
-- Sửa tổng quát
UPDATE THIETBI
SET 
    TenTB = N'Máy chạy bộ Matrix T70 - Ver 2',
    LoaiTB = N'Cardio Cấp Cao',
    MaKV = 1, -- Giữ nguyên ở Khu Cardio
    GiaTri = 48000000,
    TinhTrang = N'Sẵn sàng',
    NgaySua = GETDATE()
WHERE MaTB = 1;
GO

-- Cập nhật trạng thái một số máy
UPDATE THIETBI SET TinhTrang = N'Sẵn sàng', NgaySua = GETDATE() WHERE MaTB = 10;
UPDATE THIETBI SET TinhTrang = N'Đang hỏng', NgaySua = GETDATE() WHERE MaTB = 5;
UPDATE THIETBI SET TinhTrang = N'Bảo trì', NgaySua = GETDATE() WHERE MaTB = 8;
GO




--========================================--
--===== 6. XEM THÙNG RÁC (MÁY HỎNG/BẢO TRÌ) --
--========================================--
SELECT 
    'TB' + FORMAT(TB.MaTB, '00') AS [ID],
    TB.TenTB AS [Thiết Bị Cần Xử Lý],
    TB.LoaiTB AS [Phân Loại],
    KV.TenKV AS [Vị Trí],
    
    CASE 
        WHEN TB.TinhTrang = N'Đang hỏng' THEN N'❌ ' + TB.TinhTrang
        WHEN TB.TinhTrang = N'Bảo trì' THEN N'🛠️ ' + TB.TinhTrang
        ELSE TB.TinhTrang
    END AS [Tình Trạng],

    DATEDIFF(DAY, TB.NgaySua, GETDATE()) AS [Số Ngày Chờ Sửa],
    FORMAT(TB.NgaySua, 'dd/MM/yyyy HH:mm') AS [Thời Điểm Báo Lỗi],
    N'⚠️ Đang tạm dừng' AS [Trạng Thái Hệ Thống]
FROM THIETBI TB
JOIN KHUVUC KV ON TB.MaKV = KV.MaKV
WHERE 
    TB.DaXoa = 0 
    AND (TB.TinhTrang = N'Đang hỏng' OR TB.TinhTrang = N'Bảo trì')
ORDER BY [Số Ngày Chờ Sửa] DESC; 
GO




--========================================--
--======== 7. THỐNG KÊ TÌNH TRẠNG ========--
--========================================--
SELECT 
    COUNT(MaTB) AS [Tổng Số Thiết Bị],
    SUM(CASE WHEN TinhTrang = N'Sẵn sàng' THEN 1 ELSE 0 END) AS [Đang Hoạt Động],
    SUM(CASE WHEN TinhTrang = N'Bảo trì' THEN 1 ELSE 0 END) AS [Đang Bảo Trì],
    SUM(CASE WHEN TinhTrang = N'Đang hỏng' THEN 1 ELSE 0 END) AS [Đang Hỏng],
    FORMAT(CAST(SUM(CASE WHEN TinhTrang = N'Sẵn sàng' THEN 1 ELSE 0 END) AS FLOAT) / COUNT(MaTB), 'P') AS [Tỷ Lệ Sẵn Sàng]
FROM THIETBI
WHERE DaXoa = 0; 
GO




--========================================--
--======= 8. THỐNG KÊ CHI TIẾT THEO KHU VỰC --
--========================================--
SELECT 
    KV.TenKV AS [Khu Vực],
    COUNT(TB.MaTB) AS [Số Lượng Máy],
    SUM(CASE WHEN TB.TinhTrang = N'Sẵn sàng' THEN 1 ELSE 0 END) AS [Sẵn Sàng],
    SUM(CASE WHEN TB.TinhTrang <> N'Sẵn sàng' THEN 1 ELSE 0 END) AS [Cần Sửa Chữa/Bảo Trì],
    FORMAT(SUM(TB.GiaTri), '#,###') + ' VND' AS [Tổng Giá Trị]
FROM THIETBI TB
JOIN KHUVUC KV ON TB.MaKV = KV.MaKV
WHERE TB.DaXoa = 0
GROUP BY KV.TenKV
ORDER BY COUNT(TB.MaTB) DESC;
GO