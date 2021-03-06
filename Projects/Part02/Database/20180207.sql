USE [HoaDon13se]
GO
/****** Object:  StoredProcedure [dbo].[SP_KhachHang_Select]    Script Date: 03/07/2018 11:25:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_KhachHang_Select]
AS
    SELECT  ROW_NUMBER() OVER ( ORDER BY ( SELECT   1
                                         ) ) AS STT ,
            MaKH ,
            KiHieu ,
            TenCT ,
            DiaChi ,
            ThanhPho ,
            SoDienThoai ,
            0 AS checked
    FROM    KhachHang
    ORDER BY makh DESC;
GO
/****** Object:  StoredProcedure [dbo].[SP_KhachHang_InsertUpdate]    Script Date: 03/07/2018 11:25:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_KhachHang_InsertUpdate]
@MaKH int, 
@KiHieu NVARCHAR(15), 
@TenCT NVARCHAR(200), 
@DiaChi NVARCHAR(200), 
@ThanhPho NVARCHAR(50), 
@SoDienThoai NVARCHAR(15)
AS
IF EXISTS (SELECT 1 FROM KhachHang WHERE MaKH=@MaKH)
BEGIN
		--update
		UPDATE khachhang
		SET
		kihieu=@kihieu,
		tenct=@tenct,
		diachi=@diachi,
		thanhpho=@thanhpho,
		sodienthoai=@sodienthoai
		WHERE makh=@makh
END
ELSE	
BEGIN
		--insert
		INSERT INTO khachHang( KiHieu, TenCT, DiaChi, ThanhPho, SoDienThoai)
		VALUES( @KiHieu, @TenCT, @DiaChi, @ThanhPho, @SoDienThoai)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_KhachHang_Delete]    Script Date: 03/07/2018 11:25:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[SP_KhachHang_Delete] @MaKh INT
AS
    SET XACT_ABORT ON;
    BEGIN TRAN;
    IF EXISTS ( SELECT  1
                FROM    hoadon
                WHERE   makh = @makh )
        BEGIN
        
            IF EXISTS ( SELECT  1
                        FROM    dbo.ChiTietHoaDon
                        WHERE   Mahd IN ( SELECT    Mahd
                                          FROM      HoaDon
                                          WHERE     makh = @makh ) )
                BEGIN
	    --xoa cthd
                    DELETE  chitiethoadon
                    WHERE   mahd IN ( SELECT    Mahd
                                      FROM      HoaDon
                                      WHERE     makh = @makh );
	    --xoa hoa don
                    DELETE  hoadon
                    WHERE   mahd IN ( SELECT    Mahd
                                      FROM      HoaDon
                                      WHERE     makh = @makh );
	    --xoa khach hang
                    DELETE  khachhang
                    WHERE   makh = @makh;	
                END;
            ELSE
                BEGIN
			 --xoa hoa don
                    DELETE  hoadon
                    WHERE   mahd IN ( SELECT    Mahd
                                      FROM      HoaDon
                                      WHERE     makh = @makh );
	    --xoa khach hang
                    DELETE  khachhang
                    WHERE   makh = @makh;	
                END;
        END; 
    ELSE
        BEGIN
            DELETE  khachhang
            WHERE   makh = @makh;	
        END;
    COMMIT;
GO
