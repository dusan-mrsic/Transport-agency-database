USE [TransportPaketa]
GO

/****** Object:  StoredProcedure [dbo].[spPrihvatiZahtevZaKurira]    Script Date: 22-Jun-21 2:34:50 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spPrihvatiZahtevZaKurira]
	@korisnickoIme varchar(100),
	@retValue int output
AS
BEGIN
	if @korisnickoIme='' begin set @retValue = 0 return end
	if exists (select * from Kurir where KorisnickoIme = @korisnickoIme)
	if not exists (select * from Korisnik where KorisnickoIme=@korisnickoIme)
		begin set @retValue = 0 return end
	if not exists ( select * from ZahtevVozilo where KorisnickoIme=@korisnickoIme)
		begin set @retValue = 0 return end

	declare @registracioniBroj varchar(100)

	set @registracioniBroj = (select RegistracioniBroj from ZahtevVozilo where korisnickoIme=@korisnickoIme)

	insert into Kurir values (@registracioniBroj,@korisnickoIme,0,0,0)

	delete from ZahtevVozilo WHERE KorisnickoIme = @korisnickoIme;

	set @retValue = 1
	
	return


END
GO

