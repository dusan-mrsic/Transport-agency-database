USE [TransportPaketa]
GO

/****** Object:  Trigger [dbo].[TR_TransportOffer]    Script Date: 22-Jun-21 2:35:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[TR_TransportOffer]
   ON  [dbo].[OdobrenaPonuda]
   AFTER INSERT
AS 
BEGIN
	
	declare @kursor cursor

	set @kursor = cursor for
	select Paket from inserted

	open @kursor
	declare @paket int
	fetch next from @kursor
	into @paket

	while @@FETCH_STATUS=0
	begin
		delete from Ponuda where Paket = @paket

		fetch next from @kursor
		into @paket
	end
	close @kursor
	deallocate @kursor
END
GO

ALTER TABLE [dbo].[OdobrenaPonuda] ENABLE TRIGGER [TR_TransportOffer]
GO

