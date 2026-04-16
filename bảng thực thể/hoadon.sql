USE [QLPhongGym];
GO

--========================================--
-- 1. XÓA BẢNG AN TOÀN                    --
--========================================--
IF OBJECT_ID('CHITIET_HOADON', 'U') IS NOT NULL DROP TABLE CHITIET_HOADON;
IF OBJECT_ID('HOADON', 'U') IS NOT NULL DROP TABLE HOADON;
GO




--========================================--
-- 2. TẠO BẢNG HOÀ ĐƠN (Cập nhật)         --
--========================================--
CREATE TABLE HOADON (
    MaHD INT IDENTITY(1,1) PRIMARY KEY,
    MaKH INT NOT NULL,
    MaNV INT NOT NULL,
    NgayLap DATETIME DEFAULT GETDATE(),
    TongTien DECIMAL(18,2) DEFAULT 0,
    PhuongThuc NVARCHAR(50) DEFAULT N'Tiền mặt', -- THÊM CỘT NÀY
    GhiChu NVARCHAR(255),
    NgaySua DATETIME DEFAULT GETDATE(),
    DaXoa BIT DEFAULT 0,

    CONSTRAINT FK_HOADON_KHACHHANG FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
    CONSTRAINT FK_HOADON_NHANVIEN FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)
);
GO




--========================================--
-- 3. TẠO BẢNG CHI TIẾT HOÁ ĐƠN           --
--========================================--
CREATE TABLE CHITIET_HOADON (
    MaCTHD INT IDENTITY(1,1) PRIMARY KEY,
    MaHD INT NOT NULL,
    MaSP INT NOT NULL,
    SoLuong INT NOT NULL CHECK (SoLuong > 0),
    DonGia DECIMAL(18,2) NOT NULL,
    ThanhTien AS (SoLuong * DonGia),

    CONSTRAINT FK_CTHD_HOADON FOREIGN KEY (MaHD) REFERENCES HOADON(MaHD),
    CONSTRAINT FK_CTHD_SANPHAM FOREIGN KEY (MaSP) REFERENCES SANPHAM(MaSP)
);
GO




--========================================--
-- 4. THÊM DỮ LIỆU MẪU                    --
--========================================--
-- Dùng RESEED 0 để bản ghi đầu tiên có ID = 1
DELETE FROM CHITIET_HOADON;
DELETE FROM HOADON;
GO
SET IDENTITY_INSERT HOADON ON;
-- Thêm hóa đơn tổng (Có phương thức thanh toán)
INSERT INTO HOADON (MaHD, MaKH, MaNV, NgayLap, TongTien, PhuongThuc, GhiChu)
VALUES 
(1, 1, 1, '2026-04-01 08:00', 35000, N'Tiền mặt', N'Bán lẻ nước uống'),
(2, 2, 5, '2026-04-01 09:15', 300000, N'Chuyển khoản', N'Phụ kiện tập gym'),
(3, 5, 8, '2026-04-02 10:00', 1550000, N'Quẹt thẻ', N'Thực phẩm chức năng'),
(4, 10, 1, '2026-04-02 14:30', 85000, N'Tiền mặt', N'Tất thể thao'),
(5, 15, 8, '2026-04-03 16:00', 2115000, N'Chuyển khoản', N'Combo giày và nước'),
(6, 6, 2, '2026-04-03 19:00', 950000, N'Tiền mặt', N'Pre-workout'),
(7, 7, 7, '2026-04-04 07:30', 250000, N'Quẹt thẻ', N'Dây kháng lực'),
(8, 8, 1, '2026-04-04 11:00', 50000, N'Tiền mặt', N'Nước điện giải'),
(9, 11, 6, '2026-04-05 15:45', 2450000, N'Chuyển khoản', N'Giày nâng tạ chuyên dụng'),
(10, 12, 3, '2026-04-05 17:20', 180000, N'Tiền mặt', N'Găng tay tập gym'),
(11, 20, 1, '2026-04-06 08:30', 550000, N'Quẹt thẻ', N'Creatine 300g'),
(12, 21, 5, '2026-04-06 12:00', 45000, N'Tiền mặt', N'Bánh Protein Bar'),
(13, 22, 8, '2026-04-07 10:00', 850000, N'Chuyển khoản', N'Thắt lưng tập Gym'),
(14, 25, 10, '2026-04-07 14:00', 1850000, N'Quẹt thẻ', N'Mass Tech Extreme'),
(15, 26, 1, '2026-04-08 18:15', 70000, N'Tiền mặt', N'Nước tăng lực'),
(16, 27, 5, '2026-04-08 20:00', 150000, N'Chuyển khoản', N'Dây kéo lưng'),
(17, 28, 7, '2026-04-09 09:00', 650000, N'Tiền mặt', N'BCAAs Amino'),
(18, 29, 8, '2026-04-09 13:30', 220000, N'Quẹt thẻ', N'Tất chuyên dụng cử tạ'),
(19, 30, 1, '2026-04-10 10:45', 105000, N'Tiền mặt', N'Nước tăng lực Monster'),
(20, 4, 2, '2026-04-10 15:00', 450000, N'Chuyển khoản', N'Vitamin tổng hợp');




-- 4. TẮT CHẾ ĐỘ TỰ GÁN ID
SET IDENTITY_INSERT HOADON OFF;
GO
-- Thêm chi tiết hóa đơn
INSERT INTO CHITIET_HOADON (MaHD, MaSP, SoLuong, DonGia) VALUES 
(1, 2, 2, 15000), (1, 1, 1, 5000),
(2, 5, 1, 180000), (2, 4, 1, 120000),
(3, 3, 1, 1550000),
(4, 28, 1, 85000),
(5, 21, 1, 1850000), (5, 13, 3, 35000), (5, 10, 2, 45000),
(6, 7, 1, 950000),
(7, 8, 1, 250000),
(8, 2, 2, 15000), (8, 1, 4, 5000),
(9, 21, 1, 2450000),
(10, 5, 1, 180000),
(11, 16, 1, 550000),
(12, 10, 1, 45000),
(13, 11, 1, 850000),
(14, 6, 1, 1850000),
(15, 13, 2, 35000),
(16, 12, 1, 150000),
(17, 19, 1, 650000),
(18, 29, 1, 220000),
(19, 13, 3, 35000),
(20, 14, 1, 450000);
GO




--========================================--
-- 5. TRUY VẤN HIỂN THỊ                   --
--========================================--
SELECT 
    'HD' + FORMAT(HD.MaHD, '00') AS [ID],
    KH.TenKH AS [Khách Hàng],
    NV.TenNV AS [Nhân Viên Bán],
    STRING_AGG(SP.TenSP, ', ') AS [Danh sách sản phẩm], -- Gộp tên sản phẩm lại
    SUM(CT.SoLuong) AS [Tổng SL],
    FORMAT(HD.TongTien, '#,### VNĐ') AS [Thành Tiền],
    HD.PhuongThuc AS [Hình Thức],
    FORMAT(HD.NgayLap, 'dd/MM/yyyy HH:mm') AS [Ngày Lập]
FROM HOADON HD
JOIN CHITIET_HOADON CT ON HD.MaHD = CT.MaHD
JOIN KHACHHANG KH ON HD.MaKH = KH.MaKH
JOIN SANPHAM SP ON CT.MaSP = SP.MaSP
JOIN NHANVIEN NV ON HD.MaNV = NV.MaNV
WHERE HD.DaXoa = 0
GROUP BY 
    HD.MaHD, 
    KH.TenKH, 
    NV.TenNV, 
    HD.TongTien, 
    HD.PhuongThuc, 
    HD.NgayLap;
GO




--========================================--
-- 6. CẬP NHẬT DỮ LIỆU (UPDATE)           --
--========================================--
-- Tình huống 1: Cập nhật phương thức thanh toán và ghi chú cho hóa đơn số 1
UPDATE HOADON
SET 
    PhuongThuc = N'Chuyển khoản',
    GhiChu = N'Khách đổi từ tiền mặt sang chuyển khoản',
    NgaySua = GETDATE()
WHERE MaHD = 1;
GO

-- Tình huống 2: Cập nhật lại đơn giá bán trong chi tiết (nếu có sai sót lúc nhập)
-- Ví dụ: Sửa đơn giá SP 2 trong hóa đơn 1 thành 16,000
UPDATE CHITIET_HOADON
SET DonGia = 16000
WHERE MaHD = 1 AND MaSP = 2;

-- Lưu ý: Nếu không dùng Trigger, bạn phải tự cập nhật lại cột TongTien ở bảng HOADON sau khi sửa CHITIET
UPDATE HD
SET HD.TongTien = (SELECT SUM(ThanhTien) FROM CHITIET_HOADON WHERE MaHD = HD.MaHD)
FROM HOADON HD
WHERE HD.MaHD = 1;
GO




--========================================--
-- 7. XÓA VÀ XEM DỮ LIỆU (DELETE/TRASH)   --
--========================================--
-- Xóa mềm hóa đơn số 4 (Khách trả hàng/Nhập sai)
UPDATE HOADON
SET 
    DaXoa = 1,
    NgaySua = GETDATE()
WHERE MaHD = 4;
GO

-- Xem danh sách hóa đơn đã xóa (Thùng rác)
SELECT 
    'HD' + FORMAT(HD.MaHD, '00') AS [ID],
    KH.TenKH AS [Khách Hàng],
    FORMAT(HD.TongTien, '#,### VNĐ') AS [Giá Trị Hủy],
    FORMAT(HD.NgaySua, 'dd/MM/yyyy HH:mm') AS [Ngày Hủy],
    HD.GhiChu AS [Ghi Chú]
FROM HOADON HD
JOIN KHACHHANG KH ON HD.MaKH = KH.MaKH
WHERE HD.DaXoa = 1;
GO




--========================================--
-- 8. TÌM KIẾM DỮ LIỆU NÂNG CAO           --
--========================================--
-- 1. Tìm kiếm hóa đơn theo tên Khách hàng hoặc tên Nhân viên

DECLARE @SearchKey NVARCHAR(100) = N'Tuấn';

SELECT 
    'HD' + FORMAT(HD.MaHD, '00') AS [ID],
    KH.TenKH AS [Tên Khách Hàng],
    NV.TenNV AS [Nhân Viên Lập],
    FORMAT(HD.TongTien, '#,### VNĐ') AS [Giá Trị Hóa Đơn],
    CONVERT(VARCHAR, HD.NgayLap, 103) AS [Ngày Lập] -- Định dạng dd/mm/yyyy
FROM HOADON HD
JOIN KHACHHANG KH ON HD.MaKH = KH.MaKH
JOIN NHANVIEN NV ON HD.MaNV = NV.MaNV
WHERE (KH.TenKH LIKE N'%' + @SearchKey + N'%' OR NV.TenNV LIKE N'%' + @SearchKey + N'%')
AND HD.DaXoa = 0;
GO
-- 2. Tìm kiếm hóa đơn phát sinh trong một khoảng thời gian
DECLARE @TuNgay DATETIME = '2026-04-01';
DECLARE @DenNgay DATETIME = '2026-04-05 23:59:59';

SELECT 
    'HD' + FORMAT(MaHD, '00') AS [ID],
    FORMAT(TongTien, '#,### VNĐ') AS [Tổng Tiền],
    PhuongThuc AS [PT Thanh Toán],
    CONVERT(VARCHAR, NgayLap, 103) + ' ' + CONVERT(VARCHAR, NgayLap, 108) AS [Thời Gian]
FROM HOADON
WHERE NgayLap BETWEEN @TuNgay AND @DenNgay AND DaXoa = 0;
GO

-- 3. Tìm các hóa đơn có giá trị lớn (Trên 1,000,000 VNĐ)
SELECT TOP 3
    UPPER(SP.TenSP) AS [TÊN SẢN PHẨM], -- Viết hoa tên SP cho nổi bật
    SUM(CT.SoLuong) AS [SỐ LƯỢNG ĐÃ BÁN],
    N'⭐' AS [Xếp Hạng] -- Thêm icon trang trí nếu hiển thị trên web/app
FROM CHITIET_HOADON CT
JOIN SANPHAM SP ON CT.MaSP = SP.MaSP
JOIN HOADON HD ON CT.MaHD = HD.MaHD
WHERE HD.DaXoa = 0
GROUP BY SP.TenSP
ORDER BY [SỐ LƯỢNG ĐÃ BÁN] DESC;
GO




--========================================--
-- 9. THỐNG KÊ DOANH SỐ BÁN LẺ            --
--========================================--
-- Thống kê tổng tiền thu được theo từng phương thức thanh toán
SELECT 
    PhuongThuc,
    COUNT(MaHD) AS [Số Đơn Hàng],
    FORMAT(SUM(TongTien), '#,### VNĐ') AS [Tổng Doanh Thu]
FROM HOADON
WHERE DaXoa = 0
GROUP BY PhuongThuc;

-- Tìm sản phẩm nào đang bán chạy nhất (Top 3)
SELECT TOP 3
    SP.TenSP,
    SUM(CT.SoLuong) AS [Tổng Số Lượng Bán]
FROM CHITIET_HOADON CT
JOIN SANPHAM SP ON CT.MaSP = SP.MaSP
JOIN HOADON HD ON CT.MaHD = HD.MaHD
WHERE HD.DaXoa = 0
GROUP BY SP.TenSP
ORDER BY [Tổng Số Lượng Bán] DESC;
GO