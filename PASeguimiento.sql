use BDAcademico
go

-- PA Seguimiento Academico
if OBJECT_ID('spSeguimientoAcademico') is not null
	drop proc spSeguimientoAcademico
go
create proc spSeguimientoAcademico
@Usuario varchar(50)
as
begin
	declare @CodAlumno char(5) 
	set @CodAlumno = (select CodAlumno from TAlumno where Usuario = @Usuario)
	select N.Semestre, N.CodAsignatura, A.Asignatura, N.Parcial1, N.Parcial2,N.NotaFinal
	from TNotas N inner join TAsignatura A on
		N.CodAsignatura = A.CodAsignatura
	where N.CodAlumno = @CodAlumno 
	order by N.Semestre DESC
end
go

exec spSeguimientoAcademico 'cuellar@hotmail.com'
go