USE [QLPhongGym];
GO

--========================================--
-- 1. XÓA BẢNG AN TOÀN                    --
--========================================--
IF OBJECT_ID('DIEMDANH', 'U') IS NOT NULL DROP TABLE DIEMDANH;
GO




--========================================--
--========== 2. TẠO BẢNG ĐIỂM DANH =======--
--========================================--
CREATE TABLE DIEMDANH (
    MaDD INT IDENTITY(1,1) PRIMARY KEY,
   
    MaNV INT NULL, 
    MaKH INT NULL, 
    MaHLV INT NULL, 
    
    ThoiGianVao DATETIME DEFAULT GETDATE(),
    ThoiGianRa DATETIME NULL,
    GhiChu NVARCHAR(255) NULL,
    
    -- Các cột đồng bộ hệ thống
    NgaySua DATETIME DEFAULT GETDATE(),
    DaXoa BIT DEFAULT 0,

    -- Ràng buộc khóa ngoại
    CONSTRAINT FK_DIEMDANH_NHANVIEN FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV),
    CONSTRAINT FK_DIEMDANH_KHACHHANG FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
    CONSTRAINT FK_DIEMDANH_HLV FOREIGN KEY (MaHLV) REFERENCES HLV(MaHLV),
    
    -- Ràng buộc 1: Bắt buộc CHỈ MỘT đối tượng được phép quét thẻ tại 1 thời điểm
    CONSTRAINT CK_DoiTuong_Check CHECK (
        (CASE WHEN MaNV IS NOT NULL THEN 1 ELSE 0 END + 
         CASE WHEN MaKH IS NOT NULL THEN 1 ELSE 0 END + 
         CASE WHEN MaHLV IS NOT NULL THEN 1 ELSE 0 END) = 1
    ),

    -- Ràng buộc 2: Giờ ra phải hợp lý (Sau giờ vào)
    CONSTRAINT CK_ThoiGian_HopLe CHECK (ThoiGianRa IS NULL OR ThoiGianRa >= ThoiGianVao)
);
GO




--========================================--
--========== 3. THÊM DỮ LIỆU MẪU =========--
--========================================--
DELETE FROM DIEMDANH;
DBCC CHECKIDENT ('DIEMDANH', RESEED, 1); -- Sửa thành 0 để bắt đầu từ 1
GO

INSERT INTO DIEMDANH (MaKH, MaHLV, MaNV, ThoiGianVao, ThoiGianRa, GhiChu)
VALUES 
    -- Sáng sớm: Nhân viên mở cửa và Khách tập sớm
    (NULL, NULL, 1, '2026-04-14 05:30:00', '2026-04-14 13:30:00', N'NV Lễ tân ca sáng'),
    (1, NULL, NULL, '2026-04-14 05:45:00', '2026-04-14 07:15:00', N'Khách tập Cardio'),
    (2, NULL, NULL, '2026-04-14 06:00:00', '2026-04-14 07:30:00', N'Khách tập tự do'),
    (NULL, 1, NULL, '2026-04-14 06:15:00', '2026-04-14 08:15:00', N'HLV dạy lớp Yoga'),
    (3, NULL, NULL, '2026-04-14 06:30:00', '2026-04-14 08:00:00', N'Khách tập PT'),

    -- Giờ hành chính: Quản lý và các dịch vụ bảo trì
    (NULL, NULL, 2, '2026-04-14 08:00:00', '2026-04-14 17:00:00', N'Quản lý trực ngày'),
    (NULL, NULL, 6, '2026-04-14 08:30:00', '2026-04-14 11:30:00', N'NV Kỹ thuật kiểm tra máy'),
    (10, NULL, NULL, '2026-04-14 09:00:00', '2026-04-14 10:30:00', N'Khách tập Pilates'),
    (NULL, 4, NULL, '2026-04-14 09:15:00', '2026-04-14 11:15:00', N'HLV dạy Pilates'),
    (15, NULL, NULL, '2026-04-14 10:00:00', '2026-04-14 11:30:00', N'Khách tập tự do'),

    -- Ca chiều: Nhân viên ca chiều và HLV các lớp nhảy
    (NULL, NULL, 5, '2026-04-14 13:30:00', '2026-04-14 21:30:00', N'NV Lễ tân ca chiều'),
    (20, NULL, NULL, '2026-04-14 15:00:00', '2026-04-14 16:30:00', N'Khách sinh viên'),
    (NULL, 2, NULL, '2026-04-14 16:00:00', '2026-04-14 18:00:00', N'HLV dạy Zumba'),
    (5, NULL, NULL, '2026-04-14 16:30:00', '2026-04-14 18:00:00', N'Khách tập lớp Zumba'),
    (25, NULL, NULL, '2026-04-14 17:00:00', '2026-04-14 18:30:00', N'Khách tập Gym'),

    -- Giờ cao điểm tối: Rất nhiều khách và HLV Boxing/Crossfit
    (NULL, 14, NULL, '2026-04-14 17:30:00', '2026-04-14 19:30:00', N'HLV dạy Boxing'),
    (12, NULL, NULL, '2026-04-14 18:00:00', '2026-04-14 19:30:00', N'Khách tập Boxing'),
    (13, NULL, NULL, '2026-04-14 18:15:00', '2026-04-14 19:45:00', N'Khách tập tự do'),
    (NULL, 5, NULL, '2026-04-14 18:30:00', '2026-04-14 20:30:00', N'HLV dạy Crossfit'),
    (18, NULL, NULL, '2026-04-14 18:45:00', '2026-04-14 20:15:00', N'Khách tập Crossfit'),
    (30, NULL, NULL, '2026-04-14 19:00:00', '2026-04-14 20:30:00', N'Khách tập Gym tối'),
    (NULL, NULL, 3, '2026-04-14 19:00:00', '2026-04-14 23:00:00', N'Bảo vệ ca đêm'),
    (7, NULL, NULL, '2026-04-14 19:30:00', '2026-04-14 21:00:00', N'Khách tập Cardio'),
    (NULL, 10, NULL, '2026-04-14 20:00:00', '2026-04-14 22:00:00', N'HLV dạy Pilates tối'),

    -- Ngày hôm sau: Những người đang ở phòng tập (ThoiGianRa là NULL)
    (NULL, NULL, 1, '2026-04-15 05:30:00', NULL, N'NV Lễ tân bắt đầu ca'),
    (8, NULL, NULL, '2026-04-15 06:00:00', NULL, N'Khách tập sớm chưa về'),
    (NULL, 3, NULL, '2026-04-15 06:15:00', NULL, N'HLV đang dạy lớp Gym'),
    (22, NULL, NULL, '2026-04-15 06:30:00', NULL, N'Khách tập Yoga sáng'),
    (NULL, NULL, 10, '2026-04-15 07:00:00', NULL, N'NV Kỹ thuật kiểm tra định kỳ'),
    (11, NULL, NULL, '2026-04-15 07:15:00', NULL, N'Khách mới vào check-in');
GO




--========================================--
--========== 4. TRUY VẤN ĐIỂM DANH =======--
--========================================--
SELECT 
    'DD' + FORMAT(DD.MaDD, '00') AS [ID],
    COALESCE(KH.TenKH, H.TenHLV, NV.TenNV) AS [Tên],
    CASE 
        WHEN DD.MaKH IS NOT NULL THEN N'Khách hàng'
        WHEN DD.MaHLV IS NOT NULL THEN N'Huấn luyện viên'
        WHEN DD.MaNV IS NOT NULL THEN N'Nhân viên'
    END AS [Đối Tượng],
    FORMAT(DD.ThoiGianVao, 'dd/MM/yyyy HH:mm') AS [Thời Gian Vào],
    ISNULL(FORMAT(DD.ThoiGianRa, 'dd/MM/yyyy HH:mm'), N'--- Đang ở phòng tập ---') AS [Thời Gian Ra],
    DD.GhiChu AS [Ghi Chú]
FROM DIEMDANH DD
LEFT JOIN KHACHHANG KH ON DD.MaKH = KH.MaKH
LEFT JOIN HLV H ON DD.MaHLV = H.MaHLV
LEFT JOIN NHANVIEN NV ON DD.MaNV = NV.MaNV
WHERE DD.DaXoa = 0 
--ORDER BY DD.ThoiGianVao DESC; 
GO




--========================================--
--========== 5. CẬP NHẬT VÀ XEM DỮ LIỆU ==--
--========================================--
-- Tình huống 1: Check-out cho Khách hàng tập Yoga (Mã DD = 28)
UPDATE DIEMDANH
SET 
    ThoiGianRa = '2026-04-15 08:30:00',
    GhiChu = N'Khách tập xong - Check-out muộn'
WHERE MaDD = 28 AND ThoiGianRa IS NULL;
GO


-- Tình huống 2: Cập nhật đồng loạt ghi chú cho nhân viên ca sáng 14/04
UPDATE DIEMDANH
SET 
    GhiChu = GhiChu + N' - (Đã xác nhận hoàn thành ca)',
    NgaySua = GETDATE()
WHERE MaNV IS NOT NULL 
  AND CAST(ThoiGianVao AS DATE) = '2026-04-14'
  AND CAST(ThoiGianVao AS TIME) < '12:00:00';
GO


-- Tình huống 3: Điều chỉnh giờ vào cho HLV số 3 (Đã sửa mã khớp với dữ liệu thực tế)
UPDATE DIEMDANH
SET 
    ThoiGianVao = DATEADD(MINUTE, -15, ThoiGianVao), 
    GhiChu = N'Bổ sung: Check-in sớm 15p'
WHERE MaHLV = 3 AND CAST(ThoiGianVao AS DATE) = '2026-04-15';
GO


-- Xem lại dữ liệu sau update
SELECT 
    'DD' + FORMAT(DD.MaDD, '00') AS [Mã DD],
    COALESCE(KH.TenKH, H.TenHLV, NV.TenNV) AS [Tên Đối Tượng],
    FORMAT(DD.ThoiGianVao, 'HH:mm') AS [Giờ Vào],
    FORMAT(DD.ThoiGianRa, 'HH:mm') AS [Giờ Ra],
    DD.GhiChu AS [Ghi Chú Mới],
    FORMAT(DD.NgaySua, 'dd/MM/yyyy HH:mm') AS [Lần Sửa Cuối]
FROM DIEMDANH DD
LEFT JOIN KHACHHANG KH ON DD.MaKH = KH.MaKH
LEFT JOIN HLV H ON DD.MaHLV = H.MaHLV
LEFT JOIN NHANVIEN NV ON DD.MaNV = NV.MaNV
WHERE DD.MaDD IN (27, 28) OR DD.GhiChu LIKE N'%Đã xác nhận%'; -- Sửa Mã DD để map với dữ liệu HLV 3
GO




--========================================--
--========== 6. TÌM KIẾM DỮ LIỆU =========--
--========================================--
-- 1. Tìm kiếm tổng hợp theo Tên hoặc Ghi chú
DECLARE @fKeySearch NVARCHAR(100) = N'Hồng'; 

SELECT 
    'DD' + FORMAT(DD.MaDD, '00') AS [ID],
    COALESCE(KH.TenKH, H.TenHLV, NV.TenNV) AS [Tên],
    CASE 
        WHEN DD.MaKH IS NOT NULL THEN N'Khách hàng'
        WHEN DD.MaHLV IS NOT NULL THEN N'Huấn luyện viên'
        WHEN DD.MaNV IS NOT NULL THEN N'Nhân viên'
    END AS [Nhóm],
    FORMAT(DD.ThoiGianVao, 'dd/MM HH:mm') AS [Vào],
    ISNULL(FORMAT(DD.ThoiGianRa, 'HH:mm'), N'--- Đang ở Gym ---') AS [Ra],
    DD.GhiChu AS [Ghi Chú]
FROM DIEMDANH DD
LEFT JOIN KHACHHANG KH ON DD.MaKH = KH.MaKH
LEFT JOIN HLV H ON DD.MaHLV = H.MaHLV
LEFT JOIN NHANVIEN NV ON DD.MaNV = NV.MaNV
WHERE (
    KH.TenKH LIKE N'%' + @fKeySearch + '%'
    OR H.TenHLV LIKE N'%' + @fKeySearch + '%'
    OR NV.TenNV LIKE N'%' + @fKeySearch + '%'
    OR DD.GhiChu LIKE N'%' + @fKeySearch + '%'
) 
AND DD.DaXoa = 0;
GO


-- 2. Lọc danh sách những người "Chưa Check-out"
SELECT 
    COALESCE(KH.TenKH, H.TenHLV, NV.TenNV) AS [Người đang ở phòng tập],
    FORMAT(ThoiGianVao, 'HH:mm') AS [Giờ vào ca/tập],
    GhiChu
FROM DIEMDANH DD
LEFT JOIN KHACHHANG KH ON DD.MaKH = KH.MaKH
LEFT JOIN HLV H ON DD.MaHLV = H.MaHLV
LEFT JOIN NHANVIEN NV ON DD.MaNV = NV.MaNV
WHERE ThoiGianRa IS NULL AND DD.DaXoa = 0;
GO


-- 3. Tìm kiếm theo khung giờ 
DECLARE @fTuGio TIME = '17:00:00';
DECLARE @fDenGio TIME = '20:00:00';

SELECT 
    COALESCE(KH.TenKH, H.TenHLV, NV.TenNV) AS [Tên],
    FORMAT(DD.ThoiGianVao, 'HH:mm') AS [Giờ Vào],
    GhiChu
FROM DIEMDANH DD
LEFT JOIN KHACHHANG KH ON DD.MaKH = KH.MaKH
LEFT JOIN HLV H ON DD.MaHLV = H.MaHLV
LEFT JOIN NHANVIEN NV ON DD.MaNV = NV.MaNV
WHERE CAST(ThoiGianVao AS TIME) BETWEEN @fTuGio AND @fDenGio
AND DD.DaXoa = 0;
GO


-- 4. Tìm những người ở lại phòng tập lâu hơn mức trung bình
SELECT 
    MaDD, 
    GhiChu, 
    DATEDIFF(MINUTE, ThoiGianVao, ThoiGianRa) AS [Phút Ở Lại]
FROM DIEMDANH
WHERE ThoiGianRa IS NOT NULL
AND DATEDIFF(MINUTE, ThoiGianVao, ThoiGianRa) > (
    SELECT AVG(DATEDIFF(MINUTE, ThoiGianVao, ThoiGianRa)) 
    FROM DIEMDANH 
    WHERE ThoiGianRa IS NOT NULL
);
GO