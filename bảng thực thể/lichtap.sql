USE [QLPhongGym];
GO

--========================================--
-- 1. XÓA BẢNG AN TOÀN                    --
--========================================--
IF OBJECT_ID('dbo.LICHTAP', 'U') IS NOT NULL DROP TABLE dbo.LICHTAP;
GO




--========================================--
--========== 2. TẠO BẢNG LỊCH TẬP ========--
--========================================--
CREATE TABLE LICHTAP (
    MaLich INT IDENTITY(1,1) PRIMARY KEY,
    MaKH INT NOT NULL,     
    MaHLV INT NOT NULL,     
    
    NgayTap DATE NOT NULL,
    GioBatDau TIME NOT NULL, 
    GioKetThuc TIME NOT NULL, 
    
    NoiDung NVARCHAR(500) NULL, 
    
    -- Các cột đồng bộ hệ thống
    NgaySua DATETIME DEFAULT GETDATE(),
    DaXoa BIT DEFAULT 0,

    -- Thiết lập các khóa ngoại
    CONSTRAINT FK_LICHTAP_KHACHHANG FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
    CONSTRAINT FK_LICHTAP_HLV FOREIGN KEY (MaHLV) REFERENCES HLV(MaHLV),
    CONSTRAINT CK_GioTap CHECK (GioKetThuc > GioBatDau)
);
GO




--========================================--
--========== 3. THÊM VÀ XEM DỮ LIỆU ======--
--========================================--
IF OBJECT_ID('LICHTAP', 'U') IS NOT NULL 
BEGIN
    DELETE FROM LICHTAP;
    DBCC CHECKIDENT ('LICHTAP', RESEED, 1); -- Đưa về 0 để ID bắt đầu bằng 1
END
GO

-- (Dữ liệu mẫu của bạn - Đảm bảo các MaKH này đã có DANGKY hợp lệ bao phủ tháng 4/2026)
INSERT INTO LICHTAP (MaKH, MaHLV, NgayTap, GioBatDau, GioKetThuc, NoiDung)
VALUES 
(24, 26, '2026-04-19', '19:00', '20:30', N'Yoga - Thư giãn'),
(11, 3, '2026-04-17', '06:30', '08:00', N'Gym - Cơ bắp tay'),
(12, 11, '2026-04-21', '18:30', '20:00', N'Aerobics - Đốt calo cường độ cao'),
(1, 3, '2026-04-18', '17:00', '18:30', N'Gym - Duy trì cơ bắp'),
(2, 2, '2026-04-17', '06:00', '07:30', N'Zumba - Khởi động sáng'),
(19, 14, '2026-04-17', '19:00', '20:30', N'Boxing - Đối kháng'),
(14, 4, '2026-04-17', '09:30', '11:00', N'Pilates - Cốt lõi'),
(27, 27, '2026-04-17', '20:00', '21:30', N'Crossfit - Bùng nổ'),
(6, 6, '2026-04-17', '05:30', '07:00', N'Yoga - Chào mặt trời'),
(13, 7, '2026-04-17', '07:00', '08:30', N'Gym - Full body'),
(23, 1, '2026-04-17', '18:00', '19:30', N'Yoga - Thiền định Nam'),
(12, 2, '2026-04-17', '07:30', '09:00', N'Zumba - Đốt mỡ nhanh'),
(21, 3, '2026-04-17', '08:00', '09:30', N'Gym - Chân nặng'),
(11, 1, '2026-04-20', '06:30', '08:00', N'Yoga Nam - Tăng độ dẻo'),
(4, 4, '2026-04-17', '08:00', '09:30', N'Pilates - Dáng đẹp'),
(15, 5, '2026-04-17', '07:30', '09:00', N'Crossfit - Sức bền'),
(22, 13, '2026-04-17', '17:00', '18:30', N'Yoga - Dẻo dai Nữ'),
(17, 12, '2026-04-17', '18:30', '20:00', N'Gym - Vai rộng'),
(9, 14, '2026-04-17', '17:30', '19:00', N'Boxing - Kỹ thuật đấm'),
(1, 3, '2026-04-17', '05:00', '06:30', N'Gym - Sức mạnh ngực'),
(25, 1, '2026-04-17', '19:30', '21:00', N'Yoga - Khỏe mạnh'),
(8, 8, '2026-04-17', '17:00', '18:30', N'Zumba - Sôi động chiều'),
(13, 12, '2026-04-18', '07:30', '09:00', N'Gym - Thể hình'),
(29, 27, '2026-04-17', '05:00', '06:30', N'Crossfit - Khởi động'),
(5, 5, '2026-04-17', '06:00', '07:30', N'Crossfit - Thể lực'),
(10, 10, '2026-04-17', '17:30', '19:00', N'Pilates - Trị liệu'),
(3, 7, '2026-04-17', '05:30', '07:00', N'Gym - Squat nâng cao'),
(16, 6, '2026-04-17', '07:00', '08:30', N'Yoga - Thăng bằng'),
(24, 13, '2026-04-17', '18:30', '20:00', N'Yoga - Cột sống'),
(7, 12, '2026-04-17', '17:00', '18:30', N'Gym - Xô lưng'),
(18, 8, '2026-04-17', '18:30', '20:00', N'Zumba - Party tối'),
(20, 10, '2026-04-17', '19:00', '20:30', N'Pilates - Linh hoạt'),
(11, 3, '2026-04-18', '18:30', '20:00', N'Gym - Siết cơ'),
(12, 2, '2026-04-18', '19:00', '20:30', N'Zumba - Giải tỏa stress'),
(5, 5, '2026-04-18', '17:00', '18:30', N'Crossfit - Cardio'),
(4, 4, '2026-04-18', '06:00', '07:30', N'Pilates - Core'),
(2, 2, '2026-04-18', '08:00', '09:30', N'Zumba - Sáng năng lượng'),
(15, 5, '2026-04-18', '18:30', '20:00', N'Crossfit - Endurance'),
(26, 4, '2026-04-18', '17:00', '18:30', N'Pilates - Toàn thân'),
(6, 6, '2026-04-18', '19:00', '20:30', N'Yoga - Bay'),
(3, 12, '2026-04-18', '06:00', '07:30', N'Gym - Powerlifting'),
(28, 6, '2026-04-18', '05:30', '07:00', N'Yoga - Detox'),
(19, 29, '2026-04-18', '17:30', '19:00', N'Boxing - Tốc độ'),
(9, 29, '2026-04-18', '06:00', '07:30', N'Boxing - Phản xạ'),
(8, 11, '2026-04-18', '18:00', '19:30', N'Aerobics - Giảm cân'),
(20, 11, '2026-04-18', '06:30', '08:00', N'Aerobics - Dance'),
(7, 7, '2026-04-18', '20:00', '21:30', N'Gym - Bụng'),
(17, 7, '2026-04-18', '08:30', '10:00', N'Gym - Lưng xô'),
(21, 30, '2026-04-18', '17:00', '18:30', N'Gym - Chuyên sâu Nam'),
(30, 30, '2026-04-18', '18:30', '20:00', N'Gym - Chân'),
(25, 25, '2026-04-19', '06:00', '07:30', N'Gym - Tổng hợp'),
(27, 25, '2026-04-19', '17:00', '18:30', N'Gym - Lực đẩy'),
(22, 26, '2026-04-19', '08:00', '09:30', N'Yoga - Tĩnh tâm'),
(23, 23, '2026-04-19', '06:30', '08:00', N'Zumba - Khỏe trẻ'),
(10, 28, '2026-04-19', '17:30', '19:00', N'Pilates - Vóc dáng'),
(11, 29, '2026-04-19', '05:00', '06:30', N'Boxing - Khởi động'),
(12, 24, '2026-04-19', '20:00', '21:30', N'Aerobics - Đêm sôi động'),
(1, 1, '2026-04-19', '09:00', '10:30', N'Yoga - Sức mạnh Nam'),
(15, 1, '2026-04-19', '18:00', '19:30', N'Yoga - Trị liệu Nam'),
(21, 1, '2026-04-20', '17:00', '18:30', N'Yoga Nam - Trị liệu vai gáy'),
(2, 2, '2026-04-20', '06:00', '07:30', N'Zumba - Sáng năng động'),
(22, 2, '2026-04-20', '18:30', '20:00', N'Zumba - Nhịp điệu tối'),
(3, 3, '2026-04-20', '05:30', '07:00', N'Gym - Ngực và tay sau'),
(13, 3, '2026-04-20', '07:00', '08:30', N'Gym - Vai rộng'),
(23, 3, '2026-04-20', '19:00', '20:30', N'Gym - Chân nặng'),
(4, 4, '2026-04-20', '08:00', '09:30', N'Pilates - Vòng eo thon'),
(14, 4, '2026-04-20', '17:00', '18:30', N'Pilates - Cơ trọng tâm'),
(24, 4, '2026-04-20', '18:30', '20:00', N'Pilates - Thăng bằng'),
(19, 14, '2026-04-20', '17:30', '19:00', N'Boxing - Di chuyển bộ chân'),
(29, 14, '2026-04-20', '19:00', '20:30', N'Boxing - Combo đấm'),
(5, 5, '2026-04-21', '06:00', '07:30', N'Crossfit - Sức mạnh tổng thể'),
(15, 5, '2026-04-21', '07:30', '09:00', N'Crossfit - Cardio cường độ cao'),
(25, 5, '2026-04-21', '17:00', '18:30', N'Crossfit - Bứt phá giới hạn'),
(6, 6, '2026-04-21', '05:30', '07:00', N'Yoga - Chào mặt trời'),
(16, 6, '2026-04-21', '07:00', '08:30', N'Yoga - Giữ thăng bằng'),
(26, 6, '2026-04-21', '19:00', '20:30', N'Yoga - Thiền tĩnh tâm'),
(7, 12, '2026-04-21', '06:30', '08:00', N'Gym - Lưng xô chuyên sâu'),
(17, 12, '2026-04-21', '08:00', '09:30', N'Gym - Tay trước tay sau'),
(27, 12, '2026-04-21', '18:00', '19:30', N'Gym - Squat & Deadlift'),
(8, 11, '2026-04-21', '08:30', '10:00', N'Aerobics - Nhịp điệu trẻ'),
(18, 11, '2026-04-21', '17:30', '19:00', N'Aerobics - Đốt calo'),
(28, 11, '2026-04-21', '19:00', '20:30', N'Aerobics - Dáng chuẩn'),
(9, 29, '2026-04-21', '17:00', '18:30', N'Boxing - Phản xạ nhanh'),
(20, 21, '2026-04-21', '05:30', '07:00', N'Yoga Nữ - Khởi động'),
(13, 13, '2026-04-22', '07:00', '08:30', N'Yoga - Phục hồi cột sống'),
(23, 13, '2026-04-22', '18:30', '20:00', N'Yoga - Thư giãn cơ'),
(17, 14, '2026-04-22', '06:00', '07:30', N'Boxing - Đối kháng nhẹ'),
(27, 14, '2026-04-22', '17:30', '19:00', N'Boxing - Kỹ thuật phòng thủ'),
(15, 25, '2026-04-22', '08:00', '09:30', N'Gym - Tăng cơ giảm mỡ'),
(25, 25, '2026-04-22', '19:30', '21:00', N'Gym - Thể hình cơ bản'),
(16, 26, '2026-04-22', '05:30', '07:00', N'Yoga - Detox cơ thể'),
(26, 26, '2026-04-22', '17:00', '18:30', N'Yoga - Bay nâng cao'),
(19, 27, '2026-04-22', '06:30', '08:00', N'Crossfit - Thể lực kéo dài'),
(29, 27, '2026-04-22', '18:00', '19:30', N'Crossfit - Bài tập tạ'),
(10, 28, '2026-04-22', '07:30', '09:00', N'Pilates - Thăng bằng core'),
(30, 30, '2026-04-22', '20:00', '21:30', N'Gym - Xây dựng cơ chân'),
(1, 3, '2026-04-23', '05:00', '06:30', N'Gym - Cơ ngực cao điểm'),
(11, 3, '2026-04-23', '06:30', '08:00', N'Gym - Cơ bụng 6 múi'),
(2, 8, '2026-04-23', '17:00', '18:30', N'Zumba - Vũ điệu Latin'),
(12, 8, '2026-04-23', '18:30', '20:00', N'Zumba - Party tối muộn'),
(5, 18, '2026-04-23', '06:00', '07:30', N'Crossfit - Sức mạnh bộc phát'),
(15, 18, '2026-04-23', '19:00', '20:30', N'Crossfit - Thử thách ngày mới'),
(6, 21, '2026-04-23', '07:00', '08:30', N'Yoga - Bay nâng cao'),
(16, 21, '2026-04-23', '17:30', '19:00', N'Yoga - Thăng bằng nâng cao'),
(7, 22, '2026-04-23', '05:30', '07:00', N'Gym - Tập trung cơ tay'),
(17, 22, '2026-04-23', '08:00', '09:30', N'Gym - Kỹ thuật kéo xô'),
(9, 20, '2026-04-23', '17:00', '18:30', N'Boxing - Ca chiều tốc độ'),
(19, 20, '2026-04-23', '18:30', '20:00', N'Boxing - Đối kháng chuyên sâu');
GO




--========================================--
--========== 4. XEM DỮ LIỆU TỔNG HỢP =====--
--========================================--
SELECT 
    'LT' + FORMAT(LT.MaLich, '00') AS [ID],
    KH.TenKH AS [Tên KH],
    HLV.TenHLV AS [Tên HLV Phụ Trách],
    CASE DATEPART(WEEKDAY, LT.NgayTap)
        WHEN 1 THEN N'Chủ Nhật'
        WHEN 2 THEN N'Thứ Hai'
        WHEN 3 THEN N'Thứ Ba'
        WHEN 4 THEN N'Thứ Tư'
        WHEN 5 THEN N'Thứ Năm'
        WHEN 6 THEN N'Thứ Sáu'
        WHEN 7 THEN N'Thứ Bảy'
    END AS [Thứ],
    FORMAT(LT.NgayTap, 'dd/MM/yyyy') AS [Ngày Tập],
    CONVERT(VARCHAR(5), LT.GioBatDau, 108) + ' - ' + 
    CONVERT(VARCHAR(5), LT.GioKetThuc, 108) AS [Khung Giờ],
    LT.NoiDung AS [Nội Dung Tập],
    FORMAT(LT.NgaySua, 'dd/MM/yyyy HH:mm') AS [Lần Cập Nhật Cuối]
FROM LICHTAP LT
INNER JOIN KHACHHANG KH ON LT.MaKH = KH.MaKH
INNER JOIN HLV ON LT.MaHLV = HLV.MaHLV
WHERE LT.DaXoa = 0 
--ORDER BY LT.NgayTap DESC, LT.GioBatDau ASC;
GO




--========================================--
--========== 5. CẬP NHẬT TRẠNG THÁI ======--
--========================================--
UPDATE LICHTAP
SET 
     GioBatDau = '20:00',
    GioKetThuc = '21:00', 
    NoiDung = N'Tập chân - mông ',
    NgaySua = GETDATE()
WHERE MaLich = 1;
GO




--========================================--
--========== 6. HỦY LỊCH VÀ KHÔI PHỤC ====--
--========================================--
-- Hủy lịch tập số 5 (Khách hàng báo bận)
UPDATE LICHTAP
SET 
    DaXoa = 1,
    NoiDung = NoiDung + N' (ĐÃ HỦY)',
    NgaySua = GETDATE()
WHERE MaLich = 5 AND DaXoa = 0;
GO


-- Xem thùng rác
SELECT 
    'LT' + FORMAT(LT.MaLich, '000') AS [ID],
    KH.TenKH AS [Khách Hàng],
    HLV.TenHLV AS [HLV Phụ Trách],
    FORMAT(LT.NgayTap, 'dd/MM/yyyy') AS [Ngày Tập],
    CONVERT(VARCHAR(5), LT.GioBatDau, 108) + '-' + 
    CONVERT(VARCHAR(5), LT.GioKetThuc, 108) AS [Khung Giờ],
    LT.NoiDung AS [Ghi Chú Hủy],
    FORMAT(LT.NgaySua, 'dd/MM/yyyy HH:mm') AS [Thời Điểm Hủy]
FROM LICHTAP LT
JOIN KHACHHANG KH ON LT.MaKH = KH.MaKH
JOIN HLV ON LT.MaHLV = HLV.MaHLV
WHERE LT.DaXoa = 1
--ORDER BY LT.NgaySua DESC; 
GO


-- Khôi phục
UPDATE LICHTAP 
SET DaXoa = 0, 
    NoiDung = REPLACE(NoiDung, N' (ĐÃ HỦY)', ''), 
    NgaySua = GETDATE() 
WHERE MaLich = 5;
GO




--========================================--
--========== 7. TÌM KIẾM DỮ LIỆU =========--
--========================================--
-- Tìm kiếm lịch của HLV
DECLARE @TenHLV NVARCHAR(100) = N'Nguyễn Văn Hùng'; 

SELECT 
    'LT' + FORMAT(LT.MaLich, '000') AS [ID],
    HLV.TenHLV AS [HLV Phụ Trách],
    KH.TenKH AS [Khách Hàng],
    CASE DATEPART(WEEKDAY, LT.NgayTap)
        WHEN 1 THEN N'Chủ Nhật' ELSE N'Thứ ' + CAST(DATEPART(WEEKDAY, LT.NgayTap) AS NVARCHAR)
    END AS [Thứ],
    FORMAT(LT.NgayTap, 'dd/MM/yyyy') AS [Ngày Tập],
    CONVERT(VARCHAR(5), LT.GioBatDau, 108) + ' - ' + 
    CONVERT(VARCHAR(5), LT.GioKetThuc, 108) AS [Khung Giờ],
    LT.NoiDung AS [Nội Dung]
FROM LICHTAP LT
JOIN KHACHHANG KH ON LT.MaKH = KH.MaKH
JOIN HLV ON LT.MaHLV = HLV.MaHLV
WHERE HLV.TenHLV LIKE N'%' + @TenHLV + '%'
  AND LT.DaXoa = 0
--ORDER BY LT.NgayTap ASC, LT.GioBatDau ASC;
GO


-- Tìm kiếm lịch trong 1 ngày
DECLARE @NgayCanTim DATE = '2026-04-17'; 

SELECT 
    CONVERT(VARCHAR(5), LT.GioBatDau, 108) + ' - ' + 
    CONVERT(VARCHAR(5), LT.GioKetThuc, 108) AS [Khung Giờ],
    KH.TenKH AS [Khách Hàng],
    KH.SDT AS [SĐT Khách],
    HLV.TenHLV AS [HLV Phụ Trách],
    LT.NoiDung AS [Bài Tập Dự Kiến]
FROM LICHTAP LT
JOIN KHACHHANG KH ON LT.MaKH = KH.MaKH
JOIN HLV ON LT.MaHLV = HLV.MaHLV
WHERE LT.NgayTap = @NgayCanTim
  AND LT.DaXoa = 0
--ORDER BY LT.GioBatDau ASC;
GO




--========================================--
--======== 8. THỐNG KÊ DOANH SỐ HLV ======--
--========================================--
SELECT 
    HLV.TenHLV AS [Tên HLV],
    HLV.ChuyenMon AS [Chuyên Môn],
    COUNT(LT.MaLich) AS [Tổng Số Ca Dạy],
    CAST(COUNT(LT.MaLich) * 1.5 AS DECIMAL(10,1)) AS [Tổng Giờ Dạy (h)]
FROM HLV
LEFT JOIN LICHTAP LT ON HLV.MaHLV = LT.MaHLV AND LT.DaXoa = 0
GROUP BY HLV.TenHLV, HLV.ChuyenMon
--ORDER BY [Tổng Số Ca Dạy] DESC;
GO




--========================================--
--====== 9. KIỂM TRA TRÙNG LỊCH DẠY ======--
--========================================--
-- Chạy đoạn này để rà soát lại xem có ca nào bị lọt kẽ hở trước khi cài Trigger không
SELECT 
    FORMAT(A.NgayTap, 'dd/MM/yyyy') AS [Ngày Trùng],
    H.TenHLV AS [Huấn Luyện Viên],
    CONVERT(VARCHAR(5), A.GioBatDau, 108) + '-' + CONVERT(VARCHAR(5), A.GioKetThuc, 108) AS [Khung Giờ Ca 1],
    K1.TenKH AS [Khách 1],
    CONVERT(VARCHAR(5), B.GioBatDau, 108) + '-' + CONVERT(VARCHAR(5), B.GioKetThuc, 108) AS [Khung Giờ Ca 2],
    K2.TenKH AS [Khách 2],
    N'Lỗi: Trùng thời gian!' AS [Cảnh Báo]
FROM LICHTAP A
JOIN LICHTAP B ON A.MaHLV = B.MaHLV 
    AND A.NgayTap = B.NgayTap 
    AND A.MaLich < B.MaLich 
JOIN HLV H ON A.MaHLV = H.MaHLV
JOIN KHACHHANG K1 ON A.MaKH = K1.MaKH
JOIN KHACHHANG K2 ON B.MaKH = K2.MaKH
WHERE 
    (A.GioBatDau < B.GioKetThuc AND B.GioBatDau < A.GioKetThuc)
    AND A.DaXoa = 0 
    AND B.DaXoa = 0
--ORDER BY A.NgayTap ASC;
GO