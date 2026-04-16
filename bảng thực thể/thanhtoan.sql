USE [QLPhongGym];
GO

--========================================--
-- 1. XÓA BẢNG AN TOÀN                    --
--========================================--
IF OBJECT_ID('THANHTOAN', 'U') IS NOT NULL DROP TABLE THANHTOAN;
GO




--========================================--
--========== 2. TẠO BẢNG THANH TOÁN ======--
--========================================--
CREATE TABLE THANHTOAN (
    MaTT INT IDENTITY(1,1) PRIMARY KEY,  
    MaDK INT NOT NULL,                  
    NgayThanhToan DATETIME DEFAULT GETDATE(),
    SoTien DECIMAL(10,2) NOT NULL,    
    PhuongThuc NVARCHAR(50) NULL,    
    TrangThai NVARCHAR(50) DEFAULT N'Chờ thanh toán',
    
    -- Các cột đồng bộ như các bảng trước
    NgaySua DATETIME DEFAULT GETDATE(),
    DaXoa BIT DEFAULT 0,

    -- Ràng buộc khóa ngoại
    CONSTRAINT FK_THANHTOAN_DANGKY FOREIGN KEY (MaDK) REFERENCES DANGKY(MaDK)
);
GO

ALTER TABLE THANHTOAN ADD CONSTRAINT CK_TongTien CHECK (SoTien >= 0);
GO




--========================================--
--========== 3. THÊM DỮ LIỆU MẪU =========--
--========================================--
DELETE FROM THANHTOAN;
DBCC CHECKIDENT ('THANHTOAN', RESEED, 1); -- Sửa lại RESEED 0 để ID bắt đầu từ 1
GO

INSERT INTO THANHTOAN (MaDK, SoTien, NgayThanhToan, PhuongThuc, TrangThai)
VALUES 
(1, 500000, '2026-04-01 08:30:00', N'Tiền mặt', N'Đã thanh toán'),
(2, 5000000, '2026-04-08 10:15:00', N'Chuyển khoản', N'Chưa thanh toán'),
(3, 12000000, GETDATE(), N'Quẹt thẻ', N'Đã thanh toán'),
(4, 500000, '2026-04-07 09:00:00', N'Tiền mặt', N'Đã thanh toán'),
(5, 1200000, '2026-04-12 14:20:00', N'Chuyển khoản', N'Đã thanh toán'),
(6, 350000, '2026-04-13 15:00:00', N'Tiền mặt', N'Đã thanh toán'),
(7, 1500000, '2026-04-14 10:00:00', N'Quẹt thẻ', N'Đã thanh toán'),
(8, 1200000, '2026-04-15 08:45:00', N'Chuyển khoản', N'Chưa thanh toán'),
(9, 15000000, '2026-04-15 11:30:00', N'Chuyển khoản', N'Đã thanh toán'),
(10, 4000000, '2026-04-16 16:00:00', N'Quẹt thẻ', N'Đã thanh toán'),
(11, 500000, '2026-04-16 17:30:00', N'Tiền mặt', N'Chưa thanh toán'),
(12, 400000, '2026-04-17 06:15:00', N'Tiền mặt', N'Đã thanh toán'),
(13, 800000, '2026-04-17 18:00:00', N'Chuyển khoản', N'Đã thanh toán'),
(14, 5000000, '2026-04-18 09:30:00', N'Quẹt thẻ', N'Đã thanh toán'),
(15, 350000, '2026-04-18 14:00:00', N'Tiền mặt', N'Chưa thanh toán'),
(16, 1200000, '2026-04-19 10:45:00', N'Chuyển khoản', N'Đã thanh toán'),
(17, 700000, '2026-04-19 15:20:00', N'Tiền mặt', N'Đã thanh toán'),
(18, 500000, '2026-04-20 08:00:00', N'Tiền mặt', N'Đã thanh toán'),
(19, 900000, '2026-04-20 19:15:00', N'Chuyển khoản', N'Chưa thanh toán'),
(20, 1500000, '2026-04-21 11:00:00', N'Quẹt thẻ', N'Đã thanh toán'),
(21, 1600000, '2026-04-21 17:00:00', N'Chuyển khoản', N'Đã thanh toán'),
(22, 350000, '2026-04-22 09:00:00', N'Tiền mặt', N'Đã thanh toán'),
(23, 500000, '2026-04-22 18:30:00', N'Tiền mặt', N'Đã thanh toán'),
(24, 400000, '2026-04-23 20:15:00', N'Chuyển khoản', N'Chưa thanh toán'),
(25, 1200000, '2026-04-23 10:00:00', N'Quẹt thẻ', N'Đã thanh toán'),
(26, 1200000, '2026-04-24 15:45:00', N'Chuyển khoản', N'Đã thanh toán'),
(27, 800000, '2026-04-24 17:00:00', N'Tiền mặt', N'Đã thanh toán'),
(28, 4000000, '2026-04-25 08:30:00', N'Quẹt thẻ', N'Chưa thanh toán'),
(29, 350000, '2026-04-25 14:15:00', N'Tiền mặt', N'Đã thanh toán'),
(30, 1500000, '2026-04-26 10:00:00', N'Chuyển khoản', N'Đã thanh toán');
GO




--========================================--
--========== 4. XEM DỮ LIỆU TỔNG HỢP =====--
--========================================--
SELECT 
    'TT' + FORMAT(TT.MaTT, '00') AS [ID],
    'DK' + FORMAT(DK.MaDK, '00') AS [Mã ĐK],
    KH.TenKH AS [Tên Khách Hàng],
    GT.TenGoi AS [Gói Tập],
    ISNULL(HLV.TenHLV, N'Tự do') AS [HLV Phụ Trách],
    FORMAT(TT.SoTien, '#,### VNĐ') AS [Số Tiền TT], 
    FORMAT(TT.NgayThanhToan, 'dd/MM/yyyy HH:mm') AS [Ngày Thanh Toán],
    CASE 
        WHEN TT.TrangThai = N'Đã thanh toán' THEN N'✅ ' + TT.TrangThai
        WHEN TT.TrangThai = N'Chưa thanh toán' THEN N'❌ ' + TT.TrangThai
        ELSE TT.TrangThai
    END AS [Trạng Thái],
    CASE 
        WHEN TT.TrangThai = N'Chưa thanh toán' THEN N'---' 
        ELSE TT.PhuongThuc 
    END AS [Hình Thức],
    FORMAT(TT.NgaySua, 'dd/MM/yyyy HH:mm') AS [Cập nhật lần cuối]
FROM THANHTOAN TT
JOIN DANGKY DK ON TT.MaDK = DK.MaDK
JOIN KHACHHANG KH ON DK.MaKH = KH.MaKH
JOIN GOITAP GT ON DK.MaGoi = GT.MaGoi
LEFT JOIN HLV ON DK.MaHLV = HLV.MaHLV
WHERE TT.DaXoa = 0 
ORDER BY TT.NgaySua DESC; 
GO




--========================================--
--========== 5. CẬP NHẬT TRẠNG THÁI ======--
--========================================--
UPDATE THANHTOAN
SET 
    TrangThai = N'Đã thanh toán',
    NgayThanhToan = GETDATE(), 
    PhuongThuc = N'Chuyển khoản',
    NgaySua = GETDATE()
WHERE MaTT = 2; 
GO




--========================================--
--========== 6. TÌM KIẾM DỮ LIỆU =========--
--========================================--
DECLARE @fTenKH NVARCHAR(100) = NULL;         
DECLARE @fTrangThai NVARCHAR(50) = N'Chưa thanh toán'; 
DECLARE @fTuNgay DATE = NULL;                 
DECLARE @fDenNgay DATE = NULL;                

SELECT 
    'TT' + FORMAT(TT.MaTT, '00') AS [ID],
    KH.TenKH AS [Khách Hàng],
    KH.SDT AS [Số Điện Thoại],
    GT.TenGoi AS [Gói Tập],
    ISNULL(HLV.TenHLV, N'---') AS [HLV],
    FORMAT(TT.SoTien, '#,###') + ' VND' AS [Số Tiền],
    FORMAT(TT.NgayThanhToan, 'dd/MM/yyyy') AS [Ngày Giao Dịch],

    CASE 
        WHEN TT.TrangThai = N'Đã thanh toán' THEN N'✅ Đã xong'
        WHEN TT.TrangThai = N'Chưa thanh toán' THEN N'❌ Còn nợ'
        ELSE N'❓ ' + TT.TrangThai
    END AS [Trạng Thái],
    
    CASE 
        WHEN TT.TrangThai = N'Chưa thanh toán' THEN N'🚩 Cần thu tiền'
        ELSE ISNULL(TT.PhuongThuc, N'Tiền mặt') 
    END AS [Hình Thức/Ghi chú],

    CASE 
        WHEN TT.TrangThai = N'Chưa thanh toán' AND DATEDIFF(day, TT.NgayThanhToan, GETDATE()) > 30 
        THEN N'❗ Nợ lâu' 
        ELSE N'' 
    END AS [Cảnh báo]
FROM THANHTOAN TT
JOIN DANGKY DK ON TT.MaDK = DK.MaDK
JOIN KHACHHANG KH ON DK.MaKH = KH.MaKH
JOIN GOITAP GT ON DK.MaGoi = GT.MaGoi
LEFT JOIN HLV ON DK.MaHLV = HLV.MaHLV
WHERE 
    TT.DaXoa = 0 
    AND (@fTenKH IS NULL OR KH.TenKH LIKE N'%' + @fTenKH + N'%')
    AND (@fTrangThai IS NULL OR TT.TrangThai = @fTrangThai)
    AND (@fTuNgay IS NULL OR TT.NgayThanhToan >= @fTuNgay)
    AND (@fDenNgay IS NULL OR TT.NgayThanhToan <= @fDenNgay)
ORDER BY 
    CASE WHEN TT.TrangThai = N'Chưa thanh toán' THEN 0 ELSE 1 END, 
    TT.NgayThanhToan ASC;
GO


-- Tìm khách hàng có số tiền thanh toán cao hơn mức trung bình
SELECT KH.TenKH, SUM(TT.SoTien) AS [Tổng Chi]
FROM THANHTOAN TT
JOIN DANGKY DK ON TT.MaDK = DK.MaDK
JOIN KHACHHANG KH ON DK.MaKH = KH.MaKH
WHERE TT.TrangThai = N'Đã thanh toán'
GROUP BY KH.TenKH
HAVING SUM(TT.SoTien) > (SELECT AVG(SoTien) FROM THANHTOAN WHERE TrangThai = N'Đã thanh toán');
GO




--========================================--
--========== 7. BÁO CÁO DOANH THU ========--
--========================================--
-- Theo HLV (Đã fix lỗi chia cho 0)
SELECT 
    ISNULL(HLV.TenHLV, N'--- Tự tập (Không PT) ---') AS [Huấn Luyện Viên],
    COUNT(TT.MaTT) AS [Số HĐ],
    FORMAT(SUM(TT.SoTien), '#,### VNĐ') AS [Tổng Doanh Thu],
    
    -- Dùng NULLIF để nếu tổng DT = 0 thì không bị báo lỗi toán học
    FORMAT(SUM(TT.SoTien) / NULLIF((SELECT SUM(SoTien) FROM THANHTOAN WHERE TrangThai = N'Đã thanh toán' AND DaXoa = 0), 0), 'P') AS [Tỷ Trọng],

    CASE 
        WHEN SUM(TT.SoTien) > 10000000 THEN N'⭐ Xuất sắc'
        WHEN SUM(TT.SoTien) > 5000000 THEN N'✅ Đạt chỉ tiêu'
        ELSE N'🛡️ Ổn định'
    END AS [Đánh giá]
FROM THANHTOAN TT
JOIN DANGKY DK ON TT.MaDK = DK.MaDK
LEFT JOIN HLV ON DK.MaHLV = HLV.MaHLV
WHERE TT.TrangThai = N'Đã thanh toán' AND TT.DaXoa = 0
GROUP BY HLV.TenHLV
ORDER BY SUM(TT.SoTien) DESC;
GO


-- Theo gói tập
SELECT 
    GT.TenGoi AS [Gói Tập],
    COUNT(TT.MaTT) AS [Số Lượng Khách],
    FORMAT(SUM(TT.SoTien), '#,### VNĐ') AS [Doanh Thu Gói],
    N'🔥' + REPLICATE('|', COUNT(TT.MaTT) / 2) AS [Biểu đồ cột] 
FROM THANHTOAN TT
JOIN DANGKY DK ON TT.MaDK = DK.MaDK
JOIN GOITAP GT ON DK.MaGoi = GT.MaGoi
WHERE TT.TrangThai = N'Đã thanh toán' AND TT.DaXoa = 0
GROUP BY GT.TenGoi
ORDER BY COUNT(TT.MaTT) DESC;
GO


-- Theo tháng
SELECT 
    MONTH(TT.NgayThanhToan) AS [Tháng],
    YEAR(TT.NgayThanhToan) AS [Năm],
    COUNT(TT.MaTT) AS [Tổng Đơn hàng],
    FORMAT(SUM(TT.SoTien), '#,### VNĐ') AS [Thực Thu],
    FORMAT(AVG(TT.SoTien), '#,### VNĐ') AS [Giá trị đơn TB]
FROM THANHTOAN TT
WHERE TT.TrangThai = N'Đã thanh toán' AND TT.DaXoa = 0
GROUP BY MONTH(TT.NgayThanhToan), YEAR(TT.NgayThanhToan)
ORDER BY [Năm] DESC, [Tháng] DESC;
GO