
CREATE TYPE [Varchar100]
	FROM VARCHAR(100) NULL
go

CREATE TYPE [RealNumber]
	FROM DECIMAL(10,3) NULL
go

CREATE TYPE [ID]
	FROM INTEGER NULL
go

CREATE TABLE [Administrator]
( 
	[KorisnickoIme]      [Varchar100]  NOT NULL 
)
go

ALTER TABLE [Administrator]
	ADD CONSTRAINT [XPKAdministrator] PRIMARY KEY  CLUSTERED ([KorisnickoIme] ASC)
go

CREATE TABLE [Grad]
( 
	[ID]                 [ID]  NOT NULL  IDENTITY ,
	[Naziv]              [Varchar100]  NULL ,
	[PostanskiBroj]      [Varchar100]  NULL 
)
go

ALTER TABLE [Grad]
	ADD CONSTRAINT [XPKGrad] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [Korisnik]
( 
	[KorisnickoIme]      [Varchar100]  NOT NULL ,
	[Ime]                [Varchar100]  NOT NULL ,
	[Prezime]            [Varchar100]  NOT NULL ,
	[Sifra]              [Varchar100]  NOT NULL ,
	[BrPoslatihPaketa]   integer  NOT NULL 
)
go

ALTER TABLE [Korisnik]
	ADD CONSTRAINT [XPKKorisnik] PRIMARY KEY  CLUSTERED ([KorisnickoIme] ASC)
go

CREATE TABLE [Kurir]
( 
	[Vozilo]             [Varchar100]  NOT NULL ,
	[KorisnickoIme]      [Varchar100]  NOT NULL ,
	[BrIsporucenihPaketa] integer  NULL ,
	[OstvarenProfit]     [RealNumber]  NULL ,
	[Status]             bit  NOT NULL 
)
go

ALTER TABLE [Kurir]
	ADD CONSTRAINT [XPKKurir] PRIMARY KEY  CLUSTERED ([KorisnickoIme] ASC)
go

CREATE TABLE [OdobrenaPonuda]
( 
	[ID]                 integer  NOT NULL  IDENTITY ,
	[ProcenatCeneIsporuke] [RealNumber] ,
	[Kurir]              [Varchar100] ,
	[Korisnik]           [Varchar100] ,
	[Paket]              [ID] 
)
go

ALTER TABLE [OdobrenaPonuda]
	ADD CONSTRAINT [XPKOdobrenaPonuda] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [Opstina]
( 
	[ID]                 [ID]  NOT NULL  IDENTITY ,
	[Naziv]              [Varchar100]  NOT NULL ,
	[X]                  integer  NOT NULL ,
	[Y]                  integer  NOT NULL ,
	[Grad]               [ID]  NOT NULL 
)
go

ALTER TABLE [Opstina]
	ADD CONSTRAINT [XPKOpstina] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [Paket]
( 
	[ID]                 [ID]  NOT NULL  IDENTITY ,
	[Status]             integer  NOT NULL ,
	[Cena]               [RealNumber]  NULL ,
	[VremePrihvatanja]   datetime  NULL ,
	[Tip]                numeric  NOT NULL ,
	[Tezina]             [RealNumber]  NOT NULL ,
	[Kurir]              [Varchar100] 
)
go

ALTER TABLE [Paket]
	ADD CONSTRAINT [XPKPaket] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [Ponuda]
( 
	[ProcenatCeneIsporuke] [RealNumber]  NOT NULL ,
	[KorisnickoIme]      [Varchar100] ,
	[Korisnik]           [Varchar100] ,
	[Paket]              [ID] ,
	[ID]                 integer  NOT NULL  IDENTITY 
)
go

ALTER TABLE [Ponuda]
	ADD CONSTRAINT [XPKPonuda] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [Sadrzi]
( 
	[Voznja]             [ID]  NOT NULL ,
	[Kilometraza]        [RealNumber] ,
	[Paket]              [ID]  NOT NULL 
)
go

ALTER TABLE [Sadrzi]
	ADD CONSTRAINT [XPKSadrzi] PRIMARY KEY  CLUSTERED ([Voznja] ASC,[Paket] ASC)
go

CREATE TABLE [Vozilo]
( 
	[RegistracioniBroj]  [Varchar100]  NOT NULL ,
	[TipGoriva]          integer  NOT NULL ,
	[Potrosnja]          [RealNumber]  NULL 
)
go

ALTER TABLE [Vozilo]
	ADD CONSTRAINT [XPKVozilo] PRIMARY KEY  CLUSTERED ([RegistracioniBroj] ASC)
go

CREATE TABLE [Voznja]
( 
	[ID]                 [ID]  NOT NULL  IDENTITY ,
	[Kurir]              [Varchar100] ,
	[Opstina]            [ID] 
)
go

ALTER TABLE [Voznja]
	ADD CONSTRAINT [XPKVoznja] PRIMARY KEY  CLUSTERED ([ID] ASC)
go

CREATE TABLE [ZahtevVozilo]
( 
	[KorisnickoIme]      [Varchar100]  NOT NULL ,
	[RegistracioniBroj]  [Varchar100] 
)
go

ALTER TABLE [ZahtevVozilo]
	ADD CONSTRAINT [XPKZahtevVozilo] PRIMARY KEY  CLUSTERED ([KorisnickoIme] ASC)
go

CREATE TABLE [ZahtevZaPrevozom]
( 
	[Korisnik]           [Varchar100]  NOT NULL ,
	[Paket]              [ID]  NOT NULL ,
	[OpstinaOD]          [ID]  NOT NULL ,
	[OpstinaDO]          [ID]  NOT NULL 
)
go

ALTER TABLE [ZahtevZaPrevozom]
	ADD CONSTRAINT [XPKZahtevZaPrevozom] PRIMARY KEY  CLUSTERED ([Korisnik] ASC,[Paket] ASC)
go


ALTER TABLE [Administrator]
	ADD CONSTRAINT [R_5] FOREIGN KEY ([KorisnickoIme]) REFERENCES [Korisnik]([KorisnickoIme])
		ON DELETE CASCADE
		ON UPDATE CASCADE
go


ALTER TABLE [Kurir]
	ADD CONSTRAINT [R_7] FOREIGN KEY ([Vozilo]) REFERENCES [Vozilo]([RegistracioniBroj])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go

ALTER TABLE [Kurir]
	ADD CONSTRAINT [R_8] FOREIGN KEY ([KorisnickoIme]) REFERENCES [Korisnik]([KorisnickoIme])
		ON DELETE CASCADE
		ON UPDATE CASCADE
go


ALTER TABLE [OdobrenaPonuda]
	ADD CONSTRAINT [R_33] FOREIGN KEY ([Kurir]) REFERENCES [Kurir]([KorisnickoIme])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go

ALTER TABLE [OdobrenaPonuda]
	ADD CONSTRAINT [R_34] FOREIGN KEY ([Korisnik],[Paket]) REFERENCES [ZahtevZaPrevozom]([Korisnik],[Paket])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go


ALTER TABLE [Opstina]
	ADD CONSTRAINT [R_2] FOREIGN KEY ([Grad]) REFERENCES [Grad]([ID])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go


ALTER TABLE [Paket]
	ADD CONSTRAINT [R_30] FOREIGN KEY ([Kurir]) REFERENCES [Kurir]([KorisnickoIme])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go


ALTER TABLE [Ponuda]
	ADD CONSTRAINT [R_31] FOREIGN KEY ([KorisnickoIme]) REFERENCES [Kurir]([KorisnickoIme])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go

ALTER TABLE [Ponuda]
	ADD CONSTRAINT [R_32] FOREIGN KEY ([Korisnik],[Paket]) REFERENCES [ZahtevZaPrevozom]([Korisnik],[Paket])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go


ALTER TABLE [Sadrzi]
	ADD CONSTRAINT [R_22] FOREIGN KEY ([Voznja]) REFERENCES [Voznja]([ID])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go

ALTER TABLE [Sadrzi]
	ADD CONSTRAINT [R_43] FOREIGN KEY ([Paket]) REFERENCES [Paket]([ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


ALTER TABLE [Voznja]
	ADD CONSTRAINT [R_36] FOREIGN KEY ([Kurir]) REFERENCES [Kurir]([KorisnickoIme])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go

ALTER TABLE [Voznja]
	ADD CONSTRAINT [R_42] FOREIGN KEY ([Opstina]) REFERENCES [Opstina]([ID])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go


ALTER TABLE [ZahtevVozilo]
	ADD CONSTRAINT [R_27] FOREIGN KEY ([KorisnickoIme]) REFERENCES [Korisnik]([KorisnickoIme])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go

ALTER TABLE [ZahtevVozilo]
	ADD CONSTRAINT [R_29] FOREIGN KEY ([RegistracioniBroj]) REFERENCES [Vozilo]([RegistracioniBroj])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go


ALTER TABLE [ZahtevZaPrevozom]
	ADD CONSTRAINT [R_9] FOREIGN KEY ([Korisnik]) REFERENCES [Korisnik]([KorisnickoIme])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [ZahtevZaPrevozom]
	ADD CONSTRAINT [R_10] FOREIGN KEY ([Paket]) REFERENCES [Paket]([ID])
		ON DELETE NO ACTION
		ON UPDATE CASCADE
go

ALTER TABLE [ZahtevZaPrevozom]
	ADD CONSTRAINT [R_11] FOREIGN KEY ([OpstinaOD]) REFERENCES [Opstina]([ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go

ALTER TABLE [ZahtevZaPrevozom]
	ADD CONSTRAINT [R_13] FOREIGN KEY ([OpstinaDO]) REFERENCES [Opstina]([ID])
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
go


CREATE TRIGGER tD_Administrator ON Administrator FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Administrator */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Korisnik  Administrator on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00016626", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="Administrator"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="KorisnickoIme" */
    IF EXISTS (SELECT * FROM deleted,Korisnik
      WHERE
        /* %JoinFKPK(deleted,Korisnik," = "," AND") */
        deleted.KorisnickoIme = Korisnik.KorisnickoIme AND
        NOT EXISTS (
          SELECT * FROM Administrator
          WHERE
            /* %JoinFKPK(Administrator,Korisnik," = "," AND") */
            Administrator.KorisnickoIme = Korisnik.KorisnickoIme
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Administrator because Korisnik exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Administrator ON Administrator FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Administrator */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insKorisnickoIme Varchar100,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Korisnik  Administrator on child update no action */
  /* ERWIN_RELATION:CHECKSUM="000176a6", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="Administrator"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="KorisnickoIme" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(KorisnickoIme)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Korisnik
        WHERE
          /* %JoinFKPK(inserted,Korisnik) */
          inserted.KorisnickoIme = Korisnik.KorisnickoIme
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Administrator because Korisnik does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Grad ON Grad FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Grad */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Grad  Opstina on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="000101e6", PARENT_OWNER="", PARENT_TABLE="Grad"
    CHILD_OWNER="", CHILD_TABLE="Opstina"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="Grad" */
    IF EXISTS (
      SELECT * FROM deleted,Opstina
      WHERE
        /*  %JoinFKPK(Opstina,deleted," = "," AND") */
        Opstina.Grad = deleted.ID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Grad because Opstina exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Grad ON Grad FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Grad */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insID ID,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Grad  Opstina on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00015761", PARENT_OWNER="", PARENT_TABLE="Grad"
    CHILD_OWNER="", CHILD_TABLE="Opstina"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="Grad" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ID)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insID = inserted.ID
        FROM inserted
      UPDATE Opstina
      SET
        /*  %JoinFKPK(Opstina,@ins," = ",",") */
        Opstina.Grad = @insID
      FROM Opstina,inserted,deleted
      WHERE
        /*  %JoinFKPK(Opstina,deleted," = "," AND") */
        Opstina.Grad = deleted.ID
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Grad update because more than one row has been affected.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Korisnik ON Korisnik FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Korisnik */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Korisnik  ZahtevVozilo on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0003a9b9", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="ZahtevVozilo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="KorisnickoIme" */
    IF EXISTS (
      SELECT * FROM deleted,ZahtevVozilo
      WHERE
        /*  %JoinFKPK(ZahtevVozilo,deleted," = "," AND") */
        ZahtevVozilo.KorisnickoIme = deleted.KorisnickoIme
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Korisnik because ZahtevVozilo exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Korisnik  ZahtevZaPrevozom on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="Korisnik" */
    IF EXISTS (
      SELECT * FROM deleted,ZahtevZaPrevozom
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevozom,deleted," = "," AND") */
        ZahtevZaPrevozom.Korisnik = deleted.KorisnickoIme
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Korisnik because ZahtevZaPrevozom exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Korisnik  Kurir on parent delete cascade */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="Kurir"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="KorisnickoIme" */
    DELETE Kurir
      FROM Kurir,deleted
      WHERE
        /*  %JoinFKPK(Kurir,deleted," = "," AND") */
        Kurir.KorisnickoIme = deleted.KorisnickoIme

    /* erwin Builtin Trigger */
    /* Korisnik  Administrator on parent delete cascade */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="Administrator"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="KorisnickoIme" */
    DELETE Administrator
      FROM Administrator,deleted
      WHERE
        /*  %JoinFKPK(Administrator,deleted," = "," AND") */
        Administrator.KorisnickoIme = deleted.KorisnickoIme


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Korisnik ON Korisnik FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Korisnik */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insKorisnickoIme Varchar100,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Korisnik  ZahtevVozilo on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="0005714a", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="ZahtevVozilo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="KorisnickoIme" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(KorisnickoIme)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insKorisnickoIme = inserted.KorisnickoIme
        FROM inserted
      UPDATE ZahtevVozilo
      SET
        /*  %JoinFKPK(ZahtevVozilo,@ins," = ",",") */
        ZahtevVozilo.KorisnickoIme = @insKorisnickoIme
      FROM ZahtevVozilo,inserted,deleted
      WHERE
        /*  %JoinFKPK(ZahtevVozilo,deleted," = "," AND") */
        ZahtevVozilo.KorisnickoIme = deleted.KorisnickoIme
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Korisnik update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Korisnik  ZahtevZaPrevozom on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="Korisnik" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(KorisnickoIme)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ZahtevZaPrevozom
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevozom,deleted," = "," AND") */
        ZahtevZaPrevozom.Korisnik = deleted.KorisnickoIme
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Korisnik because ZahtevZaPrevozom exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Korisnik  Kurir on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="Kurir"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="KorisnickoIme" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(KorisnickoIme)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insKorisnickoIme = inserted.KorisnickoIme
        FROM inserted
      UPDATE Kurir
      SET
        /*  %JoinFKPK(Kurir,@ins," = ",",") */
        Kurir.KorisnickoIme = @insKorisnickoIme
      FROM Kurir,inserted,deleted
      WHERE
        /*  %JoinFKPK(Kurir,deleted," = "," AND") */
        Kurir.KorisnickoIme = deleted.KorisnickoIme
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Korisnik update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Korisnik  Administrator on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="Administrator"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_5", FK_COLUMNS="KorisnickoIme" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(KorisnickoIme)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insKorisnickoIme = inserted.KorisnickoIme
        FROM inserted
      UPDATE Administrator
      SET
        /*  %JoinFKPK(Administrator,@ins," = ",",") */
        Administrator.KorisnickoIme = @insKorisnickoIme
      FROM Administrator,inserted,deleted
      WHERE
        /*  %JoinFKPK(Administrator,deleted," = "," AND") */
        Administrator.KorisnickoIme = deleted.KorisnickoIme
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Korisnik update because more than one row has been affected.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Kurir ON Kurir FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Kurir */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Kurir  Voznja on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0005ec0d", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="Voznja"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_36", FK_COLUMNS="Kurir" */
    IF EXISTS (
      SELECT * FROM deleted,Voznja
      WHERE
        /*  %JoinFKPK(Voznja,deleted," = "," AND") */
        Voznja.Kurir = deleted.KorisnickoIme
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Kurir because Voznja exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Kurir  OdobrenaPonuda on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="OdobrenaPonuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_33", FK_COLUMNS="Kurir" */
    IF EXISTS (
      SELECT * FROM deleted,OdobrenaPonuda
      WHERE
        /*  %JoinFKPK(OdobrenaPonuda,deleted," = "," AND") */
        OdobrenaPonuda.Kurir = deleted.KorisnickoIme
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Kurir because OdobrenaPonuda exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Kurir  Ponuda on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="Ponuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_31", FK_COLUMNS="KorisnickoIme" */
    IF EXISTS (
      SELECT * FROM deleted,Ponuda
      WHERE
        /*  %JoinFKPK(Ponuda,deleted," = "," AND") */
        Ponuda.KorisnickoIme = deleted.KorisnickoIme
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Kurir because Ponuda exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Kurir  Paket on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="Paket"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_30", FK_COLUMNS="Kurir" */
    IF EXISTS (
      SELECT * FROM deleted,Paket
      WHERE
        /*  %JoinFKPK(Paket,deleted," = "," AND") */
        Paket.Kurir = deleted.KorisnickoIme
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Kurir because Paket exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Korisnik  Kurir on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="Kurir"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="KorisnickoIme" */
    IF EXISTS (SELECT * FROM deleted,Korisnik
      WHERE
        /* %JoinFKPK(deleted,Korisnik," = "," AND") */
        deleted.KorisnickoIme = Korisnik.KorisnickoIme AND
        NOT EXISTS (
          SELECT * FROM Kurir
          WHERE
            /* %JoinFKPK(Kurir,Korisnik," = "," AND") */
            Kurir.KorisnickoIme = Korisnik.KorisnickoIme
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Kurir because Korisnik exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Vozilo  Kurir on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Vozilo"
    CHILD_OWNER="", CHILD_TABLE="Kurir"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="Vozilo" */
    IF EXISTS (SELECT * FROM deleted,Vozilo
      WHERE
        /* %JoinFKPK(deleted,Vozilo," = "," AND") */
        deleted.Vozilo = Vozilo.RegistracioniBroj AND
        NOT EXISTS (
          SELECT * FROM Kurir
          WHERE
            /* %JoinFKPK(Kurir,Vozilo," = "," AND") */
            Kurir.Vozilo = Vozilo.RegistracioniBroj
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Kurir because Vozilo exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Kurir ON Kurir FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Kurir */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insKorisnickoIme Varchar100,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Kurir  Voznja on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="0008203b", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="Voznja"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_36", FK_COLUMNS="Kurir" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(KorisnickoIme)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insKorisnickoIme = inserted.KorisnickoIme
        FROM inserted
      UPDATE Voznja
      SET
        /*  %JoinFKPK(Voznja,@ins," = ",",") */
        Voznja.Kurir = @insKorisnickoIme
      FROM Voznja,inserted,deleted
      WHERE
        /*  %JoinFKPK(Voznja,deleted," = "," AND") */
        Voznja.Kurir = deleted.KorisnickoIme
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Kurir update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Kurir  OdobrenaPonuda on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="OdobrenaPonuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_33", FK_COLUMNS="Kurir" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(KorisnickoIme)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insKorisnickoIme = inserted.KorisnickoIme
        FROM inserted
      UPDATE OdobrenaPonuda
      SET
        /*  %JoinFKPK(OdobrenaPonuda,@ins," = ",",") */
        OdobrenaPonuda.Kurir = @insKorisnickoIme
      FROM OdobrenaPonuda,inserted,deleted
      WHERE
        /*  %JoinFKPK(OdobrenaPonuda,deleted," = "," AND") */
        OdobrenaPonuda.Kurir = deleted.KorisnickoIme
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Kurir update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Kurir  Ponuda on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="Ponuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_31", FK_COLUMNS="KorisnickoIme" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(KorisnickoIme)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insKorisnickoIme = inserted.KorisnickoIme
        FROM inserted
      UPDATE Ponuda
      SET
        /*  %JoinFKPK(Ponuda,@ins," = ",",") */
        Ponuda.KorisnickoIme = @insKorisnickoIme
      FROM Ponuda,inserted,deleted
      WHERE
        /*  %JoinFKPK(Ponuda,deleted," = "," AND") */
        Ponuda.KorisnickoIme = deleted.KorisnickoIme
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Kurir update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Kurir  Paket on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="Paket"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_30", FK_COLUMNS="Kurir" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(KorisnickoIme)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insKorisnickoIme = inserted.KorisnickoIme
        FROM inserted
      UPDATE Paket
      SET
        /*  %JoinFKPK(Paket,@ins," = ",",") */
        Paket.Kurir = @insKorisnickoIme
      FROM Paket,inserted,deleted
      WHERE
        /*  %JoinFKPK(Paket,deleted," = "," AND") */
        Paket.Kurir = deleted.KorisnickoIme
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Kurir update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Korisnik  Kurir on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="Kurir"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_8", FK_COLUMNS="KorisnickoIme" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(KorisnickoIme)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Korisnik
        WHERE
          /* %JoinFKPK(inserted,Korisnik) */
          inserted.KorisnickoIme = Korisnik.KorisnickoIme
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Kurir because Korisnik does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Vozilo  Kurir on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Vozilo"
    CHILD_OWNER="", CHILD_TABLE="Kurir"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="Vozilo" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Vozilo)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Vozilo
        WHERE
          /* %JoinFKPK(inserted,Vozilo) */
          inserted.Vozilo = Vozilo.RegistracioniBroj
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Kurir because Vozilo does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_OdobrenaPonuda ON OdobrenaPonuda FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on OdobrenaPonuda */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* ZahtevZaPrevozom  OdobrenaPonuda on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002ca6a", PARENT_OWNER="", PARENT_TABLE="ZahtevZaPrevozom"
    CHILD_OWNER="", CHILD_TABLE="OdobrenaPonuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_34", FK_COLUMNS="Korisnik""Paket" */
    IF EXISTS (SELECT * FROM deleted,ZahtevZaPrevozom
      WHERE
        /* %JoinFKPK(deleted,ZahtevZaPrevozom," = "," AND") */
        deleted.Korisnik = ZahtevZaPrevozom.Korisnik AND
        deleted.Paket = ZahtevZaPrevozom.Paket AND
        NOT EXISTS (
          SELECT * FROM OdobrenaPonuda
          WHERE
            /* %JoinFKPK(OdobrenaPonuda,ZahtevZaPrevozom," = "," AND") */
            OdobrenaPonuda.Korisnik = ZahtevZaPrevozom.Korisnik AND
            OdobrenaPonuda.Paket = ZahtevZaPrevozom.Paket
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last OdobrenaPonuda because ZahtevZaPrevozom exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Kurir  OdobrenaPonuda on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="OdobrenaPonuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_33", FK_COLUMNS="Kurir" */
    IF EXISTS (SELECT * FROM deleted,Kurir
      WHERE
        /* %JoinFKPK(deleted,Kurir," = "," AND") */
        deleted.Kurir = Kurir.KorisnickoIme AND
        NOT EXISTS (
          SELECT * FROM OdobrenaPonuda
          WHERE
            /* %JoinFKPK(OdobrenaPonuda,Kurir," = "," AND") */
            OdobrenaPonuda.Kurir = Kurir.KorisnickoIme
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last OdobrenaPonuda because Kurir exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_OdobrenaPonuda ON OdobrenaPonuda FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on OdobrenaPonuda */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insID integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* ZahtevZaPrevozom  OdobrenaPonuda on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0003273b", PARENT_OWNER="", PARENT_TABLE="ZahtevZaPrevozom"
    CHILD_OWNER="", CHILD_TABLE="OdobrenaPonuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_34", FK_COLUMNS="Korisnik""Paket" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Korisnik) OR
    UPDATE(Paket)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,ZahtevZaPrevozom
        WHERE
          /* %JoinFKPK(inserted,ZahtevZaPrevozom) */
          inserted.Korisnik = ZahtevZaPrevozom.Korisnik and
          inserted.Paket = ZahtevZaPrevozom.Paket
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.Korisnik IS NULL AND
      inserted.Paket IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update OdobrenaPonuda because ZahtevZaPrevozom does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Kurir  OdobrenaPonuda on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="OdobrenaPonuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_33", FK_COLUMNS="Kurir" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Kurir)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Kurir
        WHERE
          /* %JoinFKPK(inserted,Kurir) */
          inserted.Kurir = Kurir.KorisnickoIme
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.Kurir IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update OdobrenaPonuda because Kurir does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Opstina ON Opstina FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Opstina */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Opstina  Voznja on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0003f75b", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="Voznja"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_42", FK_COLUMNS="Opstina" */
    IF EXISTS (
      SELECT * FROM deleted,Voznja
      WHERE
        /*  %JoinFKPK(Voznja,deleted," = "," AND") */
        Voznja.Opstina = deleted.ID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Opstina because Voznja exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Opstina  ZahtevZaPrevozom on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="OpstinaDO" */
    IF EXISTS (
      SELECT * FROM deleted,ZahtevZaPrevozom
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevozom,deleted," = "," AND") */
        ZahtevZaPrevozom.OpstinaDO = deleted.ID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Opstina because ZahtevZaPrevozom exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Opstina  ZahtevZaPrevozom on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="OpstinaOD" */
    IF EXISTS (
      SELECT * FROM deleted,ZahtevZaPrevozom
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevozom,deleted," = "," AND") */
        ZahtevZaPrevozom.OpstinaOD = deleted.ID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Opstina because ZahtevZaPrevozom exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Grad  Opstina on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Grad"
    CHILD_OWNER="", CHILD_TABLE="Opstina"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="Grad" */
    IF EXISTS (SELECT * FROM deleted,Grad
      WHERE
        /* %JoinFKPK(deleted,Grad," = "," AND") */
        deleted.Grad = Grad.ID AND
        NOT EXISTS (
          SELECT * FROM Opstina
          WHERE
            /* %JoinFKPK(Opstina,Grad," = "," AND") */
            Opstina.Grad = Grad.ID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Opstina because Grad exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Opstina ON Opstina FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Opstina */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insID ID,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Opstina  Voznja on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="0004ad72", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="Voznja"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_42", FK_COLUMNS="Opstina" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ID)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insID = inserted.ID
        FROM inserted
      UPDATE Voznja
      SET
        /*  %JoinFKPK(Voznja,@ins," = ",",") */
        Voznja.Opstina = @insID
      FROM Voznja,inserted,deleted
      WHERE
        /*  %JoinFKPK(Voznja,deleted," = "," AND") */
        Voznja.Opstina = deleted.ID
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Opstina update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Opstina  ZahtevZaPrevozom on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="OpstinaDO" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ZahtevZaPrevozom
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevozom,deleted," = "," AND") */
        ZahtevZaPrevozom.OpstinaDO = deleted.ID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Opstina because ZahtevZaPrevozom exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Opstina  ZahtevZaPrevozom on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="OpstinaOD" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,ZahtevZaPrevozom
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevozom,deleted," = "," AND") */
        ZahtevZaPrevozom.OpstinaOD = deleted.ID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Opstina because ZahtevZaPrevozom exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Grad  Opstina on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Grad"
    CHILD_OWNER="", CHILD_TABLE="Opstina"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_2", FK_COLUMNS="Grad" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Grad)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Grad
        WHERE
          /* %JoinFKPK(inserted,Grad) */
          inserted.Grad = Grad.ID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Opstina because Grad does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Paket ON Paket FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Paket */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Paket  Sadrzi on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00030237", PARENT_OWNER="", PARENT_TABLE="Paket"
    CHILD_OWNER="", CHILD_TABLE="Sadrzi"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_43", FK_COLUMNS="Paket" */
    IF EXISTS (
      SELECT * FROM deleted,Sadrzi
      WHERE
        /*  %JoinFKPK(Sadrzi,deleted," = "," AND") */
        Sadrzi.Paket = deleted.ID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Paket because Sadrzi exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Paket  ZahtevZaPrevozom on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Paket"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="Paket" */
    IF EXISTS (
      SELECT * FROM deleted,ZahtevZaPrevozom
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevozom,deleted," = "," AND") */
        ZahtevZaPrevozom.Paket = deleted.ID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Paket because ZahtevZaPrevozom exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Kurir  Paket on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="Paket"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_30", FK_COLUMNS="Kurir" */
    IF EXISTS (SELECT * FROM deleted,Kurir
      WHERE
        /* %JoinFKPK(deleted,Kurir," = "," AND") */
        deleted.Kurir = Kurir.KorisnickoIme AND
        NOT EXISTS (
          SELECT * FROM Paket
          WHERE
            /* %JoinFKPK(Paket,Kurir," = "," AND") */
            Paket.Kurir = Kurir.KorisnickoIme
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Paket because Kurir exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Paket ON Paket FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Paket */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insID ID,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Paket  Sadrzi on parent update no action */
  /* ERWIN_RELATION:CHECKSUM="0003b5f1", PARENT_OWNER="", PARENT_TABLE="Paket"
    CHILD_OWNER="", CHILD_TABLE="Sadrzi"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_43", FK_COLUMNS="Paket" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ID)
  BEGIN
    IF EXISTS (
      SELECT * FROM deleted,Sadrzi
      WHERE
        /*  %JoinFKPK(Sadrzi,deleted," = "," AND") */
        Sadrzi.Paket = deleted.ID
    )
    BEGIN
      SELECT @errno  = 30005,
             @errmsg = 'Cannot update Paket because Sadrzi exists.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Paket  ZahtevZaPrevozom on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Paket"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="Paket" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ID)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insID = inserted.ID
        FROM inserted
      UPDATE ZahtevZaPrevozom
      SET
        /*  %JoinFKPK(ZahtevZaPrevozom,@ins," = ",",") */
        ZahtevZaPrevozom.Paket = @insID
      FROM ZahtevZaPrevozom,inserted,deleted
      WHERE
        /*  %JoinFKPK(ZahtevZaPrevozom,deleted," = "," AND") */
        ZahtevZaPrevozom.Paket = deleted.ID
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Paket update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Kurir  Paket on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="Paket"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_30", FK_COLUMNS="Kurir" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Kurir)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Kurir
        WHERE
          /* %JoinFKPK(inserted,Kurir) */
          inserted.Kurir = Kurir.KorisnickoIme
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.Kurir IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Paket because Kurir does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Ponuda ON Ponuda FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Ponuda */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* ZahtevZaPrevozom  Ponuda on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002a575", PARENT_OWNER="", PARENT_TABLE="ZahtevZaPrevozom"
    CHILD_OWNER="", CHILD_TABLE="Ponuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_32", FK_COLUMNS="Korisnik""Paket" */
    IF EXISTS (SELECT * FROM deleted,ZahtevZaPrevozom
      WHERE
        /* %JoinFKPK(deleted,ZahtevZaPrevozom," = "," AND") */
        deleted.Korisnik = ZahtevZaPrevozom.Korisnik AND
        deleted.Paket = ZahtevZaPrevozom.Paket AND
        NOT EXISTS (
          SELECT * FROM Ponuda
          WHERE
            /* %JoinFKPK(Ponuda,ZahtevZaPrevozom," = "," AND") */
            Ponuda.Korisnik = ZahtevZaPrevozom.Korisnik AND
            Ponuda.Paket = ZahtevZaPrevozom.Paket
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Ponuda because ZahtevZaPrevozom exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Kurir  Ponuda on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="Ponuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_31", FK_COLUMNS="KorisnickoIme" */
    IF EXISTS (SELECT * FROM deleted,Kurir
      WHERE
        /* %JoinFKPK(deleted,Kurir," = "," AND") */
        deleted.KorisnickoIme = Kurir.KorisnickoIme AND
        NOT EXISTS (
          SELECT * FROM Ponuda
          WHERE
            /* %JoinFKPK(Ponuda,Kurir," = "," AND") */
            Ponuda.KorisnickoIme = Kurir.KorisnickoIme
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Ponuda because Kurir exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Ponuda ON Ponuda FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Ponuda */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insID integer,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* ZahtevZaPrevozom  Ponuda on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00031f1c", PARENT_OWNER="", PARENT_TABLE="ZahtevZaPrevozom"
    CHILD_OWNER="", CHILD_TABLE="Ponuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_32", FK_COLUMNS="Korisnik""Paket" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Korisnik) OR
    UPDATE(Paket)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,ZahtevZaPrevozom
        WHERE
          /* %JoinFKPK(inserted,ZahtevZaPrevozom) */
          inserted.Korisnik = ZahtevZaPrevozom.Korisnik and
          inserted.Paket = ZahtevZaPrevozom.Paket
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.Korisnik IS NULL AND
      inserted.Paket IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Ponuda because ZahtevZaPrevozom does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Kurir  Ponuda on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="Ponuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_31", FK_COLUMNS="KorisnickoIme" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(KorisnickoIme)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Kurir
        WHERE
          /* %JoinFKPK(inserted,Kurir) */
          inserted.KorisnickoIme = Kurir.KorisnickoIme
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.KorisnickoIme IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Ponuda because Kurir does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Sadrzi ON Sadrzi FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Sadrzi */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Paket  Sadrzi on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00023a22", PARENT_OWNER="", PARENT_TABLE="Paket"
    CHILD_OWNER="", CHILD_TABLE="Sadrzi"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_43", FK_COLUMNS="Paket" */
    IF EXISTS (SELECT * FROM deleted,Paket
      WHERE
        /* %JoinFKPK(deleted,Paket," = "," AND") */
        deleted.Paket = Paket.ID AND
        NOT EXISTS (
          SELECT * FROM Sadrzi
          WHERE
            /* %JoinFKPK(Sadrzi,Paket," = "," AND") */
            Sadrzi.Paket = Paket.ID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Sadrzi because Paket exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Voznja  Sadrzi on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Voznja"
    CHILD_OWNER="", CHILD_TABLE="Sadrzi"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="Voznja" */
    IF EXISTS (SELECT * FROM deleted,Voznja
      WHERE
        /* %JoinFKPK(deleted,Voznja," = "," AND") */
        deleted.Voznja = Voznja.ID AND
        NOT EXISTS (
          SELECT * FROM Sadrzi
          WHERE
            /* %JoinFKPK(Sadrzi,Voznja," = "," AND") */
            Sadrzi.Voznja = Voznja.ID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Sadrzi because Voznja exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Sadrzi ON Sadrzi FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Sadrzi */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insVoznja ID, 
           @insPaket ID,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Paket  Sadrzi on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00027a89", PARENT_OWNER="", PARENT_TABLE="Paket"
    CHILD_OWNER="", CHILD_TABLE="Sadrzi"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_43", FK_COLUMNS="Paket" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Paket)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Paket
        WHERE
          /* %JoinFKPK(inserted,Paket) */
          inserted.Paket = Paket.ID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Sadrzi because Paket does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Voznja  Sadrzi on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Voznja"
    CHILD_OWNER="", CHILD_TABLE="Sadrzi"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="Voznja" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Voznja)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Voznja
        WHERE
          /* %JoinFKPK(inserted,Voznja) */
          inserted.Voznja = Voznja.ID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Sadrzi because Voznja does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Vozilo ON Vozilo FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Vozilo */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Vozilo  ZahtevVozilo on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0001f8fe", PARENT_OWNER="", PARENT_TABLE="Vozilo"
    CHILD_OWNER="", CHILD_TABLE="ZahtevVozilo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_29", FK_COLUMNS="RegistracioniBroj" */
    IF EXISTS (
      SELECT * FROM deleted,ZahtevVozilo
      WHERE
        /*  %JoinFKPK(ZahtevVozilo,deleted," = "," AND") */
        ZahtevVozilo.RegistracioniBroj = deleted.RegistracioniBroj
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Vozilo because ZahtevVozilo exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Vozilo  Kurir on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Vozilo"
    CHILD_OWNER="", CHILD_TABLE="Kurir"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="Vozilo" */
    IF EXISTS (
      SELECT * FROM deleted,Kurir
      WHERE
        /*  %JoinFKPK(Kurir,deleted," = "," AND") */
        Kurir.Vozilo = deleted.RegistracioniBroj
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Vozilo because Kurir exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Vozilo ON Vozilo FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Vozilo */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insRegistracioniBroj Varchar100,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Vozilo  ZahtevVozilo on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="000310cd", PARENT_OWNER="", PARENT_TABLE="Vozilo"
    CHILD_OWNER="", CHILD_TABLE="ZahtevVozilo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_29", FK_COLUMNS="RegistracioniBroj" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(RegistracioniBroj)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insRegistracioniBroj = inserted.RegistracioniBroj
        FROM inserted
      UPDATE ZahtevVozilo
      SET
        /*  %JoinFKPK(ZahtevVozilo,@ins," = ",",") */
        ZahtevVozilo.RegistracioniBroj = @insRegistracioniBroj
      FROM ZahtevVozilo,inserted,deleted
      WHERE
        /*  %JoinFKPK(ZahtevVozilo,deleted," = "," AND") */
        ZahtevVozilo.RegistracioniBroj = deleted.RegistracioniBroj
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Vozilo update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Vozilo  Kurir on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Vozilo"
    CHILD_OWNER="", CHILD_TABLE="Kurir"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_7", FK_COLUMNS="Vozilo" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(RegistracioniBroj)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insRegistracioniBroj = inserted.RegistracioniBroj
        FROM inserted
      UPDATE Kurir
      SET
        /*  %JoinFKPK(Kurir,@ins," = ",",") */
        Kurir.Vozilo = @insRegistracioniBroj
      FROM Kurir,inserted,deleted
      WHERE
        /*  %JoinFKPK(Kurir,deleted," = "," AND") */
        Kurir.Vozilo = deleted.RegistracioniBroj
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Vozilo update because more than one row has been affected.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_Voznja ON Voznja FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on Voznja */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Voznja  Sadrzi on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00032a01", PARENT_OWNER="", PARENT_TABLE="Voznja"
    CHILD_OWNER="", CHILD_TABLE="Sadrzi"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="Voznja" */
    IF EXISTS (
      SELECT * FROM deleted,Sadrzi
      WHERE
        /*  %JoinFKPK(Sadrzi,deleted," = "," AND") */
        Sadrzi.Voznja = deleted.ID
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete Voznja because Sadrzi exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Opstina  Voznja on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="Voznja"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_42", FK_COLUMNS="Opstina" */
    IF EXISTS (SELECT * FROM deleted,Opstina
      WHERE
        /* %JoinFKPK(deleted,Opstina," = "," AND") */
        deleted.Opstina = Opstina.ID AND
        NOT EXISTS (
          SELECT * FROM Voznja
          WHERE
            /* %JoinFKPK(Voznja,Opstina," = "," AND") */
            Voznja.Opstina = Opstina.ID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Voznja because Opstina exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Kurir  Voznja on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="Voznja"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_36", FK_COLUMNS="Kurir" */
    IF EXISTS (SELECT * FROM deleted,Kurir
      WHERE
        /* %JoinFKPK(deleted,Kurir," = "," AND") */
        deleted.Kurir = Kurir.KorisnickoIme AND
        NOT EXISTS (
          SELECT * FROM Voznja
          WHERE
            /* %JoinFKPK(Voznja,Kurir," = "," AND") */
            Voznja.Kurir = Kurir.KorisnickoIme
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last Voznja because Kurir exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_Voznja ON Voznja FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on Voznja */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insID ID,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Voznja  Sadrzi on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="0003fb5b", PARENT_OWNER="", PARENT_TABLE="Voznja"
    CHILD_OWNER="", CHILD_TABLE="Sadrzi"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_22", FK_COLUMNS="Voznja" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(ID)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insID = inserted.ID
        FROM inserted
      UPDATE Sadrzi
      SET
        /*  %JoinFKPK(Sadrzi,@ins," = ",",") */
        Sadrzi.Voznja = @insID
      FROM Sadrzi,inserted,deleted
      WHERE
        /*  %JoinFKPK(Sadrzi,deleted," = "," AND") */
        Sadrzi.Voznja = deleted.ID
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade Voznja update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Opstina  Voznja on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="Voznja"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_42", FK_COLUMNS="Opstina" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Opstina)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Opstina
        WHERE
          /* %JoinFKPK(inserted,Opstina) */
          inserted.Opstina = Opstina.ID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.Opstina IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Voznja because Opstina does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Kurir  Voznja on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Kurir"
    CHILD_OWNER="", CHILD_TABLE="Voznja"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_36", FK_COLUMNS="Kurir" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Kurir)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Kurir
        WHERE
          /* %JoinFKPK(inserted,Kurir) */
          inserted.Kurir = Kurir.KorisnickoIme
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.Kurir IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update Voznja because Kurir does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_ZahtevVozilo ON ZahtevVozilo FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on ZahtevVozilo */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* Vozilo  ZahtevVozilo on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="0002a01e", PARENT_OWNER="", PARENT_TABLE="Vozilo"
    CHILD_OWNER="", CHILD_TABLE="ZahtevVozilo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_29", FK_COLUMNS="RegistracioniBroj" */
    IF EXISTS (SELECT * FROM deleted,Vozilo
      WHERE
        /* %JoinFKPK(deleted,Vozilo," = "," AND") */
        deleted.RegistracioniBroj = Vozilo.RegistracioniBroj AND
        NOT EXISTS (
          SELECT * FROM ZahtevVozilo
          WHERE
            /* %JoinFKPK(ZahtevVozilo,Vozilo," = "," AND") */
            ZahtevVozilo.RegistracioniBroj = Vozilo.RegistracioniBroj
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ZahtevVozilo because Vozilo exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Korisnik  ZahtevVozilo on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="ZahtevVozilo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="KorisnickoIme" */
    IF EXISTS (SELECT * FROM deleted,Korisnik
      WHERE
        /* %JoinFKPK(deleted,Korisnik," = "," AND") */
        deleted.KorisnickoIme = Korisnik.KorisnickoIme AND
        NOT EXISTS (
          SELECT * FROM ZahtevVozilo
          WHERE
            /* %JoinFKPK(ZahtevVozilo,Korisnik," = "," AND") */
            ZahtevVozilo.KorisnickoIme = Korisnik.KorisnickoIme
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ZahtevVozilo because Korisnik exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_ZahtevVozilo ON ZahtevVozilo FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on ZahtevVozilo */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insKorisnickoIme Varchar100,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* Vozilo  ZahtevVozilo on child update no action */
  /* ERWIN_RELATION:CHECKSUM="0002e44f", PARENT_OWNER="", PARENT_TABLE="Vozilo"
    CHILD_OWNER="", CHILD_TABLE="ZahtevVozilo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_29", FK_COLUMNS="RegistracioniBroj" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(RegistracioniBroj)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Vozilo
        WHERE
          /* %JoinFKPK(inserted,Vozilo) */
          inserted.RegistracioniBroj = Vozilo.RegistracioniBroj
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    select @nullcnt = count(*) from inserted where
      inserted.RegistracioniBroj IS NULL
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ZahtevVozilo because Vozilo does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Korisnik  ZahtevVozilo on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="ZahtevVozilo"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_27", FK_COLUMNS="KorisnickoIme" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(KorisnickoIme)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Korisnik
        WHERE
          /* %JoinFKPK(inserted,Korisnik) */
          inserted.KorisnickoIme = Korisnik.KorisnickoIme
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ZahtevVozilo because Korisnik does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go




CREATE TRIGGER tD_ZahtevZaPrevozom ON ZahtevZaPrevozom FOR DELETE AS
/* erwin Builtin Trigger */
/* DELETE trigger on ZahtevZaPrevozom */
BEGIN
  DECLARE  @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)
    /* erwin Builtin Trigger */
    /* ZahtevZaPrevozom  OdobrenaPonuda on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="0006fd52", PARENT_OWNER="", PARENT_TABLE="ZahtevZaPrevozom"
    CHILD_OWNER="", CHILD_TABLE="OdobrenaPonuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_34", FK_COLUMNS="Korisnik""Paket" */
    IF EXISTS (
      SELECT * FROM deleted,OdobrenaPonuda
      WHERE
        /*  %JoinFKPK(OdobrenaPonuda,deleted," = "," AND") */
        OdobrenaPonuda.Korisnik = deleted.Korisnik AND
        OdobrenaPonuda.Paket = deleted.Paket
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete ZahtevZaPrevozom because OdobrenaPonuda exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* ZahtevZaPrevozom  Ponuda on parent delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ZahtevZaPrevozom"
    CHILD_OWNER="", CHILD_TABLE="Ponuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_32", FK_COLUMNS="Korisnik""Paket" */
    IF EXISTS (
      SELECT * FROM deleted,Ponuda
      WHERE
        /*  %JoinFKPK(Ponuda,deleted," = "," AND") */
        Ponuda.Korisnik = deleted.Korisnik AND
        Ponuda.Paket = deleted.Paket
    )
    BEGIN
      SELECT @errno  = 30001,
             @errmsg = 'Cannot delete ZahtevZaPrevozom because Ponuda exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Opstina  ZahtevZaPrevozom on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="OpstinaDO" */
    IF EXISTS (SELECT * FROM deleted,Opstina
      WHERE
        /* %JoinFKPK(deleted,Opstina," = "," AND") */
        deleted.OpstinaDO = Opstina.ID AND
        NOT EXISTS (
          SELECT * FROM ZahtevZaPrevozom
          WHERE
            /* %JoinFKPK(ZahtevZaPrevozom,Opstina," = "," AND") */
            ZahtevZaPrevozom.OpstinaDO = Opstina.ID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ZahtevZaPrevozom because Opstina exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Opstina  ZahtevZaPrevozom on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="OpstinaOD" */
    IF EXISTS (SELECT * FROM deleted,Opstina
      WHERE
        /* %JoinFKPK(deleted,Opstina," = "," AND") */
        deleted.OpstinaOD = Opstina.ID AND
        NOT EXISTS (
          SELECT * FROM ZahtevZaPrevozom
          WHERE
            /* %JoinFKPK(ZahtevZaPrevozom,Opstina," = "," AND") */
            ZahtevZaPrevozom.OpstinaOD = Opstina.ID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ZahtevZaPrevozom because Opstina exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Paket  ZahtevZaPrevozom on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Paket"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="Paket" */
    IF EXISTS (SELECT * FROM deleted,Paket
      WHERE
        /* %JoinFKPK(deleted,Paket," = "," AND") */
        deleted.Paket = Paket.ID AND
        NOT EXISTS (
          SELECT * FROM ZahtevZaPrevozom
          WHERE
            /* %JoinFKPK(ZahtevZaPrevozom,Paket," = "," AND") */
            ZahtevZaPrevozom.Paket = Paket.ID
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ZahtevZaPrevozom because Paket exists.'
      GOTO error
    END

    /* erwin Builtin Trigger */
    /* Korisnik  ZahtevZaPrevozom on child delete no action */
    /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="Korisnik" */
    IF EXISTS (SELECT * FROM deleted,Korisnik
      WHERE
        /* %JoinFKPK(deleted,Korisnik," = "," AND") */
        deleted.Korisnik = Korisnik.KorisnickoIme AND
        NOT EXISTS (
          SELECT * FROM ZahtevZaPrevozom
          WHERE
            /* %JoinFKPK(ZahtevZaPrevozom,Korisnik," = "," AND") */
            ZahtevZaPrevozom.Korisnik = Korisnik.KorisnickoIme
        )
    )
    BEGIN
      SELECT @errno  = 30010,
             @errmsg = 'Cannot delete last ZahtevZaPrevozom because Korisnik exists.'
      GOTO error
    END


    /* erwin Builtin Trigger */
    RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


CREATE TRIGGER tU_ZahtevZaPrevozom ON ZahtevZaPrevozom FOR UPDATE AS
/* erwin Builtin Trigger */
/* UPDATE trigger on ZahtevZaPrevozom */
BEGIN
  DECLARE  @numrows int,
           @nullcnt int,
           @validcnt int,
           @insKorisnik Varchar100, 
           @insPaket ID,
           @errno   int,
           @severity int,
           @state    int,
           @errmsg  varchar(255)

  SELECT @numrows = @@rowcount
  /* erwin Builtin Trigger */
  /* ZahtevZaPrevozom  OdobrenaPonuda on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="000884bd", PARENT_OWNER="", PARENT_TABLE="ZahtevZaPrevozom"
    CHILD_OWNER="", CHILD_TABLE="OdobrenaPonuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_34", FK_COLUMNS="Korisnik""Paket" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Korisnik) OR
    UPDATE(Paket)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insKorisnik = inserted.Korisnik, 
             @insPaket = inserted.Paket
        FROM inserted
      UPDATE OdobrenaPonuda
      SET
        /*  %JoinFKPK(OdobrenaPonuda,@ins," = ",",") */
        OdobrenaPonuda.Korisnik = @insKorisnik,
        OdobrenaPonuda.Paket = @insPaket
      FROM OdobrenaPonuda,inserted,deleted
      WHERE
        /*  %JoinFKPK(OdobrenaPonuda,deleted," = "," AND") */
        OdobrenaPonuda.Korisnik = deleted.Korisnik AND
        OdobrenaPonuda.Paket = deleted.Paket
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade ZahtevZaPrevozom update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* ZahtevZaPrevozom  Ponuda on parent update cascade */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="ZahtevZaPrevozom"
    CHILD_OWNER="", CHILD_TABLE="Ponuda"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_32", FK_COLUMNS="Korisnik""Paket" */
  IF
    /* %ParentPK(" OR",UPDATE) */
    UPDATE(Korisnik) OR
    UPDATE(Paket)
  BEGIN
    IF @numrows = 1
    BEGIN
      SELECT @insKorisnik = inserted.Korisnik, 
             @insPaket = inserted.Paket
        FROM inserted
      UPDATE Ponuda
      SET
        /*  %JoinFKPK(Ponuda,@ins," = ",",") */
        Ponuda.Korisnik = @insKorisnik,
        Ponuda.Paket = @insPaket
      FROM Ponuda,inserted,deleted
      WHERE
        /*  %JoinFKPK(Ponuda,deleted," = "," AND") */
        Ponuda.Korisnik = deleted.Korisnik AND
        Ponuda.Paket = deleted.Paket
    END
    ELSE
    BEGIN
      SELECT @errno = 30006,
             @errmsg = 'Cannot cascade ZahtevZaPrevozom update because more than one row has been affected.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Opstina  ZahtevZaPrevozom on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_13", FK_COLUMNS="OpstinaDO" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(OpstinaDO)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Opstina
        WHERE
          /* %JoinFKPK(inserted,Opstina) */
          inserted.OpstinaDO = Opstina.ID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ZahtevZaPrevozom because Opstina does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Opstina  ZahtevZaPrevozom on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Opstina"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_11", FK_COLUMNS="OpstinaOD" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(OpstinaOD)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Opstina
        WHERE
          /* %JoinFKPK(inserted,Opstina) */
          inserted.OpstinaOD = Opstina.ID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ZahtevZaPrevozom because Opstina does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Paket  ZahtevZaPrevozom on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Paket"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_10", FK_COLUMNS="Paket" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Paket)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Paket
        WHERE
          /* %JoinFKPK(inserted,Paket) */
          inserted.Paket = Paket.ID
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ZahtevZaPrevozom because Paket does not exist.'
      GOTO error
    END
  END

  /* erwin Builtin Trigger */
  /* Korisnik  ZahtevZaPrevozom on child update no action */
  /* ERWIN_RELATION:CHECKSUM="00000000", PARENT_OWNER="", PARENT_TABLE="Korisnik"
    CHILD_OWNER="", CHILD_TABLE="ZahtevZaPrevozom"
    P2C_VERB_PHRASE="", C2P_VERB_PHRASE="", 
    FK_CONSTRAINT="R_9", FK_COLUMNS="Korisnik" */
  IF
    /* %ChildFK(" OR",UPDATE) */
    UPDATE(Korisnik)
  BEGIN
    SELECT @nullcnt = 0
    SELECT @validcnt = count(*)
      FROM inserted,Korisnik
        WHERE
          /* %JoinFKPK(inserted,Korisnik) */
          inserted.Korisnik = Korisnik.KorisnickoIme
    /* %NotnullFK(inserted," IS NULL","select @nullcnt = count(*) from inserted where"," AND") */
    
    IF @validcnt + @nullcnt != @numrows
    BEGIN
      SELECT @errno  = 30007,
             @errmsg = 'Cannot update ZahtevZaPrevozom because Korisnik does not exist.'
      GOTO error
    END
  END


  /* erwin Builtin Trigger */
  RETURN
error:
   RAISERROR (@errmsg, -- Message text.
              @severity, -- Severity (0~25).
              @state) -- State (0~255).
    rollback transaction
END

go


