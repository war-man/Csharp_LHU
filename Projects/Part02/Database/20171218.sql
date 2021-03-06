USE [HoaDon13se]
GO
/****** Object:  StoredProcedure [dbo].[SP_KiemTraDangNhap]    Script Date: 18/12/2017 11:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_KiemTraDangNhap]
@TaiKhoan VARCHAR(20),
@MatKhau VARCHAR(20)
AS
IF EXISTS (SELECT 1 FROM dbo.NhanVien WHERE TaiKhoan=@TaiKhoan AND pwdcompare(@MatKhau,matkhau)=1)--kiểm tra có tài khoản cần
BEGIN
		SELECT 1 AS result,MaNV, Ho, Ten, Phai, DiaChi, DienThoai, TaiKhoan
		FROM dbo.NhanVien
		WHERE TaiKhoan=@TaiKhoan AND pwdcompare(@MatKhau,matkhau)=1
END
ELSE--không tồn tài tài khoản
BEGIN
     SELECT 0 AS result,0 AS MaNV,''as Ho,''as Ten, 0 AS Phai, ''AS DiaChi,''as DienThoai, ''AS TaiKhoan
END
GO
/****** Object:  StoredProcedure [dbo].[SP_NhanVien_InserAndUpdate]    Script Date: 18/12/2017 11:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_NhanVien_InserAndUpdate]
    @MaNV INT,
    @Ho NVARCHAR(40),
    @Ten NVARCHAR(10),
    @Phai bit,
    @DiaChi NVARCHAR(200),
    @DienThoai VARCHAR(20),
    @TaiKhoan VARCHAR(20),
    @MatKhau VARCHAR(20)
AS
IF EXISTS (SELECT 1 FROM dbo.NhanVien WHERE MaNV = @MaNV)
BEGIN --cập nhật
    UPDATE dbo.NhanVien
    set Ho = @Ho,
        Ten = @Ten,
        Phai = @Phai,
        DiaChi = @DiaChi,
        DienThoai = @DienThoai
    where MaNV = @MaNV;

END;
ELSE
BEGIN --thêm mới
    INSERT INTO dbo.NhanVien
    (
        Ho,
        Ten,
        Phai,
        DiaChi,
        DienThoai,
        TaiKhoan,
        MatKhau
    )
    VALUES
    (@Ho, @Ten, @Phai, @DiaChi, @DienThoai, @TaiKhoan, pwdencrypt(@MatKhau));
END;
GO
/****** Object:  StoredProcedure [dbo].[SP_NhanVien_Xoa]    Script Date: 18/12/2017 11:21:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_NhanVien_Xoa]
@MaNV INT
AS
DELETE dbo.NhanVien
WHERE MaNV=@MaNV
GO
